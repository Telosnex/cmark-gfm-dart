/// Options controlling math parsing behaviour.
class CmarkMathOptions {
  const CmarkMathOptions({
    this.allowBlockDoubleDollar = true,
    this.allowBracketDelimiters = true,
    this.allowSingleDollar = true,
  });

  final bool allowBlockDoubleDollar;
  final bool allowBracketDelimiters;
  final bool allowSingleDollar;
}

/// Options controlling parser behaviour.
class CmarkParserOptions {
  const CmarkParserOptions({
    this.enableMath = true,
    this.mathOptions = const CmarkMathOptions(),
    this.maxReferenceSize,
    this.enableAutolinkExtension = false,
    this.singleTildeStrikethrough = true,
  });

  final bool enableMath;
  final CmarkMathOptions mathOptions;
  final int? maxReferenceSize;
  final bool enableAutolinkExtension;
  
  /// Whether single tilde `~like this~` creates strikethrough.
  /// 
  /// When true (default), both `~single~` and `~~double~~` work.
  /// When false, only `~~double~~` creates strikethrough, and single
  /// tilde is treated as literal text (useful when `~` means "approximately").
  final bool singleTildeStrikethrough;
}
