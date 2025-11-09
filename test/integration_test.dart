import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  group('Integration tests', () {
    test('parses complex GFM document with all features', () {
      final parser = CmarkParser();
      final markdown = '''
# Main Heading

This is a paragraph with **bold**, *italic*, ~~strikethrough~~, and `code`.

## Lists

### Unordered List
- Item 1
- Item 2
- Item 3

### Ordered List
1. First
2. Second
3. Third

### Task List
- [ ] Todo item
- [x] Completed item

## Links and References

[Link with title](http://example.com "Title")

[Reference link][ref1]

Visit <http://example.com> or email <user@example.com>

[ref1]: http://reference.com "Reference"

## Code

Inline `code` and block:

\`\`\`python
def hello():
    print("world")
\`\`\`

Indented code:

    int main() {
        return 0;
    }

## Tables

| Header 1 | Header 2 | Header 3 |
| :--- | :---: | ---: |
| Left | Center | Right |
| A | B | C |

## Block Quotes

> This is a quote
> with multiple lines
>
> And paragraphs

## Thematic Breaks

---

## Footnotes

Text with footnote[^1] and another[^note].

[^1]: First footnote
[^note]: Second footnote with **formatting**

End of document.
''';

      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      // Verify all features are present
      expect(html, contains('<h1>Main Heading</h1>'));
      expect(html, contains('<h2>Lists</h2>'));
      expect(html, contains('<h3>Unordered List</h3>'));
      expect(html, contains('<strong>bold</strong>'));
      expect(html, contains('<em>italic</em>'));
      expect(html, contains('<del>strikethrough</del>'));
      expect(html, contains('<code>code</code>'));
      expect(html, contains('<ul>'));
      expect(html, contains('<ol>'));
      expect(html, contains('input type="checkbox"'));
      expect(html, contains('checked=""'));
      expect(html, contains('<a href="http://example.com" title="Title">'));
      expect(html, contains('<a href="http://reference.com"'));
      expect(html, contains('<a href="http://example.com">http://example.com</a>'));
      expect(html, contains('<a href="mailto:user@example.com">'));
      expect(html, contains('language-python'));
      expect(html, contains('def hello()'));
      expect(html, contains('int main()'));
      expect(html, contains('<table>'));
      expect(html, contains('<th'));
      expect(html, contains('<td'));
      expect(html, contains('align="left"'));
      expect(html, contains('align="center"'));
      expect(html, contains('align="right"'));
      expect(html, contains('<blockquote>'));
      expect(html, contains('<hr />'));
      expect(html, contains('footnote-ref'));
      expect(html, contains('First footnote'));
      expect(html, contains('Second footnote'));
    });

    test('handles streaming of complex document', () {
      final parser = CmarkParser();
      final chunks = [
        '# Title\n\n',
        'Paragraph with **',
        'bold** and *',
        'italic*.\n\n',
        '| A | B |\n| - | - |\n',
        '| 1 | 2 |\n\n',
        '- [ ] Task\n',
        '- [x] Done\n\n',
        '```\n',
        'code\n',
        '```\n',
      ];

      for (final chunk in chunks) {
        parser.feed(chunk);
      }

      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html, contains('<h1>Title</h1>'));
      expect(html, contains('<strong>bold</strong>'));
      expect(html, contains('<em>italic</em>'));
      expect(html, contains('<table>'));
      expect(html, contains('input type="checkbox"'));
      expect(html, contains('<pre><code>'));
    });
  });
}
