import '../node.dart';

/// Delimiter in the delimiter stack (for emphasis/strong/strikethrough matching).
/// From inlines.c delimiter struct.
class Delimiter {
  Delimiter({
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
  final CmarkNode inlText;
  final int position;
  int length;
  Delimiter? previous;
  Delimiter? next;
  bool active = true;
}

/// Bracket in the bracket stack (for link/image matching).
/// From inlines.c bracket struct.
class Bracket {
  Bracket({
    required this.image,
    required this.inlText,
    required this.position,
    this.previous,
  });

  final bool image;
  final CmarkNode inlText;
  final int position;
  bool active = true;
  bool bracketAfter = false;
  bool inBracketImage0 = false;
  bool inBracketImage1 = false;
  Bracket? previous;
}
