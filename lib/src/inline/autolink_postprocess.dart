import 'dart:convert';
import 'dart:typed_data';

import '../inline/link_parsing.dart';
import '../node.dart';
import '../util/node_iterator.dart';

/// Post-process text nodes to add GFM autolinks (www/http/email/mailto/xmpp).
void applyAutolinks(CmarkNode root) {
  _mergeAdjacentTextNodes(root);
  final iter = CmarkIter(root);
  var depthInLink = 0;

  while (true) {
    final event = iter.next();
    if (event == CmarkEventType.done) {
      break;
    }

    final node = iter.node;

    switch (node.type) {
      case CmarkNodeType.link:
      case CmarkNodeType.image:
        if (event == CmarkEventType.enter) {
          depthInLink++;
        } else if (event == CmarkEventType.exit && depthInLink > 0) {
          depthInLink--;
        }
        continue;
      default:
        break;
    }

    if (depthInLink > 0) {
      continue;
    }

    if (event == CmarkEventType.enter && node.type == CmarkNodeType.text) {
      if (_isSuppressedContext(node)) {
        continue;
      }
      _processTextNode(node);
    }
  }
}

bool _isSuppressedContext(CmarkNode node) {
  var current = node.parent;
  while (current != null) {
    switch (current.type) {
      case CmarkNodeType.code:
      case CmarkNodeType.codeBlock:
      case CmarkNodeType.htmlBlock:
      case CmarkNodeType.htmlInline:
        return true;
      default:
        current = current.parent;
        break;
    }
  }
  return false;
}

class _AutolinkMatch {
  _AutolinkMatch(this.start, this.end, this.url, this.text);

  final int start; // byte index
  final int end; // byte index
  final String url;
  final String text;
}

void _processTextNode(CmarkNode node) {
  final literal = node.content.toString();
  if (literal.isEmpty) {
    return;
  }

  final data = Uint8List.fromList(utf8.encode(literal));
  final matches = <_AutolinkMatch>[];

  var index = 0;
  while (index < data.length) {
    _AutolinkMatch? match;
    final byte = data[index];

    if (_matchesMailtoPrefix(data, index)) {
      match = _matchMailto(data, index);
    }

    if (match == null && _matchesXmppPrefix(data, index)) {
      match = _matchXmpp(data, index);
    }

    if (match == null && _matchesSchemePrefix(byte)) {
      match = _matchUrlScheme(data, index);
    }

    if (match == null && (byte == 0x77 || byte == 0x57)) {
      match = _matchWWW(data, index);
    }

    if (match == null && byte == 0x40) {
      match = _matchBareEmail(data, index);
    }

    if (match != null &&
        !_isWithinAngleBrackets(data, match.start, match.end)) {
      matches.add(match);
      index = match.end;
    } else {
      index++;
    }
  }

  if (matches.isEmpty) {
    return;
  }

  // print('matches ${matches.length} for $literal');

  _replaceTextWithMatches(node, data, matches);
}

void _replaceTextWithMatches(
  CmarkNode node,
  Uint8List data,
  List<_AutolinkMatch> matches,
) {
  final parent = node.parent;
  if (parent == null) {
    return;
  }

  var last = 0;
  var cursor = node;

  for (final match in matches) {
    if (match.start < last) {
      continue; // overlapping match - skip
    }

    var spanStart = match.start;
    var spanEnd = match.end;
    final hasAngleWrappers = match.start > 0 &&
        match.end < data.length &&
        data[match.start - 1] == 0x3C &&
        data[match.end] == 0x3E;
    if (hasAngleWrappers) {
      spanStart = match.start - 1;
      spanEnd = match.end + 1;
    }

    if (spanStart > last) {
      final text =
          utf8.decode(data.sublist(last, spanStart), allowMalformed: true);
      if (text.isNotEmpty) {
        final textNode = CmarkNode(CmarkNodeType.text)..content.write(text);
        parent.insertAfter(cursor, textNode);
        cursor = textNode;
      }
    }

    final url = cleanUrl(match.url);
    if (url.isNotEmpty) {
      final link = CmarkNode(CmarkNodeType.link)
        ..linkData.url = url
        ..linkData.title = '';
      final textNode = CmarkNode(CmarkNodeType.text)..content.write(match.text);
      link.appendChild(textNode);
      parent.insertAfter(cursor, link);
      cursor = link;
      _trimAdjacentAngleBrackets(link);
    }

    last = spanEnd;
  }

  if (last < data.length) {
    final trailing = utf8.decode(data.sublist(last), allowMalformed: true);
    if (trailing.isNotEmpty) {
      final textNode = CmarkNode(CmarkNodeType.text)..content.write(trailing);
      parent.insertAfter(cursor, textNode);
      cursor = textNode;
    }
  }

  node.unlink();
}

void _mergeAdjacentTextNodes(CmarkNode root) {
  final iter = CmarkIter(root);
  while (true) {
    final event = iter.next();
    if (event == CmarkEventType.done) {
      break;
    }
    final node = iter.node;
    if (event != CmarkEventType.enter) {
      continue;
    }
    var child = node.firstChild;
    while (child != null) {
      if (child.type == CmarkNodeType.text) {
        var next = child.next;
        while (next != null && next.type == CmarkNodeType.text) {
          child.content.write(next.content.toString());
          final toRemove = next;
          next = next.next;
          toRemove.unlink();
        }
        child = next;
      } else {
        child = child.next;
      }
    }
  }
}

void _trimAdjacentAngleBrackets(CmarkNode link) {
  final prev = link.previous;
  if (prev != null && prev.type == CmarkNodeType.text) {
    final text = prev.content.toString();
    if (text.endsWith('<')) {
      final updated = text.substring(0, text.length - 1);
      prev.content
        ..clear()
        ..write(updated);
      if (updated.isEmpty) {
        prev.unlink();
      }
    }
  }

  final next = link.next;
  if (next != null && next.type == CmarkNodeType.text) {
    final text = next.content.toString();
    if (text.startsWith('>')) {
      final updated = text.substring(1);
      next.content
        ..clear()
        ..write(updated);
      if (updated.isEmpty) {
        next.unlink();
      }
    }
  }
}

bool _matchesMailtoPrefix(Uint8List data, int index) {
  const mailto = 'mailto:';
  return _startsWithIgnoreCase(data, index, mailto);
}

bool _matchesXmppPrefix(Uint8List data, int index) {
  const xmpp = 'xmpp:';
  return _startsWithIgnoreCase(data, index, xmpp);
}

bool _matchesSchemePrefix(int byte) {
  final lower = _toLower(byte);
  return lower == 0x68 || lower == 0x66; // h or f (http/https/ftp)
}

_AutolinkMatch? _matchMailto(Uint8List data, int index) {
  if (!_hasBoundaryBefore(data, index)) {
    return null;
  }

  const mailto = 'mailto:';
  if (!_startsWithIgnoreCase(data, index, mailto)) {
    return null;
  }

  final schemeEnd = index + mailto.length;
  final email = _scanEmailFrom(data, schemeEnd);
  if (email == null) {
    return null;
  }

  var end = email.end;
  final trimmed = _autolinkDelim(data, index, end - index);
  if (trimmed <= schemeEnd) {
    return null;
  }

  final text = utf8.decode(data.sublist(index, trimmed), allowMalformed: true);
  return _AutolinkMatch(index, trimmed, text, text);
}

_AutolinkMatch? _matchXmpp(Uint8List data, int index) {
  if (!_hasBoundaryBefore(data, index)) {
    return null;
  }

  const xmpp = 'xmpp:';
  if (!_startsWithIgnoreCase(data, index, xmpp)) {
    return null;
  }

  var end = index + xmpp.length;
  final email = _scanEmailFrom(data, end);
  if (email == null) {
    return null;
  }

  end = email.end;
  while (end < data.length && data[end] == 0x2F) {
    end++;
    while (end < data.length && !_isTerminator(data[end])) {
      end++;
    }
    break;
  }

  final trimmed = _autolinkDelim(data, index, end - index);
  if (trimmed <= index + xmpp.length) {
    return null;
  }

  final text = utf8.decode(data.sublist(index, trimmed), allowMalformed: true);
  return _AutolinkMatch(index, trimmed, text, text);
}

_AutolinkMatch? _matchUrlScheme(Uint8List data, int index) {
  if (index > 0 && _isAsciiAlnum(data[index - 1])) {
    return null;
  }

  const schemes = ['http://', 'https://', 'ftp://'];
  List<int>? matched;
  for (final scheme in schemes) {
    if (_startsWithIgnoreCase(data, index, scheme)) {
      matched = utf8.encode(scheme);
      break;
    }
  }

  if (matched == null) {
    return null;
  }

  var end = index + matched.length;
  if (end >= data.length) {
    return null;
  }

  if (!_isValidHostChar(data[end])) {
    return null;
  }

  final domainLen = _scanDomain(data, end, allowShort: true);
  if (domainLen == 0) {
    return null;
  }

  final domainStart = end;
  final domainText = utf8.decode(
    data.sublist(domainStart, domainStart + domainLen),
    allowMalformed: true,
  );
  if (_hasInvalidUnderscore(domainText)) {
    return null;
  }

  end += domainLen;
  while (end < data.length && !_isTerminator(data[end])) {
    end++;
  }

  final trimmed = _autolinkDelim(data, index, end - index);
  if (trimmed <= index + matched.length) {
    return null;
  }

  final text = utf8.decode(data.sublist(index, trimmed), allowMalformed: true);
  return _AutolinkMatch(index, trimmed, text, text);
}

_AutolinkMatch? _matchWWW(Uint8List data, int index) {
  const prefix = 'www.';
  if (!_startsWithIgnoreCase(data, index, prefix)) {
    return null;
  }
  if (!_hasBoundaryBefore(data, index)) {
    return null;
  }

  var end = index + prefix.length;
  final domainLen = _scanDomain(data, end, allowShort: false);
  if (domainLen == 0) {
    return null;
  }
  end += domainLen;

  final domainStart = index + prefix.length;
  final domainText = utf8.decode(
    data.sublist(domainStart, domainStart + domainLen),
    allowMalformed: true,
  );
  if (_hasInvalidUnderscore(domainText)) {
    return null;
  }

  while (end < data.length && !_isTerminator(data[end])) {
    end++;
  }

  final trimmed = _autolinkDelim(data, index, end - index);
  if (trimmed <= index + prefix.length) {
    return null;
  }

  final text = utf8.decode(data.sublist(index, trimmed), allowMalformed: true);
  final url = 'http://$text';
  return _AutolinkMatch(index, trimmed, url, text);
}

_AutolinkMatch? _matchBareEmail(Uint8List data, int atIndex) {
  final match = _scanEmail(data, atIndex + 1, atSignIndex: atIndex);
  if (match == null) {
    return null;
  }
  final start = match.start;
  if (!_hasBoundaryBefore(data, start)) {
    return null;
  }

  final trimmed = _autolinkDelim(data, start, match.end - start);
  if (trimmed <= atIndex) {
    return null;
  }

  final text = utf8.decode(data.sublist(start, trimmed), allowMalformed: true);
  return _AutolinkMatch(start, trimmed, 'mailto:$text', text);
}

typedef _EmailScanResult = ({int start, int end});

_EmailScanResult? _scanEmail(Uint8List data, int domainStart,
    {int? atSignIndex}) {
  final atIndex = atSignIndex ?? (domainStart - 1);
  var localStart = atIndex - 1;
  while (localStart >= 0) {
    final byte = data[localStart];
    if (_isEmailLocalChar(byte)) {
      localStart--;
    } else {
      break;
    }
  }
  localStart++;
  if (localStart >= atIndex) {
    return null;
  }

  var end = domainStart;
  var dotCount = 0;
  while (end < data.length) {
    final byte = data[end];
    if (_isAsciiAlnum(byte)) {
      end++;
      continue;
    }
    if (byte == 0x2F) {
      break;
    }
    if (byte == 0x2E && end + 1 < data.length && _isAsciiAlnum(data[end + 1])) {
      dotCount++;
      end++;
      continue;
    }
    if (byte == 0x2D || byte == 0x5F) {
      end++;
      continue;
    }
    break;
  }

  if (dotCount == 0 || end == domainStart) {
    return null;
  }

  final last = data[end - 1];
  if (!_isAsciiAlpha(last) && last != 0x2E) {
    return null;
  }

  return (start: localStart, end: end);
}

_EmailScanResult? _scanEmailFrom(Uint8List data, int start) {
  var at = start;
  while (at < data.length && data[at] != 0x40) {
    at++;
  }
  if (at >= data.length) {
    return null;
  }
  return _scanEmail(data, at + 1, atSignIndex: at);
}

bool _startsWithIgnoreCase(Uint8List data, int index, String pattern) {
  final bytes = utf8.encode(pattern);
  if (index + bytes.length > data.length) {
    return false;
  }
  for (var i = 0; i < bytes.length; i++) {
    if (_toLower(data[index + i]) != _toLower(bytes[i])) {
      return false;
    }
  }
  return true;
}

bool _hasBoundaryBefore(Uint8List data, int index) {
  if (index == 0) {
    return true;
  }
  final prev = data[index - 1];
  return !_isAsciiAlnum(prev);
}

bool _isTerminator(int byte) =>
    _isWhitespace(byte) || byte == 0x3C || byte == 0x3E;

bool _isWhitespace(int byte) {
  return byte == 0 ||
      byte == 0x20 ||
      byte == 0x09 ||
      byte == 0x0A ||
      byte == 0x0B ||
      byte == 0x0C ||
      byte == 0x0D;
}

bool _isAsciiAlpha(int byte) =>
    (byte >= 0x41 && byte <= 0x5A) || (byte >= 0x61 && byte <= 0x7A);
bool _isAsciiDigit(int byte) => byte >= 0x30 && byte <= 0x39;
bool _isAsciiAlnum(int byte) => _isAsciiAlpha(byte) || _isAsciiDigit(byte);

int _toLower(int byte) {
  if (byte >= 0x41 && byte <= 0x5A) {
    return byte + 0x20;
  }
  return byte;
}

bool _isValidHostChar(int byte) {
  if (byte >= 0x80) {
    return true;
  }
  if (_isWhitespace(byte)) {
    return false;
  }
  switch (byte) {
    case 0x21:
    case 0x22:
    case 0x23:
    case 0x24:
    case 0x25:
    case 0x26:
    case 0x27:
    case 0x28:
    case 0x29:
    case 0x2A:
    case 0x2B:
    case 0x2C:
    case 0x3A:
    case 0x3B:
    case 0x3C:
    case 0x3D:
    case 0x3E:
    case 0x3F:
    case 0x40:
    case 0x5B:
    case 0x5C:
    case 0x5D:
    case 0x5E:
    case 0x60:
    case 0x7B:
    case 0x7C:
    case 0x7D:
      return false;
    default:
      return true;
  }
}

int _scanDomain(Uint8List data, int start, {required bool allowShort}) {
  var i = start;
  var dotCount = 0;
  var uscore1 = 0;
  var uscore2 = 0;

  while (i < data.length) {
    final byte = data[i];
    if (byte == 0x5C && i + 1 < data.length) {
      i += 2;
      continue;
    }
    if (byte == 0x5F) {
      uscore2++;
      i++;
      continue;
    }
    if (byte == 0x2F) {
      break;
    }
    if (byte == 0x2E) {
      uscore1 = uscore2;
      uscore2 = 0;
      dotCount++;
      i++;
      continue;
    }
    if (!_isValidHostChar(byte) && byte != 0x2D) {
      break;
    }
    i++;
  }

  if (!allowShort && dotCount == 0) {
    return 0;
  }

  if ((uscore1 > 0 || uscore2 > 0) && dotCount <= 10) {
    return 0;
  }

  return i - start;
}

bool _hasInvalidUnderscore(String domain) {
  final parts = domain.split('.');
  if (parts.length < 2) {
    return false;
  }
  bool containsUnderscore(String part) => part.contains('_');
  final last = parts.last;
  final secondLast = parts[parts.length - 2];
  final dotCount = parts.length - 1;
  if (dotCount > 10) {
    return false;
  }
  return containsUnderscore(last) || containsUnderscore(secondLast);
}

bool _isWithinAngleBrackets(Uint8List data, int start, int end) {
  var before = start - 1;
  var hasSpaceBefore = false;
  while (before >= 0 && (data[before] == 0x20 || data[before] == 0x09)) {
    hasSpaceBefore = true;
    before--;
  }
  if (before < 0 || data[before] != 0x3C) {
    return false;
  }

  var hasSpaceAfter = false;
  var hasExtraAfter = false;
  for (var i = end; i < data.length; i++) {
    final ch = data[i];
    if (ch == 0x3E) {
      return hasSpaceBefore || hasSpaceAfter || hasExtraAfter;
    }
    if (ch == 0x0A || ch == 0x0D) {
      break;
    }
    if (ch == 0x20 || ch == 0x09) {
      hasSpaceAfter = true;
      continue;
    }
    hasExtraAfter = true;
  }
  return false;
}

// Trim trailing punctuation similar to autolink_delim in cmark.
int _autolinkDelim(List<int> data, int start, int linkEnd) {
  var closing = 0;
  var opening = 0;

  for (var i = start; i < start + linkEnd; i++) {
    final byte = data[i];
    if (byte == 0x28) {
      opening++;
    } else if (byte == 0x29) {
      closing++;
    }
  }

  while (linkEnd > 0) {
    final ch = data[start + linkEnd - 1];

    if (ch == 0x29) {
      if (closing <= opening) {
        return linkEnd + start;
      }
      closing--;
      linkEnd--;
      continue;
    }

    if (ch == 0x3F ||
        ch == 0x21 ||
        ch == 0x2E ||
        ch == 0x2C ||
        ch == 0x3A ||
        ch == 0x2A ||
        ch == 0x5F ||
        ch == 0x7E ||
        ch == 0x27 ||
        ch == 0x22) {
      linkEnd--;
      continue;
    }

    if (ch == 0x3B) {
      var entityStart = start + linkEnd - 2;
      while (entityStart > start && _isAsciiAlpha(data[entityStart])) {
        entityStart--;
      }
      if (entityStart > start && data[entityStart] == 0x26) {
        linkEnd = entityStart - start;
        continue;
      }
      linkEnd--;
      continue;
    }

    break;
  }

  return start + linkEnd;
}

bool _isEmailLocalChar(int byte) {
  if (_isAsciiAlnum(byte)) {
    return true;
  }
  switch (byte) {
    case 0x2E:
    case 0x21:
    case 0x23:
    case 0x24:
    case 0x25:
    case 0x26:
    case 0x27:
    case 0x2A:
    case 0x2B:
    case 0x2D:
    case 0x3D:
    case 0x3F:
    case 0x5E:
    case 0x5F:
    case 0x60:
    case 0x7B:
    case 0x7C:
    case 0x7D:
    case 0x7E:
      return true;
    default:
      return false;
  }
}
