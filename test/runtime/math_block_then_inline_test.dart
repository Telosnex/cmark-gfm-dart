import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('math block followed by paragraph with inline math', () {
    const markdown = r'''Consider the quadratic formula:

$$
x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$

which solves \(ax^2 + bx + c = 0\).''';

    const expected = 'document: ""\n'
        '  paragraph: "Consider the quadratic formula:"\n'
        '    text: "Consider the quadratic formula:"\n'
        r'  math_block: "" literal="x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}"' '\n'
        r'  paragraph: "which solves \(ax^2 + bx + c = 0\)."' '\n'
        r'    text: "which solves "' '\n'
        r'    math: "\(ax^2 + bx + c = 0\)" literal="ax^2 + bx + c = 0"' '\n'
        r'    text: "."' '\n'
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

  test('inline math works by itself', () {
    const markdown = r'which solves \(ax^2 + bx + c = 0\).';

    const expected = 'document: ""\n'
        r'  paragraph: "which solves \(ax^2 + bx + c = 0\)."' '\n'
        r'    text: "which solves "' '\n'
        r'    math: "\(ax^2 + bx + c = 0\)" literal="ax^2 + bx + c = 0"' '\n'
        r'    text: "."' '\n'
        '';

    final parser = CmarkParser(
      options: const CmarkParserOptions(
        enableMath: true,
        mathOptions: CmarkMathOptions(
          allowBlockDoubleDollar: true,
          allowBracketDelimiters: true,
        ),
      ),
    );
    parser.feed(markdown);
    final doc = parser.finish();
    final output = getStringForTree(doc);
    print('--- standalone inline math ---');
    print(output);
    expect(output, expected, reason: 'Standalone inline math');
  });
}
