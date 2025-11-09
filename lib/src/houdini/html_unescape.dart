import '../util/strbuf.dart';
import '../util/utf8.dart';
import 'entities.dart';

class HoudiniHtmlUnescape {
  static bool unescape(CmarkStrbuf dest, List<int> src) {
    var i = 0;
    var wroteAny = false;

    while (i < src.length) {
      final start = i;
      while (i < src.length && src[i] != 0x26) {
        i++;
      }
      if (i > start) {
        dest.putBytes(src.sublist(start, i));
        wroteAny = true;
      }

      if (i >= src.length) {
        break;
      }

      i++; // skip '&'
      final consumed = unescapeEntity(dest, src, i);
      if (consumed > 0) {
        i += consumed;
        wroteAny = true;
      } else {
        dest.putc(0x26);
        wroteAny = true;
      }
    }

    return wroteAny;
  }

  static int unescapeEntity(CmarkStrbuf dest, List<int> src, int offset) {
    if (offset >= src.length) {
      return 0;
    }

    var i = offset;
    if (src[i] == 0x23) {
      i++;
      var codePoint = 0;
      var digits = 0;
      if (i < src.length && _isDigit(src[i])) {
        while (i < src.length && _isDigit(src[i])) {
          codePoint = (codePoint * 10) + (src[i] - 0x30);
          if (codePoint >= 0x110000) {
            codePoint = 0x110000;
          }
          i++;
        }
        digits = i - offset - 1;
      } else if (i < src.length && (src[i] == 0x78 || src[i] == 0x58)) {
        i++;
        while (i < src.length && _isHexDigit(src[i])) {
          codePoint = (codePoint * 16) + _hexValue(src[i]);
          if (codePoint >= 0x110000) {
            codePoint = 0x110000;
          }
          i++;
        }
        digits = i - offset - 2;
      }

      if (digits >= 1 && digits <= 8 && i < src.length && src[i] == 0x3B) {
        if (codePoint == 0 ||
            (codePoint >= 0xD800 && codePoint < 0xE000) ||
            codePoint >= 0x110000) {
          codePoint = 0xFFFD;
        }
        CmarkUtf8.encodeChar(codePoint, dest);
        return i - offset + 1;
      }
      return 0;
    }

    final maxEnd = (src.length < offset + kEntityMaxLength)
        ? src.length
        : offset + kEntityMaxLength;
    var end = offset;
    while (end < maxEnd && src[end] != 0x3B && src[end] != 0x20) {
      end++;
    }

    if (end < src.length && src[end] == 0x3B) {
      final length = end - offset;
      if (length >= kEntityMinLength) {
        final name = String.fromCharCodes(src.sublist(offset, end));
        final value = kHtmlEntities[name];
        if (value != null) {
          dest.putBytes(value);
          return length + 1;
        }
      }
    }

    return 0;
  }

  static bool _isDigit(int byte) => byte >= 0x30 && byte <= 0x39;

  static bool _isHexDigit(int byte) =>
      (byte >= 0x30 && byte <= 0x39) ||
      (byte >= 0x41 && byte <= 0x46) ||
      (byte >= 0x61 && byte <= 0x66);

  static int _hexValue(int byte) {
    if (byte >= 0x30 && byte <= 0x39) {
      return byte - 0x30;
    }
    if (byte >= 0x41 && byte <= 0x46) {
      return byte - 0x41 + 10;
    }
    return byte - 0x61 + 10;
  }
}
