import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

/// Tests that \[...\] display math only triggers at start of line,
/// not mid-sentence where it conflicts with escaped brackets.
void main() {
  group(r'Bracket math \[...\] position sensitivity', () {
    test(r'mid-line \[Delete\] should be escaped brackets, not math', () {
      final html = _render(r'menu: \[Delete\]');
      expect(html, contains('[Delete]'));
      expect(html, isNot(contains('math')));
    });

    test(r'mid-line \[Download, Delete\] should be escaped brackets', () {
      final html = _render(r'menu: \[Download, Delete\]');
      expect(html, contains('[Download, Delete]'));
      expect(html, isNot(contains('math')));
    });

    test(r'table cell with \[Delete\] should not become math', () {
      final html = _render(
        '| Col |\n|---|\n| menu: \\[Delete\\] |',
      );
      expect(html, contains('[Delete]'));
      expect(html, isNot(contains('math')));
    });

    test(r'start-of-line \[x^2\] should still be display math', () {
      final html = _render(r'\[x^2\]');
      expect(html, contains('math'));
      expect(html, contains('x^2'));
    });

    test(r'start-of-line with leading spaces \[x^2\] is display math', () {
      final html = _render(r'  \[x^2\]');
      // The paragraph strips leading whitespace before inline parsing,
      // so this should still match as start-of-content.
      expect(html, contains('math'));
    });

    test(r'inline \(...\) still works anywhere', () {
      final html = _render(r'result is \(x^2\) here');
      expect(html, contains('math'));
      expect(html, contains('x^2'));
    });

    test(r'\[x\] mid-sentence is NOT math', () {
      final html = _render(r'the value \[x\] is important');
      expect(html, isNot(contains('math')));
      expect(html, contains('[x]'));
    });

    test(r'real-world table from JSON with escaped brackets', () {
      final html = _render(
        '| Element | Implementation |\n'
        '|---------|---------------|\n'
        r'| Directory row | menu: \[Delete\] |'
        '\n'
        r'| File row | menu: \[Download, Delete\] |',
      );
      expect(html, contains('[Delete]'));
      expect(html, contains('[Download, Delete]'));
      expect(html, isNot(contains('math')));
    });
  });
}

String _render(String markdown) {
  final parser = CmarkParser(
    options: CmarkParserOptions(
      mathOptions: CmarkMathOptions(allowBracketDelimiters: true),
    ),
  );
  parser.feed(markdown);
  return HtmlRenderer().render(parser.finish());
}
