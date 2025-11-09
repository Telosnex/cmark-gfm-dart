import 'dart:convert';

import 'package:cmark_gfm/src/util/strbuf.dart';
import 'package:test/test.dart';

void main() {
  group('CmarkStrbuf', () {
    test('putString and detach', () {
      final buf = CmarkStrbuf();
      buf.putString('hello');
      expect(buf.length, 5);
      expect(utf8.decode(buf.detach()), 'hello');
      expect(buf.length, 0);
    });

    test('trim and rtrim', () {
      final buf = CmarkStrbuf();
      buf.putString('  hello  ');
      buf.trim();
      expect(buf.toString(), 'hello');
    });

    test('normalizeWhitespace collapses spaces', () {
      final buf = CmarkStrbuf();
      buf.putString('a\n\nb\t\tc');
      buf.normalizeWhitespace();
      expect(buf.toString(), 'a b c');
    });

    test('unescape removes backslashes before punctuation', () {
      final buf = CmarkStrbuf();
      buf.putString(r"\*foo\!");
      buf.unescape();
      expect(buf.toString(), '*foo!');
    });

    test('drop and truncate', () {
      final buf = CmarkStrbuf();
      buf.putString('abcdef');
      buf.drop(2);
      expect(buf.toString(), 'cdef');
      buf.truncate(3);
      expect(buf.toString(), 'cde');
    });
  });
}
