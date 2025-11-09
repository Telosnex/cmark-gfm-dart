# cmark-gfm-dart

A pure Dart port of the [cmark-gfm](https://github.com/github/cmark-gfm) Markdown parser with streaming support.

## Features

✅ **Streaming Parser** - Feed chunks of text incrementally without reparsing from scratch  
✅ **GitHub Flavored Markdown (GFM)** - Tables, strikethrough, task lists, autolinks  
✅ **CommonMark Core** - Paragraphs, headings, lists, code blocks, block quotes, links, images, emphasis  
✅ **Footnotes** - Full footnote support with automatic numbering and backreferences  
✅ **HTML Rendering** - Built-in HTML output with proper escaping  
✅ **Reference Links** - Full support for link reference definitions

## Usage

### Basic Parsing

```dart
import 'package:cmark_gfm/cmark_gfm.dart';

final parser = CmarkParser();
parser.feed('# Hello **World**\n\nThis is a paragraph.');
final doc = parser.finish();
final html = HtmlRenderer().render(doc);
print(html);
// Output:
// <h1>Hello <strong>World</strong></h1>
// <p>This is a paragraph.</p>
```

### Streaming Parsing

The parser is designed to handle incremental input, making it ideal for streaming chat applications:

```dart
final parser = CmarkParser();

// Feed chunks as they arrive
parser.feed('# Title\n\n');
parser.feed('Paragraph with **');
parser.feed('bold** text.\n\n');
parser.feed('- List item\n');

// Finalize and render
final doc = parser.finish();
final html = HtmlRenderer().render(doc);
```

### GFM Extensions

#### Tables

```dart
final parser = CmarkParser();
parser.feed('''
| Header 1 | Header 2 |
| :--- | ---: |
| Left aligned | Right aligned |
''');
final html = HtmlRenderer().render(parser.finish());
```

#### Strikethrough

```dart
parser.feed('~~strikethrough~~ or ~single~');
// Renders: <del>strikethrough</del> or <del>single</del>
```

#### Task Lists

```dart
parser.feed('''
- [ ] Unchecked task
- [x] Completed task
''');
// Renders checkboxes with disabled attribute
```

#### Autolinks

```dart
parser.feed('Visit <http://example.com> or email <user@example.com>');
// Automatically creates clickable links
```

#### Footnotes

```dart
parser.feed('''
Text with footnote[^1] and another[^note].

[^1]: First footnote
[^note]: Second footnote
''');
// Renders footnotes at end with proper anchors and backreferences
```

### Link References

```dart
parser.feed('''
[Link text][ref]

[ref]: http://example.com "Title"
''');
// Resolves reference and creates proper <a> tag
```

## Performance

This parser is designed to avoid O(N*M) reprocessing during streaming. Each `feed()` call processes only the new content, maintaining parser state between calls.

## Current Status

**Working:**
- All CommonMark block structures (paragraphs, headings, lists, code blocks, block quotes, thematic breaks)
- Full inline parsing (emphasis, strong, links, images, code spans, line breaks)
- GFM extensions: tables, strikethrough, task lists, autolinks
- Link reference definitions
- Footnotes (definitions and references)
- Streaming input handling

**Not Working:**
- HTML rendering (currently have no intent to implement; embedding arbitrary HTML is a security risk)

**TODO:**
- Complete CommonMark spec test suite validation (658/749 passing; incl. HTML tests)

## Architecture

- `CmarkParser` - High-level streaming parser API
- `BlockParser` - Block-level parsing (paragraphs, lists, etc.)
- `InlineParser` - Inline-level parsing (emphasis, links, etc.)
- `HtmlRenderer` - Renders AST to HTML
- `CmarkNode` - AST node with support for all CommonMark and GFM node types
- `CmarkReferenceMap` - Link reference storage and lookup
