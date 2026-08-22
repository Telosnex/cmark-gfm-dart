import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('cost formulae parse as three display math blocks', () {
    const markdown = r'''
\[
oldOutputCost = T_{out} \times oldOutputPrice
\]

\[
oldInputCacheCost = publishedCost - oldOutputCost
\]

\[
newCost \approx
oldOutputCost \frac{newOutputPrice}{oldOutputPrice}
+
oldInputCacheCost \frac{newInputPrice}{oldInputPrice}
\]
''';

    final parser = CmarkParser(
      options: const CmarkParserOptions(
        enableMath: true,
        mathOptions: CmarkMathOptions(allowBracketDelimiters: true),
      ),
    )..feed(markdown);

    final output = getStringForTree(parser.finish());

    const expected = 'document: ""\n'
        r'  math_block: "" literal="oldOutputCost = T_{out} \times oldOutputPrice"'
        '\n'
        r'  math_block: "" literal="oldInputCacheCost = publishedCost - oldOutputCost"'
        '\n'
        r'  math_block: "" literal="newCost \approx\noldOutputCost \frac{newOutputPrice}{oldOutputPrice}\n+\noldInputCacheCost \frac{newInputPrice}{oldInputPrice}"'
        '\n';

    expect(output, expected);
  });
}
