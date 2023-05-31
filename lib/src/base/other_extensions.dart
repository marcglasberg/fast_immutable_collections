// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:fast_immutable_collections/fast_immutable_collections.dart";

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
