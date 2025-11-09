import 'package:cmark_gfm/src/reference/reference_map.dart';
import 'package:cmark_gfm/src/util/chunk.dart';
import 'package:test/test.dart';

void main() {
  group('CmarkReferenceMap', () {
    test('normalizes labels', () {
      final map = CmarkReferenceMap();
      final label = CmarkChunk.literal(' Foo\nBAR ');
      final url = CmarkChunk.literal('http://example.com');
      final title = CmarkChunk.literal('Title');

      expect(map.add(label, url, title), isTrue);
      final lookupLabel = CmarkChunk.literal('foo bar');
      final ref = map.lookup(lookupLabel);
      expect(ref, isNotNull);
      expect(ref!.url.toString(), 'http://example.com');
      expect(ref.title.toString(), 'Title');
    });

    test('ignores duplicate labels', () {
      final map = CmarkReferenceMap();
      final url1 = CmarkChunk.literal('one');
      final url2 = CmarkChunk.literal('two');
      final title = CmarkChunk.literal('Title');

      expect(map.add(CmarkChunk.literal('foo'), url1, title), isTrue);
      expect(map.add(CmarkChunk.literal('FOO'), url2, title), isFalse);
      final ref = map.lookup(CmarkChunk.literal('foo'));
      expect(ref, isNotNull);
      expect(ref!.url.toString(), 'one');
    });

    test('respects maximum reference size', () {
      final map = CmarkReferenceMap(maxRefSize: 4);
      final label = CmarkChunk.literal('label');
      final url = CmarkChunk.literal('1234');
      final title = CmarkChunk.literal('9');

      expect(map.add(label, url, title), isTrue);
      final ref = map.lookup(label);
      expect(ref, isNull, reason: 'size exceeds limit');
    });

    test('cleans url and title', () {
      final map = CmarkReferenceMap();
      final label = CmarkChunk.literal('label');
      final url = CmarkChunk.literal('  http://example.com?x=&amp;y  ');
      final title = CmarkChunk.literal('"Hello &quot;World&quot;"');

      expect(map.add(label, url, title), isTrue);
      final ref = map.lookup(label);
      expect(ref, isNotNull);
      expect(ref!.url.toString(), 'http://example.com?x=&y');
      expect(ref.title.toString(), 'Hello "World"');
    });
  });
}
