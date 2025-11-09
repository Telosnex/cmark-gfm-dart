import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  group('Footnote parsing', () {
    test('parses footnote definition and reference', () {
      final parser = CmarkParser();
      parser.feed('Text with footnote[^1].\n\n[^1]: Footnote content');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      
      expect(html, contains('footnote-ref'));
      expect(html, contains('href="#fn-1"'));
      expect(html, contains('Footnote content'));
    });

    test('handles multiple footnotes', () {
      final parser = CmarkParser();
      parser.feed('''
First[^1] and second[^2].

[^1]: First footnote
[^2]: Second footnote
''');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      
      expect(html, contains('First footnote'));
      expect(html, contains('Second footnote'));
      expect(html, contains('href="#fn-1"'));
      expect(html, contains('href="#fn-2"'));
    });

    test('footnotes appear at end of document', () {
      final parser = CmarkParser();
      parser.feed('''
[^1]: Definition at top

Text with footnote[^1].
''');
      final doc = parser.finish();
      
      // Verify footnote definition is last child
      var lastChild = doc.firstChild;
      while (lastChild?.next != null) {
        lastChild = lastChild!.next;
      }
      expect(lastChild?.type, CmarkNodeType.footnoteDefinition);
    });

    test('handles footnote with complex content', () {
      final parser = CmarkParser();
      parser.feed('''
Text[^note].

[^note]: This has **bold** and *italic* text.
''');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      
      expect(html, contains('<strong>bold</strong>'));
      expect(html, contains('<em>italic</em>'));
    });
  });
}
