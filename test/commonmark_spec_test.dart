import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

// Generated from cmark-gfm/test/spec.txt
// DO NOT EDIT - regenerate with tool/generate_spec_tests.dart

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

    test('Precedence - Example 1', () {
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

    test('Thematic breaks - Example 1', () {
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

    test('Thematic breaks - Example 2', () {
      final markdown = '''+++''';
      final expected = '''<p>+++</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 3', () {
      final markdown = '''===''';
      final expected = '''<p>===</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 4', () {
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

    test('Thematic breaks - Example 5', () {
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

    test('Thematic breaks - Example 6', () {
      final markdown = '''    ***''';
      final expected = '''<pre><code>***
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 7', () {
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

    test('Thematic breaks - Example 8', () {
      final markdown = '''_____________________________________''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 9', () {
      final markdown = ''' - - -''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 10', () {
      final markdown = ''' **  * ** * ** * **''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 11', () {
      final markdown = '''-     -      -      -''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 12', () {
      final markdown = '''- - - -    ''';
      final expected = '''<hr />''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 13', () {
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

    test('Thematic breaks - Example 14', () {
      final markdown = ''' *-*''';
      final expected = '''<p><em>-</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Thematic breaks - Example 15', () {
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

    test('Thematic breaks - Example 16', () {
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

    test('Thematic breaks - Example 17', () {
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

    test('Thematic breaks - Example 18', () {
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

    test('Thematic breaks - Example 19', () {
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

    test('ATX headings - Example 1', () {
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

    test('ATX headings - Example 2', () {
      final markdown = '''####### foo''';
      final expected = '''<p>####### foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 3', () {
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

    test('ATX headings - Example 4', () {
      final markdown = '''\\## foo''';
      final expected = '''<p>## foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 5', () {
      final markdown = '''# foo *bar* \\*baz\\*''';
      final expected = '''<h1>foo <em>bar</em> *baz*</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 6', () {
      final markdown = '''#                  foo                     ''';
      final expected = '''<h1>foo</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 7', () {
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

    test('ATX headings - Example 8', () {
      final markdown = '''    # foo''';
      final expected = '''<pre><code># foo
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 9', () {
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

    test('ATX headings - Example 10', () {
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

    test('ATX headings - Example 11', () {
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

    test('ATX headings - Example 12', () {
      final markdown = '''### foo ###     ''';
      final expected = '''<h3>foo</h3>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 13', () {
      final markdown = '''### foo ### b''';
      final expected = '''<h3>foo ### b</h3>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 14', () {
      final markdown = '''# foo#''';
      final expected = '''<h1>foo#</h1>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('ATX headings - Example 15', () {
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

    test('ATX headings - Example 16', () {
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

    test('ATX headings - Example 17', () {
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

    test('ATX headings - Example 18', () {
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

    test('Setext headings - Example 1', () {
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

    test('Setext headings - Example 2', () {
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

    test('Setext headings - Example 3', () {
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

    test('Setext headings - Example 4', () {
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

    test('Setext headings - Example 5', () {
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

    test('Setext headings - Example 6', () {
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

    test('Setext headings - Example 7', () {
      final markdown = '''Foo
   ----      ''';
      final expected = '''<h2>Foo</h2>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 8', () {
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

    test('Setext headings - Example 9', () {
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

    test('Setext headings - Example 10', () {
      final markdown = '''Foo  
-----''';
      final expected = '''<h2>Foo</h2>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 11', () {
      final markdown = '''Foo\\
----''';
      final expected = '''<h2>Foo\\</h2>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 12', () {
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

    test('Setext headings - Example 13', () {
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

    test('Setext headings - Example 14', () {
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

    test('Setext headings - Example 15', () {
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

    test('Setext headings - Example 16', () {
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

    test('Setext headings - Example 17', () {
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

    test('Setext headings - Example 18', () {
      final markdown = '''
====''';
      final expected = '''<p>====</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 19', () {
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

    test('Setext headings - Example 20', () {
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

    test('Setext headings - Example 21', () {
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

    test('Setext headings - Example 22', () {
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

    test('Setext headings - Example 23', () {
      final markdown = '''\\> foo
------''';
      final expected = '''<h2>&gt; foo</h2>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Setext headings - Example 24', () {
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

    test('Setext headings - Example 25', () {
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

    test('Setext headings - Example 26', () {
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

    test('Setext headings - Example 27', () {
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

    test('Indented code blocks - Example 1', () {
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

    test('Indented code blocks - Example 2', () {
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

    test('Indented code blocks - Example 3', () {
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

    test('Indented code blocks - Example 4', () {
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

    test('Indented code blocks - Example 5', () {
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

    test('Indented code blocks - Example 6', () {
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

    test('Indented code blocks - Example 7', () {
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

    test('Indented code blocks - Example 8', () {
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

    test('Indented code blocks - Example 9', () {
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

    test('Indented code blocks - Example 10', () {
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

    test('Indented code blocks - Example 11', () {
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

    test('Indented code blocks - Example 12', () {
      final markdown = '''    foo  ''';
      final expected = '''<pre><code>foo  
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 1', () {
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

    test('Fenced code blocks - Example 2', () {
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

    test('Fenced code blocks - Example 3', () {
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

    test('Fenced code blocks - Example 4', () {
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

    test('Fenced code blocks - Example 5', () {
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

    test('Fenced code blocks - Example 6', () {
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

    test('Fenced code blocks - Example 7', () {
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

    test('Fenced code blocks - Example 8', () {
      final markdown = '''```''';
      final expected = '''<pre><code></code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 9', () {
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

    test('Fenced code blocks - Example 10', () {
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

    test('Fenced code blocks - Example 11', () {
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

    test('Fenced code blocks - Example 12', () {
      final markdown = '''```
```''';
      final expected = '''<pre><code></code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 13', () {
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

    test('Fenced code blocks - Example 14', () {
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

    test('Fenced code blocks - Example 15', () {
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

    test('Fenced code blocks - Example 16', () {
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

    test('Fenced code blocks - Example 17', () {
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

    test('Fenced code blocks - Example 18', () {
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

    test('Fenced code blocks - Example 19', () {
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

    test('Fenced code blocks - Example 20', () {
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

    test('Fenced code blocks - Example 21', () {
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

    test('Fenced code blocks - Example 22', () {
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

    test('Fenced code blocks - Example 23', () {
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

    test('Fenced code blocks - Example 24', () {
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

    test('Fenced code blocks - Example 25', () {
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

    test('Fenced code blocks - Example 26', () {
      final markdown = '''````;
````''';
      final expected = '''<pre><code class="language-;"></code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Fenced code blocks - Example 27', () {
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

    test('Fenced code blocks - Example 28', () {
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

    test('Fenced code blocks - Example 29', () {
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

    test('HTML blocks - Example 1', () {
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

    test('HTML blocks - Example 2', () {
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

    test('HTML blocks - Example 3', () {
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

    test('HTML blocks - Example 4', () {
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

    test('HTML blocks - Example 5', () {
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

    test('HTML blocks - Example 6', () {
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

    test('HTML blocks - Example 7', () {
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

    test('HTML blocks - Example 8', () {
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

    test('HTML blocks - Example 9', () {
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

    test('HTML blocks - Example 10', () {
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

    test('HTML blocks - Example 11', () {
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

    test('HTML blocks - Example 12', () {
      final markdown = '''<div><a href="bar">*foo*</a></div>''';
      final expected = '''<div><a href="bar">*foo*</a></div>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 13', () {
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

    test('HTML blocks - Example 14', () {
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

    test('HTML blocks - Example 15', () {
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

    test('HTML blocks - Example 16', () {
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

    test('HTML blocks - Example 17', () {
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

    test('HTML blocks - Example 18', () {
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

    test('HTML blocks - Example 19', () {
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

    test('HTML blocks - Example 20', () {
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

    test('HTML blocks - Example 21', () {
      final markdown = '''<del>*foo*</del>''';
      final expected = '''<p><del><em>foo</em></del></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 22', () {
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

    test('HTML blocks - Example 23', () {
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

    test('HTML blocks - Example 24', () {
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

    test('HTML blocks - Example 25', () {
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

    test('HTML blocks - Example 26', () {
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

    test('HTML blocks - Example 27', () {
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

    test('HTML blocks - Example 28', () {
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

    test('HTML blocks - Example 29', () {
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

    test('HTML blocks - Example 30', () {
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

    test('HTML blocks - Example 31', () {
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

    test('HTML blocks - Example 32', () {
      final markdown = '''<?php

  echo '>';

?>
okay''';
      final expected = '''<?php

  echo '>';

?>
<p>okay</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 33', () {
      final markdown = '''<!DOCTYPE html>''';
      final expected = '''<!DOCTYPE html>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('HTML blocks - Example 34', () {
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

    test('HTML blocks - Example 35', () {
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

    test('HTML blocks - Example 36', () {
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

    test('HTML blocks - Example 37', () {
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

    test('HTML blocks - Example 38', () {
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

    test('HTML blocks - Example 39', () {
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

    test('HTML blocks - Example 40', () {
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

    test('HTML blocks - Example 41', () {
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

    test('HTML blocks - Example 42', () {
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

    test('HTML blocks - Example 43', () {
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

    test('Link reference definitions - Example 1', () {
      final markdown = '''[foo]: /url "title"

[foo]''';
      final expected = '''<p><a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 2', () {
      final markdown = '''   [foo]: 
      /url  
           'the title'  

[foo]''';
      final expected = '''<p><a href="/url" title="the title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 3', () {
      final markdown = '''[Foo*bar\\]]:my_(url) 'title (with parens)'

[Foo*bar\\]]''';
      final expected = '''<p><a href="my_(url)" title="title (with parens)">Foo*bar]</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 4', () {
      final markdown = '''[Foo bar]:
<my url>
'title'

[Foo bar]''';
      final expected = '''<p><a href="my%20url" title="title">Foo bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 5', () {
      final markdown = '''[foo]: /url '
title
line1
line2
'

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

    test('Link reference definitions - Example 6', () {
      final markdown = '''[foo]: /url 'title

with blank line'

[foo]''';
      final expected = '''<p>[foo]: /url 'title</p>
<p>with blank line'</p>
<p>[foo]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 7', () {
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

    test('Link reference definitions - Example 8', () {
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

    test('Link reference definitions - Example 9', () {
      final markdown = '''[foo]: <>

[foo]''';
      final expected = '''<p><a href="">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 10', () {
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

    test('Link reference definitions - Example 11', () {
      final markdown = '''[foo]: /url\\bar\\*baz "foo\\"bar\\baz"

[foo]''';
      final expected = '''<p><a href="/url%5Cbar*baz" title="foo&quot;bar\\baz">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 12', () {
      final markdown = '''[foo]

[foo]: url''';
      final expected = '''<p><a href="url">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 13', () {
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

    test('Link reference definitions - Example 14', () {
      final markdown = '''[FOO]: /url

[Foo]''';
      final expected = '''<p><a href="/url">Foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 15', () {
      final markdown = '''[ΑΓΩ]: /φου

[αγω]''';
      final expected = '''<p><a href="/%CF%86%CE%BF%CF%85">αγω</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 16', () {
      final markdown = '''[foo]: /url''';
      final expected = '''''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 17', () {
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

    test('Link reference definitions - Example 18', () {
      final markdown = '''[foo]: /url "title" ok''';
      final expected = '''<p>[foo]: /url &quot;title&quot; ok</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 19', () {
      final markdown = '''[foo]: /url
"title" ok''';
      final expected = '''<p>&quot;title&quot; ok</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Link reference definitions - Example 20', () {
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

    test('Link reference definitions - Example 21', () {
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

    test('Link reference definitions - Example 22', () {
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

    test('Link reference definitions - Example 23', () {
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

    test('Link reference definitions - Example 24', () {
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

    test('Link reference definitions - Example 25', () {
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

    test('Link reference definitions - Example 26', () {
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

    test('Link reference definitions - Example 27', () {
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

    test('Link reference definitions - Example 28', () {
      final markdown = '''[foo]: /url''';
      final expected = '''''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Paragraphs - Example 1', () {
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

    test('Paragraphs - Example 2', () {
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

    test('Paragraphs - Example 3', () {
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

    test('Paragraphs - Example 4', () {
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

    test('Paragraphs - Example 5', () {
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

    test('Paragraphs - Example 6', () {
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

    test('Paragraphs - Example 7', () {
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

    test('Paragraphs - Example 8', () {
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

    test('Blank lines - Example 1', () {
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

    test('Block quotes - Example 1', () {
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

    test('Block quotes - Example 2', () {
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

    test('Block quotes - Example 3', () {
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

    test('Block quotes - Example 4', () {
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

    test('Block quotes - Example 5', () {
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

    test('Block quotes - Example 6', () {
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

    test('Block quotes - Example 7', () {
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

    test('Block quotes - Example 8', () {
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

    test('Block quotes - Example 9', () {
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

    test('Block quotes - Example 10', () {
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

    test('Block quotes - Example 11', () {
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

    test('Block quotes - Example 12', () {
      final markdown = '''>''';
      final expected = '''<blockquote>
</blockquote>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Block quotes - Example 13', () {
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

    test('Block quotes - Example 14', () {
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

    test('Block quotes - Example 15', () {
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

    test('Block quotes - Example 16', () {
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

    test('Block quotes - Example 17', () {
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

    test('Block quotes - Example 18', () {
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

    test('Block quotes - Example 19', () {
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

    test('Block quotes - Example 20', () {
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

    test('Block quotes - Example 21', () {
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

    test('Block quotes - Example 22', () {
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

    test('Block quotes - Example 23', () {
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

    test('Block quotes - Example 24', () {
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

    test('Block quotes - Example 25', () {
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

    test('List items - Example 1', () {
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

    test('List items - Example 2', () {
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

    test('List items - Example 3', () {
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

    test('List items - Example 4', () {
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

    test('List items - Example 5', () {
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

    test('List items - Example 6', () {
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

    test('List items - Example 7', () {
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

    test('List items - Example 8', () {
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

    test('List items - Example 9', () {
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

    test('List items - Example 10', () {
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

    test('List items - Example 11', () {
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

    test('List items - Example 12', () {
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

    test('List items - Example 13', () {
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

    test('List items - Example 14', () {
      final markdown = '''1234567890. not ok''';
      final expected = '''<p>1234567890. not ok</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 15', () {
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

    test('List items - Example 16', () {
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

    test('List items - Example 17', () {
      final markdown = '''-1. not ok''';
      final expected = '''<p>-1. not ok</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('List items - Example 18', () {
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

    test('List items - Example 19', () {
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

    test('List items - Example 20', () {
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

    test('List items - Example 21', () {
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

    test('List items - Example 22', () {
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

    test('List items - Example 23', () {
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

    test('List items - Example 24', () {
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

    test('List items - Example 25', () {
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

    test('List items - Example 26', () {
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

    test('List items - Example 27', () {
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

    test('List items - Example 28', () {
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

    test('List items - Example 29', () {
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

    test('List items - Example 30', () {
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

    test('List items - Example 31', () {
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

    test('List items - Example 32', () {
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

    test('List items - Example 33', () {
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

    test('List items - Example 34', () {
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

    test('List items - Example 35', () {
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

    test('List items - Example 36', () {
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

    test('List items - Example 37', () {
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

    test('List items - Example 38', () {
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

    test('List items - Example 39', () {
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

    test('List items - Example 40', () {
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

    test('List items - Example 41', () {
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

    test('List items - Example 42', () {
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

    test('List items - Example 43', () {
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

    test('List items - Example 44', () {
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

    test('List items - Example 45', () {
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

    test('List items - Example 46', () {
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

    test('List items - Example 47', () {
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

    test('List items - Example 48', () {
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

    test('Lists - Example 1', () {
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

    test('Lists - Example 2', () {
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

    test('Lists - Example 3', () {
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

    test('Lists - Example 4', () {
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

    test('Lists - Example 5', () {
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

    test('Lists - Example 6', () {
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

    test('Lists - Example 7', () {
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

    test('Lists - Example 8', () {
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

    test('Lists - Example 9', () {
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

    test('Lists - Example 10', () {
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

    test('Lists - Example 11', () {
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

    test('Lists - Example 12', () {
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

    test('Lists - Example 13', () {
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

    test('Lists - Example 14', () {
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

    test('Lists - Example 15', () {
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

    test('Lists - Example 16', () {
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

    test('Lists - Example 17', () {
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

    test('Lists - Example 18', () {
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

    test('Lists - Example 19', () {
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

    test('Lists - Example 20', () {
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

    test('Lists - Example 21', () {
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

    test('Lists - Example 22', () {
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

    test('Lists - Example 23', () {
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

    test('Lists - Example 24', () {
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

    test('Lists - Example 25', () {
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

    test('Lists - Example 26', () {
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

    test('Lists - Example 27', () {
      final markdown = '''`hi`lo`''';
      final expected = '''<p><code>hi</code>lo`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 1', () {
      final markdown = '''\\!\\"\\#\\\$\\%\\&\\'\\(\\)\\*\\+\\,\\-\\.\\/\\:\\;\\<\\=\\>\\?\\@\\[\\\\\\]\\^\\_\\`\\{\\|\\}\\~''';
      final expected = '''<p>!&quot;#\$%&amp;'()*+,-./:;&lt;=&gt;?@[\\]^_`{|}~</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 2', () {
      final markdown = '''\\	\\A\\a\\ \\3\\φ\\«''';
      final expected = '''<p>\\	\\A\\a\\ \\3\\φ\\«</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 3', () {
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

    test('Backslash escapes - Example 4', () {
      final markdown = '''\\\\*emphasis*''';
      final expected = '''<p>\\<em>emphasis</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 5', () {
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

    test('Backslash escapes - Example 6', () {
      final markdown = '''`` \\[\\` ``''';
      final expected = '''<p><code>\\[\\`</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 7', () {
      final markdown = '''    \\[\\]''';
      final expected = '''<pre><code>\\[\\]
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 8', () {
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

    test('Backslash escapes - Example 9', () {
      final markdown = '''<http://example.com?find=\\*>''';
      final expected = '''<p><a href="http://example.com?find=%5C*">http://example.com?find=\\*</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 10', () {
      final markdown = '''<a href="/bar\\/)">''';
      final expected = '''<a href="/bar\\/)">''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 11', () {
      final markdown = '''[foo](/bar\\* "ti\\*tle")''';
      final expected = '''<p><a href="/bar*" title="ti*tle">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 12', () {
      final markdown = '''[foo]

[foo]: /bar\\* "ti\\*tle"''';
      final expected = '''<p><a href="/bar*" title="ti*tle">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Backslash escapes - Example 13', () {
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

    test('Entity and numeric character references - Example 1', () {
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

    test('Entity and numeric character references - Example 2', () {
      final markdown = '''&#35; &#1234; &#992; &#0;''';
      final expected = '''<p># Ӓ Ϡ �</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 3', () {
      final markdown = '''&#X22; &#XD06; &#xcab;''';
      final expected = '''<p>&quot; ആ ಫ</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 4', () {
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

    test('Entity and numeric character references - Example 5', () {
      final markdown = '''&copy''';
      final expected = '''<p>&amp;copy</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 6', () {
      final markdown = '''&MadeUpEntity;''';
      final expected = '''<p>&amp;MadeUpEntity;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 7', () {
      final markdown = '''<a href="&ouml;&ouml;.html">''';
      final expected = '''<a href="&ouml;&ouml;.html">''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 8', () {
      final markdown = '''[foo](/f&ouml;&ouml; "f&ouml;&ouml;")''';
      final expected = '''<p><a href="/f%C3%B6%C3%B6" title="föö">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 9', () {
      final markdown = '''[foo]

[foo]: /f&ouml;&ouml; "f&ouml;&ouml;"''';
      final expected = '''<p><a href="/f%C3%B6%C3%B6" title="föö">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 10', () {
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

    test('Entity and numeric character references - Example 11', () {
      final markdown = '''`f&ouml;&ouml;`''';
      final expected = '''<p><code>f&amp;ouml;&amp;ouml;</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 12', () {
      final markdown = '''    f&ouml;f&ouml;''';
      final expected = '''<pre><code>f&amp;ouml;f&amp;ouml;
</code></pre>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 13', () {
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

    test('Entity and numeric character references - Example 14', () {
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

    test('Entity and numeric character references - Example 15', () {
      final markdown = '''foo&#10;&#10;bar''';
      final expected = '''<p>foo

bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 16', () {
      final markdown = '''&#9;foo''';
      final expected = '''<p>	foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Entity and numeric character references - Example 17', () {
      final markdown = '''[a](url &quot;tit&quot;)''';
      final expected = '''<p>[a](url &quot;tit&quot;)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 1', () {
      final markdown = '''`foo`''';
      final expected = '''<p><code>foo</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 2', () {
      final markdown = '''`` foo ` bar ``''';
      final expected = '''<p><code>foo ` bar</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 3', () {
      final markdown = '''` `` `''';
      final expected = '''<p><code>``</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 4', () {
      final markdown = '''`  ``  `''';
      final expected = '''<p><code> `` </code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 5', () {
      final markdown = '''` a`''';
      final expected = '''<p><code> a</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 6', () {
      final markdown = '''` b `''';
      final expected = '''<p><code> b </code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 7', () {
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

    test('Code spans - Example 8', () {
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

    test('Code spans - Example 9', () {
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

    test('Code spans - Example 10', () {
      final markdown = '''`foo   bar 
baz`''';
      final expected = '''<p><code>foo   bar  baz</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 11', () {
      final markdown = '''`foo\\`bar`''';
      final expected = '''<p><code>foo\\</code>bar`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 12', () {
      final markdown = '''``foo`bar``''';
      final expected = '''<p><code>foo`bar</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 13', () {
      final markdown = '''` foo `` bar `''';
      final expected = '''<p><code>foo `` bar</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 14', () {
      final markdown = '''*foo`*`''';
      final expected = '''<p>*foo<code>*</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 15', () {
      final markdown = '''[not a `link](/foo`)''';
      final expected = '''<p>[not a <code>link](/foo</code>)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 16', () {
      final markdown = '''`<a href="`">`''';
      final expected = '''<p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 17', () {
      final markdown = '''<a href="`">`''';
      final expected = '''<p><a href="`">`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 18', () {
      final markdown = '''`<http://foo.bar.`baz>`''';
      final expected = '''<p><code>&lt;http://foo.bar.</code>baz&gt;`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 19', () {
      final markdown = '''<http://foo.bar.`baz>`''';
      final expected = '''<p><a href="http://foo.bar.%60baz">http://foo.bar.`baz</a>`</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 20', () {
      final markdown = '''```foo``''';
      final expected = '''<p>```foo``</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 21', () {
      final markdown = '''`foo''';
      final expected = '''<p>`foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Code spans - Example 22', () {
      final markdown = '''`foo``bar``''';
      final expected = '''<p>`foo<code>bar</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 1', () {
      final markdown = '''*foo bar*''';
      final expected = '''<p><em>foo bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 2', () {
      final markdown = '''a * foo bar*''';
      final expected = '''<p>a * foo bar*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 3', () {
      final markdown = '''a*"foo"*''';
      final expected = '''<p>a*&quot;foo&quot;*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 4', () {
      final markdown = '''* a *''';
      final expected = '''<p>* a *</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 5', () {
      final markdown = '''foo*bar*''';
      final expected = '''<p>foo<em>bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 6', () {
      final markdown = '''5*6*78''';
      final expected = '''<p>5<em>6</em>78</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 7', () {
      final markdown = '''_foo bar_''';
      final expected = '''<p><em>foo bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 8', () {
      final markdown = '''_ foo bar_''';
      final expected = '''<p>_ foo bar_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 9', () {
      final markdown = '''a_"foo"_''';
      final expected = '''<p>a_&quot;foo&quot;_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 10', () {
      final markdown = '''foo_bar_''';
      final expected = '''<p>foo_bar_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 11', () {
      final markdown = '''5_6_78''';
      final expected = '''<p>5_6_78</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 12', () {
      final markdown = '''пристаням_стремятся_''';
      final expected = '''<p>пристаням_стремятся_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 13', () {
      final markdown = '''aa_"bb"_cc''';
      final expected = '''<p>aa_&quot;bb&quot;_cc</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 14', () {
      final markdown = '''foo-_(bar)_''';
      final expected = '''<p>foo-<em>(bar)</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 15', () {
      final markdown = '''_foo*''';
      final expected = '''<p>_foo*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 16', () {
      final markdown = '''*foo bar *''';
      final expected = '''<p>*foo bar *</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 17', () {
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

    test('Emphasis and strong emphasis - Example 18', () {
      final markdown = '''*(*foo)''';
      final expected = '''<p>*(*foo)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 19', () {
      final markdown = '''*(*foo*)*''';
      final expected = '''<p><em>(<em>foo</em>)</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 20', () {
      final markdown = '''*foo*bar''';
      final expected = '''<p><em>foo</em>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 21', () {
      final markdown = '''_foo bar _''';
      final expected = '''<p>_foo bar _</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 22', () {
      final markdown = '''_(_foo)''';
      final expected = '''<p>_(_foo)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 23', () {
      final markdown = '''_(_foo_)_''';
      final expected = '''<p><em>(<em>foo</em>)</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 24', () {
      final markdown = '''_foo_bar''';
      final expected = '''<p>_foo_bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 25', () {
      final markdown = '''_пристаням_стремятся''';
      final expected = '''<p>_пристаням_стремятся</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 26', () {
      final markdown = '''_foo_bar_baz_''';
      final expected = '''<p><em>foo_bar_baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 27', () {
      final markdown = '''_(bar)_.''';
      final expected = '''<p><em>(bar)</em>.</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 28', () {
      final markdown = '''**foo bar**''';
      final expected = '''<p><strong>foo bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 29', () {
      final markdown = '''** foo bar**''';
      final expected = '''<p>** foo bar**</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 30', () {
      final markdown = '''a**"foo"**''';
      final expected = '''<p>a**&quot;foo&quot;**</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 31', () {
      final markdown = '''foo**bar**''';
      final expected = '''<p>foo<strong>bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 32', () {
      final markdown = '''__foo bar__''';
      final expected = '''<p><strong>foo bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 33', () {
      final markdown = '''__ foo bar__''';
      final expected = '''<p>__ foo bar__</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 34', () {
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

    test('Emphasis and strong emphasis - Example 35', () {
      final markdown = '''a__"foo"__''';
      final expected = '''<p>a__&quot;foo&quot;__</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 36', () {
      final markdown = '''foo__bar__''';
      final expected = '''<p>foo__bar__</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 37', () {
      final markdown = '''5__6__78''';
      final expected = '''<p>5__6__78</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 38', () {
      final markdown = '''пристаням__стремятся__''';
      final expected = '''<p>пристаням__стремятся__</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 39', () {
      final markdown = '''__foo, __bar__, baz__''';
      final expected = '''<p><strong>foo, bar, baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 40', () {
      final markdown = '''foo-__(bar)__''';
      final expected = '''<p>foo-<strong>(bar)</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 41', () {
      final markdown = '''**foo bar **''';
      final expected = '''<p>**foo bar **</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 42', () {
      final markdown = '''**(**foo)''';
      final expected = '''<p>**(**foo)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 43', () {
      final markdown = '''*(**foo**)*''';
      final expected = '''<p><em>(<strong>foo</strong>)</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 44', () {
      final markdown = '''**Gomphocarpus (*Gomphocarpus physocarpus*, syn.
*Asclepias physocarpa*)**''';
      final expected = '''<p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.
<em>Asclepias physocarpa</em>)</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 45', () {
      final markdown = '''**foo "*bar*" foo**''';
      final expected = '''<p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 46', () {
      final markdown = '''**foo**bar''';
      final expected = '''<p><strong>foo</strong>bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 47', () {
      final markdown = '''__foo bar __''';
      final expected = '''<p>__foo bar __</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 48', () {
      final markdown = '''__(__foo)''';
      final expected = '''<p>__(__foo)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 49', () {
      final markdown = '''_(__foo__)_''';
      final expected = '''<p><em>(<strong>foo</strong>)</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 50', () {
      final markdown = '''__foo__bar''';
      final expected = '''<p>__foo__bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 51', () {
      final markdown = '''__пристаням__стремятся''';
      final expected = '''<p>__пристаням__стремятся</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 52', () {
      final markdown = '''__foo__bar__baz__''';
      final expected = '''<p><strong>foo__bar__baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 53', () {
      final markdown = '''__(bar)__.''';
      final expected = '''<p><strong>(bar)</strong>.</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 54', () {
      final markdown = '''*foo [bar](/url)*''';
      final expected = '''<p><em>foo <a href="/url">bar</a></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 55', () {
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

    test('Emphasis and strong emphasis - Example 56', () {
      final markdown = '''_foo __bar__ baz_''';
      final expected = '''<p><em>foo <strong>bar</strong> baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 57', () {
      final markdown = '''_foo _bar_ baz_''';
      final expected = '''<p><em>foo <em>bar</em> baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 58', () {
      final markdown = '''__foo_ bar_''';
      final expected = '''<p><em><em>foo</em> bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 59', () {
      final markdown = '''*foo *bar**''';
      final expected = '''<p><em>foo <em>bar</em></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 60', () {
      final markdown = '''*foo **bar** baz*''';
      final expected = '''<p><em>foo <strong>bar</strong> baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 61', () {
      final markdown = '''*foo**bar**baz*''';
      final expected = '''<p><em>foo<strong>bar</strong>baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 62', () {
      final markdown = '''*foo**bar*''';
      final expected = '''<p><em>foo**bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 63', () {
      final markdown = '''***foo** bar*''';
      final expected = '''<p><em><strong>foo</strong> bar</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 64', () {
      final markdown = '''*foo **bar***''';
      final expected = '''<p><em>foo <strong>bar</strong></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 65', () {
      final markdown = '''*foo**bar***''';
      final expected = '''<p><em>foo<strong>bar</strong></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 66', () {
      final markdown = '''foo***bar***baz''';
      final expected = '''<p>foo<em><strong>bar</strong></em>baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 67', () {
      final markdown = '''foo******bar*********baz''';
      final expected = '''<p>foo<strong>bar</strong>***baz</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 68', () {
      final markdown = '''*foo **bar *baz* bim** bop*''';
      final expected = '''<p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 69', () {
      final markdown = '''*foo [*bar*](/url)*''';
      final expected = '''<p><em>foo <a href="/url"><em>bar</em></a></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 70', () {
      final markdown = '''** is not an empty emphasis''';
      final expected = '''<p>** is not an empty emphasis</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 71', () {
      final markdown = '''**** is not an empty strong emphasis''';
      final expected = '''<p>**** is not an empty strong emphasis</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 72', () {
      final markdown = '''**foo [bar](/url)**''';
      final expected = '''<p><strong>foo <a href="/url">bar</a></strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 73', () {
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

    test('Emphasis and strong emphasis - Example 74', () {
      final markdown = '''__foo _bar_ baz__''';
      final expected = '''<p><strong>foo <em>bar</em> baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 75', () {
      final markdown = '''__foo __bar__ baz__''';
      final expected = '''<p><strong>foo bar baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 76', () {
      final markdown = '''____foo__ bar__''';
      final expected = '''<p><strong>foo bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 77', () {
      final markdown = '''**foo **bar****''';
      final expected = '''<p><strong>foo bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 78', () {
      final markdown = '''**foo *bar* baz**''';
      final expected = '''<p><strong>foo <em>bar</em> baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 79', () {
      final markdown = '''**foo*bar*baz**''';
      final expected = '''<p><strong>foo<em>bar</em>baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 80', () {
      final markdown = '''***foo* bar**''';
      final expected = '''<p><strong><em>foo</em> bar</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 81', () {
      final markdown = '''**foo *bar***''';
      final expected = '''<p><strong>foo <em>bar</em></strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 82', () {
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

    test('Emphasis and strong emphasis - Example 83', () {
      final markdown = '''**foo [*bar*](/url)**''';
      final expected = '''<p><strong>foo <a href="/url"><em>bar</em></a></strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 84', () {
      final markdown = '''__ is not an empty emphasis''';
      final expected = '''<p>__ is not an empty emphasis</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 85', () {
      final markdown = '''____ is not an empty strong emphasis''';
      final expected = '''<p>____ is not an empty strong emphasis</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 86', () {
      final markdown = '''foo ***''';
      final expected = '''<p>foo ***</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 87', () {
      final markdown = '''foo *\\**''';
      final expected = '''<p>foo <em>*</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 88', () {
      final markdown = '''foo *_*''';
      final expected = '''<p>foo <em>_</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 89', () {
      final markdown = '''foo *****''';
      final expected = '''<p>foo *****</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 90', () {
      final markdown = '''foo **\\***''';
      final expected = '''<p>foo <strong>*</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 91', () {
      final markdown = '''foo **_**''';
      final expected = '''<p>foo <strong>_</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 92', () {
      final markdown = '''**foo*''';
      final expected = '''<p>*<em>foo</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 93', () {
      final markdown = '''*foo**''';
      final expected = '''<p><em>foo</em>*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 94', () {
      final markdown = '''***foo**''';
      final expected = '''<p>*<strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 95', () {
      final markdown = '''****foo*''';
      final expected = '''<p>***<em>foo</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 96', () {
      final markdown = '''**foo***''';
      final expected = '''<p><strong>foo</strong>*</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 97', () {
      final markdown = '''*foo****''';
      final expected = '''<p><em>foo</em>***</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 98', () {
      final markdown = '''foo ___''';
      final expected = '''<p>foo ___</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 99', () {
      final markdown = '''foo _\\__''';
      final expected = '''<p>foo <em>_</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 100', () {
      final markdown = '''foo _*_''';
      final expected = '''<p>foo <em>*</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 101', () {
      final markdown = '''foo _____''';
      final expected = '''<p>foo _____</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 102', () {
      final markdown = '''foo __\\___''';
      final expected = '''<p>foo <strong>_</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 103', () {
      final markdown = '''foo __*__''';
      final expected = '''<p>foo <strong>*</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 104', () {
      final markdown = '''__foo_''';
      final expected = '''<p>_<em>foo</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 105', () {
      final markdown = '''_foo__''';
      final expected = '''<p><em>foo</em>_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 106', () {
      final markdown = '''___foo__''';
      final expected = '''<p>_<strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 107', () {
      final markdown = '''____foo_''';
      final expected = '''<p>___<em>foo</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 108', () {
      final markdown = '''__foo___''';
      final expected = '''<p><strong>foo</strong>_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 109', () {
      final markdown = '''_foo____''';
      final expected = '''<p><em>foo</em>___</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 110', () {
      final markdown = '''**foo**''';
      final expected = '''<p><strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 111', () {
      final markdown = '''*_foo_*''';
      final expected = '''<p><em><em>foo</em></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 112', () {
      final markdown = '''__foo__''';
      final expected = '''<p><strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 113', () {
      final markdown = '''_*foo*_''';
      final expected = '''<p><em><em>foo</em></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 114', () {
      final markdown = '''****foo****''';
      final expected = '''<p><strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 115', () {
      final markdown = '''____foo____''';
      final expected = '''<p><strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 116', () {
      final markdown = '''******foo******''';
      final expected = '''<p><strong>foo</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 117', () {
      final markdown = '''***foo***''';
      final expected = '''<p><em><strong>foo</strong></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 118', () {
      final markdown = '''_____foo_____''';
      final expected = '''<p><em><strong>foo</strong></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 119', () {
      final markdown = '''*foo _bar* baz_''';
      final expected = '''<p><em>foo _bar</em> baz_</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 120', () {
      final markdown = '''*foo __bar *baz bim__ bam*''';
      final expected = '''<p><em>foo <strong>bar *baz bim</strong> bam</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 121', () {
      final markdown = '''**foo **bar baz**''';
      final expected = '''<p>**foo <strong>bar baz</strong></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 122', () {
      final markdown = '''*foo *bar baz*''';
      final expected = '''<p>*foo <em>bar baz</em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 123', () {
      final markdown = '''*[bar*](/url)''';
      final expected = '''<p>*<a href="/url">bar*</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 124', () {
      final markdown = '''_foo [bar_](/url)''';
      final expected = '''<p>_foo <a href="/url">bar_</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 125', () {
      final markdown = '''*<img src="foo" title="*"/>''';
      final expected = '''<p>*<img src="foo" title="*"/></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 126', () {
      final markdown = '''**<a href="**">''';
      final expected = '''<p>**<a href="**"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 127', () {
      final markdown = '''__<a href="__">''';
      final expected = '''<p>__<a href="__"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 128', () {
      final markdown = '''*a `*`*''';
      final expected = '''<p><em>a <code>*</code></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 129', () {
      final markdown = '''_a `_`_''';
      final expected = '''<p><em>a <code>_</code></em></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 130', () {
      final markdown = '''**a<http://foo.bar/?q=**>''';
      final expected = '''<p>**a<a href="http://foo.bar/?q=**">http://foo.bar/?q=**</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Emphasis and strong emphasis - Example 131', () {
      final markdown = '''__a<http://foo.bar/?q=__>''';
      final expected = '''<p>__a<a href="http://foo.bar/?q=__">http://foo.bar/?q=__</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 1', () {
      final markdown = '''[link](/uri "title")''';
      final expected = '''<p><a href="/uri" title="title">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 2', () {
      final markdown = '''[link](/uri)''';
      final expected = '''<p><a href="/uri">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 3', () {
      final markdown = '''[link]()''';
      final expected = '''<p><a href="">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 4', () {
      final markdown = '''[link](<>)''';
      final expected = '''<p><a href="">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 5', () {
      final markdown = '''[link](/my uri)''';
      final expected = '''<p>[link](/my uri)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 6', () {
      final markdown = '''[link](</my uri>)''';
      final expected = '''<p><a href="/my%20uri">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 7', () {
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

    test('Links - Example 8', () {
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

    test('Links - Example 9', () {
      final markdown = '''[a](<b)c>)''';
      final expected = '''<p><a href="b)c">a</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 10', () {
      final markdown = '''[link](<foo\\>)''';
      final expected = '''<p>[link](&lt;foo&gt;)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 11', () {
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

    test('Links - Example 12', () {
      final markdown = '''[link](\\(foo\\))''';
      final expected = '''<p><a href="(foo)">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 13', () {
      final markdown = '''[link](foo(and(bar)))''';
      final expected = '''<p><a href="foo(and(bar))">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 14', () {
      final markdown = '''[link](foo\\(and\\(bar\\))''';
      final expected = '''<p><a href="foo(and(bar)">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 15', () {
      final markdown = '''[link](<foo(and(bar)>)''';
      final expected = '''<p><a href="foo(and(bar)">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 16', () {
      final markdown = '''[link](foo\\)\\:)''';
      final expected = '''<p><a href="foo):">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 17', () {
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

    test('Links - Example 18', () {
      final markdown = '''[link](foo\\bar)''';
      final expected = '''<p><a href="foo%5Cbar">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 19', () {
      final markdown = '''[link](foo%20b&auml;)''';
      final expected = '''<p><a href="foo%20b%C3%A4">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 20', () {
      final markdown = '''[link]("title")''';
      final expected = '''<p><a href="%22title%22">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 21', () {
      final markdown = '''[link](/url "title")
[link](/url 'title')
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

    test('Links - Example 22', () {
      final markdown = '''[link](/url "title \\"&quot;")''';
      final expected = '''<p><a href="/url" title="title &quot;&quot;">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 23', () {
      final markdown = '''[link](/url "title")''';
      final expected = '''<p><a href="/url%C2%A0%22title%22">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 24', () {
      final markdown = '''[link](/url "title "and" title")''';
      final expected = '''<p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 25', () {
      final markdown = '''[link](/url 'title "and" title')''';
      final expected = '''<p><a href="/url" title="title &quot;and&quot; title">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 26', () {
      final markdown = '''[link](   /uri
  "title"  )''';
      final expected = '''<p><a href="/uri" title="title">link</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 27', () {
      final markdown = '''[link] (/uri)''';
      final expected = '''<p>[link] (/uri)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 28', () {
      final markdown = '''[link [foo [bar]]](/uri)''';
      final expected = '''<p><a href="/uri">link [foo [bar]]</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 29', () {
      final markdown = '''[link] bar](/uri)''';
      final expected = '''<p>[link] bar](/uri)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 30', () {
      final markdown = '''[link [bar](/uri)''';
      final expected = '''<p>[link <a href="/uri">bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 31', () {
      final markdown = '''[link \\[bar](/uri)''';
      final expected = '''<p><a href="/uri">link [bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 32', () {
      final markdown = '''[link *foo **bar** `#`*](/uri)''';
      final expected = '''<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 33', () {
      final markdown = '''[![moon](moon.jpg)](/uri)''';
      final expected = '''<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 34', () {
      final markdown = '''[foo [bar](/uri)](/uri)''';
      final expected = '''<p>[foo <a href="/uri">bar</a>](/uri)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 35', () {
      final markdown = '''[foo *[bar [baz](/uri)](/uri)*](/uri)''';
      final expected = '''<p>[foo <em>[bar <a href="/uri">baz</a>](/uri)</em>](/uri)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 36', () {
      final markdown = '''![[[foo](uri1)](uri2)](uri3)''';
      final expected = '''<p><img src="uri3" alt="[foo](uri2)" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 37', () {
      final markdown = '''*[foo*](/uri)''';
      final expected = '''<p>*<a href="/uri">foo*</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 38', () {
      final markdown = '''[foo *bar](baz*)''';
      final expected = '''<p><a href="baz*">foo *bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 39', () {
      final markdown = '''*foo [bar* baz]''';
      final expected = '''<p><em>foo [bar</em> baz]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 40', () {
      final markdown = '''[foo <bar attr="](baz)">''';
      final expected = '''<p>[foo <bar attr="](baz)"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 41', () {
      final markdown = '''[foo`](/uri)`''';
      final expected = '''<p>[foo<code>](/uri)</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 42', () {
      final markdown = '''[foo<http://example.com/?search=](uri)>''';
      final expected = '''<p>[foo<a href="http://example.com/?search=%5D(uri)">http://example.com/?search=](uri)</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 43', () {
      final markdown = '''[foo][bar]

[bar]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 44', () {
      final markdown = '''[link [foo [bar]]][ref]

[ref]: /uri''';
      final expected = '''<p><a href="/uri">link [foo [bar]]</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 45', () {
      final markdown = '''[link \\[bar][ref]

[ref]: /uri''';
      final expected = '''<p><a href="/uri">link [bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 46', () {
      final markdown = '''[link *foo **bar** `#`*][ref]

[ref]: /uri''';
      final expected = '''<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 47', () {
      final markdown = '''[![moon](moon.jpg)][ref]

[ref]: /uri''';
      final expected = '''<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 48', () {
      final markdown = '''[foo [bar](/uri)][ref]

[ref]: /uri''';
      final expected = '''<p>[foo <a href="/uri">bar</a>]<a href="/uri">ref</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 49', () {
      final markdown = '''[foo *bar [baz][ref]*][ref]

[ref]: /uri''';
      final expected = '''<p>[foo <em>bar <a href="/uri">baz</a></em>]<a href="/uri">ref</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 50', () {
      final markdown = '''*[foo*][ref]

[ref]: /uri''';
      final expected = '''<p>*<a href="/uri">foo*</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 51', () {
      final markdown = '''[foo *bar][ref]

[ref]: /uri''';
      final expected = '''<p><a href="/uri">foo *bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 52', () {
      final markdown = '''[foo <bar attr="][ref]">

[ref]: /uri''';
      final expected = '''<p>[foo <bar attr="][ref]"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 53', () {
      final markdown = '''[foo`][ref]`

[ref]: /uri''';
      final expected = '''<p>[foo<code>][ref]</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 54', () {
      final markdown = '''[foo<http://example.com/?search=][ref]>

[ref]: /uri''';
      final expected = '''<p>[foo<a href="http://example.com/?search=%5D%5Bref%5D">http://example.com/?search=][ref]</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 55', () {
      final markdown = '''[foo][BaR]

[bar]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 56', () {
      final markdown = '''[Толпой][Толпой] is a Russian word.

[ТОЛПОЙ]: /url''';
      final expected = '''<p><a href="/url">Толпой</a> is a Russian word.</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 57', () {
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

    test('Links - Example 58', () {
      final markdown = '''[foo] [bar]

[bar]: /url "title"''';
      final expected = '''<p>[foo] <a href="/url" title="title">bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 59', () {
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

    test('Links - Example 60', () {
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

    test('Links - Example 61', () {
      final markdown = '''[bar][foo\\!]

[foo!]: /url''';
      final expected = '''<p>[bar][foo!]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 62', () {
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

    test('Links - Example 63', () {
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

    test('Links - Example 64', () {
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

    test('Links - Example 65', () {
      final markdown = '''[foo][ref\\[]

[ref\\[]: /uri''';
      final expected = '''<p><a href="/uri">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 66', () {
      final markdown = '''[bar\\\\]: /uri

[bar\\\\]''';
      final expected = '''<p><a href="/uri">bar\\</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 67', () {
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

    test('Links - Example 68', () {
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

    test('Links - Example 69', () {
      final markdown = '''[foo][]

[foo]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 70', () {
      final markdown = '''[*foo* bar][]

[*foo* bar]: /url "title"''';
      final expected = '''<p><a href="/url" title="title"><em>foo</em> bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 71', () {
      final markdown = '''[Foo][]

[foo]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">Foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 72', () {
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

    test('Links - Example 73', () {
      final markdown = '''[foo]

[foo]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 74', () {
      final markdown = '''[*foo* bar]

[*foo* bar]: /url "title"''';
      final expected = '''<p><a href="/url" title="title"><em>foo</em> bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 75', () {
      final markdown = '''[[*foo* bar]]

[*foo* bar]: /url "title"''';
      final expected = '''<p>[<a href="/url" title="title"><em>foo</em> bar</a>]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 76', () {
      final markdown = '''[[bar [foo]

[foo]: /url''';
      final expected = '''<p>[[bar <a href="/url">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 77', () {
      final markdown = '''[Foo]

[foo]: /url "title"''';
      final expected = '''<p><a href="/url" title="title">Foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 78', () {
      final markdown = '''[foo] bar

[foo]: /url''';
      final expected = '''<p><a href="/url">foo</a> bar</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 79', () {
      final markdown = '''\\[foo]

[foo]: /url "title"''';
      final expected = '''<p>[foo]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 80', () {
      final markdown = '''[foo*]: /url

*[foo*]''';
      final expected = '''<p>*<a href="/url">foo*</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 81', () {
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

    test('Links - Example 82', () {
      final markdown = '''[foo][]

[foo]: /url1''';
      final expected = '''<p><a href="/url1">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 83', () {
      final markdown = '''[foo]()

[foo]: /url1''';
      final expected = '''<p><a href="">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 84', () {
      final markdown = '''[foo](not a link)

[foo]: /url1''';
      final expected = '''<p><a href="/url1">foo</a>(not a link)</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 85', () {
      final markdown = '''[foo][bar][baz]

[baz]: /url''';
      final expected = '''<p>[foo]<a href="/url">bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 86', () {
      final markdown = '''[foo][bar][baz]

[baz]: /url1
[bar]: /url2''';
      final expected = '''<p><a href="/url2">foo</a><a href="/url1">baz</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Links - Example 87', () {
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

    test('Images - Example 1', () {
      final markdown = '''![foo](/url "title")''';
      final expected = '''<p><img src="/url" alt="foo" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 2', () {
      final markdown = '''![foo *bar*]

[foo *bar*]: train.jpg "train & tracks"''';
      final expected = '''<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 3', () {
      final markdown = '''![foo ![bar](/url)](/url2)''';
      final expected = '''<p><img src="/url2" alt="foo bar" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 4', () {
      final markdown = '''![foo [bar](/url)](/url2)''';
      final expected = '''<p><img src="/url2" alt="foo bar" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 5', () {
      final markdown = '''![foo *bar*][]

[foo *bar*]: train.jpg "train & tracks"''';
      final expected = '''<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 6', () {
      final markdown = '''![foo *bar*][foobar]

[FOOBAR]: train.jpg "train & tracks"''';
      final expected = '''<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 7', () {
      final markdown = '''![foo](train.jpg)''';
      final expected = '''<p><img src="train.jpg" alt="foo" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 8', () {
      final markdown = '''My ![foo bar](/path/to/train.jpg  "title"   )''';
      final expected = '''<p>My <img src="/path/to/train.jpg" alt="foo bar" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 9', () {
      final markdown = '''![foo](<url>)''';
      final expected = '''<p><img src="url" alt="foo" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 10', () {
      final markdown = '''![](/url)''';
      final expected = '''<p><img src="/url" alt="" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 11', () {
      final markdown = '''![foo][bar]

[bar]: /url''';
      final expected = '''<p><img src="/url" alt="foo" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 12', () {
      final markdown = '''![foo][bar]

[BAR]: /url''';
      final expected = '''<p><img src="/url" alt="foo" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 13', () {
      final markdown = '''![foo][]

[foo]: /url "title"''';
      final expected = '''<p><img src="/url" alt="foo" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 14', () {
      final markdown = '''![*foo* bar][]

[*foo* bar]: /url "title"''';
      final expected = '''<p><img src="/url" alt="foo bar" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 15', () {
      final markdown = '''![Foo][]

[foo]: /url "title"''';
      final expected = '''<p><img src="/url" alt="Foo" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 16', () {
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

    test('Images - Example 17', () {
      final markdown = '''![foo]

[foo]: /url "title"''';
      final expected = '''<p><img src="/url" alt="foo" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 18', () {
      final markdown = '''![*foo* bar]

[*foo* bar]: /url "title"''';
      final expected = '''<p><img src="/url" alt="foo bar" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 19', () {
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

    test('Images - Example 20', () {
      final markdown = '''![Foo]

[foo]: /url "title"''';
      final expected = '''<p><img src="/url" alt="Foo" title="title" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 21', () {
      final markdown = '''!\\[foo]

[foo]: /url "title"''';
      final expected = '''<p>![foo]</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Images - Example 22', () {
      final markdown = '''\\![foo]

[foo]: /url "title"''';
      final expected = '''<p>!<a href="/url" title="title">foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 1', () {
      final markdown = '''<http://foo.bar.baz>''';
      final expected = '''<p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 2', () {
      final markdown = '''<http://foo.bar.baz/test?q=hello&id=22&boolean>''';
      final expected = '''<p><a href="http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 3', () {
      final markdown = '''<irc://foo.bar:2233/baz>''';
      final expected = '''<p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 4', () {
      final markdown = '''<MAILTO:FOO@BAR.BAZ>''';
      final expected = '''<p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 5', () {
      final markdown = '''<a+b+c:d>''';
      final expected = '''<p><a href="a+b+c:d">a+b+c:d</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 6', () {
      final markdown = '''<made-up-scheme://foo,bar>''';
      final expected = '''<p><a href="made-up-scheme://foo,bar">made-up-scheme://foo,bar</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 7', () {
      final markdown = '''<http://../>''';
      final expected = '''<p><a href="http://../">http://../</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 8', () {
      final markdown = '''<localhost:5001/foo>''';
      final expected = '''<p><a href="localhost:5001/foo">localhost:5001/foo</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 9', () {
      final markdown = '''<http://foo.bar/baz bim>''';
      final expected = '''<p>&lt;http://foo.bar/baz bim&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 10', () {
      final markdown = '''<http://example.com/\\[\\>''';
      final expected = '''<p><a href="http://example.com/%5C%5B%5C">http://example.com/\\[\\</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 11', () {
      final markdown = '''<foo@bar.example.com>''';
      final expected = '''<p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 12', () {
      final markdown = '''<foo+special@Bar.baz-bar0.com>''';
      final expected = '''<p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 13', () {
      final markdown = '''<foo\\+@bar.example.com>''';
      final expected = '''<p>&lt;foo+@bar.example.com&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 14', () {
      final markdown = '''<>''';
      final expected = '''<p>&lt;&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 15', () {
      final markdown = '''< http://foo.bar >''';
      final expected = '''<p>&lt; http://foo.bar &gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 16', () {
      final markdown = '''<m:abc>''';
      final expected = '''<p>&lt;m:abc&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 17', () {
      final markdown = '''<foo.bar.baz>''';
      final expected = '''<p>&lt;foo.bar.baz&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 18', () {
      final markdown = '''http://example.com''';
      final expected = '''<p>http://example.com</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Autolinks - Example 19', () {
      final markdown = '''foo@bar.example.com''';
      final expected = '''<p>foo@bar.example.com</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 1', () {
      final markdown = '''<a><bab><c2c>''';
      final expected = '''<p><a><bab><c2c></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 2', () {
      final markdown = '''<a/><b2/>''';
      final expected = '''<p><a/><b2/></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 3', () {
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

    test('Raw HTML - Example 4', () {
      final markdown = '''<a foo="bar" bam = 'baz <em>"</em>'
_boolean zoop:33=zoop:33 />''';
      final expected = '''<p><a foo="bar" bam = 'baz <em>"</em>'
_boolean zoop:33=zoop:33 /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 5', () {
      final markdown = '''Foo <responsive-image src="foo.jpg" />''';
      final expected = '''<p>Foo <responsive-image src="foo.jpg" /></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 6', () {
      final markdown = '''<33> <__>''';
      final expected = '''<p>&lt;33&gt; &lt;__&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 7', () {
      final markdown = '''<a h*#ref="hi">''';
      final expected = '''<p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 8', () {
      final markdown = '''<a href="hi'> <a href=hi'>''';
      final expected = '''<p>&lt;a href=&quot;hi'&gt; &lt;a href=hi'&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 9', () {
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

    test('Raw HTML - Example 10', () {
      final markdown = '''<a href='bar'title=title>''';
      final expected = '''<p>&lt;a href='bar'title=title&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 11', () {
      final markdown = '''</a></foo >''';
      final expected = '''<p></a></foo ></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 12', () {
      final markdown = '''</a href="foo">''';
      final expected = '''<p>&lt;/a href=&quot;foo&quot;&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 13', () {
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

    test('Raw HTML - Example 14', () {
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

    test('Raw HTML - Example 15', () {
      final markdown = '''foo <?php echo \$a; ?>''';
      final expected = '''<p>foo <?php echo \$a; ?></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 16', () {
      final markdown = '''foo <!ELEMENT br EMPTY>''';
      final expected = '''<p>foo <!ELEMENT br EMPTY></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 17', () {
      final markdown = '''foo <![CDATA[>&<]]>''';
      final expected = '''<p>foo <![CDATA[>&<]]></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 18', () {
      final markdown = '''foo <a href="&ouml;">''';
      final expected = '''<p>foo <a href="&ouml;"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 19', () {
      final markdown = '''foo <a href="\\*">''';
      final expected = '''<p>foo <a href="\\*"></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Raw HTML - Example 20', () {
      final markdown = '''<a href="\\"">''';
      final expected = '''<p>&lt;a href=&quot;&quot;&quot;&gt;</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 1', () {
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

    test('Hard line breaks - Example 2', () {
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

    test('Hard line breaks - Example 3', () {
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

    test('Hard line breaks - Example 4', () {
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

    test('Hard line breaks - Example 5', () {
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

    test('Hard line breaks - Example 6', () {
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

    test('Hard line breaks - Example 7', () {
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

    test('Hard line breaks - Example 8', () {
      final markdown = '''`code  
span`''';
      final expected = '''<p><code>code   span</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 9', () {
      final markdown = '''`code\\
span`''';
      final expected = '''<p><code>code\\ span</code></p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 10', () {
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

    test('Hard line breaks - Example 11', () {
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

    test('Hard line breaks - Example 12', () {
      final markdown = '''foo\\''';
      final expected = '''<p>foo\\</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 13', () {
      final markdown = '''foo  ''';
      final expected = '''<p>foo</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 14', () {
      final markdown = '''### foo\\''';
      final expected = '''<h3>foo\\</h3>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Hard line breaks - Example 15', () {
      final markdown = '''### foo  ''';
      final expected = '''<h3>foo</h3>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Soft line breaks - Example 1', () {
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

    test('Soft line breaks - Example 2', () {
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

    test('Textual content - Example 1', () {
      final markdown = '''hello \$.;'there''';
      final expected = '''<p>hello \$.;'there</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Textual content - Example 2', () {
      final markdown = '''Foo χρῆν''';
      final expected = '''<p>Foo χρῆν</p>''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();
      final html = HtmlRenderer().render(doc);

      expect(html.trim(), expected.trim());
    });

    test('Textual content - Example 3', () {
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
