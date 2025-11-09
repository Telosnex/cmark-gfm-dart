import '../node.dart';

enum CmarkEventType {
  none,
  done,
  enter,
  exit,
}

/// Iterator for walking a tree with ENTER/EXIT events.
/// Port of cmark_iter from iterator.c
class CmarkIter {
  CmarkIter(CmarkNode root)
      : _root = root,
        _curNode = root,
        _curEventType = CmarkEventType.none,
        _nextNode = root,
        _nextEventType = CmarkEventType.enter;

  final CmarkNode _root;
  CmarkNode _curNode;
  CmarkEventType _curEventType;
  CmarkNode _nextNode;
  CmarkEventType _nextEventType;

  CmarkEventType next() {
    final evType = _nextEventType;
    final node = _nextNode;

    _curEventType = evType;
    _curNode = node;

    if (evType == CmarkEventType.done) {
      return evType;
    }

    // Roll forward to next item (from C's cmark_iter_next)
    if (evType == CmarkEventType.enter && !_isLeaf(node)) {
      if (node.firstChild == null) {
        // Stay on this node but exit
        _nextEventType = CmarkEventType.exit;
      } else {
        _nextEventType = CmarkEventType.enter;
        _nextNode = node.firstChild!;
      }
    } else if (node == _root) {
      // Don't move past root
      _nextEventType = CmarkEventType.done;
      _nextNode = _root; // Keep node valid
    } else if (node.next != null) {
      _nextEventType = CmarkEventType.enter;
      _nextNode = node.next!;
    } else if (node.parent != null) {
      _nextEventType = CmarkEventType.exit;
      _nextNode = node.parent!;
    } else {
      _nextEventType = CmarkEventType.done;
      _nextNode = _root; // Keep node valid
    }

    return evType;
  }

  bool _isLeaf(CmarkNode node) {
    // From S_is_leaf() in iterator.c
    switch (node.type) {
      case CmarkNodeType.htmlBlock:
      case CmarkNodeType.thematicBreak:
      case CmarkNodeType.codeBlock:
      case CmarkNodeType.text:
      case CmarkNodeType.softbreak:
      case CmarkNodeType.linebreak:
      case CmarkNodeType.code:
      case CmarkNodeType.htmlInline:
        return true;
      default:
        return false;
    }
  }

  CmarkNode get node => _curNode;
  CmarkEventType get eventType => _curEventType;
}
