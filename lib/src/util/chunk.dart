import 'dart:convert';

import 'ctype.dart';
import 'strbuf.dart';

class CmarkChunk {
  CmarkChunk(
    this._buffer, {
    int start = 0,
    int? length,
    bool allocated = false,
  })  : _start = start,
        _length = length ?? (_buffer.length - start),
        _allocated = allocated;

  factory CmarkChunk.literal(String text) {
    final bytes = utf8.encode(text);
    return CmarkChunk(List<int>.from(bytes, growable: false), allocated: false);
  }

  factory CmarkChunk.fromBytes(List<int> bytes, {bool allocated = false}) {
    return CmarkChunk(List<int>.from(bytes, growable: false),
        allocated: allocated);
  }

  factory CmarkChunk.fromStrbuf(CmarkStrbuf buf) {
    final bytes = buf.detach();
    return CmarkChunk(bytes, allocated: true);
  }

  static final CmarkChunk empty =
      CmarkChunk.fromBytes(const [], allocated: false);

  final List<int> _buffer;
  int _start;
  int _length;
  bool _allocated;

  List<int> get data => _buffer.sublist(_start, _start + _length);

  int get length => _length;

  bool get isEmpty => _length == 0;

  bool get isAllocated => _allocated;

  CmarkChunk clone() => CmarkChunk.fromBytes(data, allocated: true);

  void ltrim() {
    while (_length > 0 && CmarkCType.isSpace(_buffer[_start])) {
      _start++;
      _length--;
    }
  }

  void rtrim() {
    while (_length > 0 && CmarkCType.isSpace(_buffer[_start + _length - 1])) {
      _length--;
    }
  }

  void trim() {
    ltrim();
    rtrim();
  }

  int indexOf(int charCode, [int offset = 0]) {
    if (offset < 0) {
      offset = 0;
    }
    for (var i = offset; i < _length; i++) {
      if (_buffer[_start + i] == (charCode & 0xFF)) {
        return i;
      }
    }
    return _length;
  }

  CmarkChunk dup(int pos, int length) {
    final clampedPos = pos.clamp(0, _length);
    final remaining = _length - clampedPos;
    final clampedLen = length.clamp(0, remaining);
    return CmarkChunk(_buffer,
        start: _start + clampedPos, length: clampedLen, allocated: false);
  }

  String toDartString() => utf8.decode(data, allowMalformed: true);

  @override
  String toString() => toDartString();
}
