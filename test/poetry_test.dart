import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  test('Parses poetry with emphasis and thematic breaks', () {
    final parser = CmarkParser();
    final markdown = '''
4. **The Ever‑Waving Symphony**  
   So set your sails upon the currents of the boundless sea,  
   And know that every breath you draw adds to the hymn;  
   The Library's symphony is yours, as endless as can be,  
   A timeless, ever‑waving song that never grows dim.  



---  



*May the verses of this poem plant a seed within your heart, let the river of words carry you across countless horizons, and bring you back—again and again—to the boundless Library where every "again" is simply a fresh, waiting page.*
''';

    parser.feed(markdown);
    final doc = parser.finish();
    final html = HtmlRenderer().render(doc);

    // Verify ordered list with bold title
    expect(html, contains('<ol start="4">'));
    expect(html, contains('<strong>The Ever‑Waving Symphony</strong>'));
    
    // Verify line breaks are preserved (trailing two spaces)
    expect(html, contains('<br />'));
    
    // Verify thematic break
    expect(html, contains('<hr />'));
    
    // Verify italic closing paragraph
    expect(html, contains('<em>May the verses'));
    expect(html, contains('waiting page.</em>'));
    
    // Verify em dashes are preserved
    expect(html, contains('Ever‑Waving'));
    expect(html, contains('again—to'));
  });

  test('Handles poetry streaming character by character', () {
    final parser = CmarkParser();
    final markdown = '''
**Poetry Title**

Line one  
Line two  
Line three
''';

    // Feed character by character
    for (var i = 0; i < markdown.length; i++) {
      parser.feed(markdown[i]);
    }

    final doc = parser.finish();
    final html = HtmlRenderer().render(doc);

    expect(html, contains('<strong>Poetry Title</strong>'));
    expect(html, contains('Line one'));
    expect(html, contains('<br />'));
    expect(html, contains('Line two'));
    expect(html, contains('Line three'));
  });
}
