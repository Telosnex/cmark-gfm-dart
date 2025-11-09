import '../node.dart';

class ContainerStack {
  ContainerStack() {
    _stack.add(_StackEntry(CmarkNode(CmarkNodeType.document)));
  }

  final List<_StackEntry> _stack = <_StackEntry>[];

  CmarkNode get root => _stack.first.node;

  CmarkNode get current => _stack.last.node;

  int get depth => _stack.length - 1;

  void open(CmarkNode node) {
    final parent = current;
    parent.appendChild(node);
    node.flags |= _openFlag;
    _stack.add(_StackEntry(node));
  }

  CmarkNode close() {
    final closing = _stack.removeLast().node;
    closing.flags &= ~_openFlag;
    return closing;
  }

  void closeToDepth(int targetDepth) {
    while (depth > targetDepth) {
      close();
    }
  }

  bool get isEmpty => _stack.length <= 1;

  bool get lastLineBlank => (current.flags & _blankFlag) != 0;

  set lastLineBlank(bool value) {
    if (value) {
      current.flags |= _blankFlag;
    } else {
      current.flags &= ~_blankFlag;
    }
  }

  static const int _openFlag = 1 << 0;
  static const int _blankFlag = 1 << 1;
}

class _StackEntry {
  _StackEntry(this.node);
  final CmarkNode node;
}
