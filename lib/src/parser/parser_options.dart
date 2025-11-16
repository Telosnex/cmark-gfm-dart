/// Options controlling math parsing behaviour.
class CmarkMathOptions {
  const CmarkMathOptions({
    this.allowBlockDoubleDollar = true,
    this.allowBracketDelimiters = true,
  });

  final bool allowBlockDoubleDollar;
  final bool allowBracketDelimiters;
}

/// Options controlling parser behaviour.
class CmarkParserOptions {
  const CmarkParserOptions({
    this.enableMath = false,
    this.mathOptions = const CmarkMathOptions(),
    this.maxReferenceSize,
    this.enableAutolinkExtension = false,
  });

  final bool enableMath;
  final CmarkMathOptions mathOptions;
  final int? maxReferenceSize;
  final bool enableAutolinkExtension;
}
