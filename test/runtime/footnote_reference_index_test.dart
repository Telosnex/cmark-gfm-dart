import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  group('Footnote reference index', () {
    test('standard format [^N] references get correct indices', () {
      const markdown = '''
Here is ref one [^1] and ref three [^3] and ref nine [^9].

[^1]: https://example.com/1
[^3]: https://example.com/3
[^9]: https://example.com/9
''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();

      final refs = <int>[];
      _collectFootnoteReferenceIndices(doc, refs);

      // Each reference should have a unique index based on order of first appearance
      expect(refs, hasLength(3));
      expect(refs[0], 1); // [^1] is first reference seen → index 1
      expect(refs[1], 2); // [^3] is second reference seen → index 2
      expect(refs[2], 3); // [^9] is third reference seen → index 3
    });

    test('nonstandard format [^N^] references get correct indices', () {
      const markdown = '''
Here is ref one [^1^] and ref three [^3^] and ref nine [^9^].

[^1^]: https://example.com/1
[^3^]: https://example.com/3
[^9^]: https://example.com/9
''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();

      final refs = <int>[];
      _collectFootnoteReferenceIndices(doc, refs);

      // Each reference should have a unique index
      expect(refs, hasLength(3));
      expect(refs[0], 1); // [^1^] → index 1
      expect(refs[1], 2); // [^3^] → index 2  
      expect(refs[2], 3); // [^9^] → index 3
    });

    test('reference content matches definition label for [^N^] format', () {
      const markdown = '''
Ref [^1^] here.

[^1^]: https://example.com/1
''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();

      // Find the footnote reference
      CmarkNode? ref;
      CmarkNode? def;
      _findFootnoteNodes(doc, (r) => ref = r, (d) => def = d);

      expect(ref, isNotNull, reason: 'Should find footnote reference');
      expect(def, isNotNull, reason: 'Should find footnote definition');
      
      print('Reference content: "${ref!.content}"');
      print('Definition content (label): "${def!.content}"');
      print('Reference index: ${ref!.footnoteReferenceIndex}');
      
      // The reference should be linked to the definition
      expect(ref!.footnoteReferenceIndex, 1);
    });

    test('LA Kings example - all refs should have different indices', () {
      const markdown = '''
**Hockey (NHL) - LA Kings:**
- **Kings 1, Dallas Stars 3** (1/11) - The LA Kings lost. [^1^] [^3^]

**Basketball (NBA) - Sacramento Kings:**
- **Sacramento Kings 124, LA Lakers 112** (1/12) - The Kings won. [^9^]

[^1^]: https://www.espn.com/nhl/team/_/name/la/los-angeles-kings
[^3^]: https://lakingsinsider.com/2026/01/12/final-kings-1-stars-3/
[^9^]: https://www.espn.com/nba/recap/_/gameId/401810417
''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finish();

      final refs = <int>[];
      final contents = <String>[];
      _collectFootnoteReferenceData(doc, refs, contents);

      print('Found ${refs.length} footnote references:');
      for (var i = 0; i < refs.length; i++) {
        print('  Reference $i: content="${contents[i]}", index=${refs[i]}');
      }

      expect(refs, hasLength(3), reason: 'Should find 3 footnote references');
      
      // All indices should be different
      expect(refs.toSet().length, 3, reason: 'All indices should be unique');
      
      // Indices should be 1, 2, 3 (order of first appearance)
      expect(refs, containsAll([1, 2, 3]));
    });

    test('finishClone also gets correct indices', () {
      const markdown = '''
**Hockey (NHL) - LA Kings:**
- **Kings 1, Dallas Stars 3** (1/11) - The LA Kings lost. [^1^] [^3^]

**Basketball (NBA) - Sacramento Kings:**
- **Sacramento Kings 124, LA Lakers 112** (1/12) - The Kings won. [^9^]

[^1^]: https://www.espn.com/nhl/team/_/name/la/los-angeles-kings
[^3^]: https://lakingsinsider.com/2026/01/12/final-kings-1-stars-3/
[^9^]: https://www.espn.com/nba/recap/_/gameId/401810417
''';

      final parser = CmarkParser();
      parser.feed(markdown);
      final doc = parser.finishClone(); // Using finishClone like telosnex does

      final refs = <int>[];
      final contents = <String>[];
      _collectFootnoteReferenceData(doc, refs, contents);

      print('finishClone - Found ${refs.length} footnote references:');
      for (var i = 0; i < refs.length; i++) {
        print('  Reference $i: content="${contents[i]}", index=${refs[i]}');
      }

      expect(refs, hasLength(3), reason: 'Should find 3 footnote references');
      expect(refs.toSet().length, 3, reason: 'All indices should be unique');
    });
  });
}

void _collectFootnoteReferenceIndices(CmarkNode node, List<int> indices) {
  if (node.type == CmarkNodeType.footnoteReference) {
    indices.add(node.footnoteReferenceIndex);
  }
  var child = node.firstChild;
  while (child != null) {
    _collectFootnoteReferenceIndices(child, indices);
    child = child.next;
  }
}

void _collectFootnoteReferenceData(CmarkNode node, List<int> indices, List<String> contents) {
  if (node.type == CmarkNodeType.footnoteReference) {
    indices.add(node.footnoteReferenceIndex);
    contents.add(node.content.toString());
  }
  var child = node.firstChild;
  while (child != null) {
    _collectFootnoteReferenceData(child, indices, contents);
    child = child.next;
  }
}

void _findFootnoteNodes(
  CmarkNode node,
  void Function(CmarkNode) onRef,
  void Function(CmarkNode) onDef,
) {
  if (node.type == CmarkNodeType.footnoteReference) {
    onRef(node);
  }
  if (node.type == CmarkNodeType.footnoteDefinition) {
    onDef(node);
  }
  var child = node.firstChild;
  while (child != null) {
    _findFootnoteNodes(child, onRef, onDef);
    child = child.next;
  }
}
