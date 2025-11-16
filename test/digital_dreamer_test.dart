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
      expect(
          html,
          '<h1>🌟 The Digital Dreamer</h1>\n'
          '<blockquote>\n'
          '<p><em>A meditation on code and consciousness</em></p>\n'
          '</blockquote>\n'
          '<hr />\n'
          '<h2>The Poem</h2>\n'
          '<p>In <strong>circuits</strong> deep where <code>electrons</code> flow,<br />\n'
          'A <em>whisper</em> echoes <del>loud</del> soft and low,<br />\n'
          'Through <a href="https://example.com">hyperlinks</a> and streams of light,<br />\n'
          'Where <code>async</code> thoughts take <code>await</code> flight,<br />\n'
          'The <strong>parser</strong> reads what hearts compose—<br />\n'
          'Six lines of verse in <code>monospace</code> prose.</p>\n'
          '<hr />\n'
          '<h3>Technical Details</h3>\n'
          '<table>\n'
          '<thead>\n'
          '<tr>\n'
          '<th>Attribute</th>\n'
          '<th>Value</th>\n'
          '</tr>\n'
          '</thead>\n'
          '<tbody>\n'
          '<tr>\n'
          '<td>Lines</td>\n'
          '<td>6</td>\n'
          '</tr>\n'
          '<tr>\n'
          '<td>Format</td>\n'
          '<td><strong>GFM</strong></td>\n'
          '</tr>\n'
          '<tr>\n'
          '<td>Syntax</td>\n'
          '<td><del>Simple</del> Advanced</td>\n'
          '</tr>\n'
          '</tbody>\n'
          '</table>\n'
          '<pre><code class="language-dart">void dream() {\n'
          '  print(\'Hello, parsed world! 🚀\');\n'
          '}\n'
          '</code></pre>\n'
          '<hr />\n'
          '<p><sub>© 2025 · Rendered with ❤️ by cmark-gfm-widget</sub></p>\n'
          '');
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
