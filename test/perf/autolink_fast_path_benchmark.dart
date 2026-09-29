// Run with: dart run test/perf/autolink_fast_path_benchmark.dart
// To compare revisions, compile this same file on each revision with
// `dart compile exe` and run both executables with identical arguments.
//
// Inputs: plain | links | email | chat | chatlinks, enabled | disabled,
// stream | static. plain/links/email are one long paragraph; chat and
// chatlinks are multi-block replies with emphasis, lists and code.
// Output: seven times in milliseconds per parse or streaming session.
import 'dart:math';

import 'package:cmark_gfm/cmark_gfm.dart';

int _sink = 0;

String _chatSection(bool withLinks) {
  final link = withLinks
      ? ' See https://example.org/docs/setup or www.example.com/help, '
          'and write to support@example.com.'
      : ' See the setup guide or the help page, and write to support.';
  return '''
## Step overview

The **first** change updates the *parser* and keeps the `CmarkNode` tree
stable while text streams in. It isn't a large change!$link

- Read the `input` and check each line: headings, lists and code.
- Keep **bold** and _italic_ runs intact, e.g. 3 * 4 = 12.
- Don't rebuild the tree when nothing changed [yet].

```dart
final parser = CmarkParser()..feed(text);
```

> Note: a quote with a `span` and a trailing question?

''';
}

String _text(String kind) {
  if (kind == 'chat' || kind == 'chatlinks') {
    return List.filled(24, _chatSection(kind == 'chatlinks')).join(); // ~13 KB
  }
  const prose =
      'A conversation reply describes each step with context and gives the user a clear and useful next action. ';
  final block = switch (kind) {
    'plain' => prose * 12,
    'links' =>
      '${prose * 6}https://example.org/guide/feature www.example.com/support ${prose * 5}',
    'email' =>
      '${prose * 6}team@example.org mailto:help@example.com ${prose * 5}',
    _ => throw ArgumentError.value(kind, 'kind'),
  };
  return List.filled(12, block).join(' '); // About 13 KB.
}

void _parse(String text, CmarkParserOptions options, bool streaming) {
  final parser = CmarkParser(options: options);
  if (streaming) {
    final initialLength = min(1800, text.length);
    parser.feed(text.substring(0, initialLength));
    _sink +=
        parser.finishClone().firstChild?.firstChild?.contentString.length ?? 0;
    var previous = initialLength;
    for (var end = initialLength + 115; end < text.length; end += 115) {
      parser.feed(text.substring(previous, end));
      _sink +=
          parser.finishClone().firstChild?.firstChild?.contentString.length ??
              0;
      previous = end;
    }
    if (previous < text.length) {
      parser.feed(text.substring(previous));
      _sink +=
          parser.finishClone().firstChild?.firstChild?.contentString.length ??
              0;
    }
  } else {
    parser.feed(text);
  }
  _sink += parser.finish().firstChild?.firstChild?.contentString.length ?? 0;
}

void main(List<String> args) {
  if (args.length != 3 ||
      !['plain', 'links', 'email', 'chat', 'chatlinks'].contains(args[0]) ||
      !['enabled', 'disabled'].contains(args[1]) ||
      !['stream', 'static'].contains(args[2])) {
    throw ArgumentError(
      'Usage: dart run test/perf/autolink_fast_path_benchmark.dart '
      '<plain|links|email|chat|chatlinks> <enabled|disabled> <stream|static>',
    );
  }
  final text = _text(args[0]);
  final options =
      CmarkParserOptions(enableAutolinkExtension: args[1] == 'enabled');
  final streaming = args[2] == 'stream';
  final iterations = streaming ? 5 : 60;

  for (var i = 0; i < (streaming ? 4 : 25); i++) {
    _parse(text, options, streaming);
  }
  for (var batch = 0; batch < 7; batch++) {
    final timer = Stopwatch()..start();
    for (var i = 0; i < iterations; i++) {
      _parse(text, options, streaming);
    }
    timer.stop();
    print(timer.elapsedMicroseconds / iterations / 1000);
  }
  if (_sink < 0) print(_sink);
}
