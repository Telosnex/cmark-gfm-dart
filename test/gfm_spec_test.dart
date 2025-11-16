import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import 'commonmark_spec_test.dart';

CmarkParser _createGfmParser() => CmarkParser(
      options: const CmarkParserOptions(enableAutolinkExtension: true),
    );

void _expectHtml(String actual, String expected) {
  if (expected.trim() == '<IGNORE>') {
    return;
  }
  expect(actual.trim(), expected.trim());
}

// Generated from cmark-gfm/test/extensions.txt
// DO NOT EDIT - regenerate with tool/generate_spec_tests.dart

void main() {
  group('GFM Extensions Spec Tests', () {
    test('Tables - Example 1', () {
      final markdown = '''| abc | def |
| --- | --- |
| ghi | jkl |
| mno | pqr |''';
      final expected = '''<table>
<thead>
<tr>
<th>abc</th>
<th>def</th>
</tr>
</thead>
<tbody>
<tr>
<td>ghi</td>
<td>jkl</td>
</tr>
<tr>
<td>mno</td>
<td>pqr</td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Tables - Example 2', skip: kSkipKnownFailure, () {
      final markdown = '''Hello!

| _abc_ | セン |
| ----- | ---- |
| 1. Block elements inside cells don\'t work. | |
| But _**inline elements do**_. | x |

Hi!''';
      final expected = '''<p>Hello!</p>
<table>
<thead>
<tr>
<th><em>abc</em></th>
<th>セン</th>
</tr>
</thead>
<tbody>
<tr>
<td>1. Block elements inside cells don\'t work.</td>
<td></td>
</tr>
<tr>
<td>But <em><strong>inline elements do</strong></em>.</td>
<td>x</td>
</tr>
</tbody>
</table>
<p>Hi!</p>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Tables - Example 3', skip: kSkipKnownFailure, () {
      final markdown = '''| Not enough table | to be considered table |

| Not enough table | to be considered table |
| Not enough table | to be considered table |

| Just enough table | to be considered table |
| ----------------- | ---------------------- |

| ---- | --- |

|x|
|-|

| xyz |
| --- |''';
      final expected = '''<p>| Not enough table | to be considered table |</p>
<p>| Not enough table | to be considered table |
| Not enough table | to be considered table |</p>
<table>
<thead>
<tr>
<th>Just enough table</th>
<th>to be considered table</th>
</tr>
</thead>
</table>
<p>| ---- | --- |</p>
<table>
<thead>
<tr>
<th>x</th>
</tr>
</thead>
</table>
<table>
<thead>
<tr>
<th>xyz</th>
</tr>
</thead>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Tables - Example 4', () {
      final markdown = '''abc | def
--- | ---
xyz | ghi''';
      final expected = '''<table>
<thead>
<tr>
<th>abc</th>
<th>def</th>
</tr>
</thead>
<tbody>
<tr>
<td>xyz</td>
<td>ghi</td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Tables - Example 5', () {
      final markdown = '''Hello!

| _abc_ | セン |
| ----- | ---- |
| this row has a space at the end | | 
| But _**inline elements do**_. | x |

Hi!''';
      final expected = '''<p>Hello!</p>
<table>
<thead>
<tr>
<th><em>abc</em></th>
<th>セン</th>
</tr>
</thead>
<tbody>
<tr>
<td>this row has a space at the end</td>
<td></td>
</tr>
<tr>
<td>But <em><strong>inline elements do</strong></em>.</td>
<td>x</td>
</tr>
</tbody>
</table>
<p>Hi!</p>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Tables - Example 6', () {
      final markdown = '''aaa | bbb | ccc | ddd | eee
:-- | --- | :-: | --- | --:
fff | ggg | hhh | iii | jjj''';
      final expected = '''<table>
<thead>
<tr>
<th align="left">aaa</th>
<th>bbb</th>
<th align="center">ccc</th>
<th>ddd</th>
<th align="right">eee</th>
</tr>
</thead>
<tbody>
<tr>
<td align="left">fff</td>
<td>ggg</td>
<td align="center">hhh</td>
<td>iii</td>
<td align="right">jjj</td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Table cell count mismatches - Example 7', skip: kSkipKnownFailure,
        () {
      final markdown = '''| a | b | c |
| --- | --- |
| this | isn\'t | okay |''';
      final expected = '''<p>| a | b | c |
| --- | --- |
| this | isn\'t | okay |</p>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Table cell count mismatches - Example 8', () {
      final markdown = '''| a | b | c |
| --- | --- | ---
| x
| a | b
| 1 | 2 | 3 | 4 | 5 |''';
      final expected = '''<table>
<thead>
<tr>
<th>a</th>
<th>b</th>
<th>c</th>
</tr>
</thead>
<tbody>
<tr>
<td>x</td>
<td></td>
<td></td>
</tr>
<tr>
<td>a</td>
<td>b</td>
<td></td>
</tr>
<tr>
<td>1</td>
<td>2</td>
<td>3</td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Embedded pipes - Example 9', skip: kSkipKnownFailure, () {
      final markdown = '''| a | b |
| --- | --- |
| Escaped pipes are \\|okay\\|. | Like \\| this. |
| Within `\\|code\\| is okay` too. |
| _**`c\\|`**_ \\| complex
| don\'t **\\_reparse\\_**''';
      final expected = '''<table>
<thead>
<tr>
<th>a</th>
<th>b</th>
</tr>
</thead>
<tbody>
<tr>
<td>Escaped pipes are |okay|.</td>
<td>Like | this.</td>
</tr>
<tr>
<td>Within <code>|code| is okay</code> too.</td>
<td></td>
</tr>
<tr>
<td><em><strong><code>c|</code></strong></em> | complex</td>
<td></td>
</tr>
<tr>
<td>don\'t <strong>_reparse_</strong></td>
<td></td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Oddly-formatted markers - Example 10', skip: kSkipKnownFailure, () {
      final markdown = '''| a |
--- |''';
      final expected = '''<table>
<thead>
<tr>
<th>a</th>
</tr>
</thead>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Escaping - Example 11', () {
      final markdown = '''| a | b |
| --- | --- |
| \\\\ | `\\\\` |
| \\\\\\\\ | `\\\\\\\\` |
| \\_ | `\\_` |
| \\| | `\\|` |
| \\a | `\\a` |

\\\\ `\\\\`

\\\\\\\\ `\\\\\\\\`

\\_ `\\_`

\\| `\\|`

\\a `\\a`''';
      final expected = '''<table>
<thead>
<tr>
<th>a</th>
<th>b</th>
</tr>
</thead>
<tbody>
<tr>
<td>\\</td>
<td><code>\\\\</code></td>
</tr>
<tr>
<td>\\\\</td>
<td><code>\\\\\\\\</code></td>
</tr>
<tr>
<td>_</td>
<td><code>\\_</code></td>
</tr>
<tr>
<td>|</td>
<td><code>|</code></td>
</tr>
<tr>
<td>\\a</td>
<td><code>\\a</code></td>
</tr>
</tbody>
</table>
<p>\\ <code>\\\\</code></p>
<p>\\\\ <code>\\\\\\\\</code></p>
<p>_ <code>\\_</code></p>
<p>| <code>\\|</code></p>
<p>\\a <code>\\a</code></p>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Embedded HTML - Example 12', skip: kSkipKnownFailure, () {
      final markdown = '''| a |
| --- |
| <strong>hello</strong> |
| ok <br> sure |''';
      final expected = '''<table>
<thead>
<tr>
<th>a</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>hello</strong></td>
</tr>
<tr>
<td>ok <br> sure</td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Reference-style links - Example 13', skip: kSkipKnownFailure, () {
      final markdown = '''Here\'s a link to [Freedom Planet 2][].

| Here\'s a link to [Freedom Planet 2][] in a table header. |
| --- |
| Here\'s a link to [Freedom Planet 2][] in a table row. |

[Freedom Planet 2]: http://www.freedomplanet2.com/''';
      final expected =
          '''<p>Here\'s a link to <a href="http://www.freedomplanet2.com/">Freedom Planet 2</a>.</p>
<table>
<thead>
<tr>
<th>Here\'s a link to <a href="http://www.freedomplanet2.com/">Freedom Planet 2</a> in a table header.</th>
</tr>
</thead>
<tbody>
<tr>
<td>Here\'s a link to <a href="http://www.freedomplanet2.com/">Freedom Planet 2</a> in a table row.</td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Sequential cells - Example 14', () {
      final markdown = '''| a | b | c |
| --- | --- | --- |
| d || e |''';
      final expected = '''<table>
<thead>
<tr>
<th>a</th>
<th>b</th>
<th>c</th>
</tr>
</thead>
<tbody>
<tr>
<td>d</td>
<td></td>
<td>e</td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Interaction with emphasis - Example 15', () {
      final markdown = '''| a | b |
| --- | --- |
|***(a)***|''';
      final expected = '''<table>
<thead>
<tr>
<th>a</th>
<th>b</th>
</tr>
</thead>
<tbody>
<tr>
<td><em><strong>(a)</strong></em></td>
<td></td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test(
        'a table can be recognised when separated from a paragraph of text without an empty line - Example 16',
        skip: kSkipKnownFailure, () {
      final markdown = '''123
456
| a | b |
| ---| --- |
d | e''';
      final expected = '''<p>123
456</p>
<table>
<thead>
<tr>
<th>a</th>
<th>b</th>
</tr>
</thead>
<tbody>
<tr>
<td>d</td>
<td>e</td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Strikethroughs - Example 17', () {
      final markdown = '''A proper ~strikethrough~.''';
      final expected = '''<p>A proper <del>strikethrough</del>.</p>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Strikethroughs - Example 18', skip: kSkipKnownFailure, () {
      final markdown = '''These are ~not strikethroughs.

No, they are not~

This ~is ~ legit~ isn\'t ~ legit.

This is not ~~~~~one~~~~~ huge strikethrough.

~one~ ~~two~~ ~~~three~~~

No ~mismatch~~''';
      final expected = '''<p>These are ~not strikethroughs.</p>
<p>No, they are not~</p>
<p>This <del>is ~ legit</del> isn\'t ~ legit.</p>
<p>This is not ~~~~~one~~~~~ huge strikethrough.</p>
<p><del>one</del> <del>two</del> ~~~three~~~</p>
<p>No ~mismatch~~</p>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Autolinks - Example 19', skip: kSkipKnownFailure, () {
      final markdown = ''': http://google.com https://google.com

<http://google.com/å> http://google.com/å

scyther@pokemon.com

scy.the_rbe-edr+ill@pokemon.com

scyther@pokemon.com.

scyther@pokemon.com/

scyther@pokemon.com/beedrill@pokemon.com

mailto:scyther@pokemon.com

This is a mailto:scyther@pokemon.com

mailto:scyther@pokemon.com.

mmmmailto:scyther@pokemon.com

mailto:scyther@pokemon.com/

mailto:scyther@pokemon.com/message

mailto:scyther@pokemon.com/mailto:beedrill@pokemon.com

xmpp:scyther@pokemon.com

xmpp:scyther@pokemon.com.

xmpp:scyther@pokemon.com/message

xmpp:scyther@pokemon.com/message.

Email me at:scyther@pokemon.com

www.github.com www.github.com/á

www.google.com/a_b

Underscores not allowed in host name www.xxx.yyy._zzz

Underscores not allowed in host name www.xxx._yyy.zzz

Underscores allowed in domain name www._xxx.yyy.zzz

**Autolink and http://inlines**

![http://inline.com/image](http://inline.com/image)

a.w@b.c

Full stop outside parens shouldn\'t be included http://google.com/ok.

(Full stop inside parens shouldn\'t be included http://google.com/ok.)

"http://google.com"

\'http://google.com\'

http://🍄.ga/ http://x🍄.ga/''';
      final expected =
          '''<p>: <a href="http://google.com">http://google.com</a> <a href="https://google.com">https://google.com</a></p>
<p><a href="http://google.com/%C3%A5">http://google.com/å</a> <a href="http://google.com/%C3%A5">http://google.com/å</a></p>
<p><a href="mailto:scyther@pokemon.com">scyther@pokemon.com</a></p>
<p><a href="mailto:scy.the_rbe-edr+ill@pokemon.com">scy.the_rbe-edr+ill@pokemon.com</a></p>
<p><a href="mailto:scyther@pokemon.com">scyther@pokemon.com</a>.</p>
<p><a href="mailto:scyther@pokemon.com">scyther@pokemon.com</a>/</p>
<p><a href="mailto:scyther@pokemon.com">scyther@pokemon.com</a>/<a href="mailto:beedrill@pokemon.com">beedrill@pokemon.com</a></p>
<p><a href="mailto:scyther@pokemon.com">mailto:scyther@pokemon.com</a></p>
<p>This is a <a href="mailto:scyther@pokemon.com">mailto:scyther@pokemon.com</a></p>
<p><a href="mailto:scyther@pokemon.com">mailto:scyther@pokemon.com</a>.</p>
<p>mmmmailto:<a href="mailto:scyther@pokemon.com">scyther@pokemon.com</a></p>
<p><a href="mailto:scyther@pokemon.com">mailto:scyther@pokemon.com</a>/</p>
<p><a href="mailto:scyther@pokemon.com">mailto:scyther@pokemon.com</a>/message</p>
<p><a href="mailto:scyther@pokemon.com">mailto:scyther@pokemon.com</a>/<a href="mailto:beedrill@pokemon.com">mailto:beedrill@pokemon.com</a></p>
<p><a href="xmpp:scyther@pokemon.com">xmpp:scyther@pokemon.com</a></p>
<p><a href="xmpp:scyther@pokemon.com">xmpp:scyther@pokemon.com</a>.</p>
<p><a href="xmpp:scyther@pokemon.com/message">xmpp:scyther@pokemon.com/message</a></p>
<p><a href="xmpp:scyther@pokemon.com/message">xmpp:scyther@pokemon.com/message</a>.</p>
<p>Email me at:<a href="mailto:scyther@pokemon.com">scyther@pokemon.com</a></p>
<p><a href="http://www.github.com">www.github.com</a> <a href="http://www.github.com/%C3%A1">www.github.com/á</a></p>
<p><a href="http://www.google.com/a_b">www.google.com/a_b</a></p>
<p>Underscores not allowed in host name www.xxx.yyy._zzz</p>
<p>Underscores not allowed in host name www.xxx._yyy.zzz</p>
<p>Underscores allowed in domain name <a href="http://www._xxx.yyy.zzz">www._xxx.yyy.zzz</a></p>
<p><strong>Autolink and <a href="http://inlines">http://inlines</a></strong></p>
<p><img src="http://inline.com/image" alt="http://inline.com/image" /></p>
<p><a href="mailto:a.w@b.c">a.w@b.c</a></p>
<p>Full stop outside parens shouldn\'t be included <a href="http://google.com/ok">http://google.com/ok</a>.</p>
<p>(Full stop inside parens shouldn\'t be included <a href="http://google.com/ok">http://google.com/ok</a>.)</p>
<p>&quot;<a href="http://google.com">http://google.com</a>&quot;</p>
<p>\'<a href="http://google.com">http://google.com</a>\'</p>
<p><a href="http://%F0%9F%8D%84.ga/">http://🍄.ga/</a> <a href="http://x%F0%9F%8D%84.ga/">http://x🍄.ga/</a></p>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Autolinks - Example 20', skip: kSkipKnownFailure, () {
      final markdown = '''This shouldn\'t crash everything: (_A_@_.A''';
      final expected = '''<IGNORE>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Autolinks - Example 21', () {
      final markdown = '''These should not link:

* @a.b.c@. x
* n@.  b''';
      final expected = '''<p>These should not link:</p>
<ul>
<li>@a.b.c@. x</li>
<li>n@.  b</li>
</ul>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('HTML tag filter - Example 22', skip: kSkipNongoal_HtmlGeneral, () {
      final markdown =
          '''This is <xmp> not okay, but **this** <strong>is</strong>.

<p>This is <xmp> not okay, but **this** <strong>is</strong>.</p>

Nope, I won\'t have <textarea>.

<p>No <textarea> here either.</p>

<p>This <random /> <thing> is okay</thing> though.</p>

Yep, <totally>okay</totally>.

<!-- HTML comments are okay, though. -->
<!- But we\'re strict. ->
<! No nonsense. >
<!-- Leave multiline comments the heck alone, though, okay?
Even with {"x":"y"} or 1 > 2 or whatever. Even **markdown**.
-->
<!--- Support everything CommonMark\'s parser does. -->
<!---->
<!--thistoo-->''';
      final expected =
          '''<p>This is &lt;xmp> not okay, but <strong>this</strong> <strong>is</strong>.</p>
<p>This is &lt;xmp> not okay, but **this** <strong>is</strong>.</p>
<p>Nope, I won\'t have &lt;textarea>.</p>
<p>No &lt;textarea> here either.</p>
<p>This <random /> <thing> is okay</thing> though.</p>
<p>Yep, <totally>okay</totally>.</p>
<!-- HTML comments are okay, though. -->
<p>&lt;!- But we\'re strict. -&gt;
&lt;! No nonsense. &gt;</p>
<!-- Leave multiline comments the heck alone, though, okay?
Even with {"x":"y"} or 1 > 2 or whatever. Even **markdown**.
-->
<!--- Support everything CommonMark\'s parser does. -->
<!---->
<!--thistoo-->''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Footnotes - Example 23', skip: kSkipKnownFailure, () {
      final markdown = '''This is some text![^1]. Other text.[^footnote].

Here\'s a thing[^other-note].

And another thing[^codeblock-note].

This doesn\'t have a referent[^nope].


[^other-note]:       no code block here (spaces are stripped away)

[^codeblock-note]:
        this is now a code block (8 spaces indentation)

[^1]: Some *bolded* footnote definition.

Hi!

[^footnote]:
    > Blockquotes can be in a footnote.

        as well as code blocks

    or, naturally, simple paragraphs.

[^unused]: This is unused.''';
      final expected =
          '''<p>This is some text!<sup class="footnote-ref"><a href="#fn-1" id="fnref-1" data-footnote-ref>1</a></sup>. Other text.<sup class="footnote-ref"><a href="#fn-footnote" id="fnref-footnote" data-footnote-ref>2</a></sup>.</p>
<p>Here\'s a thing<sup class="footnote-ref"><a href="#fn-other-note" id="fnref-other-note" data-footnote-ref>3</a></sup>.</p>
<p>And another thing<sup class="footnote-ref"><a href="#fn-codeblock-note" id="fnref-codeblock-note" data-footnote-ref>4</a></sup>.</p>
<p>This doesn\'t have a referent[^nope].</p>
<p>Hi!</p>
<section class="footnotes" data-footnotes>
<ol>
<li id="fn-1">
<p>Some <em>bolded</em> footnote definition. <a href="#fnref-1" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="1" aria-label="Back to reference 1">↩</a></p>
</li>
<li id="fn-footnote">
<blockquote>
<p>Blockquotes can be in a footnote.</p>
</blockquote>
<pre><code>as well as code blocks
</code></pre>
<p>or, naturally, simple paragraphs. <a href="#fnref-footnote" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="2" aria-label="Back to reference 2">↩</a></p>
</li>
<li id="fn-other-note">
<p>no code block here (spaces are stripped away) <a href="#fnref-other-note" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="3" aria-label="Back to reference 3">↩</a></p>
</li>
<li id="fn-codeblock-note">
<pre><code>this is now a code block (8 spaces indentation)
</code></pre>
<a href="#fnref-codeblock-note" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="4" aria-label="Back to reference 4">↩</a>
</li>
</ol>
</section>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test(
        'When a footnote is used multiple times, we insert multiple backrefs. - Example 24',
        skip: kSkipKnownFailure, () {
      final markdown = '''This is some text. It has a footnote[^a-footnote].

This footnote is referenced[^a-footnote] multiple times, in lots of different places.[^a-footnote]

[^a-footnote]: This footnote definition should have three backrefs.''';
      final expected =
          '''<p>This is some text. It has a footnote<sup class="footnote-ref"><a href="#fn-a-footnote" id="fnref-a-footnote" data-footnote-ref>1</a></sup>.</p>
<p>This footnote is referenced<sup class="footnote-ref"><a href="#fn-a-footnote" id="fnref-a-footnote-2" data-footnote-ref>1</a></sup> multiple times, in lots of different places.<sup class="footnote-ref"><a href="#fn-a-footnote" id="fnref-a-footnote-3" data-footnote-ref>1</a></sup></p>
<section class="footnotes" data-footnotes>
<ol>
<li id="fn-a-footnote">
<p>This footnote definition should have three backrefs. <a href="#fnref-a-footnote" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="1" aria-label="Back to reference 1">↩</a> <a href="#fnref-a-footnote-2" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="1-2" aria-label="Back to reference 1-2">↩<sup class="footnote-ref">2</sup></a> <a href="#fnref-a-footnote-3" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="1-3" aria-label="Back to reference 1-3">↩<sup class="footnote-ref">3</sup></a></p>
</li>
</ol>
</section>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Footnote reference labels are href escaped - Example 25',
        skip: kSkipKnownFailure, () {
      final markdown = '''Hello[^"><script>alert(1)</script>]

[^"><script>alert(1)</script>]: pwned''';
      final expected =
          '''<p>Hello<sup class="footnote-ref"><a href="#fn-%22%3E%3Cscript%3Ealert(1)%3C/script%3E" id="fnref-%22%3E%3Cscript%3Ealert(1)%3C/script%3E" data-footnote-ref>1</a></sup></p>
<section class="footnotes" data-footnotes>
<ol>
<li id="fn-%22%3E%3Cscript%3Ealert(1)%3C/script%3E">
<p>pwned <a href="#fnref-%22%3E%3Cscript%3Ealert(1)%3C/script%3E" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="1" aria-label="Back to reference 1">↩</a></p>
</li>
</ol>
</section>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Interop - Example 26', skip: kSkipKnownFailure, () {
      final markdown = '''~~www.google.com~~

~~http://google.com~~''';
      final expected =
          '''<p><del><a href="http://www.google.com">www.google.com</a></del></p>
<p><del><a href="http://google.com">http://google.com</a></del></p>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Interop - Example 27', skip: kSkipKnownFailure, () {
      final markdown = '''| a | b |
| --- | --- |
| https://github.com www.github.com | http://pokemon.com |''';
      final expected = '''<table>
<thead>
<tr>
<th>a</th>
<th>b</th>
</tr>
</thead>
<tbody>
<tr>
<td><a href="https://github.com">https://github.com</a> <a href="http://www.github.com">www.github.com</a></td>
<td><a href="http://pokemon.com">http://pokemon.com</a></td>
</tr>
</tbody>
</table>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Task lists - Example 28', () {
      final markdown = '''- [ ] foo
- [x] bar''';
      final expected = '''<ul>
<li><input type="checkbox" disabled="" /> foo</li>
<li><input type="checkbox" checked="" disabled="" /> bar</li>
</ul>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Task lists - Example 29', () {
      final markdown = '''- [x] foo
  - [ ] bar
  - [x] baz
- [ ] bim

Show a regular (non task) list to show that it has the same structure
- [@] foo
  - [@] bar
  - [@] baz
- [@] bim''';
      final expected = '''<ul>
<li><input type="checkbox" checked="" disabled="" /> foo
<ul>
<li><input type="checkbox" disabled="" /> bar</li>
<li><input type="checkbox" checked="" disabled="" /> baz</li>
</ul>
</li>
<li><input type="checkbox" disabled="" /> bim</li>
</ul>
<p>Show a regular (non task) list to show that it has the same structure</p>
<ul>
<li>[@] foo
<ul>
<li>[@] bar</li>
<li>[@] baz</li>
</ul>
</li>
<li>[@] bim</li>
</ul>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });

    test('Task lists - Example 30', () {
      final markdown = '''- [x] foo
    - [ ] bar
    - [x] baz
- [ ] bim

Show a regular (non task) list to show that it has the same structure
- [@] foo
    - [@] bar
    - [@] baz
- [@] bim''';
      final expected = '''<ul>
<li><input type="checkbox" checked="" disabled="" /> foo
<ul>
<li><input type="checkbox" disabled="" /> bar</li>
<li><input type="checkbox" checked="" disabled="" /> baz</li>
</ul>
</li>
<li><input type="checkbox" disabled="" /> bim</li>
</ul>
<p>Show a regular (non task) list to show that it has the same structure</p>
<ul>
<li>[@] foo
<ul>
<li>[@] bar</li>
<li>[@] baz</li>
</ul>
</li>
<li>[@] bim</li>
</ul>''';

      final parser = _createGfmParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      _expectHtml(html, expected);
    });
  });
}
