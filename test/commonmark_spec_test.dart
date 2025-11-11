import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

// Generated from cmark-gfm/test/spec.txt
// DO NOT EDIT - regenerate with tool/generate_spec_tests.dart

const kSkipNongoal_MdToHtml =
    'Skipping because the test verifies HTML is left undisturbed while Markdown becomes HTML. It is a non-goal for us to pass these tests: instead, the markdown is preserved.';
const kSkipNongoal_MdNotToHtml =
    'Skipping because the test verifies text that is *almost* correct HTML is left undisturbed and Markdown does not become HTML. It is a non-goal for us to pass these tests: instead, HTML isn\'t recognized, we leave the markdown as-is.';
const kSkipNongoal_HtmlGeneral =
    'Skipping because the test verifies general HTML behavior which is a non-goal for us to pass these tests.';
const kSkipKnownFailure =
    'Skipping because known failure; avoid noise when checking for regressions, thus enabling checking for regressions.';
void main() {
  group('CommonMark Spec Tests', () {
    test('Tabs - Example 1', () {
      final markdown = '''	foo	baz		bim''';
      final expected = '''<pre><code>foo	baz		bim
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Tabs - Example 2', () {
      final markdown = '''  	foo	baz		bim''';
      final expected = '''<pre><code>foo	baz		bim
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Tabs - Example 3', () {
      final markdown = '''    a	a
    ὐ	a''';
      final expected = '''<pre><code>a	a
ὐ	a
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Tabs - Example 4', () {
      final markdown = '''  - foo

	bar''';
      final expected = '''<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Tabs - Example 5', () {
      final markdown = '''- foo

		bar''';
      final expected = '''<ul>
<li>
<p>foo</p>
<pre><code>  bar
</code></pre>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Tabs - Example 6', () {
      final markdown = '''>		foo''';
      final expected = '''<blockquote>
<pre><code>  foo
</code></pre>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Tabs - Example 7', () {
      final markdown = '''-		foo''';
      final expected = '''<ul>
<li>
<pre><code>  foo
</code></pre>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Tabs - Example 8', () {
      final markdown = '''    foo
	bar''';
      final expected = '''<pre><code>foo
bar
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Tabs - Example 9', () {
      final markdown = ''' - foo
   - bar
	 - baz''';
      final expected = '''<ul>
<li>foo
<ul>
<li>bar
<ul>
<li>baz</li>
</ul>
</li>
</ul>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Tabs - Example 10', () {
      final markdown = '''#	Foo''';
      final expected = '''<h1>Foo</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Tabs - Example 11', () {
      final markdown = '''*	*	*	''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Precedence - Example 12', () {
      final markdown = '''- `one
- two`''';
      final expected = '''<ul>
<li>`one</li>
<li>two`</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 13', () {
      final markdown = '''***
---
___''';
      final expected = '''<hr />
<hr />
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 14', () {
      final markdown = '''+++''';
      final expected = '''<p>+++</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 15', () {
      final markdown = '''===''';
      final expected = '''<p>===</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 16', () {
      final markdown = '''--
**
__''';
      final expected = '''<p>--
**
__</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 17', () {
      final markdown = ''' ***
  ***
   ***''';
      final expected = '''<hr />
<hr />
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 18', () {
      final markdown = '''    ***''';
      final expected = '''<pre><code>***
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 19', () {
      final markdown = '''Foo
    ***''';
      final expected = '''<p>Foo
***</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 20', () {
      final markdown = '''_____________________________________''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 21', () {
      final markdown = ''' - - -''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 22', () {
      final markdown = ''' **  * ** * ** * **''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 23', () {
      final markdown = '''-     -      -      -''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 24', () {
      final markdown = '''- - - -    ''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 25', () {
      final markdown = '''_ _ _ _ a

a------

---a---''';
      final expected = '''<p>_ _ _ _ a</p>
<p>a------</p>
<p>---a---</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 26', () {
      final markdown = ''' *-*''';
      final expected = '''<p><em>-</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 27', () {
      final markdown = '''- foo
***
- bar''';
      final expected = '''<ul>
<li>foo</li>
</ul>
<hr />
<ul>
<li>bar</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 28', () {
      final markdown = '''Foo
***
bar''';
      final expected = '''<p>Foo</p>
<hr />
<p>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 29', () {
      final markdown = '''Foo
---
bar''';
      final expected = '''<h2>Foo</h2>
<p>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 30', () {
      final markdown = '''* Foo
* * *
* Bar''';
      final expected = '''<ul>
<li>Foo</li>
</ul>
<hr />
<ul>
<li>Bar</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 31', () {
      final markdown = '''- Foo
- * * *''';
      final expected = '''<ul>
<li>Foo</li>
<li>
<hr />
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 32', () {
      final markdown = '''# foo
## foo
### foo
#### foo
##### foo
###### foo''';
      final expected = '''<h1>foo</h1>
<h2>foo</h2>
<h3>foo</h3>
<h4>foo</h4>
<h5>foo</h5>
<h6>foo</h6>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 33', () {
      final markdown = '''####### foo''';
      final expected = '''<p>####### foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 34', () {
      final markdown = '''#5 bolt

#hashtag''';
      final expected = '''<p>#5 bolt</p>
<p>#hashtag</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 35', () {
      final markdown = '''\\## foo''';
      final expected = '''<p>## foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 36', () {
      final markdown = '''# foo *bar* \\*baz\\*''';
      final expected = '''<h1>foo <em>bar</em> *baz*</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 37', () {
      final markdown = '''#                  foo                     ''';
      final expected = '''<h1>foo</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 38', () {
      final markdown = ''' ### foo
  ## foo
   # foo''';
      final expected = '''<h3>foo</h3>
<h2>foo</h2>
<h1>foo</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 39', () {
      final markdown = '''    # foo''';
      final expected = '''<pre><code># foo
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 40', () {
      final markdown = '''foo
    # bar''';
      final expected = '''<p>foo
# bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 41', () {
      final markdown = '''## foo ##
  ###   bar    ###''';
      final expected = '''<h2>foo</h2>
<h3>bar</h3>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 42', () {
      final markdown = '''# foo ##################################
##### foo ##''';
      final expected = '''<h1>foo</h1>
<h5>foo</h5>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 43', () {
      final markdown = '''### foo ###     ''';
      final expected = '''<h3>foo</h3>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 44', () {
      final markdown = '''### foo ### b''';
      final expected = '''<h3>foo ### b</h3>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 45', () {
      final markdown = '''# foo#''';
      final expected = '''<h1>foo#</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 46', () {
      final markdown = '''### foo \\###
## foo #\\##
# foo \\#''';
      final expected = '''<h3>foo ###</h3>
<h2>foo ###</h2>
<h1>foo #</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 47', () {
      final markdown = '''****
## foo
****''';
      final expected = '''<hr />
<h2>foo</h2>
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 48', () {
      final markdown = '''Foo bar
# baz
Bar foo''';
      final expected = '''<p>Foo bar</p>
<h1>baz</h1>
<p>Bar foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 49', () {
      final markdown = '''## 
#
### ###''';
      final expected = '''<h2></h2>
<h1></h1>
<h3></h3>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 50', () {
      final markdown = '''Foo *bar*
=========

Foo *bar*
---------''';
      final expected = '''<h1>Foo <em>bar</em></h1>
<h2>Foo <em>bar</em></h2>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 51', () {
      final markdown = '''Foo *bar
baz*
====''';
      final expected = '''<h1>Foo <em>bar
baz</em></h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 52', () {
      final markdown = '''  Foo *bar
baz*	
====''';
      final expected = '''<h1>Foo <em>bar
baz</em></h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 53', () {
      final markdown = '''Foo
-------------------------

Foo
=''';
      final expected = '''<h2>Foo</h2>
<h1>Foo</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 54', () {
      final markdown = '''   Foo
---

  Foo
-----

  Foo
  ===''';
      final expected = '''<h2>Foo</h2>
<h2>Foo</h2>
<h1>Foo</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 55', () {
      final markdown = '''    Foo
    ---

    Foo
---''';
      final expected = '''<pre><code>Foo
---

Foo
</code></pre>
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 56', () {
      final markdown = '''Foo
   ----      ''';
      final expected = '''<h2>Foo</h2>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 57', () {
      final markdown = '''Foo
    ---''';
      final expected = '''<p>Foo
---</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 58', () {
      final markdown = '''Foo
= =

Foo
--- -''';
      final expected = '''<p>Foo
= =</p>
<p>Foo</p>
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 59', () {
      final markdown = '''Foo  
-----''';
      final expected = '''<h2>Foo</h2>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 60', () {
      final markdown = '''Foo\\
----''';
      final expected = '''<h2>Foo\\</h2>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 61', () {
      final markdown = '''`Foo
----
`

<a title="a lot
---
of dashes"/>''';
      final expected = '''<h2>`Foo</h2>
<p>`</p>
<h2>&lt;a title=&quot;a lot</h2>
<p>of dashes&quot;/&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 62', () {
      final markdown = '''> Foo
---''';
      final expected = '''<blockquote>
<p>Foo</p>
</blockquote>
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 63', () {
      final markdown = '''> foo
bar
===''';
      final expected = '''<blockquote>
<p>foo
bar
===</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 64', () {
      final markdown = '''- Foo
---''';
      final expected = '''<ul>
<li>Foo</li>
</ul>
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 65', () {
      final markdown = '''Foo
Bar
---''';
      final expected = '''<h2>Foo
Bar</h2>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 66', () {
      final markdown = '''---
Foo
---
Bar
---
Baz''';
      final expected = '''<hr />
<h2>Foo</h2>
<h2>Bar</h2>
<p>Baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 67', () {
      final markdown = '''
====''';
      final expected = '''<p>====</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 68', () {
      final markdown = '''---
---''';
      final expected = '''<hr />
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 69', () {
      final markdown = '''- foo
-----''';
      final expected = '''<ul>
<li>foo</li>
</ul>
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 70', () {
      final markdown = '''    foo
---''';
      final expected = '''<pre><code>foo
</code></pre>
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 71', () {
      final markdown = '''> foo
-----''';
      final expected = '''<blockquote>
<p>foo</p>
</blockquote>
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 72', () {
      final markdown = '''\\> foo
------''';
      final expected = '''<h2>&gt; foo</h2>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 73', () {
      final markdown = '''Foo

bar
---
baz''';
      final expected = '''<p>Foo</p>
<h2>bar</h2>
<p>baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 74', () {
      final markdown = '''Foo
bar

---

baz''';
      final expected = '''<p>Foo
bar</p>
<hr />
<p>baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 75', () {
      final markdown = '''Foo
bar
* * *
baz''';
      final expected = '''<p>Foo
bar</p>
<hr />
<p>baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 76', () {
      final markdown = '''Foo
bar
\\---
baz''';
      final expected = '''<p>Foo
bar
---
baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 77', () {
      final markdown = '''    a simple
      indented code block''';
      final expected = '''<pre><code>a simple
  indented code block
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 78', () {
      final markdown = '''  - foo

    bar''';
      final expected = '''<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 79', () {
      final markdown = '''1.  foo

    - bar''';
      final expected = '''<ol>
<li>
<p>foo</p>
<ul>
<li>bar</li>
</ul>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 80', () {
      final markdown = '''    <a/>
    *hi*

    - one''';
      final expected = '''<pre><code>&lt;a/&gt;
*hi*

- one
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 81', () {
      final markdown = '''    chunk1

    chunk2
  
 
 
    chunk3''';
      final expected = '''<pre><code>chunk1

chunk2



chunk3
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 82', () {
      final markdown = '''    chunk1
      
      chunk2''';
      final expected = '''<pre><code>chunk1
  
  chunk2
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 83', () {
      final markdown = '''Foo
    bar
''';
      final expected = '''<p>Foo
bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 84', () {
      final markdown = '''    foo
bar''';
      final expected = '''<pre><code>foo
</code></pre>
<p>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 85', () {
      final markdown = '''# Heading
    foo
Heading
------
    foo
----''';
      final expected = '''<h1>Heading</h1>
<pre><code>foo
</code></pre>
<h2>Heading</h2>
<pre><code>foo
</code></pre>
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 86', () {
      final markdown = '''        foo
    bar''';
      final expected = '''<pre><code>    foo
bar
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 87', () {
      final markdown = '''
    
    foo
    
''';
      final expected = '''<pre><code>foo
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Indented code blocks - Example 88', () {
      final markdown = '''    foo  ''';
      final expected = '''<pre><code>foo  
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 89', () {
      final markdown = '''```
<
 >
```''';
      final expected = '''<pre><code>&lt;
 &gt;
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 90', () {
      final markdown = '''~~~
<
 >
~~~''';
      final expected = '''<pre><code>&lt;
 &gt;
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 91', () {
      final markdown = '''``
foo
``''';
      final expected = '''<p><code>foo</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 92', () {
      final markdown = '''```
aaa
~~~
```''';
      final expected = '''<pre><code>aaa
~~~
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 93', () {
      final markdown = '''~~~
aaa
```
~~~''';
      final expected = '''<pre><code>aaa
```
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 94', () {
      final markdown = '''````
aaa
```
``````''';
      final expected = '''<pre><code>aaa
```
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 95', () {
      final markdown = '''~~~~
aaa
~~~
~~~~''';
      final expected = '''<pre><code>aaa
~~~
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 96', () {
      final markdown = '''```''';
      final expected = '''<pre><code></code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 97', () {
      final markdown = '''`````

```
aaa''';
      final expected = '''<pre><code>
```
aaa
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 98', () {
      final markdown = '''> ```
> aaa

bbb''';
      final expected = '''<blockquote>
<pre><code>aaa
</code></pre>
</blockquote>
<p>bbb</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 99', () {
      final markdown = '''```

  
```''';
      final expected = '''<pre><code>
  
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 100', () {
      final markdown = '''```
```''';
      final expected = '''<pre><code></code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 101', () {
      final markdown = ''' ```
 aaa
aaa
```''';
      final expected = '''<pre><code>aaa
aaa
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 102', () {
      final markdown = '''  ```
aaa
  aaa
aaa
  ```''';
      final expected = '''<pre><code>aaa
aaa
aaa
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 103', () {
      final markdown = '''   ```
   aaa
    aaa
  aaa
   ```''';
      final expected = '''<pre><code>aaa
 aaa
aaa
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 104', () {
      final markdown = '''    ```
    aaa
    ```''';
      final expected = '''<pre><code>```
aaa
```
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 105', () {
      final markdown = '''```
aaa
  ```''';
      final expected = '''<pre><code>aaa
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 106', () {
      final markdown = '''   ```
aaa
  ```''';
      final expected = '''<pre><code>aaa
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 107', () {
      final markdown = '''```
aaa
    ```''';
      final expected = '''<pre><code>aaa
    ```
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 108', () {
      final markdown = '''``` ```
aaa''';
      final expected = '''<p><code> </code>
aaa</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 109', () {
      final markdown = '''~~~~~~
aaa
~~~ ~~''';
      final expected = '''<pre><code>aaa
~~~ ~~
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 110', () {
      final markdown = '''foo
```
bar
```
baz''';
      final expected = '''<p>foo</p>
<pre><code>bar
</code></pre>
<p>baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 111', () {
      final markdown = '''foo
---
~~~
bar
~~~
# baz''';
      final expected = '''<h2>foo</h2>
<pre><code>bar
</code></pre>
<h1>baz</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 112', () {
      final markdown = '''```ruby
def foo(x)
  return 3
end
```''';
      final expected = '''<pre><code class="language-ruby">def foo(x)
  return 3
end
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 113', () {
      final markdown = '''~~~~    ruby startline=3 \$%@#\$
def foo(x)
  return 3
end
~~~~~~~''';
      final expected = '''<pre><code class="language-ruby">def foo(x)
  return 3
end
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 114', () {
      final markdown = '''````;
````''';
      final expected = '''<pre><code class="language-;"></code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 115', () {
      final markdown = '''``` aa ```
foo''';
      final expected = '''<p><code>aa</code>
foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 116', () {
      final markdown = '''~~~ aa ``` ~~~
foo
~~~''';
      final expected = '''<pre><code class="language-aa">foo
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 117', () {
      final markdown = '''```
``` aaa
```''';
      final expected = '''<pre><code>``` aaa
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 118', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<table><tr><td>
<pre>
**Hello**,

_world_.
</pre>
</td></tr></table>''';
      final expected = '''<table><tr><td>
<pre>
**Hello**,
<p><em>world</em>.
</pre></p>
</td></tr></table>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 119', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<table>
  <tr>
    <td>
           hi
    </td>
  </tr>
</table>

okay.''';
      final expected = '''<table>
  <tr>
    <td>
           hi
    </td>
  </tr>
</table>
<p>okay.</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 120', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = ''' <div>
  *hello*
         <foo><a>''';
      final expected = ''' <div>
  *hello*
         <foo><a>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 121', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''</div>
*foo*''';
      final expected = '''</div>
*foo*''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 122', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<DIV CLASS="foo">

*Markdown*

</DIV>''';
      final expected = '''<DIV CLASS="foo">
<p><em>Markdown</em></p>
</DIV>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 123', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<div id="foo"
  class="bar">
</div>''';
      final expected = '''<div id="foo"
  class="bar">
</div>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 124', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<div id="foo" class="bar
  baz">
</div>''';
      final expected = '''<div id="foo" class="bar
  baz">
</div>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 125', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<div>
*foo*

*bar*''';
      final expected = '''<div>
*foo*
<p><em>bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 126', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<div id="foo"
*hi*''';
      final expected = '''<div id="foo"
*hi*''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 127', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<div class
foo''';
      final expected = '''<div class
foo''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 128', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<div *???-&&&-<---
*foo*''';
      final expected = '''<div *???-&&&-<---
*foo*''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 129', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<div><a href="bar">*foo*</a></div>''';
      final expected = '''<div><a href="bar">*foo*</a></div>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 130', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<table><tr><td>
foo
</td></tr></table>''';
      final expected = '''<table><tr><td>
foo
</td></tr></table>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 131', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<div></div>
``` c
int x = 33;
```''';
      final expected = '''<div></div>
``` c
int x = 33;
```''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 132', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<a href="foo">
*bar*
</a>''';
      final expected = '''<a href="foo">
*bar*
</a>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 133', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''<Warning>
*bar*
</Warning>''';
      final expected = '''<Warning>
*bar*
</Warning>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 134', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''<i class="foo">
*bar*
</i>''';
      final expected = '''<i class="foo">
*bar*
</i>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 135', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''</ins>
*bar*''';
      final expected = '''</ins>
*bar*''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 136', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''<del>
*foo*
</del>''';
      final expected = '''<del>
*foo*
</del>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 137', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<del>

*foo*

</del>''';
      final expected = '''<del>
<p><em>foo</em></p>
</del>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 138', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<del>*foo*</del>''';
      final expected = '''<p><del><em>foo</em></del></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 139', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<pre language="haskell"><code>
import Text.HTML.TagSoup

main :: IO ()
main = print \$ parseTags tags
</code></pre>
okay''';
      final expected = '''<pre language="haskell"><code>
import Text.HTML.TagSoup

main :: IO ()
main = print \$ parseTags tags
</code></pre>
<p>okay</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 140', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<script type="text/javascript">
// JavaScript example

document.getElementById("demo").innerHTML = "Hello JavaScript!";
</script>
okay''';
      final expected = '''<script type="text/javascript">
// JavaScript example

document.getElementById("demo").innerHTML = "Hello JavaScript!";
</script>
<p>okay</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 141', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<style
  type="text/css">
h1 {color:red;}

p {color:blue;}
</style>
okay''';
      final expected = '''<style
  type="text/css">
h1 {color:red;}

p {color:blue;}
</style>
<p>okay</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 142', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<style
  type="text/css">

foo''';
      final expected = '''<style
  type="text/css">

foo''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 143', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''> <div>
> foo

bar''';
      final expected = '''<blockquote>
<div>
foo
</blockquote>
<p>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 144', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''- <div>
- foo''';
      final expected = '''<ul>
<li>
<div>
</li>
<li>foo</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 145', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<style>p{color:red;}</style>
*foo*''';
      final expected = '''<style>p{color:red;}</style>
<p><em>foo</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 146', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<!-- foo -->*bar*
*baz*''';
      final expected = '''<!-- foo -->*bar*
<p><em>baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 147', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''<script>
foo
</script>1. *bar*''';
      final expected = '''<script>
foo
</script>1. *bar*''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 148', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<!-- Foo

bar
   baz -->
okay''';
      final expected = '''<!-- Foo

bar
   baz -->
<p>okay</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 149', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<?php

  echo \'>\';

?>
okay''';
      final expected = '''<?php

  echo \'>\';

?>
<p>okay</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 150', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''<!DOCTYPE html>''';
      final expected = '''<!DOCTYPE html>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 151', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<![CDATA[
function matchwo(a,b)
{
  if (a < b && a < 0) then {
    return 1;

  } else {

    return 0;
  }
}
]]>
okay''';
      final expected = '''<![CDATA[
function matchwo(a,b)
{
  if (a < b && a < 0) then {
    return 1;

  } else {

    return 0;
  }
}
]]>
<p>okay</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 152', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''  <!-- foo -->

    <!-- foo -->''';
      final expected = '''  <!-- foo -->
<pre><code>&lt;!-- foo --&gt;
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 153', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''  <div>

    <div>''';
      final expected = '''  <div>
<pre><code>&lt;div&gt;
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 154', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''Foo
<div>
bar
</div>''';
      final expected = '''<p>Foo</p>
<div>
bar
</div>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 155', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''<div>
bar
</div>
*foo*''';
      final expected = '''<div>
bar
</div>
*foo*''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 156', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''Foo
<a href="bar">
baz''';
      final expected = '''<p>Foo
<a href="bar">
baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 157', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<div>

*Emphasized* text.

</div>''';
      final expected = '''<div>
<p><em>Emphasized</em> text.</p>
</div>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 158', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''<div>
*Emphasized* text.
</div>''';
      final expected = '''<div>
*Emphasized* text.
</div>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 159', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''<table>

<tr>

<td>
Hi
</td>

</tr>

</table>''';
      final expected = '''<table>
<tr>
<td>
Hi
</td>
</tr>
</table>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 160', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<table>

  <tr>

    <td>
      Hi
    </td>

  </tr>

</table>''';
      final expected = '''<table>
  <tr>
<pre><code>&lt;td&gt;
  Hi
&lt;/td&gt;
</code></pre>
  </tr>
</table>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 161', () {
      final markdown = '''[foo]: /url "title"

[foo]''';
      final expected = '''<p><a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 162', () {
      final markdown = '''   [foo]: 
      /url  
           \'the title\'  

[foo]''';
      final expected = '''<p><a href="/url" title="the title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 163', () {
      final markdown = '''[Foo*bar\\]]:my_(url) \'title (with parens)\'

[Foo*bar\\]]''';
      final expected =
          '''<p><a href="my_(url)" title="title (with parens)">Foo*bar]</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 164', () {
      final markdown = '''[Foo bar]:
<my url>
\'title\'

[Foo bar]''';
      final expected =
          '''<p><a href="my%20url" title="title">Foo bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 165', () {
      final markdown = '''[foo]: /url \'
title
line1
line2
\'

[foo]''';
      final expected = '''<p><a href="/url" title="
title
line1
line2
">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 166', () {
      final markdown = '''[foo]: /url \'title

with blank line\'

[foo]''';
      final expected = '''<p>[foo]: /url \'title</p>
<p>with blank line\'</p>
<p>[foo]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 167', () {
      final markdown = '''[foo]:
/url

[foo]''';
      final expected = '''<p><a href="/url">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 168', () {
      final markdown = '''[foo]:

[foo]''';
      final expected = '''<p>[foo]:</p>
<p>[foo]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 169', () {
      final markdown = '''[foo]: <>

[foo]''';
      final expected = '''<p><a href="">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 170',
        skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''[foo]: <bar>(baz)

[foo]''';
      final expected = '''<p>[foo]: <bar>(baz)</p>
<p>[foo]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 171', () {
      final markdown = '''[foo]: /url\\bar\\*baz "foo\\"bar\\baz"

[foo]''';
      final expected =
          '''<p><a href="/url%5Cbar*baz" title="foo&quot;bar\\baz">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 172', skip: kSkipKnownFailure,
        () {
      final markdown = '''[foo]

[foo]: url''';
      final expected = '''<p><a href="url">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 173', skip: kSkipKnownFailure,
        () {
      final markdown = '''[foo]

[foo]: first
[foo]: second''';
      final expected = '''<p><a href="first">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 174', () {
      final markdown = '''[FOO]: /url

[Foo]''';
      final expected = '''<p><a href="/url">Foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 175', () {
      final markdown = '''[ΑΓΩ]: /φου

[αγω]''';
      final expected = '''<p><a href="/%CF%86%CE%BF%CF%85">αγω</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 176', skip: kSkipKnownFailure,
        () {
      final markdown = '''[foo]: /url''';
      final expected = '''''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 177', () {
      final markdown = '''[
foo
]: /url
bar''';
      final expected = '''<p>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 178', () {
      final markdown = '''[foo]: /url "title" ok''';
      final expected = '''<p>[foo]: /url &quot;title&quot; ok</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 179', () {
      final markdown = '''[foo]: /url
"title" ok''';
      final expected = '''<p>&quot;title&quot; ok</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 180', () {
      final markdown = '''    [foo]: /url "title"

[foo]''';
      final expected = '''<pre><code>[foo]: /url &quot;title&quot;
</code></pre>
<p>[foo]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 181', () {
      final markdown = '''```
[foo]: /url
```

[foo]''';
      final expected = '''<pre><code>[foo]: /url
</code></pre>
<p>[foo]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 182', () {
      final markdown = '''Foo
[bar]: /baz

[bar]''';
      final expected = '''<p>Foo
[bar]: /baz</p>
<p>[bar]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 183', () {
      final markdown = '''# [Foo]
[foo]: /url
> bar''';
      final expected = '''<h1><a href="/url">Foo</a></h1>
<blockquote>
<p>bar</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 184', () {
      final markdown = '''[foo]: /url
bar
===
[foo]''';
      final expected = '''<h1>bar</h1>
<p><a href="/url">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 185', () {
      final markdown = '''[foo]: /url
===
[foo]''';
      final expected = '''<p>===
<a href="/url">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 186', () {
      final markdown = '''[foo]: /foo-url "foo"
[bar]: /bar-url
  "bar"
[baz]: /baz-url

[foo],
[bar],
[baz]''';
      final expected = '''<p><a href="/foo-url" title="foo">foo</a>,
<a href="/bar-url" title="bar">bar</a>,
<a href="/baz-url">baz</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 187', skip: kSkipKnownFailure,
        () {
      final markdown = '''[foo]

> [foo]: /url''';
      final expected = '''<p><a href="/url">foo</a></p>
<blockquote>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 188', skip: kSkipKnownFailure,
        () {
      final markdown = '''[foo]: /url''';
      final expected = '''''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Paragraphs - Example 189', () {
      final markdown = '''aaa

bbb''';
      final expected = '''<p>aaa</p>
<p>bbb</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Paragraphs - Example 190', () {
      final markdown = '''aaa
bbb

ccc
ddd''';
      final expected = '''<p>aaa
bbb</p>
<p>ccc
ddd</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Paragraphs - Example 191', () {
      final markdown = '''aaa


bbb''';
      final expected = '''<p>aaa</p>
<p>bbb</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Paragraphs - Example 192', () {
      final markdown = '''  aaa
 bbb''';
      final expected = '''<p>aaa
bbb</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Paragraphs - Example 193', () {
      final markdown = '''aaa
             bbb
                                       ccc''';
      final expected = '''<p>aaa
bbb
ccc</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Paragraphs - Example 194', () {
      final markdown = '''   aaa
bbb''';
      final expected = '''<p>aaa
bbb</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Paragraphs - Example 195', () {
      final markdown = '''    aaa
bbb''';
      final expected = '''<pre><code>aaa
</code></pre>
<p>bbb</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Paragraphs - Example 196', () {
      final markdown = '''aaa     
bbb     ''';
      final expected = '''<p>aaa<br />
bbb</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Blank lines - Example 197', () {
      final markdown = '''

aaa
  

# aaa

  ''';
      final expected = '''<p>aaa</p>
<h1>aaa</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 198', () {
      final markdown = '''> # Foo
> bar
> baz''';
      final expected = '''<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 199', () {
      final markdown = '''># Foo
>bar
> baz''';
      final expected = '''<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 200', () {
      final markdown = '''   > # Foo
   > bar
 > baz''';
      final expected = '''<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 201', () {
      final markdown = '''    > # Foo
    > bar
    > baz''';
      final expected = '''<pre><code>&gt; # Foo
&gt; bar
&gt; baz
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 202', () {
      final markdown = '''> # Foo
> bar
baz''';
      final expected = '''<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 203', skip: kSkipKnownFailure, () {
      final markdown = '''> bar
baz
> foo''';
      final expected = '''<blockquote>
<p>bar
baz
foo</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 204', () {
      final markdown = '''> foo
---''';
      final expected = '''<blockquote>
<p>foo</p>
</blockquote>
<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 205', () {
      final markdown = '''> - foo
- bar''';
      final expected = '''<blockquote>
<ul>
<li>foo</li>
</ul>
</blockquote>
<ul>
<li>bar</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 206', () {
      final markdown = '''>     foo
    bar''';
      final expected = '''<blockquote>
<pre><code>foo
</code></pre>
</blockquote>
<pre><code>bar
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 207', () {
      final markdown = '''> ```
foo
```''';
      final expected = '''<blockquote>
<pre><code></code></pre>
</blockquote>
<p>foo</p>
<pre><code></code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 208', () {
      final markdown = '''> foo
    - bar''';
      final expected = '''<blockquote>
<p>foo
- bar</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 209', () {
      final markdown = '''>''';
      final expected = '''<blockquote>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 210', () {
      final markdown = '''>
>  
> ''';
      final expected = '''<blockquote>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 211', () {
      final markdown = '''>
> foo
>  ''';
      final expected = '''<blockquote>
<p>foo</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 212', () {
      final markdown = '''> foo

> bar''';
      final expected = '''<blockquote>
<p>foo</p>
</blockquote>
<blockquote>
<p>bar</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 213', () {
      final markdown = '''> foo
> bar''';
      final expected = '''<blockquote>
<p>foo
bar</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 214', () {
      final markdown = '''> foo
>
> bar''';
      final expected = '''<blockquote>
<p>foo</p>
<p>bar</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 215', () {
      final markdown = '''foo
> bar''';
      final expected = '''<p>foo</p>
<blockquote>
<p>bar</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 216', () {
      final markdown = '''> aaa
***
> bbb''';
      final expected = '''<blockquote>
<p>aaa</p>
</blockquote>
<hr />
<blockquote>
<p>bbb</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 217', () {
      final markdown = '''> bar
baz''';
      final expected = '''<blockquote>
<p>bar
baz</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 218', () {
      final markdown = '''> bar

baz''';
      final expected = '''<blockquote>
<p>bar</p>
</blockquote>
<p>baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 219', () {
      final markdown = '''> bar
>
baz''';
      final expected = '''<blockquote>
<p>bar</p>
</blockquote>
<p>baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 220', () {
      final markdown = '''> > > foo
bar''';
      final expected = '''<blockquote>
<blockquote>
<blockquote>
<p>foo
bar</p>
</blockquote>
</blockquote>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 221', skip: kSkipKnownFailure, () {
      final markdown = '''>>> foo
> bar
>>baz''';
      final expected = '''<blockquote>
<blockquote>
<blockquote>
<p>foo
bar
baz</p>
</blockquote>
</blockquote>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 222', () {
      final markdown = '''>     code

>    not code''';
      final expected = '''<blockquote>
<pre><code>code
</code></pre>
</blockquote>
<blockquote>
<p>not code</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 223', () {
      final markdown = '''A paragraph
with two lines.

    indented code

> A block quote.''';
      final expected = '''<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 224', () {
      final markdown = '''1.  A paragraph
    with two lines.

        indented code

    > A block quote.''';
      final expected = '''<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 225', () {
      final markdown = '''- one

 two''';
      final expected = '''<ul>
<li>one</li>
</ul>
<p>two</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 226', () {
      final markdown = '''- one

  two''';
      final expected = '''<ul>
<li>
<p>one</p>
<p>two</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 227', () {
      final markdown = ''' -    one

     two''';
      final expected = '''<ul>
<li>one</li>
</ul>
<pre><code> two
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 228', () {
      final markdown = ''' -    one

      two''';
      final expected = '''<ul>
<li>
<p>one</p>
<p>two</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 229', () {
      final markdown = '''   > > 1.  one
>>
>>     two''';
      final expected = '''<blockquote>
<blockquote>
<ol>
<li>
<p>one</p>
<p>two</p>
</li>
</ol>
</blockquote>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 230', () {
      final markdown = '''>>- one
>>
  >  > two''';
      final expected = '''<blockquote>
<blockquote>
<ul>
<li>one</li>
</ul>
<p>two</p>
</blockquote>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 231', () {
      final markdown = '''-one

2.two''';
      final expected = '''<p>-one</p>
<p>2.two</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 232', () {
      final markdown = '''- foo


  bar''';
      final expected = '''<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 233', () {
      final markdown = '''1.  foo

    ```
    bar
    ```

    baz

    > bam''';
      final expected = '''<ol>
<li>
<p>foo</p>
<pre><code>bar
</code></pre>
<p>baz</p>
<blockquote>
<p>bam</p>
</blockquote>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 234', () {
      final markdown = '''- Foo

      bar


      baz''';
      final expected = '''<ul>
<li>
<p>Foo</p>
<pre><code>bar


baz
</code></pre>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 235', () {
      final markdown = '''123456789. ok''';
      final expected = '''<ol start="123456789">
<li>ok</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 236', () {
      final markdown = '''1234567890. not ok''';
      final expected = '''<p>1234567890. not ok</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 237', () {
      final markdown = '''0. ok''';
      final expected = '''<ol start="0">
<li>ok</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 238', () {
      final markdown = '''003. ok''';
      final expected = '''<ol start="3">
<li>ok</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 239', () {
      final markdown = '''-1. not ok''';
      final expected = '''<p>-1. not ok</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 240', () {
      final markdown = '''- foo

      bar''';
      final expected = '''<ul>
<li>
<p>foo</p>
<pre><code>bar
</code></pre>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 241', () {
      final markdown = '''  10.  foo

           bar''';
      final expected = '''<ol start="10">
<li>
<p>foo</p>
<pre><code>bar
</code></pre>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 242', () {
      final markdown = '''    indented code

paragraph

    more code''';
      final expected = '''<pre><code>indented code
</code></pre>
<p>paragraph</p>
<pre><code>more code
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 243', () {
      final markdown = '''1.     indented code

   paragraph

       more code''';
      final expected = '''<ol>
<li>
<pre><code>indented code
</code></pre>
<p>paragraph</p>
<pre><code>more code
</code></pre>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 244', () {
      final markdown = '''1.      indented code

   paragraph

       more code''';
      final expected = '''<ol>
<li>
<pre><code> indented code
</code></pre>
<p>paragraph</p>
<pre><code>more code
</code></pre>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 245', () {
      final markdown = '''   foo

bar''';
      final expected = '''<p>foo</p>
<p>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 246', () {
      final markdown = '''-    foo

  bar''';
      final expected = '''<ul>
<li>foo</li>
</ul>
<p>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 247', () {
      final markdown = '''-  foo

   bar''';
      final expected = '''<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 248', skip: kSkipKnownFailure, () {
      final markdown = '''-
  foo
-
  ```
  bar
  ```
-
      baz''';
      final expected = '''<ul>
<li>foo</li>
<li>
<pre><code>bar
</code></pre>
</li>
<li>
<pre><code>baz
</code></pre>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 249', () {
      final markdown = '''-   
  foo''';
      final expected = '''<ul>
<li>foo</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 250', () {
      final markdown = '''-

  foo''';
      final expected = '''<ul>
<li></li>
</ul>
<p>foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 251', () {
      final markdown = '''- foo
-
- bar''';
      final expected = '''<ul>
<li>foo</li>
<li></li>
<li>bar</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 252', () {
      final markdown = '''- foo
-   
- bar''';
      final expected = '''<ul>
<li>foo</li>
<li></li>
<li>bar</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 253', () {
      final markdown = '''1. foo
2.
3. bar''';
      final expected = '''<ol>
<li>foo</li>
<li></li>
<li>bar</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 254', () {
      final markdown = '''*''';
      final expected = '''<ul>
<li></li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 255', () {
      final markdown = '''foo
*

foo
1.''';
      final expected = '''<p>foo
*</p>
<p>foo
1.</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 256', () {
      final markdown = ''' 1.  A paragraph
     with two lines.

         indented code

     > A block quote.''';
      final expected = '''<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 257', () {
      final markdown = '''  1.  A paragraph
      with two lines.

          indented code

      > A block quote.''';
      final expected = '''<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 258', () {
      final markdown = '''   1.  A paragraph
       with two lines.

           indented code

       > A block quote.''';
      final expected = '''<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 259', () {
      final markdown = '''    1.  A paragraph
        with two lines.

            indented code

        > A block quote.''';
      final expected = '''<pre><code>1.  A paragraph
    with two lines.

        indented code

    &gt; A block quote.
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 260', skip: kSkipKnownFailure, () {
      final markdown = '''  1.  A paragraph
with two lines.

          indented code

      > A block quote.''';
      final expected = '''<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 261', () {
      final markdown = '''  1.  A paragraph
    with two lines.''';
      final expected = '''<ol>
<li>A paragraph
with two lines.</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 262', () {
      final markdown = '''> 1. > Blockquote
continued here.''';
      final expected = '''<blockquote>
<ol>
<li>
<blockquote>
<p>Blockquote
continued here.</p>
</blockquote>
</li>
</ol>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 263', () {
      final markdown = '''> 1. > Blockquote
> continued here.''';
      final expected = '''<blockquote>
<ol>
<li>
<blockquote>
<p>Blockquote
continued here.</p>
</blockquote>
</li>
</ol>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 264', () {
      final markdown = '''- foo
  - bar
    - baz
      - boo''';
      final expected = '''<ul>
<li>foo
<ul>
<li>bar
<ul>
<li>baz
<ul>
<li>boo</li>
</ul>
</li>
</ul>
</li>
</ul>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 265', () {
      final markdown = '''- foo
 - bar
  - baz
   - boo''';
      final expected = '''<ul>
<li>foo</li>
<li>bar</li>
<li>baz</li>
<li>boo</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 266', () {
      final markdown = '''10) foo
    - bar''';
      final expected = '''<ol start="10">
<li>foo
<ul>
<li>bar</li>
</ul>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 267', () {
      final markdown = '''10) foo
   - bar''';
      final expected = '''<ol start="10">
<li>foo</li>
</ol>
<ul>
<li>bar</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 268', () {
      final markdown = '''- - foo''';
      final expected = '''<ul>
<li>
<ul>
<li>foo</li>
</ul>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 269', () {
      final markdown = '''1. - 2. foo''';
      final expected = '''<ol>
<li>
<ul>
<li>
<ol start="2">
<li>foo</li>
</ol>
</li>
</ul>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 270', () {
      final markdown = '''- # Foo
- Bar
  ---
  baz''';
      final expected = '''<ul>
<li>
<h1>Foo</h1>
</li>
<li>
<h2>Bar</h2>
baz</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 271', () {
      final markdown = '''- foo
- bar
+ baz''';
      final expected = '''<ul>
<li>foo</li>
<li>bar</li>
</ul>
<ul>
<li>baz</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 272', () {
      final markdown = '''1. foo
2. bar
3) baz''';
      final expected = '''<ol>
<li>foo</li>
<li>bar</li>
</ol>
<ol start="3">
<li>baz</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 273', () {
      final markdown = '''Foo
- bar
- baz''';
      final expected = '''<p>Foo</p>
<ul>
<li>bar</li>
<li>baz</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 274', () {
      final markdown = '''The number of windows in my house is
14.  The number of doors is 6.''';
      final expected = '''<p>The number of windows in my house is
14.  The number of doors is 6.</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 275', () {
      final markdown = '''The number of windows in my house is
1.  The number of doors is 6.''';
      final expected = '''<p>The number of windows in my house is</p>
<ol>
<li>The number of doors is 6.</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 276', () {
      final markdown = '''- foo

- bar


- baz''';
      final expected = '''<ul>
<li>
<p>foo</p>
</li>
<li>
<p>bar</p>
</li>
<li>
<p>baz</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 277', () {
      final markdown = '''- foo
  - bar
    - baz


      bim''';
      final expected = '''<ul>
<li>foo
<ul>
<li>bar
<ul>
<li>
<p>baz</p>
<p>bim</p>
</li>
</ul>
</li>
</ul>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 278', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''- foo
- bar

<!-- -->

- baz
- bim''';
      final expected = '''<ul>
<li>foo</li>
<li>bar</li>
</ul>
<!-- -->
<ul>
<li>baz</li>
<li>bim</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 279', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''-   foo

    notcode

-   foo

<!-- -->

    code''';
      final expected = '''<ul>
<li>
<p>foo</p>
<p>notcode</p>
</li>
<li>
<p>foo</p>
</li>
</ul>
<!-- -->
<pre><code>code
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 280', () {
      final markdown = '''- a
 - b
  - c
   - d
  - e
 - f
- g''';
      final expected = '''<ul>
<li>a</li>
<li>b</li>
<li>c</li>
<li>d</li>
<li>e</li>
<li>f</li>
<li>g</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 281', () {
      final markdown = '''1. a

  2. b

   3. c''';
      final expected = '''<ol>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
</li>
<li>
<p>c</p>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 282', () {
      final markdown = '''- a
 - b
  - c
   - d
    - e''';
      final expected = '''<ul>
<li>a</li>
<li>b</li>
<li>c</li>
<li>d
- e</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 283', () {
      final markdown = '''1. a

  2. b

    3. c''';
      final expected = '''<ol>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
</li>
</ol>
<pre><code>3. c
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 284', () {
      final markdown = '''- a
- b

- c''';
      final expected = '''<ul>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
</li>
<li>
<p>c</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 285', () {
      final markdown = '''* a
*

* c''';
      final expected = '''<ul>
<li>
<p>a</p>
</li>
<li></li>
<li>
<p>c</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 286', () {
      final markdown = '''- a
- b

  c
- d''';
      final expected = '''<ul>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
<p>c</p>
</li>
<li>
<p>d</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 287', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''- a
- b

  [ref]: /url
- d''';
      final expected = '''<ul>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
</li>
<li>
<p>d</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 288', skip: kSkipKnownFailure, () {
      final markdown = '''- a
- ```
  b


  ```
- c''';
      final expected = '''<ul>
<li>a</li>
<li>
<pre><code>b


</code></pre>
</li>
<li>c</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 289', () {
      final markdown = '''- a
  - b

    c
- d''';
      final expected = '''<ul>
<li>a
<ul>
<li>
<p>b</p>
<p>c</p>
</li>
</ul>
</li>
<li>d</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 290', () {
      final markdown = '''* a
  > b
  >
* c''';
      final expected = '''<ul>
<li>a
<blockquote>
<p>b</p>
</blockquote>
</li>
<li>c</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 291', skip: kSkipKnownFailure, () {
      final markdown = '''- a
  > b
  ```
  c
  ```
- d''';
      final expected = '''<ul>
<li>a
<blockquote>
<p>b</p>
</blockquote>
<pre><code>c
</code></pre>
</li>
<li>d</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 292', () {
      final markdown = '''- a''';
      final expected = '''<ul>
<li>a</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 293', () {
      final markdown = '''- a
  - b''';
      final expected = '''<ul>
<li>a
<ul>
<li>b</li>
</ul>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 294', () {
      final markdown = '''1. ```
   foo
   ```

   bar''';
      final expected = '''<ol>
<li>
<pre><code>foo
</code></pre>
<p>bar</p>
</li>
</ol>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 295', () {
      final markdown = '''* foo
  * bar

  baz''';
      final expected = '''<ul>
<li>
<p>foo</p>
<ul>
<li>bar</li>
</ul>
<p>baz</p>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Lists - Example 296', () {
      final markdown = '''- a
  - b
  - c

- d
  - e
  - f''';
      final expected = '''<ul>
<li>
<p>a</p>
<ul>
<li>b</li>
<li>c</li>
</ul>
</li>
<li>
<p>d</p>
<ul>
<li>e</li>
<li>f</li>
</ul>
</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Inlines - Example 297', () {
      final markdown = '''`hi`lo`''';
      final expected = '''<p><code>hi</code>lo`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 298', () {
      final markdown =
          '''\\!\\"\\#\\\$\\%\\&\\\'\\(\\)\\*\\+\\,\\-\\.\\/\\:\\;\\<\\=\\>\\?\\@\\[\\\\\\]\\^\\_\\`\\{\\|\\}\\~''';
      final expected =
          '''<p>!&quot;#\$%&amp;\'()*+,-./:;&lt;=&gt;?@[\\]^_`{|}~</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 299', () {
      final markdown = '''\\	\\A\\a\\ \\3\\φ\\«''';
      final expected = '''<p>\\	\\A\\a\\ \\3\\φ\\«</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 300', () {
      final markdown = '''\\*not emphasized*
\\<br/> not a tag
\\[not a link](/foo)
\\`not code`
1\\. not a list
\\* not a list
\\# not a heading
\\[foo]: /url "not a reference"
\\&ouml; not a character entity''';
      final expected = '''<p>*not emphasized*
&lt;br/&gt; not a tag
[not a link](/foo)
`not code`
1. not a list
* not a list
# not a heading
[foo]: /url &quot;not a reference&quot;
&amp;ouml; not a character entity</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 301', () {
      final markdown = '''\\\\*emphasis*''';
      final expected = '''<p>\\<em>emphasis</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 302', () {
      final markdown = '''foo\\
bar''';
      final expected = '''<p>foo<br />
bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 303', () {
      final markdown = '''`` \\[\\` ``''';
      final expected = '''<p><code>\\[\\`</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 304', () {
      final markdown = '''    \\[\\]''';
      final expected = '''<pre><code>\\[\\]
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 305', () {
      final markdown = '''~~~
\\[\\]
~~~''';
      final expected = '''<pre><code>\\[\\]
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 306', () {
      final markdown = '''<http://example.com?find=\\*>''';
      final expected =
          '''<p><a href="http://example.com?find=%5C*">http://example.com?find=\\*</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 307', skip: kSkipKnownFailure, () {
      final markdown = '''<a href="/bar\\/)">''';
      final expected = '''<a href="/bar\\/)">''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 308', () {
      final markdown = '''[foo](/bar\\* "ti\\*tle")''';
      final expected = '''<p><a href="/bar*" title="ti*tle">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 309', skip: kSkipKnownFailure, () {
      final markdown = '''[foo]

[foo]: /bar\\* "ti\\*tle"''';
      final expected = '''<p><a href="/bar*" title="ti*tle">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 310', skip: kSkipKnownFailure, () {
      final markdown = '''``` foo\\+bar
foo
```''';
      final expected = '''<pre><code class="language-foo+bar">foo
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 311', () {
      final markdown = '''&nbsp; &amp; &copy; &AElig; &Dcaron;
&frac34; &HilbertSpace; &DifferentialD;
&ClockwiseContourIntegral; &ngE;''';
      final expected = '''<p>  &amp; © Æ Ď
¾ ℋ ⅆ
∲ ≧̸</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 312', () {
      final markdown = '''&#35; &#1234; &#992; &#0;''';
      final expected = '''<p># Ӓ Ϡ �</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 313', () {
      final markdown = '''&#X22; &#XD06; &#xcab;''';
      final expected = '''<p>&quot; ആ ಫ</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 314', () {
      final markdown = '''&nbsp &x; &#; &#x;
&#987654321;
&#abcdef0;
&ThisIsNotDefined; &hi?;''';
      final expected = '''<p>&amp;nbsp &amp;x; &amp;#; &amp;#x;
&amp;#987654321;
&amp;#abcdef0;
&amp;ThisIsNotDefined; &amp;hi?;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 315', () {
      final markdown = '''&copy''';
      final expected = '''<p>&amp;copy</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 316', () {
      final markdown = '''&MadeUpEntity;''';
      final expected = '''<p>&amp;MadeUpEntity;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 317', skip: kSkipKnownFailure, () {
      final markdown = '''<a href="&ouml;&ouml;.html">''';
      final expected = '''<a href="&ouml;&ouml;.html">''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 318', () {
      final markdown = '''[foo](/f&ouml;&ouml; "f&ouml;&ouml;")''';
      final expected =
          '''<p><a href="/f%C3%B6%C3%B6" title="föö">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 319', skip: kSkipKnownFailure, () {
      final markdown = '''[foo]

[foo]: /f&ouml;&ouml; "f&ouml;&ouml;"''';
      final expected =
          '''<p><a href="/f%C3%B6%C3%B6" title="föö">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 320', skip: kSkipKnownFailure, () {
      final markdown = '''``` f&ouml;&ouml;
foo
```''';
      final expected = '''<pre><code class="language-föö">foo
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 321', () {
      final markdown = '''`f&ouml;&ouml;`''';
      final expected = '''<p><code>f&amp;ouml;&amp;ouml;</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 322', () {
      final markdown = '''    f&ouml;f&ouml;''';
      final expected = '''<pre><code>f&amp;ouml;f&amp;ouml;
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 323', () {
      final markdown = '''&#42;foo&#42;
*foo*''';
      final expected = '''<p>*foo*
<em>foo</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 324', () {
      final markdown = '''&#42; foo

* foo''';
      final expected = '''<p>* foo</p>
<ul>
<li>foo</li>
</ul>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 325', () {
      final markdown = '''foo&#10;&#10;bar''';
      final expected = '''<p>foo

bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 326', () {
      final markdown = '''&#9;foo''';
      final expected = '''<p>	foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 327', () {
      final markdown = '''[a](url &quot;tit&quot;)''';
      final expected = '''<p>[a](url &quot;tit&quot;)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 328', () {
      final markdown = '''`foo`''';
      final expected = '''<p><code>foo</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 329', () {
      final markdown = '''`` foo ` bar ``''';
      final expected = '''<p><code>foo ` bar</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 330', () {
      final markdown = '''` `` `''';
      final expected = '''<p><code>``</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 331', () {
      final markdown = '''`  ``  `''';
      final expected = '''<p><code> `` </code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 332', () {
      final markdown = '''` a`''';
      final expected = '''<p><code> a</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 333', () {
      final markdown = '''` b `''';
      final expected = '''<p><code> b </code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 334', () {
      final markdown = '''` `
`  `''';
      final expected = '''<p><code> </code>
<code>  </code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 335', () {
      final markdown = '''``
foo
bar  
baz
``''';
      final expected = '''<p><code>foo bar   baz</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 336', () {
      final markdown = '''``
foo 
``''';
      final expected = '''<p><code>foo </code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 337', () {
      final markdown = '''`foo   bar 
baz`''';
      final expected = '''<p><code>foo   bar  baz</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 338', () {
      final markdown = '''`foo\\`bar`''';
      final expected = '''<p><code>foo\\</code>bar`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 339', () {
      final markdown = '''``foo`bar``''';
      final expected = '''<p><code>foo`bar</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 340', () {
      final markdown = '''` foo `` bar `''';
      final expected = '''<p><code>foo `` bar</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 341', () {
      final markdown = '''*foo`*`''';
      final expected = '''<p>*foo<code>*</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 342', () {
      final markdown = '''[not a `link](/foo`)''';
      final expected = '''<p>[not a <code>link](/foo</code>)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 343', () {
      final markdown = '''`<a href="`">`''';
      final expected = '''<p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 344', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''<a href="`">`''';
      final expected = '''<p><a href="`">`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 345', () {
      final markdown = '''`<http://foo.bar.`baz>`''';
      final expected = '''<p><code>&lt;http://foo.bar.</code>baz&gt;`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 346', () {
      final markdown = '''<http://foo.bar.`baz>`''';
      final expected =
          '''<p><a href="http://foo.bar.%60baz">http://foo.bar.`baz</a>`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 347', () {
      final markdown = '''```foo``''';
      final expected = '''<p>```foo``</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 348', () {
      final markdown = '''`foo''';
      final expected = '''<p>`foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 349', () {
      final markdown = '''`foo``bar``''';
      final expected = '''<p>`foo<code>bar</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 350', () {
      final markdown = '''*foo bar*''';
      final expected = '''<p><em>foo bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 351', () {
      final markdown = '''a * foo bar*''';
      final expected = '''<p>a * foo bar*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 352', () {
      final markdown = '''a*"foo"*''';
      final expected = '''<p>a*&quot;foo&quot;*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 353', skip: kSkipKnownFailure, () {
      final markdown = '''* a *''';
      final expected = '''<p>* a *</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 354', () {
      final markdown = '''foo*bar*''';
      final expected = '''<p>foo<em>bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 355', () {
      final markdown = '''5*6*78''';
      final expected = '''<p>5<em>6</em>78</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 356', () {
      final markdown = '''_foo bar_''';
      final expected = '''<p><em>foo bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 357', () {
      final markdown = '''_ foo bar_''';
      final expected = '''<p>_ foo bar_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 358', () {
      final markdown = '''a_"foo"_''';
      final expected = '''<p>a_&quot;foo&quot;_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 359', () {
      final markdown = '''foo_bar_''';
      final expected = '''<p>foo_bar_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 360', () {
      final markdown = '''5_6_78''';
      final expected = '''<p>5_6_78</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 361', () {
      final markdown = '''пристаням_стремятся_''';
      final expected = '''<p>пристаням_стремятся_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 362', () {
      final markdown = '''aa_"bb"_cc''';
      final expected = '''<p>aa_&quot;bb&quot;_cc</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 363', () {
      final markdown = '''foo-_(bar)_''';
      final expected = '''<p>foo-<em>(bar)</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 364', () {
      final markdown = '''_foo*''';
      final expected = '''<p>_foo*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 365', () {
      final markdown = '''*foo bar *''';
      final expected = '''<p>*foo bar *</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 366', () {
      final markdown = '''*foo bar
*''';
      final expected = '''<p>*foo bar
*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 367', () {
      final markdown = '''*(*foo)''';
      final expected = '''<p>*(*foo)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 368', () {
      final markdown = '''*(*foo*)*''';
      final expected = '''<p><em>(<em>foo</em>)</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 369', () {
      final markdown = '''*foo*bar''';
      final expected = '''<p><em>foo</em>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 370', () {
      final markdown = '''_foo bar _''';
      final expected = '''<p>_foo bar _</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 371', () {
      final markdown = '''_(_foo)''';
      final expected = '''<p>_(_foo)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 372', () {
      final markdown = '''_(_foo_)_''';
      final expected = '''<p><em>(<em>foo</em>)</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 373', () {
      final markdown = '''_foo_bar''';
      final expected = '''<p>_foo_bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 374', () {
      final markdown = '''_пристаням_стремятся''';
      final expected = '''<p>_пристаням_стремятся</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 375', () {
      final markdown = '''_foo_bar_baz_''';
      final expected = '''<p><em>foo_bar_baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 376', () {
      final markdown = '''_(bar)_.''';
      final expected = '''<p><em>(bar)</em>.</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 377', () {
      final markdown = '''**foo bar**''';
      final expected = '''<p><strong>foo bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 378', () {
      final markdown = '''** foo bar**''';
      final expected = '''<p>** foo bar**</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 379', () {
      final markdown = '''a**"foo"**''';
      final expected = '''<p>a**&quot;foo&quot;**</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 380', () {
      final markdown = '''foo**bar**''';
      final expected = '''<p>foo<strong>bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 381', () {
      final markdown = '''__foo bar__''';
      final expected = '''<p><strong>foo bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 382', () {
      final markdown = '''__ foo bar__''';
      final expected = '''<p>__ foo bar__</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 383', () {
      final markdown = '''__
foo bar__''';
      final expected = '''<p>__
foo bar__</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 384', () {
      final markdown = '''a__"foo"__''';
      final expected = '''<p>a__&quot;foo&quot;__</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 385', () {
      final markdown = '''foo__bar__''';
      final expected = '''<p>foo__bar__</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 386', () {
      final markdown = '''5__6__78''';
      final expected = '''<p>5__6__78</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 387', () {
      final markdown = '''пристаням__стремятся__''';
      final expected = '''<p>пристаням__стремятся__</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 388', () {
      final markdown = '''__foo, __bar__, baz__''';
      final expected = '''<p><strong>foo, bar, baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 389', () {
      final markdown = '''foo-__(bar)__''';
      final expected = '''<p>foo-<strong>(bar)</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 390', () {
      final markdown = '''**foo bar **''';
      final expected = '''<p>**foo bar **</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 391', () {
      final markdown = '''**(**foo)''';
      final expected = '''<p>**(**foo)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 392', () {
      final markdown = '''*(**foo**)*''';
      final expected = '''<p><em>(<strong>foo</strong>)</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 393', () {
      final markdown = '''**Gomphocarpus (*Gomphocarpus physocarpus*, syn.
*Asclepias physocarpa*)**''';
      final expected =
          '''<p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.
<em>Asclepias physocarpa</em>)</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 394', () {
      final markdown = '''**foo "*bar*" foo**''';
      final expected =
          '''<p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 395', () {
      final markdown = '''**foo**bar''';
      final expected = '''<p><strong>foo</strong>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 396', () {
      final markdown = '''__foo bar __''';
      final expected = '''<p>__foo bar __</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 397', () {
      final markdown = '''__(__foo)''';
      final expected = '''<p>__(__foo)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 398', () {
      final markdown = '''_(__foo__)_''';
      final expected = '''<p><em>(<strong>foo</strong>)</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 399', () {
      final markdown = '''__foo__bar''';
      final expected = '''<p>__foo__bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 400', () {
      final markdown = '''__пристаням__стремятся''';
      final expected = '''<p>__пристаням__стремятся</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 401', () {
      final markdown = '''__foo__bar__baz__''';
      final expected = '''<p><strong>foo__bar__baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 402', () {
      final markdown = '''__(bar)__.''';
      final expected = '''<p><strong>(bar)</strong>.</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 403', () {
      final markdown = '''*foo [bar](/url)*''';
      final expected = '''<p><em>foo <a href="/url">bar</a></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 404', () {
      final markdown = '''*foo
bar*''';
      final expected = '''<p><em>foo
bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 405', () {
      final markdown = '''_foo __bar__ baz_''';
      final expected = '''<p><em>foo <strong>bar</strong> baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 406', () {
      final markdown = '''_foo _bar_ baz_''';
      final expected = '''<p><em>foo <em>bar</em> baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 407', () {
      final markdown = '''__foo_ bar_''';
      final expected = '''<p><em><em>foo</em> bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 408', () {
      final markdown = '''*foo *bar**''';
      final expected = '''<p><em>foo <em>bar</em></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 409', () {
      final markdown = '''*foo **bar** baz*''';
      final expected = '''<p><em>foo <strong>bar</strong> baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 410', () {
      final markdown = '''*foo**bar**baz*''';
      final expected = '''<p><em>foo<strong>bar</strong>baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 411', () {
      final markdown = '''*foo**bar*''';
      final expected = '''<p><em>foo**bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 412', () {
      final markdown = '''***foo** bar*''';
      final expected = '''<p><em><strong>foo</strong> bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 413', () {
      final markdown = '''*foo **bar***''';
      final expected = '''<p><em>foo <strong>bar</strong></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 414', () {
      final markdown = '''*foo**bar***''';
      final expected = '''<p><em>foo<strong>bar</strong></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 415', () {
      final markdown = '''foo***bar***baz''';
      final expected = '''<p>foo<em><strong>bar</strong></em>baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 416', () {
      final markdown = '''foo******bar*********baz''';
      final expected = '''<p>foo<strong>bar</strong>***baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 417', () {
      final markdown = '''*foo **bar *baz* bim** bop*''';
      final expected =
          '''<p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 418', () {
      final markdown = '''*foo [*bar*](/url)*''';
      final expected =
          '''<p><em>foo <a href="/url"><em>bar</em></a></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 419', () {
      final markdown = '''** is not an empty emphasis''';
      final expected = '''<p>** is not an empty emphasis</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 420', () {
      final markdown = '''**** is not an empty strong emphasis''';
      final expected = '''<p>**** is not an empty strong emphasis</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 421', () {
      final markdown = '''**foo [bar](/url)**''';
      final expected = '''<p><strong>foo <a href="/url">bar</a></strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 422', () {
      final markdown = '''**foo
bar**''';
      final expected = '''<p><strong>foo
bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 423', () {
      final markdown = '''__foo _bar_ baz__''';
      final expected = '''<p><strong>foo <em>bar</em> baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 424', () {
      final markdown = '''__foo __bar__ baz__''';
      final expected = '''<p><strong>foo bar baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 425', () {
      final markdown = '''____foo__ bar__''';
      final expected = '''<p><strong>foo bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 426', () {
      final markdown = '''**foo **bar****''';
      final expected = '''<p><strong>foo bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 427', () {
      final markdown = '''**foo *bar* baz**''';
      final expected = '''<p><strong>foo <em>bar</em> baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 428', () {
      final markdown = '''**foo*bar*baz**''';
      final expected = '''<p><strong>foo<em>bar</em>baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 429', () {
      final markdown = '''***foo* bar**''';
      final expected = '''<p><strong><em>foo</em> bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 430', () {
      final markdown = '''**foo *bar***''';
      final expected = '''<p><strong>foo <em>bar</em></strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 431', () {
      final markdown = '''**foo *bar **baz**
bim* bop**''';
      final expected = '''<p><strong>foo <em>bar <strong>baz</strong>
bim</em> bop</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 432', () {
      final markdown = '''**foo [*bar*](/url)**''';
      final expected =
          '''<p><strong>foo <a href="/url"><em>bar</em></a></strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 433', () {
      final markdown = '''__ is not an empty emphasis''';
      final expected = '''<p>__ is not an empty emphasis</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 434', () {
      final markdown = '''____ is not an empty strong emphasis''';
      final expected = '''<p>____ is not an empty strong emphasis</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 435', () {
      final markdown = '''foo ***''';
      final expected = '''<p>foo ***</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 436', () {
      final markdown = '''foo *\\**''';
      final expected = '''<p>foo <em>*</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 437', () {
      final markdown = '''foo *_*''';
      final expected = '''<p>foo <em>_</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 438', () {
      final markdown = '''foo *****''';
      final expected = '''<p>foo *****</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 439', () {
      final markdown = '''foo **\\***''';
      final expected = '''<p>foo <strong>*</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 440', () {
      final markdown = '''foo **_**''';
      final expected = '''<p>foo <strong>_</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 441', () {
      final markdown = '''**foo*''';
      final expected = '''<p>*<em>foo</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 442', () {
      final markdown = '''*foo**''';
      final expected = '''<p><em>foo</em>*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 443', () {
      final markdown = '''***foo**''';
      final expected = '''<p>*<strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 444', () {
      final markdown = '''****foo*''';
      final expected = '''<p>***<em>foo</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 445', () {
      final markdown = '''**foo***''';
      final expected = '''<p><strong>foo</strong>*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 446', () {
      final markdown = '''*foo****''';
      final expected = '''<p><em>foo</em>***</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 447', () {
      final markdown = '''foo ___''';
      final expected = '''<p>foo ___</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 448', () {
      final markdown = '''foo _\\__''';
      final expected = '''<p>foo <em>_</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 449', () {
      final markdown = '''foo _*_''';
      final expected = '''<p>foo <em>*</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 450', () {
      final markdown = '''foo _____''';
      final expected = '''<p>foo _____</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 451', () {
      final markdown = '''foo __\\___''';
      final expected = '''<p>foo <strong>_</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 452', () {
      final markdown = '''foo __*__''';
      final expected = '''<p>foo <strong>*</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 453', () {
      final markdown = '''__foo_''';
      final expected = '''<p>_<em>foo</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 454', () {
      final markdown = '''_foo__''';
      final expected = '''<p><em>foo</em>_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 455', () {
      final markdown = '''___foo__''';
      final expected = '''<p>_<strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 456', () {
      final markdown = '''____foo_''';
      final expected = '''<p>___<em>foo</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 457', () {
      final markdown = '''__foo___''';
      final expected = '''<p><strong>foo</strong>_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 458', () {
      final markdown = '''_foo____''';
      final expected = '''<p><em>foo</em>___</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 459', () {
      final markdown = '''**foo**''';
      final expected = '''<p><strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 460', () {
      final markdown = '''*_foo_*''';
      final expected = '''<p><em><em>foo</em></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 461', () {
      final markdown = '''__foo__''';
      final expected = '''<p><strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 462', () {
      final markdown = '''_*foo*_''';
      final expected = '''<p><em><em>foo</em></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 463', () {
      final markdown = '''****foo****''';
      final expected = '''<p><strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 464', () {
      final markdown = '''____foo____''';
      final expected = '''<p><strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 465', () {
      final markdown = '''******foo******''';
      final expected = '''<p><strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 466', () {
      final markdown = '''***foo***''';
      final expected = '''<p><em><strong>foo</strong></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 467', () {
      final markdown = '''_____foo_____''';
      final expected = '''<p><em><strong>foo</strong></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 468', () {
      final markdown = '''*foo _bar* baz_''';
      final expected = '''<p><em>foo _bar</em> baz_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 469', () {
      final markdown = '''*foo __bar *baz bim__ bam*''';
      final expected =
          '''<p><em>foo <strong>bar *baz bim</strong> bam</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 470', () {
      final markdown = '''**foo **bar baz**''';
      final expected = '''<p>**foo <strong>bar baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 471', () {
      final markdown = '''*foo *bar baz*''';
      final expected = '''<p>*foo <em>bar baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 472', () {
      final markdown = '''*[bar*](/url)''';
      final expected = '''<p>*<a href="/url">bar*</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 473', () {
      final markdown = '''_foo [bar_](/url)''';
      final expected = '''<p>_foo <a href="/url">bar_</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 474', skip: kSkipKnownFailure, () {
      final markdown = '''*<img src="foo" title="*"/>''';
      final expected = '''<p>*<img src="foo" title="*"/></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 475',  skip: kSkipKnownFailure, () {
      final markdown = '''**<a href="**">''';
      final expected = '''<p>**<a href="**"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 476', skip: kSkipKnownFailure, () {
      final markdown = '''__<a href="__">''';
      final expected = '''<p>__<a href="__"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 477', () {
      final markdown = '''*a `*`*''';
      final expected = '''<p><em>a <code>*</code></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 478', () {
      final markdown = '''_a `_`_''';
      final expected = '''<p><em>a <code>_</code></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 479', () {
      final markdown = '''**a<http://foo.bar/?q=**>''';
      final expected =
          '''<p>**a<a href="http://foo.bar/?q=**">http://foo.bar/?q=**</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 480', () {
      final markdown = '''__a<http://foo.bar/?q=__>''';
      final expected =
          '''<p>__a<a href="http://foo.bar/?q=__">http://foo.bar/?q=__</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 481', () {
      final markdown = '''[link](/uri "title")''';
      final expected = '''<p><a href="/uri" title="title">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 482', () {
      final markdown = '''[link](/uri)''';
      final expected = '''<p><a href="/uri">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 483', () {
      final markdown = '''[link]()''';
      final expected = '''<p><a href="">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 484', () {
      final markdown = '''[link](<>)''';
      final expected = '''<p><a href="">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 485', () {
      final markdown = '''[link](/my uri)''';
      final expected = '''<p>[link](/my uri)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 486', () {
      final markdown = '''[link](</my uri>)''';
      final expected = '''<p><a href="/my%20uri">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 487', () {
      final markdown = '''[link](foo
bar)''';
      final expected = '''<p>[link](foo
bar)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 488', skip: kSkipKnownFailure, () {
      final markdown = '''[link](<foo
bar>)''';
      final expected = '''<p>[link](<foo
bar>)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 489', () {
      final markdown = '''[a](<b)c>)''';
      final expected = '''<p><a href="b)c">a</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 490', () {
      final markdown = '''[link](<foo\\>)''';
      final expected = '''<p>[link](&lt;foo&gt;)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 491', skip: kSkipKnownFailure, () {
      final markdown = '''[a](<b)c
[a](<b)c>
[a](<b>c)''';
      final expected = '''<p>[a](&lt;b)c
[a](&lt;b)c&gt;
[a](<b>c)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 492', () {
      final markdown = '''[link](\\(foo\\))''';
      final expected = '''<p><a href="(foo)">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 493', () {
      final markdown = '''[link](foo(and(bar)))''';
      final expected = '''<p><a href="foo(and(bar))">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 494', () {
      final markdown = '''[link](foo\\(and\\(bar\\))''';
      final expected = '''<p><a href="foo(and(bar)">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 495', () {
      final markdown = '''[link](<foo(and(bar)>)''';
      final expected = '''<p><a href="foo(and(bar)">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 496', () {
      final markdown = '''[link](foo\\)\\:)''';
      final expected = '''<p><a href="foo):">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 497', () {
      final markdown = '''[link](#fragment)

[link](http://example.com#fragment)

[link](http://example.com?foo=3#frag)''';
      final expected = '''<p><a href="#fragment">link</a></p>
<p><a href="http://example.com#fragment">link</a></p>
<p><a href="http://example.com?foo=3#frag">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 498', () {
      final markdown = '''[link](foo\\bar)''';
      final expected = '''<p><a href="foo%5Cbar">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 499', () {
      final markdown = '''[link](foo%20b&auml;)''';
      final expected = '''<p><a href="foo%20b%C3%A4">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 500', () {
      final markdown = '''[link]("title")''';
      final expected = '''<p><a href="%22title%22">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 501', () {
      final markdown = '''[link](/url "title")
[link](/url \'title\')
[link](/url (title))''';
      final expected = '''<p><a href="/url" title="title">link</a>
<a href="/url" title="title">link</a>
<a href="/url" title="title">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 502', () {
      final markdown = '''[link](/url "title \\"&quot;")''';
      final expected =
          '''<p><a href="/url" title="title &quot;&quot;">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 503', () {
      final markdown = '''[link](/url "title")''';
      final expected = '''<p><a href="/url%C2%A0%22title%22">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 504', () {
      final markdown = '''[link](/url "title "and" title")''';
      final expected =
          '''<p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 505', () {
      final markdown = '''[link](/url \'title "and" title\')''';
      final expected =
          '''<p><a href="/url" title="title &quot;and&quot; title">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 506', skip: kSkipKnownFailure, () {
      final markdown = '''[link](   /uri
  "title"  )''';
      final expected = '''<p><a href="/uri" title="title">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 507', () {
      final markdown = '''[link] (/uri)''';
      final expected = '''<p>[link] (/uri)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 508', () {
      final markdown = '''[link [foo [bar]]](/uri)''';
      final expected = '''<p><a href="/uri">link [foo [bar]]</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 509', () {
      final markdown = '''[link] bar](/uri)''';
      final expected = '''<p>[link] bar](/uri)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 510', () {
      final markdown = '''[link [bar](/uri)''';
      final expected = '''<p>[link <a href="/uri">bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 511', () {
      final markdown = '''[link \\[bar](/uri)''';
      final expected = '''<p><a href="/uri">link [bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 512', () {
      final markdown = '''[link *foo **bar** `#`*](/uri)''';
      final expected =
          '''<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 513', () {
      final markdown = '''[![moon](moon.jpg)](/uri)''';
      final expected =
          '''<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 514', () {
      final markdown = '''[foo [bar](/uri)](/uri)''';
      final expected = '''<p>[foo <a href="/uri">bar</a>](/uri)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 515', () {
      final markdown = '''[foo *[bar [baz](/uri)](/uri)*](/uri)''';
      final expected =
          '''<p>[foo <em>[bar <a href="/uri">baz</a>](/uri)</em>](/uri)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 516', () {
      final markdown = '''![[[foo](uri1)](uri2)](uri3)''';
      final expected = '''<p><img src="uri3" alt="[foo](uri2)" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 517', () {
      final markdown = '''*[foo*](/uri)''';
      final expected = '''<p>*<a href="/uri">foo*</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 518', () {
      final markdown = '''[foo *bar](baz*)''';
      final expected = '''<p><a href="baz*">foo *bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 519', () {
      final markdown = '''*foo [bar* baz]''';
      final expected = '''<p><em>foo [bar</em> baz]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 520', skip: kSkipKnownFailure, () {
      final markdown = '''[foo <bar attr="](baz)">''';
      final expected = '''<p>[foo <bar attr="](baz)"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 521', () {
      final markdown = '''[foo`](/uri)`''';
      final expected = '''<p>[foo<code>](/uri)</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 522', () {
      final markdown = '''[foo<http://example.com/?search=](uri)>''';
      final expected =
          '''<p>[foo<a href="http://example.com/?search=%5D(uri)">http://example.com/?search=](uri)</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 523', skip: kSkipKnownFailure, () {
      final markdown = '''[foo][bar]

[bar]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 524', skip: kSkipKnownFailure, () {
      final markdown = '''[link [foo [bar]]][ref]

[ref]: /uri''';
      final expected = '''<p><a href="/uri">link [foo [bar]]</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 525', skip: kSkipKnownFailure, () {
      final markdown = '''[link \\[bar][ref]

[ref]: /uri''';
      final expected = '''<p><a href="/uri">link [bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 526', skip: kSkipKnownFailure, () {
      final markdown = '''[link *foo **bar** `#`*][ref]

[ref]: /uri''';
      final expected =
          '''<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 527', skip: kSkipKnownFailure, () {
      final markdown = '''[![moon](moon.jpg)][ref]

[ref]: /uri''';
      final expected =
          '''<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 528', skip: kSkipKnownFailure, () {
      final markdown = '''[foo [bar](/uri)][ref]

[ref]: /uri''';
      final expected =
          '''<p>[foo <a href="/uri">bar</a>]<a href="/uri">ref</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 529', skip: kSkipKnownFailure, () {
      final markdown = '''[foo *bar [baz][ref]*][ref]

[ref]: /uri''';
      final expected =
          '''<p>[foo <em>bar <a href="/uri">baz</a></em>]<a href="/uri">ref</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 530', skip: kSkipKnownFailure, () {
      final markdown = '''*[foo*][ref]

[ref]: /uri''';
      final expected = '''<p>*<a href="/uri">foo*</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 531', skip: kSkipKnownFailure, () {
      final markdown = '''[foo *bar][ref]

[ref]: /uri''';
      final expected = '''<p><a href="/uri">foo *bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 532', skip: kSkipKnownFailure, () {
      final markdown = '''[foo <bar attr="][ref]">

[ref]: /uri''';
      final expected = '''<p>[foo <bar attr="][ref]"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 533', skip: kSkipKnownFailure, () {
      final markdown = '''[foo`][ref]`

[ref]: /uri''';
      final expected = '''<p>[foo<code>][ref]</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 534', skip: kSkipKnownFailure, () {
      final markdown = '''[foo<http://example.com/?search=][ref]>

[ref]: /uri''';
      final expected =
          '''<p>[foo<a href="http://example.com/?search=%5D%5Bref%5D">http://example.com/?search=][ref]</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 535', skip: kSkipKnownFailure, () {
      final markdown = '''[foo][BaR]

[bar]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 536', skip: kSkipKnownFailure, () {
      final markdown = '''[Толпой][Толпой] is a Russian word.

[ТОЛПОЙ]: /url''';
      final expected =
          '''<p><a href="/url">Толпой</a> is a Russian word.</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 537', () {
      final markdown = '''[Foo
  bar]: /url

[Baz][Foo bar]''';
      final expected = '''<p><a href="/url">Baz</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 538', skip: kSkipKnownFailure, () {
      final markdown = '''[foo] [bar]

[bar]: /url "title"''';
      final expected = '''<p>[foo] <a href="/url" title="title">bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 539', skip: kSkipKnownFailure, () {
      final markdown = '''[foo]
[bar]

[bar]: /url "title"''';
      final expected = '''<p>[foo]
<a href="/url" title="title">bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 540', () {
      final markdown = '''[foo]: /url1

[foo]: /url2

[bar][foo]''';
      final expected = '''<p><a href="/url1">bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 541', skip: kSkipKnownFailure, () {
      final markdown = '''[bar][foo\\!]

[foo!]: /url''';
      final expected = '''<p>[bar][foo!]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 542', () {
      final markdown = '''[foo][ref[]

[ref[]: /uri''';
      final expected = '''<p>[foo][ref[]</p>
<p>[ref[]: /uri</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 543', () {
      final markdown = '''[foo][ref[bar]]

[ref[bar]]: /uri''';
      final expected = '''<p>[foo][ref[bar]]</p>
<p>[ref[bar]]: /uri</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 544', () {
      final markdown = '''[[[foo]]]

[[[foo]]]: /url''';
      final expected = '''<p>[[[foo]]]</p>
<p>[[[foo]]]: /url</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 545', skip: kSkipKnownFailure, () {
      final markdown = '''[foo][ref\\[]

[ref\\[]: /uri''';
      final expected = '''<p><a href="/uri">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 546', () {
      final markdown = '''[bar\\\\]: /uri

[bar\\\\]''';
      final expected = '''<p><a href="/uri">bar\\</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 547', () {
      final markdown = '''[]

[]: /uri''';
      final expected = '''<p>[]</p>
<p>[]: /uri</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 548', () {
      final markdown = '''[
 ]

[
 ]: /uri''';
      final expected = '''<p>[
]</p>
<p>[
]: /uri</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 549', skip: kSkipKnownFailure, () {
      final markdown = '''[foo][]

[foo]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 550', skip: kSkipKnownFailure, () {
      final markdown = '''[*foo* bar][]

[*foo* bar]: /url "title"''';
      final expected =
          '''<p><a href="/url" title="title"><em>foo</em> bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 551', skip: kSkipKnownFailure, () {
      final markdown = '''[Foo][]

[foo]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">Foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 552',skip: kSkipKnownFailure, () {
      final markdown = '''[foo] 
[]

[foo]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">foo</a>
[]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 553', skip: kSkipKnownFailure, () {
      final markdown = '''[foo]

[foo]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 554', skip: kSkipKnownFailure, () {
      final markdown = '''[*foo* bar]

[*foo* bar]: /url "title"''';
      final expected =
          '''<p><a href="/url" title="title"><em>foo</em> bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 555', skip: kSkipKnownFailure, () {
      final markdown = '''[[*foo* bar]]

[*foo* bar]: /url "title"''';
      final expected =
          '''<p>[<a href="/url" title="title"><em>foo</em> bar</a>]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 556', skip: kSkipKnownFailure, () {
      final markdown = '''[[bar [foo]

[foo]: /url''';
      final expected = '''<p>[[bar <a href="/url">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 557', skip: kSkipKnownFailure, () {
      final markdown = '''[Foo]

[foo]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">Foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 558', skip: kSkipKnownFailure, () {
      final markdown = '''[foo] bar

[foo]: /url''';
      final expected = '''<p><a href="/url">foo</a> bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 559', skip: kSkipKnownFailure, () {
      final markdown = '''\\[foo]

[foo]: /url "title"''';
      final expected = '''<p>[foo]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 560', () {
      final markdown = '''[foo*]: /url

*[foo*]''';
      final expected = '''<p>*<a href="/url">foo*</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 561', skip: kSkipKnownFailure, () {
      final markdown = '''[foo][bar]

[foo]: /url1
[bar]: /url2''';
      final expected = '''<p><a href="/url2">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 562',skip: kSkipKnownFailure, () {
      final markdown = '''[foo][]

[foo]: /url1''';
      final expected = '''<p><a href="/url1">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 563', skip: kSkipKnownFailure, () {
      final markdown = '''[foo]()

[foo]: /url1''';
      final expected = '''<p><a href="">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 564',skip: kSkipKnownFailure,  () {
      final markdown = '''[foo](not a link)

[foo]: /url1''';
      final expected = '''<p><a href="/url1">foo</a>(not a link)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 565', skip: kSkipKnownFailure, () {
      final markdown = '''[foo][bar][baz]

[baz]: /url''';
      final expected = '''<p>[foo]<a href="/url">bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 566', skip: kSkipKnownFailure, () {
      final markdown = '''[foo][bar][baz]

[baz]: /url1
[bar]: /url2''';
      final expected =
          '''<p><a href="/url2">foo</a><a href="/url1">baz</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 567', skip: kSkipKnownFailure, () {
      final markdown = '''[foo][bar][baz]

[baz]: /url1
[foo]: /url2''';
      final expected = '''<p>[foo]<a href="/url1">bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 568', () {
      final markdown = '''![foo](/url "title")''';
      final expected = '''<p><img src="/url" alt="foo" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 569', skip: kSkipKnownFailure, () {
      final markdown = '''![foo *bar*]

[foo *bar*]: train.jpg "train & tracks"''';
      final expected =
          '''<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 570', () {
      final markdown = '''![foo ![bar](/url)](/url2)''';
      final expected = '''<p><img src="/url2" alt="foo bar" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 571', () {
      final markdown = '''![foo [bar](/url)](/url2)''';
      final expected = '''<p><img src="/url2" alt="foo bar" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 572',skip: kSkipKnownFailure, () {
      final markdown = '''![foo *bar*][]

[foo *bar*]: train.jpg "train & tracks"''';
      final expected =
          '''<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 573', skip: kSkipKnownFailure, () {
      final markdown = '''![foo *bar*][foobar]

[FOOBAR]: train.jpg "train & tracks"''';
      final expected =
          '''<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 574', () {
      final markdown = '''![foo](train.jpg)''';
      final expected = '''<p><img src="train.jpg" alt="foo" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 575', () {
      final markdown = '''My ![foo bar](/path/to/train.jpg  "title"   )''';
      final expected =
          '''<p>My <img src="/path/to/train.jpg" alt="foo bar" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 576', () {
      final markdown = '''![foo](<url>)''';
      final expected = '''<p><img src="url" alt="foo" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 577', () {
      final markdown = '''![](/url)''';
      final expected = '''<p><img src="/url" alt="" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 578', skip: kSkipKnownFailure, () {
      final markdown = '''![foo][bar]

[bar]: /url''';
      final expected = '''<p><img src="/url" alt="foo" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 579',skip: kSkipKnownFailure, () {
      final markdown = '''![foo][bar]

[BAR]: /url''';
      final expected = '''<p><img src="/url" alt="foo" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 580', skip: kSkipKnownFailure, () {
      final markdown = '''![foo][]

[foo]: /url "title"''';
      final expected = '''<p><img src="/url" alt="foo" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 581', skip: kSkipKnownFailure, () {
      final markdown = '''![*foo* bar][]

[*foo* bar]: /url "title"''';
      final expected =
          '''<p><img src="/url" alt="foo bar" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 582', skip: kSkipKnownFailure, () {
      final markdown = '''![Foo][]

[foo]: /url "title"''';
      final expected = '''<p><img src="/url" alt="Foo" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 583', skip: kSkipKnownFailure, () {
      final markdown = '''![foo] 
[]

[foo]: /url "title"''';
      final expected = '''<p><img src="/url" alt="foo" title="title" />
[]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 584', skip: kSkipKnownFailure, () {
      final markdown = '''![foo]

[foo]: /url "title"''';
      final expected = '''<p><img src="/url" alt="foo" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 585', skip: kSkipKnownFailure, () {
      final markdown = '''![*foo* bar]

[*foo* bar]: /url "title"''';
      final expected =
          '''<p><img src="/url" alt="foo bar" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 586', () {
      final markdown = '''![[foo]]

[[foo]]: /url "title"''';
      final expected = '''<p>![[foo]]</p>
<p>[[foo]]: /url &quot;title&quot;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 587', skip: kSkipKnownFailure, () {
      final markdown = '''![Foo]

[foo]: /url "title"''';
      final expected = '''<p><img src="/url" alt="Foo" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 588', skip: kSkipKnownFailure, () {
      final markdown = '''!\\[foo]

[foo]: /url "title"''';
      final expected = '''<p>![foo]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 589', skip: kSkipKnownFailure, () {
      final markdown = '''\\![foo]

[foo]: /url "title"''';
      final expected = '''<p>!<a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 590', () {
      final markdown = '''<http://foo.bar.baz>''';
      final expected =
          '''<p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 591', () {
      final markdown = '''<http://foo.bar.baz/test?q=hello&id=22&boolean>''';
      final expected =
          '''<p><a href="http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 592', () {
      final markdown = '''<irc://foo.bar:2233/baz>''';
      final expected =
          '''<p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 593', () {
      final markdown = '''<MAILTO:FOO@BAR.BAZ>''';
      final expected =
          '''<p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 594', () {
      final markdown = '''<a+b+c:d>''';
      final expected = '''<p><a href="a+b+c:d">a+b+c:d</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 595', () {
      final markdown = '''<made-up-scheme://foo,bar>''';
      final expected =
          '''<p><a href="made-up-scheme://foo,bar">made-up-scheme://foo,bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 596', () {
      final markdown = '''<http://../>''';
      final expected = '''<p><a href="http://../">http://../</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 597', () {
      final markdown = '''<localhost:5001/foo>''';
      final expected =
          '''<p><a href="localhost:5001/foo">localhost:5001/foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 598', () {
      final markdown = '''<http://foo.bar/baz bim>''';
      final expected = '''<p>&lt;http://foo.bar/baz bim&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 599', () {
      final markdown = '''<http://example.com/\\[\\>''';
      final expected =
          '''<p><a href="http://example.com/%5C%5B%5C">http://example.com/\\[\\</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 600', () {
      final markdown = '''<foo@bar.example.com>''';
      final expected =
          '''<p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 601', () {
      final markdown = '''<foo+special@Bar.baz-bar0.com>''';
      final expected =
          '''<p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 602', () {
      final markdown = '''<foo\\+@bar.example.com>''';
      final expected = '''<p>&lt;foo+@bar.example.com&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 603', () {
      final markdown = '''<>''';
      final expected = '''<p>&lt;&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 604', () {
      final markdown = '''< http://foo.bar >''';
      final expected = '''<p>&lt; http://foo.bar &gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 605', () {
      final markdown = '''<m:abc>''';
      final expected = '''<p>&lt;m:abc&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 606', () {
      final markdown = '''<foo.bar.baz>''';
      final expected = '''<p>&lt;foo.bar.baz&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 607', () {
      final markdown = '''http://example.com''';
      final expected = '''<p>http://example.com</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 608', () {
      final markdown = '''foo@bar.example.com''';
      final expected = '''<p>foo@bar.example.com</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 609', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<a><bab><c2c>''';
      final expected = '''<p><a><bab><c2c></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 610', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<a/><b2/>''';
      final expected = '''<p><a/><b2/></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 611', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<a  /><b2
data="foo" >''';
      final expected = '''<p><a  /><b2
data="foo" ></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 612',skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<a foo="bar" bam = \'baz <em>"</em>\'
_boolean zoop:33=zoop:33 />''';
      final expected = '''<p><a foo="bar" bam = \'baz <em>"</em>\'
_boolean zoop:33=zoop:33 /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 613', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''Foo <responsive-image src="foo.jpg" />''';
      final expected = '''<p>Foo <responsive-image src="foo.jpg" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 614', () {
      final markdown = '''<33> <__>''';
      final expected = '''<p>&lt;33&gt; &lt;__&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 615', () {
      final markdown = '''<a h*#ref="hi">''';
      final expected = '''<p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 616', () {
      final markdown = '''<a href="hi\'> <a href=hi\'>''';
      final expected =
          '''<p>&lt;a href=&quot;hi\'&gt; &lt;a href=hi\'&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 617', () {
      final markdown = '''< a><
foo><bar/ >
<foo bar=baz
bim!bop />''';
      final expected = '''<p>&lt; a&gt;&lt;
foo&gt;&lt;bar/ &gt;
&lt;foo bar=baz
bim!bop /&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 618', () {
      final markdown = '''<a href=\'bar\'title=title>''';
      final expected = '''<p>&lt;a href=\'bar\'title=title&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 619', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''</a></foo >''';
      final expected = '''<p></a></foo ></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 620', () {
      final markdown = '''</a href="foo">''';
      final expected = '''<p>&lt;/a href=&quot;foo&quot;&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 621', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''foo <!-- this is a --
comment - with hyphens -->''';
      final expected = '''<p>foo <!-- this is a --
comment - with hyphens --></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 622', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''foo <!--> foo -->

foo <!---> foo -->''';
      final expected = '''<p>foo <!--> foo --&gt;</p>
<p>foo <!---> foo --&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 623', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''foo <?php echo \$a; ?>''';
      final expected = '''<p>foo <?php echo \$a; ?></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 624', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''foo <!ELEMENT br EMPTY>''';
      final expected = '''<p>foo <!ELEMENT br EMPTY></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 625', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''foo <![CDATA[>&<]]>''';
      final expected = '''<p>foo <![CDATA[>&<]]></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 626', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''foo <a href="&ouml;">''';
      final expected = '''<p>foo <a href="&ouml;"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 627', skip: kSkipNongoal_MdNotToHtml, () {
      final markdown = '''foo <a href="\\*">''';
      final expected = '''<p>foo <a href="\\*"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 628', () {
      final markdown = '''<a href="\\"">''';
      final expected = '''<p>&lt;a href=&quot;&quot;&quot;&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 629', () {
      final markdown = '''foo  
baz''';
      final expected = '''<p>foo<br />
baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 630', () {
      final markdown = '''foo\\
baz''';
      final expected = '''<p>foo<br />
baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 631', () {
      final markdown = '''foo       
baz''';
      final expected = '''<p>foo<br />
baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 632', () {
      final markdown = '''foo  
     bar''';
      final expected = '''<p>foo<br />
bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 633', () {
      final markdown = '''foo\\
     bar''';
      final expected = '''<p>foo<br />
bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 634', () {
      final markdown = '''*foo  
bar*''';
      final expected = '''<p><em>foo<br />
bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 635', () {
      final markdown = '''*foo\\
bar*''';
      final expected = '''<p><em>foo<br />
bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 636', () {
      final markdown = '''`code  
span`''';
      final expected = '''<p><code>code   span</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 637', () {
      final markdown = '''`code\\
span`''';
      final expected = '''<p><code>code\\ span</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 638', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<a href="foo  
bar">''';
      final expected = '''<p><a href="foo  
bar"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 639', skip: kSkipNongoal_MdToHtml, () {
      final markdown = '''<a href="foo\\
bar">''';
      final expected = '''<p><a href="foo\\
bar"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 640', () {
      final markdown = '''foo\\''';
      final expected = '''<p>foo\\</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 641', () {
      final markdown = '''foo  ''';
      final expected = '''<p>foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 642', () {
      final markdown = '''### foo\\''';
      final expected = '''<h3>foo\\</h3>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 643', () {
      final markdown = '''### foo  ''';
      final expected = '''<h3>foo</h3>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Soft line breaks - Example 644', () {
      final markdown = '''foo
baz''';
      final expected = '''<p>foo
baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Soft line breaks - Example 645', () {
      final markdown = '''foo 
 baz''';
      final expected = '''<p>foo
baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Textual content - Example 646', () {
      final markdown = '''hello \$.;\'there''';
      final expected = '''<p>hello \$.;\'there</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Textual content - Example 647', () {
      final markdown = '''Foo χρῆν''';
      final expected = '''<p>Foo χρῆν</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Textual content - Example 648', () {
      final markdown = '''Multiple     spaces''';
      final expected = '''<p>Multiple     spaces</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });
  });
}
