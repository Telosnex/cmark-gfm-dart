import '../node.dart';
import '../reference/reference_map.dart';
import 'block_parser.dart';

/// High-level convenience wrapper that feeds text into the block parser.
class CmarkParser {
  CmarkParser({int? maxReferenceSize})
      : _blockParser = BlockParser(maxReferenceSize: maxReferenceSize);

  final BlockParser _blockParser;

  CmarkReferenceMap get referenceMap => _blockParser.referenceMap;

  void feed(String text) => _blockParser.feed(text);

  CmarkNode finish() => _blockParser.finish();

  /// Create a finalized clone of the current tree for rendering,
  /// but keep the parser alive to accept more feed() calls.
  /// Use this for streaming/incremental rendering of AI responses.
  CmarkNode finishClone() => _blockParser.finishClone();
}
