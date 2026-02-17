import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  group('CmarkParser (partial)', () {
    test('parses single paragraph', () {
      final parser = CmarkParser();
      parser.feed('Hello world');
      final doc = parser.finish();
      expect(doc.firstChild, isNotNull);
      expect(doc.firstChild!.type, CmarkNodeType.paragraph);
      expect(doc.firstChild!.content.toString().trimRight(), 'Hello world');
    });

    test('parses multiple paragraphs separated by blank lines', () {
      final parser = CmarkParser();
      parser.feed('Hello world\n\nSecond paragraph');
      final doc = parser.finish();
      expect(doc.firstChild, isNotNull);
      expect(doc.firstChild!.next, isNotNull);
      expect(doc.firstChild!.content.toString().trimRight(), 'Hello world');
      expect(doc.firstChild!.next!.content.toString().trimRight(), 'Second paragraph');
    });

    test('handles multi-line paragraph', () {
      final parser = CmarkParser();
      parser.feed('Hello world\nSecond line');
      final doc = parser.finish();
      expect(doc.firstChild!.content.toString().trimRight(), 'Hello world\nSecond line');
    });

    test('allows incremental feed', () {
      final parser = CmarkParser();
      parser.feed('Hello');
      parser.feed(' world\n\nSecond');
      parser.feed(' paragraph');
      final doc = parser.finish();
      expect(doc.firstChild!.content.toString().trimRight(), 'Hello world');
      expect(doc.firstChild!.next!.content.toString().trimRight(), 'Second paragraph');
    });

    test('parses ATX headings', () {
      final parser = CmarkParser();
      parser.feed('# Heading 1\nParagraph');
      final doc = parser.finish();
      final heading = doc.firstChild;
      expect(heading, isNotNull);
      expect(heading!.type, CmarkNodeType.heading);
      expect(heading.headingData.level, 1);
      expect(heading.content.toString().trimRight(), 'Heading 1');
      expect(heading.next!.type, CmarkNodeType.paragraph);
    });

    test('parses setext headings', () {
      final parser = CmarkParser();
      parser.feed('Heading\n===\n');
      final doc = parser.finish();
      final heading = doc.firstChild;
      expect(heading, isNotNull);
      expect(heading!.type, CmarkNodeType.heading);
      expect(heading.headingData.level, 1);
      expect(heading.headingData.setext, isTrue);
      expect(heading.content.toString().trimRight(), 'Heading');
    });

    test('parses thematic breaks', () {
      final parser = CmarkParser();
      parser.feed('Paragraph\n\n---\nNext');
      final doc = parser.finish();
      final first = doc.firstChild;
      expect(first, isNotNull);
      expect(first!.type, CmarkNodeType.paragraph);
      final hr = first.next;
      expect(hr, isNotNull);
      expect(hr!.type, CmarkNodeType.thematicBreak);
      final next = hr.next;
      expect(next, isNotNull);
      expect(next!.type, CmarkNodeType.paragraph);
      expect(next.content.toString().trimRight(), 'Next');
    });

    test('parses block quote with paragraphs', () {
      final parser = CmarkParser();
      parser.feed('> Quote line\n>\n> Second line\n\nAfter');
      final doc = parser.finish();
      final blockQuote = doc.firstChild;
      expect(blockQuote, isNotNull);
      expect(blockQuote!.type, CmarkNodeType.blockQuote);
      final innerFirst = blockQuote.firstChild;
      expect(innerFirst, isNotNull);
      expect(innerFirst!.type, CmarkNodeType.paragraph);
      expect(innerFirst.content.toString().trimRight(), 'Quote line');
      final innerSecond = innerFirst.next;
      expect(innerSecond, isNotNull);
      expect(innerSecond!.type, CmarkNodeType.paragraph);
      expect(innerSecond.content.toString().trimRight(), 'Second line');
      final paragraph = blockQuote.next;
      expect(paragraph, isNotNull);
      expect(paragraph!.type, CmarkNodeType.paragraph);
      expect(paragraph.content.toString().trimRight(), 'After');
    });

    test('parses unordered list with multiple items', () {
      final parser = CmarkParser();
      parser.feed('- item one\n- item two');
      final doc = parser.finish();
      final list = doc.firstChild;
      expect(list, isNotNull);
      expect(list!.type, CmarkNodeType.list);
      final firstItem = list.firstChild;
      expect(firstItem, isNotNull);
      expect(firstItem!.type, CmarkNodeType.item);
      expect(firstItem.firstChild!.content.toString().trimRight(), 'item one');
      final secondItem = firstItem.next;
      expect(secondItem, isNotNull);
      expect(secondItem!.firstChild!.content.toString().trimRight(), 'item two');
    });

    test('parses ordered list with numbering', () {
      final parser = CmarkParser();
      parser.feed('3. alpha\n4. beta');
      final doc = parser.finish();
      final list = doc.firstChild;
      expect(list, isNotNull);
      expect(list!.type, CmarkNodeType.list);
      expect(list.listData.listType, CmarkListType.ordered);
      expect(list.listData.start, 3);
      final firstItem = list.firstChild;
      expect(firstItem!.firstChild!.content.toString().trimRight(), 'alpha');
      final secondItem = firstItem.next;
      expect(secondItem!.firstChild!.content.toString().trimRight(), 'beta');
    });

    test('parses indented code block', () {
      final parser = CmarkParser();
      parser.feed('    code line\n        indented');
      final doc = parser.finish();
      final code = doc.firstChild;
      expect(code, isNotNull);
      expect(code!.type, CmarkNodeType.codeBlock);
      expect(code.codeData.literal, 'code line\n    indented\n');
    });

    test('parses fenced code block', () {
      final parser = CmarkParser();
      parser.feed('```dart\nfinal x = 1;\n```');
      final doc = parser.finish();
      final code = doc.firstChild;
      expect(code, isNotNull);
      expect(code!.type, CmarkNodeType.codeBlock);
      expect(code.codeData.info, 'dart');
      expect(code.codeData.isFenced, isTrue);
      expect(code.codeData.literal, 'final x = 1;\n');
    });
  });
}
