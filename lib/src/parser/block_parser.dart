import 'dart:convert';
import 'dart:typed_data';
import '../node.dart';
import '../reference/reference_map.dart';
import '../reference/reference_parser.dart';
import '../inline/inline_parser.dart';
import '../util/node_iterator.dart';
import '../footnote/footnote_map.dart';

const int kCodeIndent = 4;
const int kTabStop = 4;

/// Real port of cmark-gfm's block parser with proper container stack.
class BlockParser {
  BlockParser({int? maxReferenceSize})
      : referenceMap = CmarkReferenceMap(maxRefSize: maxReferenceSize),
        footnoteMap = CmarkFootnoteMap();

  final CmarkReferenceMap referenceMap;
  final CmarkFootnoteMap footnoteMap;

  final CmarkNode root = CmarkNode(CmarkNodeType.document);
  late CmarkNode current;

  // Parser state per line
  int offset = 0;
  int column = 0;
  int firstNonspace = 0;
  int firstNonspaceColumn = 0;
  int indent = 0;
  bool blank = false;
  bool partiallyConsumedTab = false;
  int lineNumber = 0;
  int lastLineLength = 0;

  String _pending = '';
  String _currentLine = '';

  List<CmarkTableAlign>? _currentTableAlignments;
  bool _skipAddText = false;

  void feed(String text) {
    if (text.isEmpty) {
      return;
    }

    if (lineNumber == 0) {
      _initialize();
    }

    _pending += text;

    // Process complete lines
    var iterations = 0;
    while (true) {
      iterations++;
      if (iterations > 1000000000) {
        throw StateError(
            'SAFETY: feed() loop iterations=$iterations pending=${_pending.length}');
      }

      final newlineIndex = _findNewline(_pending);
      if (newlineIndex == -1) {
        break;
      }

      final line = _pending.substring(0, newlineIndex);
      final newlineLen = _pending[newlineIndex] == '\r' &&
              newlineIndex + 1 < _pending.length &&
              _pending[newlineIndex + 1] == '\n'
          ? 2
          : 1;
      _pending = _pending.substring(newlineIndex + newlineLen);

      _processLine(line);
    }
  }

  /// Finish and return the document tree.
  /// After calling this, the parser cannot accept more input.
  CmarkNode finish() {
    return _finishInternal(root);
  }

  /// Create a finalized clone of the current tree for rendering,
  /// but keep the parser alive to accept more feed() calls.
  /// Use this for streaming/incremental rendering.
  CmarkNode finishClone() {
    // Save complete parser state
    final savedTreeClone = root.deepCopy();
    final savedPending = _pending;
    final savedLineNumber = lineNumber;
    final savedOffset = offset;
    final savedColumn = column;
    final savedBlank = blank;
    final savedPartiallyConsumedTab = partiallyConsumedTab;
    
    // Build a path from root to current (so we can restore current pointer later)
    final pathToCurrent = <int>[];
    var node = current;
    while (node != root) {
      final parent = node.parent;
      if (parent == null) break;
      
      // Find the index of this node among its siblings
      var index = 0;
      var sibling = parent.firstChild;
      while (sibling != null && sibling != node) {
        index++;
        sibling = sibling.next;
      }
      pathToCurrent.insert(0, index);
      node = parent;
    }
    
    // Process pending text into the real tree (so block structure is recognized)
    if (_pending.isNotEmpty) {
      _processLine(_pending);
      _pending = '';
    }
    
    // Clone the now-updated tree
    final clonedRoot = root.deepCopy();
    
    // Restore the original tree by swapping children back
    while (root.firstChild != null) {
      root.firstChild!.unlink();
    }
    var child = savedTreeClone.firstChild;
    while (child != null) {
      final next = child.next;
      child.unlink();
      root.appendChild(child);
      child = next;
    }
    
    // Restore current pointer by following the saved path
    current = root;
    for (final index in pathToCurrent) {
      var child = current.firstChild;
      for (var i = 0; i < index && child != null; i++) {
        child = child.next;
      }
      if (child != null) {
        current = child;
      } else {
        break; // Path is invalid, stay at current level
      }
    }
    
    // Restore all other parser state
    _pending = savedPending;
    lineNumber = savedLineNumber;
    offset = savedOffset;
    column = savedColumn;
    blank = savedBlank;
    partiallyConsumedTab = savedPartiallyConsumedTab;
    
    // Finalize and return the clone (original state fully restored)
    return _finishInternal(clonedRoot);
  }

  CmarkNode _finishInternal(CmarkNode rootToFinalize) {
    final isClone = rootToFinalize != root;

    if (!isClone) {
      // For real finish, process pending and close all containers
      if (_pending.isNotEmpty) {
        _processLine(_pending);
        _pending = '';
      }
    }
    
    // Finalize all nodes in the tree (both for finish and finishClone)
    _finalizeTreeRecursive(rootToFinalize);

    // Process inlines with V2 parser
    final inlineParser = InlineParser(referenceMap, footnoteMap: footnoteMap);
    _processInlines(rootToFinalize, inlineParser);

    // Link footnote references to definitions and set indices
    _linkFootnotes(rootToFinalize);

    // Append footnotes
    _appendFootnotes(rootToFinalize);

    return rootToFinalize;
  }

  void _finalizeTreeRecursive(CmarkNode node) {
    // Clear OPEN flag
    node.flags &= ~1;

    // Set end positions (use current parser line numbers)
    if (node.endLine == 0) {
      node.endLine = lineNumber;
      node.endColumn = lastLineLength;
    }

    // Type-specific finalization
    if (node.type == CmarkNodeType.paragraph) {
      _resolveReferenceLinkDefinitions(node);
    } else if (node.type == CmarkNodeType.list) {
      node.listData.tight = _calculateTightness(node);
    } else if (node.type == CmarkNodeType.codeBlock) {
      final content = node.content.toString();

      // Only finalize if not already finalized (content non-empty)
      // Already-finalized blocks have content cleared and literal set
      if (content.isEmpty) {
        // Already finalized - skip
      } else if (node.codeData.isFenced) {
        var pos = 0;
        while (pos < content.length && content.codeUnitAt(pos) != 0x0A) {
          pos++;
        }
        if (pos < content.length) {
          node.codeData.info = content.substring(0, pos).trim();
          pos++;
          if (pos < content.length &&
              content.codeUnitAt(pos - 1) == 0x0D &&
              content.codeUnitAt(pos) == 0x0A) {
            pos++;
          }
          node.codeData.literal = content.substring(pos);
        } else {
          node.codeData.info = content.trim();
          node.codeData.literal = '';
        }
      } else {
        var literal = content;
        while (literal.endsWith('\n\n')) {
          literal = literal.substring(0, literal.length - 1);
        }
        node.codeData.literal = literal;
      }
      node.content.clear();
    }

    // Recurse to children
    var child = node.firstChild;
    while (child != null) {
      _finalizeTreeRecursive(child);
      child = child.next;
    }
  }

  void _linkFootnotes(CmarkNode root) {
    // First pass: collect all footnote definitions
    final iter1 = CmarkIter(root);
    var evType = iter1.next();
    while (evType != CmarkEventType.done) {
      final node = iter1.node;
      if (evType == CmarkEventType.exit &&
          node.type == CmarkNodeType.footnoteDefinition) {
        footnoteMap.add(node.content.toString(), node);
      }
      evType = iter1.next();
    }

    // Second pass: link references to definitions and assign indices
    var ix = 0;
    final iter2 = CmarkIter(root);
    evType = iter2.next();
    while (evType != CmarkEventType.done) {
      final node = iter2.node;
      if (evType == CmarkEventType.exit &&
          node.type == CmarkNodeType.footnoteReference) {
        final label = node.content.toString();
        final footnote = footnoteMap.lookup(label);
        if (footnote != null) {
          // Assign index to definition if first time
          if (footnote.node.footnoteReferenceIndex == 0) {
            ix++;
            footnote.node.footnoteReferenceIndex = ix;
          }

          // Set reference to point to definition
          footnote.node.footnoteDefCount++;
          node.footnoteRefIndex = footnote.node.footnoteDefCount;

          // Copy definition's index to reference for rendering
          node.footnoteReferenceIndex = footnote.node.footnoteReferenceIndex;

          // For rendering, we need to access the definition's label
          node.footnoteDefLabel = label;
        }
      }
      evType = iter2.next();
    }
  }

  void _initialize() {
    root.flags |= 1; // OPEN
    current = root;
  }

  int _findNewline(String text) {
    for (var i = 0; i < text.length; i++) {
      final ch = text.codeUnitAt(i);
      if (ch == 0x0A || ch == 0x0D) {
        return i;
      }
    }
    return -1;
  }

  int _processLineCount = 0;

  void _processLine(String line) {
    _processLineCount++;
    if (_processLineCount > 10000) {
      throw StateError('SAFETY: _processLine called $_processLineCount times');
    }

    lineNumber++;
    _currentLine = line;
    offset = 0;
    column = 0;
    firstNonspace = 0;
    firstNonspaceColumn = 0;
    indent = 0;
    blank = false;
    partiallyConsumedTab = false;
    _skipAddText = false;

    // Phase 1: Check open containers
    final checkResult = _checkOpenBlocks();
    if (checkResult.container == null) {
      lastLineLength = line.length;
      return;
    }

    var container = checkResult.container!;
    final lastMatchedContainer = container;
    final allMatched = checkResult.allMatched;

    // Phase 2: Open new blocks
    container = _openNewBlocks(container, allMatched);

    // Phase 3: Add text to container
    if (!_skipAddText) {
      _addTextToContainer(container, lastMatchedContainer);
    }
    lastLineLength = line.length;
  }

  _CheckOpenBlocksResult _checkOpenBlocks() {
    var container = root;
    var allMatched = true;

    while (_isOpen(container.lastChild)) {
      container = container.lastChild!;
      
      _findFirstNonspace();

      final matched = _checkContinuation(container);
      if (!matched) {
        allMatched = false;
        // Finalize the unmatched container before returning parent
        container = _finalize(container);
        return _CheckOpenBlocksResult(container, allMatched);
      }
    }

    return _CheckOpenBlocksResult(container, allMatched);
  }

  bool _isOpen(CmarkNode? node) {
    return node != null && (node.flags & 1) != 0; // OPEN flag
  }

  bool _checkContinuation(CmarkNode container) {
    switch (container.type) {
      case CmarkNodeType.blockQuote:
        return _parseBlockQuotePrefix();
      case CmarkNodeType.item:
        return _parseNodeItemPrefix(container);
      case CmarkNodeType.codeBlock:
        return _parseCodeBlockPrefix(container);
      case CmarkNodeType.heading:
        return false; // Headings never continue
      case CmarkNodeType.paragraph:
        return !blank;
      case CmarkNodeType.table:
        // Table continues if line has pipes AND is not a delimiter row
        if (blank || !_currentLine.contains('|')) {
          return false;
        }
        // Don't continue on delimiter rows
        if (_scanTableStart(firstNonspace)) {
          return false;
        }
        return true;
      case CmarkNodeType.footnoteDefinition:
        return _parseFootnoteDefinitionPrefix();
      default:
        return true;
    }
  }

  bool _parseBlockQuotePrefix() {
    if (indent > 3) {
      return false;
    }
    if (_charAt(firstNonspace) != 0x3E) {
      // '>'
      return false;
    }
    _advanceOffset(indent + 1, true);
    if (_isSpaceOrTab(_charAt(offset))) {
      _advanceOffset(1, true);
    }
    return true;
  }

  bool _parseNodeItemPrefix(CmarkNode container) {
    final itemData = container.listData;
    final neededIndent = itemData.markerOffset + itemData.padding;

    if (indent >= neededIndent) {
      _advanceOffset(neededIndent, true);
      return true;
    } else if (blank && container.firstChild != null) {
      // Blank lines continue if item has content
      _advanceOffset(firstNonspace - offset, false);
      return true;
    }
    return false;
  }

  bool _parseCodeBlockPrefix(CmarkNode container) {
    if (!container.codeData.isFenced) {
      // Indented code
      if (indent >= kCodeIndent) {
        _advanceOffset(kCodeIndent, true);
        return true;
      } else if (blank) {
        _advanceOffset(firstNonspace - offset, false);
        return true;
      }
      return false;
    } else {
      // Fenced code - check for closing fence
      final fenceChar = container.codeData.fenceChar;
      final fenceLen = container.codeData.fenceLength;

      if (indent <= 3 && _charAt(firstNonspace) == fenceChar) {
        final closingLen = _scanCloseFence(firstNonspace, fenceChar);
        if (closingLen >= fenceLen) {
          // Closing fence found - consume entire line and close block
          _advanceOffset(_currentLine.length - offset, false);
          return false; // This will cause checkOpenBlocks to return parent, closing the block
        }
      }

      // Not a closing fence - skip fence offset spaces
      var i = container.codeData.fenceOffset;
      while (i > 0 && _isSpaceOrTab(_charAt(offset))) {
        _advanceOffset(1, true);
        i--;
      }
      return true;
    }
  }

  bool _parseFootnoteDefinitionPrefix() {
    if (indent >= 4) {
      _advanceOffset(4, true);
      return true;
    } else if (blank) {
      return true;
    }
    return false;
  }

  int _scanCloseFence(int pos, int fenceChar) {
    var count = 0;
    while (_charAt(pos) == fenceChar) {
      count++;
      pos++;
    }
    final next = _charAt(pos);
    if (next == 0x0A || next == 0x0D || next == 0) {
      return count;
    }
    return 0;
  }

  CmarkNode _openNewBlocks(CmarkNode container, bool allMatched) {
    var iterations = 0;
    final maybeLazy = current.type == CmarkNodeType.paragraph;

    while (container.type != CmarkNodeType.codeBlock &&
        container.type != CmarkNodeType.htmlBlock &&
        container.type != CmarkNodeType.table) {
      iterations++;
      if (iterations > 50) {
        throw StateError('Infinite loop in _openNewBlocks');
      }
      _findFirstNonspace();
      final indented = indent >= kCodeIndent;

      // Try block quote
      if (!indented && _charAt(firstNonspace) == 0x3E) {
        _advanceOffset(firstNonspace + 1 - offset, false);
        if (_isSpaceOrTab(_charAt(offset))) {
          _advanceOffset(1, true);
        }
        container = _addChild(container, CmarkNodeType.blockQuote);
        continue;
      }

      // Try ATX heading
      if (!indented) {
        final headingMatch = _scanAtxHeading(firstNonspace);
        if (headingMatch > 0) {
          _advanceOffset(firstNonspace + headingMatch - offset, false);
          container = _addChild(container, CmarkNodeType.heading);
          container.headingData
            ..level = headingMatch
            ..setext = false;
          // Headings accept lines - break so add_text_to_container processes rest
          break;
        }
      }

      // Try fenced code
      if (!indented) {
        final fenceMatch = _scanOpenCodeFence(firstNonspace);
        if (fenceMatch > 0) {
          container = _addChild(container, CmarkNodeType.codeBlock);
          container.codeData
            ..isFenced = true
            ..fenceChar = _charAt(firstNonspace)
            ..fenceLength = fenceMatch
            ..fenceOffset = firstNonspace - offset;

          // Advance past fence, rest of line becomes first line of content (for info extraction in finalize)
          _advanceOffset(firstNonspace + fenceMatch - offset, false);
          break; // Don't continue - allow rest of line to be added as content
        }
      }

      // Try setext heading (must come before thematic break)
      if (!indented && container.type == CmarkNodeType.paragraph) {
        final setextLevel = _scanSetextHeadingLine(firstNonspace);
        if (setextLevel > 0) {
          // Resolve reference definitions first (C does this before converting)
          final hasContent = _resolveReferenceLinkDefinitions(container);

          if (hasContent) {
            // Convert paragraph to heading
            container.type = CmarkNodeType.heading;
            // Initialize heading data since it wasn't created as a heading
            container.initializeHeadingData();
            container.headingData
              ..level = setextLevel
              ..setext = true;
            // Consume entire line so underline doesn't get added to content
            _advanceOffset(_currentLine.length - offset, false);
            // Close the heading immediately
            _finalize(container);
          }
          break;
        }
      }

      // Try thematic break (after setext check)
      // Port: !(cont_type == CMARK_NODE_PARAGRAPH && !all_matched)
      // Meaning: allow thematic break UNLESS it's a lazily continued paragraph
      if (!indented &&
          !(container.type == CmarkNodeType.paragraph && !allMatched) &&
          _scanThematicBreak(firstNonspace) > 0) {
        container = _addChild(container, CmarkNodeType.thematicBreak);
        // Consume entire line
        _advanceOffset(_currentLine.length - offset, false);
        // Don't finalize here - C doesn't. The loop will break because thematic break doesn't accept lines
        break;
      }

      // Try table (must come before other checks)
      if (!indented && container.type == CmarkNodeType.paragraph) {
        if (_scanTableStart(firstNonspace)) {
          // This is a delimiter row - convert paragraph to table
          final paraContent = container.content.toString();
          // Strip trailing newline from para content
          final headerText = paraContent.endsWith('\n')
              ? paraContent.substring(0, paraContent.length - 1)
              : paraContent;

          final headerCells = _parseTableRow(headerText);
          final alignments =
              _parseTableDelimiterRow(_currentLine.substring(firstNonspace));

          if (headerCells.length == alignments.length &&
              headerCells.isNotEmpty) {
            // Valid table - convert paragraph to table
            container.type = CmarkNodeType.table;
            container.content.clear();

            // Create header row
            final headerRow = _addChild(container, CmarkNodeType.tableRow);
            headerRow.tableRowData.isHeader = true;
            for (var i = 0; i < headerCells.length; i++) {
              final cell = _addChild(headerRow, CmarkNodeType.tableCell);
              cell.initializeTableCellData();
              cell.tableCellData.align = alignments[i];
              cell.content.write(headerCells[i]);
            }
            _finalize(headerRow);

            // Store alignments for body rows
            _currentTableAlignments = alignments;

            // Consume delimiter line completely - don't add it as content
            _advanceOffset(_currentLine.length - offset, false);
            // Mark that we handled this line - don't call _addTextToContainer
            _skipAddText = true;
            current = container;
            break;
          }
        }
      }

      // Try footnote definition
      if (!indented) {
        final footnoteMatch = _scanFootnoteDefinition(firstNonspace);
        if (footnoteMatch > 0) {
          // Extract label from [^label]:
          var labelEnd = firstNonspace + 2; // Skip [^
          while (_charAt(labelEnd) != 0x5D && _charAt(labelEnd) != 0) {
            labelEnd++;
          }
          if (_charAt(labelEnd) == 0x5D) {
            final label = _currentLine.substring(firstNonspace + 2, labelEnd);
            _advanceOffset(firstNonspace + footnoteMatch - offset, false);
            container = _addChild(container, CmarkNodeType.footnoteDefinition);
            container.content.write(label);
            continue;
          }
        }
      }

      // Try list marker
      if ((!indented || container.type == CmarkNodeType.list) && indent < 4) {
        // Check if interrupting a paragraph
        final interruptsPara = container.type == CmarkNodeType.paragraph;
        final listData = _parseListMarker(firstNonspace, interruptsPara);
        if (listData != null) {
          _advanceOffset(firstNonspace + listData.markerLength - offset, false);

          // Calculate padding
          final saveOffset = offset;
          final saveColumn = column;
          final saveTab = partiallyConsumedTab;

          while (column - saveColumn <= 5 && _isSpaceOrTab(_charAt(offset))) {
            _advanceOffset(1, true);
          }

          final i = column - saveColumn;
          if (i >= 5 ||
              i < 1 ||
              _charAt(offset) == 0x0A ||
              _charAt(offset) == 0) {
            listData.padding = listData.markerLength + 1;
            offset = saveOffset;
            column = saveColumn;
            partiallyConsumedTab = saveTab;
            if (i > 0) {
              _advanceOffset(1, true);
            }
          } else {
            listData.padding = listData.markerLength + i;
          }

          listData.markerOffset = indent;

          // Check if we can reuse existing list
          if (container.type != CmarkNodeType.list ||
              !_listsMatch(container.listData, listData)) {
            // Create new list (add_child will finalize parents as needed)
            container = _addChild(container, CmarkNodeType.list);
            _copyListData(container.listData, listData);
          }

          // Add item
          container = _addChild(container, CmarkNodeType.item);
          _copyListData(container.listData, listData);

          // Check for task list marker ([ ] or [x])
          if (_charAt(offset) == 0x5B) {
            // '['
            if (_charAt(offset + 1) == 0x20 &&
                _charAt(offset + 2) == 0x5D &&
                _charAt(offset + 3) == 0x20) {
              // '[ ] '
              container.listData.checked = false;
              _advanceOffset(4, true);
            } else if ((_charAt(offset + 1) == 0x78 ||
                    _charAt(offset + 1) == 0x58) &&
                _charAt(offset + 2) == 0x5D &&
                _charAt(offset + 3) == 0x20) {
              // '[x] ' or '[X] '
              container.listData.checked = true;
              _advanceOffset(4, true);
            }
          }

          continue;
        }
      }

      // Try indented code
      if (indented && !maybeLazy && !blank) {
        _advanceOffset(kCodeIndent, true);
        container = _addChild(container, CmarkNodeType.codeBlock);
        container.codeData
          ..isFenced = false
          ..info = '';
        continue;
      }

      // Nothing else matches
      break;
    }

    return container;
  }

  void _addTextToContainer(
      CmarkNode container, CmarkNode lastMatchedContainer) {
    _findFirstNonspace();

    if (blank && container.lastChild != null) {
      container.lastChild!.flags |= 2; // LAST_LINE_BLANK
    }

    // Set last_line_blank flag on container
    // Port of C's last_line_blank calculation
    final shouldSetBlank = blank &&
        container.type != CmarkNodeType.blockQuote &&
        container.type != CmarkNodeType.heading &&
        container.type != CmarkNodeType.thematicBreak &&
        !(container.type == CmarkNodeType.codeBlock &&
            container.codeData.isFenced) &&
        !(container.type == CmarkNodeType.item &&
            container.firstChild == null &&
            container.startLine == lineNumber);

    if (shouldSetBlank) {
      container.flags |= 2; // LAST_LINE_BLANK
    } else {
      container.flags &= ~2;
    }

    var tmp = container;
    var iterations = 0;
    while (tmp.parent != null && iterations < 100) {
      tmp.parent!.flags &= ~2; // Clear parent's LAST_LINE_BLANK
      tmp = tmp.parent!;
      iterations++;
    }
    if (iterations >= 100) {
      throw StateError('Infinite loop clearing parent flags');
    }

    // Lazy continuation for paragraphs
    if (current != lastMatchedContainer &&
        container == lastMatchedContainer &&
        !blank &&
        current.type == CmarkNodeType.paragraph) {
      _addLine(current);
    } else {
      if (container.type == CmarkNodeType.table) {
        // Add a table row
        _addTableRow(container);
      } else if (container.type == CmarkNodeType.codeBlock ||
          container.type == CmarkNodeType.htmlBlock) {
        _addLine(container);
      } else if (blank) {
        // Do nothing for blank lines
      } else if (_acceptsLines(container.type)) {
        if (container.type == CmarkNodeType.heading &&
            !container.headingData.setext) {
          _chopTrailingHashtags();
        }
        _advanceOffset(firstNonspace - offset, false);
        _addLine(container);
      } else {
        // Create paragraph
        container = _addChild(container, CmarkNodeType.paragraph);
        _advanceOffset(firstNonspace - offset, false);
        _addLine(container);
      }

      current = container;
    }
  }

  void _addLine(CmarkNode node) {
    if (partiallyConsumedTab) {
      offset++;
      final charsToTab = kTabStop - (column % kTabStop);
      for (var i = 0; i < charsToTab; i++) {
        node.content.writeCharCode(0x20);
      }
    }
    if (offset < _currentLine.length) {
      node.content.write(_currentLine.substring(offset));
    }
    // Add newline separator (like cmark's add_line does)
    node.content.writeCharCode(0x0A);
  }

  bool _acceptsLines(CmarkNodeType type) {
    return type == CmarkNodeType.paragraph ||
        type == CmarkNodeType.heading ||
        type == CmarkNodeType.codeBlock;
  }

  void _chopTrailingHashtags() {
    // Port of chop_trailing_hashtags from blocks.c
    // First rtrim (remove trailing whitespace)
    var end = _currentLine.length;
    while (end > offset) {
      final c = _currentLine.codeUnitAt(end - 1);
      if (c != 0x20 && c != 0x09 && c != 0x0A && c != 0x0D) {
        break;
      }
      end--;
    }

    final origEnd = end;

    // Count trailing #s
    while (end > offset && _currentLine.codeUnitAt(end - 1) == 0x23) {
      end--;
    }

    // Check for space before the #s
    if (end != origEnd &&
        end > offset &&
        _isSpaceOrTab(_currentLine.codeUnitAt(end - 1))) {
      _currentLine = _currentLine.substring(0, end);
      // rtrim again
      while (_currentLine.isNotEmpty &&
          _isSpaceOrTab(_currentLine.codeUnitAt(_currentLine.length - 1))) {
        _currentLine = _currentLine.substring(0, _currentLine.length - 1);
      }
    }
  }

  CmarkNode _addChild(CmarkNode parent, CmarkNodeType type) {
    // Find appropriate parent
    var finalizeCount = 0;
    while (!parent.canContain(type)) {
      finalizeCount++;
      parent = _finalize(parent);
      if (finalizeCount > 10) {
        throw StateError('SAFETY: _addChild finalized $finalizeCount times');
      }
    }

    final child = CmarkNode(type);
    child.flags |= 1; // OPEN
    child.startLine = lineNumber;
    child.startColumn = column + 1;
    child.parent = parent;

    if (parent.lastChild != null) {
      parent.lastChild!.next = child;
      child.previous = parent.lastChild;
    } else {
      parent.firstChild = child;
    }
    parent.lastChild = child;

    return child;
  }

  CmarkNode _finalize(CmarkNode node) {
    node.flags &= ~1; // Clear OPEN flag

    final parent = node.parent;

    if (parent == null) {
      // Finalizing root - special case
      node.endLine = lineNumber;
      node.endColumn = lastLineLength;
      return node; // Return root itself since it has no parent
    }

    node.endLine = lineNumber - 1;
    node.endColumn = lastLineLength;

    // Type-specific finalization
    switch (node.type) {
      case CmarkNodeType.paragraph:
        // Resolve reference link definitions (port of resolve_reference_link_definitions)
        final hasContent = _resolveReferenceLinkDefinitions(node);
        if (!hasContent) {
          // Paragraph becomes just reference definitions - remove it
          node.unlink();
        }
        break;

      case CmarkNodeType.heading:
        // Strip trailing newlines from heading content
        final headingContent = node.content.toString();
        if (headingContent.endsWith('\n')) {
          node.content.clear();
          node.content
              .write(headingContent.substring(0, headingContent.length - 1));
        }
        break;

      case CmarkNodeType.codeBlock:
        final content = node.content.toString();
        if (node.codeData.isFenced) {
          // First line is info string
          var pos = 0;
          while (pos < content.length && content.codeUnitAt(pos) != 0x0A) {
            pos++;
          }

          if (pos < content.length) {
            final infoLine = content.substring(0, pos);
            node.codeData.info = infoLine.trim();

            // Skip past newline
            pos++;
            if (pos < content.length &&
                content.codeUnitAt(pos - 1) == 0x0D &&
                content.codeUnitAt(pos) == 0x0A) {
              pos++;
            }

            node.codeData.literal = content.substring(pos);
          } else {
            node.codeData.info = content.trim();
            node.codeData.literal = '';
          }
        } else {
          // Indented code - remove trailing blank lines
          var literal = content;
          while (literal.endsWith('\n\n')) {
            literal = literal.substring(0, literal.length - 1);
          }
          node.codeData.literal = literal;
        }
        // Clear content buffer since we moved it to literal
        node.content.clear();
        break;

      case CmarkNodeType.footnoteDefinition:
        // Register footnote in map
        final label = node.content.toString();
        if (label.isNotEmpty) {
          footnoteMap.add(label, node);
        }
        break;

      case CmarkNodeType.list:
        // Determine tight/loose
        node.listData.tight = _calculateTightness(node);
        break;

      default:
        break;
    }

    return parent;
  }

  bool _calculateTightness(CmarkNode list) {
    var item = list.firstChild;
    while (item != null) {
      if ((item.flags & 2) != 0 && item.next != null) {
        return false; // Non-final item ends with blank
      }
      var subitem = item.firstChild;
      while (subitem != null) {
        if ((item.next != null || subitem.next != null) &&
            _endsWithBlank(subitem)) {
          return false;
        }
        subitem = subitem.next;
      }
      item = item.next;
    }
    return true;
  }

  bool _endsWithBlank(CmarkNode node) {
    if ((node.flags & 4) != 0) {
      // LAST_LINE_CHECKED
      return (node.flags & 2) != 0; // LAST_LINE_BLANK
    }
    if ((node.type == CmarkNodeType.list || node.type == CmarkNodeType.item) &&
        node.lastChild != null) {
      node.flags |= 4;
      return _endsWithBlank(node.lastChild!);
    }
    node.flags |= 4;
    return (node.flags & 2) != 0;
  }

  /// Port of resolve_reference_link_definitions from blocks.c
  bool _resolveReferenceLinkDefinitions(CmarkNode para) {
    var content = para.content.toString();

    // Strip trailing newline first (like C does before parsing refs)
    if (content.endsWith('\n')) {
      content = content.substring(0, content.length - 1);
    }

    final bytes = Uint8List.fromList(utf8.encode(content));
    var pos = 0;

    // Keep parsing while we have '[' at current position
    while (pos < bytes.length && bytes[pos] == 0x5B) {
      final consumed = parseReferenceInline(
        Uint8List.sublistView(bytes, pos),
        referenceMap,
      );

      if (consumed == 0) {
        break; // No more references
      }

      pos += consumed;
    }

    // Update paragraph content with remaining (after stripping refs)
    final remaining = bytes.sublist(pos);
    para.content.clear();
    para.content.write(utf8.decode(remaining, allowMalformed: true));

    // Return true if content remains
    final remainingContent = para.content.toString().trim();
    return remainingContent.isNotEmpty;
  }

  _ListMarkerResult? _parseListMarker(int pos, bool interruptsParagraph) {
    final c = _charAt(pos);

    // Bullet list
    if (c == 0x2A || c == 0x2D || c == 0x2B) {
      final nextChar = _charAt(pos + 1);
      // Next char must be space, tab, newline, or EOF
      if (!_isSpaceOrTab(nextChar) && nextChar != 0x0A && nextChar != 0) {
        return null;
      }
      if (interruptsParagraph) {
        // Require non-blank after marker
        var i = pos + 1;
        while (_isSpaceOrTab(_charAt(i))) {
          i++;
        }
        if (_charAt(i) == 0x0A || _charAt(i) == 0) {
          return null;
        }
      }
      return _ListMarkerResult(
        markerLength: 1,
        listType: CmarkListType.bullet,
        bulletChar: c,
        start: 0,
        delimiter: CmarkDelimType.period, // Not used for bullets
      );
    }

    // Ordered list
    if (_isDigit(c)) {
      var start = 0;
      var digits = 0;
      var i = pos;

      while (digits < 9 && _isDigit(_charAt(i))) {
        start = start * 10 + (_charAt(i) - 0x30);
        i++;
        digits++;
      }

      if (interruptsParagraph && start != 1) {
        return null;
      }

      final delim = _charAt(i);
      if (delim != 0x2E && delim != 0x29) {
        return null;
      }

      final nextChar = _charAt(i + 1);
      // Next char must be space, tab, newline, or EOF
      if (!_isSpaceOrTab(nextChar) && nextChar != 0x0A && nextChar != 0) {
        return null;
      }

      if (interruptsParagraph) {
        var j = i + 1;
        while (_isSpaceOrTab(_charAt(j))) {
          j++;
        }
        if (_charAt(j) == 0x0A || _charAt(j) == 0) {
          return null;
        }
      }

      return _ListMarkerResult(
        markerLength: i - pos + 1,
        listType: CmarkListType.ordered,
        start: start,
        bulletChar: 0,
        delimiter:
            delim == 0x2E ? CmarkDelimType.period : CmarkDelimType.parenthesis,
      );
    }

    return null;
  }

  bool _listsMatch(CmarkListData a, _ListMarkerResult b) {
    return a.listType == b.listType &&
        a.delimiter == b.delimiter &&
        a.bulletChar == b.bulletChar;
  }

  void _copyListData(CmarkListData dest, _ListMarkerResult src) {
    dest.listType = src.listType;
    dest.start = src.start;
    dest.bulletChar = src.bulletChar;
    dest.delimiter = src.delimiter;
    dest.markerOffset = src.markerOffset;
    dest.padding = src.padding;
  }

  int _scanAtxHeading(int pos) {
    var count = 0;
    while (_charAt(pos) == 0x23 && count < 6) {
      count++;
      pos++;
    }
    if (count == 0) return 0;
    final next = _charAt(pos);
    if (next != 0x20 && next != 0x09 && next != 0x0A && next != 0) {
      return 0;
    }
    return count;
  }

  int _scanOpenCodeFence(int pos) {
    final c = _charAt(pos);
    if (c != 0x60 && c != 0x7E) return 0; // ` or ~

    var count = 0;
    while (_charAt(pos) == c) {
      count++;
      pos++;
    }

    if (count < 3) return 0;

    // Info string validation
    if (c == 0x60) {
      // For backticks: info string can't contain backticks
      while (_charAt(pos) != 0x0A && _charAt(pos) != 0) {
        if (_charAt(pos) == 0x60) return 0;
        pos++;
      }
    } else {
      // For tildes: just skip to end of line
      while (_charAt(pos) != 0x0A && _charAt(pos) != 0) {
        pos++;
      }
    }

    // C uses lookahead / [\r\n] which requires newline or EOF
    // In our case, we're reading _currentLine which already strips newlines,
    // so just check we're at end of current line
    final endChar = _charAt(pos);
    if (endChar != 0 && endChar != 0x0A && endChar != 0x0D) {
      return 0; // Not at end of line
    }

    return count;
  }

  int _scanFootnoteDefinition(int pos) {
    // Check for [^label]:
    if (_charAt(pos) != 0x5B || _charAt(pos + 1) != 0x5E) {
      return 0;
    }

    var i = pos + 2;
    while (_charAt(i) != 0x5D && _charAt(i) != 0 && _charAt(i) != 0x0A) {
      i++;
    }

    if (_charAt(i) != 0x5D) {
      return 0;
    }
    i++; // skip ]

    if (_charAt(i) != 0x3A) {
      return 0;
    }
    i++; // skip :

    return i - pos;
  }

  int _scanSetextHeadingLine(int pos) {
    final c = _charAt(pos);
    if (c != 0x3D && c != 0x2D) return 0; // = or -

    var i = pos;
    while (_charAt(i) == c) {
      i++;
    }

    // Must have at least one character
    if (i == pos) return 0;

    // Rest of line must be spaces/tabs or end
    while (_charAt(i) == 0x20 || _charAt(i) == 0x09) {
      i++;
    }

    final next = _charAt(i);
    if (next == 0x0A || next == 0x0D || next == 0) {
      return c == 0x3D ? 1 : 2; // = is level 1, - is level 2
    }

    return 0;
  }

  int _scanThematicBreak(int pos) {
    final c = _charAt(pos);
    if (c != 0x2A && c != 0x5F && c != 0x2D) return 0;

    var count = 0;
    var i = pos;
    var next = 0;

    while ((next = _charAt(i)) != 0) {
      if (next == c) {
        count++;
      } else if (next != 0x20 && next != 0x09) {
        break;
      }
      i++;
    }

    if (count >= 3 && (next == 0x0A || next == 0x0D || next == 0)) {
      return i - pos + 1;
    }
    return 0;
  }

  void _findFirstNonspace() {
    if (firstNonspace <= offset) {
      firstNonspace = offset;
      firstNonspaceColumn = column;
      var charsToTab = kTabStop - (column % kTabStop);

      while (true) {
        final c = _charAt(firstNonspace);
        if (c == 0x20) {
          firstNonspace++;
          firstNonspaceColumn++;
          charsToTab--;
          if (charsToTab == 0) {
            charsToTab = kTabStop;
          }
        } else if (c == 0x09) {
          firstNonspace++;
          firstNonspaceColumn += charsToTab;
          charsToTab = kTabStop;
        } else {
          break;
        }
      }
    }

    indent = firstNonspaceColumn - column;
    blank = _charAt(firstNonspace) == 0x0A ||
        _charAt(firstNonspace) == 0x0D ||
        _charAt(firstNonspace) == 0;
  }

  void _advanceOffset(int count, bool columns) {
    while (count > 0) {
      final c = _charAt(offset);
      if (c == 0) break;

      if (c == 0x09) {
        final charsToTab = kTabStop - (column % kTabStop);
        if (columns) {
          partiallyConsumedTab = charsToTab > count;
          final advance = count < charsToTab ? count : charsToTab;
          column += advance;
          offset += partiallyConsumedTab ? 0 : 1;
          count -= advance;
        } else {
          partiallyConsumedTab = false;
          column += charsToTab;
          offset++;
          count--;
        }
      } else {
        partiallyConsumedTab = false;
        offset++;
        column++;
        count--;
      }
    }
  }

  int _charAt(int pos) {
    if (pos < 0 || pos >= _currentLine.length) {
      return 0;
    }
    return _currentLine.codeUnitAt(pos);
  }

  bool _isSpaceOrTab(int c) => c == 0x20 || c == 0x09;
  bool _isDigit(int c) => c >= 0x30 && c <= 0x39;

  void _processInlines(CmarkNode node, InlineParser inlineParser) {
    var childCount = node.children.length;
    if (childCount > 1000000) {
      throw StateError(
          'SAFETY: Node ${node.type.name} has $childCount children');
    }

    inlineParser.parseInlines(node);

    var processed = 0;
    for (final child in node.children) {
      processed++;
      if (processed > 1000000) {
        throw StateError(
            'SAFETY: Processed $processed children of ${node.type.name}');
      }
      _processInlines(child, inlineParser);
    }
  }

  void _appendFootnotes(CmarkNode root) {
    // Move footnote definitions to end of document (C's create_footnote_list)
    final footnotes = footnoteMap.getAllSorted();
    for (final footnote in footnotes) {
      // Unlink from current position and append to root
      footnote.node.unlink();
      root.appendChild(footnote.node);
    }
  }

  bool _scanTableStart(int pos) {
    // Table delimiter must have at least one pipe and dashes/colons
    final line = _currentLine.substring(pos);
    if (!line.contains('|')) {
      return false;
    }

    final pattern = RegExp(r'^\|?\s*:?-+:?\s*(\|\s*:?-+:?\s*)+\|?\s*$');
    return pattern.hasMatch(line);
  }

  List<CmarkTableAlign> _parseTableDelimiterRow(String line) {
    var trimmed = line.trim();
    if (trimmed.startsWith('|')) {
      trimmed = trimmed.substring(1);
    }
    if (trimmed.endsWith('|')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }

    final cells = trimmed.split('|');
    final alignments = <CmarkTableAlign>[];

    for (final cell in cells) {
      final cleaned = cell.trim();
      if (cleaned.isEmpty) continue;

      final startsColon = cleaned.startsWith(':');
      final endsColon = cleaned.endsWith(':');

      if (startsColon && endsColon) {
        alignments.add(CmarkTableAlign.center);
      } else if (startsColon) {
        alignments.add(CmarkTableAlign.left);
      } else if (endsColon) {
        alignments.add(CmarkTableAlign.right);
      } else {
        alignments.add(CmarkTableAlign.none);
      }
    }

    return alignments;
  }

  List<String> _parseTableRow(String line) {
    // Port of row_from_string() from table.c
    // Scans for cell boundaries, respecting backslashes
    var trimmed = line.trim();
    if (trimmed.startsWith('|')) {
      trimmed = trimmed.substring(1);
    }
    if (trimmed.endsWith('|')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }

    final cells = <String>[];
    var cellStart = 0;

    for (var pos = 0; pos < trimmed.length; pos++) {
      final ch = trimmed.codeUnitAt(pos);

      // Skip escaped characters (including \|)
      if (ch == 0x5C && pos + 1 < trimmed.length) {
        pos++; // Skip next char
        continue;
      }

      if (ch == 0x7C) {
        // |
        // Found unescaped pipe - cell boundary
        final cellContent = trimmed.substring(cellStart, pos);
        cells.add(_unescapePipes(cellContent).trim());
        cellStart = pos + 1;
      }
    }

    // Add final cell
    final finalCell = trimmed.substring(cellStart);
    cells.add(_unescapePipes(finalCell).trim());

    return cells;
  }

  String _unescapePipes(String s) {
    // Remove backslashes before pipes: \| → |
    final result = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (s.codeUnitAt(i) == 0x5C &&
          i + 1 < s.length &&
          s.codeUnitAt(i + 1) == 0x7C) {
        // Skip backslash, write pipe
        i++;
        result.writeCharCode(s.codeUnitAt(i));
      } else {
        result.writeCharCode(s.codeUnitAt(i));
      }
    }
    return result.toString();
  }

  void _addTableRow(CmarkNode table) {
    final alignments = _currentTableAlignments;
    if (alignments == null) {
      return;
    }

    final cells = _parseTableRow(_currentLine);
    final nColumns = alignments.length; // Number of columns in header

    final row = _addChild(table, CmarkNodeType.tableRow);
    row.tableRowData.isHeader = false; // Body row, not header

    // Add cells from parsed row (up to nColumns)
    for (var i = 0; i < cells.length && i < nColumns; i++) {
      final cell = _addChild(row, CmarkNodeType.tableCell);
      cell.initializeTableCellData();
      cell.tableCellData.align = alignments[i];
      cell.content.write(cells[i]);
    }

    // Auto-complete with empty cells if row is short
    for (var i = cells.length; i < nColumns; i++) {
      final cell = _addChild(row, CmarkNodeType.tableCell);
      cell.initializeTableCellData();
      cell.tableCellData.align = alignments[i];
      // Leave content empty
    }

    _finalize(row);

    // Consume entire line
    _advanceOffset(_currentLine.length - offset, false);
  }
}

class _CheckOpenBlocksResult {
  _CheckOpenBlocksResult(this.container, this.allMatched);
  final CmarkNode? container;
  final bool allMatched;
}

class _ListMarkerResult {
  _ListMarkerResult({
    required this.markerLength,
    required this.listType,
    required this.start,
    required this.bulletChar,
    required this.delimiter,
  });

  final int markerLength;
  final CmarkListType listType;
  final int start;
  final int bulletChar;
  final CmarkDelimType delimiter;
  int padding = 0;
  int markerOffset = 0;
}
