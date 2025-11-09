import 'dart:convert';
import '../node.dart';

/// Postprocess text nodes to auto-link emails.
/// Port of postprocess_text() from autolink.c
void autolinkEmailPostprocess(CmarkNode root) {
  _walkTreeForTextNodes(root, (textNode) {
    // Skip if already inside a link
    if (_isInsideLink(textNode)) {
      return;
    }
    
    _processTextNodeForEmails(textNode);
  });
}

void _walkTreeForTextNodes(CmarkNode node, void Function(CmarkNode) callback) {
  if (node.type == CmarkNodeType.text) {
    callback(node);
  }
  
  var child = node.firstChild;
  while (child != null) {
    _walkTreeForTextNodes(child, callback);
    child = child.next;
  }
}

bool _isInsideLink(CmarkNode node) {
  var current = node.parent;
  while (current != null) {
    if (current.type == CmarkNodeType.link || current.type == CmarkNodeType.image) {
      return true;
    }
    current = current.parent;
  }
  return false;
}

void _processTextNodeForEmails(CmarkNode textNode) {
  final literal = textNode.content.toString();
  if (literal.isEmpty) {
    return;
  }
  
  final bytes = utf8.encode(literal);
  var start = 0;
  var offset = 0;
  
  while (offset < bytes.length) {
    // Look for @
    var atPos = -1;
    for (var i = offset; i < bytes.length; i++) {
      if (bytes[i] == 0x40) { // @
        atPos = i;
        break;
      }
    }
    
    if (atPos == -1) {
      break; // No more @
    }
    
    final maxRewind = atPos - start - offset;
    var rewind = 0;
    
    // Scan backwards for email start
    for (rewind = 0; rewind < maxRewind; rewind++) {
      final c = bytes[start + offset + maxRewind - rewind - 1];
      
      if (_isAlnum(c)) {
        continue;
      }
      
      if (c == 0x2E || c == 0x2B || c == 0x2D || c == 0x5F) {
        continue;
      }
      
      break;
    }
    
    if (rewind == 0) {
      offset += maxRewind + 1;
      continue;
    }
    
    // Scan forwards for domain
    var linkEnd = 1;
    var dotCount = 0;
    
    while (linkEnd < bytes.length - offset - maxRewind) {
      final c = bytes[start + offset + maxRewind + linkEnd];
      
      if (_isAlnum(c)) {
        linkEnd++;
        continue;
      }
      
      if (c == 0x2E && 
          linkEnd < bytes.length - offset - maxRewind - 1 &&
          _isAlnum(bytes[start + offset + maxRewind + linkEnd + 1])) {
        dotCount++;
        linkEnd++;
        continue;
      }
      
      if (c != 0x2D && c != 0x5F) {
        break;
      }
      
      linkEnd++;
    }
    
    // Must have at least 2 chars and a dot
    if (linkEnd < 2 || dotCount == 0) {
      offset += maxRewind + linkEnd;
      continue;
    }
    
    // Must end with alnum or dot
    final lastChar = bytes[start + offset + maxRewind + linkEnd - 1];
    if (!_isAlpha(lastChar) && lastChar != 0x2E) {
      offset += maxRewind + linkEnd;
      continue;
    }
    
    linkEnd = _autolinkDelim(bytes, start + offset + maxRewind, linkEnd);
    
    if (linkEnd == 0) {
      offset += maxRewind + 1;
      continue;
    }
    
    // Create link node
    final emailStart = start + offset + maxRewind - rewind;
    final emailEnd = start + offset + maxRewind + linkEnd;
    final emailText = utf8.decode(bytes.sublist(emailStart, emailEnd));
    
    final linkNode = CmarkNode(CmarkNodeType.link);
    linkNode.linkData.url = 'mailto:$emailText';
    linkNode.linkData.title = '';
    
    final linkText = CmarkNode(CmarkNodeType.text)
      ..content.write(emailText);
    linkNode.appendChild(linkText);
    
    // Insert link after text node
    textNode.parent?.insertAfter(textNode, linkNode);
    
    // Create text node for content after email
    if (emailEnd < bytes.length) {
      final afterNode = CmarkNode(CmarkNodeType.text)
        ..content.write(utf8.decode(bytes.sublist(emailEnd)));
      textNode.parent?.insertAfter(linkNode, afterNode);
    }
    
    // Update textNode to only have content before email
    textNode.content.clear();
    if (emailStart > 0) {
      textNode.content.write(utf8.decode(bytes.sublist(0, emailStart)));
    } else {
      // No text before - remove node
      textNode.unlink();
    }
    
    break; // Only process one email per text node (simplification)
  }
}

int _autolinkDelim(List<int> data, int start, int linkEnd) {
  var closing = 0;
  var opening = 0;
  
  // Count parens
  for (var i = start; i < start + linkEnd; i++) {
    if (data[i] == 0x28) {
      opening++;
    } else if (data[i] == 0x29) {
      closing++;
    }
  }
  
  // Trim trailing punctuation
  while (linkEnd > 0) {
    final ch = data[start + linkEnd - 1];
    
    // Allow ) if balanced
    if (ch == 0x29) {
      if (closing <= opening) {
        return linkEnd;
      }
      closing--;
      linkEnd--;
      continue;
    }
    
    // Trim common trailing punctuation
    if (ch == 0x3F || ch == 0x21 || ch == 0x2E || ch == 0x2C ||
        ch == 0x3A || ch == 0x2A || ch == 0x5F || ch == 0x7E ||
        ch == 0x27 || ch == 0x22) {
      linkEnd--;
      continue;
    }
    
    // Handle entity-like patterns at end (e.g., &mdash;)
    if (ch == 0x3B) {
      var entityStart = start + linkEnd - 2;
      while (entityStart > start && _isAlpha(data[entityStart])) {
        entityStart--;
      }
      if (entityStart > start && data[entityStart] == 0x26) {
        linkEnd = entityStart - start;
        continue;
      }
      linkEnd--;
      continue;
    }
    
    break;
  }
  
  return linkEnd;
}

bool _isAlnum(int c) => _isAlpha(c) || _isDigit(c);
bool _isAlpha(int c) => (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A);
bool _isDigit(int c) => c >= 0x30 && c <= 0x39;
