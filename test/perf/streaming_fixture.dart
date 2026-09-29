import 'dart:math' as math;

/// A synthetic LLM reply of about [targetLength] UTF-16 code units, and the
/// chunks a streaming client would receive for it.
///
/// Sections cycle through the block types that chat replies use: headings,
/// prose with inline markup and links, lists, task lists, fenced code,
/// tables, block quotes, footnote references and reference links. Footnote
/// and reference definitions are at the end, as models write them.
class StreamingFixture {
  StreamingFixture._(this.name, this.text, this.chunks);

  factory StreamingFixture.reply({
    required String name,
    required int targetLength,
    int seed = 7,
    int minChunk = 1,
    int maxChunk = 48,
  }) {
    final text = _reply(targetLength, math.Random(seed));
    return StreamingFixture._(
      name,
      text,
      _chunks(text, math.Random(seed + 1), minChunk, maxChunk),
    );
  }

  final String name;
  final String text;

  /// Consecutive pieces of [text]. Their concatenation is [text].
  final List<String> chunks;

  @override
  String toString() => '$name (${text.length} chars, ${chunks.length} chunks)';
}

List<String> _chunks(String text, math.Random rng, int minChunk, int maxChunk) {
  final chunks = <String>[];
  var start = 0;
  while (start < text.length) {
    final size = minChunk + rng.nextInt(maxChunk - minChunk + 1);
    final end = math.min(text.length, start + size);
    chunks.add(text.substring(start, end));
    start = end;
  }
  return chunks;
}

const _words = [
  'parser',
  'stream',
  'snapshot',
  'block',
  'inline',
  'token',
  'render',
  'widget',
  'layout',
  'cache',
  'reply',
  'model',
  'result',
  'value',
  'change',
  'update',
  'node',
  'tree',
  'text',
  'line',
  'user',
  'answer',
  'detail',
  'context',
  'example',
  'option',
  'measure',
  'faster',
  'simple',
  'stable',
];

String _sentence(math.Random rng, int footnotes) {
  final count = 8 + rng.nextInt(14);
  final b = StringBuffer();
  for (var i = 0; i < count; i++) {
    if (i > 0) b.write(' ');
    final word = _words[rng.nextInt(_words.length)];
    switch (rng.nextInt(24)) {
      case 0:
        b.write('**$word**');
      case 1:
        b.write('*$word*');
      case 2:
        b.write('`$word()`');
      case 3:
        b.write('[$word](https://example.com/$word)');
      case 4:
        b.write('https://docs.example.org/$word');
      case 5:
        b.write('[$word][ref${rng.nextInt(3) + 1}]');
      default:
        b.write(i == 0 ? '${word[0].toUpperCase()}${word.substring(1)}' : word);
    }
  }
  b.write('.');
  if (footnotes > 0 && rng.nextInt(3) == 0) {
    b.write('[^${rng.nextInt(footnotes) + 1}]');
  }
  return b.toString();
}

String _reply(int targetLength, math.Random rng) {
  const footnotes = 4;
  final b = StringBuffer();
  var section = 0;
  while (b.length < targetLength) {
    switch (section % 7) {
      case 0:
        b.writeln('## ${_sentence(rng, 0).replaceAll('.', '')}');
        b.writeln();
        b.writeln('${_sentence(rng, footnotes)} ${_sentence(rng, footnotes)}');
        b.writeln(_sentence(rng, footnotes));
      case 1:
        for (var i = 0; i < 3 + rng.nextInt(3); i++) {
          b.writeln('- ${_sentence(rng, footnotes)}');
        }
      case 2:
        b.writeln('```dart');
        for (var i = 0; i < 4 + rng.nextInt(6); i++) {
          b.writeln('final v$i = parser.feed(chunk$i); // ${_words[i]}');
        }
        b.writeln('```');
      case 3:
        b.writeln('| Option | Value | Notes |');
        b.writeln('| --- | :---: | ---: |');
        for (var i = 0; i < 3 + rng.nextInt(4); i++) {
          b.writeln('| `${_words[i]}` | $i | ${_sentence(rng, 0)} |');
        }
      case 4:
        for (var i = 1; i <= 3; i++) {
          b.writeln('$i. ${_sentence(rng, footnotes)}');
          b.writeln('   - [${i.isEven ? 'x' : ' '}] ${_sentence(rng, 0)}');
        }
      case 5:
        b.writeln('> ${_sentence(rng, footnotes)}');
        b.writeln('> ${_sentence(rng, 0)}');
      case 6:
        b.writeln('${_sentence(rng, footnotes)} ${_sentence(rng, footnotes)} '
            '${_sentence(rng, footnotes)}');
    }
    b.writeln();
    section++;
  }
  for (var i = 1; i <= 3; i++) {
    b.writeln('[ref$i]: https://example.com/ref$i "Reference $i"');
  }
  b.writeln();
  for (var i = 1; i <= footnotes; i++) {
    b.writeln('[^$i]: ${_sentence(rng, 0)}');
    b.writeln();
  }
  return b.toString();
}
