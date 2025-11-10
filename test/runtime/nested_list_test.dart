import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('nested list - A B C', () {
    const markdown = '- A\n  - B\n  - C';
    const expected = 'document: ""\n'
        '  list: ""\n'
        '    item: ""\n'
        '      paragraph: "A"\n'
        '        text: "A"\n'
        '      list: ""\n'
        '        item: ""\n'
        '          paragraph: "B"\n'
        '            text: "B"\n'
        '        item: ""\n'
        '          paragraph: "C"\n'
        '            text: "C"\n'
        '';

    // Non-streaming
    final parser1 = CmarkParser();
    parser1.feed(markdown);
    final doc1 = parser1.finish();
    final nonstreamingOutput = getStringForTree(doc1);
    print('--- finish() ---');
    print(nonstreamingOutput);
    
    // Streaming (critical: C without trailing newline should still create list item)
    final parser2 = CmarkParser();
    final chunks = ['- A\n', '  - B\n', '  - C'];
    int snapshot = 0;
    CmarkNode? lastClone;
    for (final chunk in chunks) {
      parser2.feed(chunk);
      snapshot++;
      final clone = parser2.finishClone();
      print('--- finishClone() snapshot $snapshot after chunk "$chunk" ---');
      print(getStringForTree(clone));
      lastClone = clone;
    }

    final finalCloneOutput = getStringForTree(lastClone!);
    expect(finalCloneOutput, expected, reason: 'Streaming parse matches finish()');
  });
}
