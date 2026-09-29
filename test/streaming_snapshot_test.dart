import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import 'perf/streaming_fixture.dart';

String _html(CmarkNode node) => HtmlRenderer().render(node);

String _fresh(String markdown, [CmarkParserOptions? options]) {
  final parser = CmarkParser(options: options ?? const CmarkParserOptions());
  return _html((parser..feed(markdown)).finish());
}

/// Streams [chunks] into one parser and takes a snapshot after each chunk.
/// Returns every snapshot's HTML and the final document's HTML.
({List<String> snapshots, String finished}) _stream(
  List<String> chunks, [
  CmarkParserOptions? options,
]) {
  final parser = CmarkParser(options: options ?? const CmarkParserOptions());
  final snapshots = <String>[];
  for (final chunk in chunks) {
    parser.feed(chunk);
    snapshots.add(_html(parser.finishClone()));
  }
  return (snapshots: snapshots, finished: _html(parser.finish()));
}

List<String> _characters(String text) => text.split('');

List<String> _lines(String text) =>
    RegExp(r'[^\n]*\n|[^\n]+$').allMatches(text).map((m) => m[0]!).toList();

/// Each snapshot must equal a fresh parse of the text fed so far, and the
/// final document must equal a fresh parse of the whole text.
void _expectStreamingMatchesFresh(
  List<String> chunks, [
  CmarkParserOptions? options,
]) {
  final result = _stream(chunks, options);
  var fed = '';
  for (var i = 0; i < chunks.length; i++) {
    fed += chunks[i];
    expect(
      result.snapshots[i],
      _fresh(fed, options),
      reason:
          'snapshot after ${fed.length} chars: ${fed.replaceAll('\n', r'\n')}',
    );
  }
  expect(result.finished, _fresh(fed, options), reason: 'finished document');
}

const _footnotes = 'Text[^1] and[^2].\n'
    '\n'
    '[^1]: Note *here*.\n'
    '\n'
    '[^2]: Two.\n'
    '\n'
    'More text\n';

void main() {
  group('finishClone snapshots', () {
    test('a partial reference definition does not stick', () {
      _expectStreamingMatchesFresh(
        _characters('[foo]\n\n[foo]: /url "title"\n'),
      );
    });

    test('a reference definition in the pending line does not stick', () {
      // The snapshot must not register "/u" for a label that the rest of
      // the stream defines as "/url".
      final parser = CmarkParser()..feed('[foo]\n\n[foo]: /u');
      parser.finishClone();
      parser.feed('rl\n');
      expect(_html(parser.finish()), _fresh('[foo]\n\n[foo]: /url\n'));
    });

    test('an unfinished title does not create a link', () {
      _expectStreamingMatchesFresh(_characters('[foo]: /url "title\n'));
    });

    test('task list items keep their checkbox', () {
      _expectStreamingMatchesFresh(_characters('- [ ] one\n- [x] two\n'));
    });

    test('task list state survives a snapshot of later text', () {
      final parser = CmarkParser()..feed('- [x] done\n');
      parser.feed('- [ ] ');
      parser.finishClone();
      parser.feed('todo\n');
      expect(
        _html(parser.finish()),
        _fresh('- [x] done\n- [ ] todo\n'),
      );
    });

    test('footnotes are numbered once per snapshot', () {
      _expectStreamingMatchesFresh(_lines(_footnotes));
    });

    test('footnotes streamed by character', () {
      _expectStreamingMatchesFresh(_characters(_footnotes));
    });

    test('a later snapshot does not change an earlier one', () {
      final parser = CmarkParser()..feed('Text[^1].\n\n[^1]: Note.\n\n');
      final first = parser.finishClone();
      final firstHtml = _html(first);
      parser.feed('More[^1].\n\n');
      parser.finishClone();
      parser.finishClone();
      expect(_html(first), firstHtml);
    });

    test('a later snapshot does not take nodes from the finished tree', () {
      final parser = CmarkParser()..feed('Text[^1].\n\n[^1]: Note.\n\nEnd\n');
      final snapshot = parser.finishClone();
      final snapshotHtml = _html(snapshot);
      final finished = parser.finish();
      expect(_html(snapshot), snapshotHtml);
      expect(_html(finished), _fresh('Text[^1].\n\n[^1]: Note.\n\nEnd\n'));
    });

    test('a loose list keeps its looseness in later snapshots', () {
      _expectStreamingMatchesFresh(
        _characters('- a\n  - b\n  - c\n\n- d\n  - e\n\npara\n'),
      );
    });

    test('a synthetic chat reply streams like fresh parses', () {
      final fixture = StreamingFixture.reply(
        name: 'reply',
        targetLength: 4000,
        maxChunk: 64,
      );
      _expectStreamingMatchesFresh(fixture.chunks);
    });

    test('a synthetic chat reply streams by line', () {
      final fixture = StreamingFixture.reply(name: 'reply', targetLength: 4000);
      _expectStreamingMatchesFresh(_lines(fixture.text));
    });
  });

  group('finishClone trailingText', () {
    test('parses as if appended', () {
      const fed = 'Text[^1] and code:\n\n```dart\nfinal x = 1;';
      const trailing = '\n```\n\n[^1]: Stub\n';
      final parser = CmarkParser()..feed(fed);
      expect(
        _html(parser.finishClone(trailingText: trailing)),
        _fresh(fed + trailing),
      );
    });

    test('is not kept', () {
      final parser = CmarkParser()..feed('```dart\nfinal x');
      parser.finishClone(trailingText: '\n```\n[^1]: Stub');
      parser.feed(' = 1;\n```\n');
      expect(
        _html(parser.finishClone()),
        _fresh('```dart\nfinal x = 1;\n```\n'),
      );
      expect(_html(parser.finish()), _fresh('```dart\nfinal x = 1;\n```\n'));
    });

    test('streamed with a changing trailing text', () {
      final fixture = StreamingFixture.reply(name: 'reply', targetLength: 3000);
      final parser = CmarkParser();
      var fed = '';
      for (final chunk in fixture.chunks) {
        parser.feed(chunk);
        fed += chunk;
        final trailing = '\n```\n\n[^${fed.length % 5}]: stub ${fed.length}';
        expect(
          _html(parser.finishClone(trailingText: trailing)),
          _fresh(fed + trailing),
          reason: 'after ${fed.length} chars',
        );
      }
    });
  });

  group('list tightness', () {
    // Expected HTML is from cmark-gfm 0.29.0.gfm.13. Finalizing the list a
    // second time used to read a stale cached answer and make it tight.
    test('a closed loose list with a nested list', () {
      expect(
        _fresh('- a\n  - b\n  - c\n\n- d\n\npara\n'),
        '<ul>\n<li>\n<p>a</p>\n<ul>\n<li>b</li>\n<li>c</li>\n</ul>\n</li>\n'
        '<li>\n<p>d</p>\n</li>\n</ul>\n<p>para</p>\n',
      );
    });
  });

  group('CmarkNode.deepCopy', () {
    test('copies task list state', () {
      final item = CmarkNode(CmarkNodeType.item)..listData.checked = true;
      expect(item.deepCopy().listData.checked, isTrue);
    });
  });
}
