import 'forked/block_parser_v2.dart';
import 'forked/node2.dart';
import 'package:cmark_gfm/cmark_gfm.dart';

void main() {
  final p = BlockParserV2(parserOptions: const CmarkParserOptions());
  p.feed('hello\n\n```dart\ncode here\n```\n\nworld');
  final root = p.finish();
  void walk(CmarkNode2 node, [int depth = 0]) {
    final content = node.content.toString().replaceAll('\n', '\\n');
    final extra = node.type == CmarkNodeType.codeBlock 
        ? ' [info="${node.codeData.info}" literal="${node.codeData.literal}"]' 
        : '';
    print('${"  " * depth}${node.type}: "$content"$extra');
    var c = node.firstChild;
    while (c != null) { walk(c, depth + 1); c = c.next; }
  }
  walk(root);
}
