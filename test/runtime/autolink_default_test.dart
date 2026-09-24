import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  String render(String markdown, {CmarkParserOptions? options}) {
    final parser = CmarkParser(options: options ?? const CmarkParserOptions())
      ..feed(markdown);
    return HtmlRenderer().render(parser.finish());
  }

  test('bare URLs, www domains, and email autolink by default', () {
    final html = render(
      'Visit https://example.com/path. Then www.example.org, '
      'or email user@example.com.',
    );
    expect(
        html,
        contains(
            '<a href="https://example.com/path">https://example.com/path</a>.'));
    expect(html,
        contains('<a href="http://www.example.org">www.example.org</a>, '));
    expect(html,
        contains('<a href="mailto:user@example.com">user@example.com</a>.'));
  });

  test('explicit opt-out leaves bare addresses as text', () {
    final html = render(
      'https://example.com and user@example.com',
      options: const CmarkParserOptions(enableAutolinkExtension: false),
    );
    expect(html, '<p>https://example.com and user@example.com</p>\n');
  });

  test('explicit links and angle autolinks are not nested or duplicated', () {
    final html = render(
      '[see https://example.com](https://destination.test) '
      '<https://example.org> `https://inline.test`',
    );
    expect(
        html,
        contains(
            '<a href="https://destination.test">see https://example.com</a>'));
    expect(html,
        contains('<a href="https://example.org">https://example.org</a>'));
    expect(html, contains('<code>https://inline.test</code>'));
    expect(RegExp('<a ').allMatches(html), hasLength(2));
  });

  test('URLs inside fenced code are not autolinked', () {
    final html = render('```\nhttps://example.com\n```');
    expect(html, contains('<code>https://example.com'));
    expect(html, isNot(contains('<a ')));
  });

  test('default survives maxReferenceSize convenience constructor', () {
    final parser = CmarkParser(maxReferenceSize: 100)
      ..feed('https://example.com');
    expect(HtmlRenderer().render(parser.finish()),
        contains('<a href="https://example.com">'));
  });

  test('incremental snapshots autolink as soon as address is complete', () {
    final parser = CmarkParser()..feed('Visit https://example.com');
    expect(HtmlRenderer().render(parser.finishClone()),
        contains('<a href="https://example.com">'));
    parser.feed('/path and later text');
    final html = HtmlRenderer().render(parser.finishClone());
    expect(
        html,
        contains(
            '<a href="https://example.com/path">https://example.com/path</a>'));
    expect(RegExp('<a ').allMatches(html), hasLength(1));
  });
}
