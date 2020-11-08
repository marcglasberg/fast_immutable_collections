import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// The [if0] extension lets you nest comparators. For example:
///
///     // 1) Strings are ordered according to their length.
///     // 2) Otherwise, they come in their natural order.
///     compareTo = (String a, String b) =>
///                    a.length.compareTo(b.length)
///                      .if0(a.compareTo(b));
///
extension ComparatorExtension on int {
  int if0(int then) => this == 0 ? then : this;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension ComparableExtension<T extends Comparable<T>> on Comparable<T> {
  /// If your collection can have nulls, you can use [nullableCompareTo]
  /// instead of [compareTo]. For example:
  ///
  ///      // Results in: [1, 2, null]
  ///      [2, null, 1].sort((int a, int b) => a.nullableCompareTo(b));
  ///
  ///      // Results in: [null, 1, 2]
  ///      [2, null, 1].sort((int a, int b) => a.nullableCompareTo(b, nullsBefore: true));
  ///
  int nullableCompareTo(T other, {bool nullsBefore = false}) {
    if (this == null && other == null) return 0;
    if (this == null) return nullsBefore ? -1 : 1;
    if (other == null) return nullsBefore ? 1 : -1;
    return compareTo(other);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// The [sortBy] function can be used to create a comparator to sort
/// collections, comparing [a] and [b] such that:
///
/// - If both [a] and [b] satisfy the [test], and [then] is not provided,
///   the order between [a] and [b] undefined.
///
/// - If both [a] and [b] don't satisfy the [test], and [then] is not provided,
///   the order between [a] and [b] undefined.
///
/// - Otherwise, if only [a] or only [b] satisfies the [test],
///   then the one which satisfies the [test] comes before.
///
/// - Otherwise, if both [a] and [b] satisfy the [test], and [then] is provided,
///   the order between [a] and [b] with be given by [then].
///
/// This comparator makes it easy to create complex comparators,
/// using the language described below. For example, suppose you
/// have a list of numbers which you want to sort according to
/// the following rules:
///
///      1) If present, number 14 is always the first, followed by number 15.
///      2) Otherwise, odd numbers come before even ones.
///      3) Otherwise, come numbers which are multiples of 3,
///      4) Otherwise, come numbers which are multiples of 5,
///      5) Otherwise, numbers come in their natural order.
///      int Function(int, int) compareTo = sortBy((x) => x == 14,
///         then: sortBy((x) => x == 15,
///             then: sortBy((x) => x % 2 == 1,
///                 then: sortBy((x) => x % 3 == 0,
///                     then: sortBy((x) => x % 5 == 0,
///                         then: (int a, int b) => a.compareTo(b),
///                     )))));
///
/// Important: When a cascade of [sortBy] is used, make sure you don't create
/// inconsistencies. For example, this is inconsistent: `a<b` and `a>c` and `b<c`.
/// Sorts with inconsistent rules may result in different orders for the same
/// items depending on their initial position, and the rules may not be followed
/// precisely.
///
/// Note [sortBy] can be combined with [sortLike].
///
int Function(T, T) sortBy<T>(
  bool Function(T) test, {
  int Function(T, T) then,
}) =>
    (T a, T b) {
      var ta = test(a);
      var tb = test(b);
      if (ta == tb) return (then == null) ? 0 : then(a, b);
      return ta ? -1 : 1;
    };

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// The [sortLike] function can be used to create a comparator to sort
/// collections, comparing [a] and [b] such that:
///
/// - If [a] and [b] are equal, the order between [a] and [b] is undefined.
///
/// - Otherwise, If [a] and [b] are not equal and both are present in [order],
///   then the order between them will be the same as in [order].
///
/// - Otherwise, If both [a] and [b] are not present in [order], or
///   only one of them is present and the other is not, and [then]
///   is not provided, then the order between [a] and [b] undefined.
///
/// - Otherwise, If both [a] and [b] are not present in [order], or
///   only one of them is present and the other is not, and [then]
///   is provided, then the order between [a] and [b] with be given by [then].
///
/// Optionally, you can provide a [mapper] function, to convert [a] and [b]
/// into the type of values in [order].
///
/// Notes:
///
/// - [order] should be [List] or [IList], otherwise it will be converted
/// to a list in every use, which will hurt performance.
///
/// - If a value appears twice in [order], only the first time counts.
///
/// This comparator makes it easy to create complex comparators,
/// using the language described below. For example, suppose you
/// have a list of numbers which you want to sort according to
/// a certain order:
///
///      1) Order should be [7, 3, 4, 21, 2] when these values appear.
///      2) Otherwise, odd numbers come before even ones.
///      3) Otherwise, numbers come in their natural order.
///      int Function(int, int) compareTo = sortLike([7, 3, 4, 21, 2],
///         then: sortBy((x) => x % 2 == 1,
///             then: (int a, int b) => a.compareTo(b),
///                 ));
///
/// Important: When a cascade of [sortLike] is used, make sure you don't create
/// inconsistencies. For example, this is inconsistent: `a<b` and `a>c` and `b<c`.
/// Sorts with inconsistent rules may result in different orders for the same
/// items depending on their initial position, and the rules may not be followed
/// precisely.
///
/// Note [sortLike] can be combined with [sortBy].
///
int Function(T, T) sortLike<T, E>(
  Iterable<E> order, {
  E Function(T) mapper,
  int Function(T, T) then,
}) =>
    (T a, T b) {
      if (a == b) return 0;
      int posA, posB;

      E ma, mb;
      if (mapper != null) {
        ma = mapper(a);
        mb = mapper(b);
      } else {
        ma = a as E;
        mb = b as E;
      }
      if (order is List<E>) {
        posA = order.indexOf(ma);
        posB = order.indexOf(mb);
      } else if (order is IList<E>) {
        posA = order.indexOf(ma);
        posB = order.indexOf(mb);
      } else {
        posA = order.toList().indexOf(ma);
        posB = order.toList().indexOf(mb);
      }

      return (posA != -1 && posB != -1)
          ? posA.compareTo(posB)
          : (then == null)
              ? 0
              : then(a, b);
    };

/// 1) If [a] and [b] are both of type [Comparable], compare them with their
/// natural comparator.
///
/// 2) If [a] and [b] are map-entries, compare their keys (if they are
/// [Comparable]). If the keys don't have order (are the same or not
/// [Comparable]), compare their values (if they are [Comparable]).
///
/// 3) If [a] and [b] are booleans, compare them such as true > false.
///
/// Otherwise, return 0 (which means unordered).
///
int compareObject(Object a, Object b) {
  if (a == null) {
    return b == null ? 0 : 1;
  } else if (b == null) return -1;
  if (a is Comparable && b is Comparable) return a.compareTo(b);
  if (a is MapEntry && b is MapEntry) {
    int result = compareObject(a.key, b.key);
    if (result == 0) result = compareObject(a.value, b.value);
    return result;
  }
  if (a is bool && b is bool) return a.compareTo(b);
  return 0;
}

