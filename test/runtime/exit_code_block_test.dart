import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('exit code block properly', () {
    const markdown = r'''# A

B
```bash
C
```  
D''';

    const expected = 'document: ""\n'
        '  heading: "A"\n'
        '    text: "A"\n'
        '  paragraph: "B"\n'
        '    text: "B"\n'
        '  code_block: "" info="bash" literal="C\\n"\n'
        '  paragraph: "D"\n'
        '    text: "D"\n'
        '';

    // Non-streaming
    final parser1 = CmarkParser(
      options: const CmarkParserOptions(
        enableMath: true,
        mathOptions: CmarkMathOptions(
          allowBlockDoubleDollar: true,
          allowBracketDelimiters: true,
        ),
      ),
    );
    parser1.feed(markdown);
    final doc1 = parser1.finish();
    final nonstreamingOutput = getStringForTree(doc1);
    print('--- finish() ---');
    print(nonstreamingOutput);
    expect(nonstreamingOutput, expected, reason: 'Non-streaming parse');
  });
}
