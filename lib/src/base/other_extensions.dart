import "package:fast_immutable_collections/fast_immutable_collections.dart";

// /////////////////////////////////////////////////////////////////////////////

extension IMapExtension on IMap {
  /// Checks if `this` is `null` or `[isEmpty].
  bool get isNullOrEmpty => (this == null) || isEmpty;

  /// Checks if `this` is **not** `null` and **not** `[isEmpty].
  bool get isNotNullOrEmpty => (this != null) && isNotEmpty;

  /// Checks if `this` is [isEmpty] but **not** `null`.
  bool get isEmptyButNotNull => (this != null) && isEmpty;
}

extension IMapOfSetsExtension on IMapOfSets {
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
  /// Convert this iterator into an [Iterable].
  Iterable<T> toIterable() sync* {
    while (moveNext()) yield current;
  }

  /// Convert this iterator into a [List].
  List<T> toList({bool growable = true}) => List.of(toIterable(), growable: growable);

  /// Convert this iterator into a [Set].
  Set<T> toSet() => Set.of(toIterable());

  /// Convert this iterator into an [IList].
  IList<T> toIList() => IList(toIterable());

  /// Convert this iterator into an [ISet].
  ISet<T> toISet() => ISet(toIterable());
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
