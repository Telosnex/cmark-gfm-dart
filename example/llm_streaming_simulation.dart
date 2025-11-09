import 'dart:async';
import 'package:cmark_gfm/cmark_gfm.dart';

/// Simulates how this would be used with an LLM streaming response.
///
/// Demonstrates that you can feed chunks as they arrive and get a final
/// rendered HTML document at the end, without reparsing from scratch.
Future<void> main() async {
  print('=== Simulating LLM Streaming Response ===\n');

  // Simulate an LLM response that comes in over time
  final responseChunks = [
    'I can',
    ' help you',
    ' analyze',
    ' this data',
    '.\n\n',
    '## Key',
    ' Findings',
    '\n\n',
    'The analysis',
    ' shows:\n\n',
    '1. **Performance',
    '** has improved',
    '\n2. *Latency*',
    ' decreased',
    '\n3. ~~Old approach~~',
    ' is obsolete',
    '\n\n',
    '### Metrics Table',
    '\n\n',
    '| Metric | Before | After |\n',
    '| --- | ---: | ---: |\n',
    '| Speed | 10s | 1s |\n',
    '| Memory | 500MB | 50MB |\n',
    '\n\n',
    'See footnote',
    '[^1]',
    ' for details',
    '.\n\n',
    '### Code Example',
    '\n\n',
    '```dart\n',
    'final parser = CmarkParser();\n',
    'parser.feed(chunk);\n',
    '```\n\n',
    '[^1]: This optimization was achieved through incremental parsing.',
  ];

  final parser = CmarkParser();
  var chunkCount = 0;

  print('Streaming ${responseChunks.length} chunks...\n');

  // Simulate chunks arriving over time
  for (final chunk in responseChunks) {
    await Future.delayed(Duration(milliseconds: 10)); // Simulate network latency
    parser.feed(chunk);
    chunkCount++;

    // In a real app, you might render intermediate state here
    if (chunkCount % 10 == 0) {
      print('  Received $chunkCount chunks...');
    }
  }

  print('\nStream complete! Finalizing...\n');

  // Finalize and render
  final doc = parser.finish();
  final html = HtmlRenderer().render(doc);

  print('=== Final Rendered HTML ===\n');
  print(html);

  // Verify expected content
  print('\n=== Verification ===');
  final expectations = [
    'Key Findings heading',
    'Performance improved',
    'Metrics table',
    'Code example',
    'Footnote reference',
    'Footnote content',
  ];

  var allGood = true;
  for (final expectation in expectations) {
    var found = false;
    if (expectation == 'Key Findings heading') found = html.contains('<h2>Key Findings</h2>');
    if (expectation == 'Performance improved') found = html.contains('<strong>Performance</strong>');
    if (expectation == 'Metrics table') found = html.contains('<table>');
    if (expectation == 'Code example') found = html.contains('language-dart');
    if (expectation == 'Footnote reference') found = html.contains('footnote-ref');
    if (expectation == 'Footnote content') found = html.contains('incremental parsing');

    final status = found ? '✅' : '❌';
    print('$status $expectation');
    if (!found) allGood = false;
  }

  if (allGood) {
    print('\n🎉 Perfect! All content parsed and rendered correctly!');
    print('\n📊 Performance: Processed ${responseChunks.length} chunks with NO reparsing.');
    print('💡 In the old approach, this would have required ${responseChunks.length} full parses!');
  }
}
