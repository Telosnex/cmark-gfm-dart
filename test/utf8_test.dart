import 'dart:convert';

import 'package:cmark_gfm_dart/src/util/strbuf.dart';
import 'package:cmark_gfm_dart/src/util/utf8.dart';
import 'package:test/test.dart';

void main() {
  group('CmarkUtf8', () {
    test('encodeChar encodes BMP and astral', () {
      final buf = CmarkStrbuf();
      CmarkUtf8.encodeChar('é'.runes.first, buf);
      CmarkUtf8.encodeChar(0x1F600, buf); // 😀
      expect(utf8.decode(buf.detach()), 'é😀');
    });

    test('iterate decodes valid sequences', () {
      final bytes = utf8.encode('A😀');
      final result1 = CmarkUtf8.iterate(bytes, 0);
      expect(result1.length, 1);
      expect(String.fromCharCode(result1.codePoint), 'A');
      final result2 = CmarkUtf8.iterate(bytes, result1.length);
      expect(result2.length, 4);
      expect(result2.codePoint, 0x1F600);
    });

    test('caseFold lowers ASCII and special cases', () {
      final buf = CmarkStrbuf();
      CmarkUtf8.caseFold(buf, utf8.encode('Straße'));
      expect(utf8.decode(buf.detach()), 'strasse');
    });

    test('check replaces invalid bytes', () {
      final buf = CmarkStrbuf();
      CmarkUtf8.check(buf, [0x41, 0x80, 0x41]);
      expect(buf.length, 1 + 3 + 1);
    });
  });
}
