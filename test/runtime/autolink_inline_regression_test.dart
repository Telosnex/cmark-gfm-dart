import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

String _render(String source, {bool enabled = true}) {
  final parser = CmarkParser(
    options: CmarkParserOptions(enableAutolinkExtension: enabled),
  )..feed(source);
  return HtmlRenderer().render(parser.finish());
}

void main() {
  test('an unmatched bracket suppresses inline URL and www autolinks', () {
    expect(_render('[https://example.com and [www.example.org'),
        '<p>[https://example.com and [www.example.org</p>\n');
    expect(_render('![https://example.com'), '<p>![https://example.com</p>\n');
    expect(_render('after ] https://example.com'),
        contains('<a href="https://example.com">https://example.com</a>'));
  });

  test('www uses the cmark boundary, not any punctuation or uppercase W', () {
    expect(_render('a.www.example.com, )www.example.org Www.example.net'),
        '<p>a.www.example.com, )www.example.org Www.example.net</p>\n');
    expect(_render('www.example.com (www.example.org'),
        contains('<a href="http://www.example.org">www.example.org</a>'));
  });

  test('mail addresses survive adjacent schemes, markup and snapshots', () {
    final parser = CmarkParser()..feed('Email user@example.com and ');
    expect(HtmlRenderer().render(parser.finishClone()),
        contains('<a href="mailto:user@example.com">user@example.com</a>'));
    parser.feed('mailto:person@example.org or xmpp:chat@example.net');
    final html = HtmlRenderer().render(parser.finishClone());
    expect(html, contains('<a href="mailto:person@example.org">'));
    expect(html, contains('<a href="xmpp:chat@example.net">'));
    expect(RegExp('<a ').allMatches(html), hasLength(3));
    expect(
        _render('`user@example.com` [user@example.com](https://dest.test)'),
        '<p><code>user@example.com</code> '
        '<a href="https://dest.test">user@example.com</a></p>\n');
  });

  test('disabling autolinks is per parser, even after enabled parser', () {
    expect(_render('www.example.com http://example.com', enabled: false),
        '<p>www.example.com http://example.com</p>\n');
    expect(_render('www.example.com http://example.com'),
        contains('<a href="http://www.example.com">'));
    expect(_render('www.example.com http://example.com', enabled: false),
        '<p>www.example.com http://example.com</p>\n');
  });

  test('angle autolinks with UTF-8 keep the correct byte offsets', () {
    expect(
        _render('<https://example.com/é> https://example.com/é'),
        '<p><a href="https://example.com/%C3%A9">https://example.com/é</a> '
        '<a href="https://example.com/%C3%A9">https://example.com/é</a></p>\n');
  });

  test('underscores in the final two labels are rejected in a single scan', () {
    expect(_render('www.foo._bar.com and http://foo._bar.com'),
        '<p>www.foo._bar.com and http://foo._bar.com</p>\n');
    expect(_render('www._foo.bar.com'),
        contains('<a href="http://www._foo.bar.com">www._foo.bar.com</a>'));
  });

  test('a long plain snapshot leaves its contents unchanged', () {
    final text = 'words with no addresses. ' * 4000;
    final parser = CmarkParser()..feed(text);
    final snapshot = parser.finishClone();
    expect(snapshot.firstChild!.firstChild!.contentString, text.trimRight());
    expect(snapshot.firstChild!.firstChild!.type, CmarkNodeType.text);
  });

  test('plain prose with w and colons has the same output as no autolinks', () {
    final text = 'We wrote words: when, where, why, and how. ' * 200;
    expect(_render(text), _render(text, enabled: false));
  });

  test('email entities and escapes still link without a literal at sign', () {
    for (final source in [
      'user&#64;example.org',
      'user&commat;example.org',
      r'user\@example.org',
    ]) {
      expect(_render(source),
          '<p><a href="mailto:user@example.org">user@example.org</a></p>\n');
    }
  });

  test('streaming snapshot detects a link split across feeds', () {
    final parser = CmarkParser()..feed('We wrote words: www');
    expect(HtmlRenderer().render(parser.finishClone()),
        '<p>We wrote words: www</p>\n');
    parser.feed('.example.com and user&commat;example.org');
    final html = HtmlRenderer().render(parser.finishClone());
    expect(html, contains('<a href="http://www.example.com">'));
    expect(html, contains('<a href="mailto:user@example.org">'));
  });
}
