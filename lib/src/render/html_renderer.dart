import '../node.dart';
import '../util/node_iterator.dart';
import '../houdini/href_escape.dart';

class HtmlRenderer {
  HtmlRenderer({this.safe = false});

  final bool safe;
  final StringBuffer _output = StringBuffer();
  bool _inTableHeader = false;
  bool _needClosingTableBody = false;
  CmarkNode?
      _plainTextMode; // When set, render children as plain text (for image alt)
  bool _inFootnoteSection = false;
  final Set<CmarkNode> _footnotesWithInlineBackrefs = <CmarkNode>{};

  String render(CmarkNode root) {
    _output.clear();
    _inTableHeader = false;
    _needClosingTableBody = false;
    _plainTextMode = null;
    _footnotesWithInlineBackrefs.clear();
    _inFootnoteSection = false;

    // Use iterator like C's cmark_iter
    final iter = CmarkIter(root);
    CmarkEventType evType;

    while ((evType = iter.next()) != CmarkEventType.done) {
      final node = iter.node;

      // Check if we're exiting plain text mode
      if (_plainTextMode == node && evType == CmarkEventType.exit) {
        _plainTextMode = null;
      }

      // If in plain text mode, only output text content
      if (_plainTextMode != null && _plainTextMode != node) {
        if (evType == CmarkEventType.enter) {
          switch (node.type) {
            case CmarkNodeType.text:
            case CmarkNodeType.code:
              _output.write(_escapeHtml(node.content.toString()));
              break;
            case CmarkNodeType.linebreak:
            case CmarkNodeType.softbreak:
              _output.write(' ');
              break;
            default:
              break;
          }
        }
        continue; // Skip normal rendering for children of plain text node
      }
      
      _renderNode(node, evType == CmarkEventType.enter);
    }
    
    // Close footnote section if it was opened
    if (_inFootnoteSection) {
      _output.write('</ol>\n</section>\n');
    }
    
    return _output.toString();
  }

  void _renderNode(CmarkNode node, bool entering) {
    switch (node.type) {
      case CmarkNodeType.document:
        // No output for document
        break;
      case CmarkNodeType.paragraph:
        // Check if this is in a tight list (grandparent is list and tight=true)
        var tight = false;
        final parent = node.parent;
        if (parent != null) {
          final grandparent = parent.parent;
          if (grandparent != null && grandparent.type == CmarkNodeType.list) {
            tight = grandparent.listData.tight;
          }
        }
        
        if (!tight) {
          if (entering) {
            _renderCr();
            _output.write('<p>');
          } else {
            final parentFootnote = node.parent;
            final isFootnoteParagraph = parentFootnote != null &&
                parentFootnote.type == CmarkNodeType.footnoteDefinition &&
                node.next == null;
            if (isFootnoteParagraph) {
              _renderFootnoteBackrefs(parentFootnote, inline: true);
              _footnotesWithInlineBackrefs.add(parentFootnote);
            }
            _output.write('</p>\n');
          }
        }
        break;
      case CmarkNodeType.heading:
        if (entering) {
          _renderCr();
          final level = node.headingData.level;
          _output.write('<h$level>');
        } else {
          final level = node.headingData.level;
          _output.write('</h$level>\n');
        }
        break;
      case CmarkNodeType.blockQuote:
        if (entering) {
          _renderCr();
          _output.write('<blockquote>\n');
        } else {
          _renderCr();
          _output.write('</blockquote>\n');
        }
        break;
      case CmarkNodeType.list:
        if (entering) {
          _renderCr();
          final tag =
              node.listData.listType == CmarkListType.ordered ? 'ol' : 'ul';
          final start = node.listData.start;
          if (tag == 'ol' && start != 1) {
            _output.write('<$tag start="$start">\n');
          } else {
            _output.write('<$tag>\n');
          }
        } else {
          final tag =
              node.listData.listType == CmarkListType.ordered ? 'ol' : 'ul';
          _output.write('</$tag>\n');
        }
        break;
      case CmarkNodeType.item:
        if (entering) {
          _renderCr();
          final checked = node.listData.checked;
          if (checked != null) {
            final checkedAttr = checked ? 'checked="" ' : '';
            _output.write(
                '<li><input type="checkbox" ${checkedAttr}disabled="" /> ');
          } else {
            _output.write('<li>');
          }
        } else {
          _output.write('</li>\n');
        }
        break;
      case CmarkNodeType.codeBlock:
        if (entering) {
          _renderCr();
          final info = node.codeData.info;
          if (info.isNotEmpty) {
            final lang = _escapeHtml(info.split(' ').first);
            _output.write('<pre><code class="language-$lang">');
          } else {
            _output.write('<pre><code>');
          }
          _output.write(_escapeHtml(node.codeData.literal));
          _output.write('</code></pre>\n');
        }
        break;
      case CmarkNodeType.htmlBlock:
        if (entering) {
          _renderCr();
          if (!safe) {
            _output.write(node.content.toString());
          }
          _renderCr();
        }
        break;
      case CmarkNodeType.thematicBreak:
        if (entering) {
          _renderCr();
          _output.write('<hr />\n');
        }
        break;
      case CmarkNodeType.footnoteDefinition:
        if (entering) {
          if (!_inFootnoteSection) {
            _output.write('<section class="footnotes" data-footnotes>\n<ol>\n');
            _inFootnoteSection = true;
          }
          
          final label = escapeHref(node.content.toString());
          _output.write('<li id="fn-$label">\n');
        } else {
          if (!_footnotesWithInlineBackrefs.remove(node)) {
            _renderFootnoteBackrefs(node, inline: false);
            _output.write('\n');
          }

          _output.write('</li>\n');
        }
        break;
      case CmarkNodeType.footnoteReference:
        if (entering) {
          final label = escapeHref(node.content.toString());
          final defIndex = node
              .footnoteReferenceIndex; // The footnote's global index (1, 2, 3...)
          final refNum = node
              .footnoteRefIndex; // Which reference to this footnote (1st, 2nd, 3rd...)
          final suffix = refNum > 1 ? '-$refNum' : '';

          _output.write(
              '<sup class="footnote-ref"><a href="#fn-$label" id="fnref-$label$suffix" data-footnote-ref>$defIndex</a></sup>');
        }
        break;
      case CmarkNodeType.table:
        if (entering) {
          _output.write('<table>\n');
          _needClosingTableBody = false;
        } else {
          if (_needClosingTableBody) {
            _output.write('</tbody>\n');
          }
          _output.write('</table>\n');
          _needClosingTableBody = false;
        }
        break;
      case CmarkNodeType.tableRow:
        if (entering) {
          if (node.tableRowData.isHeader) {
            _inTableHeader = true;
            _output.write('<thead>\n');
          } else if (!_needClosingTableBody) {
            _output.write('<tbody>\n');
            _needClosingTableBody = true;
          }
          _output.write('<tr>\n');
        } else {
          _output.write('</tr>\n');
          if (node.tableRowData.isHeader) {
            _output.write('</thead>\n');
            _inTableHeader = false;
          }
        }
        break;
      case CmarkNodeType.tableCell:
        if (entering) {
          final align = node.tableCellData.align;
          final tag = _inTableHeader ? 'th' : 'td';
          final alignAttr =
              align != CmarkTableAlign.none ? ' align="${align.name}"' : '';
          _output.write('<$tag$alignAttr>');
        } else {
          final tag = _inTableHeader ? 'th' : 'td';
          _output.write('</$tag>\n');
        }
        break;
      case CmarkNodeType.text:
        if (entering) {
          _output.write(_escapeHtml(node.content.toString()));
        }
        break;
      case CmarkNodeType.softbreak:
        if (entering) {
          _output.write('\n');
        }
        break;
      case CmarkNodeType.linebreak:
        if (entering) {
          _output.write('<br />\n');
        }
        break;
      case CmarkNodeType.code:
        if (entering) {
          _output.write('<code>');
          _output.write(_escapeHtml(node.content.toString()));
          _output.write('</code>');
        }
        break;
      case CmarkNodeType.htmlInline:
        if (entering && !safe) {
          _output.write(node.content.toString());
        }
        break;
      case CmarkNodeType.emph:
        if (entering) {
          _output.write('<em>');
        } else {
          _output.write('</em>');
        }
        break;
      case CmarkNodeType.strong:
        // Check if parent is also strong - avoid double nesting
        if (node.parent == null || node.parent!.type != CmarkNodeType.strong) {
          if (entering) {
            _output.write('<strong>');
          } else {
            _output.write('</strong>');
          }
        }
        break;
      case CmarkNodeType.strikethrough:
        if (entering) {
          _output.write('<del>');
        } else {
          _output.write('</del>');
        }
        break;
      case CmarkNodeType.link:
        if (entering) {
          final url =
              escapeHref(node.linkData.url); // Use href escaping, not HTML
          final title = node.linkData.title;
          _output.write('<a href="$url"');
          if (title.isNotEmpty) {
            final escapedTitle = _escapeHtml(title);
            _output.write(' title="$escapedTitle"');
          }
          _output.write('>');
        } else {
          _output.write('</a>');
        }
        break;
      case CmarkNodeType.image:
        if (entering) {
          final url =
              escapeHref(node.linkData.url); // Use href escaping, not HTML
          _output.write('<img src="$url" alt="');
          _plainTextMode = node; // Enter plain text mode for children
        } else {
          final title = node.linkData.title;
          if (title.isNotEmpty) {
            final escapedTitle = _escapeHtml(title);
            _output.write('" title="$escapedTitle');
          }
          _output.write('" />');
        }
        break;
      case CmarkNodeType.math:
        if (entering) {
          final literal = node.mathData.literal;
          final escapedLiteral = _escapeHtml(literal);
          final classes = node.mathData.display
              ? 'math math-inline math-display'
              : 'math math-inline';
          _output.write(
              '<span class="$classes" data-latex="$escapedLiteral">$escapedLiteral</span>');
        }
        break;
      case CmarkNodeType.mathBlock:
        if (entering) {
          _renderCr();
          final literal = node.mathData.literal;
          final escapedLiteral = _escapeHtml(literal);
          _output.write(
              '<div class="math math-display" data-latex="$escapedLiteral">$escapedLiteral</div>\n');
        }
        break;
      default:
        // Unknown node types - do nothing
        break;
    }
  }

  void _renderFootnoteBackrefs(CmarkNode node, {required bool inline}) {
    final defCount = node.footnoteDefCount;
    if (defCount <= 0) {
      return;
    }

    final label = escapeHref(node.content.toString());
    final displayIndex = node.footnoteReferenceIndex;

    if (inline) {
      _output.write(' ');
    }

    if (defCount == 1) {
      _output.write(
          '<a href="#fnref-$label" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="$displayIndex" aria-label="Back to reference $displayIndex">↩</a>');
    } else {
      for (var i = 1; i <= defCount; i++) {
        final suffix = i == 1 ? '' : '-$i';
        _output.write(
            '<a href="#fnref-$label$suffix" class="footnote-backref" data-footnote-backref data-footnote-backref-idx="$displayIndex');
        if (i > 1) {
          _output.write('-$i');
        }
        _output.write('" aria-label="Back to reference $displayIndex');
        if (i > 1) {
          _output.write('-$i');
        }
        _output.write('">↩');
        if (i > 1) {
          _output.write('<sup class="footnote-ref">$i</sup>');
        }
        _output.write('</a>');
        if (i < defCount) {
          _output.write(' ');
        }
      }
    }

    if (!inline) {
      // Caller handles surrounding newlines.
    }
  }

  void _renderCr() {
    // Port of cmark_html_render_cr - output newline if buffer doesn't end with one
    // Only output if buffer is NOT empty and doesn't end with newline
    if (_output.isNotEmpty && !_output.toString().endsWith('\n')) {
      _output.write('\n');
    }
  }
  
  

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;');
  }
}
