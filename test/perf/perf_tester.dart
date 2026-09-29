// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'perf_profiler.dart';

/// A named implementation entry for [PerfTester].
class PerfImpl<Input, Output> {
  final String name;
  final FutureOr<Output?> Function(Input) fn;
  const PerfImpl(this.name, this.fn);
}

/// Small utility for comparing implementations on the same inputs.
///
/// Supports one or more implementations (a single implementation is allowed
/// for pure measurement/profiling runs). When two or more are given, the
/// first implementation in the list is treated as the **baseline** for
/// comparison.
///
/// ## Two-implementation usage (original API)
///
/// ```dart
/// final tester = PerfTester<String, dynamic>(
///   testName: 'my test',
///   testCases: inputs,
///   implementation1: fnA,
///   implementation2: fnB,
///   impl1Name: 'Baseline',
///   impl2Name: 'Candidate',
/// );
/// ```
///
/// ## Multi-implementation usage
///
/// ```dart
/// final tester = PerfTester<String, dynamic>.multi(
///   testName: 'my test',
///   testCases: inputs,
///   implementations: [
///     PerfImpl('Baseline', fnA),
///     PerfImpl('Candidate B', fnB),
///     PerfImpl('Candidate C', fnC),
///   ],
/// );
/// ```
///
/// It verifies output parity first, then runs a warmup phase and a benchmark
/// phase, finally printing a human-readable summary of the results.
///
/// ## Testing after you've already edited the file
///
/// The most common scenario: you've already changed a method and want to
/// benchmark old vs new. The old code lives in `git diff` — here's how to
/// recover it.
///
/// 1. **Extract the old version** next to the current one:
///    ```bash
///    # Dump the committed (pre-edit) file:
///    git show HEAD:lib/path/to/foo.dart > test/perf/foo_old.dart
///    ```
///    Then trim it to just the function(s) you care about. Remove
///    framework imports that won't resolve in a plain `dart run` context.
///
/// 2. **Extract the new version** the same way — copy the function(s) from
///    the working-tree file into `test/perf/foo_new.dart`.
///
///    Why copy both instead of importing the real file? If the real file
///    has framework imports (Flutter, provider, etc.) and you want to run
///    outside Flutter, standalone copies keep the test runnable with
///    `dart run`. If you're fine using `flutter test`, you can import
///    the real file directly.
///
/// 3. **Make private methods public** in the copies. The copies are
///    throwaway test scaffolding — visibility doesn't matter.
///
/// 4. **Import with prefixes** in your perf test:
///    ```dart
///    import 'foo_old.dart' as old;
///    import 'foo_new.dart' as current;
///    ```
///
/// 5. **Wire into PerfTester** as `implementation1` / `implementation2`
///    or entries in the `implementations` list.
///
/// 6. **Run:**
///    ```bash
///    # Pure Dart:
///    dart run test/perf/some_perf_test.dart
///
///    # Flutter (code imports flutter packages):
///    flutter test test/perf/some_perf_test.dart
///
///    # Flutter + CPU profiling:
///    flutter test --enable-vmservice --no-dds test/perf/some_perf_test.dart
///    ```
class PerfTester<Input, Output> {
  /// A short label used in the benchmark output.
  final String testName;

  /// Inputs that will be fed to all implementations.
  final List<Input> testCases;

  /// All implementations being compared. The first is the baseline.
  final List<PerfImpl<Input, Output>> implementations;

  /// Optional custom equality check for result comparison.
  final bool Function(Output?, Output?)? equalityCheck;

  /// Stable RNG used to select warmup inputs reproducibly.
  final _random = math.Random(42);

  /// Measured runtime samples per implementation, in milliseconds.
  /// Index corresponds to [implementations] index.
  late final List<List<double>> implTimes = List.generate(
    implementations.length,
    (_) => <double>[],
  );

  // Legacy accessors for 2-impl callers.
  List<double> get impl1Times => implTimes[0];
  List<double> get impl2Times =>
      implTimes.length > 1 ? implTimes[1] : implTimes[0];

  /// Original constructor: compares exactly two implementations.
  PerfTester({
    required this.testName,
    required this.testCases,
    required FutureOr<Output?> Function(Input) implementation1,
    required FutureOr<Output?> Function(Input) implementation2,
    String impl1Name = 'Original',
    String impl2Name = 'Optimized',
    this.equalityCheck,
  }) : implementations = [
         PerfImpl(impl1Name, implementation1),
         PerfImpl(impl2Name, implementation2),
       ];

  /// Multi-implementation constructor: measures one or more implementations.
  /// With two or more, the first in the list is the baseline.
  PerfTester.multi({
    required this.testName,
    required this.testCases,
    required this.implementations,
    this.equalityCheck,
  }) : assert(implementations.isNotEmpty, 'Need at least 1 implementation');

  // ── Output helpers ──────────────────────────────────────────────────

  static const _ruleDouble =
      '══════════════════════════════════════════════════════';
  static const _ruleSingle =
      '──────────────────────────────────────────────────────';

  void _header(String title) {
    print('');
    print(_ruleDouble);
    print(' PerfTester: $title');
    print(_ruleDouble);
  }

  void _step(int n, int total, String msg) {
    print('');
    print('[$n/$total] $msg');
  }

  void _sub(String msg) => print('      $msg');

  // ── Public entry point ──────────────────────────────────────────────

  /// Runs the full comparison flow.
  ///
  /// The default flow is: verify outputs, warm up all implementations, then
  /// benchmark them and print a summary.
  ///
  /// ## CPU profiling
  ///
  /// Set [profile] to `true` to collect a CPU sample profile during the
  /// benchmark phase and print the top-N hottest functions afterward.
  ///
  /// ### Pure Dart tests
  ///
  /// ```bash
  /// dart run --enable-vm-service test/perf/some_perf_test.dart
  /// ```
  ///
  /// ### Flutter tests (code depends on Flutter)
  ///
  /// Flutter tests need two extra flags and one code change:
  ///
  /// ```bash
  /// flutter test --enable-vmservice --no-dds test/perf/some_perf_test.dart
  /// ```
  ///
  /// Why both flags:
  /// - `--enable-vmservice` starts the VM service (off by default in tests).
  /// - `--no-dds` disables the Dart Development Service, which otherwise
  ///   puts the VM service in single-client mode and silently drops our
  ///   WebSocket connection (causing an infinite hang).
  ///
  /// In your test, pass `tester.runAsync` to escape the fake async zone
  /// that Flutter's test framework uses. Without it, the VM service
  /// WebSocket connection (real I/O) never completes:
  ///
  /// ```dart
  /// testWidgets('perf', (tester) async {
  ///   await myTester.run(
  ///     profile: true,
  ///     runAsync: tester.runAsync,
  ///   );
  /// });
  /// ```
  ///
  /// Only the VM-service I/O (connect/clear/collect) runs inside `runAsync`;
  /// implementation invocations run in the normal test zone, so impls that
  /// call `tester.pump*` are fine.
  ///
  /// Without the VM service flags, profiling is silently skipped and the
  /// benchmark runs normally.
  ///
  /// [profileSaveDir], when set, additionally writes each implementation's
  /// samples as DevTools cpu-profiler JSON to
  /// `<profileSaveDir>/cpu_profile_<implName>.json` for offline analysis.
  Future<void> run({
    int warmupRuns = 100,
    int benchmarkRuns = 100,
    bool skipEqualityCheck = false,
    bool profile = false,
    int profileTopN = 50,
    int profileRuns = 100,
    String? profileSaveDir,

    /// Pass `tester.runAsync` when running inside a Flutter widget test.
    /// Real I/O (VM service connection) needs to escape the fake async zone.
    Future<T?> Function<T>(
      Future<T> Function() callback, {
      Duration additionalTime,
    })?
    runAsync,
  }) async {
    final totalSteps = 2 + (skipEqualityCheck ? 0 : 1) + (profile ? 1 : 0);
    var step = 0;

    _header(testName);
    final steps = [
      if (!skipEqualityCheck) 'Verify',
      'Warmup',
      'Benchmark',
      if (profile) 'Profile (×${implementations.length})',
    ];
    print(' Implementations: ${implementations.map((e) => e.name).join(', ')}');
    print(' Steps: ${steps.join(' → ')}');
    print(_ruleSingle);

    // ── Verify ──
    if (!skipEqualityCheck) {
      step++;
      _step(
        step,
        totalSteps,
        'Verify: checking all implementations produce identical output...',
      );
      await _verifyImplementations();
    }

    // ── Warmup ──
    step++;
    _step(
      step,
      totalSteps,
      'Warmup: $warmupRuns randomly selected test case${warmupRuns == 1 ? '' : 's'}...',
    );
    await _warmup(warmupRuns);

    // ── Benchmark ──
    step++;
    _step(
      step,
      totalSteps,
      'Benchmark: $benchmarkRuns run${benchmarkRuns == 1 ? '' : 's'}, ${testCases.length} test case${testCases.length == 1 ? '' : 's'} each...',
    );
    await _benchmark(benchmarkRuns);
    _printResults();

    // ── Profile ──
    if (profile) {
      step++;

      // Real I/O (VM service websocket) must run outside the fake async
      // zone; implementation invocations must stay INSIDE it (widget-test
      // impls call tester.pump*, which is illegal within runAsync).
      Future<T?> io<T>(Future<T> Function() fn) {
        if (runAsync != null) return runAsync(fn);
        return fn();
      }

      final profiler = PerfProfiler();
      final connected = await io(profiler.connect) ?? false;
      if (connected) {
        _step(
          step,
          totalSteps,
          'Profile: running each implementation separately...',
        );
        for (final impl in implementations) {
          await io(profiler.clearSamples);
          for (int r = 0; r < profileRuns; r++) {
            for (final input in testCases) {
              await _invoke(impl.fn, input);
            }
          }
          // One snapshot, shared by the printed table and the saved JSON:
          // fetching twice makes the second fetch profile the first.
          await io(profiler.capture);
          await io(
            () => profiler.collectAndPrint(topN: profileTopN, label: impl.name),
          );
          if (profileSaveDir != null) {
            final safeName = impl.name.replaceAll(
              RegExp(r'[^A-Za-z0-9_-]'),
              '_',
            );
            await io(
              () => profiler.saveAsDevToolsJson(
                '$profileSaveDir/cpu_profile_$safeName.json',
              ),
            );
          }
        }
        await io(profiler.dispose);
      } else {
        _step(step, totalSteps, 'Profile: skipped (VM service not available).');
      }
    }
  }

  // ── Verify ────────────────────────────────────────────────────────────

  /// Executes all implementations for every test case and checks that the
  /// outputs match the baseline (first implementation).
  Future<void> _verifyImplementations() async {
    var allEqual = true;
    final baseline = implementations[0];

    for (var i = 0; i < testCases.length; i++) {
      final input = testCases[i];
      final baseResult = await _invoke(baseline.fn, input);
      final baseEncoded = _safeEncode(baseResult);

      for (var k = 1; k < implementations.length; k++) {
        final impl = implementations[k];
        final result = await _invoke(impl.fn, input);
        final encoded = _safeEncode(result);
        final isEqual = equalityCheck != null
            ? equalityCheck!(baseResult, result)
            : baseEncoded == encoded;

        if (!isEqual) {
          _sub('❌ Mismatch on test case $i: ${baseline.name} vs ${impl.name}');
          _sub('Input: $input');

          if (baseEncoded.length > 1000 || encoded.length > 1000) {
            _printStringDiff(
              baseEncoded,
              encoded,
              labelA: baseline.name,
              labelB: impl.name,
            );
          } else {
            _sub('${baseline.name}: $baseEncoded');
            _sub('${impl.name}: $encoded');
          }
          allEqual = false;
        }
      }
    }

    if (allEqual) {
      _sub(
        '✅ All ${testCases.length} test case${testCases.length == 1 ? '' : 's'} match across ${implementations.length} implementations.',
      );
    } else {
      _sub('❌ Differences found in outputs!');
    }
  }

  // ── Warmup ────────────────────────────────────────────────────────────

  /// Performs a short warmup using random test cases to reduce cold-start
  /// effects before the timed benchmark begins.
  Future<void> _warmup(int runs) async {
    final sw = Stopwatch()..start();
    for (var i = 0; i < runs; i++) {
      final input = testCases[_random.nextInt(testCases.length)];
      for (final impl in implementations) {
        await _invoke(impl.fn, input);
      }
    }
    sw.stop();
    _sub('Done (${sw.elapsedMilliseconds} ms).');
  }

  // ── Benchmark ─────────────────────────────────────────────────────────

  /// Measures all implementations across the full test suite.
  ///
  /// The order of implementations is rotated each run to reduce bias from
  /// cache or VM effects.
  Future<void> _benchmark(int runs) async {
    final n = implementations.length;

    for (var run = 0; run < runs; run++) {
      final runIterationSw = Stopwatch()..start();

      // Build a rotated order for this run to reduce ordering bias.
      final order = List.generate(n, (k) => (k + run) % n);

      final stopwatches = List.generate(n, (_) => Stopwatch());

      for (final idx in order) {
        final sw = stopwatches[idx]..start();
        for (var input in testCases) {
          await _invoke(implementations[idx].fn, input);
        }
        sw.stop();
      }

      for (var idx = 0; idx < n; idx++) {
        implTimes[idx].add(stopwatches[idx].elapsedMicroseconds / 1000.0);
      }

      runIterationSw.stop();
      // Print at most 10 progress messages.
      final printStep = math.max(1, runs ~/ 10);
      if ((run + 1) % printStep == 0 || run == runs - 1) {
        _sub(
          'Run ${run + 1}/$runs (${runIterationSw.elapsedMilliseconds} ms).',
        );
      }
    }
  }

  Future<Output?> _invoke(
    FutureOr<Output?> Function(Input) implementation,
    Input input,
  ) async {
    final result = implementation(input);
    if (result is Future<Output?>) {
      return await result;
    }
    return result;
  }

  // ── Results ───────────────────────────────────────────────────────────

  /// Prints the final timing summary and a distribution view.
  void _printResults() {
    _printStats();
    _printVisualizations();
  }

  /// Prints aggregate statistics for all implementations, comparing each
  /// against the baseline (first implementation).
  void _printStats() {
    final n = implementations.length;

    // Sort each timing list for percentile calculations.
    for (final times in implTimes) {
      times.sort();
    }

    double mean(List<double> list) =>
        list.reduce((a, b) => a + b) / list.length;
    double median(List<double> list) => list.length.isOdd
        ? list[list.length ~/ 2]
        : (list[list.length ~/ 2 - 1] + list[list.length ~/ 2]) / 2;
    double stdDev(List<double> list, double m) {
      var squaredDiffs = list.map((x) => math.pow(x - m, 2));
      return math.sqrt(
        squaredDiffs.reduce((a, b) => a + b) / (list.length - 1),
      );
    }

    // Pre-compute stats for each implementation.
    final means = <double>[];
    final medians = <double>[];
    final stdDevs = <double>[];
    final totals = <double>[];
    final opsPerSecs = <double>[];

    for (var k = 0; k < n; k++) {
      final times = implTimes[k];
      final m = mean(times);
      means.add(m);
      medians.add(median(times));
      stdDevs.add(stdDev(times, m));
      final total = times.reduce((a, b) => a + b);
      totals.add(total);
      final totalOps = times.length * testCases.length;
      opsPerSecs.add((totalOps / total) * 1000);
    }

    // Helper function to format numbers intelligently
    String formatNumber(double value) {
      if (value >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(2)}M';
      } else if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(2)}K';
      } else if (value >= 100) {
        return value.toStringAsFixed(1);
      } else if (value >= 10) {
        return value.toStringAsFixed(2);
      } else {
        return value.toStringAsFixed(3);
      }
    }

    // Metrics: label → values per implementation
    final metrics = {
      'Total Time (ms)': totals,
      'Ops/Second': opsPerSecs,
      'Min (ms)': [for (var k = 0; k < n; k++) implTimes[k].first],
      'Max (ms)': [for (var k = 0; k < n; k++) implTimes[k].last],
      'Median (ms)': medians,
      'Mean (ms)': means,
      'Std Dev (ms)': stdDevs,
    };

    final names = implementations.map((e) => e.name).toList();

    final maxLabelWidth =
        metrics.keys.map((label) => label.length).reduce(math.max) + 2;

    // Column widths per implementation.
    final colWidths = <int>[];
    for (var k = 0; k < n; k++) {
      var maxW = names[k].length;
      for (final vals in metrics.values) {
        final v = vals[k];
        final formatted = v >= 1000 ? formatNumber(v) : v.toStringAsFixed(3);
        if (formatted.length > maxW) maxW = formatted.length;
      }
      colWidths.add(maxW + 2);
    }

    print('');
    _sub('Results:');

    // Header row.
    final headerBuf = StringBuffer(''.padRight(maxLabelWidth));
    for (var k = 0; k < n; k++) {
      headerBuf.write(names[k].padRight(colWidths[k]));
    }
    if (n > 1) headerBuf.write('vs ${names[0]}');
    _sub(headerBuf.toString());

    // Row printer.
    void printRow(
      String label,
      List<double> vals, {
      bool formatLarge = false,
      bool higherIsBetter = false,
    }) {
      final buf = StringBuffer(label.padRight(maxLabelWidth));
      for (var k = 0; k < n; k++) {
        final formatted = formatLarge
            ? formatNumber(vals[k])
            : vals[k].toStringAsFixed(3);
        buf.write(formatted.padRight(colWidths[k]));
      }

      // Comparison: each non-baseline vs baseline.
      final comparisons = <String>[];
      for (var k = 1; k < n; k++) {
        // ignore: avoid-accessing-collections-by-constant-index
        final baseVal = vals[0];
        final implVal = vals[k];

        var improvement = ((baseVal - implVal) / baseVal * 100);
        var speedupFactor = baseVal / implVal;

        if (higherIsBetter) {
          improvement = -improvement;
          speedupFactor = 1 / speedupFactor;
        }

        String comp;
        if (improvement > 0) {
          String speedupStr = speedupFactor.isInfinite
              ? 'Infinity'
              : speedupFactor.toStringAsFixed(1);
          comp = '↑${improvement.toStringAsFixed(1)}% (${speedupStr}x faster)';
        } else if (improvement < 0) {
          comp =
              '↓${(-improvement).toStringAsFixed(1)}% (${(1 / speedupFactor).toStringAsFixed(1)}x slower)';
        } else {
          comp = 'No difference';
        }
        comparisons.add('${names[k]}: $comp');
      }
      buf.write(comparisons.join('  '));
      _sub(buf.toString());
    }

    printRow('Total Time (ms):', totals);
    printRow(
      'Ops/Second:',
      opsPerSecs,
      formatLarge: true,
      higherIsBetter: true,
    );
    printRow('Min (ms):', metrics['Min (ms)']!);
    printRow('Max (ms):', metrics['Max (ms)']!);
    printRow('Median (ms):', medians);
    printRow('Mean (ms):', means);
    printRow('Std Dev (ms):', stdDevs);
  }

  /// Prints histogram-style timing visualizations for all implementations.
  void _printVisualizations() {
    if (implTimes.any((t) => t.isEmpty)) return;
    // With a single sample (or identical samples) there is no range to bin;
    // binSize would be 0 and produce NaN.
    final totalSamples = implTimes.fold(0, (a, t) => a + t.length);
    if (totalSamples < 2) return;

    // Compute shared range across all implementations.
    final allSorted = <List<double>>[];
    for (final times in implTimes) {
      allSorted.add(List.of(times)..sort());
    }

    var visMin = allSorted.map((s) => s.first).reduce(math.min);
    var visMax =
        allSorted.map((s) => s[(s.length * 0.99).floor()]).reduce(math.max) *
        1.2;
    final absMax = allSorted.map((s) => s.last).reduce(math.max);
    if (visMax > absMax) visMax = absMax;

    final binCount = 30;
    final binSize = (visMax - visMin) / binCount;
    if (binSize <= 0 || !binSize.isFinite) return;

    String formatValue(double val) {
      if (val < 0.001) return val.toStringAsFixed(6);
      if (val < 0.01) return val.toStringAsFixed(4);
      if (val < 0.1) return val.toStringAsFixed(3);
      if (val < 1) return val.toStringAsFixed(2);
      return val.toStringAsFixed(1);
    }

    // Build all histograms first to find global max count.
    final histograms = <List<int>>[];
    final outlierCounts = <int>[];
    for (final times in implTimes) {
      final hist = List.filled(binCount, 0);
      var outliers = 0;
      for (var value in times) {
        if (value > visMax) {
          outliers++;
          continue;
        }
        var bin = ((value - visMin) / binSize).floor();
        bin = math.min(math.max(bin, 0), binCount - 1);
        hist[bin]++;
      }
      histograms.add(hist);
      outlierCounts.add(outliers);
    }

    var maxCount = 0;
    for (final hist in histograms) {
      final m = hist.reduce(math.max);
      if (m > maxCount) maxCount = m;
    }

    // Pad label to the longest implementation name (min 15).
    final maxNameLen = implementations
        .map((e) => e.name.length)
        .reduce(math.max);
    final labelWidth = math.max(15, maxNameLen + 1);

    String getDistributionLine(
      List<int> hist,
      String label,
      int outlierCount,
      double min,
      double max,
    ) {
      var line = StringBuffer();
      line.write('${label.padRight(labelWidth)}│');

      // Use square root scaling for better visibility
      for (var count in hist) {
        var heightRatio = count == 0
            ? 0
            : math.sqrt(count) / math.sqrt(maxCount);
        var height = (heightRatio * 8).round();
        var char = switch (height) {
          0 => ' ',
          1 => '▁',
          2 => '▂',
          3 => '▃',
          4 => '▄',
          5 => '▅',
          6 => '▆',
          7 => '▇',
          _ => '█',
        };
        line.write(char);
      }
      line.write('│');

      // Add statistics
      line.write(' n=${hist.reduce((a, b) => a + b)}');
      if (outlierCount > 0) line.write(' (+$outlierCount)');
      line.write(' [${formatValue(min)}-${formatValue(max)}ms]');

      return line.toString();
    }

    print('');
    _sub(
      'Distribution (showing ${formatValue(visMin)}-${formatValue(visMax)}ms):',
    );
    for (var k = 0; k < implementations.length; k++) {
      final sorted = allSorted[k];
      _sub(
        getDistributionLine(
          histograms[k],
          implementations[k].name,
          outlierCounts[k],
          sorted.first,
          sorted.last,
        ),
      );
    }
  }
}

/// Encodes a value for comparison, falling back to `toString()` if JSON
/// encoding is not possible.
String _safeEncode(Object? value) {
  try {
    return jsonEncode(value);
  } catch (_) {
    return value?.toString() ?? 'null';
  }
}

/// Prints a compact diff between two long strings by showing the common
/// prefix/suffix and the differing middle segments with context.
void _printStringDiff(
  String a,
  String b, {
  String labelA = 'A',
  String labelB = 'B',
  // rationale: clarity for callers
  // ignore: avoid-never-passed-parameters
  int context = 200,
  // ignore: avoid-never-passed-parameters
  int maxMiddle = 600,
}) {
  // Find common prefix
  final minLen = a.length < b.length ? a.length : b.length;
  var prefix = 0;
  while (prefix < minLen && a.codeUnitAt(prefix) == b.codeUnitAt(prefix)) {
    prefix++;
  }

  // Find common suffix without overlapping the prefix
  var suffix = 0;
  while (suffix < minLen - prefix &&
      a.codeUnitAt(a.length - 1 - suffix) ==
          b.codeUnitAt(b.length - 1 - suffix)) {
    suffix++;
  }

  final aMidStart = prefix;
  final aMidEnd = a.length - suffix;
  final bMidStart = prefix;
  final bMidEnd = b.length - suffix;

  String safeSlice(String s, int start, int end) {
    if (start < 0) start = 0;
    if (end > s.length) end = s.length;
    if (start > end) start = end;
    return s.substring(start, end);
  }

  // Limit middle segments to maxMiddle each for readability
  final aMid = safeSlice(
    a,
    aMidStart,
    (aMidStart + maxMiddle).clamp(0, aMidEnd),
  );
  final bMid = safeSlice(
    b,
    bMidStart,
    (bMidStart + maxMiddle).clamp(0, bMidEnd),
  );

  // Metadata
  print('--- Diff summary ---');
  print('Lengths: $labelA=${a.length}, $labelB=${b.length}');
  print('Common prefix: $prefix chars, Common suffix: $suffix chars');

  // Show diff with context
  if (prefix > 0) {
    final prefixSnippet = safeSlice(
      a,
      (prefix - context).clamp(0, a.length),
      prefix,
    );

    print('...${prefixSnippet.replaceAll('\n', '\\n')}');
  }
  print('<<< $labelA differs >>>');
  print(aMid.replaceAll('\n', '\\n'));
  print('>>> $labelB differs <<<');
  print(bMid.replaceAll('\n', '\\n'));
  if (suffix > 0) {
    final hasSuffixEllipsis = suffix > context;

    final suffixSnippet = safeSlice(
      a,
      a.length - suffix,
      (a.length - suffix + context).clamp(0, a.length),
    );
    print(
      '${suffixSnippet.replaceAll('\n', '\\n')}${hasSuffixEllipsis ? '...' : ''}',
    );
  }
  print('--- End diff ---');
}
