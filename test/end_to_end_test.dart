import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  group('End-to-end parsing and rendering', () {
    test('renders simple paragraph', () {
      final parser = CmarkParser();
      parser.feed('Hello world');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, '<p>Hello world</p>\n');
    });

    test('renders paragraph with emphasis', () {
      final parser = CmarkParser();
      parser.feed('Hello *world*');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, '<p>Hello <em>world</em></p>\n');
    });

    test('renders paragraph with strong', () {
      final parser = CmarkParser();
      parser.feed('Hello **world**');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, '<p>Hello <strong>world</strong></p>\n');
    });

    test('renders paragraph with code span', () {
      final parser = CmarkParser();
      parser.feed('Hello `code` world');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, '<p>Hello <code>code</code> world</p>\n');
    });

    test('backtick cache not poisoned by failed long-backtick scan', () {
      // A failed 4-backtick scan records all single-backtick positions.
      // A successful 1-backtick scan must not overwrite those positions
      // with lower values, or later 1-backtick pairs silently fail.
      final parser = CmarkParser();
      parser.feed(r'````a`b`c`d`e');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, '<p>````a<code>b</code>c<code>d</code>e</p>\n');
    });

    test('backtick cache: code spans in table after unmatched 4-backtick', () {
      // Real-world case: a table cell containing ````lua` plus later
      // `code` spans. The 4-backtick run fails to match, then the
      // first 1-backtick match must not poison the cache so that
      // subsequent 1-backtick pairs still work.
      final parser = CmarkParser();
      parser.feed(
        '| # | Fix |\n'
        '|---|-----|\n'
        '| 2 | Restored content in ````lua` block + response. '
            'Restored `Icons.calculate` icon and `"Code"` fallback label |\n',
      );
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      // Three code spans: "block + response. Restored", "icon and", and the
      // unmatched trailing backtick stays literal.
      expect(html, contains('<code>block + response. Restored</code>'));
      expect(html, contains('<code>icon and</code>'));
      expect(html, contains('Icons.calculate'));
      expect(html, isNot(contains('<code>Icons.calculate</code>')));
    });

    test('renders heading', () {
      final parser = CmarkParser();
      parser.feed('# Heading');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, '<h1>Heading</h1>\n');
    });

    test('renders list', () {
      final parser = CmarkParser();
      parser.feed('- item one\n- item two');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, contains('<ul>'));
      expect(html, contains('item one'));
      expect(html, contains('item two'));
    });

    test('renders code block', () {
      final parser = CmarkParser();
      parser.feed('```dart\nfinal x = 1;\n```');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, contains('<pre><code class="language-dart">'));
      expect(html, contains('final x = 1;'));
    });

    test('renders link with reference', () {
      final parser = CmarkParser();
      parser.feed('[link][ref]\n\n[ref]: http://example.com "Title"');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html,
          contains('<a href="http://example.com" title="Title">link</a>'));
    });

    test('renders strikethrough (GFM)', () {
      final parser = CmarkParser();
      parser.feed('Hello ~~world~~');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, '<p>Hello <del>world</del></p>\n');
    });

    test('renders single tilde strikethrough', () {
      final parser = CmarkParser();
      parser.feed('Hello ~world~');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, '<p>Hello <del>world</del></p>\n');
    });

    test('renders task list (GFM)', () {
      final parser = CmarkParser();
      parser.feed('- [ ] Unchecked\n- [x] Checked');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, contains('<input type="checkbox" disabled="" />'));
      expect(
          html, contains('<input type="checkbox" checked="" disabled="" />'));
      expect(html, contains('Unchecked'));
      expect(html, contains('Checked'));
    });

    test('renders autolink URL', () {
      final parser = CmarkParser();
      parser.feed('Visit <http://example.com>');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html,
          contains('<a href="http://example.com">http://example.com</a>'));
    });

    test('renders autolink email', () {
      final parser = CmarkParser();
      parser.feed('Email <user@example.com>');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html,
          contains('<a href="mailto:user@example.com">user@example.com</a>'));
    });

    test('renders table (GFM)', () {
      final parser = CmarkParser();
      parser
          .feed('| Header 1 | Header 2 |\n| --- | --- |\n| Cell 1 | Cell 2 |');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, contains('<table>'));
      expect(html, contains('<th>Header 1</th>'));
      expect(html, contains('<th>Header 2</th>'));
      expect(html, contains('<td>Cell 1</td>'));
      expect(html, contains('<td>Cell 2</td>'));
    });

    test('renders table with alignment', () {
      final parser = CmarkParser();
      parser.feed(
          '| Left | Center | Right |\n| :--- | :---: | ---: |\n| A | B | C |');
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);
      expect(html, contains('align="left"'));
      expect(html, contains('align="center"'));
      expect(html, contains('align="right"'));
    });
  });
}
