import 'node.dart';

/// Placeholder document API. The full parser implementation is forthcoming.
///
/// Currently this exposes minimal helpers to satisfy package exports and
/// allow tests that exercise the node tree to compile.
class CmarkDocument {
  CmarkDocument();

  final CmarkNode root = CmarkNode(CmarkNodeType.document);
}
