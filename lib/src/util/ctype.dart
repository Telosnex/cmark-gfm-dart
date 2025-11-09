/// Locale-independent ASCII character classification helpers.
///
/// These mirror the functions exposed by cmark-gfm's `cmark_ctype.{c,h}` so
/// the parser behaves deterministically regardless of system locale.
class CmarkCType {
  static const List<int> _classTable = <int>[
    // 0x0x
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, // 0x0
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 0x1
    1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, // 0x2
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, // 0x3
    2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, // 0x4
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 2, 2, 2, 2, // 0x5
    2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, // 0x6
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 2, 2, 2, 0, // 0x7
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 0x8
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 0x9
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 0xa
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 0xb
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 0xc
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 0xd
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 0xe
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 0xf
  ];

  static bool isSpace(int charCode) => _class(charCode) == 1;
  static bool isPunct(int charCode) => _class(charCode) == 2;
  static bool isDigit(int charCode) => _class(charCode) == 3;
  static bool isAlnum(int charCode) {
    final value = _class(charCode);
    return value == 3 || value == 4;
  }

  static bool isAlpha(int charCode) => _class(charCode) == 4;

  static int _class(int charCode) {
    if (charCode < 0 || charCode > 0xFF) {
      return 0;
    }
    return _classTable[charCode];
  }
}
