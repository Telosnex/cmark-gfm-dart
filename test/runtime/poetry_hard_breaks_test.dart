import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('poetry with hard line breaks', () {
    const markdown = '''4. **The Ever‑Waving Symphony**  
   So set your sails upon the currents of the boundless sea,  
   And know that every breath you draw adds to the hymn;  
   The Library's symphony is yours, as endless as can be,  
   A timeless, ever‑waving song that never grows dim.  



---  



*May the verses of this poem plant a seed within your heart, let the river of words carry you across countless horizons, and bring you back—again and again—to the boundless Library where every "again" is simply a fresh, waiting page.*''';
    const expected = 'document: ""\n'
        '  list: ""\n'
        '    item: ""\n'
        '      paragraph: "**The Ever‑Waving Symphony**  \\nSo set your sails upon the currents of the boundless sea,  \\nAnd know that every breath you draw adds to the hymn;  \\nThe Library\'s symphony is yours, as endless as can be,  \\nA timeless, ever‑waving song that never grows dim.  "\n'
        '        strong: ""\n'
        '          text: "The Ever‑Waving Symphony"\n'
        '        text: ""\n'
        '        linebreak: ""\n'
        '        text: "So set your sails upon the currents of the boundless sea,"\n'
        '        linebreak: ""\n'
        '        text: "And know that every breath you draw adds to the hymn;"\n'
        '        linebreak: ""\n'
        '        text: "The Library\'s symphony is yours, as endless as can be,"\n'
        '        linebreak: ""\n'
        '        text: "A timeless, ever‑waving song that never grows dim."\n'
        '  thematic_break: ""\n'
        '  paragraph: "*May the verses of this poem plant a seed within your heart, let the river of words carry you across countless horizons, and bring you back—again and again—to the boundless Library where every "again" is simply a fresh, waiting page.*"\n'
        '    emph: ""\n'
        '      text: "May the verses of this poem plant a seed within your heart, let the river of words carry you across countless horizons, and bring you back—again and again—to the boundless Library where every "again" is simply a fresh, waiting page."\n'
        '';
    // Non-streaming
    final parser1 = CmarkParser();
    parser1.feed(markdown);
    final doc1 = parser1.finish();
    final output1 = getStringForTree(doc1);
    print('--- Non-streaming parse tree ---');
    print(output1);
    expect(output1, expected, reason: 'Non-streaming parse');

    // Streaming
    final parser2 = CmarkParser();
    final chunks = splitIntoChunks(markdown, chunkSize: 100);
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
