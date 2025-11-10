import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('p code p', () {
    const markdown = 'X\n\n```ts\nY\n```\n\nZ';
    const expected = 'document: ""\n'
        '  paragraph: "X"\n'
        '    text: "X"\n'
        '  code_block: "" info="ts" literal="Y\\n"\n'
        '  paragraph: "Z"\n'
        '    text: "Z"\n'
        '';

    // Non-streaming
    final parser1 = CmarkParser();
    parser1.feed(markdown);
    final doc1 = parser1.finish();
    final nonstreamingOutput = getStringForTree(doc1);
    print('--- finish() ---');
    print(nonstreamingOutput);
    expect(nonstreamingOutput, expected, reason: 'Non-streaming parse');

    // Streaming
    final parser2 = CmarkParser();
    final chunks = ['X\n\n', '```ts\n', 'Y\n', '```\n\n', 'Z'];
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
    expect(finalCloneOutput, expected, reason: 'Streaming parse');
  });
}
