import 'package:cmark_gfm/src/util/ctype.dart';
import 'package:test/test.dart';

void main() {
  group('CmarkCType', () {
    test('classifies whitespace', () {
      expect(CmarkCType.isSpace(0x20), isTrue);
      expect(CmarkCType.isSpace(0x09), isTrue);
      expect(CmarkCType.isSpace(0x41), isFalse);
    });

    test('classifies punctuation', () {
      expect(CmarkCType.isPunct('!'.codeUnitAt(0)), isTrue);
      expect(CmarkCType.isPunct('a'.codeUnitAt(0)), isFalse);
    });

    test('classifies digits and alpha', () {
      expect(CmarkCType.isDigit('5'.codeUnitAt(0)), isTrue);
      expect(CmarkCType.isAlpha('Z'.codeUnitAt(0)), isTrue);
      expect(CmarkCType.isAlnum('Z'.codeUnitAt(0)), isTrue);
      expect(CmarkCType.isAlnum('@'.codeUnitAt(0)), isFalse);
    });
  });
}
