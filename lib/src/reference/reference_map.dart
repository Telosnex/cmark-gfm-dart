import 'dart:convert';

import '../houdini/html_unescape.dart';
import '../util/chunk.dart';
import '../util/strbuf.dart';
import '../util/utf8.dart';

const int kMaxLinkLabelLength = 1000;

class CmarkReference {
  CmarkReference({
    required this.label,
    required this.url,
    required this.title,
    required this.age,
  });

  final String label;
  final CmarkChunk url;
  final CmarkChunk title;
  final int age;

  int get size => url.length + title.length;

  CmarkReference copy() => CmarkReference(
        label: label,
        url: url.clone(),
        title: title.clone(),
        age: age,
      );
}

class CmarkReferenceMap {
  CmarkReferenceMap({int? maxRefSize}) : _maxRefSize = maxRefSize ?? 0xFFFFFFFF;

  final Map<String, CmarkReference> _entries = <String, CmarkReference>{};
  int _refSize = 0;
  int _maxRefSize;

  int get size => _entries.length;

  int get maxRefSize => _maxRefSize;
  set maxRefSize(int value) => _maxRefSize = value;

  void resetUsage() {
    _refSize = 0;
  }

  bool addStrings(String labelStr, String urlStr, String titleStr) {
    final label = CmarkChunk.literal(labelStr);
    final url = CmarkChunk.literal(urlStr);
    final title = CmarkChunk.literal(titleStr);
    return add(label, url, title);
  }
  
  bool add(CmarkChunk label, CmarkChunk url, CmarkChunk title) {
    if (label.length == 0 || label.length > kMaxLinkLabelLength) {
      return false;
    }

    final normalized = _normalizeLabel(label);
    if (normalized == null || normalized.isEmpty) {
      return false;
    }
    if (_entries.containsKey(normalized)) {
      return false;
    }

    final normalizedUrl = _cleanUrl(url);
    final normalizedTitle = _cleanTitle(title);

    final reference = CmarkReference(
      label: normalized,
      url: normalizedUrl,
      title: normalizedTitle,
      age: _entries.length,
    );
    _entries[normalized] = reference;
    return true;
  }

  CmarkReference? lookupString(String labelStr, {bool cloneResult = true}) {
    if (labelStr.isEmpty || labelStr.length > kMaxLinkLabelLength) {
      return null;
    }
    
    final label = CmarkChunk.literal(labelStr);
    return lookup(label, cloneResult: cloneResult);
  }
  
  CmarkReference? lookup(CmarkChunk label, {bool cloneResult = true}) {
    if (label.length == 0 || label.length > kMaxLinkLabelLength) {
      return null;
    }

    final normalized = _normalizeLabel(label);
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    final reference = _entries[normalized];
    if (reference == null) {
      return null;
    }

    if (reference.size > _maxRefSize - _refSize) {
      return null;
    }
    _refSize += reference.size;

    return cloneResult ? reference.copy() : reference;
  }

  static CmarkChunk _cleanUrl(CmarkChunk url) {
    final trimmed = url.clone()..trim();
    if (trimmed.isEmpty) {
      return CmarkChunk.empty.clone();
    }

    final buf = CmarkStrbuf();
    HoudiniHtmlUnescape.unescape(buf, trimmed.data);
    buf.unescape();
    return CmarkChunk.fromBytes(buf.detach(), allocated: true);
  }

  static CmarkChunk _cleanTitle(CmarkChunk title) {
    final trimmed = title.clone();
    if (trimmed.isEmpty) {
      return CmarkChunk.empty.clone();
    }

    final first = trimmed.data.first;
    final last = trimmed.data.last;
    final buf = CmarkStrbuf();

    if (trimmed.length > 1 &&
        ((first == last && (first == 0x22 || first == 0x27)) ||
            (first == 0x28 && last == 0x29))) {
      HoudiniHtmlUnescape.unescape(
        buf,
        trimmed.dup(1, trimmed.length - 2).data,
      );
    } else {
      HoudiniHtmlUnescape.unescape(buf, trimmed.data);
    }

    buf.unescape();
    return CmarkChunk.fromBytes(buf.detach(), allocated: true);
  }

  static String? _normalizeLabel(CmarkChunk label) {
    if (label.length == 0) {
      return null;
    }

    final buffer = CmarkStrbuf();
    CmarkUtf8.caseFold(buffer, label.data);
    buffer.trim();
    buffer.normalizeWhitespace();

    final normalizedBytes = buffer.detach();
    if (normalizedBytes.isEmpty) {
      return null;
    }
    return utf8.decode(normalizedBytes, allowMalformed: true);
  }
}
