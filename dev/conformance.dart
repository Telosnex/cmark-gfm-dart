/// Utility for working with the CommonMark/GFM conformance tests.
///
/// Usage (from the repo root):
///
///   dart run dev/conformance.dart run
///       # runs only the CommonMark and GFM spec tests
///
///   dart run dev/conformance.dart run --summary
///       # runs the suite with the JSON reporter and prints a concise
///       # list of failing tests (handy for copy/paste into `show`)
///
///   dart run dev/conformance.dart list [pattern]
///       # lists test names (optionally filtered by a substring)
///
///   dart run dev/conformance.dart show <pattern>
///       # prints the full Dart source for matching tests
///       # e.g.:
///       #   dart run dev/conformance.dart show "Tabs - Example 1"
///       #   dart run dev/conformance.dart show "CommonMark Spec Tests Tabs - Example 1"
///
/// This is meant to make it easy to:
///   * run just the conformance suite, and
///   * quickly find the corresponding test case without opening the
///     large generated test files.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

const _commonmarkFile = 'test/commonmark_spec_test.dart';
const _gfmFile = 'test/gfm_spec_test.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty ||
      args.first == 'help' ||
      args.first == '--help' ||
      args.first == '-h') {
    _printUsage();
    return;
  }

  final cmd = args.first;
  final rest = args.skip(1).toList();

  switch (cmd) {
    case 'run':
      final parsed = _parseRunArgs(rest);
      if (parsed.summaryMode) {
        await _runConformanceTestsSummary(parsed.extraArgs);
      } else {
        await _runConformanceTests(parsed.extraArgs);
      }
      break;
    case 'list':
      final pattern = rest.isEmpty ? null : rest.join(' ');
      await _listTests(pattern);
      break;
    case 'show':
      if (rest.isEmpty) {
        stderr.writeln('Missing pattern for show.');
        _printUsage();
        exitCode = 1;
        return;
      }
      final pattern = rest.join(' ');
      await _showTests(pattern);
      break;
    default:
      stderr.writeln('Unknown command: $cmd');
      _printUsage();
      exitCode = 1;
  }
}

void _printUsage() {
  stdout.writeln('Conformance test helper');
  stdout.writeln();
  stdout.writeln('Usage (run from the repository root):');
  stdout.writeln('  dart run dev/conformance.dart run [--summary|-s]');
  stdout.writeln('      Run the CommonMark and GFM spec test suites.');
  stdout.writeln(
      '      --summary / -s  Re-run with the JSON reporter and print a summary of failing tests.');
  stdout.writeln();
  stdout.writeln('  dart run dev/conformance.dart list [pattern]');
  stdout.writeln(
      '      List all conformance tests, optionally filtered by a substring.');
  stdout.writeln();
  stdout.writeln('  dart run dev/conformance.dart show <pattern>');
  stdout.writeln(
      '      Print the Dart source for tests whose name contains <pattern>.');
  stdout.writeln();
  stdout.writeln('Examples:');
  stdout.writeln('  dart run dev/conformance.dart run');
  stdout.writeln('  dart run dev/conformance.dart list "Tabs - Example"');
  stdout.writeln('  dart run dev/conformance.dart show "Tabs - Example 1"');
  stdout.writeln(
      '  dart run dev/conformance.dart show "CommonMark Spec Tests Tabs - Example 1"');
}

Future<void> _runConformanceTests(List<String> extraArgs) async {
  final args = <String>[
    'test',
    _commonmarkFile,
    _gfmFile,
    ...extraArgs,
  ];

  stdout.writeln('Running conformance tests:');
  stdout.writeln('  dart ${args.join(' ')}');
  stdout.writeln();

  final process = await Process.start(
    'dart',
    args,
    runInShell: true,
  );

  // Pipe stdout/stderr through.
  await Future.wait([
    stdout.addStream(process.stdout),
    stderr.addStream(process.stderr),
  ]);

  final code = await process.exitCode;
  if (code != 0) {
    stderr.writeln('Conformance tests failed with exit code $code');
    exit(code);
  }
}

class _RunCommandArgs {
  const _RunCommandArgs({
    required this.summaryMode,
    required this.extraArgs,
  });

  final bool summaryMode;
  final List<String> extraArgs;
}

_RunCommandArgs _parseRunArgs(List<String> args) {
  final filtered = <String>[];
  var summary = false;

  for (final arg in args) {
    if (arg == '--summary' || arg == '-s') {
      summary = true;
      continue;
    }
    filtered.add(arg);
  }

  return _RunCommandArgs(summaryMode: summary, extraArgs: filtered);
}

Future<void> _runConformanceTestsSummary(List<String> extraArgs) async {
  if (extraArgs.any((arg) =>
      arg == '--reporter' ||
      arg == '-r' ||
      arg.startsWith('--reporter=') ||
      arg.startsWith('-r='))) {
    stderr.writeln('Cannot combine --summary with a custom reporter.');
    exitCode = 64;
    return;
  }

  final args = <String>[
    'test',
    _commonmarkFile,
    _gfmFile,
    '--reporter',
    'json',
    ...extraArgs,
  ];

  stdout.writeln('Running conformance tests (summary mode):');
  stdout.writeln('  dart ${args.join(' ')}');
  stdout.writeln();

  final process = await Process.start(
    'dart',
    args,
    runInShell: true,
  );

  final suitePaths = <int, String>{};
  final testSuites = <int, int>{};
  final testNames = <int, String>{};
  final testMessages = <int, List<String>>{};
  final failing = <_TestFailure>[];

  final stdoutDone = Completer<void>();

  process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen(
      (line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) {
      return;
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(trimmed);
    } catch (err) {
      stderr.writeln('Could not parse JSON from dart test: $trimmed');
      return;
    }

    if (decoded is! Map<String, dynamic>) {
      return;
    }

    final type = decoded['type'] as String?;
    if (type == null) return;

    switch (type) {
      case 'suite':
        final suite = decoded['suite'];
        if (suite is Map<String, dynamic>) {
          final id = suite['id'];
          final path = suite['path'];
          if (id is int && path is String) {
            suitePaths[id] = _makeRelativePath(path);
          }
        }
        break;
      case 'testStart':
        final test = decoded['test'];
        if (test is Map<String, dynamic>) {
          final id = test['id'];
          final name = test['name'];
          final suiteId = test['suiteID'];
          if (id is int && name is String) {
            testNames[id] = name;
          }
          if (id is int && suiteId is int) {
            testSuites[id] = suiteId;
          }
        }
        break;
      case 'print':
        final testId = decoded['testID'];
        final message = decoded['message'];
        if (testId is int && message is String) {
          final list = testMessages.putIfAbsent(testId, () => []);
          list.add(message);
        }
        break;
      case 'error':
        final testId = decoded['testID'];
        final error = decoded['error'];
        if (testId is int && error is Map<String, dynamic>) {
          final message = error['message'];
          final stack = error['stackTrace'];
          final list = testMessages.putIfAbsent(testId, () => []);
          if (message is String && message.trim().isNotEmpty) {
            list.add(message.trim());
          }
          if (stack is String && stack.trim().isNotEmpty) {
            list.add(stack.trim());
          }
        }
        break;
      case 'testDone':
        final testId = decoded['testID'];
        final result = decoded['result'];
        final hidden = decoded['hidden'] == true;
        final skipped = decoded['skipped'] == true;
        if (hidden) {
          break;
        }

        if (testId is! int) {
          break;
        }

        if (skipped) {
          break;
        }

        if (result == 'failure' || result == 'error') {
          final name = testNames[testId] ?? 'Test $testId';
          final suiteId = testSuites[testId];
          final path = suiteId == null ? null : suitePaths[suiteId];
          final messages = testMessages[testId] ?? const [];
          failing.add(
            _TestFailure(
              name: name,
              suitePath: path,
              messages: messages,
            ),
          );
        }
        break;
      default:
        break;
    }
  }, onDone: () {
    stdoutDone.complete();
  }, onError: (Object error, StackTrace stack) {
    stderr.writeln('Error reading dart test output: $error');
    stdoutDone.completeError(error, stack);
  });

  final stderrFuture = stderr.addStream(process.stderr);

  await Future.wait([stdoutDone.future, stderrFuture]);
  final code = await process.exitCode;

  stdout.writeln();
  if (failing.isEmpty && code == 0) {
    stdout.writeln('All conformance tests passed.');
  } else if (failing.isEmpty) {
    stdout.writeln(
        'No structured failures were captured, but dart test exited with code $code.');
  } else {
    stdout.writeln('# ${failing.length} FAILING');
    for (var i = 0; i < failing.length; i++) {
      final failure = failing[i];
      stdout.writeln('  ${i + 1}. ${failure.name}');
      if (failure.suitePath != null) {
        stdout.writeln('     File: ${failure.suitePath}');
      }
      if (failure.messages.isNotEmpty) {
        for (final message in failure.messages) {
          final indented =
              message.split('\n').map((line) => '     $line').join('\n');
          stdout.writeln(indented);
        }
      }
      stdout.writeln();
    }
    stdout.writeln(
        'Tip: use `dart run dev/conformance.dart show "<test name>"` to see the full test case.');
    stdout.writeln('# ${failing.length} FAILING');
  }

  if (code != 0) {
    exit(code);
  }
}

class _TestCase {
  _TestCase({
    required this.name,
    required this.file,
    required this.startLine,
    required this.endLine,
    required this.lines,
  });

  final String name; // e.g. "Tabs - Example 1"
  final String file; // e.g. "test/commonmark_spec_test.dart"
  final int startLine; // 1-based
  final int endLine; // 1-based (inclusive)
  final List<String> lines;
}

class _TestFailure {
  _TestFailure({
    required this.name,
    this.suitePath,
    this.messages = const [],
  });

  final String name;
  final String? suitePath;
  final List<String> messages;
}

String _makeRelativePath(String path) {
  final cwd = Directory.current.absolute.path;
  final separator = Platform.pathSeparator;
  final normalizedCwd = cwd.endsWith(separator) ? cwd : '$cwd$separator';
  if (path.startsWith(normalizedCwd)) {
    return path.substring(normalizedCwd.length);
  }
  return path;
}

Future<List<_TestCase>> _loadAllTests() async {
  final all = <_TestCase>[];
  all.addAll(await _extractTestsFromFile(_commonmarkFile));
  all.addAll(await _extractTestsFromFile(_gfmFile));
  return all;
}

Future<List<_TestCase>> _extractTestsFromFile(String relativePath) async {
  final file = File(relativePath);
  if (!await file.exists()) {
    stderr.writeln('Test file not found: $relativePath');
    return const [];
  }

  final lines = await file.readAsLines();
  final cases = <_TestCase>[];

  var i = 0;
  while (i < lines.length) {
    final line = lines[i];
    final trimmed = line.trimLeft();

    if (!trimmed.startsWith('test(')) {
      i++;
      continue;
    }

    final name = _parseTestName(trimmed);
    if (name == null) {
      // Could not parse name; skip this line.
      i++;
      continue;
    }

    final startLine = i + 1; // 1-based
    final snippetLines = <String>[];
    var endLine = startLine;

    var j = i;
    for (; j < lines.length; j++) {
      snippetLines.add(lines[j]);
      if (lines[j].trim() == '});') {
        endLine = j + 1;
        break;
      }
    }

    cases.add(
      _TestCase(
        name: name,
        file: relativePath,
        startLine: startLine,
        endLine: endLine,
        lines: snippetLines,
      ),
    );

    // Continue scanning from after this test block.
    i = j + 1;
  }

  return cases;
}

String? _parseTestName(String trimmedLine) {
  // Expect something like:
  //   test('Tabs - Example 1', () {
  final marker = "test('";
  final start = trimmedLine.indexOf(marker);
  if (start == -1) return null;

  final nameStart = start + marker.length;
  final nameEnd = trimmedLine.indexOf("'", nameStart);
  if (nameEnd == -1) return null;

  return trimmedLine.substring(nameStart, nameEnd);
}

String _normaliseQuery(String pattern) {
  var q = pattern.trim();

  // Allow users to paste the full test label from `dart test`, which
  // includes the group name, e.g.:
  //   "CommonMark Spec Tests Tabs - Example 1"
  //   "GFM Extensions Spec Tests Tables - Example 1"
  for (final prefix in const [
    'CommonMark Spec Tests',
    'GFM Extensions Spec Tests',
  ]) {
    if (q.startsWith(prefix)) {
      q = q.substring(prefix.length).trimLeft();
    }
  }

  return q;
}

Future<void> _listTests(String? pattern) async {
  final all = await _loadAllTests();
  final query = pattern == null || pattern.trim().isEmpty
      ? null
      : _normaliseQuery(pattern).toLowerCase();

  final matches = query == null
      ? all
      : all.where((t) => t.name.toLowerCase().contains(query)).toList();

  if (matches.isEmpty) {
    stdout.writeln('No tests matched "${pattern ?? ''}".');
    return;
  }

  stdout.writeln('Found ${matches.length} test(s):');
  for (final t in matches) {
    stdout.writeln('  ${t.file}:${t.startLine}  ${t.name}');
  }
}

Future<void> _showTests(String pattern) async {
  final query = _normaliseQuery(pattern).toLowerCase();

  final all = await _loadAllTests();
  final matches =
      all.where((t) => t.name.toLowerCase().contains(query)).toList();

  if (matches.isEmpty) {
    stdout.writeln('No tests matched "$pattern".');
    return;
  }

  for (var idx = 0; idx < matches.length; idx++) {
    final t = matches[idx];
    if (matches.length > 1) {
      stdout.writeln('===== [${idx + 1}/${matches.length}] ${t.name} =====');
    } else {
      stdout.writeln('===== ${t.name} =====');
    }
    stdout.writeln('File: ${t.file}:${t.startLine}-${t.endLine}');
    stdout.writeln('');
    stdout.writeln(t.lines.join('\n'));
    stdout.writeln('');
  }
}
