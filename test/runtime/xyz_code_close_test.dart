import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('X code Y code Z - fence closes properly', () {
    const markdown = 'X\n\n```\nY\n```\n\nZ';
    const expected = 'document: ""\n'
            '  paragraph: "X"\n'
            '    text: "X"\n'
            '  code_block: "" info="" literal="Y\\n"\n'
            '  paragraph: "Z"\n'
            '    text: "Z"\n'
            '';

    // Non-streaming
    final parser1 = CmarkParser();
    parser1.feed(markdown);
    final doc1 = parser1.finish();
    final output1 = getStringForTree(doc1);
    print('--- Non-streaming parse tree ---');
    print(output1);
    expect(output1, expected, reason: 'Non-streaming parse');

    // Streaming - critical that Z appears without trailing newline
    final parser2 = CmarkParser();
    final chunks = ['X\n\n', '```\n', 'Y\n', '```\n\n', 'Z'];
    int snapshot = 0;
    CmarkNode? lastClone;
    
    for (final chunk in chunks) {
      parser2.feed(chunk);
      snapshot++;
      final clone = parser2.finishClone();
      print('--- Streaming snapshot $snapshot after chunk "${chunk.replaceAll('\n', '\\n')}" ---');
      print(getStringForTree(clone));
      lastClone = clone;
    }
    final finalCloneOutput = getStringForTree(lastClone!);
    expect(finalCloneOutput, expected, reason: 'Streaming parse matches finish()');
  });
}
