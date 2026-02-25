import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  group('Ordered list - preserve original numbers', () {
    test('sequential numbers 1,2,3,4,5', () {
      const markdown = '''
1. First
2. Second
3. Third
4. Fourth
5. Fifth
''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();

      final items = _collectListItemNumbers(doc);
      expect(items, [1, 2, 3, 4, 5]);
    });

    test('non-sequential numbers 1,2,3,7,10', () {
      const markdown = '''
1. In n Out
2. El Pollo Loco
3. Pupuseria
7. Dominican place
10. Vons
''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();

      final items = _collectListItemNumbers(doc);
      // Should preserve original numbers, not normalize to 1,2,3,4,5
      expect(items, [1, 2, 3, 7, 10]);
    });

    test('starting from non-1 number', () {
      const markdown = '''
5. Fifth item
6. Sixth item
10. Tenth item
''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();

      final items = _collectListItemNumbers(doc);
      expect(items, [5, 6, 10]);
    });

    test('all same number', () {
      const markdown = '''
1. First
1. Also first
1. Still first
''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();

      final items = _collectListItemNumbers(doc);
      expect(items, [1, 1, 1]);
    });
  });
}

/// Collects the original marker numbers from all list items in the document.
List<int> _collectListItemNumbers(CmarkNode node) {
  final numbers = <int>[];
  _walkForItems(node, numbers);
  return numbers;
}

void _walkForItems(CmarkNode node, List<int> numbers) {
  if (node.type == CmarkNodeType.item) {
    numbers.add(node.listData.start);
  }
  var child = node.firstChild;
  while (child != null) {
    _walkForItems(child, numbers);
    child = child.next;
  }
}
