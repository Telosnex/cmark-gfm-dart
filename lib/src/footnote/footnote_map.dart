import 'dart:convert';

import '../node.dart';
import '../util/strbuf.dart';
import '../util/utf8.dart';

class CmarkFootnote {
  CmarkFootnote({required this.label, required this.node});
  final String label;
  final CmarkNode node;
}

class CmarkFootnoteMap {
  CmarkFootnoteMap();

  final Map<String, CmarkFootnote> _entries = {};

  int get size => _entries.length;

  void clear() => _entries.clear();

  void add(String label, CmarkNode node) {
    final normalized = _normalizeLabel(label);
    if (normalized == null || normalized.isEmpty) return;
    if (_entries.containsKey(normalized)) return;
    node.footnoteReferenceIndex = 0;
    _entries[normalized] = CmarkFootnote(label: normalized, node: node);
  }

  CmarkFootnote? lookup(String label) {
    final normalized = _normalizeLabel(label);
    if (normalized == null || normalized.isEmpty) return null;
    return _entries[normalized];
  }

  Iterable<CmarkFootnote> get entries => _entries.values;

  List<CmarkFootnote> getReferencedInOrder() {
    final referenced = _entries.values
        .where((e) => e.node.footnoteReferenceIndex > 0)
        .toList();
    referenced.sort((a, b) =>
        a.node.footnoteReferenceIndex.compareTo(b.node.footnoteReferenceIndex));
    return referenced;
  }

  // Streaming snapshots resolve the same few labels again and again, and
  // normalizing (UTF-8 encode, case fold, decode) is the expensive part.
  static final Map<String, String?> _normalized = <String, String?>{};

  static String? _normalizeLabel(String label) {
    if (label.isEmpty) return null;
    final cached = _normalized[label];
    if (cached != null || _normalized.containsKey(label)) return cached;
    if (_normalized.length >= 1024) _normalized.clear();
    return _normalized[label] = _normalizeUncached(label);
  }

  static String? _normalizeUncached(String label) {
    final buffer = CmarkStrbuf();
    CmarkUtf8.caseFold(buffer, utf8.encode(label));
    buffer.trim();
    buffer.normalizeWhitespace();
    final bytes = buffer.detach();
    if (bytes.isEmpty) return null;
    return utf8.decode(bytes, allowMalformed: true);
  }
}
