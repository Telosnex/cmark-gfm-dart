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
class CmarkNode {
  CmarkNode(this.type)
      : content = StringBuffer(),
        startLine = 0,
        startColumn = 0,
        endLine = 0,
        endColumn = 0,
        internalOffset = 0,
        _listData = type == CmarkNodeType.list || type == CmarkNodeType.item
            ? CmarkListData()
            : null,
        _codeData =
            type == CmarkNodeType.codeBlock || type == CmarkNodeType.code
                ? CmarkCodeData()
                : null,
        _headingData =
            type == CmarkNodeType.heading ? CmarkHeadingData() : null,
        _linkData = type == CmarkNodeType.link || type == CmarkNodeType.image
            ? CmarkLinkData()
            : null,
        _customData = type == CmarkNodeType.customBlock ||
                type == CmarkNodeType.customInline
            ? CmarkCustomData()
            : null,
        _tableRowData =
            type == CmarkNodeType.tableRow ? CmarkTableRowData() : null,
        _tableCellData =
            type == CmarkNodeType.tableCell ? CmarkTableCellData() : null,
        _mathData = type == CmarkNodeType.math || type == CmarkNodeType.mathBlock
            ? CmarkMathData(display: type == CmarkNodeType.mathBlock)
            : null;

  CmarkNodeType type;

  final StringBuffer content;

  CmarkNode? next;
  CmarkNode? previous;
  CmarkNode? parent;
  CmarkNode? firstChild;
  CmarkNode? lastChild;

  Object? userData;
  void Function(Object?)? userDataFreeFunc;

  int startLine;
  int startColumn;
  int endLine;
  int endColumn;
  int internalOffset;

  /// Flag bits used by the parser and renderer.
  int flags = 0;

  /// The number of references/definitions recorded for footnote bookkeeping.
  int footnoteReferenceIndex = 0;
  
  /// For footnote definitions: how many times this footnote has been referenced
  int footnoteDefCount = 0;
  
  /// For footnote references: which reference number this is (1st, 2nd, 3rd...)
  int footnoteRefIndex = 0;
  
  /// For footnote references: the label of the definition
  String footnoteDefLabel = '';

  /// Link to the containing footnote definition node, if any.
  CmarkNode? parentFootnoteDefinition;

  CmarkListData? _listData;
  CmarkCodeData? _codeData;
  CmarkHeadingData? _headingData;
  CmarkLinkData? _linkData;
  CmarkCustomData? _customData;
  CmarkTableRowData? _tableRowData;
  CmarkTableCellData? _tableCellData;
  CmarkMathData? _mathData;

  /// Returns true if this node can contain [childType]. The rules mirror
  /// `cmark_node_can_contain_type` from the C implementation.
  bool canContain(CmarkNodeType childType) {
    if (childType == CmarkNodeType.document) {
      return false;
    }

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
    final parent = this.parent;

    if (previous != null) {
      previous!.next = next;
    }
    if (next != null) {
      next!.previous = previous;
    }

    if (parent != null) {
      if (parent.firstChild == this) {
        parent.firstChild = next;
      }
      if (parent.lastChild == this) {
        parent.lastChild = previous;
      }
    }

    previous = null;
    next = null;
    this.parent = null;
  }

  /// Appends [child] as the final child of this node.
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
  
  void appendChild(CmarkNode child) {
    _insertChild(child, append: true);
  }

  /// Prepends [child] as the first child of this node.
  void prependChild(CmarkNode child) {
    _insertChild(child, append: false);
  }

  void _insertChild(CmarkNode child, {required bool append}) {
    if (!canContain(child.type)) {
      throw ArgumentError(
        'Cannot insert child of type ${child.type} into parent of type $type',
      );
    }

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

  Iterable<CmarkNode> get children sync* {
    var node = firstChild;
    while (node != null) {
      yield node;
      node = node.next;
    }
  }

  CmarkListData get listData {
    _assertData(_listData, 'list');
    return _listData!;
  }

  CmarkCodeData get codeData {
    _assertData(_codeData, 'code');
    return _codeData!;
  }

  CmarkHeadingData get headingData {
    _assertData(_headingData, 'heading');
    return _headingData!;
  }

  CmarkLinkData get linkData {
    _assertData(_linkData, 'link');
    return _linkData!;
  }

  CmarkCustomData get customData {
    _assertData(_customData, 'custom');
    return _customData!;
  }

  CmarkMathData get mathData {
    _assertData(_mathData, 'math');
    return _mathData!;
  }

  CmarkTableRowData get tableRowData {
    _assertData(_tableRowData, 'table row');
    return _tableRowData!;
  }

  CmarkTableCellData get tableCellData {
    _assertData(_tableCellData, 'table cell');
    return _tableCellData!;
  }

  void _assertData(Object? data, String kind) {
    if (data == null) {
      throw StateError('Node of type $type does not carry $kind data.');
    }
  }
  
  /// Initialize heading data when converting from another type.
  void initializeHeadingData() {
    if (_headingData == null) {
      _headingData = CmarkHeadingData();
    }
  }
  
  /// Initialize table row data.
  void initializeTableRowData() {
    if (_tableRowData == null) {
      _tableRowData = CmarkTableRowData();
    }
  }
  
  /// Initialize table cell data when converting or creating cell.
  void initializeTableCellData() {
    if (_tableCellData == null) {
      _tableCellData = CmarkTableCellData();
    }
  }

  CmarkNode deepCopy() {
    final copy = CmarkNode(type)
      ..content.write(content.toString())
      ..startLine = startLine
      ..startColumn = startColumn
      ..endLine = endLine
      ..endColumn = endColumn
      ..internalOffset = internalOffset
      ..flags = flags
      ..footnoteReferenceIndex = footnoteReferenceIndex
      ..footnoteDefCount = footnoteDefCount
      ..footnoteRefIndex = footnoteRefIndex
      ..footnoteDefLabel = footnoteDefLabel;

    if (_listData != null) {
      copy._listData = _listData!.copy();
    }
    if (_codeData != null) {
      copy._codeData = _codeData!.copy();
    }
    if (_headingData != null) {
      copy._headingData = _headingData!.copy();
    }
    if (_linkData != null) {
      copy._linkData = _linkData!.copy();
    }
    if (_customData != null) {
      copy._customData = _customData!.copy();
    }
    if (_tableRowData != null) {
      copy._tableRowData = _tableRowData!.copy();
    }
    if (_tableCellData != null) {
      copy._tableCellData = _tableCellData!.copy();
    }
    if (_mathData != null) {
      copy._mathData = _mathData!.copy();
    }

    for (final child in children) {
      copy.appendChild(child.deepCopy());
    }

    return copy;
  }
}
