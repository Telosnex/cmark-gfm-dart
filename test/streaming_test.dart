import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  group('Streaming parsing', () {
    test('handles text streamed one character at a time', () {
      final parser = CmarkParser();
      final text = 'Hello world';
      for (var i = 0; i < text.length; i++) {
        parser.feed(text[i]);
      }
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, '<p>Hello world</p>\n');
    });

    test('handles streaming with partial lines', () {
      final parser = CmarkParser();
      parser.feed('Hello');
      parser.feed(' ');
      parser.feed('world');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, '<p>Hello world</p>\n');
    });

    test('handles streaming across paragraph boundaries', () {
      final parser = CmarkParser();
      parser.feed('First para');
      parser.feed('graph\n\nSec');
      parser.feed('ond paragraph');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, contains('First paragraph'));
      expect(html, contains('Second paragraph'));
    });

    test('handles streaming with code blocks', () {
      final parser = CmarkParser();
      parser.feed('```dart\n');
      parser.feed('final x = 1;\n');
      parser.feed('final y = 2;\n');
      parser.feed('```\n');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, contains('final x = 1;'));
      expect(html, contains('final y = 2;'));
    });

    test('handles streaming with lists', () {
      final parser = CmarkParser();
      parser.feed('- item ');
      parser.feed('one\n- ');
      parser.feed('item two');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, contains('item one'));
      expect(html, contains('item two'));
    });

    test('handles large document streamed in chunks', () {
      final parser = CmarkParser();
      final chunks = [
        '# Heading\n\n',
        'This is a **bold** paragraph ',
        'with *emphasis* and `code`.\n\n',
        '## Subheading\n\n',
        '- List item 1\n',
        '- List item 2\n\n',
        '```python\n',
        'def hello():\n',
        '    print("world")\n',
        '```\n',
      ];

      for (final chunk in chunks) {
        parser.feed(chunk);
      }

      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, contains('<h1>Heading</h1>'));
      expect(html, contains('<strong>bold</strong>'));
      expect(html, contains('<em>emphasis</em>'));
      expect(html, contains('<code>code</code>'));
      expect(html, contains('<h2>Subheading</h2>'));
      expect(html, contains('List item 1'));
      expect(html, contains('List item 2'));
      expect(html, contains('language-python'));
      expect(html, contains('def hello()'));
    });
  });
}
