import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  group('Multi-file markdown fence boundaries', () {
    test('Example A - inner triple backticks in first file', () {
      const markdown = '''
**Files read:**
- `/tmp/a.md`
- `/tmp/b.txt`

---
/tmp/a.md:
````md
Top
```js
console.log("hi")
```
Bottom
````

---
/tmp/b.txt:
```txt
B must be a separate section
```
''';

      final html = _render(markdown);
      _expectLaterSectionsAreSeparate(html, const ['/tmp/b.txt:']);
    });

    test('Example B - mixed fence styles', () {
      const markdown = '''
**Files read:**
- `/tmp/a.md`
- `/tmp/b.txt`

---
/tmp/a.md:
~~~md
Before
```py
print("x")
```
After
~~~

---
/tmp/b.txt:
~~~txt
Must not be nested under file A
~~~
''';

      final html = _render(markdown);
      _expectLaterSectionsAreSeparate(html, const ['/tmp/b.txt:']);
    });

    test('Example C - long backtick runs inside content', () {
      const markdown = '''
**Files read:**
- `/tmp/a.md`
- `/tmp/b.txt`

---
/tmp/a.md:
`````md
This line has four ticks: ````
Still in file A
`````

---
/tmp/b.txt:
`````txt
File B should render independently
`````
''';

      final html = _render(markdown);
      _expectLaterSectionsAreSeparate(html, const ['/tmp/b.txt:']);
    });

    test('Example D - content includes both ``` and ~~~', () {
      const markdown = '''
**Files read:**
- `/tmp/a.md`
- `/tmp/b.txt`
- `/tmp/c.txt`

---
/tmp/a.md:
``````md
Backticks:
```go
fmt.Println("ok")
```

Tildes:
~~~sql
select 1;
~~~
``````

---
/tmp/b.txt:
``````txt
B section
``````

---
/tmp/c.txt:
``````txt
C section
``````
''';

      final html = _render(markdown);
      _expectLaterSectionsAreSeparate(html, const ['/tmp/b.txt:', '/tmp/c.txt:']);
    });

    test('Example E - first file ends with fence-like text', () {
      const markdown = '''
**Files read:**
- `/tmp/a.md`
- `/tmp/b.txt`

---
/tmp/a.md:
````md
Literal fence marker at end:
```
````

---
/tmp/b.txt:
````txt
If this appears inside A\'s block, rendering is broken
````
''';

      final html = _render(markdown);
      _expectLaterSectionsAreSeparate(html, const ['/tmp/b.txt:']);
    });
  });

  group('Multi-file markdown fence boundaries (streaming/finishClone)', () {
    for (final sample in _samples) {
      test('${sample.name} - chunked streaming with finishClone snapshots', () {
        final html = _renderStreamedWithFinishClone(
          sample.markdown,
          chunkSize: 7,
        );
        _expectLaterSectionsAreSeparate(html, sample.laterHeaders);

        final oneShot = _render(sample.markdown);
        expect(html, oneShot,
            reason:
                'Streaming finishClone output diverged from one-shot parse for ${sample.name}');
      });

      test('${sample.name} - character streaming with finishClone snapshots', () {
        final html = _renderStreamedWithFinishClone(
          sample.markdown,
          chunkSize: 1,
        );
        _expectLaterSectionsAreSeparate(html, sample.laterHeaders);

        final oneShot = _render(sample.markdown);
        expect(html, oneShot,
            reason:
                'Char-by-char finishClone output diverged from one-shot parse for ${sample.name}');
      });
    }
  });
}

class _Sample {
  const _Sample(this.name, this.markdown, this.laterHeaders);

  final String name;
  final String markdown;
  final List<String> laterHeaders;
}

const _samples = <_Sample>[
  _Sample(
    'Example A',
    '''
**Files read:**
- `/tmp/a.md`
- `/tmp/b.txt`

---
/tmp/a.md:
````md
Top
```js
console.log("hi")
```
Bottom
````

---
/tmp/b.txt:
```txt
B must be a separate section
```
''',
    ['/tmp/b.txt:'],
  ),
  _Sample(
    'Example B',
    '''
**Files read:**
- `/tmp/a.md`
- `/tmp/b.txt`

---
/tmp/a.md:
~~~md
Before
```py
print("x")
```
After
~~~

---
/tmp/b.txt:
~~~txt
Must not be nested under file A
~~~
''',
    ['/tmp/b.txt:'],
  ),
  _Sample(
    'Example C',
    '''
**Files read:**
- `/tmp/a.md`
- `/tmp/b.txt`

---
/tmp/a.md:
`````md
This line has four ticks: ````
Still in file A
`````

---
/tmp/b.txt:
`````txt
File B should render independently
`````
''',
    ['/tmp/b.txt:'],
  ),
  _Sample(
    'Example D',
    '''
**Files read:**
- `/tmp/a.md`
- `/tmp/b.txt`
- `/tmp/c.txt`

---
/tmp/a.md:
``````md
Backticks:
```go
fmt.Println("ok")
```

Tildes:
~~~sql
select 1;
~~~
``````

---
/tmp/b.txt:
``````txt
B section
``````

---
/tmp/c.txt:
``````txt
C section
``````
''',
    ['/tmp/b.txt:', '/tmp/c.txt:'],
  ),
  _Sample(
    'Example E',
    '''
**Files read:**
- `/tmp/a.md`
- `/tmp/b.txt`

---
/tmp/a.md:
````md
Literal fence marker at end:
```
````

---
/tmp/b.txt:
````txt
If this appears inside A\'s block, rendering is broken
````
''',
    ['/tmp/b.txt:'],
  ),
];

String _render(String markdown) {
  final parser = CmarkParser();
  parser.feed(markdown);
  return HtmlRenderer().render(parser.finish());
}

String _renderStreamedWithFinishClone(String markdown, {required int chunkSize}) {
  final parser = CmarkParser();
  final chunks = splitIntoChunks(markdown, chunkSize: chunkSize);

  for (final chunk in chunks) {
    parser.feed(chunk);
    // Simulate runtime behavior: UI snapshots via finishClone while streaming.
    parser.finishClone();
  }

  return HtmlRenderer().render(parser.finishClone());
}

void _expectLaterSectionsAreSeparate(String html, List<String> laterHeaders) {
  expect(html, contains('<pre><code'));

  final firstBlockStart = html.indexOf('<pre><code');
  final firstBlockEnd = html.indexOf('</code></pre>', firstBlockStart);
  expect(firstBlockStart, isNonNegative,
      reason: 'Expected at least one fenced code block.\n$html');
  expect(firstBlockEnd, greaterThan(firstBlockStart),
      reason: 'Expected first fenced code block to close.\n$html');

  final firstBlock = html.substring(firstBlockStart, firstBlockEnd);

  for (final header in laterHeaders) {
    final marker = '<p>$header</p>';
    final headerIndex = html.indexOf(marker);

    expect(headerIndex, isNonNegative,
        reason: 'Expected later section heading $header in HTML.\n$html');
    expect(headerIndex, greaterThan(firstBlockEnd),
        reason: 'Expected $header to appear after first fenced block closes.');
    expect(firstBlock, isNot(contains(header)),
        reason: '$header was swallowed into first fenced block.');
  }
}
