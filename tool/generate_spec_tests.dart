import 'dart:io';

/// Regenerates the CommonMark and GFM extension spec tests directly from the
/// upstream cmark-gfm repository.
///
/// Optional environment variables:
///   * `COMMONMARK_SPEC_PATH` – override path to `test/spec.txt`
///   * `GFM_SPEC_PATH`        – override path to `test/extensions.txt`
Future<void> main(List<String> args) async {
  final suites = args.isEmpty ? const ['commonmark', 'gfm'] : args;

  if (suites.contains('commonmark')) {
    _generateCommonmark();
  }
  if (suites.contains('gfm')) {
    _generateGfm();
  }
}

void _generateGfm() {
  final specPath = Platform.environment['GFM_SPEC_PATH'] ??
      '${Directory.current.parent.path}/cmark-gfm/test/extensions.txt';
  final specFile = File(specPath);
  if (!specFile.existsSync()) {
    stderr.writeln('Unable to locate extensions spec at $specPath');
    exitCode = 1;
    return;
  }

  final raw = specFile.readAsStringSync();
  final examples = _parseExamples(raw, suitePrefix: 'GFM');
  if (examples.isEmpty) {
    stderr.writeln('No examples found in ${specFile.path}');
    exitCode = 1;
    return;
  }

  final out = StringBuffer()
    ..writeln("import 'package:cmark_gfm/cmark_gfm.dart';")
    ..writeln("import 'package:test/test.dart';")
    ..writeln()
    ..writeln('// Generated from cmark-gfm/test/extensions.txt')
    ..writeln('// DO NOT EDIT - regenerate with tool/generate_spec_tests.dart')
    ..writeln()
    ..writeln('CmarkParser _createGfmParser() => CmarkParser(')
    ..writeln('      options: const CmarkParserOptions(')
    ..writeln('        enableAutolinkExtension: true,')
    ..writeln('      ),')
    ..writeln('    );')
    ..writeln()
    ..writeln('void _expectHtml(String actual, String expected) {')
    ..writeln("  if (expected.trim() == '<IGNORE>') return;")
    ..writeln('  expect(actual.trim(), expected.trim());')
    ..writeln('}')
    ..writeln()
    ..writeln('String _renderGfmHtml(CmarkNode doc) =>')
    ..writeln('    HtmlRenderer(filterHtml: true).render(doc);')
    ..writeln()
    ..writeln('void main() {')
    ..writeln("  group('GFM Extensions Spec Tests', () {");

  for (final example in examples) {
    out
      ..writeln("    test('${_escapeSingle(example.name)}', () {")
      ..writeln(
          "      final markdown = '''${_escapeTriple(example.markdown)}''';")
      ..writeln("      final expected = '''${_escapeTriple(example.html)}''';")
      ..writeln()
      ..writeln('      final parser = _createGfmParser();')
      ..writeln('      parser.feed(markdown);')
      ..writeln('      final doc = parser.finish();')
      ..writeln('      final html = _renderGfmHtml(doc);')
      ..writeln()
      ..writeln('      _expectHtml(html, expected);')
      ..writeln('    });')
      ..writeln();
  }

  out
    ..writeln('  });')
    ..writeln('}');

  File('test/gfm_spec_test.dart').writeAsStringSync(out.toString());
  stdout.writeln('Generated ${examples.length} GFM tests.');
}

void _generateCommonmark() {
  final specPath = Platform.environment['COMMONMARK_SPEC_PATH'] ??
      '${Directory.current.parent.path}/cmark-gfm/test/spec.txt';
  final specFile = File(specPath);
  if (!specFile.existsSync()) {
    stderr.writeln('Unable to locate CommonMark spec at $specPath');
    exitCode = 1;
    return;
  }

  final raw = specFile.readAsStringSync();
  final allExamples = _parseExamples(raw, suitePrefix: 'CommonMark');
  final examples = allExamples.where((ex) => ex.extensions.isEmpty).toList();
  if (examples.isEmpty) {
    stderr.writeln('No CommonMark examples found in ${specFile.path}');
    exitCode = 1;
    return;
  }

  final out = StringBuffer()
    ..writeln("import 'package:cmark_gfm/cmark_gfm.dart';")
    ..writeln("import 'package:test/test.dart';")
    ..writeln()
    ..writeln('// Generated from cmark-gfm/test/spec.txt')
    ..writeln('// DO NOT EDIT - regenerate with tool/generate_spec_tests.dart')
    ..writeln()
    ..writeln('void main() {')
    ..writeln("  group('CommonMark Spec Tests', () {");

  for (final example in examples) {
    out
      ..writeln("    test('${_escapeSingle(example.name)}', () {")
      ..writeln(
          "      final markdown = '''${_escapeTriple(example.markdown)}''';")
      ..writeln("      final expected = '''${_escapeTriple(example.html)}''';")
      ..writeln()
      ..writeln('      final parser = CmarkParser();')
      ..writeln('      parser.feed(markdown);')
      ..writeln('      final doc = parser.finish();')
      ..writeln('      final html = HtmlRenderer().render(doc);')
      ..writeln()
      ..writeln('      expect(html.trim(), expected.trim());')
      ..writeln('    });')
      ..writeln();
  }

  out
    ..writeln('  });')
    ..writeln('}');

  File('test/commonmark_spec_test.dart').writeAsStringSync(out.toString());
  stdout.writeln('Generated ${examples.length} CommonMark tests.');
}

class _Example {
  _Example(this.name, this.markdown, this.html, this.extensions);
  final String name;
  final String markdown;
  final String html;
  final List<String> extensions;
}

List<_Example> _parseExamples(String raw, {required String suitePrefix}) {
  final lines = raw.split('\n');
  final examples = <_Example>[];
  var section = suitePrefix;
  final counts = <String, int>{};

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.startsWith('## ')) {
      section = line.substring(3).trim();
      continue;
    }
    final trimmed = line.trim();
    final startMatch = RegExp(r'^(\`+)[ \t]+example(?:[ \t]+(.*))?$',
            multiLine: false)
        .firstMatch(trimmed);
    if (startMatch == null) {
      if (trimmed.startsWith('## ')) {
        section = trimmed.substring(3).trim();
      }
      continue;
    }

    final openingFence = startMatch.group(1)!;
    final closingFence = '`' * openingFence.length;
    final extensionTokens = (startMatch.group(2) ?? '').trim();
    final extensions = extensionTokens.isEmpty
        ? <String>[]
        : extensionTokens.split(RegExp(r'\s+'));
    if (extensions.contains('disabled')) {
      continue;
    }

    final markdown = <String>[];
    i++;
    while (i < lines.length && lines[i] != '.') {
      markdown.add(lines[i]);
      i++;
    }
    if (i >= lines.length) break;

    final html = <String>[];
    i++; // skip '.'
    while (i < lines.length && !lines[i].contains(closingFence)) {
      html.add(lines[i]);
      i++;
    }

    final count = (counts[section] ?? 0) + 1;
    counts[section] = count;
    final name = '$section - Example $count';

    examples.add(_Example(
      name,
      _detab(markdown.join('\n')),
      _detab(html.join('\n')),
      extensions,
    ));
  }

  return examples;
}

String _detab(String input) => input.replaceAll('→', '\t');

String _escapeTriple(String input) => input
    .replaceAll('\\', r'\\')
    .replaceAll("'''", "''\'")
    .replaceAll(r'$', r'\$');

String _escapeSingle(String input) => input.replaceAll("'", r"\'");
