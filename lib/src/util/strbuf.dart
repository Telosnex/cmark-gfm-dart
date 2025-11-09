import 'dart:convert';
import 'dart:math';

import 'ctype.dart';

/// Growable byte buffer emulating cmark-gfm's `cmark_strbuf`.
class CmarkStrbuf {
  CmarkStrbuf([Iterable<int>? initial]) {
    if (initial != null) {
      _data.addAll(initial.map((value) => value & 0xFF));
    }
  }

  final List<int> _data = <int>[];

  int get length => _data.length;

  bool get isEmpty => _data.isEmpty;

  int operator [](int index) => _data[index];

  void clear() => _data.clear();

  void setBytes(List<int> bytes) {
    _data
      ..clear()
      ..addAll(bytes.map((value) => value & 0xFF));
  }

  void setString(String string) {
    setBytes(utf8.encode(string));
  }

  void putc(int charCode) {
    _data.add(charCode & 0xFF);
  }

  void putBytes(List<int> bytes) {
    if (bytes.isEmpty) {
      return;
    }
    _data.addAll(bytes.map((value) => value & 0xFF));
  }

  void putString(String string) {
    putBytes(utf8.encode(string));
  }

  int indexOf(int charCode, [int start = 0]) {
    if (start < 0) {
      start = 0;
    }
    for (var i = start; i < _data.length; i++) {
      if (_data[i] == (charCode & 0xFF)) {
        return i;
      }
    }
    return -1;
  }

  int lastIndexOf(int charCode, [int? start]) {
    var i = start ?? (_data.length - 1);
    if (i >= _data.length) {
      i = _data.length - 1;
    }
    for (; i >= 0; i--) {
      if (_data[i] == (charCode & 0xFF)) {
        return i;
      }
    }
    return -1;
  }

  void drop(int n) {
    if (n <= 0) {
      return;
    }
    if (n >= _data.length) {
      clear();
      return;
    }
    _data.removeRange(0, n);
  }

  void truncate(int length) {
    if (length < 0) {
      length = 0;
    }
    if (length >= _data.length) {
      return;
    }
    _data.removeRange(length, _data.length);
  }

  void rtrim() {
    while (_data.isNotEmpty && CmarkCType.isSpace(_data.last)) {
      _data.removeLast();
    }
  }

  void trim() {
    var start = 0;
    while (start < _data.length && CmarkCType.isSpace(_data[start])) {
      start++;
    }
    if (start > 0) {
      drop(start);
    }
    rtrim();
  }

  void normalizeWhitespace() {
    if (_data.isEmpty) {
      return;
    }
    var writeIndex = 0;
    var lastWasSpace = false;
    for (var read = 0; read < _data.length; read++) {
      final byte = _data[read];
      if (CmarkCType.isSpace(byte)) {
        if (!lastWasSpace) {
          _data[writeIndex++] = 0x20; // space
          lastWasSpace = true;
        }
      } else {
        _data[writeIndex++] = byte;
        lastWasSpace = false;
      }
    }
    truncate(writeIndex);
  }

  void unescape() {
    if (_data.isEmpty) {
      return;
    }
    var writeIndex = 0;
    var read = 0;
    while (read < _data.length) {
      var byte = _data[read];
      if (byte == 0x5C && read + 1 < _data.length) {
        // '\\'
        final next = _data[read + 1];
        if (CmarkCType.isPunct(next)) {
          byte = next;
          read += 2;
          _data[writeIndex++] = byte;
          continue;
        }
      }
      _data[writeIndex++] = byte;
      read++;
    }
    truncate(writeIndex);
  }

  List<int> detach() {
    final result = List<int>.from(_data, growable: false);
    clear();
    return result;
  }

  void swap(CmarkStrbuf other) {
    final selfCopy = List<int>.from(_data);
    _data
      ..clear()
      ..addAll(other._data);
    other._data
      ..clear()
      ..addAll(selfCopy);
  }

  int compareTo(CmarkStrbuf other) {
    final minLen = min(length, other.length);
    for (var i = 0; i < minLen; i++) {
      final diff = _data[i] - other._data[i];
      if (diff != 0) {
        return diff;
      }
    }
    if (length == other.length) {
      return 0;
    }
    return length < other.length ? -1 : 1;
  }

  @override
  String toString() => utf8.decode(_data, allowMalformed: true);
}
