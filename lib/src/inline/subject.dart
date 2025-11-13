import 'dart:typed_data';

import '../reference/reference_map.dart';
import '../footnote/footnote_map.dart';
import 'delimiter.dart';

const int maxBackticks = 80;

/// Subject for inline parsing - tracks state during parsing.
/// From inlines.c subject struct.
class Subject {
  Subject({
    required this.refmap,
    required this.footnoteMap,
  })  : input = Uint8List(0),
        line = 0,
        blockOffset = 0;

  Uint8List input;
  final CmarkReferenceMap refmap;
  final CmarkFootnoteMap footnoteMap;

  int line;
  int pos = 0;
  int blockOffset;
  int columnOffset = 0;

  Delimiter? lastDelim;
  Bracket? lastBracket;

  final List<int> backticks = List.filled(maxBackticks + 1, 0);
  bool scannedForBackticks = false;
  bool noLinkOpeners = true;

  void reset() {
    pos = 0;
    columnOffset = 0;
    lastDelim = null;
    lastBracket = null;
    scannedForBackticks = false;
    noLinkOpeners = true;
    backticks.fillRange(0, backticks.length, 0);
  }

  void initialize({
    required Uint8List input,
    required int line,
    required int blockOffset,
  }) {
    this.input = input;
    this.line = line;
    this.blockOffset = blockOffset;
    reset();
  }

  // Special char tables (populated by extensions)
  static final List<bool> specialChars = List.filled(256, false);
  static final List<bool> skipChars = List.filled(256, false);

  static void initSpecialChars() {
    // "\r\n\\`&_*[]<!~"  (added ~ for strikethrough)
    specialChars[0x0D] = true; // \r
    specialChars[0x0A] = true; // \n
    specialChars[0x5C] = true; // \
    specialChars[0x60] = true; // `
    specialChars[0x26] = true; // &
    specialChars[0x5F] = true; // _
    specialChars[0x2A] = true; // *
    specialChars[0x5B] = true; // [
    specialChars[0x5D] = true; // ]
    specialChars[0x3C] = true; // <
    specialChars[0x21] = true; // !
    specialChars[0x7E] = true; // ~ for strikethrough
  }

  static void addSpecialChar(int c, {bool emphasis = false}) {
    if (c >= 0 && c < 256) {
      specialChars[c] = true;
      if (emphasis) {
        skipChars[c] = true;
      }
    }
  }

  static bool _mathCharsEnabled = false;

  static void enableMathDelimiters() {
    if (_mathCharsEnabled) {
      return;
    }
    addSpecialChar(0x24); // $
    _mathCharsEnabled = true;
  }

  int peekChar() {
    if (pos >= input.length) {
      return 0;
    }
    return input[pos];
  }

  int peekCharN(int n) {
    if (pos + n >= input.length) {
      return 0;
    }
    return input[pos + n];
  }

  int peekAt(int position) {
    if (position < 0 || position >= input.length) {
      return 0;
    }
    return input[position];
  }

  bool isEof() => pos >= input.length;

  void advance() {
    pos++;
  }

  int scanSpacechars() {
    var count = 0;
    while (peekChar() == 0x20 || peekChar() == 0x09) {
      advance();
      count++;
    }
    return count;
  }

  int scanSpacecharsAt(int position) {
    var count = 0;
    var p = position;
    while (p < input.length && (input[p] == 0x20 || input[p] == 0x09)) {
      count++;
      p++;
    }
    return count;
  }

  bool skipSpaces() {
    return scanSpacechars() > 0;
  }

  void spnl() {
    skipSpaces();
    if (skipLineEnd()) {
      skipSpaces();
    }
  }

  bool skipLineEnd() {
    var seenLineEndChar = false;
    if (peekChar() == 0x0D) {
      advance();
      seenLineEndChar = true;
    }
    if (peekChar() == 0x0A) {
      advance();
      seenLineEndChar = true;
    }
    return seenLineEndChar || isEof();
  }

  int findSpecialChar() {
    var n = pos + 1;
    while (n < input.length) {
      final c = input[n];
      if (c < 256 && specialChars[c]) {
        return n;
      }
      n++;
    }
    return input.length;
  }
}
