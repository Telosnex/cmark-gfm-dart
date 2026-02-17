import 'package:cmark_gfm/cmark_gfm.dart' show CmarkNodeType;
import 'package:cmark_gfm/src/util/node_iterator.dart' show CmarkEventType;
import 'node2.dart';

/// CmarkIter ported for CmarkNode2 trees.
class CmarkIter2 {
  CmarkIter2(CmarkNode2 root)
      : _root = root,
        _curNode = root,
        _curEventType = CmarkEventType.none,
        _nextNode = root,
        _nextEventType = CmarkEventType.enter;

  final CmarkNode2 _root;
  CmarkNode2 _curNode;
  CmarkEventType _curEventType;
  CmarkNode2 _nextNode;
  CmarkEventType _nextEventType;

  CmarkEventType next() {
    final evType = _nextEventType;
    final node = _nextNode;
    _curEventType = evType;
    _curNode = node;
    if (evType == CmarkEventType.done) return evType;
    if (evType == CmarkEventType.enter && !_isLeaf(node)) {
      if (node.firstChild == null) {
        _nextEventType = CmarkEventType.exit;
      } else {
        _nextEventType = CmarkEventType.enter;
        _nextNode = node.firstChild!;
      }
    } else if (node == _root) {
      _nextEventType = CmarkEventType.done;
      _nextNode = _root;
    } else if (node.next != null) {
      _nextEventType = CmarkEventType.enter;
      _nextNode = node.next!;
    } else if (node.parent != null) {
      _nextEventType = CmarkEventType.exit;
      _nextNode = node.parent!;
    } else {
      _nextEventType = CmarkEventType.done;
      _nextNode = _root;
    }
    return evType;
  }

  bool _isLeaf(CmarkNode2 node) {
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

  CmarkNode2 get node => _curNode;
  CmarkEventType get eventType => _curEventType;
}
