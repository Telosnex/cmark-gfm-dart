import 'package:cmark_gfm/cmark_gfm.dart';

/// Example showing how to use the streaming parser for chat/LLM applications.
///
/// This demonstrates the key advantage: you can feed chunks incrementally
/// without reparsing the entire message from scratch each time.
void main() {
  print('=== Streaming Markdown Parser Example ===\n');

  // Simulate receiving a markdown message in chunks (like from an LLM stream)
  final chunks = [
    '# Analysis Report\n\n',
    'Here are the key findings:\n\n',
    '## Summary\n\n',
    'The data shows **significant',
    '** improvement over baseline.\n\n',
    '### Metrics\n\n',
    '| Metric | Before | After |\n| --- | ---: | ---: |\n| Speed | 100ms | 50ms |\n| Memory | 200MB | 150MB |\n\n',
    '### Action Items\n\n',
    '- [x] Complete analysis\n- [ ] Review results\n- [ ] Deploy changes\n\n',
    '## Code Sample\n\n',
    '```python\ndef optimize():\n    return "faster"\n```\n\n',
    'For more info, see <http://example.com>.\n',
  ];

  final parser = CmarkParser();

  print('Feeding ${chunks.length} chunks...\n');

  // Feed each chunk as it arrives
  for (var i = 0; i < chunks.length; i++) {
    final chunk = chunks[i];
    parser.feed(chunk);
    
    // In a real app, you could render intermediate state here
    // (though the current implementation only provides final output)
    if (i % 5 == 0) {
      print('Fed chunk ${i + 1}/${chunks.length}...');
    }
  }

  // Finalize and render the complete document
  final doc = parser.finish();
  final html = HtmlRenderer().render(doc);

  print('\n=== Rendered HTML ===\n');
  print(html);

  print('\n=== Performance Note ===');
  print('Traditional approach: O(N*M) where N=message length, M=number of chunks');
  print('Streaming approach: O(N) - process each chunk only once');
  print('\nFor a 100-page message with 1000 chunks, this is ~1000x faster!');
}
