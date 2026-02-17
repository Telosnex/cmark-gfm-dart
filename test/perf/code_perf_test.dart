// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cmark_gfm/cmark_gfm.dart';
import 'forked/block_parser_v2.dart';
import 'forked/node2.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'perf_tester.dart';

/// Extract all text content from a CmarkNode tree.
String getTextContent(CmarkNode root) {
  final buf = StringBuffer();
  void walk(CmarkNode node) {
    if (node.type == CmarkNodeType.softbreak) { buf.write('\n'); }
    else if (node.type == CmarkNodeType.linebreak) { buf.write('\n'); }
    else if (node.type == CmarkNodeType.codeBlock) { buf.write(node.codeData.literal); }
    else if (node.type.isInline && node.firstChild == null) { buf.write(node.content.toString()); }
    var c = node.firstChild;
    while (c != null) { walk(c); c = c.next; }
  }
  walk(root);
  return buf.toString();
}

/// Extract all text content from a CmarkNode2 tree.
String getTextContent2(CmarkNode2 root) {
  final buf = StringBuffer();
  void walk(CmarkNode2 node) {
    if (node.type == CmarkNodeType.softbreak) { buf.write('\n'); }
    else if (node.type == CmarkNodeType.linebreak) { buf.write('\n'); }
    else if (node.type == CmarkNodeType.codeBlock) { buf.write(node.codeData.literal); }
    else if (node.type.isInline && node.firstChild == null) { buf.write(node.contentString); }
    var c = node.firstChild;
    while (c != null) { walk(c); c = c.next; }
  }
  walk(root);
  return buf.toString();
}



Future<void> main() async {
  // if (args.contains('--bench')) {
  //   await runBlockParserPerfTest();
  //   return;
  // }

  test('BlockParser v1 vs v2 (code)', skip: false, () async {
    await runBlockParserPerfTest('selectable_region.txt');
  }, timeout: const Timeout(Duration(minutes: 10)));

  test('BlockParser v1 vs v2 (prose)', skip: false, () async {
    await runBlockParserPerfTest('long_poem.txt');
  }, timeout: const Timeout(Duration(minutes: 10)));
}

Future<void> runBlockParserPerfTest(String filename) async {
  // Load the large test file
  final assetsDir = path.join(Directory.current.path, 'test', 'perf', 'assets');
  final testFile = File(path.join(assetsDir, filename));
  final sourceText = await testFile.readAsString();

  print('Loaded test file: ${testFile.path}');
  print(
      'Size: ${sourceText.length} chars, ${sourceText.split('\n').length} lines');

  // Test cases: parse the full text and various chunks
  final testCases = [
    sourceText,
    sourceText.substring(0, sourceText.length ~/ 2),
    sourceText.substring(sourceText.length ~/ 4, sourceText.length * 3 ~/ 4),
    sourceText.substring(0, sourceText.length ~/ 4),
  ];

  final tester = PerfTester<String, Object>(
    testName: 'Block Parser v1 vs v2',
    testCases: testCases,
    implementation1: (input) {
      final parser = BlockParser(
        parserOptions: const CmarkParserOptions(enableMath: true),
      );
      parser.feed(input);
      return parser.finish();
    },
    implementation2: (input) {
      final parser = BlockParserV2(
        parserOptions: const CmarkParserOptions(enableMath: true),
      );
      parser.feed(input);
      return parser.finish();
    },
    impl1Name: 'BlockParser v1',
    impl2Name: 'BlockParser v2',
    equalityCheck: (a, b) {
      // Tree structure may differ in node boundaries (e.g. around $)
      // because V2's fused loop handles unmatched math chars differently.
      // Compare extracted text content instead.
      final textA = a is CmarkNode2 ? getTextContent2(a) : getTextContent(a as CmarkNode);
      final textB = b is CmarkNode2 ? getTextContent2(b) : getTextContent(b as CmarkNode);
      return textA == textB;
    },
  );

  await tester.run(
    warmupRuns: 30,
    benchmarkRuns: 250,
  );
  // await Future.delayed(const Duration(seconds: 5)); // Allow async logs to flush
}
