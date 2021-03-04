import "package:fast_immutable_collections/fast_immutable_collections.dart";

// /////////////////////////////////////////////////////////////////////////////

extension IMapExtension on IMap? {
  /// Checks if `this` is `null` or empty.
  bool get isNullOrEmpty => (this == null) || this!.isEmpty;

  /// Checks if `this` is **not** `null` and **not** empty.
  bool get isNotNullNotEmpty => (this != null) && this!.isNotEmpty;

  /// Checks if `this` is empty but **not** `null`.
  bool get isEmptyNotNull => (this != null) && this!.isEmpty;
}

extension IMapOfSetsExtension on IMapOfSets? {
  /// Checks if `this` is `null` or empty.
  bool get isNullOrEmpty => (this == null) || this!.isEmpty;

  /// Checks if `this` is **not** `null` and **not** empty.
  bool get isNotNullNotEmpty => (this != null) && this!.isNotEmpty;

  /// Checks if `this` is empty but **not** `null`.
  bool get isEmptyNotNull => (this != null) && this!.isEmpty;
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
