// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:isolate' as isolate;

import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

/// Connects to the VM service running in *this* process and collects CPU
/// profiling samples around a user-supplied block.
///
/// Requires `--enable-vm-service` when launching:
/// ```bash
/// dart run --enable-vm-service test/perf/some_perf_test.dart
/// ```
///
/// If the VM service isn't available (e.g. normal `dart run` without the
/// flag), [connect] returns `false` and the other methods are no-ops.
class PerfProfiler {
  VmService? _service;
  String? _isolateId;
  CpuSamples? _captured;

  /// Try to connect to the VM service. Returns `true` on success.
  Future<bool> connect() async {
    try {
      // getInfo() reads existing state without blocking (controlWebServer
      // hangs in the Flutter tester even with --enable-vmservice).
      print('[PerfProfiler] Calling Service.getInfo()...');
      final info = await developer.Service.getInfo();
      print('[PerfProfiler] getInfo returned: ${info.serverUri}');
      final uri = info.serverUri;
      if (uri == null) {
        print(
          '[PerfProfiler] VM service not available. '
          'Run with: dart run --enable-vm-service <script>',
        );
        return false;
      }

      // Convert HTTP URI to WebSocket URI.
      final wsUri = uri.replace(
        scheme: uri.scheme == 'https' ? 'wss' : 'ws',
        path: '${uri.path}ws',
      );

      _service = await vmServiceConnectUri(wsUri.toString()).timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            throw TimeoutException('VM service connection timed out after 5s'),
      );

      // Enable the profiler.
      await _service!.setFlag('profiler', 'true');

      // Get our own isolate ID.
      _isolateId = developer.Service.getIsolateId(isolate.Isolate.current);
      if (_isolateId == null) {
        print('[PerfProfiler] Could not determine isolate ID.');
        await _service?.dispose();
        _service = null;
        return false;
      }

      return true;
    } catch (e) {
      print('[PerfProfiler] Failed to connect: $e');
      return false;
    }
  }

  /// Clear previously collected CPU samples so the next [capture] only sees
  /// samples from the benchmark region.
  Future<void> clearSamples() async {
    if (_service == null || _isolateId == null) return;
    _captured = null;
    await _service!.clearCpuSamples(_isolateId!);
  }

  /// Fetch the samples accumulated since [clearSamples] **once**, caching them
  /// for [collectAndPrint] and [saveAsDevToolsJson].
  ///
  /// Both consumers must analyse the *same* snapshot. A `getCpuSamples`
  /// round-trip is itself expensive Dart work in this isolate — the VM
  /// resolves script/library metadata for every function, then encodes a
  /// multi-megabyte JSON response — and that work lands in this isolate's own
  /// sample buffer. So a second fetch ends up profiling the first fetch:
  /// before this snapshot was shared, the hottest leaves in the saved JSON
  /// were `dart::Library::LoadedScripts`, `dart::Script::FindLibrary` and the
  /// JSON parser (the profiler itself), while the printed table — fetched
  /// first, so unpolluted — told a completely different story.
  Future<CpuSamples?> capture() async {
    if (_service == null || _isolateId == null) return null;
    return _captured = await _service!.getCpuSamples(_isolateId!, 0, ~0);
  }

  /// Collect CPU samples and print the top-N hottest functions.
  Future<void> collectAndPrint({int topN = 20, String? label}) async {
    if (_service == null || _isolateId == null) return;

    final cpuSamples = _captured ?? await capture();
    if (cpuSamples == null) return;
    final functions = cpuSamples.functions ?? [];
    final samples = cpuSamples.samples ?? [];

    if (samples.isEmpty) {
      print('\n[PerfProfiler] No CPU samples collected.');
      return;
    }

    // Sort by exclusive ticks (self time) descending.
    final sorted = List.of(
      functions,
    )..sort((a, b) => (b.exclusiveTicks ?? 0).compareTo(a.exclusiveTicks ?? 0));

    final totalSamples = cpuSamples.sampleCount ?? samples.length;
    final period = cpuSamples.samplePeriod ?? 0; // microseconds

    final title = label != null
        ? 'CPU Profile: $label  ($totalSamples samples, $periodµs)'
        : 'CPU Profile  ($totalSamples samples, $periodµs)';
    final boxWidth = title.length + 4;
    print('');
    print('      ┌${'─' * boxWidth}┐');
    print('      │  $title  │');
    print('      └${'─' * boxWidth}┘');
    print(
      '      Self% = time in function itself.  '
      'Incl% = time in function + everything it calls.',
    );
    print(
      '      [Stub] = compiler-generated helpers '
      '(type checks, allocation, etc.).',
    );
    print('');
    print(
      '      ${'Self%'.padRight(8)}'
      '${'Incl%'.padRight(8)}'
      '${'Self'.padRight(8)}'
      '${'Incl'.padRight(8)}'
      'Function',
    );
    print('      ${'─' * 8}${'─' * 8}${'─' * 8}${'─' * 8}${'─' * 40}');

    var printed = 0;
    for (final pf in sorted) {
      if (printed >= topN) break;
      final excl = pf.exclusiveTicks ?? 0;
      final incl = pf.inclusiveTicks ?? 0;
      if (excl == 0 && incl == 0) continue;

      final exclPct = (excl / totalSamples * 100).toStringAsFixed(1);
      final inclPct = (incl / totalSamples * 100).toStringAsFixed(1);

      // Extract a readable function name.
      final funcName = _functionName(pf);
      final url = pf.resolvedUrl ?? '';
      // Shorten the URL to just the filename.
      final shortUrl = url.contains('/') ? url.split('/').last : url;

      print(
        '      ${exclPct.padLeft(5)}%  '
        '${inclPct.padLeft(5)}%  '
        '${excl.toString().padLeft(6)}  '
        '${incl.toString().padLeft(6)}  '
        '$funcName ($shortUrl)',
      );
      printed++;
    }
  }

  /// Dump the currently collected CPU samples in DevTools'
  /// `cpu-profiler` JSON shape to [path], so the file can be fed
  /// straight into `lib/features/debug_inspector/perf.py`.
  ///
  /// The DevTools schema expects an interned stackFrame tree where each
  /// node carries `{name, resolvedUrl, packageUri?, parent?}` and each
  /// sample references its leaf via `sf`. We build that tree by walking
  /// each sample's stack root→leaf and interning on
  /// `(functionIndex, parentNodeId)` so shared prefixes fold together
  /// (which is what keeps the JSON small for long-running captures).
  ///
  /// Note: `sourceLine` is omitted — the VM service returns function
  /// metadata without locations unless we fetch each `Func` individually,
  /// which would balloon into thousands of extra RPC round-trips. The
  /// perf.py analyser tolerates a missing `sourceLine` field and just
  /// skips the `Lnnn` column in those rows.
  Future<void> saveAsDevToolsJson(String path) async {
    final service = _service;
    final isolateId = _isolateId;
    if (service == null || isolateId == null) return;

    final cs = _captured ?? await capture();
    if (cs == null) return;
    final funcs = cs.functions ?? const <ProfileFunction>[];
    final samples = cs.samples ?? const <CpuSample>[];

    final stackFrames = <String, Map<String, Object?>>{};
    final intern = <String, String>{};
    var nextFrameId = 0;

    String internFrame(int funcIdx, String? parentId) {
      final key = '$funcIdx|${parentId ?? ''}';
      final existing = intern[key];
      if (existing != null) return existing;
      final id = 's${nextFrameId++}';
      intern[key] = id;

      final pf = funcs[funcIdx];
      final name = _functionName(pf);
      final url = pf.resolvedUrl ?? '';
      final frame = <String, Object?>{'name': name, 'resolvedUrl': url};
      // DevTools uses the resolved URL as packageUri for
      // package:/dart: URIs; perf.py's attribution rules key on that
      // field, so mirror the behaviour here.
      if (url.startsWith('package:') || url.startsWith('dart:')) {
        frame['packageUri'] = url;
      }
      if (parentId != null) frame['parent'] = parentId;
      stackFrames[id] = frame;
      return id;
    }

    final traceEvents = <Map<String, Object?>>[];
    for (final s in samples) {
      final stack = s.stack ?? const <int>[];
      if (stack.isEmpty) continue;
      // CpuSample.stack is ordered leaf-first (index 0 = most recent
      // frame). Walk root→leaf so interning produces a tree whose
      // root has parent == null and the leaf — the reference we want
      // on `sf` — is what internFrame() last returned.
      String? parent;
      for (var i = stack.length - 1; i >= 0; i--) {
        parent = internFrame(stack[i], parent);
      }
      traceEvents.add({
        'sf': parent,
        'tid': s.tid ?? 0,
        'ts': s.timestamp ?? 0,
      });
    }

    final dump = <String, Object?>{
      'cpu-profiler': <String, Object?>{
        'sampleCount': cs.sampleCount ?? samples.length,
        'samplePeriod': cs.samplePeriod ?? 0,
        'stackDepth': cs.maxStackDepth ?? 0,
        'timeExtentMicros': cs.timeExtentMicros ?? 0,
        'stackFrames': stackFrames,
        'traceEvents': traceEvents,
      },
    };

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(dump));
    print(
      '[PerfProfiler] Wrote DevTools profile: $path '
      '(${stackFrames.length} frames, ${traceEvents.length} samples)',
    );
  }

  /// Disconnect from the VM service.
  Future<void> dispose() async {
    await _service?.dispose();
    _service = null;
  }

  String _functionName(ProfileFunction pf) {
    final func = pf.function;
    if (func is FuncRef) {
      final owner = func.owner;
      if (owner is ClassRef) {
        return '${owner.name}.${func.name}';
      }
      return func.name ?? '?';
    }
    if (func is NativeFunction) {
      return func.name ?? '[native]';
    }
    // Fallback: try .name via dynamic, else toString.
    try {
      return (func).name as String;
    } catch (_) {
      return func.toString();
    }
  }
}
