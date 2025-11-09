import 'package:cmark_gfm/cmark_gfm.dart';

/// Complete demonstration of all cmark-gfm-dart features.
///
/// This shows every supported markdown construct parsing and rendering correctly.
void main() {
  final parser = CmarkParser();

  // Feed a comprehensive markdown document
  parser.feed('''
# Complete Feature Demo

## Basic Formatting

Paragraphs with **bold**, *italic*, ***bold italic***, ~~strikethrough~~, 
~single strike~, and `inline code`.

Line breaks work too:  
This is a hard break after two spaces.

Backslash escapes: \\* \\[ \\`

## Headings

### Level 3
#### Level 4
##### Level 5
###### Level 6

Setext Heading Level 1
======================

Setext Heading Level 2
----------------------

## Lists

### Unordered
- Apple
- Banana
- Cherry

### Ordered
1. First
2. Second
3. Third

### Task Lists (GFM)
- [ ] Todo item
- [x] Completed item
- [ ] Another todo

## Links and Images

[Inline link](http://example.com "Title")

[Reference link][ref]

![Image](http://example.com/image.png "Alt text")

Autolinks: <http://example.com> and <user@example.com>

[ref]: http://reference.com "Reference Title"

## Code Blocks

Inline: `var x = 42;`

Fenced with language:
\`\`\`dart
final greeting = 'Hello';
print(greeting);
\`\`\`

Indented:

    def python_code():
        return True

## Tables (GFM)

| Feature | Status | Priority |
| :------ | :----: | -------: |
| Parsing | ✅ Done | High |
| Rendering | ✅ Done | High |
| Testing | ✅ Done | High |

## Block Quotes

> This is a quote.
> It can span multiple lines.
>
> And have multiple paragraphs.

## Footnotes

This document has footnotes[^1] that provide additional information[^details].

[^1]: Footnotes appear at the end of the document.
[^details]: They can contain **formatting** and even `code`.

## HTML Entities

Use &amp; for ampersand, &lt; for less-than, &gt; for greater-than.

Numeric: &#35; &#169; &#8594;

## Thematic Breaks

---

***

___

## Conclusion

All features demonstrated above are fully functional with streaming support!
''');

  // Finalize and render
  final doc = parser.finish();
  final html = HtmlRenderer().render(doc);

  print('=== Generated HTML ===\n');
  print(html);

  print('\n=== Verification ===\n');

  // Verify all features are present
  final features = {
    'Headings (h1-h6)': html.contains('<h1>') && html.contains('<h6>'),
    'Bold': html.contains('<strong>'),
    'Italic': html.contains('<em>'),
    'Strikethrough': html.contains('<del>'),
    'Code spans': html.contains('<code>'),
    'Line breaks': html.contains('<br />'),
    'Unordered lists': html.contains('<ul>'),
    'Ordered lists': html.contains('<ol>'),
    'Task lists': html.contains('type="checkbox"'),
    'Links': html.contains('<a href'),
    'Images': html.contains('<img'),
    'Autolinks': html.contains('mailto:'),
    'Reference links': html.contains('reference.com'),
    'Fenced code blocks': html.contains('language-dart'),
    'Indented code blocks': html.contains('def python_code'),
    'Tables': html.contains('<table>'),
    'Table alignment': html.contains('align='),
    'Block quotes': html.contains('<blockquote>'),
    'Footnotes': html.contains('footnote-ref'),
    'HTML entities': html.contains('&amp;'),
    'Thematic breaks': html.contains('<hr />'),
  };

  var allPresent = true;
  for (final entry in features.entries) {
    final status = entry.value ? '✅' : '❌';
    print('$status ${entry.key}');
    if (!entry.value) {
      allPresent = false;
    }
  }

  if (allPresent) {
    print('\n🎉 All features working correctly!');
  } else {
    print('\n⚠️ Some features missing!');
  }
}
