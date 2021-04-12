// /////////////////////////////////////////////////////////////////////////////

extension FicNumberExtension<T extends num> on T {
  bool isInRange(num ini, num fim) => this >= ini && this <= fim;

  bool isNotInRange(num ini, num fim) => this < ini || this > fim;

  /// Returns the number constrainedTo between min and max.
  /// If the number is `null`, return [orElse].
  ///
  /// Example:
  ///
  /// ```dart
  /// 2.constrainedTo(0, 10) = 2;
  /// 2.constrainedTo(5, 10) = 5;
  /// 12.constrainedTo(5, 10) = 10;
  /// null.constrainedTo(5, 10) = null;
  /// null.constrainedTo(5, 10, orElse: 7) = 7;
  /// ```
  ///
  /// Beware: `-10.inRange(5, 8)` is the same as `-(10.inRange(5, 10)`.
  /// To enforce the negative input value you must write:
  /// `(-10).inRange(5, 10)` or use a variable to hold the `-10`.
  ///
  T inRange(T min, T max) {
    if (this <= min) return min;
    if (this >= max) return max;
    return this;
  }
}

// /////////////////////////////////////////////////////////////////////////////

extension FicNumberExtensionNullable<T extends num> on T? {
  bool get isNullOrZero => this == null || this == 0;

  // TODO: Marcelo, uma sugestão seria não utilizar *not* à frente de `or` ou `and`.
  // Fica difícil de saber se o *not* se refere ao primeiro termo ou ao resto do texto totalmente.
  // Além disso, o nome menciona `or`, mas a implementação é com `and`, o que me deixa ainda mais confuso.
  bool get isNotNullOrZero => this != null && this != 0;

  /// Returns the number constrainedTo between min and max.
  /// If the number is `null`, return [orElse].
  ///
  /// Example:
  ///
  /// ```dart
  /// 2.constrainedTo(0, 10) = 2;
  /// 2.constrainedTo(5, 10) = 5;
  /// 12.constrainedTo(5, 10) = 10;
  /// null.constrainedTo(5, 10) = null;
  /// null.constrainedTo(5, 10, orElse: 7) = 7;
  /// ```
  ///
  T? inRange(T min, T max, {T? orElse}) {
    if (this == null) return orElse;
    if (this! <= min) return min;
    if (this! >= max) return max;
    return this;
  }
}

// /////////////////////////////////////////////////////////////////////////////
