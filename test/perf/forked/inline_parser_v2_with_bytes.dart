import 'dart:convert';
import 'dart:typed_data';

import 'package:cmark_gfm/cmark_gfm.dart';
import 'node2.dart';
import 'footnote_map2.dart';
import 'package:cmark_gfm/src/houdini/html_unescape.dart' as houdini;
import 'delimiter2.dart';
import 'package:cmark_gfm/src/inline/link_parsing.dart';
import 'package:cmark_gfm/src/inline/subject.dart';
import 'package:cmark_gfm/src/util/strbuf.dart';
import 'package:cmark_gfm/src/util/utf8.dart';


/// Optimized inline parser. Key changes vs V1:
/// 1. Fused main loop — scans for special chars inline instead of per-call dispatch
/// 2. Batched text accumulation — one utf8.decode per text run instead of per-fragment
/// 3. Removed redundant c < 256 check in special char scanning
class InlineParserV2 {
  InlineParserV2(
    this.refmap, {
    CmarkFootnoteMap2? footnoteMap,
    CmarkParserOptions parserOptions = const CmarkParserOptions(),
  })  : options = parserOptions,
        mathOptions = parserOptions.mathOptions,
        footnoteMap = footnoteMap ?? CmarkFootnoteMap2() {
    _subject = Subject(refmap: refmap, footnoteMap: CmarkFootnoteMap());
    if (!_initialized) {
      Subject.initSpecialChars();
      _initialized = true;
    }
    if (parserOptions.enableMath) {
      Subject.enableMathDelimiters();
    }
  }

  static bool _initialized = false;

  final CmarkReferenceMap refmap;
  final CmarkParserOptions options;
  final CmarkMathOptions mathOptions;
  final CmarkFootnoteMap2 footnoteMap;

  late final Subject _subject;

  Delimiter2? _lastDelim;
  Bracket2? _lastBracket;
  bool _noLinkOpeners = true;

  void reset() {
    _subject.reset();
    _lastDelim = null;
    _lastBracket = null;
    _noLinkOpeners = true;
  }

  void parseInlines(CmarkNode2 block) {
    if (block.type.isInline) return;
    if (!_containsInlines(block.type)) return;

    // Use byte path directly — skips StringBuffer.toString() + utf8.encode()
    final content = block.contentAsBytes;
    if (content.isEmpty) return;

    // Trim trailing whitespace
    var trimmedLen = content.length;
    while (trimmedLen > 0 &&
        (content[trimmedLen - 1] == 0x20 ||
            content[trimmedLen - 1] == 0x09 ||
            content[trimmedLen - 1] == 0x0A ||
            content[trimmedLen - 1] == 0x0D)) {
      trimmedLen--;
    }

    final trimmedInput = Uint8List.sublistView(content, 0, trimmedLen);
    final subj = _subject;
    subj.initialize(
      input: trimmedInput,
      line: block.startLine,
      blockOffset: block.startColumn - 1,
    );
    _lastDelim = null;
    _lastBracket = null;
    _noLinkOpeners = true;

    // ---- Fused main loop ----
    // Instead of calling _parseInline() per iteration (function call + switch),
    // scan for special chars inline and batch text runs.
    final input = subj.input;
    final len = input.length;
    final specials = Subject.specialChars;

    while (subj.pos < len) {
      // Scan ahead for next special char (inlined findSpecialChar, no c<256 check)
      final textStart = subj.pos;
      var n = textStart;
      var allAscii = true;
      while (n < len && !specials[input[n]]) {
        if (input[n] >= 0x80) allAscii = false;
        n++;
      }

      // Emit accumulated text as one node
      if (n > textStart) {
        subj.pos = n;
        var textEnd = n;
        // Trim trailing spaces before newline (like C version)
        if (n < len) {
          final next = input[n];
          if (next == 0x0A || next == 0x0D) {
            while (textEnd > textStart && input[textEnd - 1] == 0x20) {
              textEnd--;
            }
          }
        }
        final text = allAscii
            ? String.fromCharCodes(input, textStart, textEnd)
            : utf8.decode(Uint8List.sublistView(input, textStart, textEnd));
        final textNode = CmarkNode2(CmarkNodeType.text)
          ..setLiteral(text)
          ..startLine = subj.line
          ..endLine = subj.line
          ..startColumn = textStart + 1 + subj.columnOffset + subj.blockOffset
          ..endColumn = n + subj.columnOffset + subj.blockOffset;
        block.appendNewChild(textNode);
      }

      if (subj.pos >= len) break;

      // Handle the special char
      final c = input[subj.pos];
      CmarkNode2? newInl;

      if (options.enableMath && (c == 0x24 || c == 0x5C)) {
        newInl = _tryParseMath(subj, c);
      }

      if (newInl == null) {
        switch (c) {
          case 0x0D: // \r
          case 0x0A: // \n
            {
              final nlpos = subj.pos;
              if (input[subj.pos] == 0x0D) subj.pos++;
              if (subj.pos < len && input[subj.pos] == 0x0A) subj.pos++;
              subj.line++;
              subj.columnOffset = -subj.pos;
              // skipSpaces inline
              while (subj.pos < len && (input[subj.pos] == 0x20 || input[subj.pos] == 0x09)) subj.pos++;
              newInl = (nlpos > 1 && input[nlpos - 1] == 0x20 && input[nlpos - 2] == 0x20)
                  ? CmarkNode2(CmarkNodeType.linebreak)
                  : CmarkNode2(CmarkNodeType.softbreak);
            }
            break;
          case 0x60: // `
            newInl = _handleBackticks(subj);
            break;
          case 0x5C: // backslash
            newInl = _handleBackslash(subj);
            break;
          case 0x26: // &
            newInl = _handleEntity(subj);
            break;
          case 0x3C: // <
            newInl = _handlePointyBrace(subj);
            break;
          case 0x2A: // *
          case 0x5F: // _
          case 0x7E: // ~
            newInl = _handleDelim(subj, c);
            break;
          case 0x5B: // [
            subj.advance();
            newInl = _makeStr(subj, subj.pos - 1, subj.pos - 1, '[');
            _pushBracket(subj, false, newInl);
            break;
          case 0x5D: // ]
            newInl = _handleCloseBracket(subj, block);
            break;
          case 0x21: // !
            subj.advance();
            if (subj.peekChar() == 0x5B && subj.peekCharN(1) != 0x5E) {
              subj.advance();
              newInl = _makeStr(subj, subj.pos - 2, subj.pos - 1, '![');
              _pushBracket(subj, true, newInl);
            } else {
              newInl = _makeStr(subj, subj.pos - 1, subj.pos - 1, '!');
            }
            break;
          default:
            // Shouldn't reach here — specials table caught it but switch didn't.
            // Just advance past it as text.
            subj.advance();
            newInl = _makeStr(subj, subj.pos - 1, subj.pos - 1,
                String.fromCharCode(c));
            break;
        }
      }

      if (newInl != null) {
        block.appendChild(newInl);
      }
    }

    _processEmphasis(subj, 0);

    while (_lastDelim != null) {
      _removeDelimiter(_lastDelim!);
    }
    while (_lastBracket != null) {
      _popBracket();
    }
  }

  // ---- Everything below is identical to V1 except for the removed parseInline/findSpecialChar calls ----

  CmarkNode2? _tryParseMath(Subject subj, int leadingChar) {
    if (leadingChar == 0x5C && mathOptions.allowBracketDelimiters) {
      final next = subj.peekCharN(1);
      if (next == 0x28 || next == 0x5B) {
        return _parseBracketMath(subj, display: next == 0x5B);
      }
      return null;
    }

    if (leadingChar == 0x24) {
      if (mathOptions.allowBlockDoubleDollar && subj.peekCharN(1) == 0x24) {
        return _parseDoubleDollarMath(subj);
      }
      if (mathOptions.allowSingleDollar) {
        return _parseSingleDollarMath(subj);
      }
    }

    return null;
  }

  CmarkNode2? _parseBracketMath(Subject subj, {required bool display}) {
    final start = subj.pos;
    subj.advance();
    subj.advance();

    final closingChar = display ? 0x5D : 0x29;
    final literal = _scanToEscapedDelimiter(subj, closingChar);
    if (literal == null) {
      subj.pos = start;
      return null;
    }

    final normalized = _normalizeInlineMathLiteral(literal);
    if (normalized.isEmpty) {
      subj.pos = start;
      return null;
    }

    final end = subj.pos;
    return _buildInlineMathNode(
      subj: subj, start: start, end: end, literal: normalized,
      display: display,
      opening: display ? r'\[' : r'\(',
      closing: display ? r'\]' : r'\)',
    );
  }

  CmarkNode2? _parseDoubleDollarMath(Subject subj) {
    final start = subj.pos;
    subj.advance();
    subj.advance();
    final contentStart = subj.pos;
    while (!subj.isEof()) {
      final ch = subj.peekChar();
      if (ch == 0x0A || ch == 0x0D) { subj.pos = start; return null; }
      if (ch == 0x24 && subj.peekCharN(1) == 0x24) {
        final bytes = Uint8List.sublistView(subj.input, contentStart, subj.pos);
        final literal = utf8.decode(bytes, allowMalformed: true);
        final normalized = _normalizeInlineMathLiteral(literal);
        if (normalized.isEmpty) { subj.pos = start; return null; }
        subj.advance(); subj.advance();
        return _buildInlineMathNode(
          subj: subj, start: start, end: subj.pos, literal: normalized,
          display: true, opening: r'$$', closing: r'$$',
        );
      }
      subj.advance();
    }
    subj.pos = start;
    return null;
  }

  CmarkNode2? _parseSingleDollarMath(Subject subj) {
    final start = subj.pos;
    if (start > 0) {
      final before = subj.peekAt(start - 1);
      if (_isWordChar(before)) return null;
    }
    subj.advance();
    final firstContentChar = subj.peekChar();
    if (firstContentChar == 0 || firstContentChar == 0x20 ||
        firstContentChar == 0x09 || firstContentChar == 0x0A ||
        firstContentChar == 0x0D || firstContentChar == 0x24) {
      subj.pos = start; return null;
    }
    final startsWithDigit = _isDigit(firstContentChar);
    final contentStart = subj.pos;
    var seenWhitespace = false;
    var hasEarlyMathIndicator = false;
    var hasOperator = false;
    while (!subj.isEof()) {
      final ch = subj.peekChar();
      if (ch == 0x20 || ch == 0x09) seenWhitespace = true;
      if (!seenWhitespace && (_isLetter(ch) || ch == 0x5C || ch == 0x7B || ch == 0x7D)) {
        hasEarlyMathIndicator = true;
      }
      if (ch == 0x3D || ch == 0x2B || ch == 0x3C || ch == 0x3E) hasOperator = true;
      if (ch == 0x0A || ch == 0x0D) { subj.pos = start; return null; }
      if (ch == 0x24) {
        final contentEnd = subj.pos;
        if (contentEnd > contentStart) {
          final before = subj.peekAt(contentEnd - 1);
          if (before == 0x20 || before == 0x09 || before == 0x2F) { subj.advance(); continue; }
        } else { subj.pos = start; return null; }
        final after = subj.peekCharN(1);
        if (_isDigit(after)) { subj.advance(); continue; }
        if (startsWithDigit && seenWhitespace && !hasEarlyMathIndicator && !hasOperator) {
          subj.advance(); continue;
        }
        final bytes = Uint8List.sublistView(subj.input, contentStart, contentEnd);
        final literal = utf8.decode(bytes, allowMalformed: true);
        final normalized = _normalizeInlineMathLiteral(literal);
        if (normalized.isEmpty) { subj.pos = start; return null; }
        subj.advance();
        return _buildInlineMathNode(
          subj: subj, start: start, end: subj.pos, literal: normalized,
          display: false, opening: r'$', closing: r'$',
        );
      }
      subj.advance();
    }
    subj.pos = start;
    return null;
  }

  bool _isWordChar(int ch) => (ch >= 0x30 && ch <= 0x39) || (ch >= 0x41 && ch <= 0x5A) || (ch >= 0x61 && ch <= 0x7A);
  bool _isDigit(int ch) => ch >= 0x30 && ch <= 0x39;
  bool _isLetter(int ch) => (ch >= 0x41 && ch <= 0x5A) || (ch >= 0x61 && ch <= 0x7A);

  String? _scanToEscapedDelimiter(Subject subj, int closingChar) {
    final start = subj.pos;
    while (!subj.isEof()) {
      final current = subj.peekChar();
      if (current == 0x5C && subj.peekCharN(1) == closingChar) {
        final bytes = Uint8List.sublistView(subj.input, start, subj.pos);
        final literal = utf8.decode(bytes, allowMalformed: true);
        subj.advance(); subj.advance();
        return literal;
      }
      if (current == 0x0A || current == 0x0D) { subj.pos = start; return null; }
      subj.advance();
    }
    subj.pos = start;
    return null;
  }

  CmarkNode2 _buildInlineMathNode({
    required Subject subj, required int start, required int end,
    required String literal, required bool display,
    required String opening, required String closing,
  }) {
    final raw = utf8.decode(Uint8List.sublistView(subj.input, start, end), allowMalformed: true);
    final node = CmarkNode2(CmarkNodeType.math)
      ..content.write(raw)
      ..startLine = subj.line
      ..endLine = subj.line
      ..startColumn = start + 1 + subj.columnOffset + subj.blockOffset
      ..endColumn = end + subj.columnOffset + subj.blockOffset;
    node.mathData
      ..literal = literal
      ..display = display
      ..openingDelimiter = opening
      ..closingDelimiter = closing;
    return node;
  }

  String _normalizeInlineMathLiteral(String literal) => literal.trim();

  CmarkNode2 _makeStr(Subject subj, int startCol, int endCol, String text) {
    final node = CmarkNode2(CmarkNodeType.text)
      ..setLiteral(text)
      ..startLine = subj.line
      ..endLine = subj.line
      ..startColumn = startCol + 1 + subj.columnOffset + subj.blockOffset
      ..endColumn = endCol + 1 + subj.columnOffset + subj.blockOffset;
    return node;
  }

  CmarkNode2 _handleNewline(Subject subj) {
    final nlpos = subj.pos;
    if (subj.peekAt(subj.pos) == 0x0D) subj.advance();
    if (subj.peekAt(subj.pos) == 0x0A) subj.advance();
    subj.line++;
    subj.columnOffset = -subj.pos;
    subj.skipSpaces();
    if (nlpos > 1 && subj.peekAt(nlpos - 1) == 0x20 && subj.peekAt(nlpos - 2) == 0x20) {
      return CmarkNode2(CmarkNodeType.linebreak);
    }
    return CmarkNode2(CmarkNodeType.softbreak);
  }

  CmarkNode2 _handleBackticks(Subject subj) {
    final startpos = subj.pos;
    var numticks = 0;
    while (subj.peekChar() == 0x60) { subj.advance(); numticks++; }
    final afterTicksPos = subj.pos;
    final endpos = _scanToClosingBackticks(subj, numticks);
    if (endpos == 0) {
      subj.pos = afterTicksPos;
      return _makeStr(subj, startpos, afterTicksPos - 1, '`' * numticks);
    } else {
      final codeBytes = Uint8List.sublistView(subj.input, startpos + numticks, endpos - numticks);
      var code = utf8.decode(codeBytes, allowMalformed: true);
      code = code.replaceAll(RegExp(r'[\r\n]+'), ' ');
      if (code.isNotEmpty && code.trim().isNotEmpty) {
        if (code.startsWith(' ') && code.endsWith(' ') && code.length > 2) {
          code = code.substring(1, code.length - 1);
        }
      }
      return CmarkNode2(CmarkNodeType.code)
        ..content.write(code)
        ..startLine = subj.line ..endLine = subj.line
        ..startColumn = startpos + 1 ..endColumn = endpos - 1;
    }
  }

  int _scanToClosingBackticks(Subject subj, int openLen) {
    if (openLen > maxBackticks) return 0;
    if (subj.scannedForBackticks && subj.backticks[openLen] <= subj.pos) return 0;
    while (!subj.isEof()) {
      while (subj.peekChar() != 0x60 && !subj.isEof()) subj.advance();
      if (subj.isEof()) break;
      var numticks = 0;
      while (subj.peekChar() == 0x60) { subj.advance(); numticks++; }
      if (numticks <= maxBackticks) subj.recordBacktickRun(numticks, subj.pos - numticks);
      if (numticks == openLen) return subj.pos;
    }
    subj.scannedForBackticks = true;
    return 0;
  }

  CmarkNode2 _handleBackslash(Subject subj) {
    subj.advance();
    final nextchar = subj.peekChar();
    if (_isPunct(nextchar)) {
      subj.advance();
      return _makeStr(subj, subj.pos - 2, subj.pos - 1, String.fromCharCode(nextchar));
    } else if (!subj.isEof() && subj.skipLineEnd()) {
      return CmarkNode2(CmarkNodeType.linebreak);
    }
    return _makeStr(subj, subj.pos - 1, subj.pos - 1, '\\');
  }

  CmarkNode2 _handleEntity(Subject subj) {
    subj.advance();
    final buf = CmarkStrbuf();
    final consumed = houdini.HoudiniHtmlUnescape.unescapeEntity(buf, subj.input, subj.pos);
    if (consumed == 0) return _makeStr(subj, subj.pos - 1, subj.pos - 1, '&');
    subj.pos += consumed;
    final output = utf8.decode(buf.detach(), allowMalformed: true);
    return _makeStr(subj, (subj.pos - 1 - consumed), subj.pos - 1, output);
  }

  CmarkNode2 _handlePointyBrace(Subject subj) {
    subj.advance();
    final tagStart = subj.pos - 1;
    final urlMatch = _scanAutolinkUri(subj.input, subj.pos);
    if (urlMatch > 0) {
      try {
        final url = utf8.decode(Uint8List.sublistView(subj.input, subj.pos, subj.pos + urlMatch - 1));
        subj.pos += urlMatch;
        return _makeAutolink(subj, subj.pos - 1 - urlMatch, subj.pos - 1, url, false);
      } catch (_) { return _makeStr(subj, subj.pos - 1, subj.pos - 1, '<'); }
    }
    final emailMatch = _scanAutolinkEmail(subj.input, subj.pos);
    if (emailMatch > 0) {
      try {
        final email = utf8.decode(Uint8List.sublistView(subj.input, subj.pos, subj.pos + emailMatch - 1));
        subj.pos += emailMatch;
        return _makeAutolink(subj, subj.pos - 1 - emailMatch, subj.pos - 1, email, true);
      } catch (_) { return _makeStr(subj, subj.pos - 1, subj.pos - 1, '<'); }
    }
    final htmlLen = _scanHtmlTag(subj.input, tagStart);
    if (htmlLen > 0) {
      final end = tagStart + htmlLen;
      final raw = utf8.decode(Uint8List.sublistView(subj.input, tagStart, end), allowMalformed: true);
      subj.pos = end;
      return CmarkNode2(CmarkNodeType.htmlInline)
        ..content.write(raw)
        ..startLine = subj.line ..endLine = subj.line
        ..startColumn = tagStart + 1 + subj.columnOffset + subj.blockOffset
        ..endColumn = end + subj.columnOffset + subj.blockOffset;
    }
    return _makeStr(subj, subj.pos - 1, subj.pos - 1, '<');
  }

  static final _autolinkUriRe = RegExp(r'^[A-Za-z][A-Za-z0-9.+-]{1,31}:[^\x00-\x20<>]*>');
  static final _autolinkEmailRe = RegExp(
    r'^[a-zA-Z0-9.!#$%&' "'" r'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*>',
  );

  int _scanAutolinkUri(Uint8List data, int pos) {
    if (pos >= data.length) return 0;
    // URI autolink must start with [A-Za-z]
    final first = data[pos];
    if (!((first >= 0x41 && first <= 0x5A) || (first >= 0x61 && first <= 0x7A))) return 0;
    final remaining = utf8.decode(Uint8List.sublistView(data, pos), allowMalformed: true);
    return _autolinkUriRe.firstMatch(remaining)?.group(0)?.length ?? 0;
  }

  int _scanAutolinkEmail(Uint8List data, int pos) {
    if (pos >= data.length) return 0;
    // Email must start with [a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]
    final first = data[pos];
    if (first < 0x21 || first > 0x7E) return 0;
    final remaining = utf8.decode(Uint8List.sublistView(data, pos), allowMalformed: true);
    return _autolinkEmailRe.firstMatch(remaining)?.group(0)?.length ?? 0;
  }

  CmarkNode2 _makeAutolink(Subject subj, int startCol, int endCol, String url, bool isEmail) {
    final link = CmarkNode2(CmarkNodeType.link);
    var cleanedUrl = url.trim();
    if (cleanedUrl.isNotEmpty) {
      if (isEmail) cleanedUrl = 'mailto:$cleanedUrl';
      final buf = CmarkStrbuf();
      houdini.HoudiniHtmlUnescape.unescape(buf, utf8.encode(cleanedUrl));
      cleanedUrl = utf8.decode(buf.detach(), allowMalformed: true);
    }
    link.linkData.url = cleanedUrl;
    link.linkData.title = '';
    link.startLine = link.endLine = subj.line;
    link.startColumn = startCol + 1;
    link.endColumn = endCol + 1;
    final textBuf = CmarkStrbuf();
    houdini.HoudiniHtmlUnescape.unescape(textBuf, utf8.encode(url));
    final textContent = utf8.decode(textBuf.detach(), allowMalformed: true);
    link.appendChild(CmarkNode2(CmarkNodeType.text)..content.write(textContent));
    return link;
  }

  CmarkNode2 _handleDelim(Subject subj, int c) {
    final canOpen = <bool>[false];
    final canClose = <bool>[false];
    final numDelims = _scanDelims(subj, c, canOpen, canClose);
    final delims = String.fromCharCodes(List.filled(numDelims, c));
    final inlText = _makeStr(subj, subj.pos - numDelims, subj.pos - 1, delims);
    if (canOpen[0] || canClose[0]) _pushDelimiter(subj, c, canOpen[0], canClose[0], inlText);
    return inlText;
  }

  int _codePointAt(Uint8List data, int pos) {
    final first = data[pos];
    if (first < 0x80) return first;
    if ((first & 0xE0) == 0xC0 && pos + 1 < data.length) return ((first & 0x1F) << 6) | (data[pos + 1] & 0x3F);
    if ((first & 0xF0) == 0xE0 && pos + 2 < data.length) return ((first & 0x0F) << 12) | ((data[pos + 1] & 0x3F) << 6) | (data[pos + 2] & 0x3F);
    if ((first & 0xF8) == 0xF0 && pos + 3 < data.length) return ((first & 0x07) << 18) | ((data[pos + 1] & 0x3F) << 12) | ((data[pos + 2] & 0x3F) << 6) | (data[pos + 3] & 0x3F);
    return first;
  }

  int _scanDelims(Subject subj, int c, List<bool> canOpen, List<bool> canClose) {
    var numDelims = 0;
    var beforeChar = 0x0A;
    var afterChar = 0x0A;
    final startPos = subj.pos;
    if (startPos > 0) {
      var beforePos = startPos - 1;
      while (beforePos > 0 && (subj.input[beforePos] >> 6) == 2) beforePos--;
      beforeChar = _codePointAt(subj.input, beforePos);
    }
    while (subj.peekChar() == c) { numDelims++; subj.advance(); }
    if (subj.pos < subj.input.length) afterChar = _codePointAt(subj.input, subj.pos);
    final leftFlanking = numDelims > 0 && !_isSpace(afterChar) && (!_isUnicodePunct(afterChar) || _isSpace(beforeChar) || _isUnicodePunct(beforeChar));
    final rightFlanking = numDelims > 0 && !_isSpace(beforeChar) && (!_isUnicodePunct(beforeChar) || _isSpace(afterChar) || _isUnicodePunct(afterChar));
    if (c == 0x5F) {
      canOpen[0] = leftFlanking && (!rightFlanking || _isPunct(beforeChar));
      canClose[0] = rightFlanking && (!leftFlanking || _isPunct(afterChar));
    } else {
      canOpen[0] = leftFlanking;
      canClose[0] = rightFlanking;
    }
    return numDelims;
  }

  // Flat array for _processEmphasis: 3 length-mod-3 slots × 3 delim chars.
  // charIdx: * → 0, _ → 1, ~ → 2
  static int _charIdx(int c) => c == 0x2A ? 0 : (c == 0x5F ? 1 : 2);

  void _processEmphasis(Subject subj, int stackBottom) {
    // 9-element flat array replaces Map<int, Map<int, int>>
    final ob = List<int>.filled(9, 0);
    for (var i = 0; i < 3; i++) {
      ob[i * 3 + 0] = stackBottom; // *
      ob[i * 3 + 1] = stackBottom; // _
      ob[i * 3 + 2] = 0;            // ~
    }
    Delimiter2? candidate = _lastDelim;
    var closer = candidate;
    while (candidate != null && candidate.position >= stackBottom) {
      closer = candidate;
      candidate = candidate.previous;
    }
    while (closer != null) {
      if (closer.canClose) {
        var opener = closer.previous;
        var openerFound = false;
        final bottomPos = ob[(closer.length % 3) * 3 + _charIdx(closer.delimChar)];
        while (opener != null && opener.position >= stackBottom && opener.position >= bottomPos) {
          if (opener.canOpen && opener.delimChar == closer.delimChar) {
            if (!(closer.canOpen || opener.canClose) || closer.length % 3 == 0 || (opener.length + closer.length) % 3 != 0) {
              openerFound = true; break;
            }
          }
          opener = opener.previous;
        }
        final oldCloser = closer;
        if (openerFound && opener != null) {
          closer = _insertEmph(subj, opener, closer);
        } else {
          closer = closer.next;
        }
        if (!openerFound) {
          ob[(oldCloser.length % 3) * 3 + _charIdx(oldCloser.delimChar)] = oldCloser.position;
          if (!oldCloser.canOpen && stackBottom == 0) _removeDelimiter(oldCloser);
        }
      } else {
        closer = closer.next;
      }
    }
    while (_lastDelim != null && _lastDelim!.position >= stackBottom) {
      _removeDelimiter(_lastDelim!);
    }
  }

  Delimiter2? _insertEmph(Subject subj, Delimiter2 opener, Delimiter2 closer) {
    final openerInl = opener.inlText;
    final closerInl = closer.inlText;
    var openerNumChars = opener.length;
    var closerNumChars = closer.length;
    if (opener.delimChar == 0x7E) {
      final minTildes = options.singleTildeStrikethrough ? 1 : 2;
      if (openerNumChars > 2 || closerNumChars > 2 || openerNumChars < minTildes || closerNumChars < minTildes || openerNumChars != closerNumChars) {
        return closer.next;
      }
    }
    final useDelims = (opener.delimChar == 0x7E) ? openerNumChars : ((closerNumChars >= 2 && openerNumChars >= 2) ? 2 : 1);
    openerNumChars -= useDelims;
    closerNumChars -= useDelims;
    opener.length = openerNumChars;
    closer.length = closerNumChars;
    final openerText = openerInl.content.toString();
    openerInl.content.clear();
    if (openerNumChars > 0) openerInl.content.write(openerText.substring(0, openerNumChars));
    final closerText = closerInl.content.toString();
    closerInl.content.clear();
    if (closerNumChars > 0) closerInl.content.write(closerText.substring(0, closerNumChars));
    var delim = closer.previous;
    while (delim != null && delim != opener) { final tmp = delim.previous; _removeDelimiter(delim); delim = tmp; }
    final emphType = (opener.delimChar == 0x7E) ? CmarkNodeType.strikethrough : (useDelims == 1 ? CmarkNodeType.emph : CmarkNodeType.strong);
    final emph = CmarkNode2(emphType);
    var tmp = openerInl.next;
    while (tmp != null && tmp != closerInl) { final tmpNext = tmp.next; tmp.unlink(); emph.appendChild(tmp); tmp = tmpNext; }
    openerInl.parent?.insertAfter(openerInl, emph);
    emph.startLine = openerInl.startLine; emph.endLine = closerInl.endLine;
    emph.startColumn = openerInl.startColumn; emph.endColumn = closerInl.endColumn;
    if (openerNumChars == 0) { openerInl.unlink(); _removeDelimiter(opener); }
    Delimiter2? result;
    if (closerNumChars == 0) { closerInl.unlink(); result = closer.next; _removeDelimiter(closer); } else { result = closer; }
    return result;
  }

  CmarkNode2? _handleCloseBracket(Subject subj, CmarkNode2 parent) {
    subj.advance();
    final initialPos = subj.pos;
    final opener = _lastBracket;
    if (opener == null) return _makeStr(subj, subj.pos - 1, subj.pos - 1, ']');
    final isImage = opener.image;
    if (!isImage && _noLinkOpeners) { _popBracket(); return _makeStr(subj, subj.pos - 1, subj.pos - 1, ']'); }
    final afterLinkTextPos = subj.pos;
    if (subj.peekChar() == 0x28) {
      final sps = subj.scanSpacecharsAt(subj.pos + 1);
      if (sps >= 0) {
        final urlResult = LinkUrlResult();
        final n = scanLinkUrl(subj.input, subj.pos + 1 + sps, urlResult);
        if (n >= 0) {
          final endurl = subj.pos + 1 + sps + n;
          final starttitle = endurl + subj.scanSpacecharsAt(endurl);
          final endtitle = (starttitle == endurl) ? starttitle : starttitle + _scanLinkTitleAt(subj.input, starttitle);
          final endall = endtitle + subj.scanSpacecharsAt(endtitle);
          if (subj.peekAt(endall) == 0x29) {
            subj.pos = endall + 1;
            var titleStr = '';
            if (endtitle > starttitle) titleStr = utf8.decode(Uint8List.sublistView(subj.input, starttitle, endtitle), allowMalformed: true);
            return _createLink(subj, opener, isImage, cleanUrl(urlResult.url), cleanTitle(titleStr), afterLinkTextPos);
          } else { subj.pos = afterLinkTextPos; }
        } else { subj.pos = afterLinkTextPos; }
      }
    }
    final labelResult = LinkLabelResult();
    final foundLabel = linkLabel(subj.input, subj.pos, labelResult);
    String refLabel;
    if (foundLabel && labelResult.label.isNotEmpty) {
      refLabel = labelResult.label; subj.pos = labelResult.endPos;
    } else if (foundLabel) {
      refLabel = utf8.decode(Uint8List.sublistView(subj.input, opener.position, initialPos - 1), allowMalformed: true).trim();
      subj.pos = labelResult.endPos;
    } else if (!opener.bracketAfter) {
      refLabel = utf8.decode(Uint8List.sublistView(subj.input, opener.position, initialPos - 1), allowMalformed: true).trim();
    } else { _popBracket(); subj.pos = initialPos; return _makeStr(subj, subj.pos - 1, subj.pos - 1, ']'); }
    final ref = refmap.size == 0 ? null : refmap.lookupString(refLabel);
    if (ref != null) {
      return _createLink(subj, opener, isImage, utf8.decode(ref.url.data, allowMalformed: true), utf8.decode(ref.title.data, allowMalformed: true), afterLinkTextPos);
    }
    final nextNode = opener.inlText.next;
    if (nextNode != null && nextNode.type == CmarkNodeType.text) {
      final literal = nextNode.content.toString();
      if (literal.isNotEmpty && literal.startsWith('^') && (literal.length > 1 || nextNode.next != null)) {
        subj.pos = initialPos;
        final fnref = CmarkNode2(CmarkNodeType.footnoteReference);
        final fnrefEndColumn = subj.pos + subj.columnOffset + subj.blockOffset;
        final fnrefStartColumn = opener.inlText.startColumn;
        if (refLabel.length > 1) { fnref.content.write(refLabel.substring(1)); }
        else if (literal.length > 1) { fnref.content.write(literal.substring(1)); }
        fnref.startLine = fnref.endLine = subj.line;
        fnref.startColumn = fnrefStartColumn; fnref.endColumn = fnrefEndColumn;
        opener.inlText.parent?.insertAfter(opener.inlText.previous ?? opener.inlText, fnref);
        _processEmphasis(subj, opener.position);
        CmarkNode2? current = opener.inlText.next;
        while (current != null) { final next = current.next; current.unlink(); current = next; }
        opener.inlText.unlink(); _popBracket();
        return null;
      }
    }
    _popBracket(); subj.pos = initialPos;
    return _makeStr(subj, subj.pos - 1, subj.pos - 1, ']');
  }

  CmarkNode2? _createLink(Subject subj, Bracket2 opener, bool isImage, String url, String title, int afterLinkTextPos) {
    final link = CmarkNode2(isImage ? CmarkNodeType.image : CmarkNodeType.link);
    link.linkData..url = url..title = title;
    link.startLine = link.endLine = subj.line;
    link.startColumn = opener.inlText.startColumn;
    link.endColumn = subj.pos + subj.columnOffset + subj.blockOffset;
    final openerParent = opener.inlText.parent;
    if (openerParent == null) return null;
    if (opener.inlText.previous != null) { openerParent.insertAfter(opener.inlText.previous!, link); }
    else { openerParent.prependChild(link); }
    CmarkNode2? tmp = opener.inlText.next;
    while (tmp != null) { final tmpNext = tmp.next; tmp.unlink(); link.appendChild(tmp); tmp = tmpNext; }
    opener.inlText.unlink();
    _processEmphasis(subj, opener.position); _popBracket();
    if (!isImage) _noLinkOpeners = true;
    return null;
  }

  void _pushDelimiter(Subject subj, int c, bool canOpen, bool canClose, CmarkNode2 inlText) {
    final delim = Delimiter2(delimChar: c, canOpen: canOpen, canClose: canClose, inlText: inlText, position: subj.pos, length: inlText.content.length, previous: _lastDelim);
    if (delim.previous != null) delim.previous!.next = delim;
    _lastDelim = delim;
  }

  void _removeDelimiter(Delimiter2 delim) {
    if (delim.next == null) { _lastDelim = delim.previous; } else { delim.next!.previous = delim.previous; }
    if (delim.previous != null) delim.previous!.next = delim.next;
  }

  void _pushBracket(Subject subj, bool image, CmarkNode2 inlText) {
    final b = Bracket2(image: image, inlText: inlText, position: subj.pos, previous: _lastBracket);
    if (_lastBracket != null) { _lastBracket!.bracketAfter = true; b.inBracketImage0 = _lastBracket!.inBracketImage0; b.inBracketImage1 = _lastBracket!.inBracketImage1; }
    if (image) { b.inBracketImage1 = true; } else { b.inBracketImage0 = true; }
    _lastBracket = b;
    if (!image) _noLinkOpeners = false;
  }

  void _popBracket() { if (_lastBracket != null) _lastBracket = _lastBracket!.previous; }

  bool _containsInlines(CmarkNodeType type) {
    switch (type) {
      case CmarkNodeType.paragraph: case CmarkNodeType.heading: case CmarkNodeType.tableCell: return true;
      default: return false;
    }
  }

  int _scanLinkTitleAt(Uint8List input, int offset) {
    final result = LinkTitleResult();
    return scanLinkTitle(input, offset, result);
  }

  bool _isSpace(int ch) => ch == 0x20 || ch == 0x09 || ch == 0x0A || ch == 0x0B || ch == 0x0C || ch == 0x0D || ch == 0xA0;
  bool _isPunct(int ch) => (ch >= 0x21 && ch <= 0x2F) || (ch >= 0x3A && ch <= 0x40) || (ch >= 0x5B && ch <= 0x60) || (ch >= 0x7B && ch <= 0x7E);
  bool _isUnicodePunct(int ch) => CmarkUtf8.isPunctuation(ch);
}

int _scanHtmlTag(Uint8List data, int offset) {
  final len = data.length;
  if (offset >= len || data[offset] != 0x3C) return 0;
  var i = offset + 1;
  if (i >= len) return 0;
  final ch = data[i];
  if (ch == 0x21) {
    if (i + 2 < len && data[i + 1] == 0x2D && data[i + 2] == 0x2D) {
      var j = i + 1;
      while (j + 2 < len) { if (data[j] == 0x2D && data[j + 1] == 0x2D && data[j + 2] == 0x3E) return j + 3 - offset; j++; }
      return 0;
    }
    if (i + 7 < len && data[i + 1] == 0x5B && data[i + 2] == 0x43 && data[i + 3] == 0x44 && data[i + 4] == 0x41 && data[i + 5] == 0x54 && data[i + 6] == 0x41 && data[i + 7] == 0x5B) {
      var j = i + 8;
      while (j + 2 < len) { if (data[j] == 0x5D && data[j + 1] == 0x5D && data[j + 2] == 0x3E) return j + 3 - offset; j++; }
      return 0;
    }
    var j = i + 1; while (j < len && data[j] != 0x3E) j++;
    if (j == len) return 0; return j + 1 - offset;
  } else if (ch == 0x3F) {
    var j = i + 1; while (j + 1 < len) { if (data[j] == 0x3F && data[j + 1] == 0x3E) return j + 2 - offset; j++; } return 0;
  } else {
    var j = i; var isClosing = false;
    if (data[j] == 0x2F) { isClosing = true; j++; if (j >= len) return 0; }
    if (!_isAlphaByte(data[j])) return 0; j++;
    while (j < len && _isAlnumHyphenByte(data[j])) j++;
    if (isClosing) { while (j < len && _isHtmlSpace(data[j])) j++; if (j < len && data[j] == 0x3E) return j + 1 - offset; return 0; }
    while (j < len) {
      var sawWhitespace = false;
      while (j < len && _isHtmlSpace(data[j])) { sawWhitespace = true; j++; }
      if (j >= len) return 0;
      final current = data[j];
      if (current == 0x3E) return j + 1 - offset;
      if (current == 0x2F) { j++; if (j < len && data[j] == 0x3E) return j + 1 - offset; return 0; }
      if (!sawWhitespace) return 0;
      if (!_isAttrNameStart(current)) return 0; j++;
      while (j < len && _isAttrNameChar(data[j])) j++;
      final whitespaceStart = j; var afterWhitespace = j;
      while (afterWhitespace < len && _isHtmlSpace(data[afterWhitespace])) afterWhitespace++;
      if (afterWhitespace < len && data[afterWhitespace] == 0x3D) {
        j = afterWhitespace + 1; while (j < len && _isHtmlSpace(data[j])) j++;
        if (j >= len) return 0;
        final quote = data[j];
        if (quote == 0x22 || quote == 0x27) { j++; while (j < len && data[j] != quote) j++; if (j == len) return 0; j++; }
        else { var hasValue = false; while (j < len) { final v = data[j]; if (_isHtmlSpace(v) || v == 0x3E) break; if (v == 0x22 || v == 0x27 || v == 0x3C || v == 0x3D || v == 0x60) return 0; hasValue = true; j++; } if (!hasValue) return 0; }
      } else { j = whitespaceStart; }
    }
  }
  return 0;
}

bool _isAlphaByte(int byte) => (byte >= 0x41 && byte <= 0x5A) || (byte >= 0x61 && byte <= 0x7A);
bool _isAlnumHyphenByte(int byte) => _isAlphaByte(byte) || (byte >= 0x30 && byte <= 0x39) || byte == 0x2D;
bool _isHtmlSpace(int byte) => byte == 0x20 || byte == 0x09 || byte == 0x0A || byte == 0x0D || byte == 0x0C;
bool _isAttrNameStart(int byte) => _isAlphaByte(byte) || byte == 0x5F || byte == 0x3A || byte == 0x2D;
bool _isAttrNameChar(int byte) => _isAttrNameStart(byte) || (byte >= 0x30 && byte <= 0x39) || byte == 0x2E;
