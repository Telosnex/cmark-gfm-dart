import 'case_fold_map.dart';
import 'ctype.dart';
import 'strbuf.dart';
import 'utf8_class.dart';

class CmarkUtf8Result {
  CmarkUtf8Result(this.length, this.codePoint);
  final int length;
  final int codePoint;
  bool get isValid => length > 0 && codePoint >= 0;
}

class CmarkUtf8 {
  static int debugClass(int byte) => kUtf8Class[byte & 0xFF];

  static void check(CmarkStrbuf dest, List<int> line) {
    var i = 0;
    final size = line.length;
    while (i < size) {
      final org = i;
      var charLen = 0;

      while (i < size) {
        final byte = line[i];
        if (byte < 0x80 && byte != 0) {
          i++;
        } else if (byte >= 0x80) {
          charLen = _validate(line, i, size - i);
          if (charLen < 0) {
            charLen = -charLen;
            break;
          }
          i += charLen;
        } else if (byte == 0) {
          charLen = 1;
          break;
        }
      }

      if (i > org) {
        dest.putBytes(line.sublist(org, i));
      }

      if (i >= size) {
        break;
      } else {
        _encodeUnknown(dest);
        i += charLen;
      }
    }
  }

  static CmarkUtf8Result iterate(List<int> bytes, int offset) {
    final remaining = bytes.length - offset;
    if (remaining <= 0) {
      return CmarkUtf8Result(-1, -1);
    }
    final length = _charLength(bytes[offset], remaining);
    if (length <= 0) {
      return CmarkUtf8Result(length, -1);
    }
    final codePoint = _decode(bytes, offset, length);
    if (codePoint < 0) {
      return CmarkUtf8Result(-1, -1);
    }
    return CmarkUtf8Result(length, codePoint);
  }

  static void encodeChar(int codePoint, CmarkStrbuf buf) {
    if (codePoint < 0) {
      _encodeUnknown(buf);
      return;
    }
    if (codePoint < 0x80) {
      buf.putc(codePoint);
    } else if (codePoint < 0x800) {
      buf.putc(0xC0 | (codePoint >> 6));
      buf.putc(0x80 | (codePoint & 0x3F));
    } else if (codePoint < 0x10000) {
      if (codePoint == 0xFFFE) {
        buf.putc(0xFE);
        return;
      }
      if (codePoint == 0xFFFF) {
        buf.putc(0xFF);
        return;
      }
      buf.putc(0xE0 | (codePoint >> 12));
      buf.putc(0x80 | ((codePoint >> 6) & 0x3F));
      buf.putc(0x80 | (codePoint & 0x3F));
    } else if (codePoint < 0x110000) {
      buf.putc(0xF0 | (codePoint >> 18));
      buf.putc(0x80 | ((codePoint >> 12) & 0x3F));
      buf.putc(0x80 | ((codePoint >> 6) & 0x3F));
      buf.putc(0x80 | (codePoint & 0x3F));
    } else {
      _encodeUnknown(buf);
    }
  }

  static void caseFold(CmarkStrbuf dest, List<int> bytes) {
    var offset = 0;
    while (offset < bytes.length) {
      final result = iterate(bytes, offset);
      if (!result.isValid) {
        _encodeUnknown(dest);
        offset++;
        continue;
      }
      final codePoint = result.codePoint;
      final mapped = kCaseFoldMap[codePoint];
      if (mapped != null) {
        for (final value in mapped) {
          encodeChar(value, dest);
        }
      } else {
        encodeChar(codePoint, dest);
      }
      offset += result.length;
    }
  }

  static bool isSpace(int codePoint) {
    return codePoint == 9 ||
        codePoint == 10 ||
        codePoint == 12 ||
        codePoint == 13 ||
        codePoint == 32 ||
        codePoint == 160 ||
        codePoint == 5760 ||
        (codePoint >= 8192 && codePoint <= 8202) ||
        codePoint == 8239 ||
        codePoint == 8287 ||
        codePoint == 12288;
  }

  static bool isPunctuation(int codePoint) {
    if (codePoint < 128) {
      return CmarkCType.isPunct(codePoint);
    }
    const List<int> singles = <int>[
      161,
      167,
      171,
      182,
      183,
      187,
      191,
      894,
      903,
      1417,
      1418,
      1470,
      1472,
      1475,
      1478,
      1523,
      1524,
      1545,
      1546,
      1548,
      1549,
      1563,
      1566,
      1567,
      1748,
      1807,
      1808,
      2416,
      2800,
      3572,
      3663,
      3674,
      3675,
      3860,
      3973,
      4057,
      4058,
      4347,
      4960,
      4968,
      5120,
      5741,
      5742,
      5787,
      5788,
      5941,
      5942,
      6100,
      6101,
      6102,
      6104,
      6105,
      6106,
      6468,
      6469,
      6686,
      6687,
      6816,
      6822,
      6824,
      6829,
      7002,
      7008,
      7164,
      7167,
      7227,
      7231,
      7294,
      7295,
      7379,
      8208,
      8231,
      8240,
      8259,
      8261,
      8273,
      8275,
      8286,
      8317,
      8318,
      8333,
      8334,
      8968,
      8971,
      9001,
      9002,
      10088,
      10101,
      10181,
      10182,
      10214,
      10223,
      10627,
      10648,
      10712,
      10715,
      10748,
      10749,
      11513,
      11516,
      11518,
      11519,
      11632,
      12289,
      12291,
      12296,
      12305,
      12308,
      12319,
      12336,
      12349,
      12448,
      12539,
      42238,
      42239,
      42509,
      42511,
      42611,
      42622,
      42738,
      42743,
      43124,
      43127,
      43214,
      43215,
      43256,
      43258,
      43310,
      43311,
      43359,
      43457,
      43469,
      43486,
      43487,
      43612,
      43615,
      43742,
      43743,
      43760,
      43761,
      44011,
      64830,
      64831,
      65040,
      65049,
      65072,
      65106,
      65108,
      65121,
      65123,
      65128,
      65130,
      65131,
      65306,
      65307,
      65311,
      65312,
      65339,
      65341,
      65343,
      65371,
      65373,
      65375,
      65381,
      65792,
      65794,
      66463,
      66512,
      66927,
      67671,
      67871,
      67903,
      68176,
      68184,
      68223,
      68336,
      68342,
      68409,
      68415,
      68505,
      68508,
      69703,
      69709,
      69819,
      69820,
      69822,
      69825,
      69952,
      69955,
      70004,
      70005,
      70085,
      70088,
      70093,
      71233,
      71235,
      74864,
      74868,
      92782,
      92783,
      92917,
      92983,
      92987,
      92996,
      113823,
    ];

    if (singles.contains(codePoint)) {
      return true;
    }

    const List<List<int>> ranges = <List<int>>[
      [1370, 1375],
      [1470, 1470],
      [1472, 1472],
      [1475, 1475],
      [1478, 1478],
      [1523, 1524],
      [1545, 1546],
      [1548, 1549],
      [1563, 1567],
      [1642, 1645],
      [1792, 1805],
      [2039, 2041],
      [2096, 2110],
      [2142, 2142],
      [2404, 2405],
      [2416, 2416],
      [3844, 3858],
      [3898, 3901],
      [4048, 4052],
      [4170, 4175],
      [4960, 4968],
      [5120, 5120],
      [6144, 6154],
      [6686, 6687],
      [6816, 6822],
      [6824, 6829],
      [7002, 7008],
      [7164, 7167],
      [7227, 7231],
      [7360, 7367],
      [8208, 8231],
      [8240, 8259],
      [8261, 8273],
      [8275, 8286],
      [8317, 8318],
      [8333, 8334],
      [8968, 8971],
      [10088, 10101],
      [10214, 10223],
      [10627, 10648],
      [10712, 10715],
      [10748, 10749],
      [11513, 11516],
      [11776, 11822],
      [11824, 11842],
      [12289, 12291],
      [12296, 12305],
      [12308, 12319],
      [65072, 65106],
      [65108, 65121],
      [65281, 65283],
      [65285, 65290],
      [65292, 65295],
      [65339, 65341],
      [65375, 65381],
      [68176, 68184],
      [68336, 68342],
      [68409, 68415],
      [70004, 70005],
      [70085, 70088],
      [71105, 71113],
      [71233, 71235],
      [7227, 7231],
      [74864, 74868],
      [92782, 92783],
      [92983, 92987],
      [69952, 69955],
    ];

    for (final range in ranges) {
      if (codePoint >= range[0] && codePoint <= range[1]) {
        return true;
      }
    }
    return false;
  }

  static void _encodeUnknown(CmarkStrbuf buf) {
    buf.putBytes(const [0xEF, 0xBF, 0xBD]);
  }

  static int _charLength(int firstByte, int remaining) {
    final classification = kUtf8Class[firstByte & 0xFF];
    if (classification == 0) {
      return -1;
    }
    if (classification > remaining) {
      return -remaining;
    }
    return classification;
  }

  static int _validate(List<int> bytes, int offset, int remaining) {
    final length = _charLength(bytes[offset], remaining);
    if (length <= 0) {
      return length;
    }

    switch (length) {
      case 2:
        if ((bytes[offset + 1] & 0xC0) != 0x80) {
          return -1;
        }
        if (bytes[offset] < 0xC2) {
          return -length;
        }
        break;
      case 3:
        if ((bytes[offset + 1] & 0xC0) != 0x80) {
          return -1;
        }
        if ((bytes[offset + 2] & 0xC0) != 0x80) {
          return -2;
        }
        if (bytes[offset] == 0xE0) {
          if (bytes[offset + 1] < 0xA0) {
            return -length;
          }
        } else if (bytes[offset] == 0xED) {
          if (bytes[offset + 1] >= 0xA0) {
            return -length;
          }
        }
        break;
      case 4:
        if ((bytes[offset + 1] & 0xC0) != 0x80) {
          return -1;
        }
        if ((bytes[offset + 2] & 0xC0) != 0x80) {
          return -2;
        }
        if ((bytes[offset + 3] & 0xC0) != 0x80) {
          return -3;
        }
        if (bytes[offset] == 0xF0) {
          if (bytes[offset + 1] < 0x90) {
            return -length;
          }
        } else if (bytes[offset] >= 0xF4) {
          if (bytes[offset] > 0xF4 || bytes[offset + 1] >= 0x90) {
            return -length;
          }
        }
        break;
    }

    return length;
  }

  static int _decode(List<int> bytes, int offset, int length) {
    switch (length) {
      case 1:
        return bytes[offset];
      case 2:
        final value =
            ((bytes[offset] & 0x1F) << 6) | (bytes[offset + 1] & 0x3F);
        return value < 0x80 ? -1 : value;
      case 3:
        final value = ((bytes[offset] & 0x0F) << 12) |
            ((bytes[offset + 1] & 0x3F) << 6) |
            (bytes[offset + 2] & 0x3F);
        if (value < 0x800 || (value >= 0xD800 && value < 0xE000)) {
          return -1;
        }
        return value;
      case 4:
        final value = ((bytes[offset] & 0x07) << 18) |
            ((bytes[offset + 1] & 0x3F) << 12) |
            ((bytes[offset + 2] & 0x3F) << 6) |
            (bytes[offset + 3] & 0x3F);
        if (value < 0x10000 || value >= 0x110000) {
          return -1;
        }
        return value;
      default:
        return -1;
    }
  }
}
