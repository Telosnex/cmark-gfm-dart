import 'dart:convert';
import 'dart:typed_data';

import '../node.dart';
import '../reference/reference_map.dart';
import '../footnote/footnote_map.dart';
import '../parser/parser_options.dart';
import '../util/strbuf.dart';
import '../houdini/html_unescape.dart' as houdini;
import 'subject.dart';
import 'delimiter.dart';
import 'link_parsing.dart';

/// Real port of cmark-gfm's inline parser with delimiter stack.
/// From inlines.c
class InlineParser {
  InlineParser(
    this.refmap, {
    CmarkFootnoteMap? footnoteMap,
    CmarkParserOptions parserOptions = const CmarkParserOptions(),
  })  : options = parserOptions,
        mathOptions = parserOptions.mathOptions,
        footnoteMap = footnoteMap ?? CmarkFootnoteMap() {
    _subject = Subject(refmap: refmap, footnoteMap: this.footnoteMap);
    // Initialize special chars table (only need to do once)
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
  final CmarkFootnoteMap footnoteMap;

  late final Subject _subject;

  void reset() {
    _subject.reset();
  }

  void parseInlines(CmarkNode block) {
    if (block.type.isInline) {
      return;
    }

    // Skip blocks that don't contain inlines (tables, footnote_definition, etc.)
    if (!_containsInlines(block.type)) {
      return;
    }

    final contentStr = block.content.toString();

    final content = utf8.encode(contentStr);
    if (content.isEmpty) {
      return;
    }

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

    var iterations = 0;
    while (!subj.isEof()) {
      iterations++;
      if (iterations > 10000) {
        throw StateError(
            'Infinite loop in parseInlines: ${block.type.name} pos=${subj.pos} len=${subj.input.length}');
      }
      if (!_parseInline(subj, block)) {
        break;
      }
    }

    _processEmphasis(subj, 0);

    // Free delimiter and bracket stacks
    while (subj.lastDelim != null) {
      _removeDelimiter(subj, subj.lastDelim!);
    }
    while (subj.lastBracket != null) {
      _popBracket(subj);
    }
  }

  /// Main inline parsing dispatcher.
  /// Returns true if an inline was parsed, false if EOF.
  bool _parseInline(Subject subj, CmarkNode parent) {
    final c = subj.peekChar();
    if (c == 0) {
      return false;
    }

    CmarkNode? newInl;

    if (options.enableMath && (c == 0x24 || c == 0x5C)) {
      newInl = _tryParseMath(subj, c);
    }

    if (newInl == null) {
      switch (c) {
        case 0x0D: // \r
        case 0x0A: // \n
          newInl = _handleNewline(subj);
          break;
        case 0x60: // `
          newInl = _handleBackticks(subj);
          break;
        case 0x5C: // \
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
          newInl = _handleDelim(subj, c);
          break;
        case 0x7E: // ~
          newInl = _handleDelim(subj, c);
          break;
        case 0x5B: // [
          subj.advance();
          newInl = _makeStr(subj, subj.pos - 1, subj.pos - 1, '[');
          _pushBracket(subj, false, newInl);
          break;
        case 0x5D: // ]
          newInl = _handleCloseBracket(subj, parent);
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
          // Try extension matchers (would go here if we had extensions)
          // For now, collect text until next special char
          final startpos = subj.pos;
          final endpos = subj.findSpecialChar();
          var text = utf8.decode(subj.input.sublist(startpos, endpos));
          subj.pos = endpos;

          // if we're at a newline, strip trailing spaces (like C version)
          final nextChar = subj.peekChar();
          if (nextChar == 0x0A || nextChar == 0x0D) {
            text = text.trimRight();
          }

          newInl = _makeStr(subj, startpos, endpos - 1, text);
          break;
      }
    }

    if (newInl != null) {
      parent.appendChild(newInl);
    }

    return true;
  }

  CmarkNode? _tryParseMath(Subject subj, int leadingChar) {
    if (leadingChar == 0x5C) {
      final next = subj.peekCharN(1);
      if (next == 0x28 || next == 0x5B) {
        return _parseBracketMath(subj, display: next == 0x5B);
      }
      return null;
    }

    if (leadingChar == 0x24) {
      // Only parse inline double-dollar math, NOT single-dollar
      if (mathOptions.allowBlockDoubleDollar && subj.peekCharN(1) == 0x24) {
        return _parseDoubleDollarMath(subj);
      }
      // Single-dollar math removed - too ambiguous with regular text
    }

    return null;
  }

  CmarkNode? _parseBracketMath(Subject subj, {required bool display}) {
    final start = subj.pos;
    subj.advance(); // Consume '\'
    subj.advance(); // Consume '(' or '['

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
      subj: subj,
      start: start,
      end: end,
      literal: normalized,
      display: display,
      opening: display ? r'\[' : r'\(',
      closing: display ? r'\]' : r'\)',
    );
  }

  CmarkNode? _parseDoubleDollarMath(Subject subj) {
    final start = subj.pos;
    subj.advance();
    subj.advance();

    final contentStart = subj.pos;
    while (!subj.isEof()) {
      final ch = subj.peekChar();
      if (ch == 0x0A || ch == 0x0D) {
        subj.pos = start;
        return null;
      }
      if (ch == 0x24 && subj.peekCharN(1) == 0x24) {
        final bytes = subj.input.sublist(contentStart, subj.pos);
        final literal = utf8.decode(bytes, allowMalformed: true);
        final normalized = _normalizeInlineMathLiteral(literal);
        if (normalized.isEmpty) {
          subj.pos = start;
          return null;
        }
        subj.advance();
        subj.advance();
        return _buildInlineMathNode(
          subj: subj,
          start: start,
          end: subj.pos,
          literal: normalized,
          display: true,
          opening: r'$$',
          closing: r'$$',
        );
      }
      subj.advance();
    }

    subj.pos = start;
    return null;
  }

  String? _scanToEscapedDelimiter(Subject subj, int closingChar) {
    final start = subj.pos;
    while (!subj.isEof()) {
      final current = subj.peekChar();
      if (current == 0x5C && subj.peekCharN(1) == closingChar) {
        final bytes = subj.input.sublist(start, subj.pos);
        final literal = utf8.decode(bytes, allowMalformed: true);
        subj.advance();
        subj.advance();
        return literal;
      }
      if (current == 0x0A || current == 0x0D) {
        subj.pos = start;
        return null;
      }
      subj.advance();
    }
    subj.pos = start;
    return null;
  }

  CmarkNode _buildInlineMathNode({
    required Subject subj,
    required int start,
    required int end,
    required String literal,
    required bool display,
    required String opening,
    required String closing,
  }) {
    final raw = utf8.decode(
      subj.input.sublist(start, end),
      allowMalformed: true,
    );
    final node = CmarkNode(CmarkNodeType.math)
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

  CmarkNode _makeStr(Subject subj, int startCol, int endCol, String text) {
    final node = CmarkNode(CmarkNodeType.text)
      ..content.write(text)
      ..startLine = subj.line
      ..endLine = subj.line
      ..startColumn = startCol + 1 + subj.columnOffset + subj.blockOffset
      ..endColumn = endCol + 1 + subj.columnOffset + subj.blockOffset;
    return node;
  }

  CmarkNode _handleNewline(Subject subj) {
    final nlpos = subj.pos;
    if (subj.peekAt(subj.pos) == 0x0D) {
      subj.advance();
    }
    if (subj.peekAt(subj.pos) == 0x0A) {
      subj.advance();
    }
    subj.line++;
    subj.columnOffset = -subj.pos;
    subj.skipSpaces();

    // Hard break if preceded by two spaces
    if (nlpos > 1 &&
        subj.peekAt(nlpos - 1) == 0x20 &&
        subj.peekAt(nlpos - 2) == 0x20) {
      return CmarkNode(CmarkNodeType.linebreak);
    } else {
      return CmarkNode(CmarkNodeType.softbreak);
    }
  }

  CmarkNode _handleBackticks(Subject subj) {
    final startpos = subj.pos;
    var numticks = 0;
    while (subj.peekChar() == 0x60) {
      subj.advance();
      numticks++;
    }
    final afterTicksPos = subj.pos; // Position after opening backticks

    final endpos = _scanToClosingBackticks(subj, numticks);
    if (endpos == 0) {
      // Not found - reset position and return literal backticks
      subj.pos = afterTicksPos; // Reset so rest of line can be parsed
      return _makeStr(subj, startpos, afterTicksPos - 1, '`' * numticks);
    } else {
      // Found closing - extract code content
      final codeBytes =
          subj.input.sublist(startpos + numticks, endpos - numticks);
      var code = utf8.decode(codeBytes, allowMalformed: true);

      // Normalize: newlines → spaces, trim single leading/trailing space
      code = code.replaceAll(RegExp(r'[\r\n]+'), ' ');
      if (code.isNotEmpty && code.trim().isNotEmpty) {
        if (code.startsWith(' ') && code.endsWith(' ') && code.length > 2) {
          code = code.substring(1, code.length - 1);
        }
      }

      return CmarkNode(CmarkNodeType.code)
        ..content.write(code)
        ..startLine = subj.line
        ..endLine = subj.line
        ..startColumn = startpos + 1
        ..endColumn = endpos - 1;
    }
  }

  int _scanToClosingBackticks(Subject subj, int openLen) {
    if (openLen > maxBackticks) {
      return 0;
    }
    if (subj.scannedForBackticks && subj.backticks[openLen] <= subj.pos) {
      return 0;
    }

    final startPos = subj.pos;
    var iterations = 0;

    while (!subj.isEof()) {
      iterations++;
      if (iterations > 100000) {
        throw StateError(
            'Infinite loop in _scanToClosingBackticks: openLen=$openLen startPos=$startPos pos=${subj.pos}');
      }

      // Read non-backticks
      while (subj.peekChar() != 0x60 && !subj.isEof()) {
        subj.advance();
      }
      if (subj.isEof()) {
        break;
      }

      var numticks = 0;
      while (subj.peekChar() == 0x60) {
        subj.advance();
        numticks++;
      }

      if (numticks <= maxBackticks) {
        subj.recordBacktickRun(numticks, subj.pos - numticks);
      }

      if (numticks == openLen) {
        return subj.pos;
      }
    }

    subj.scannedForBackticks = true;
    return 0;
  }

  CmarkNode _handleBackslash(Subject subj) {
    subj.advance();
    final nextchar = subj.peekChar();
    if (_isPunct(nextchar)) {
      subj.advance();
      return _makeStr(
          subj, subj.pos - 2, subj.pos - 1, String.fromCharCode(nextchar));
    } else if (!subj.isEof() && subj.skipLineEnd()) {
      // Must have actual newline, not just EOF
      return CmarkNode(CmarkNodeType.linebreak);
    } else {
      return _makeStr(subj, subj.pos - 1, subj.pos - 1, '\\');
    }
  }

  CmarkNode _handleEntity(Subject subj) {
    subj.advance();
    final buf = CmarkStrbuf();
    final consumed =
        houdini.HoudiniHtmlUnescape.unescapeEntity(buf, subj.input, subj.pos);
    if (consumed == 0) {
      return _makeStr(subj, subj.pos - 1, subj.pos - 1, '&');
    }
    subj.pos += consumed;
    final output = utf8.decode(buf.detach(), allowMalformed: true);
    return _makeStr(subj, (subj.pos - 1 - consumed), subj.pos - 1, output);
  }

  CmarkNode _handlePointyBrace(Subject subj) {
    subj.advance(); // past <
    final tagStart = subj.pos - 1;

    // Try URL autolink <http://...>
    final urlMatch = _scanAutolinkUri(subj.input, subj.pos);
    if (urlMatch > 0) {
      try {
        final url =
            utf8.decode(subj.input.sublist(subj.pos, subj.pos + urlMatch - 1));
        subj.pos += urlMatch;
        return _makeAutolink(
            subj, subj.pos - 1 - urlMatch, subj.pos - 1, url, false);
      } catch (e) {
        // Invalid UTF-8 - not an autolink, return literal <
        return _makeStr(subj, subj.pos - 1, subj.pos - 1, '<');
      }
    }

    // Try email autolink <user@example.com>
    final emailMatch = _scanAutolinkEmail(subj.input, subj.pos);
    if (emailMatch > 0) {
      try {
        final email = utf8
            .decode(subj.input.sublist(subj.pos, subj.pos + emailMatch - 1));
        subj.pos += emailMatch;
        return _makeAutolink(
            subj, subj.pos - 1 - emailMatch, subj.pos - 1, email, true);
      } catch (e) {
        // Invalid UTF-8 - not an autolink, return literal <
        return _makeStr(subj, subj.pos - 1, subj.pos - 1, '<');
      }
    }

    // Try HTML tag, comment, declaration, etc.
    final htmlLen = _scanHtmlTag(subj.input, tagStart);
    if (htmlLen > 0) {
      final end = tagStart + htmlLen;
      final raw = utf8.decode(
        subj.input.sublist(tagStart, end),
        allowMalformed: true,
      );
      subj.pos = end;
      final node = CmarkNode(CmarkNodeType.htmlInline)
        ..content.write(raw)
        ..startLine = subj.line
        ..endLine = subj.line
        ..startColumn = tagStart + 1 + subj.columnOffset + subj.blockOffset
        ..endColumn = end + subj.columnOffset + subj.blockOffset;
      return node;
    }

    // Not an autolink or HTML tag - return literal <
    return _makeStr(subj, subj.pos - 1, subj.pos - 1, '<');
  }

  int _scanAutolinkUri(Uint8List data, int pos) {
    // Port of scan_autolink_uri from scanners.re
    // scheme = [A-Za-z][A-Za-z0-9.+-]{1,31}:  followed by non-space/< /control chars, ended by >
    final remaining = utf8.decode(data.sublist(pos), allowMalformed: true);
    final match = RegExp(r'^[A-Za-z][A-Za-z0-9.+-]{1,31}:[^\x00-\x20<>]*>')
        .firstMatch(remaining);
    return match?.group(0)?.length ?? 0;
  }

  int _scanAutolinkEmail(Uint8List data, int pos) {
    final remaining = utf8.decode(data.sublist(pos), allowMalformed: true);
    final pattern = r'^[a-zA-Z0-9.!#$%&'
        "'"
        r'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*>';
    final match = RegExp(pattern).firstMatch(remaining);
    return match?.group(0)?.length ?? 0;
  }

  CmarkNode _makeAutolink(
      Subject subj, int startCol, int endCol, String url, bool isEmail) {
    // Port of make_autolink from inlines.c
    final link = CmarkNode(CmarkNodeType.link);

    // Clean autolink URL (cmark_clean_autolink)
    var cleanedUrl = url.trim();
    if (cleanedUrl.isEmpty) {
      cleanedUrl = '';
    } else {
      if (isEmail) {
        cleanedUrl = 'mailto:$cleanedUrl';
      }
      // HTML unescape the URL
      final buf = CmarkStrbuf();
      houdini.HoudiniHtmlUnescape.unescape(buf, utf8.encode(cleanedUrl));
      cleanedUrl = utf8.decode(buf.detach(), allowMalformed: true);
    }

    link.linkData.url = cleanedUrl;
    link.linkData.title = '';
    link.startLine = link.endLine = subj.line;
    link.startColumn = startCol + 1;
    link.endColumn = endCol + 1;

    // Text content (with entity unescaping)
    final textBuf = CmarkStrbuf();
    houdini.HoudiniHtmlUnescape.unescape(textBuf, utf8.encode(url));
    final textContent = utf8.decode(textBuf.detach(), allowMalformed: true);

    final text = CmarkNode(CmarkNodeType.text)..content.write(textContent);
    link.appendChild(text);

    return link;
  }

  CmarkNode _handleDelim(Subject subj, int c) {
    final canOpen = <bool>[false];
    final canClose = <bool>[false];
    final numDelims = _scanDelims(subj, c, canOpen, canClose);

    final delims = String.fromCharCodes(List.filled(numDelims, c));
    final inlText = _makeStr(subj, subj.pos - numDelims, subj.pos - 1, delims);

    if (canOpen[0] || canClose[0]) {
      _pushDelimiter(subj, c, canOpen[0], canClose[0], inlText);
    }

    return inlText;
  }

  int _codePointAt(Uint8List data, int pos) {
    final first = data[pos];
    if (first < 0x80) {
      return first;
    } else if ((first & 0xE0) == 0xC0 && pos + 1 < data.length) {
      final second = data[pos + 1] & 0x3F;
      return ((first & 0x1F) << 6) | second;
    } else if ((first & 0xF0) == 0xE0 && pos + 2 < data.length) {
      final second = data[pos + 1] & 0x3F;
      final third = data[pos + 2] & 0x3F;
      return ((first & 0x0F) << 12) | (second << 6) | third;
    } else if ((first & 0xF8) == 0xF0 && pos + 3 < data.length) {
      final second = data[pos + 1] & 0x3F;
      final third = data[pos + 2] & 0x3F;
      final fourth = data[pos + 3] & 0x3F;
      return ((first & 0x07) << 18) | (second << 12) | (third << 6) | fourth;
    }
    return first;
  }

  int _scanDelims(
      Subject subj, int c, List<bool> canOpen, List<bool> canClose) {
    var numDelims = 0;
    var beforeChar = 0x0A; // newline if at start
    var afterChar = 0x0A;

    final startPos = subj.pos;

    if (startPos > 0) {
      var beforePos = startPos - 1;
      while (beforePos > 0 && (subj.input[beforePos] >> 6) == 2) {
        beforePos--;
      }
      beforeChar = _codePointAt(subj.input, beforePos);
    }

    // Count delimiters
    while (subj.peekChar() == c) {
      numDelims++;
      subj.advance();
    }

    if (subj.pos < subj.input.length) {
      afterChar = _codePointAt(subj.input, subj.pos);
    }

    final leftFlanking = numDelims > 0 &&
        !_isSpace(afterChar) &&
        (!_isPunct(afterChar) || _isSpace(beforeChar) || _isPunct(beforeChar));
    final rightFlanking = numDelims > 0 &&
        !_isSpace(beforeChar) &&
        (!_isPunct(beforeChar) || _isSpace(afterChar) || _isPunct(afterChar));

    if (c == 0x5F) {
      // _
      canOpen[0] = leftFlanking && (!rightFlanking || _isPunct(beforeChar));
      canClose[0] = rightFlanking && (!leftFlanking || _isPunct(afterChar));
    } else {
      canOpen[0] = leftFlanking;
      canClose[0] = rightFlanking;
    }

    return numDelims;
  }

  void _processEmphasis(Subject subj, int stackBottom) {
    // From process_emphasis() in inlines.c
    // openers_bottom[3][128] tracks minimum position for each delim type
    final openersBottom = <int, Map<int, int>>{
      0: {},
      1: {},
      2: {},
    };

    // Initialize for common delimiters
    for (var i = 0; i < 3; i++) {
      openersBottom[i]![0x2A] = stackBottom; // *
      openersBottom[i]![0x5F] = stackBottom; // _
      // Note: ~ (tilde) is NOT initialized to stackBottom in C
      // It's zero-initialized because it's a GFM extension delimiter
      openersBottom[i]![0x7E] = 0; // ~
    }

    Delimiter? candidate = subj.lastDelim;
    var closer = candidate;

    // Move back to first relevant delim
    while (candidate != null && candidate.position >= stackBottom) {
      closer = candidate;
      candidate = candidate.previous;
    }

    // Now move forward, looking for closers
    var emphIterations = 0;
    while (closer != null) {
      emphIterations++;
      if (emphIterations > 10000) {
        throw StateError('Infinite loop in _processEmphasis');
      }

      if (closer.canClose) {
        // Look for matching opener
        var opener = closer.previous;
        var openerFound = false;

        final bottomPos =
            openersBottom[closer.length % 3]![closer.delimChar] ?? stackBottom;

        while (opener != null &&
            opener.position >= stackBottom &&
            opener.position >= bottomPos) {
          if (opener.canOpen && opener.delimChar == closer.delimChar) {
            // Check for valid match
            if (!(closer.canOpen || opener.canClose) ||
                closer.length % 3 == 0 ||
                (opener.length + closer.length) % 3 != 0) {
              openerFound = true;
              break;
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

        // Set lower bound for future searches
        if (!openerFound) {
          openersBottom[oldCloser.length % 3]![oldCloser.delimChar] =
              oldCloser.position;
          // Only remove if we're at the top level (stackBottom=0)
          // Nested calls might not see all openers, so keep closers for later
          if (!oldCloser.canOpen && stackBottom == 0) {
            // Remove closer that can't be opener
            _removeDelimiter(subj, oldCloser);
          }
        }
      } else {
        closer = closer.next;
      }
    }

    // Free delimiters below stack bottom
    while (subj.lastDelim != null && subj.lastDelim!.position >= stackBottom) {
      _removeDelimiter(subj, subj.lastDelim!);
    }
  }

  Delimiter? _insertEmph(Subject subj, Delimiter opener, Delimiter closer) {
    final openerInl = opener.inlText;
    final closerInl = closer.inlText;
    var openerNumChars = opener.length;
    var closerNumChars = closer.length;

    // For strikethrough (~), only allow 1 or 2 tildes (from GFM strikethrough extension)
    if (opener.delimChar == 0x7E) {
      if (openerNumChars > 2 ||
          closerNumChars > 2 ||
          openerNumChars != closerNumChars) {
        return closer.next; // No match - continue
      }
    }

    // Use 2 chars if both have >= 2, else 1
    final useDelims = (opener.delimChar == 0x7E)
        ? openerNumChars // Use all tildes for strikethrough (1 or 2)
        : ((closerNumChars >= 2 && openerNumChars >= 2) ? 2 : 1);

    openerNumChars -= useDelims;
    closerNumChars -= useDelims;
    opener.length = openerNumChars;
    closer.length = closerNumChars;

    // Update literal in opener/closer text nodes
    final openerText = openerInl.content.toString();
    openerInl.content.clear();
    if (openerNumChars > 0) {
      openerInl.content.write(openerText.substring(0, openerNumChars));
    }

    final closerText = closerInl.content.toString();
    closerInl.content.clear();
    if (closerNumChars > 0) {
      closerInl.content.write(closerText.substring(0, closerNumChars));
    }

    // Free delimiters between opener and closer
    var delim = closer.previous;
    while (delim != null && delim != opener) {
      final tmpDelim = delim.previous;
      _removeDelimiter(subj, delim);
      delim = tmpDelim;
    }

    // Create emph or strong node
    final emphType = (opener.delimChar == 0x7E) // ~
        ? CmarkNodeType.strikethrough
        : (useDelims == 1 ? CmarkNodeType.emph : CmarkNodeType.strong);
    final emph = CmarkNode(emphType);

    // Move nodes between opener and closer into emph
    var tmp = openerInl.next;
    while (tmp != null && tmp != closerInl) {
      final tmpNext = tmp.next;
      tmp.unlink();
      emph.appendChild(tmp);
      tmp = tmpNext;
    }

    // Insert emph after opener
    openerInl.parent?.insertAfter(openerInl, emph);

    emph.startLine = openerInl.startLine;
    emph.endLine = closerInl.endLine;
    emph.startColumn = openerInl.startColumn;
    emph.endColumn = closerInl.endColumn;

    // Remove empty opener
    if (openerNumChars == 0) {
      openerInl.unlink();
      _removeDelimiter(subj, opener);
    }

    // Remove empty closer
    Delimiter? result;
    if (closerNumChars == 0) {
      closerInl.unlink();
      result = closer.next;
      _removeDelimiter(subj, closer);
    } else {
      result = closer;
    }

    return result;
  }

  CmarkNode? _handleCloseBracket(Subject subj, CmarkNode parent) {
    subj.advance(); // past ]
    final initialPos = subj.pos;

    // Get last [ or ![
    final opener = subj.lastBracket;
    if (opener == null) {
      return _makeStr(subj, subj.pos - 1, subj.pos - 1, ']');
    }

    final isImage = opener.image;

    // If no link openers and not image, bail
    if (!isImage && subj.noLinkOpeners) {
      _popBracket(subj);
      return _makeStr(subj, subj.pos - 1, subj.pos - 1, ']');
    }

    final afterLinkTextPos = subj.pos;

    // Try inline link (url "title")
    // Matches C: if (peek_char(subj) == '(' && scan_spacechars(...) && manual_scan_link_url(...))
    if (subj.peekChar() == 0x28) {
      // (
      // Scan spaces after ( without advancing yet
      final sps = subj.scanSpacecharsAt(subj.pos + 1);

      if (sps >= 0) {
        final urlResult = LinkUrlResult();
        final n = scanLinkUrl(subj.input, subj.pos + 1 + sps, urlResult);

        if (n >= 0) {
          // 0 is valid (empty URL)
          // Match found - now advance
          final endurl = subj.pos + 1 + sps + n;
          final starttitle = endurl + subj.scanSpacecharsAt(endurl);

          // ensure there are spaces btw url and title
          final endtitle = (starttitle == endurl)
              ? starttitle
              : starttitle + _scanLinkTitleAt(subj.input, starttitle);

          final endall = endtitle + subj.scanSpacecharsAt(endtitle);

          if (subj.peekAt(endall) == 0x29) {
            subj.pos = endall + 1;

            // Extract and clean title
            var titleStr = '';
            if (endtitle > starttitle) {
              titleStr = utf8.decode(
                subj.input.sublist(starttitle, endtitle),
                allowMalformed: true,
              );
            }

            final cleanedUrl = cleanUrl(urlResult.url);
            final cleanedTitle = cleanTitle(titleStr);

            // Found inline link - goto match
            return _createLink(subj, opener, isImage, cleanedUrl, cleanedTitle,
                afterLinkTextPos);
          } else {
            // Could still be shortcut reference - rewind
            subj.pos = afterLinkTextPos;
          }
        } else {
          // No URL found - rewind
          subj.pos = afterLinkTextPos;
        }
      }
    }

    // Try reference link [ref]
    final labelResult = LinkLabelResult();
    final foundLabel = linkLabel(subj.input, subj.pos, labelResult);

    String refLabel;
    if (foundLabel && labelResult.label.isNotEmpty) {
      // Explicit reference [foo][bar]
      refLabel = labelResult.label;
      subj.pos = labelResult.endPos;
    } else if (foundLabel) {
      // Empty reference [foo][] - use link text as label
      refLabel = utf8
          .decode(
            subj.input.sublist(opener.position, initialPos - 1),
            allowMalformed: true,
          )
          .trim();
      subj.pos = labelResult.endPos; // Advance past the []
    } else if (!opener.bracketAfter) {
      // Shortcut reference - use link text as label
      refLabel = utf8
          .decode(
            subj.input.sublist(opener.position, initialPos - 1),
            allowMalformed: true,
          )
          .trim();
    } else {
      // No match
      _popBracket(subj);
      subj.pos = initialPos;
      return _makeStr(subj, subj.pos - 1, subj.pos - 1, ']');
    }

    // Look up in reference map
    final ref = refmap.lookupString(refLabel);
    if (ref != null) {
      final urlStr = utf8.decode(ref.url.data, allowMalformed: true);
      final titleStr = utf8.decode(ref.title.data, allowMalformed: true);
      return _createLink(
          subj, opener, isImage, urlStr, titleStr, afterLinkTextPos);
    }

    // Check for footnote reference [^label]
    final nextNode = opener.inlText.next;
    if (nextNode != null && nextNode.type == CmarkNodeType.text) {
      final literal = nextNode.content.toString();

      // Check if starts with ^ and has more content
      if (literal.isNotEmpty &&
          literal.startsWith('^') &&
          (literal.length > 1 || nextNode.next != null)) {
        // Rewind to initial position (before looking for link label)
        subj.pos = initialPos;

        // Create footnote reference node
        final fnref = CmarkNode(CmarkNodeType.footnoteReference);

        final fnrefEndColumn = subj.pos + subj.columnOffset + subj.blockOffset;
        final fnrefStartColumn = opener.inlText.startColumn;

        if (refLabel.length > 1) {
          fnref.content.write(refLabel.substring(1));
        } else if (literal.length > 1) {
          fnref.content.write(literal.substring(1));
        }

        fnref.startLine = fnref.endLine = subj.line;
        fnref.startColumn = fnrefStartColumn;
        fnref.endColumn = fnrefEndColumn;

        // Insert before opener
        opener.inlText.parent?.insertAfter(
          opener.inlText.previous ?? opener.inlText,
          fnref,
        );

        // Process emphasis before this point
        _processEmphasis(subj, opener.position);

        // Free nodes after opener
        var current = opener.inlText.next;
        while (current != null) {
          final next = current.next;
          current.unlink();
          current = next;
        }

        opener.inlText.unlink();
        _popBracket(subj);
        return null;
      }
    }

    // No match
    _popBracket(subj);
    subj.pos = initialPos;
    return _makeStr(subj, subj.pos - 1, subj.pos - 1, ']');
  }

  CmarkNode? _createLink(Subject subj, Bracket opener, bool isImage, String url,
      String title, int afterLinkTextPos) {
    final link = CmarkNode(isImage ? CmarkNodeType.image : CmarkNodeType.link);
    link.linkData
      ..url = url
      ..title = title;
    link.startLine = link.endLine = subj.line;
    link.startColumn = opener.inlText.startColumn;
    link.endColumn = subj.pos + subj.columnOffset + subj.blockOffset;

    // Insert link node in place of opener
    final openerParent = opener.inlText.parent;
    if (openerParent == null) {
      return null;
    }

    // Insert before opener's position
    if (opener.inlText.previous != null) {
      openerParent.insertAfter(opener.inlText.previous!, link);
    } else {
      // Opener is first child - prepend
      openerParent.prependChild(link);
    }

    // Move nodes between opener and current position into link
    var tmp = opener.inlText.next;
    while (tmp != null) {
      final tmpNext = tmp.next;
      tmp.unlink();
      link.appendChild(tmp);
      tmp = tmpNext;
    }

    // Free the opener [ text
    opener.inlText.unlink();

    // Process emphasis before this point
    _processEmphasis(subj, opener.position);
    _popBracket(subj);

    // Deactivate link openers (no links in links)
    if (!isImage) {
      subj.noLinkOpeners = true;
    }

    return null; // Link inserted, don't append
  }

  void _pushDelimiter(
      Subject subj, int c, bool canOpen, bool canClose, CmarkNode inlText) {
    final delim = Delimiter(
      delimChar: c,
      canOpen: canOpen,
      canClose: canClose,
      inlText: inlText,
      position: subj.pos,
      length: inlText.content.length,
      previous: subj.lastDelim,
    );

    if (delim.previous != null) {
      delim.previous!.next = delim;
    }
    subj.lastDelim = delim;
  }

  void _removeDelimiter(Subject subj, Delimiter delim) {
    if (delim.next == null) {
      // End of list
      subj.lastDelim = delim.previous;
    } else {
      delim.next!.previous = delim.previous;
    }
    if (delim.previous != null) {
      delim.previous!.next = delim.next;
    }
  }

  void _pushBracket(Subject subj, bool image, CmarkNode inlText) {
    final b = Bracket(
      image: image,
      inlText: inlText,
      position: subj.pos,
      previous: subj.lastBracket,
    );

    if (subj.lastBracket != null) {
      subj.lastBracket!.bracketAfter = true;
      b.inBracketImage0 = subj.lastBracket!.inBracketImage0;
      b.inBracketImage1 = subj.lastBracket!.inBracketImage1;
    }

    if (image) {
      b.inBracketImage1 = true;
    } else {
      b.inBracketImage0 = true;
    }

    subj.lastBracket = b;
    if (!image) {
      subj.noLinkOpeners = false;
    }
  }

  void _popBracket(Subject subj) {
    if (subj.lastBracket == null) {
      return;
    }
    subj.lastBracket = subj.lastBracket!.previous;
  }

  bool _containsInlines(CmarkNodeType type) {
    // From cmark: blocks that accept inline content
    switch (type) {
      case CmarkNodeType.paragraph:
      case CmarkNodeType.heading:
      case CmarkNodeType.tableCell:
        return true;
      case CmarkNodeType.table:
      case CmarkNodeType.tableRow:
      case CmarkNodeType.footnoteDefinition:
      case CmarkNodeType.document:
      case CmarkNodeType.blockQuote:
      case CmarkNodeType.list:
      case CmarkNodeType.item:
      case CmarkNodeType.codeBlock:
      case CmarkNodeType.htmlBlock:
      case CmarkNodeType.thematicBreak:
        return false;
      default:
        return false;
    }
  }

  int _scanLinkTitleAt(Uint8List input, int offset) {
    final result = LinkTitleResult();
    return scanLinkTitle(input, offset, result);
  }

  bool _isSpace(int ch) =>
      ch == 0x20 ||
      ch == 0x09 ||
      ch == 0x0A ||
      ch == 0x0B ||
      ch == 0x0C ||
      ch == 0x0D ||
      ch == 0xA0;
  bool _isPunct(int ch) {
    return (ch >= 0x21 && ch <= 0x2F) ||
        (ch >= 0x3A && ch <= 0x40) ||
        (ch >= 0x5B && ch <= 0x60) ||
        (ch >= 0x7B && ch <= 0x7E);
  }
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
      while (j + 2 < len) {
        if (data[j] == 0x2D && data[j + 1] == 0x2D && data[j + 2] == 0x3E) {
          return j + 3 - offset;
        }
        j++;
      }
      return 0;
    }
    if (i + 7 < len &&
        data[i + 1] == 0x5B &&
        data[i + 2] == 0x43 &&
        data[i + 3] == 0x44 &&
        data[i + 4] == 0x41 &&
        data[i + 5] == 0x54 &&
        data[i + 6] == 0x41 &&
        data[i + 7] == 0x5B) {
      var j = i + 8;
      while (j + 2 < len) {
        if (data[j] == 0x5D && data[j + 1] == 0x5D && data[j + 2] == 0x3E) {
          return j + 3 - offset;
        }
        j++;
      }
      return 0;
    }
    var j = i + 1;
    while (j < len && data[j] != 0x3E) {
      j++;
    }
    if (j == len) return 0;
    return j + 1 - offset;
  } else if (ch == 0x3F) {
    var j = i + 1;
    while (j + 1 < len) {
      if (data[j] == 0x3F && data[j + 1] == 0x3E) {
        return j + 2 - offset;
      }
      j++;
    }
    return 0;
  } else {
    var j = i;
    var isClosing = false;
    if (data[j] == 0x2F) {
      isClosing = true;
      j++;
      if (j >= len) return 0;
    }
    if (!_isAlphaByte(data[j])) return 0;
    j++;
    while (j < len && _isAlnumHyphenByte(data[j])) {
      j++;
    }

    if (isClosing) {
      while (j < len && _isHtmlSpace(data[j])) {
        j++;
      }
      if (j < len && data[j] == 0x3E) {
        return j + 1 - offset;
      }
      return 0;
    }

    while (j < len) {
      var sawWhitespace = false;
      while (j < len && _isHtmlSpace(data[j])) {
        sawWhitespace = true;
        j++;
      }
      if (j >= len) return 0;
      final current = data[j];
      if (current == 0x3E) {
        return j + 1 - offset;
      }
      if (current == 0x2F) {
        j++;
        if (j < len && data[j] == 0x3E) {
          return j + 1 - offset;
        }
        return 0;
      }
      if (!sawWhitespace) {
        return 0;
      }
      if (!_isAttrNameStart(current)) return 0;
      j++;
      while (j < len && _isAttrNameChar(data[j])) {
        j++;
      }
      final whitespaceStart = j;
      var afterWhitespace = j;
      while (afterWhitespace < len && _isHtmlSpace(data[afterWhitespace])) {
        afterWhitespace++;
      }
      if (afterWhitespace < len && data[afterWhitespace] == 0x3D) {
        j = afterWhitespace + 1;
        while (j < len && _isHtmlSpace(data[j])) {
          j++;
        }
        if (j >= len) return 0;
        final quote = data[j];
        if (quote == 0x22 || quote == 0x27) {
          j++;
          while (j < len && data[j] != quote) {
            j++;
          }
          if (j == len) return 0;
          j++;
        } else {
          var hasValue = false;
          while (j < len) {
            final valueChar = data[j];
            if (_isHtmlSpace(valueChar) || valueChar == 0x3E) {
              break;
            }
            if (valueChar == 0x22 ||
                valueChar == 0x27 ||
                valueChar == 0x3C ||
                valueChar == 0x3D ||
                valueChar == 0x60) {
              return 0;
            }
            hasValue = true;
            j++;
          }
          if (!hasValue) {
            return 0;
          }
        }
      } else {
        j = whitespaceStart;
      }
    }
  }
  return 0;
}

bool _isAlphaByte(int byte) =>
    (byte >= 0x41 && byte <= 0x5A) || (byte >= 0x61 && byte <= 0x7A);

bool _isAlnumHyphenByte(int byte) =>
    _isAlphaByte(byte) || (byte >= 0x30 && byte <= 0x39) || byte == 0x2D;

bool _isHtmlSpace(int byte) =>
    byte == 0x20 ||
    byte == 0x09 ||
    byte == 0x0A ||
    byte == 0x0D ||
    byte == 0x0C;

bool _isAttrNameStart(int byte) =>
    _isAlphaByte(byte) || byte == 0x5F || byte == 0x3A || byte == 0x2D;

bool _isAttrNameChar(int byte) =>
    _isAttrNameStart(byte) || (byte >= 0x30 && byte <= 0x39) || byte == 0x2E;
