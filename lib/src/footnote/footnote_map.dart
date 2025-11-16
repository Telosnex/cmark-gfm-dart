import 'dart:convert';

import '../node.dart';
import '../util/strbuf.dart';
import '../util/utf8.dart';

class CmarkFootnote {
  CmarkFootnote({
    required this.label,
    required this.node,
  });

  final String label;
  final CmarkNode node;
}

class CmarkFootnoteMap {
  CmarkFootnoteMap();

  final Map<String, CmarkFootnote> _entries = <String, CmarkFootnote>{};

  int get size => _entries.length;

  void add(String label, CmarkNode node) {
    final normalized = _normalizeLabel(label);
    if (normalized == null || normalized.isEmpty) {
      return;
    }
    if (_entries.containsKey(normalized)) {
      return;
    }

    node.footnoteReferenceIndex = 0;
    final footnote = CmarkFootnote(
      label: normalized,
      node: node,
    );
    _entries[normalized] = footnote;
  }

  CmarkFootnote? lookup(String label) {
    final normalized = _normalizeLabel(label);
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return _entries[normalized];
  }

  Iterable<CmarkFootnote> get entries => _entries.values;

  List<CmarkFootnote> getReferencedInOrder() {
    final referenced = _entries.values
        .where((entry) => entry.node.footnoteReferenceIndex > 0)
        .toList();
    referenced.sort((a, b) =>
        a.node.footnoteReferenceIndex.compareTo(b.node.footnoteReferenceIndex));
    return referenced;
  }

  static String? _normalizeLabel(String label) {
    if (label.isEmpty) {
      return null;
    }

    final buffer = CmarkStrbuf();
    CmarkUtf8.caseFold(buffer, utf8.encode(label));
    buffer.trim();
    buffer.normalizeWhitespace();

    final normalizedBytes = buffer.detach();
    if (normalizedBytes.isEmpty) {
      return null;
    }
    return utf8.decode(normalizedBytes, allowMalformed: true);
  }
}
