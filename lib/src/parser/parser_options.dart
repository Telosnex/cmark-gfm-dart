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
  });

  final bool enableMath;
  final CmarkMathOptions mathOptions;
  final int? maxReferenceSize;
  final bool enableAutolinkExtension;
}
