import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

String parseAndRender(String markdown, {CmarkParserOptions options = const CmarkParserOptions()}) {
  final parser = CmarkParser(options: options);
  parser.feed(markdown);
  final doc = parser.finish();
  return HtmlRenderer().render(doc);
}

void main() {
  group('singleTildeStrikethrough option', () {
    test('default: single tilde creates strikethrough', () {
      final html = parseAndRender('Price: ~\$500~ or so');
      
      // Single tildes should create strikethrough by default
      expect(html, contains('<del>'));
    });
    
    test('default: double tilde creates strikethrough', () {
      final html = parseAndRender('This is ~~deleted~~ text');
      
      expect(html, contains('<del>deleted</del>'));
    });
    
    test('singleTildeStrikethrough=false: single tilde is literal', () {
      final html = parseAndRender(
        'Price: ~\$500 to ~\$600',
        options: const CmarkParserOptions(singleTildeStrikethrough: false),
      );
      
      // Single tildes should NOT create strikethrough
      expect(html, isNot(contains('<del>')));
      // Tildes should be preserved as literal text
      expect(html, contains('~\$500'));
      expect(html, contains('~\$600'));
    });
    
    test('singleTildeStrikethrough=false: double tilde still works', () {
      final html = parseAndRender(
        'This is ~~deleted~~ but ~approx~ \$500',
        options: const CmarkParserOptions(singleTildeStrikethrough: false),
      );
      
      // Double tilde should still create strikethrough
      expect(html, contains('<del>deleted</del>'));
      // Single tilde should be literal
      expect(html, contains('~approx~'));
    });
    
    test('real-world case: hotel pricing with approximate values', () {
      final html = parseAndRender(
        '- **Grand Californian**: ~\$585-\$1000/night, averaging **~\$750/night**',
        options: const CmarkParserOptions(singleTildeStrikethrough: false),
      );
      
      // Should NOT have strikethrough
      expect(html, isNot(contains('<del>')));
      // Should preserve the tildes as "approximately"
      expect(html, contains('~\$585'));
      expect(html, contains('~\$750'));
    });
  });
}
