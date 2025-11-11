import 'package:cmark_gfm/cmark_gfm.dart';

String getStringForTree(CmarkNode root) {
  final buffer = StringBuffer();
  void walk(CmarkNode node, [int depth = 0]) {
    final indent = '  ' * depth;
    final content = node.content.toString().replaceAll('\n', '\\n');
    
    if (node.type == CmarkNodeType.codeBlock) {
      final info = node.codeData.info.replaceAll('\n', '\\n');
      final literal = node.codeData.literal.replaceAll('\n', '\\n');
      buffer.writeln('$indent${node.type.name}: "$content" info="$info" literal="$literal"');
    } else if (node.type == CmarkNodeType.mathBlock) {
      final literal = node.mathData.literal.replaceAll('\n', '\\n');
      buffer.writeln('$indent${node.type.name}: "$content" literal="$literal"');
    } else if (node.type == CmarkNodeType.math) {
      final literal = node.mathData.literal.replaceAll('\n', '\\n');
      buffer.writeln('$indent${node.type.name}: "$content" literal="$literal"');
    } else {
      buffer.writeln('$indent${node.type.name}: "$content"');
    }
    
    var child = node.firstChild;
    while (child != null) {
      walk(child, depth + 1);
      child = child.next;
    }
  }

  walk(root);
  return buffer.toString();
}

List<String> splitIntoChunks(String text, {int chunkSize = 5}) {
  final chunks = <String>[];
  for (var i = 0; i < text.length; i += chunkSize) {
    final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
    chunks.add(text.substring(i, end));
  }
  return chunks;
}
