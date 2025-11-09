import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  test('Comprehensive GFM feature test', () {
    final parser = CmarkParser();
    
    // This is a kitchen-sink test of all major features
    final markdown = '''
# Main Document

This is a paragraph with **bold**, *italic*, ~~strikethrough~~, and `inline code`.

## Lists

Unordered:
- Item 1
- Item 2

Ordered:
1. First
2. Second

Task list:
- [ ] Todo
- [x] Done

## Links and References

[Direct link](http://example.com "Title")

[Reference link][ref]

Autolinks: <http://auto.com> and <user@email.com>

[ref]: http://reference.com "Ref Title"

## Code Blocks

Fenced:
\`\`\`python
def hello():
    return "world"
\`\`\`

Indented:

    int x = 42;

## Tables

| Left | Center | Right |
| :--- | :---: | ---: |
| A | B | C |

## Footnotes

Text with footnote[^1] and another[^2].

[^1]: First footnote content
[^2]: Second **formatted** footnote

## Block Quotes

> Quoted text
> with continuation

## Thematic Break

---

End.
''';

    parser.feed(markdown);
    final doc = parser.finish();
    final html = HtmlRenderer().render(doc);

    // Verify everything is present
    final checks = {
      'heading 1': '<h1>Main Document</h1>',
      'heading 2': '<h2>Lists</h2>',
      'bold': '<strong>bold</strong>',
      'italic': '<em>italic</em>',
      'strikethrough': '<del>strikethrough</del>',
      'inline code': '<code>inline code</code>',
      'ul': '<ul>',
      'ol': '<ol>',
      'task unchecked': 'type="checkbox" disabled',
      'task checked': 'checked="" disabled',
      'direct link': '<a href="http://example.com" title="Title">',
      'reference link': '<a href="http://reference.com"',
      'autolink url': '<a href="http://auto.com">',
      'autolink email': '<a href="mailto:user@email.com">',
      'fenced code': 'language-python',
      'code content': 'def hello()',
      'indented code': 'int x = 42',
      'table': '<table>',
      'table header': '<th',
      'table cell': '<td',
      'table align left': 'align="left"',
      'table align center': 'align="center"',
      'table align right': 'align="right"',
      'footnote ref': 'footnote-ref',
      'footnote link': 'href="#fn-1"',
      'footnote content': 'First footnote content',
      'footnote formatted': '<strong>formatted</strong>',
      'blockquote': '<blockquote>',
      'hr': '<hr />',
    };

    for (final entry in checks.entries) {
      expect(html, contains(entry.value),
          reason: 'Missing ${entry.key}: ${entry.value}');
    }
  });
}
