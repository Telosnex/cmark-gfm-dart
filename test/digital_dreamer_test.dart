import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  group('Digital Dreamer Poem Tests', () {
    test('Full poem parses correctly', () {
      final markdown = '''# 🌟 The Digital Dreamer

> *A meditation on code and consciousness*

---

## The Poem

In **circuits** deep where `electrons` flow,  
A _whisper_ echoes ~~loud~~ soft and low,  
Through [hyperlinks](https://example.com) and streams of light,  
Where `async` thoughts take `await` flight,  
The **parser** reads what hearts compose—  
Six lines of verse in `monospace` prose.

---

### Technical Details

| Attribute | Value |
|-----------|-------|
| Lines | 6 |
| Format | **GFM** |
| Syntax | ~~Simple~~ Advanced |

```dart
void dream() {
  print('Hello, parsed world! 🚀');
}
```

---

<sub>© 2025 · Rendered with ❤️ by cmark-gfm-widget</sub>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      
      // Verify key elements are present
      expect(html, contains('<h1>🌟 The Digital Dreamer</h1>'));
      expect(html, contains('<em>A meditation on code and consciousness</em>'));
      expect(html, contains('<strong>circuits</strong>'));
      expect(html, contains('<del>loud</del>'));
      expect(html, contains('<a href="https://example.com">hyperlinks</a>'));
      expect(html, contains('<code>electrons</code>'));
      expect(html, contains('<table>'));
      expect(html, contains('<del>Simple</del>'));
      expect(html, contains('<pre><code class="language-dart">'));
      expect(html, contains('&lt;sub&gt;')); // HTML escaped
    });
    
    test('Strikethrough in poem line', () {
      final markdown = 'A _whisper_ echoes ~~loud~~ soft and low,  ';
      
      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      
      expect(html, contains('<del>loud</del>'));
      expect(html, isNot(contains('~~loud~~')));
    });
    
    test('Nested code block in markdown code block', () {
      final markdown = '''```dart
void dream() {
  print('Hello, parsed world! 🚀');
}
```''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      
      expect(html, contains('<pre><code class="language-dart">'));
      expect(html, contains('Hello, parsed world! 🚀'));
    });
  });
}
