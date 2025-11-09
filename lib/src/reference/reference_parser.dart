import 'dart:typed_data';
import '../inline/link_parsing.dart';
import 'reference_map.dart';

/// Parse a reference link definition from a chunk.
/// Returns number of bytes consumed, or 0 if no valid reference found.
/// Port of cmark_parse_reference_inline from inlines.c
int parseReferenceInline(Uint8List input, CmarkReferenceMap refmap) {
  var pos = 0;
  
  // Parse label [label]
  final labelResult = LinkLabelResult();
  if (!linkLabel(input, pos, labelResult) || labelResult.label.isEmpty) {
    return 0;
  }
  pos = labelResult.endPos;
  
  // Expect colon
  if (pos >= input.length || input[pos] != 0x3A) { // :
    return 0;
  }
  pos++;
  
  // Skip spaces/newline (spnl)
  pos = _spnl(input, pos);
  
  // Parse URL (use reference-style scanner, not inline-link scanner)
  final urlResult = LinkUrlResult();
  final urlLen = scanLinkUrlForReference(input, pos, urlResult);
  if (urlLen <= 0) { // URL must be non-empty for reference definitions
    return 0;
  }
  pos += urlLen;
  
  // Parse optional title
  final beforeTitle = pos;
  pos = _spnl(input, pos);
  
  final titleResult = LinkTitleResult();
  final titleLen = (pos == beforeTitle) ? 0 : scanLinkTitle(input, pos, titleResult);
  
  String title;
  if (titleLen > 0) {
    title = titleResult.title;
    pos += titleLen;
  } else {
    pos = beforeTitle;
    title = '';
  }
  
  // Parse final spaces and newline
  pos = _skipSpaces(input, pos);
  if (!_skipLineEnd(input, pos)) {
    if (titleLen > 0) {
      // Try rewinding before title
      pos = beforeTitle;
      pos = _skipSpaces(input, pos);
      if (!_skipLineEnd(input, pos)) {
        return 0;
      }
    } else {
      return 0;
    }
  }
  
  // Skip the line ending (include it in consumed bytes)
  if (pos < input.length && input[pos] == 0x0D) {
    pos++;
  }
  if (pos < input.length && input[pos] == 0x0A) {
    pos++;
  }
  
  // Insert reference into map
  refmap.addStrings(labelResult.label, urlResult.url, title);
  
  return pos;
}

/// Skip spaces and optional newline (spnl from inlines.c)
int _spnl(Uint8List input, int pos) {
  pos = _skipSpaces(input, pos);
  if (_skipLineEnd(input, pos)) {
    // Skip past the line ending
    if (pos < input.length && input[pos] == 0x0D) {
      pos++;
    }
    if (pos < input.length && input[pos] == 0x0A) {
      pos++;
    }
    pos = _skipSpaces(input, pos);
  }
  return pos;
}

int _skipSpaces(Uint8List input, int pos) {
  while (pos < input.length && (input[pos] == 0x20 || input[pos] == 0x09)) {
    pos++;
  }
  return pos;
}

bool _skipLineEnd(Uint8List input, int pos) {
  if (pos >= input.length) {
    return true; // EOF
  }
  final c = input[pos];
  return c == 0x0A || c == 0x0D;
}
