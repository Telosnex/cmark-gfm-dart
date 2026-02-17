import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  late CmarkParser parser;
  late HtmlRenderer renderer;

  setUp(() {
    parser = CmarkParser(
      options: const CmarkParserOptions(
        enableMath: true,
        mathOptions: CmarkMathOptions(allowSingleDollar: true),
      ),
    );
    renderer = HtmlRenderer();
  });

  String render(String input) {
    parser.feed(input);
    final doc = parser.finish();
    return renderer.render(doc).trim();
  }

  group('Single-dollar math - Money Guard', () {
    test('rejects currency: \$20 and \$30', () {
      final html = render(r'The price is $20 and $30.');
      expect(html, contains(r'$20'));
      expect(html, contains(r'$30'));
      expect(html, isNot(contains('math')));
    });

    test('rejects currency: costs \$5', () {
      final html = render(r'It costs $5.');
      expect(html, contains(r'$5'));
      expect(html, isNot(contains('math')));
    });

    test('rejects: \$20 times two is \$40', () {
      // The classic problematic case
      final html = render(r'$20 times two is $40');
      expect(html, contains(r'$20'));
      expect(html, contains(r'$40'));
      expect(html, isNot(contains('math')));
    });

    test('accepts valid math: \$x^2\$', () {
      final html = render(r'Calculate $x^2$ now.');
      expect(html, contains('math'));
      expect(html, contains('x^2'));
    });

    test('accepts valid math: \$a + b\$', () {
      final html = render(r'The sum $a + b$ is positive.');
      expect(html, contains('math'));
      expect(html, contains('a + b'));
    });

    test('accepts math ending with number: \$x + 5\$', () {
      // This should work - the rule is about what follows the closing $
      final html = render(r'Solve $x + 5$ for x.');
      expect(html, contains('math'));
      expect(html, contains('x + 5'));
    });

    test('rejects: preceded by word char (var\$x)', () {
      // Should NOT match because $ is preceded by 'r'
      final html = render(r'The variable var$x$ is undefined.');
      expect(html, isNot(contains('class="math')));
    });

    test('rejects: space after opening \$', () {
      final html = render(r'This $ x$ here.');
      expect(html, isNot(contains('class="math')));
    });

    test('rejects: space before closing \$', () {
      final html = render(r'This $x $ here.');
      expect(html, isNot(contains('class="math')));
    });

    test('rejects: spaced dollar signs', () {
      // Two separate $ with space between - neither is valid math
      final html = render(r'Price $ 5 $ here.');
      expect(html, isNot(contains('class="math')));
    });

    test('rejects: JSON Schema style \$id/\$schema', () {
      // Path-like patterns with / before closing $ should not be math
      final html = render(r'Baseline (no $id/$schema/title/description)');
      expect(html, contains(r'$id'));
      expect(html, contains(r'$schema'));
      expect(html, isNot(contains('class="math')));
    });

    test('accepts: math with punctuation after', () {
      final html = render(r'We have $x^2$, $y^2$, and $z^2$.');
      expect(html, contains('x^2'));
      expect(html, contains('y^2'));
      expect(html, contains('z^2'));
      // Should have 3 math spans (count the opening tags)
      expect('<span class="math'.allMatches(html).length, equals(3));
    });

    test('accepts: complex LaTeX', () {
      final html = render(r'The formula $\frac{a}{b}$ is a fraction.');
      expect(html, contains('math'));
      expect(html, contains(r'\frac{a}{b}'));
    });

    test('rejects: US\$50 (word char before)', () {
      final html = render(r'It costs US$50 dollars.');
      expect(html, isNot(contains('math')));
    });

    test('rejects: OData query params \$filter/\$search', () {
      final html = render(
          r'GET /users?$filter=... or GET /people?$search=...');
      expect(html, contains(r'$filter'));
      expect(html, contains(r'$search'));
      expect(html, isNot(contains('class="math')));
    });

    test('rejects: OData params with ampersand', () {
      final html = render(r'OData: $top=10&$skip=20&$count=true');
      expect(html, contains(r'$top'));
      expect(html, contains(r'$skip'));
      expect(html, isNot(contains('class="math')));
    });

    test('mixed: currency and math in same line', () {
      final html = render(r'For $20, you get $x^2$ calculations.');
      // $20 should stay as text (digit after closing would need another $)
      // $x^2$ should become math
      expect(html, contains(r'$20'));
      expect(html, contains('class="math'));
      expect(html, contains('x^2'));
    });
  });

  group('Single-dollar math - Edge cases', () {
    test('handles escaped dollar in content', () {
      // Backslash-dollar inside math
      final html = render(r'Price is $\$5$ in math.');
      expect(html, contains('math'));
    });

    test('single char math: \$x\$', () {
      final html = render(r'Variable $x$ here.');
      expect(html, contains('math'));
      expect(html, contains('>x<'));
    });

    test('number in math with letter: \$5x\$', () {
      final html = render(r'Expression $5x$ here.');
      expect(html, contains('math'));
      expect(html, contains('5x'));
    });

    test('large number with exponent: \$1048576^{0.05}\$', () {
      // Starts with digits but has ^ before whitespace - valid math
      final html = render(r'Calculate $1048576^{0.05}$ for me.');
      expect(html, contains('class="math'));
      expect(html, contains(r'1048576^{0.05}'));
    });

    test('formatted number without whitespace: \$1,048,576\$', () {
      // No whitespace in content = no cross-span ambiguity, allow it
      final html = render(r'The number $1,048,576$ is a power of 2.');
      expect(html, contains('class="math'));
      expect(html, contains('1,048,576'));
    });

    test('numeric math with equals: \$1048576 = 2^{20}\$', () {
      final html =
          render(r'can be solved by recognizing that $1048576 = 2^{20}$');
      expect(html, contains('class="math'));
      expect(html, contains(r'1048576 = 2^{20}'));
    });

    test('preserves double-dollar precedence', () {
      final html = render(r'Display $$E=mc^2$$ math.');
      expect(html, contains('math-display'));
      expect(html, contains('E=mc^2'));
    });
  });
}
