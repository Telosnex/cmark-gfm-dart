import 'dart:convert';

import '../node.dart';
import '../util/strbuf.dart';
import '../util/utf8.dart';

class CmarkFootnote {
  CmarkFootnote({
    required this.label,
    required this.node,
    required this.index,
  });

  final String label;
  final CmarkNode node;
  final int index;
}

class CmarkFootnoteMap {
  CmarkFootnoteMap();

  final Map<String, CmarkFootnote> _entries = <String, CmarkFootnote>{};
  int _nextIndex = 1;

  int get size => _entries.length;

  void add(String label, CmarkNode node) {
    final normalized = _normalizeLabel(label);
    if (normalized == null || normalized.isEmpty) {
      return;
    }
    if (_entries.containsKey(normalized)) {
      return;
    }

    final index = _nextIndex++;
    node.footnoteReferenceIndex = index;
    final footnote = CmarkFootnote(
      label: normalized,
      node: node,
      index: index,
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

  List<CmarkFootnote> getAllSorted() {
    final footnotes = _entries.values.toList();
    footnotes.sort((a, b) => a.index.compareTo(b.index));
    return footnotes;
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
