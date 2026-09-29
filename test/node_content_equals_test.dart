import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import 'perf/streaming_fixture.dart';

const _options = CmarkParserOptions(enableMath: true);

CmarkNode _parse(String markdown) =>
    (CmarkParser(options: _options)..feed(markdown)).finish();

const _everything = '# Title\n'
    '\n'
    'A [link](https://a.example "t"), `code`, \$x^2\$ and a note[^1].\n'
    '\n'
    '- [x] done\n'
    '- [ ] todo\n'
    '\n'
    '| a | b |\n'
    '|:--|--:|\n'
    '| 1 | 2 |\n'
    '\n'
    '```dart\n'
    'main() {}\n'
    '```\n'
    '\n'
    '\$\$\n'
    'y = 1\n'
    '\$\$\n'
    '\n'
    '<div>html</div>\n'
    '\n'
    '[^1]: The note.\n';

void main() {
  group('CmarkNode.contentEquals', () {
    test('two parses of the same text are equal', () {
      expect(_parse(_everything).contentEquals(_parse(_everything)), isTrue);
    });

    test('a deep copy equals its original', () {
      final document = _parse(_everything);
      expect(document.deepCopy().contentEquals(document), isTrue);
    });

    test('reading a data getter does not change equality', () {
      final read = _parse('plain\n');
      final unread = _parse('plain\n');
      read.firstChild!.firstChild!.codeData;
      expect(read.contentEquals(unread), isTrue);
      expect(unread.contentEquals(read), isTrue);
    });

    // Each pair renders differently, and differs in one field.
    const pairs = <String, (String, String)>{
      'text': ('Hello\n', 'Hellp\n'),
      'heading level': ('# A\n', '## A\n'),
      'link URL': ('[a](https://a.example)\n', '[a](https://b.example)\n'),
      'link title': (
        '[a](https://a.example "x")\n',
        '[a](https://a.example "y")\n'
      ),
      'task state': ('- [x] a\n', '- [ ] a\n'),
      'list looseness': ('- a\n- b\n', '- a\n\n- b\n'),
      'list start': ('1. a\n', '2. a\n'),
      'code info': ('```dart\nx\n```\n', '```js\nx\n```\n'),
      'table alignment': ('| a |\n|:--|\n| 1 |\n', '| a |\n|--:|\n| 1 |\n'),
      'math display': (r'$x$' '\n', r'$$x$$' '\n'),
      'footnote occurrence': (
        'A[^1] B[^1]\n\n[^1]: n\n',
        'A[^1] B[^2]\n\n[^1]: n\n\n[^2]: m\n'
      ),
      'positions': ('A\n', ' A\n'),
      'child count': ('*a* b\n', '*a*\n'),
    };
    for (final MapEntry(key: name, value: (a, b)) in pairs.entries) {
      test('detects different $name', () {
        expect(_parse(a).contentEquals(_parse(b)), isFalse);
      });
    }

    test('streamed snapshots keep closed blocks equal', () {
      final fixture =
          StreamingFixture.reply(name: 'reply', targetLength: 4000, seed: 3);
      final parser = CmarkParser(options: _options);
      CmarkNode? previous;
      var comparedBlocks = 0;
      var equalBlocks = 0;
      for (final chunk in fixture.chunks) {
        parser.feed(chunk);
        final snapshot = parser.finishClone();
        if (previous != null) {
          var a = previous.firstChild;
          var b = snapshot.firstChild;
          while (a != null && b != null) {
            comparedBlocks++;
            // An equal block renders the same HTML.
            if (a.contentEquals(b)) {
              equalBlocks++;
              expect(HtmlRenderer().render(a), HtmlRenderer().render(b));
            }
            a = a.next;
            b = b.next;
          }
        }
        previous = snapshot;
      }
      // Most blocks are closed and unchanged between two snapshots.
      expect(equalBlocks, greaterThan(comparedBlocks * 3 ~/ 4));
    });
  });
}
