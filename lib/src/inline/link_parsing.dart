import 'dart:typed_data';
import 'dart:convert';
import '../util/strbuf.dart';
import '../houdini/html_unescape.dart' as houdini;

const int maxLinkLabelLength = 1000;

/// Parse a link label. Returns true if successful and fills rawLabel.
/// Note: unescaped brackets are not allowed in labels.
/// From link_label() in inlines.c
bool linkLabel(Uint8List input, int startPos, LinkLabelResult result) {
  var pos = startPos;
  var length = 0;
  
  // Advance past [
  if (pos >= input.length || input[pos] != 0x5B) {
    return false;
  }
  pos++;
  
  final labelStart = pos;
  
  while (pos < input.length) {
    final c = input[pos];
    
    if (c == 0x5B || c == 0x5D) {
      if (c == 0x5D) {
        // Match found
        result.label = utf8.decode(input.sublist(labelStart, pos), allowMalformed: true).trim();
        result.endPos = pos + 1; // past ]
        return true;
      } else {
        // Nested [ not allowed
        return false;
      }
    }
    
    if (c == 0x5C) { // backslash
      pos++;
      length++;
      if (pos < input.length && _isPunct(input[pos])) {
        pos++;
        length++;
      }
    } else {
      pos++;
      length++;
    }
    
    if (length > maxLinkLabelLength) {
      return false;
    }
  }
  
  // No closing ] found
  return false;
}

/// Scan link URL in (url) or <url> form.
/// From manual_scan_link_url() in inlines.c
int scanLinkUrl(Uint8List input, int offset, LinkUrlResult result) {
  if (offset >= input.length) {
    return -1;
  }
  
  var pos = offset;
  
  // Check for <url> form
  if (input[pos] == 0x3C) {
    pos++;
    final urlStart = pos;
    
    while (pos < input.length) {
      final c = input[pos];
      if (c == 0x3E) {
        // Found closing >
        result.url = utf8.decode(input.sublist(urlStart, pos), allowMalformed: true);
        return pos + 1 - offset; // Length including < and >
      } else if (c == 0x5C) {
        // Backslash
        pos += 2;
      } else if (c == 0x0A || c == 0x3C) {
        // Newline or nested < - invalid
        return -1;
      } else {
        pos++;
      }
    }
    return -1; // No closing >
  }
  
  // Bare URL form - scan with balanced parens
  return _scanLinkUrlBare(input, offset, result);
}

int _scanLinkUrlBare(Uint8List input, int offset, LinkUrlResult result) {
  var pos = offset;
  var parenCount = 0;
  final urlStart = pos;
  
  while (pos < input.length) {
    final c = input[pos];

    if (c == 0x5C && pos + 1 < input.length && _isPunct(input[pos + 1])) {
      pos += 2;
      continue;
    }

    if (c == 0x28) {
      parenCount++;
      pos++;
      if (parenCount > 32) {
        return -1;
      }
      continue;
    }

    if (c == 0x29) {
      if (parenCount == 0) {
        break;
      }
      parenCount--;
      pos++;
      continue;
    }

    final decoded = _decodeCodePoint(input, pos);
    final codePoint = decoded.value;
    final length = decoded.length;

    if (_isSpace(codePoint)) {
      if (pos == offset) {
        return -1;
      }
      break;
    }

    pos += length;
  }
  
  // EOF without closing paren is invalid
  if (pos >= input.length) {
    return -1;
  }
  
  // Empty URL is valid - return 0
  result.url = utf8.decode(input.sublist(urlStart, pos), allowMalformed: true);
  return pos - offset;
}

/// Scan URL for reference definition (ends at whitespace, not paren)
/// Port of manual_scan_link_url_2 from inlines.c
int scanLinkUrlForReference(Uint8List input, int offset, LinkUrlResult result) {
  var pos = offset;
  var parenCount = 0;
  final urlStart = pos;
  
  // Check for <url> form first
  if (pos < input.length && input[pos] == 0x3C) {
    pos++;
    final innerStart = pos;
    
    while (pos < input.length) {
      final c = input[pos];
      if (c == 0x3E) {
        // Found closing >
        result.url = utf8.decode(input.sublist(innerStart, pos), allowMalformed: true);
        return pos + 1 - offset; // Include < and >
      } else if (c == 0x5C) {
        // Backslash
        pos += 2;
      } else if (c == 0x0A || c == 0x3C) {
        // Newline or nested < - invalid
        return -1;
      } else {
        pos++;
      }
    }
    return -1; // No closing >
  }
  
  // Bare URL form - scan until whitespace or EOF
  while (pos < input.length) {
    final c = input[pos];

    if (c == 0x5C && pos + 1 < input.length && _isPunct(input[pos + 1])) {
      pos += 2;
      continue;
    }

    if (c == 0x28) {
      parenCount++;
      pos++;
      if (parenCount > 32) {
        return -1;
      }
      continue;
    }

    if (c == 0x29) {
      if (parenCount == 0) {
        break;
      }
      parenCount--;
      pos++;
      continue;
    }

    final decoded = _decodeCodePoint(input, pos);
    final codePoint = decoded.value;
    final length = decoded.length;

    if (_isSpace(codePoint)) {
      if (pos == offset) {
        return -1;
      }
      break;
    }

    pos += length;
  }
  
  // Empty or whitespace is valid for reference definitions
  result.url = utf8.decode(input.sublist(urlStart, pos), allowMalformed: true);
  return pos - offset;
}

bool _isSpace(int c) =>
    c == 0x20 ||
    c == 0x09 ||
    c == 0x0A ||
    c == 0x0D;
bool _isPunct(int c) {
  return (c >= 0x21 && c <= 0x2F) ||
         (c >= 0x3A && c <= 0x40) ||
         (c >= 0x5B && c <= 0x60) ||
         (c >= 0x7B && c <= 0x7E);
}

class LinkLabelResult {
  String label = '';
  int endPos = 0;
}

class LinkUrlResult {
  String url = '';
}

class LinkTitleResult {
  String title = '';
}

/// Scan link title: "title", 'title', or (title)
/// From scan_link_title() in scanners.c
int scanLinkTitle(Uint8List input, int offset, LinkTitleResult result) {
  if (offset >= input.length) {
    return 0;
  }
  
  final openDelim = input[offset];
  int closeDelim;
  
  if (openDelim == 0x22) { // "
    closeDelim = 0x22;
  } else if (openDelim == 0x27) { // '
    closeDelim = 0x27;
  } else if (openDelim == 0x28) { // (
    closeDelim = 0x29; // )
  } else {
    return 0;
  }
  
  var pos = offset + 1;
  
  while (pos < input.length) {
    final c = input[pos];
    
    if (c == closeDelim) {
      // Found closing delimiter
      final titleBytes = input.sublist(offset + 1, pos);
      result.title = utf8.decode(titleBytes, allowMalformed: true);
      return pos + 1 - offset; // Length including delimiters
    } else if (c == 0x5C && pos + 1 < input.length) {
      // Backslash escape
      pos += 2;
    } else if (c == 0x0A) {
      // Newline is allowed in titles
      pos++;
    } else {
      pos++;
    }
  }
  
  return 0; // No closing delimiter
}

/// Clean a URL: remove surrounding whitespace and unescape.
/// From cmark_clean_url() in inlines.c
String cleanUrl(String url) {
  var trimmed = url.trim();
  if (trimmed.isEmpty) {
    return '';
  }
  
  final buf = CmarkStrbuf();
  final bytes = utf8.encode(trimmed);
  houdini.HoudiniHtmlUnescape.unescape(buf, bytes);
  
  // Also unescape backslash-escaped punctuation (cmark_strbuf_unescape)
  final unescaped = utf8.decode(buf.detach(), allowMalformed: true);
  final result = _strbufUnescape(unescaped);
  return result;
}

/// Clean a title: remove quotes and unescape.
/// From cmark_clean_title() in inlines.c
String cleanTitle(String title) {
  if (title.isEmpty) {
    return '';
  }
  
  var content = title;
  final first = title.codeUnitAt(0);
  final last = title.codeUnitAt(title.length - 1);
  
  // Remove surrounding quotes if any
  if ((first == 0x27 && last == 0x27) || // ''
      (first == 0x28 && last == 0x29) || // ()
      (first == 0x22 && last == 0x22)) { // ""
    content = title.substring(1, title.length - 1);
  }
  
  final buf = CmarkStrbuf();
  final bytes = utf8.encode(content);
  houdini.HoudiniHtmlUnescape.unescape(buf, bytes);
  
  final unescaped = utf8.decode(buf.detach(), allowMalformed: true);
  return _strbufUnescape(unescaped);
}

/// Port of cmark_strbuf_unescape - removes backslashes before punctuation
String _strbufUnescape(String s) {
  final result = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (s.codeUnitAt(i) == 0x5C && i + 1 < s.length && _isPunct(s.codeUnitAt(i + 1))) {
      // Skip backslash before punctuation
      i++;
      result.writeCharCode(s.codeUnitAt(i));
    } else {
      result.writeCharCode(s.codeUnitAt(i));
    }
  }
  return result.toString();
}

_CodepointResult _decodeCodePoint(Uint8List data, int pos) {
  final first = data[pos];
  if (first < 0x80) {
    return _CodepointResult(first, 1);
  } else if ((first & 0xE0) == 0xC0 && pos + 1 < data.length) {
    final second = data[pos + 1] & 0x3F;
    final value = ((first & 0x1F) << 6) | second;
    return _CodepointResult(value, 2);
  } else if ((first & 0xF0) == 0xE0 && pos + 2 < data.length) {
    final second = data[pos + 1] & 0x3F;
    final third = data[pos + 2] & 0x3F;
    final value = ((first & 0x0F) << 12) | (second << 6) | third;
    return _CodepointResult(value, 3);
  } else if ((first & 0xF8) == 0xF0 && pos + 3 < data.length) {
    final second = data[pos + 1] & 0x3F;
    final third = data[pos + 2] & 0x3F;
    final fourth = data[pos + 3] & 0x3F;
    final value =
        ((first & 0x07) << 18) | (second << 12) | (third << 6) | fourth;
    return _CodepointResult(value, 4);
  }
  return _CodepointResult(first, 1);
}

class _CodepointResult {
  _CodepointResult(this.value, this.length);

  final int value;
  final int length;
}
