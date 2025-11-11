/// Options controlling math parsing behaviour.
class CmarkMathOptions {
  const CmarkMathOptions({
    this.allowInlineDollar = false,
    this.allowBlockDoubleDollar = true,
    this.allowBracketDelimiters = true,
  });

  final bool allowInlineDollar;
  final bool allowBlockDoubleDollar;
  final bool allowBracketDelimiters;
}

/// Options controlling parser behaviour.
class CmarkParserOptions {
  const CmarkParserOptions({
    this.enableMath = false,
    this.mathOptions = const CmarkMathOptions(),
    this.maxReferenceSize,
  });

  final bool enableMath;
  final CmarkMathOptions mathOptions;
  final int? maxReferenceSize;
}
