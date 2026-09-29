// ignore_for_file: avoid_print

// Streaming snapshot cost: one parser fed chunk by chunk, with a
// finishClone() after every chunk, as a chat UI does while a reply streams.
//
//   dart run test/perf/streaming_snapshot_benchmark.dart
//   dart run --enable-vm-service test/perf/streaming_snapshot_benchmark.dart --profile
//
// "Fresh parse" parses the whole text so far for every snapshot. It is the
// reference output and the cost of not streaming. Before timing, every
// snapshot of every fixture is checked against it.
import 'package:cmark_gfm/cmark_gfm.dart';

import 'perf_tester.dart';
import 'streaming_fixture.dart';

String _render(CmarkNode node) => HtmlRenderer().render(node);

/// Fresh parse of each prefix. Returns the last snapshot's HTML.
String _freshSession(StreamingFixture fixture) {
  var fed = '';
  CmarkNode? last;
  for (final chunk in fixture.chunks) {
    fed += chunk;
    last = (CmarkParser()..feed(fed)).finish();
  }
  return _render(last!);
}

/// One parser, one snapshot per chunk. Returns the last snapshot's HTML.
String _streamingSession(StreamingFixture fixture) {
  final parser = CmarkParser();
  CmarkNode? last;
  for (final chunk in fixture.chunks) {
    parser.feed(chunk);
    last = parser.finishClone();
  }
  return _render(last!);
}

/// Counts snapshots that differ from a fresh parse of the same text.
int _snapshotMismatches(StreamingFixture fixture) {
  final parser = CmarkParser();
  var fed = '';
  var mismatches = 0;
  for (final chunk in fixture.chunks) {
    fed += chunk;
    parser.feed(chunk);
    final snapshot = _render(parser.finishClone());
    if (snapshot != _render((CmarkParser()..feed(fed)).finish())) {
      mismatches++;
    }
  }
  return mismatches;
}

Future<void> main(List<String> args) async {
  final fixtures = [
    StreamingFixture.reply(name: 'reply 4 KB', targetLength: 4000),
    StreamingFixture.reply(name: 'reply 12 KB', targetLength: 12000, seed: 11),
    StreamingFixture.reply(name: 'reply 30 KB', targetLength: 30000, seed: 13),
  ];

  print('Snapshots that differ from a fresh parse:');
  for (final fixture in fixtures) {
    print('  $fixture: ${_snapshotMismatches(fixture)}');
  }

  final profile = args.contains('--profile');
  await PerfTester<StreamingFixture, String>.multi(
    testName: 'Streaming snapshots (one per chunk)',
    testCases: fixtures,
    implementations: [
      if (!profile) const PerfImpl('Fresh parse', _freshSession),
      const PerfImpl('finishClone', _streamingSession),
    ],
  ).run(
    warmupRuns: 3,
    benchmarkRuns: profile ? 5 : 15,
    skipEqualityCheck: profile,
    profile: profile,
    profileRuns: 10,
  );
}
