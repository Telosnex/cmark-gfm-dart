import 'node2.dart';

/// Delimiter in the delimiter stack (for emphasis/strong/strikethrough matching).
/// Forked from package delimiter.dart for CmarkNode2.
class Delimiter2 {
  Delimiter2({
    required this.delimChar,
    required this.canOpen,
    required this.canClose,
    required this.inlText,
    required this.position,
    required this.length,
    this.previous,
    this.next,
  });

  final int delimChar;
  bool canOpen;
  bool canClose;
  final CmarkNode2 inlText;
  final int position;
  int length;
  Delimiter2? previous;
  Delimiter2? next;
  bool active = true;
}

/// Bracket in the bracket stack (for link/image matching).
/// Forked from package delimiter.dart for CmarkNode2.
class Bracket2 {
  Bracket2({
    required this.image,
    required this.inlText,
    required this.position,
    this.previous,
  });

  final bool image;
  final CmarkNode2 inlText;
  final int position;
  bool active = true;
  bool bracketAfter = false;
  bool inBracketImage0 = false;
  bool inBracketImage1 = false;
  Bracket2? previous;
}
