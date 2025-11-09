import 'dart:convert';

import 'package:cmark_gfm/src/houdini/html_unescape.dart';
import 'package:cmark_gfm/src/util/strbuf.dart';
import 'package:test/test.dart';

void main() {
  group('HoudiniHtmlUnescape', () {
    test('unescapes numeric entity', () {
      final buf = CmarkStrbuf();
      HoudiniHtmlUnescape.unescape(buf, utf8.encode('A&#35;B'));
      expect(utf8.decode(buf.detach()), 'A#B');
    });

    test('unescapes named entities', () {
      final buf = CmarkStrbuf();
      HoudiniHtmlUnescape.unescape(buf, utf8.encode('&amp;&lt;&gt;'));
      expect(utf8.decode(buf.detach()), '&<>');
    });

    test('writes literal ampersand if unknown', () {
      final buf = CmarkStrbuf();
      HoudiniHtmlUnescape.unescape(buf, utf8.encode('&unknown;'));
      expect(utf8.decode(buf.detach()), '&unknown;');
    });
  });
}
