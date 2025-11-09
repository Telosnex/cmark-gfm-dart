import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  group('CmarkNode', () {
    test('appendChild establishes bidirectional links', () {
      final parent = CmarkNode(CmarkNodeType.document);
      final paragraph = CmarkNode(CmarkNodeType.paragraph);
      final text = CmarkNode(CmarkNodeType.text);

      parent.appendChild(paragraph);
      paragraph.appendChild(text);

      expect(parent.firstChild, same(paragraph));
      expect(parent.lastChild, same(paragraph));
      expect(paragraph.parent, same(parent));
      expect(paragraph.firstChild, same(text));
      expect(text.parent, same(paragraph));
      expect(text.previous, isNull);
      expect(text.next, isNull);
    });

    test('prependChild updates first child', () {
      final parent = CmarkNode(CmarkNodeType.document);
      final a = CmarkNode(CmarkNodeType.paragraph);
      final b = CmarkNode(CmarkNodeType.paragraph);

      parent.appendChild(a);
      parent.prependChild(b);

      expect(parent.firstChild, same(b));
      expect(parent.lastChild, same(a));
      expect(b.next, same(a));
      expect(a.previous, same(b));
    });

    test('unlink detaches node', () {
      final parent = CmarkNode(CmarkNodeType.document);
      final a = CmarkNode(CmarkNodeType.paragraph);
      final b = CmarkNode(CmarkNodeType.paragraph);
      final c = CmarkNode(CmarkNodeType.paragraph);

      parent.appendChild(a);
      parent.appendChild(b);
      parent.appendChild(c);

      b.unlink();

      expect(a.next, same(c));
      expect(c.previous, same(a));
      expect(parent.firstChild, same(a));
      expect(parent.lastChild, same(c));
      expect(b.parent, isNull);
      expect(b.next, isNull);
      expect(b.previous, isNull);
    });

    test('deepCopy clones subtree', () {
      final document = CmarkNode(CmarkNodeType.document);
      final paragraph = CmarkNode(CmarkNodeType.paragraph)
        ..content.write('Hello');
      final text = CmarkNode(CmarkNodeType.text)..content.write('world');

      document.appendChild(paragraph);
      paragraph.appendChild(text);

      final copy = document.deepCopy();

      expect(copy, isNot(same(document)));
      expect(copy.firstChild, isNotNull);
      expect(copy.firstChild!.type, CmarkNodeType.paragraph);
      expect(copy.firstChild!.content.toString(), 'Hello');
      expect(copy.firstChild!.firstChild!.type, CmarkNodeType.text);
      expect(copy.firstChild!.firstChild!.content.toString(), 'world');
    });
  });
}
