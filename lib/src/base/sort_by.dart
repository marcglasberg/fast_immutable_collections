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
///      int Function(int, int) compareTo = compare((x) => x == 14,
///         then: compare((x) => x == 15,
///             then: compare((x) => x % 2 == 1,
///                 then: compare((x) => x % 3 == 0,
///                     then: compare((x) => x % 5 == 0,
///                         then: (int a, int b) => a.compareTo(b),
///                     )))));
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
