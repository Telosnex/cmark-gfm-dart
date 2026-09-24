import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

const _markdown = '''
### Unlocking an already signed-in device

| Device | Before | Proposed |
|---|---|---|---|
| Existing | “Check the account before continuing.” | **Unlock your other device?** |
| Receiving | “Check the account before continuing.” | **Unlock encrypted data?** |
| Both | “Unlock encrypted data for this account” | Show **[email]** clearly below the heading. |
| Both | **Compare to unlock encrypted data** | **Continue** |
| Both | “This does not transfer a key or change your account yet.” | “Next, compare the symbols on both devices. Nothing is approved yet.” |
''';

void main() {
  for (final trailingNewline in [false, true]) {
    test(
        'unlocking device comparison is a table with five body rows (trailing newline: $trailingNewline)',
        () {
      final parser = CmarkParser()
        ..feed(trailingNewline ? _markdown : _markdown.trimRight());
      final document = parser.finish();
      final blocks = <CmarkNode>[];
      for (var child = document.firstChild; child != null; child = child.next) {
        blocks.add(child);
      }
      expect(blocks.map((block) => block.type),
          [CmarkNodeType.heading, CmarkNodeType.table]);
      final table = blocks.last;
      final rows = <CmarkNode>[];
      for (var row = table.firstChild; row != null; row = row.next) {
        rows.add(row);
        var cells = 0;
        for (var cell = row.firstChild; cell != null; cell = cell.next) {
          cells++;
        }
        expect(cells, 3);
      }
      expect(rows, hasLength(6));
      final html = HtmlRenderer().render(document);
      expect(html, contains('<strong>Unlock your other device?</strong>'));
      expect(html, contains('<strong>[email]</strong>'));
      expect(
          html,
          contains(
              '“Next, compare the symbols on both devices. Nothing is approved yet.”'));
    });
  }

  for (final trailingNewline in [false, true]) {
    for (final chunkSize in [1, 3, 16, 97]) {
      test(
          'streaming in $chunkSize-character chunks matches whole parse (trailing newline: $trailingNewline)',
          () {
        final markdown = trailingNewline ? _markdown : _markdown.trimRight();
        final oneShot = CmarkParser()..feed(markdown);
        final expected = HtmlRenderer().render(oneShot.finish());
        final streaming = CmarkParser();
        for (var offset = 0; offset < markdown.length; offset += chunkSize) {
          final end = (offset + chunkSize).clamp(0, markdown.length);
          streaming.feed(markdown.substring(offset, end));
          streaming.finishClone();
        }
        expect(HtmlRenderer().render(streaming.finishClone()), expected);
      });
    }
  }

  test('GFM strict mode keeps mismatched delimiter counts as prose', () {
    final parser = CmarkParser(
      options: const CmarkParserOptions(allowExtraTableDelimiters: false),
    )..feed(_markdown);
    expect(parser.finish().lastChild!.type, CmarkNodeType.paragraph);
  });

  test('extra delimiters are ignored, including more than one', () {
    final parser = CmarkParser()
      ..feed('| A | B |\n|:---|---:|---|:---:|\n| x | y |');
    final document = parser.finish();
    final table = document.firstChild!;
    expect(table.type, CmarkNodeType.table);
    expect(table.firstChild!.firstChild!.tableCellData.align,
        CmarkTableAlign.left);
    expect(table.firstChild!.firstChild!.next!.tableCellData.align,
        CmarkTableAlign.right);
    final html = HtmlRenderer().render(document);
    expect(html, contains('<td align="left">x</td>'));
    expect(html, contains('<td align="right">y</td>'));
    expect(html, isNot(contains('<td></td>')));
  });

  test('recovery does not invent a missing delimiter', () {
    final parser = CmarkParser()
      ..feed('| A | B | C |\n|---|---|\n| x | y | z |');
    expect(parser.finish().firstChild!.type, CmarkNodeType.paragraph);
  });

  test('maxReferenceSize constructor preserves the strict option', () {
    final parser = CmarkParser(
      options: const CmarkParserOptions(allowExtraTableDelimiters: false),
      maxReferenceSize: 100,
    )..feed(_markdown);
    expect(parser.finish().lastChild!.type, CmarkNodeType.paragraph);
  });
}
