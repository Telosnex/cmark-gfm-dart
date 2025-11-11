import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('simple math block', () {
    const markdown = r'''$$
x = 5
$$''';

    final parser = CmarkParser(
      options: const CmarkParserOptions(enableMath: true),
    );
    parser.feed(markdown);
    final doc = parser.finish();
    final output = getStringForTree(doc);
    print('--- simple math block ---');
    print(output);
  });

  test('math block then text', () {
    const markdown = r'''$$
x = 5
$$
hello''';

    final parser = CmarkParser(
      options: const CmarkParserOptions(enableMath: true),
    );
    parser.feed(markdown);
    final doc = parser.finish();
    final output = getStringForTree(doc);
    print('--- math block then text ---');
    print(output);
  });
}
