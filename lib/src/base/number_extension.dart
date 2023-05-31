// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

extension FicNumberExtension<T extends num> on T {
  bool isInRange(num ini, num fim) => this >= ini && this <= fim;

  bool isNotInRange(num ini, num fim) => this < ini || this > fim;

  /// Returns the number inRange between min and max.
  /// If the number is `null`, return [orElse].
  ///
  /// Example:
  ///
  /// ```dart
  /// 2.inRange(0, 10) = 2;
  /// 2.inRange(5, 10) = 5;
  /// 12.inRange(5, 10) = 10;
  /// null.inRange(5, 10) = null;
  /// null.inRange(5, 10, orElse: 7) = 7;
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

extension FicNumberExtensionNullable<T extends num> on T? {
  //

  /// Returns the number inRange between min and max.
  /// If the number is `null`, return [orElse].
  ///
  /// Example:
  ///
  /// ```dart
  /// 2.inRange(0, 10) = 2;
  /// 2.inRange(5, 10) = 5;
  /// 12.inRange(5, 10) = 10;
  /// null.inRange(5, 10) = null;
  /// null.inRange(5, 10, orElse: 7) = 7;
  /// ```
  ///
  T inRange(T min, T max, {required T orElse}) {
    if (this == null) return orElse;
    if (this! <= min) return min;
    if (this! >= max) return max;
    return this!;
  }
}
