import 'dart:convert';

/// Port of houdini_escape_href from houdini_href_e.c
/// Escapes a URL for use in href attribute
String escapeHref(String url) {
  final bytes = utf8.encode(url);
  final result = StringBuffer();
  
  for (var i = 0; i < bytes.length; i++) {
    final byte = bytes[i];
    
    if (_isHrefSafe(byte)) {
      result.writeCharCode(byte);
    } else if (byte == 0x26) { // &
      result.write('&amp;');
    } else if (byte == 0x27) { // '
      result.write('&#x27;');
    } else {
      // Percent-encode
      result.write('%');
      result.write(byte.toRadixString(16).toUpperCase().padLeft(2, '0'));
    }
  }
  
  return result.toString();
}

/// Characters safe in href (from HREF_SAFE table in C)
/// -_.+!*'(),%#@?=;:/,+&$~ alphanum
bool _isHrefSafe(int byte) {
  // Alphanumeric
  if ((byte >= 0x30 && byte <= 0x39) || // 0-9
      (byte >= 0x41 && byte <= 0x5A) || // A-Z
      (byte >= 0x61 && byte <= 0x7A)) { // a-z
    return true;
  }
  
  // Special URL-safe characters
  switch (byte) {
    case 0x21: // !
    case 0x23: // #
    case 0x24: // $
    case 0x25: // %
    case 0x28: // (
    case 0x29: // )
    case 0x2A: // *
    case 0x2B: // +
    case 0x2C: // ,
    case 0x2D: // -
    case 0x2E: // .
    case 0x2F: // /
    case 0x3A: // :
    case 0x3B: // ;
    case 0x3D: // =
    case 0x3F: // ?
    case 0x40: // @
    case 0x5F: // _
    case 0x7E: // ~
      return true;
    default:
      return false;
  }
}
