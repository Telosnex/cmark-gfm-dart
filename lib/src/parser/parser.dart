import '../node.dart';
import '../reference/reference_map.dart';
import 'block_parser.dart';
import 'parser_options.dart';

export 'parser_options.dart';

/// High-level convenience wrapper that feeds text into the block parser.
class CmarkParser {
  CmarkParser({
    CmarkParserOptions options = const CmarkParserOptions(),
    int? maxReferenceSize,
  }) : this._(
          maxReferenceSize != null
              ? CmarkParserOptions(
                  enableMath: options.enableMath,
                  mathOptions: options.mathOptions,
                  maxReferenceSize: maxReferenceSize,
                )
              : options,
        );

  CmarkParser._(CmarkParserOptions options)
      : _options = options,
        _blockParser = BlockParser(parserOptions: options);

  final BlockParser _blockParser;
  final CmarkParserOptions _options;

  CmarkParserOptions get options => _options;

  CmarkReferenceMap get referenceMap => _blockParser.referenceMap;

  void feed(String text) => _blockParser.feed(text);

  CmarkNode finish() => _blockParser.finish();

  /// Create a finalized clone of the current tree for rendering,
  /// but keep the parser alive to accept more feed() calls.
  /// Use this for streaming/incremental rendering of AI responses.
  CmarkNode finishClone() => _blockParser.finishClone();
}
