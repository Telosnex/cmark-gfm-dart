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
  static const CmarkNodeType math = CmarkNodeType._inline(0x000d, 'math');

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

  /// Flag bits used by the parser and renderer.
  int flags = 0;

  // Rarely used fields live in side objects, allocated on first write.
  // Streaming snapshots copy every node, so node size matters.
  _HtmlBlockFields? _html;
  _FootnoteFields? _footnote;

  int get internalOffset => _html?.internalOffset ?? 0;
  set internalOffset(int value) {
    if (value != 0 || _html != null)
      (_html ??= _HtmlBlockFields()).internalOffset = value;
  }

  int get htmlBlockType => _html?.htmlBlockType ?? 0;
  set htmlBlockType(int value) {
    if (value != 0 || _html != null)
      (_html ??= _HtmlBlockFields()).htmlBlockType = value;
  }

  String? get htmlBlockEndTag => _html?.htmlBlockEndTag;
  set htmlBlockEndTag(String? value) {
    if (value != null || _html != null)
      (_html ??= _HtmlBlockFields()).htmlBlockEndTag = value;
  }

  /// The number of references/definitions recorded for footnote bookkeeping.
  int get footnoteReferenceIndex => _footnote?.referenceIndex ?? 0;
  set footnoteReferenceIndex(int value) {
    if (value != 0 || _footnote != null)
      (_footnote ??= _FootnoteFields()).referenceIndex = value;
  }

  /// For footnote definitions: how many times this footnote has been referenced.
  int get footnoteDefCount => _footnote?.defCount ?? 0;
  set footnoteDefCount(int value) {
    if (value != 0 || _footnote != null)
      (_footnote ??= _FootnoteFields()).defCount = value;
  }

  /// For footnote references: which reference number this is (1st, 2nd, 3rd...).
  int get footnoteRefIndex => _footnote?.refIndex ?? 0;
  set footnoteRefIndex(int value) {
    if (value != 0 || _footnote != null)
      (_footnote ??= _FootnoteFields()).refIndex = value;
  }

  /// For footnote references: the label of the definition.
  String get footnoteDefLabel => _footnote?.defLabel ?? '';
  set footnoteDefLabel(String value) {
    if (value.isNotEmpty || _footnote != null)
      (_footnote ??= _FootnoteFields()).defLabel = value;
  }

  /// Link to the containing footnote definition node, if any.
  CmarkNode? get parentFootnoteDefinition => _footnote?.parentDefinition;
  set parentFootnoteDefinition(CmarkNode? value) {
    if (value != null || _footnote != null)
      (_footnote ??= _FootnoteFields()).parentDefinition = value;
  }

  // ---- Lazy data fields ----
  // One slot for the type-specific data: a node has one kind at a time.
  // Asking for another kind replaces it (the node's type has changed).
  Object? _data;

  CmarkListData get listData {
    final data = _data;
    if (data is CmarkListData) return data;
    return _data = CmarkListData();
  }

  CmarkCodeData get codeData {
    final data = _data;
    if (data is CmarkCodeData) return data;
    return _data = CmarkCodeData();
  }

  CmarkHeadingData get headingData {
    final data = _data;
    if (data is CmarkHeadingData) return data;
    return _data = CmarkHeadingData();
  }

  CmarkLinkData get linkData {
    final data = _data;
    if (data is CmarkLinkData) return data;
    return _data = CmarkLinkData();
  }

  CmarkCustomData get customData {
    final data = _data;
    if (data is CmarkCustomData) return data;
    return _data = CmarkCustomData();
  }

  CmarkTableRowData get tableRowData {
    final data = _data;
    if (data is CmarkTableRowData) return data;
    return _data = CmarkTableRowData();
  }

  CmarkTableCellData get tableCellData {
    final data = _data;
    if (data is CmarkTableCellData) return data;
    return _data = CmarkTableCellData();
  }

  CmarkMathData get mathData {
    final data = _data;
    if (data is CmarkMathData) return data;
    return _data = CmarkMathData();
  }

  /// Initialize heading data when converting from another type.
  void initializeHeadingData() => headingData;

  /// Initialize table cell data when converting or creating cell.
  void initializeTableCellData() => tableCellData;

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
    final copy = shallowCopy();
    var child = firstChild;
    while (child != null) {
      copy.appendNewChild(child.deepCopy());
      child = child.next;
    }
    return copy;
  }

  /// Copies this node without its children and without tree links.
  CmarkNode shallowCopy() {
    final copy = CmarkNode(type);
    // Share the content string; copying a StringBuffer would copy the text.
    final s = contentString;
    if (s.isNotEmpty) copy._literal = s;
    copy.startLine = startLine;
    copy.startColumn = startColumn;
    copy.endLine = endLine;
    copy.endColumn = endColumn;
    copy.flags = flags;
    copy._html = _html?.copy();
    copy._footnote = _footnote?.copy();
    copy.firstContentByte = firstContentByte;
    copy.userData = userData;
    final data = _data;
    if (data != null) {
      copy._data = switch (data) {
        CmarkListData() => data.copy(),
        CmarkCodeData() => data.copy(),
        CmarkHeadingData() => data.copy(),
        CmarkLinkData() => data.copy(),
        CmarkCustomData() => data.copy(),
        CmarkMathData() => data.copy(),
        CmarkTableRowData() => data.copy(),
        CmarkTableCellData() => data.copy(),
        _ => data,
      };
    }
    return copy;
  }
}

class _HtmlBlockFields {
  int internalOffset = 0;
  int htmlBlockType = 0;
  String? htmlBlockEndTag;

  _HtmlBlockFields copy() => _HtmlBlockFields()
    ..internalOffset = internalOffset
    ..htmlBlockType = htmlBlockType
    ..htmlBlockEndTag = htmlBlockEndTag;
}

class _FootnoteFields {
  int referenceIndex = 0;
  int defCount = 0;
  int refIndex = 0;
  String defLabel = '';
  CmarkNode? parentDefinition;

  /// A copy belongs to another tree, so it does not keep [parentDefinition].
  _FootnoteFields copy() => _FootnoteFields()
    ..referenceIndex = referenceIndex
    ..defCount = defCount
    ..refIndex = refIndex
    ..defLabel = defLabel;
}
