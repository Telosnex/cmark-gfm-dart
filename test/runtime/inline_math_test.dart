import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('Single-dollar inline math is NOT parsed', () {
    const markdown = r'Text $x^2$ more text';
    // Single $ is treated as regular text (may be split into text nodes)

    // Non-streaming
    final parser1 = CmarkParser(options: const CmarkParserOptions(enableMath: true));
    parser1.feed(markdown);
    final doc1 = parser1.finish();
    final output1 = getStringForTree(doc1);
    print('--- finish() ---');
    print(output1);
    expect(output1, isNot(contains('math:')), reason: 'Should not create math nodes');
    expect(output1, contains('\$'), reason: 'Dollar signs should remain in text');

    // Streaming
    final parser2 = CmarkParser(options: const CmarkParserOptions(enableMath: true));
    for (final chunk in ['Text ', r'$x^2$', ' more text']) {
      parser2.feed(chunk);
    }
    final doc2 = parser2.finishClone();
    final output2 = getStringForTree(doc2);
    print('--- finishClone() ---');
    print(output2);
    expect(output2, isNot(contains('math:')), reason: 'Streaming: Should not create math nodes');
    expect(output2, contains('\$'), reason: 'Streaming: Dollar signs should remain');
  });

  test('Double-dollar inline math IS parsed', () {
    const markdown = r'Text $$x^2$$ more';
    const expected = 'document: ""\n'
        '  paragraph: "Text \$\$x^2\$\$ more"\n'
        '    text: "Text "\n'
        '    math: "\$\$x^2\$\$" literal="x^2"\n'
        '    text: " more"\n'
        '';

    // Non-streaming
    final parser1 = CmarkParser(options: const CmarkParserOptions(enableMath: true));
    parser1.feed(markdown);
    final doc1 = parser1.finish();
    final output1 = getStringForTree(doc1);
    print('--- finish() ---');
    print(output1);
    expect(output1, expected, reason: 'Double-dollar should be parsed as math');

    // Streaming
    final parser2 = CmarkParser(options: const CmarkParserOptions(enableMath: true));
    for (final chunk in ['Text ', r'$$x^2$$', ' more']) {
      parser2.feed(chunk);
    }
    final doc2 = parser2.finishClone();
    final output2 = getStringForTree(doc2);
    print('--- finishClone() ---');
    print(output2);
    expect(output2, expected, reason: 'Streaming: Double-dollar should be parsed');
  });

  test('Bracket math \\(x\\) IS parsed', () {
    const markdown = r'Text \(x^2\) more';
    const expected = 'document: ""\n'
        '  paragraph: "Text \\(x^2\\) more"\n'
        '    text: "Text "\n'
        '    math: "\\(x^2\\)" literal="x^2"\n'
        '    text: " more"\n'
        '';

    // Non-streaming
    final parser1 = CmarkParser(options: const CmarkParserOptions(enableMath: true));
    parser1.feed(markdown);
    final doc1 = parser1.finish();
    final output1 = getStringForTree(doc1);
    print('--- finish() ---');
    print(output1);
    expect(output1, expected, reason: 'Bracket inline math should be parsed');

    // Streaming
    final parser2 = CmarkParser(options: const CmarkParserOptions(enableMath: true));
    for (final chunk in ['Text ', r'\(x^2\)', ' more']) {
      parser2.feed(chunk);
    }
    final doc2 = parser2.finishClone();
    final output2 = getStringForTree(doc2);
    print('--- finishClone() ---');
    print(output2);
    expect(output2, expected, reason: 'Streaming: Bracket math should be parsed');
  });
}
