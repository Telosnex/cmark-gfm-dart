// Expected HTML was produced by the C reference implementation:
//   cmark-gfm 0.29.0.gfm.13 (github/cmark-gfm 587a12b), built from source,
//   cmark-gfm --unsafe -e autolink -e strikethrough -e table -e tasklist
// Math is disabled because C has no math extension.
import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

String _render(String markdown) {
  final parser = CmarkParser(
    options: const CmarkParserOptions(enableMath: false),
  )..feed(markdown);
  return HtmlRenderer().render(parser.finish());
}

void main() {
  group('autolinks match cmark-gfm', () {
    test("a scheme consumed by the previous link cannot prefix the next one",
        () {
      expect(_render("foo@bar.baz_mailto:a@b.co"),
          "<p><a href=\"mailto:foo@bar.baz_mailto\">foo@bar.baz_mailto</a>:<a href=\"mailto:a@b.co\">a@b.co</a></p>\n");
    });
    test(
        "an escaped underscore counts in check_domain; the email pass links it",
        () {
      expect(_render("www.foo\\_bar@baz.org"),
          "<p><a href=\"mailto:www.foo_bar@baz.org\">www.foo_bar@baz.org</a></p>\n");
    });
    test("URL links keep source bytes; entities are not decoded", () {
      expect(_render("https://ex.com/?q=1&amp;r=2"),
          "<p><a href=\"https://ex.com/?q=1&amp;amp;r=2\">https://ex.com/?q=1&amp;amp;r=2</a></p>\n");
    });
    test("www links keep source bytes too", () {
      expect(_render("www.ex.com/a&amp;b"),
          "<p><a href=\"http://www.ex.com/a&amp;amp;b\">www.ex.com/a&amp;amp;b</a></p>\n");
    });
    test("no Dart-only angle-bracket suppression", () {
      expect(_render("< u@v.com >"),
          "<p>&lt; <a href=\"mailto:u@v.com\">u@v.com</a> &gt;</p>\n");
    });
    test("brackets around a postprocessed email stay text", () {
      expect(_render("<foo\\+@bar.example.com>"),
          "<p>&lt;<a href=\"mailto:foo+@bar.example.com\">foo+@bar.example.com</a>&gt;</p>\n");
    });
    test("a second @ restarts the scan (goto found_at)", () {
      expect(_render("a&commat;c.net\\@[x@y.com]"),
          "<p>a@c.net@[<a href=\"mailto:x@y.com\">x@y.com</a>]</p>\n");
    });
    test("after a restart, C keeps auto_mailto from the first scan", () {
      expect(_render("] mailto:a@b.coe@x.com/"),
          "<p>] mailto:a@<a href=\"b.coe@x.com\">b.coe@x.com</a>/</p>\n");
    });
    test("np is not reset when the scan restarts", () {
      expect(_render("a.b@c.d.ea&#64;b.orga:"),
          "<p>a.b@<a href=\"mailto:c.d.ea@b.orga\">c.d.ea@b.orga</a>:</p>\n");
    });
    test("the first host character must not be punctuation", () {
      expect(_render("http://-foo.com http://.x.com http://_x.com"),
          "<p>http://-foo.com http://.x.com http://_x.com</p>\n");
    });
    test("check_domain does not inspect the last byte of the content", () {
      expect(_render("see www.foo.b_"),
          "<p>see <a href=\"http://www.foo.b\">www.foo.b</a>_</p>\n");
    });
    test("protocols are case-sensitive", () {
      expect(_render("MAILTO:a@b.co and mailto:a@b.co"),
          "<p>MAILTO:<a href=\"mailto:a@b.co\">a@b.co</a> and <a href=\"mailto:a@b.co\">mailto:a@b.co</a></p>\n");
    });
    test("backslashes stay in URL links", () {
      expect(_render("http://x.com/a\\_b"),
          "<p><a href=\"http://x.com/a%5C_b\">http://x.com/a\\_b</a></p>\n");
    });
    test("domain checks stop at a UTF-8 continuation byte", () {
      expect(_render("http://ä.b_c www.ä.b_c www.a.b_c"),
          "<p><a href=\"http://%C3%A4.b_c\">http://ä.b_c</a> <a href=\"http://www.%C3%A4.b_c\">www.ä.b_c</a> www.a.b_c</p>\n");
    });
    test("more than ten dots accept underscores (GHSA-29g3-96g3-jg6c)", () {
      expect(_render("www.a.b.c.d.e.f.g.h.i.j.k.l_m"),
          "<p><a href=\"http://www.a.b.c.d.e.f.g.h.i.j.k.l_m\">www.a.b.c.d.e.f.g.h.i.j.k.l_m</a></p>\n");
    });
    test("emails accept underscores in the domain", () {
      expect(_render("user@exa_mple.com"),
          "<p><a href=\"mailto:user@exa_mple.com\">user@exa_mple.com</a></p>\n");
    });
    test("trailing punctuation and invalid final characters", () {
      expect(_render("x@y.com. x@y.com/ x@y.co_"),
          "<p><a href=\"mailto:x@y.com\">x@y.com</a>. <a href=\"mailto:x@y.com\">x@y.com</a>/ x@y.co_</p>\n");
    });
    test("only xmpp links continue past /", () {
      expect(_render("xmpp:me@chat.org/res/more x mailto:me@chat.org/res"),
          "<p><a href=\"xmpp:me@chat.org/res/more\">xmpp:me@chat.org/res/more</a> x <a href=\"mailto:me@chat.org\">mailto:me@chat.org</a>/res</p>\n");
    });
    test("underscores in the last two labels only", () {
      expect(_render("http://a.b_c.d www._foo.bar.com"),
          "<p>http://a.b_c.d <a href=\"http://www._foo.bar.com\">www._foo.bar.com</a></p>\n");
    });
    test("a trailing entity is removed; an inner one is kept", () {
      expect(_render("www.x.com&lt; www.x.com&lt;a"),
          "<p><a href=\"http://www.x.com\">www.x.com</a>&lt; <a href=\"http://www.x.com&amp;lt;a\">www.x.com&amp;lt;a</a></p>\n");
    });
    test("parentheses and emphasis delimiters", () {
      expect(_render("(www.x.com) (http://y.com)) _www.z.com_"),
          "<p>(<a href=\"http://www.x.com\">www.x.com</a>) (<a href=\"http://y.com\">http://y.com</a>)) <em><a href=\"http://www.z.com\">www.z.com</a></em></p>\n");
    });
  });

  // Short inputs from a randomized comparison with the C implementation.
  // Each one differed from C before this port.
  const generated = <(String, String)>[
    ("www.'", "<p><a href=\"http://www\">www</a>.'</p>\n"),
    ("'@b.c![", "<p>'@b.c![</p>\n"),
    ("~a@b.co", "<p>~<a href=\"mailto:a@b.co\">a@b.co</a></p>\n"),
    ("www.  🙂", "<p><a href=\"http://www\">www</a>.  🙂</p>\n"),
    ("*@b.c🙂[", "<p>*@b.c🙂[</p>\n"),
    ("@~www.\n?", "<p>@~<a href=\"http://www\">www</a>.\n?</p>\n"),
    ("((ftp://、'", "<p>((ftp://、'</p>\n"),
    ("ftp://w\\~|", "<p><a href=\"ftp://w%5C~%7C\">ftp://w\\~|</a></p>\n"),
    ("ftp://..# ", "<p>ftp://..#</p>\n"),
    ("](www..>__", "<p>](<a href=\"http://www..%3E\">www..&gt;</a>__</p>\n"),
    ("http://.org", "<p>http://.org</p>\n"),
    ("?q=1a@b.co&", "<p>?q=<a href=\"mailto:1a@b.co\">1a@b.co</a>&amp;</p>\n"),
    ("http://~~\\_", "<p>http://~~_</p>\n"),
    ("http:// :ftp", "<p>http:// :ftp</p>\n"),
    (
      "www.&; \\_!&;",
      "<p><a href=\"http://www.&amp;\">www.&amp;</a>; _!&amp;;</p>\n"
    ),
    (
      "- «![?a@b.co",
      "<ul>\n<li>«![?<a href=\"mailto:a@b.co\">a@b.co</a></li>\n</ul>\n"
    ),
    ("`[~@b.c# http", "<p>`[~@b.c# http</p>\n"),
    ("%20a@?a@b.co\\", "<p>%20a@?<a href=\"mailto:a@b.co\">a@b.co</a>\\</p>\n"),
    ("日本@@a@b.co\\@/", "<p>日本@@a@b.co@/</p>\n"),
    ("@@https://、'`", "<p>@@https://、'`</p>\n"),
    ("、a_b- ``a@b.co", "<p>、a_b- ``<a href=\"mailto:a@b.co\">a@b.co</a></p>\n"),
    (
      "`ftp://🙂—(\\.]w",
      "<p>`<a href=\"ftp://%F0%9F%99%82%E2%80%94(%5C.%5Dw\">ftp://🙂—(\\.]w</a></p>\n"
    ),
    ("a_b'https://~🙂", "<p>a_b'https://~🙂</p>\n"),
    ("ftp|@b.c@@- >#", "<p>ftp|@b.c@@- &gt;#</p>\n"),
    ("日本ftp://.com\\_x", "<p>日本ftp://.com_x</p>\n"),
    ("WWW.&w*http://、", "<p>WWW.&amp;w*http://、</p>\n"),
    ("|'|@b.c日本&quot;", "<p>|'|@b.c日本&quot;</p>\n"),
    (
      "www.&#x40;barww",
      "<p><a href=\"http://www.&amp;#x40;barww\">www.&amp;#x40;barww</a></p>\n"
    ),
    ("ftp://-))=🙂<~~,", "<p>ftp://-))=🙂&lt;~~,</p>\n"),
    ("wwxmpp:http:// ", "<p>wwxmpp:http:// </p>\n"),
    ("..https://« 🙂\n\n", "<p>..https://« 🙂</p>\n"),
    (
      "\\@—foo\\**www@b.c",
      "<p>@—foo**<a href=\"mailto:www@b.c\">www@b.c</a></p>\n"
    ),
    ("![:*@b.c—..a_b)<", "<p>![:*@b.c—..a_b)&lt;</p>\n"),
    ("ftp:// 'httpw&'~", "<p>ftp:// 'httpw&amp;'~</p>\n"),
    (
      "MAILTO:__ftp@b.c",
      "<p>MAILTO:<a href=\"mailto:__ftp@b.c\">__ftp@b.c</a></p>\n"
    ),
    ("!&#64;.comümlaut", "<p>!@.comümlaut</p>\n"),
    ("#a@b.co&#64;:x\\*", "<p>#a@b.co@:x*</p>\n"),
    (
      "'\\.;«x>\\*\\*a@b.co",
      "<p>'.;«x&gt;**<a href=\"mailto:a@b.co\">a@b.co</a></p>\n"
    ),
    ("🙂http://.www.¡www", "<p>🙂http://.www.¡www</p>\n"),
    (
      "<\\*<https@b.c &\n\n",
      "<p>&lt;*&lt;<a href=\"mailto:https@b.c\">https@b.c</a> &amp;</p>\n"
    ),
    ("日本\\@—http:// %20|", "<p>日本@—http:// %20|</p>\n"),
    (
      "Https¡&lt;!a@b.co",
      "<p>Https¡&lt;!<a href=\"mailto:a@b.co\">a@b.co</a></p>\n"
    ),
    ("\n\n&\\*[xmpp:\\*@b.c", "<p>&amp;*[xmpp:*@b.c</p>\n"),
    ("//ftp://.io&nbsp;", "<p>//ftp://.io </p>\n"),
    (
      "www.&quot;¡xmpp:;\\",
      "<p><a href=\"http://www.&amp;quot;%C2%A1xmpp:;%5C\">www.&amp;quot;¡xmpp:;\\</a></p>\n"
    ),
  ];
  for (final (markdown, html) in generated) {
    test('generated: ${markdown.replaceAll('\n', r'\n')}', () {
      expect(_render(markdown), html);
    });
  }
}
