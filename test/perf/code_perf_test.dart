// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:cmark_gfm/src/parser/block_parser.dart';
import 'package:cmark_gfm/src/parser/block_parser_v2.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../helpers.dart';
import 'perf_tester.dart';

Future<void> main(List<String> args) async {
  if (args.contains('--bench')) {
    await runBlockParserPerfTest();
    return;
  }

  test('BlockParser v1 vs v2 performance', skip: true, () async {
    await runBlockParserPerfTest();
  }, timeout: const Timeout(Duration(minutes: 10)));
}

Future<void> runBlockParserPerfTest() async {
  // Load the large test file
  final assetsDir = path.join(Directory.current.path, 'test', 'perf', 'assets');
  final testFile = File(path.join(assetsDir, 'selectable_region.txt'));
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

  final tester = PerfTester<String, CmarkNode>(
    testName: 'Block Parser v1 vs v2',
    testCases: testCases,
    implementation1: (input) {
      // V1: Original BlockParser
      final parser = BlockParser(
        parserOptions: const CmarkParserOptions(enableMath: true),
      );
      parser.feed(input);
      return parser.finish();
    },
    implementation2: (input) {
      // V2: Optimized BlockParserV2
      final parser = BlockParserV2(
        parserOptions: const CmarkParserOptions(enableMath: true),
      );
      parser.feed(input);
      return parser.finish();
    },
    impl1Name: 'BlockParser v1',
    impl2Name: 'BlockParser v2',
    equalityCheck: (a, b) {
      if (a == null || b == null) {
        return false;
      }
      // Just verify both parse without errors
      return getStringForTree(a) == getStringForTree(b);
    },
  );

  await tester.run(
    warmupRuns: 10,
    benchmarkRuns: 50,
  );
}
