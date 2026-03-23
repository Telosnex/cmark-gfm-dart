import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  group('Fence separation across sections', () {
    test('input 1: nested triple backticks in md fence do not swallow /tmp/b.txt', () {
      const markdown = '''
/tmp/a.md:
````md
Line 1
```dart
void main() {}
```
Line 2
````
---
/tmp/b.txt:
```txt
B should be separate
```
''';

      final html = _render(markdown);
      _expectBSectionIsSeparate(html, expectedBText: 'B should be separate');
    });

    test('input 2: mixed ~~~ outer with ``` inner do not swallow /tmp/b.txt', () {
      const markdown = '''
/tmp/a.md:
~~~md
Text before
```python
print("hello")
```
Text after
~~~
---
/tmp/b.txt:
~~~txt
Still separate
~~~
''';

      final html = _render(markdown);
      _expectBSectionIsSeparate(html, expectedBText: 'Still separate');
    });

    test('input 3: long backtick runs do not swallow /tmp/b.txt', () {
      const markdown = '''
/tmp/a.md:
`````md
Contains a fence-like sequence:
````
and more text
`````
---
/tmp/b.txt:
````txt
Must render as its own block
````
''';

      final html = _render(markdown);
      _expectBSectionIsSeparate(
        html,
        expectedBText: 'Must render as its own block',
      );
    });
  });
}

String _render(String markdown) {
  final parser = CmarkParser();
  parser.feed(markdown);
  final doc = parser.finish();
  return HtmlRenderer().render(doc);
}

void _expectBSectionIsSeparate(String html, {required String expectedBText}) {
  final bHeading = '<p>/tmp/b.txt:</p>';
  final bHeadingIndex = html.indexOf(bHeading);

  expect(bHeadingIndex, isNonNegative,
      reason: 'Expected /tmp/b.txt section heading in output.\n$html');
  expect(html, contains('<hr />'));
  expect(html, contains('<code class="language-txt">$expectedBText\n</code>'));

  final beforeB = html.substring(0, bHeadingIndex);
  expect(beforeB, contains('</code></pre>'),
      reason: 'Expected previous fenced block to be closed before /tmp/b.txt.');
  expect(beforeB, isNot(contains('/tmp/b.txt:')),
      reason: '/tmp/b.txt appeared before its heading location unexpectedly.');

  final firstBlockStart = html.indexOf('<pre><code');
  if (firstBlockStart >= 0) {
    final firstBlockEnd = html.indexOf('</code></pre>', firstBlockStart);
    if (firstBlockEnd > firstBlockStart) {
      final firstBlock = html.substring(firstBlockStart, firstBlockEnd);
      expect(firstBlock, isNot(contains('/tmp/b.txt:')),
          reason: '/tmp/b.txt was swallowed into the first fenced block.');
    }
  }
}
