import 'dart:convert';

import 'package:cmark_gfm/src/util/strbuf.dart';
import 'package:cmark_gfm/src/util/utf8.dart';
import 'node2.dart';

class CmarkFootnote2 {
  CmarkFootnote2({required this.label, required this.node});
  final String label;
  final CmarkNode2 node;
}

class CmarkFootnoteMap2 {
  CmarkFootnoteMap2();

  final Map<String, CmarkFootnote2> _entries = {};

  int get size => _entries.length;

  void add(String label, CmarkNode2 node) {
    final normalized = _normalizeLabel(label);
    if (normalized == null || normalized.isEmpty) return;
    if (_entries.containsKey(normalized)) return;
    node.footnoteReferenceIndex = 0;
    _entries[normalized] = CmarkFootnote2(label: normalized, node: node);
  }

  CmarkFootnote2? lookup(String label) {
    final normalized = _normalizeLabel(label);
    if (normalized == null || normalized.isEmpty) return null;
    return _entries[normalized];
  }

  Iterable<CmarkFootnote2> get entries => _entries.values;

  List<CmarkFootnote2> getReferencedInOrder() {
    final referenced = _entries.values
        .where((e) => e.node.footnoteReferenceIndex > 0)
        .toList();
    referenced.sort((a, b) =>
        a.node.footnoteReferenceIndex.compareTo(b.node.footnoteReferenceIndex));
    return referenced;
  }

  static String? _normalizeLabel(String label) {
    if (label.isEmpty) return null;
    final buffer = CmarkStrbuf();
    CmarkUtf8.caseFold(buffer, utf8.encode(label));
    buffer.trim();
    buffer.normalizeWhitespace();
    final bytes = buffer.detach();
    if (bytes.isEmpty) return null;
    return utf8.decode(bytes, allowMalformed: true);
  }
}
