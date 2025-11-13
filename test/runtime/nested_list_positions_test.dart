import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('nested list - incremental streaming', () {
    // Simulate how Telosnex actually uses the parser:
    // - Feed text incrementally as AI generates it
    // - Call finishClone() after each chunk
    
    final parser = CmarkParser();
    
    print('=== INCREMENTAL STREAMING TEST ===');
    
    // Feed line by line like streaming AI
    print('Step 1: Feed "- A\n"');
    parser.feed('- A\n');
    var doc = parser.finishClone();
    print('After step 1: ${doc.firstChild?.endLine}:${doc.firstChild?.endColumn}');
    
    print('Step 2: Feed "  - B\n"');
    parser.feed('  - B\n');
    doc = parser.finishClone();
    print('After step 2: ${doc.firstChild?.endLine}:${doc.firstChild?.endColumn}');
    
    print('Step 3: Feed "  - C"');
    parser.feed('  - C');
    doc = parser.finishClone();
    
    print('\nFinal tree:');
    print(getStringForTree(doc));
    
    final root = doc.firstChild!;
    print('\nRoot list: line ${root.startLine}:${root.startColumn} to ${root.endLine}:${root.endColumn}');
    
    // Find item C
    final firstItem = root.children.first;
    final nestedList = firstItem.children.firstWhere((c) => c.type == CmarkNodeType.list);
    final itemC = nestedList.children.toList()[1];
    
    print('Item C: line ${itemC.startLine}:${itemC.startColumn} to ${itemC.endLine}:${itemC.endColumn}');
    
    if (itemC.endLine < itemC.startLine) {
      print('\n❌ BUG: Item C ends BEFORE it starts! (${itemC.startLine} → ${itemC.endLine})');
      fail('Incremental finishClone() corrupts positions');
    } else {
      print('\n✅ PASS: Incremental streaming works!');
    }
  });
  
  test('nested list - one-shot parsing (baseline)', () {
    const markdown = '- A\n  - B\n  - C';
    
    // The issue: parent list reports wrong end position
    // Expected: list should end at line 3, column 5 (after "- C")
    // Bug: list was ending at line 2, column 5 (after "- B")
    
    print('Input markdown:');
    print('"$markdown"');
    print('');

    // Test BOTH finish() and finishClone()
    print('=== Testing finish() ===');
    final parser1 = CmarkParser();
    parser1.feed(markdown);
    final doc = parser1.finish();
    
    print('Tree structure:');
    print(getStringForTree(doc));
    print('');

    // Navigate to the root list
    final root = doc.firstChild;
    expect(root, isNotNull, reason: 'Should have a root list');
    expect(root!.type, CmarkNodeType.list, reason: 'First child should be a list');
    
    print('Root list position:');
    print('  startLine: ${root.startLine}, startColumn: ${root.startColumn}');
    print('  endLine: ${root.endLine}, endColumn: ${root.endColumn}');
    print('');
    
    // Check all items
    final items = root.children.toList();
    print('Items:');
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      print('  Item $i (${item.type}): line ${item.startLine}:${item.startColumn} to ${item.endLine}:${item.endColumn}');
      
      // Check nested list
      for (final child in item.children) {
        if (child.type == CmarkNodeType.list) {
          print('    Nested list: line ${child.startLine}:${child.startColumn} to ${child.endLine}:${child.endColumn}');
          
          for (final nestedItem in child.children) {
            print('      Nested item: line ${nestedItem.startLine}:${nestedItem.startColumn} to ${nestedItem.endLine}:${nestedItem.endColumn}');
          }
        }
      }
    }
    print('');
    
    // THE BUG: Find the nested list item for "- C" at line 3
    final firstItem = items[0];
    final nestedList = firstItem.children.firstWhere(
      (child) => child.type == CmarkNodeType.list,
    );
    final nestedItems = nestedList.children.toList();
    
    expect(nestedItems.length, 2, reason: 'Should have 2 nested items (B and C)');
    
    final itemB = nestedItems[0];
    final itemC = nestedItems[1];
    
    print('Item B position: line ${itemB.startLine}:${itemB.startColumn} to ${itemB.endLine}:${itemB.endColumn}');
    print('Item C position: line ${itemC.startLine}:${itemC.startColumn} to ${itemC.endLine}:${itemC.endColumn}');
    print('');
    
    // Verify item C is at line 3
    expect(itemC.startLine, 3, reason: 'Item C should start at line 3');
    
    // THE CRITICAL TEST: Parent list should end at line 3 or later
    print('Testing parent list end position:');
    print('  Root list ends at: line ${root.endLine}, column ${root.endColumn}');
    print('  Item C starts at:  line ${itemC.startLine}, column ${itemC.startColumn}');
    print('  Item C ends at:    line ${itemC.endLine}, column ${itemC.endColumn}');
    print('');
    
    if (root.endLine < itemC.endLine) {
      print('❌ BUG FOUND: Parent list ends at line ${root.endLine} but has child at line ${itemC.endLine}!');
      fail('Parent list should end at line ${itemC.endLine} or later, but ends at line ${root.endLine}');
    } else {
      print('✅ PASS: Parent list correctly includes all children');
    }
    
    // Now test finishClone() - THIS IS WHAT TELOSNEX USES!
    print('\n=== Testing finishClone() ===');
    final parser2 = CmarkParser();
    parser2.feed(markdown);
    final clonedDoc = parser2.finishClone();
    
    print('Cloned tree structure:');
    print(getStringForTree(clonedDoc));
    print('');
    
    final clonedRoot = clonedDoc.firstChild;
    expect(clonedRoot, isNotNull);
    expect(clonedRoot!.type, CmarkNodeType.list);
    
    print('Cloned root list position:');
    print('  startLine: ${clonedRoot.startLine}, startColumn: ${clonedRoot.startColumn}');
    print('  endLine: ${clonedRoot.endLine}, endColumn: ${clonedRoot.endColumn}');
    print('');
    
    // Check nested items in clone
    final clonedFirstItem = clonedRoot.children.first;
    final clonedNestedList = clonedFirstItem.children.firstWhere(
      (child) => child.type == CmarkNodeType.list,
    );
    final clonedNestedItems = clonedNestedList.children.toList();
    final clonedItemC = clonedNestedItems[1];
    
    print('Cloned Item C position: line ${clonedItemC.startLine}:${clonedItemC.startColumn} to ${clonedItemC.endLine}:${clonedItemC.endColumn}');
    print('');
    
    print('Testing cloned parent list end position:');
    print('  Cloned root list ends at: line ${clonedRoot.endLine}, column ${clonedRoot.endColumn}');
    print('  Cloned item C starts at:  line ${clonedItemC.startLine}, column ${clonedItemC.startColumn}');
    print('  Cloned item C ends at:    line ${clonedItemC.endLine}, column ${clonedItemC.endColumn}');
    print('');
    
    // Check for EITHER bug:
    // 1. Item C has invalid position (end before start)
    // 2. Parent list ends before item C starts
    if (clonedItemC.endLine < clonedItemC.startLine) {
      print('❌ BUG IN finishClone(): Item C has invalid position (${clonedItemC.startLine}:${clonedItemC.startColumn} to ${clonedItemC.endLine}:${clonedItemC.endColumn}) - end before start!');
      fail('finishClone() bug: Item C position is invalid');
    } else if (clonedRoot.endLine < clonedItemC.startLine) {
      print('❌ BUG IN finishClone(): Parent list ends at line ${clonedRoot.endLine} but child starts at line ${clonedItemC.startLine}!');
      fail('finishClone() bug: Parent list should include all children');
    } else {
      print('✅ PASS: finishClone() correctly includes all children');
    }
  });
}
