import "package:fast_immutable_collections/fast_immutable_collections.dart";

// /////////////////////////////////////////////////////////////////////////////

/// See also: [CanBeEmpty]
extension CanBeEmptyExtension on CanBeEmpty {
  /// Checks if `this` is `null` or `[isEmpty].
  bool get isNullOrEmpty => (this == null) || isEmpty;

  /// Checks if `this` is **not** `null` and **not** `[isEmpty].
  bool get isNotNullOrEmpty => (this != null) && isNotEmpty;

  /// Checks if `this` is [isEmpty] but **not** `null`.
  bool get isEmptyButNotNull => (this != null) && isEmpty;
}

// /////////////////////////////////////////////////////////////////////////////

/// See also: [FicIterableExtension]
extension FicIteratorExtension<T> on Iterator<T> {
  //
  Iterable<T> toIterable() sync* {
    while (moveNext()) yield current;
  }

  List<T> toList({bool growable = true}) => List.of(toIterable(), growable: growable);

  Set<T> toSet() => Set.of(toIterable());
}

// /////////////////////////////////////////////////////////////////////////////

/// See also: [compareObject], [FicComparableExtension], [FicComparatorExtension], [sortBy], [sortLike]
extension FicBooleanExtension on bool {
  /// true > false
  /// Zero: This instance and value are equal (both true or both false).
  /// Greater than zero: This instance is true and value is false.
  /// Less than zero: This instance is false and value is true.
  int compareTo(bool other) => (this == other)
      ? 0
      : this
          ? 1
          : -1;
}

// /////////////////////////////////////////////////////////////////////////////
