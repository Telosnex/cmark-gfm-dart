import 'package:cmark_gfm/src/util/chunk.dart';
import 'package:cmark_gfm/src/util/strbuf.dart';
import 'package:test/test.dart';

void main() {
  group('CmarkChunk', () {
    test('ltrim and rtrim', () {
      final chunk = CmarkChunk.literal('  hello  ');
      chunk.trim();
      expect(chunk.toString(), 'hello');
    });

    test('dup creates view', () {
      final chunk = CmarkChunk.literal('abcdef');
      final sub = chunk.dup(2, 3);
      expect(sub.toString(), 'cde');
    });

    test('from strbuf copies bytes', () {
      final buf = CmarkStrbuf()..putString('hello');
      final chunk = CmarkChunk.fromStrbuf(buf);
      expect(buf.length, 0);
      expect(chunk.toString(), 'hello');
    });
  });
}
