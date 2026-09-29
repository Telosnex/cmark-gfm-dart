import 'package:meta/meta.dart';

/// Enum representing the type of a node in the CommonMark AST.
///
/// The values mirror the constants exposed by cmark-gfm. The ordering is
/// important because code translated from the C implementation assumes block
/// and inline nodes occupy specific ranges. Keep block types grouped together
/// followed by inline types.
@immutable
class CmarkNodeType {
  static const int _typeMask = 0x3fff;
  static const int _typeBlockBase = 0x8000;
  static const int _typeInlineBase = 0xC000;

  static const CmarkNodeType document =
      CmarkNodeType._block(0x0001, 'document');
  static const CmarkNodeType blockQuote =
      CmarkNodeType._block(0x0002, 'block_quote');
  static const CmarkNodeType list = CmarkNodeType._block(0x0003, 'list');
  static const CmarkNodeType item = CmarkNodeType._block(0x0004, 'item');
  static const CmarkNodeType codeBlock =
      CmarkNodeType._block(0x0005, 'code_block');
  static const CmarkNodeType htmlBlock =
      CmarkNodeType._block(0x0006, 'html_block');
  static const CmarkNodeType customBlock =
      CmarkNodeType._block(0x0007, 'custom_block');
  static const CmarkNodeType paragraph =
      CmarkNodeType._block(0x0008, 'paragraph');
  static const CmarkNodeType heading = CmarkNodeType._block(0x0009, 'heading');
  static const CmarkNodeType thematicBreak =
      CmarkNodeType._block(0x000a, 'thematic_break');
  static const CmarkNodeType footnoteDefinition =
      CmarkNodeType._block(0x000b, 'footnote_definition');

  static const CmarkNodeType text = CmarkNodeType._inline(0x0001, 'text');
  static const CmarkNodeType softbreak =
      CmarkNodeType._inline(0x0002, 'softbreak');
  static const CmarkNodeType linebreak =
      CmarkNodeType._inline(0x0003, 'linebreak');
  static const CmarkNodeType code = CmarkNodeType._inline(0x0004, 'code');
  static const CmarkNodeType htmlInline =
      CmarkNodeType._inline(0x0005, 'html_inline');
  static const CmarkNodeType customInline =
      CmarkNodeType._inline(0x0006, 'custom_inline');
  static const CmarkNodeType emph = CmarkNodeType._inline(0x0007, 'emph');
  static const CmarkNodeType strong = CmarkNodeType._inline(0x0008, 'strong');
  static const CmarkNodeType link = CmarkNodeType._inline(0x0009, 'link');
  static const CmarkNodeType image = CmarkNodeType._inline(0x000a, 'image');
  static const CmarkNodeType footnoteReference =
      CmarkNodeType._inline(0x000b, 'footnote_reference');
  static const CmarkNodeType strikethrough =
      CmarkNodeType._inline(0x000c, 'strikethrough');
  static const CmarkNodeType math =
      CmarkNodeType._inline(0x000d, 'math');

  // GFM table extensions
  static const CmarkNodeType table = CmarkNodeType._block(0x000c, 'table');
  static const CmarkNodeType tableRow =
      CmarkNodeType._block(0x000d, 'table_row');
  static const CmarkNodeType tableCell =
      CmarkNodeType._block(0x000e, 'table_cell');
  static const CmarkNodeType mathBlock =
      CmarkNodeType._block(0x000f, 'math_block');

  static const List<CmarkNodeType> values = <CmarkNodeType>[
    document,
    blockQuote,
    list,
    item,
    codeBlock,
    htmlBlock,
    customBlock,
    paragraph,
    heading,
    thematicBreak,
    footnoteDefinition,
    text,
    softbreak,
    linebreak,
    code,
    htmlInline,
    customInline,
    emph,
    strong,
    link,
    image,
    footnoteReference,
    strikethrough,
    math,
    table,
    tableRow,
    tableCell,
    mathBlock,
  ];

  final int _encoded;
  final String name;

  const CmarkNodeType._block(int value, this.name)
      : _encoded = _typeBlockBase | (value & _typeMask);

  const CmarkNodeType._inline(int value, this.name)
      : _encoded = _typeInlineBase | (value & _typeMask);

  int get encoded => _encoded;

  bool get isBlock => (_encoded & 0x4000) == 0;

  bool get isInline => (_encoded & 0x4000) != 0;

  @override
  String toString() => 'CmarkNodeType.$name';

  static CmarkNodeType fromEncoded(int encoded) {
    return values.firstWhere(
      (type) => type._encoded == encoded,
      orElse: () => throw ArgumentError('Unknown node type encoding: $encoded'),
    );
  }
}

/// The type of list represented by a list node.
enum CmarkListType { none, bullet, ordered }

/// The delimiter used by an ordered list.
enum CmarkDelimType { none, period, parenthesis }

/// Data carried by list nodes.
class CmarkListData {
  CmarkListData({
    this.listType = CmarkListType.bullet,
    this.markerOffset = 0,
    this.padding = 0,
    this.start = 0,
    this.delimiter = CmarkDelimType.none,
    this.bulletChar = 0,
    this.tight = false,
    this.checked,
  });

  CmarkListType listType;
  int markerOffset;
  int padding;
  int start;
  CmarkDelimType delimiter;
  int bulletChar;
  bool tight;
  bool? checked;

  CmarkListData copy() => CmarkListData(
        listType: listType,
        markerOffset: markerOffset,
        padding: padding,
        start: start,
        delimiter: delimiter,
        bulletChar: bulletChar,
        tight: tight,
        checked: checked,
      );
}

/// Data carried by code block nodes.
class CmarkCodeData {
  CmarkCodeData({
    this.info = '',
    this.literal = '',
    this.fenceLength = 0,
    this.fenceOffset = 0,
    this.fenceChar = 0,
    this.isFenced = false,
  });

  String info;
  String literal;
  int fenceLength;
  int fenceOffset;
  int fenceChar;
  bool isFenced;

  CmarkCodeData copy() => CmarkCodeData(
        info: info,
        literal: literal,
        fenceLength: fenceLength,
        fenceOffset: fenceOffset,
        fenceChar: fenceChar,
        isFenced: isFenced,
      );
}

/// Data carried by heading nodes.
class CmarkHeadingData {
  CmarkHeadingData({this.level = 1, this.setext = false});

  int level;
  bool setext;

  CmarkHeadingData copy() => CmarkHeadingData(level: level, setext: setext);
}

/// Data carried by link and image nodes.
class CmarkLinkData {
  CmarkLinkData({this.url = '', this.title = ''});

  String url;
  String title;

  CmarkLinkData copy() => CmarkLinkData(url: url, title: title);
}

/// Data carried by custom nodes (block/inline).
class CmarkCustomData {
  CmarkCustomData({this.onEnter = '', this.onExit = ''});

  String onEnter;
  String onExit;

  CmarkCustomData copy() => CmarkCustomData(onEnter: onEnter, onExit: onExit);
}

/// Data carried by math nodes.
class CmarkMathData {
  CmarkMathData({
    this.literal = '',
    this.display = false,
    this.openingDelimiter = '',
    this.closingDelimiter = '',
  });

  String literal;
  bool display;
  String openingDelimiter;
  String closingDelimiter;

  CmarkMathData copy() => CmarkMathData(
        literal: literal,
        display: display,
        openingDelimiter: openingDelimiter,
        closingDelimiter: closingDelimiter,
      );
}

/// Alignment for table cells.
enum CmarkTableAlign { none, left, center, right }

/// Data carried by table row nodes.
class CmarkTableRowData {
  CmarkTableRowData({this.isHeader = false});

  bool isHeader;

  CmarkTableRowData copy() => CmarkTableRowData(isHeader: isHeader);
}

/// Data carried by table cell nodes.
class CmarkTableCellData {
  CmarkTableCellData({this.align = CmarkTableAlign.none});

  CmarkTableAlign align;

  CmarkTableCellData copy() => CmarkTableCellData(align: align);
}

/// A node in the CommonMark AST.
///
/// Key optimizations vs the original implementation:
/// 1. Constructor just sets type — no StringBuffer, no ternary checks.
/// 2. Content stored as String? literal — no StringBuffer for text nodes.
/// 3. Data fields are truly lazy — allocated on first access only.
class CmarkNode {
  CmarkNode(this.type);

  CmarkNodeType type;

  // ---- Lazy content ----
  String? _literal;
  StringBuffer? _contentBuf;

  /// Fast path for text nodes — avoids StringBuffer entirely.
  void setLiteral(String s) {
    _literal = s;
    _contentBuf = null; // otherwise [content] would return stale text
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
  CmarkNode? next;
  CmarkNode? previous;
  CmarkNode? parent;
  CmarkNode? firstChild;
  CmarkNode? lastChild;

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

  /// Flag bits used by the parser and renderer.
  int flags = 0;

  /// The number of references/definitions recorded for footnote bookkeeping.
  int footnoteReferenceIndex = 0;

  /// For footnote definitions: how many times this footnote has been referenced.
  int footnoteDefCount = 0;

  /// For footnote references: which reference number this is (1st, 2nd, 3rd...).
  int footnoteRefIndex = 0;

  /// For footnote references: the label of the definition.
  String footnoteDefLabel = '';

  /// Link to the containing footnote definition node, if any.
  CmarkNode? parentFootnoteDefinition;

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
  CmarkTableCellData get tableCellData =>
      _tableCellData ??= CmarkTableCellData();
  CmarkMathData get mathData => _mathData ??= CmarkMathData();

  /// Initialize heading data when converting from another type.
  void initializeHeadingData() {
    _headingData ??= CmarkHeadingData();
  }

  /// Initialize table cell data when converting or creating cell.
  void initializeTableCellData() {
    _tableCellData ??= CmarkTableCellData();
  }

  // ---- Tree operations ----

  /// Returns true if this node can contain [childType]. The rules mirror
  /// `cmark_node_can_contain_type` from the C implementation.
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

  /// Removes this node from its parent and sibling list while leaving its
  /// children attached. Equivalent to `cmark_node_unlink`.
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

  /// Inserts [newNode] as a sibling immediately after [reference].
  void insertAfter(CmarkNode reference, CmarkNode newNode) {
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

  /// Appends [child] as the last child of this node.
  void appendChild(CmarkNode child) {
    _insertChild(child, append: true);
  }

  /// Fast append for freshly-created nodes not in any tree.
  /// Skips unlink() and the append/prepend branch.
  @pragma('vm:prefer-inline')
  void appendNewChild(CmarkNode child) {
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

  /// Prepends [child] as the first child of this node.
  void prependChild(CmarkNode child) {
    _insertChild(child, append: false);
  }

  void _insertChild(CmarkNode child, {required bool append}) {
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

  /// Iterates over the direct children of this node.
  Iterable<CmarkNode> get children sync* {
    var node = firstChild;
    while (node != null) {
      yield node;
      node = node.next;
    }
  }

  CmarkNode deepCopy() {
    final copy = CmarkNode(type);
    // Copy content.
    final s = contentString;
    if (s.isNotEmpty) copy.setLiteral(s);
    // Copy position / metadata.
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
    copy.firstContentByte = firstContentByte;
    copy.userData = userData;
    // Copy data structs (only if allocated).
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
    if (_customData != null) {
      copy.customData
        ..onEnter = _customData!.onEnter
        ..onExit = _customData!.onExit;
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
    // Recursively copy children.
    var child = firstChild;
    while (child != null) {
      copy.appendChild(child.deepCopy());
      child = child.next;
    }
    return copy;
  }
}
