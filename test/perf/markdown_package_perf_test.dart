// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cmark_gfm/cmark_gfm.dart';
import 'forked/block_parser_v2.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'perf_tester.dart';

Future<void> main(List<String> args) async {
  if (args.contains('--bench')) {
    await runMarkdownPackagePerfTest();
    return;
  }

  test('dart markdown vs cmark_gfm performance', skip: true, () async {
    await runMarkdownPackagePerfTest();
  }, timeout: const Timeout(Duration(minutes: 10)));
}

Future<void> runMarkdownPackagePerfTest() async {
  final assetsDir = path.join(Directory.current.path, 'test', 'perf', 'assets');
  final testFile = File(path.join(assetsDir, 'selectable_region.txt'));
  final sourceText = await testFile.readAsString();

  print('Loaded test file: ${testFile.path}');
  print(
    'Size: ${sourceText.length} chars, ${sourceText.split('\n').length} lines',
  );

  final testCases = [
    sourceText,
    sourceText.substring(0, sourceText.length ~/ 2),
    sourceText.substring(sourceText.length ~/ 4, sourceText.length * 3 ~/ 4),
    sourceText.substring(0, sourceText.length ~/ 4),
    await File(path.join(assetsDir, 'long_poem.txt')).readAsString(),
  ];

  final tester = PerfTester<String, Object?>(
    testName: 'dart official markdown vs cmark_gfm_dart',
    testCases: testCases,
    implementation1: (input) {
      final document = md.Document(
        extensionSet: md.ExtensionSet.gitHubFlavored,
      );
      return document.parseLines(input.split('\n'));
    },
    implementation2: (input) {
      final parser = BlockParserV2(
        parserOptions: const CmarkParserOptions(enableMath: true),
      );
      parser.feed(input);
      return parser.finish();
    },
    impl1Name: 'markdown',
    impl2Name: 'cmark_gfm_dart',
  );

  await tester.run(
    warmupRuns: 20,
    benchmarkRuns: 250,
    skipEqualityCheck: true,
  );
}
