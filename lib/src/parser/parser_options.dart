/// Options controlling math parsing behaviour.
class CmarkMathOptions {
  const CmarkMathOptions({
    this.allowBlockDoubleDollar = true,
    this.allowBracketDelimiters = false,
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
    this.allowExtraTableDelimiters = true,
  });

  final bool enableMath;
  final CmarkMathOptions mathOptions;
  final int? maxReferenceSize;
  final bool enableAutolinkExtension;

  /// Ignore surplus delimiter cells after the last header cell. Generated
  /// Markdown often has extra `---` cells; body rows already allow differing
  /// cell counts. Set false to require the equal counts mandated by GFM.
  final bool allowExtraTableDelimiters;

  /// Whether single tilde `~like this~` creates strikethrough.
  ///
  /// When true (default), both `~single~` and `~~double~~` work.
  /// When false, only `~~double~~` creates strikethrough, and single
  /// tilde is treated as literal text (useful when `~` means "approximately").
  final bool singleTildeStrikethrough;
}
