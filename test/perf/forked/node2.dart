import 'package:cmark_gfm/cmark_gfm.dart';

/// Lightweight standalone node. Key optimizations vs CmarkNode:
/// 1. Constructor just sets type — no StringBuffer, no ternary checks
/// 2. Content stored as String? literal — no StringBuffer for text/softbreak/linebreak
/// 3. Data fields are truly lazy — allocated on first access only
class CmarkNode2 {
  CmarkNode2(this.type);

  CmarkNodeType type;

  // ---- Lazy content ----
  String? _literal;
  StringBuffer? _contentBuf;

  /// Fast path for text nodes — avoids StringBuffer entirely.
  void setLiteral(String s) {
    _literal = s;
  }

  /// StringBuffer access for block nodes that accumulate content.
  StringBuffer get content {
    if (_contentBuf == null) {
      _contentBuf = StringBuffer();
      if (_literal != null) {
        _contentBuf!.write(_literal!);
        _literal = null;
      }
    }
    return _contentBuf!;
  }

  /// Read content without forcing StringBuffer allocation.
  String get contentString {
    if (_literal != null) return _literal!;
    return _contentBuf?.toString() ?? '';
  }

  // ---- Tree pointers ----
  CmarkNode2? next;
  CmarkNode2? previous;
  CmarkNode2? parent;
  CmarkNode2? firstChild;
  CmarkNode2? lastChild;

  Object? userData;

  /// First byte of content, set by block parser's _addLine.
  /// Allows _resolveReferenceLinkDefinitions to skip toString.
  int firstContentByte = 0;

  // ---- Position tracking ----
  int startLine = 0;
  int startColumn = 0;
  int endLine = 0;
  int endColumn = 0;
  int internalOffset = 0;
  int htmlBlockType = 0;
  String? htmlBlockEndTag;
  int flags = 0;
  int footnoteReferenceIndex = 0;
  int footnoteDefCount = 0;
  int footnoteRefIndex = 0;
  String footnoteDefLabel = '';
  CmarkNode2? parentFootnoteDefinition;

  // ---- Lazy data fields ----
  CmarkListData? _listData;
  CmarkCodeData? _codeData;
  CmarkHeadingData? _headingData;
  CmarkLinkData? _linkData;
  CmarkCustomData? _customData;
  CmarkTableRowData? _tableRowData;
  CmarkTableCellData? _tableCellData;
  CmarkMathData? _mathData;

  CmarkListData get listData => _listData ??= CmarkListData();
  CmarkCodeData get codeData => _codeData ??= CmarkCodeData();
  CmarkHeadingData get headingData => _headingData ??= CmarkHeadingData();
  CmarkLinkData get linkData => _linkData ??= CmarkLinkData();
  CmarkCustomData get customData => _customData ??= CmarkCustomData();
  CmarkTableRowData get tableRowData => _tableRowData ??= CmarkTableRowData();
  CmarkTableCellData get tableCellData => _tableCellData ??= CmarkTableCellData();
  CmarkMathData get mathData => _mathData ??= CmarkMathData();

  void initializeHeadingData() { _headingData ??= CmarkHeadingData(); }
  void initializeTableCellData() { _tableCellData ??= CmarkTableCellData(); }

  // ---- Tree operations ----
  bool canContain(CmarkNodeType childType) {
    if (childType == CmarkNodeType.document) return false;
    switch (type) {
      case CmarkNodeType.document:
      case CmarkNodeType.blockQuote:
      case CmarkNodeType.footnoteDefinition:
      case CmarkNodeType.item:
        return childType.isBlock && childType != CmarkNodeType.item;
      case CmarkNodeType.list:
        return childType == CmarkNodeType.item;
      case CmarkNodeType.customBlock:
        return true;
      case CmarkNodeType.paragraph:
      case CmarkNodeType.heading:
      case CmarkNodeType.emph:
      case CmarkNodeType.strong:
      case CmarkNodeType.link:
      case CmarkNodeType.image:
      case CmarkNodeType.customInline:
      case CmarkNodeType.strikethrough:
      case CmarkNodeType.math:
        return childType.isInline;
      case CmarkNodeType.table:
        return childType == CmarkNodeType.tableRow;
      case CmarkNodeType.tableRow:
        return childType == CmarkNodeType.tableCell;
      case CmarkNodeType.tableCell:
        return childType.isInline;
      default:
        return false;
    }
  }

  void unlink() {
    if (previous != null) previous!.next = next;
    if (next != null) next!.previous = previous;
    if (parent != null) {
      if (parent!.firstChild == this) parent!.firstChild = next;
      if (parent!.lastChild == this) parent!.lastChild = previous;
    }
    previous = null;
    next = null;
    parent = null;
  }

  void insertAfter(CmarkNode2 reference, CmarkNode2 newNode) {
    newNode.parent = this;
    newNode.previous = reference;
    newNode.next = reference.next;
    if (reference.next != null) {
      reference.next!.previous = newNode;
    } else {
      lastChild = newNode;
    }
    reference.next = newNode;
  }

  void appendChild(CmarkNode2 child) {
    _insertChild(child, append: true);
  }

  /// Fast append for freshly-created nodes not in any tree.
  /// Skips unlink() and the append/prepend branch.
  @pragma('vm:prefer-inline')
  void appendNewChild(CmarkNode2 child) {
    child.parent = this;
    if (lastChild == null) {
      firstChild = child;
      lastChild = child;
    } else {
      child.previous = lastChild;
      lastChild!.next = child;
      lastChild = child;
    }
  }

  void prependChild(CmarkNode2 child) {
    _insertChild(child, append: false);
  }

  void _insertChild(CmarkNode2 child, {required bool append}) {
    child.unlink();
    child.parent = this;
    if (firstChild == null) {
      firstChild = child;
      lastChild = child;
      child.previous = null;
      child.next = null;
      return;
    }
    if (append) {
      child.previous = lastChild;
      child.next = null;
      lastChild!.next = child;
      lastChild = child;
    } else {
      child.previous = null;
      child.next = firstChild;
      firstChild!.previous = child;
      firstChild = child;
    }
  }

  CmarkNode2 deepCopy() {
    final copy = CmarkNode2(type);
    // Copy content
    final s = contentString;
    if (s.isNotEmpty) copy.setLiteral(s);
    // Copy position
    copy.startLine = startLine;
    copy.startColumn = startColumn;
    copy.endLine = endLine;
    copy.endColumn = endColumn;
    copy.internalOffset = internalOffset;
    copy.htmlBlockType = htmlBlockType;
    copy.htmlBlockEndTag = htmlBlockEndTag;
    copy.flags = flags;
    copy.footnoteReferenceIndex = footnoteReferenceIndex;
    copy.footnoteDefCount = footnoteDefCount;
    copy.footnoteRefIndex = footnoteRefIndex;
    copy.footnoteDefLabel = footnoteDefLabel;
    copy.userData = userData;
    // Copy data structs (only if allocated)
    if (_listData != null) {
      copy.listData
        ..listType = _listData!.listType
        ..markerOffset = _listData!.markerOffset
        ..padding = _listData!.padding
        ..start = _listData!.start
        ..delimiter = _listData!.delimiter
        ..bulletChar = _listData!.bulletChar
        ..tight = _listData!.tight;
    }
    if (_codeData != null) {
      copy.codeData
        ..info = _codeData!.info
        ..literal = _codeData!.literal
        ..fenceLength = _codeData!.fenceLength
        ..fenceOffset = _codeData!.fenceOffset
        ..fenceChar = _codeData!.fenceChar
        ..isFenced = _codeData!.isFenced;
    }
    if (_headingData != null) {
      copy.headingData
        ..level = _headingData!.level
        ..setext = _headingData!.setext;
    }
    if (_linkData != null) {
      copy.linkData
        ..url = _linkData!.url
        ..title = _linkData!.title;
    }
    if (_mathData != null) {
      copy.mathData
        ..literal = _mathData!.literal
        ..display = _mathData!.display
        ..openingDelimiter = _mathData!.openingDelimiter
        ..closingDelimiter = _mathData!.closingDelimiter;
    }
    if (_tableRowData != null) {
      copy.tableRowData.isHeader = _tableRowData!.isHeader;
    }
    if (_tableCellData != null) {
      copy.tableCellData.align = _tableCellData!.align;
    }
    // Recursively copy children
    var child = firstChild;
    while (child != null) {
      copy.appendChild(child.deepCopy());
      child = child.next;
    }
    return copy;
  }
}
