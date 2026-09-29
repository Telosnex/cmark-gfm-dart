import 'dart:convert';
import 'dart:typed_data';

import '../node.dart';
import '../util/ctype.dart';
import '../util/utf8.dart';

// GFM autolink extension, ported from cmark-gfm extensions/autolink.c.
//
// URL and www links are matched during inline parsing, at ':' and 'w', like
// C's `match` hook. Email, mailto and xmpp links are matched afterwards in
// consolidated text nodes, like C's `postprocess`. As in C, link URLs and
// link text are the source bytes; they are not unescaped or cleaned.

/// An autolink found at a ':' or 'w' in inline content.
class InlineAutolinkMatch {
  const InlineAutolinkMatch(this.start, this.end, this.url, this.text);

  final int start; // byte offset of the first linked byte
  final int end; // byte offset after the last linked byte
  final String url;
  final String text;
}

/// Port of C's `match`. [index] is the offset of a ':' or 'w' in [data], the
/// inline content of one block. The caller must not call this inside link or
/// image brackets (cmark_inline_parser_in_bracket).
InlineAutolinkMatch? matchInlineAutolink(Uint8List data, int index) {
  final c = data[index];
  if (c == 0x3A) return _urlMatch(data, index);
  if (c == 0x77) return _wwwMatch(data, index);
  return null;
}

InlineAutolinkMatch? _wwwMatch(Uint8List data, int index) {
  final size = data.length - index;
  if (index > 0) {
    final prev = data[index - 1];
    // strchr("*_~(", c) == NULL && !cmark_isspace(c)
    if (prev != 0x2A &&
        prev != 0x5F &&
        prev != 0x7E &&
        prev != 0x28 &&
        !CmarkCType.isSpace(prev)) {
      return null;
    }
  }
  if (size < 4 ||
      data[index + 1] != 0x77 ||
      data[index + 2] != 0x77 ||
      data[index + 3] != 0x2E) {
    return null;
  }

  var linkEnd = _checkDomain(data, index, size, allowShort: false);
  if (linkEnd == 0) return null;
  while (linkEnd < size &&
      !CmarkCType.isSpace(data[index + linkEnd]) &&
      data[index + linkEnd] != 0x3C) {
    linkEnd++;
  }
  linkEnd = _autolinkDelim(data, index, linkEnd);
  if (linkEnd == 0) return null;

  final text = _decode(data, index, index + linkEnd);
  return InlineAutolinkMatch(index, index + linkEnd, 'http://$text', text);
}

InlineAutolinkMatch? _urlMatch(Uint8List data, int index) {
  final size = data.length - index;
  if (size < 4 || data[index + 1] != 0x2F || data[index + 2] != 0x2F) {
    return null;
  }

  var rewind = 0;
  while (rewind < index && CmarkCType.isAlpha(data[index - rewind - 1])) {
    rewind++;
  }
  if (!_autolinkIsSafe(data, index - rewind, size + rewind)) return null;

  var linkEnd = 3; // "://"
  final domainLen =
      _checkDomain(data, index + linkEnd, size - linkEnd, allowShort: true);
  if (domainLen == 0) return null;
  linkEnd += domainLen;
  while (linkEnd < size &&
      !CmarkCType.isSpace(data[index + linkEnd]) &&
      data[index + linkEnd] != 0x3C) {
    linkEnd++;
  }
  linkEnd = _autolinkDelim(data, index, linkEnd);
  if (linkEnd == 0) return null;

  final text = _decode(data, index - rewind, index + linkEnd);
  return InlineAutolinkMatch(index - rewind, index + linkEnd, text, text);
}

String _decode(Uint8List data, int start, int end) =>
    utf8.decode(Uint8List.sublistView(data, start, end), allowMalformed: true);

const _http = <int>[0x68, 0x74, 0x74, 0x70, 0x3A, 0x2F, 0x2F];
const _https = <int>[0x68, 0x74, 0x74, 0x70, 0x73, 0x3A, 0x2F, 0x2F];
const _ftp = <int>[0x66, 0x74, 0x70, 0x3A, 0x2F, 0x2F];

/// Port of sd_autolink_issafe.
bool _autolinkIsSafe(Uint8List data, int start, int linkLen) {
  for (final scheme in const [_http, _https, _ftp]) {
    final len = scheme.length;
    if (linkLen > len &&
        _startsWithIgnoreAsciiCase(data, start, scheme) &&
        _isValidHostChar(data, start + len)) {
      return true;
    }
  }
  return false;
}

bool _startsWithIgnoreAsciiCase(Uint8List data, int start, List<int> lower) {
  for (var i = 0; i < lower.length; i++) {
    var c = data[start + i];
    if (c >= 0x41 && c <= 0x5A) c += 0x20;
    if (c != lower[i]) return false;
  }
  return true;
}

/// Port of is_valid_hostchar: not Unicode space or punctuation. A UTF-8
/// continuation byte is not a valid character start, so it is invalid.
bool _isValidHostChar(Uint8List data, int pos) {
  final b = data[pos];
  if (b < 0x80) {
    return !CmarkUtf8.isSpace(b) && !CmarkUtf8.isPunctuation(b);
  }
  final result = CmarkUtf8.iterate(data, pos);
  if (!result.isValid) return false;
  return !CmarkUtf8.isSpace(result.codePoint) &&
      !CmarkUtf8.isPunctuation(result.codePoint);
}

/// Port of check_domain. Like C, it starts at the second byte and does not
/// inspect the last byte of the remaining content.
int _checkDomain(Uint8List data, int base, int size,
    {required bool allowShort}) {
  var np = 0;
  var uscore1 = 0;
  var uscore2 = 0;
  var i = 1;
  for (; i < size - 1; i++) {
    if (data[base + i] == 0x5C && i < size - 2) i++;
    final c = data[base + i];
    if (c == 0x5F) {
      uscore2++;
    } else if (c == 0x2E) {
      uscore1 = uscore2;
      uscore2 = 0;
      np++;
    } else if (!_isValidHostChar(data, base + i) && c != 0x2D) {
      break;
    }
  }

  // Accept many-segment names to avoid quadratic behavior
  // (GHSA-29g3-96g3-jg6c).
  if ((uscore1 > 0 || uscore2 > 0) && np <= 10) return 0;
  if (allowShort) return i;
  return np != 0 ? i : 0;
}

/// Port of autolink_delim. Returns the trimmed length of the link that starts
/// at [base] and is [linkEnd] units long.
int _autolinkDelim(List<int> data, int base, int linkEnd) {
  var closing = 0;
  var opening = 0;
  for (var i = 0; i < linkEnd; i++) {
    final c = data[base + i];
    if (c == 0x3C) {
      linkEnd = i;
      break;
    } else if (c == 0x28) {
      opening++;
    } else if (c == 0x29) {
      closing++;
    }
  }

  while (linkEnd > 0) {
    switch (data[base + linkEnd - 1]) {
      case 0x29: // )
        if (closing <= opening) return linkEnd;
        closing--;
        linkEnd--;
      case 0x3F: // ?
      case 0x21: // !
      case 0x2E: // .
      case 0x2C: // ,
      case 0x3A: // :
      case 0x2A: // *
      case 0x5F: // _
      case 0x7E: // ~
      case 0x27: // '
      case 0x22: // "
        linkEnd--;
      case 0x3B: // ;
        var newEnd = linkEnd - 2;
        while (newEnd > 0 && CmarkCType.isAlpha(data[base + newEnd])) {
          newEnd--;
        }
        if (newEnd >= 0 &&
            newEnd < linkEnd - 2 &&
            data[base + newEnd] == 0x26) {
          linkEnd = newEnd;
        } else {
          linkEnd--;
        }
      default:
        return linkEnd;
    }
  }
  return linkEnd;
}

/// Port of cmark_consolidate_text_nodes for the inline content of [node].
/// C runs it before email postprocessing when the extension is enabled.
void consolidateTextNodes(CmarkNode node) {
  var child = node.firstChild;
  while (child != null) {
    if (child.type != CmarkNodeType.text) {
      if (child.firstChild != null) consolidateTextNodes(child);
      child = child.next;
      continue;
    }
    var next = child.next;
    if (next != null && next.type == CmarkNodeType.text) {
      final merged = StringBuffer(child.contentString);
      while (next != null && next.type == CmarkNodeType.text) {
        merged.write(next.contentString);
        child.endColumn = next.endColumn;
        final remove = next;
        next = next.next;
        remove.unlink();
      }
      child.setLiteral(merged.toString());
    }
    child = next;
  }
}

/// Port of C's email/mailto/xmpp `postprocess` for the inline content of
/// [block]. Text inside links is skipped, as in C; image descriptions are
/// also skipped because they render as plain text.
void applyEmailAutolinks(CmarkNode block) {
  var child = block.firstChild;
  while (child != null) {
    final next = child.next;
    switch (child.type) {
      case CmarkNodeType.link:
      case CmarkNodeType.image:
        break;
      case CmarkNodeType.text:
        _postprocessText(child);
      default:
        if (child.firstChild != null) applyEmailAutolinks(child);
    }
    child = next;
  }
}

typedef _EmailLink = ({int textStart, int linkStart, int linkEnd, String url});

/// Port of postprocess_text, on UTF-16 code units. Every test in the C code
/// is an ASCII test, and code units >= 0x80 fail all of them, as bytes do.
void _postprocessText(CmarkNode text) {
  final s = text.contentString;
  var at = s.indexOf('@');
  if (at < 0) return;

  final links = <_EmailLink>[];
  var start = 0;
  var offset = 0;
  var remaining = s.length;

  outer:
  while (offset < remaining) {
    at = s.indexOf('@', start + offset);
    if (at < 0) break;

    var maxRewind = at - (start + offset);
    var autoMailto = true;
    var isXmpp = false;
    var np = 0;
    var rewind = 0;
    var linkEnd = 0;

    foundAt:
    while (true) {
      final atPos = start + offset + maxRewind;
      for (rewind = 0; rewind < maxRewind; rewind++) {
        final c = s.codeUnitAt(atPos - rewind - 1);
        if (_isAsciiAlnum(c)) continue;
        if (c == 0x2E || c == 0x2B || c == 0x2D || c == 0x5F) continue;
        if (c == 0x3A) {
          if (_validateProtocol(s, 'mailto:', atPos, rewind, maxRewind)) {
            autoMailto = false;
            continue;
          }
          if (_validateProtocol(s, 'xmpp:', atPos, rewind, maxRewind)) {
            autoMailto = false;
            isXmpp = true;
            continue;
          }
        }
        break;
      }

      if (rewind == 0) {
        offset += maxRewind + 1;
        continue outer;
      }

      final limit = remaining - offset - maxRewind;
      for (linkEnd = 1; linkEnd < limit; linkEnd++) {
        final c = s.codeUnitAt(atPos + linkEnd);
        if (_isAsciiAlnum(c)) continue;
        if (c == 0x40) {
          // Another '@': retry from it, with the text between as the rewind.
          offset += maxRewind + 1;
          maxRewind = linkEnd - 1;
          continue foundAt;
        } else if (c == 0x2E &&
            linkEnd < limit - 1 &&
            _isAsciiAlnum(s.codeUnitAt(atPos + linkEnd + 1))) {
          np++;
        } else if (c == 0x2F && isXmpp) {
          continue;
        } else if (c != 0x2D && c != 0x5F) {
          break;
        }
      }
      break;
    }

    final atPos = start + offset + maxRewind;
    if (linkEnd < 2 || np == 0) {
      offset += maxRewind + linkEnd;
      continue;
    }
    final last = s.codeUnitAt(atPos + linkEnd - 1);
    if (!_isAsciiAlpha(last) && last != 0x2E) {
      offset += maxRewind + linkEnd;
      continue;
    }

    linkEnd = _autolinkDelim(s.codeUnits, atPos, linkEnd);
    if (linkEnd == 0) {
      offset += maxRewind + 1;
      continue;
    }

    final linkStart = atPos - rewind;
    final address = s.substring(linkStart, atPos + linkEnd);
    links.add((
      textStart: start,
      linkStart: linkStart,
      linkEnd: atPos + linkEnd,
      url: autoMailto ? 'mailto:$address' : address,
    ));

    start = atPos + linkEnd;
    remaining = s.length - start;
    offset = 0;
  }

  if (links.isEmpty) return;
  _replaceWithLinks(text, s, links);
}

bool _validateProtocol(
    String s, String protocol, int atPos, int rewind, int maxRewind) {
  final len = protocol.length;
  if (len > maxRewind - rewind) return false;
  final protocolStart = atPos - rewind - len;
  if (!s.startsWith(protocol, protocolStart)) return false;
  if (len == maxRewind - rewind) return true;
  return !_isAsciiAlnum(s.codeUnitAt(protocolStart - 1));
}

void _replaceWithLinks(CmarkNode text, String s, List<_EmailLink> links) {
  final parent = text.parent;
  if (parent == null) return;

  var cursor = text;
  void insert(CmarkNode node) {
    parent.insertAfter(cursor, node);
    cursor = node;
  }

  for (final link in links) {
    if (link.linkStart > link.textStart) {
      insert(CmarkNode(CmarkNodeType.text)
        ..setLiteral(s.substring(link.textStart, link.linkStart)));
    }
    final node = CmarkNode(CmarkNodeType.link)
      ..linkData.url = link.url
      ..linkData.title = '';
    node.appendChild(CmarkNode(CmarkNodeType.text)
      ..setLiteral(s.substring(link.linkStart, link.linkEnd)));
    insert(node);
  }
  final tailStart = links.last.linkEnd;
  if (tailStart < s.length) {
    insert(CmarkNode(CmarkNodeType.text)..setLiteral(s.substring(tailStart)));
  }
  text.unlink();
}

bool _isAsciiAlpha(int c) =>
    (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A);
bool _isAsciiAlnum(int c) => _isAsciiAlpha(c) || (c >= 0x30 && c <= 0x39);
