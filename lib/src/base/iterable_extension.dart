import "dart:collection";
import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

// ////////////////////////////////////////////////////////////////////////////

/// Combines iterables [a] and [b] into one, by applying the [combine] function.
/// If [allowDifferentSizes] is true, it will stop as soon as one of the
/// iterables has no more values. If [allowDifferentSizes] is false, it will
/// throw an error if the iterables have different length.
///
/// See also: [IterableZip]
///
Iterable<R> combineIterables<A, B, R>(
  Iterable<A> a,
  Iterable<B> b,
  R Function(A, B) combine, {
  bool allowDifferentSizes = false,
}) sync* {
  Iterator<A> iterA = a.iterator;
  Iterator<B> iterB = b.iterator;

  while (iterA.moveNext()) {
    if (!iterB.moveNext()) {
      if (allowDifferentSizes)
        return;
      else
        throw StateError("Can't combine iterables of different sizes (a > b).");
    }
    yield combine(iterA.current, iterB.current);
  }

  if (iterB.moveNext() && !allowDifferentSizes)
    throw StateError("Can't combine iterables of different sizes (a < b).");
}

// ////////////////////////////////////////////////////////////////////////////

/// See also: [FicListExtension], [FicSetExtension]
extension FicIterableExtensionNullable<T> on Iterable<T>? {
  //
  /// Creates an *immutable* set ([ISet]) from the iterable.
  ISet<T>? toISet([ConfigSet? config]) => (this == null) ? null : ISet<T>.withConfig(this, config);

  bool get isNullOrEmpty => (this == null) || this!.isEmpty;

  bool get isNotNullOrEmpty => (this != null) && this!.isNotEmpty;

  bool get isEmptyButNotNull => (this != null) && this!.isEmpty;

  /// Compare all items, in order or not, according to [ignoreOrder],
  /// using [operator ==]. Return true if they are all the same,
  /// in the same order.
  ///
  /// Note: Since this is an extension, it works with nulls:
  /// ```dart
  /// Iterable iterable1 = null;
  /// Iterable iterable2 = null;
  /// iterable1.deepEquals(iterable2) == true;
  /// ```
  ///
  bool deepEquals(Iterable? other, {bool ignoreOrder = false}) {
    if (identical(this, other)) return true;
    if (this == null || other == null) return false;

    /// Assumes EfficientLengthIterable for these:
    if ((this is List) ||
        (this is Set) ||
        (this is Map) ||
        (this is ImmutableCollection)) if (this!.length != other.length) return false;

    return ignoreOrder
        ? const UnorderedIterableEquality<dynamic>(IdentityEquality<dynamic>()).equals(this, other)
        : const IterableEquality<dynamic>(IdentityEquality<dynamic>()).equals(this, other);
  }

  /// Return true if they are all the same, in the same order.
  /// Compare all items, in order or not, according to [ignoreOrder],
  /// using [identical]. Return true if they are all the same,
  /// in the same order.
  ///
  /// Note: Since this is an extension, it works with nulls:
  /// ```dart
  /// Iterable iterable1 = null;
  /// Iterable iterable2 = null;
  /// iterable1.deepEqualsByIdentity(iterable2) == true;
  /// ```
  ///
  bool deepEqualsByIdentity(Iterable? other, {bool ignoreOrder = false}) {
    if (identical(this, other)) return true;
    if (this == null || other == null) return false;

    /// Assumes EfficientLengthIterable for these:
    if ((this is List) ||
        (this is Set) ||
        (this is Map) ||
        (this is ImmutableCollection)) if (this!.length != other.length) return false;

    return ignoreOrder
        ? const UnorderedIterableEquality<dynamic>(IdentityEquality<dynamic>()).equals(this, other)
        : const IterableEquality<dynamic>(IdentityEquality<dynamic>()).equals(this, other);
  }
}

// ////////////////////////////////////////////////////////////////////////////

/// See also: [FicListExtension], [FicSetExtension]
extension FicIterableExtension<T> on Iterable<T> {
  //
  /// Creates an *immutable* list ([IList]) from the iterable.
  IList<T> toIList([ConfigList? config]) => IList<T>.withConfig(this, config);

  /// Creates an *immutable* set ([ISet]) from the iterable.
  ISet<T>? toISet([ConfigSet? config]) => ISet<T>.withConfig(this, config);

  /// Finds duplicates and then returns a [Set] with the duplicated elements.
  /// If there are no duplicates, an empty [Set] is returned.
  Set<T> findDuplicates() {
    final Set<T> duplicates = <T>{};
    final Set<T> auxSet = HashSet<T>();
    for (final T element in this) {
      if (!auxSet.add(element)) duplicates.add(element);
    }
    return duplicates;
  }

  /// Returns true if all items are equal to [value].
  bool everyIs(T value) => every((item) => item == value);

  /// Returns true if any item is equal to [value].
  bool anyIs(T value) => any((item) => item == value);

  /// Removes `null`s from the [Iterable].
  Iterable<T> removeNulls() sync* {
    for (T item in this) {
      if (item != null) yield item;
    }
  }

  /// Removes all duplicates, leaving only the distinct items.
  /// Optionally, you can provide an [by] function to compare the items.
  ///
  /// If you pass [removeNulls] as true, it will also remove the nulls
  /// (it will check the item is null, before applying the [by] function).
  ///
  /// Note: This is different from `List.distinct()` because `removeDuplicates`
  /// is lazy (and you can use it with any Iterable, not just a List).
  /// For example, it can be much more efficient when you are doing some extra
  /// processing. Suppose you have a list with a million items, and you want
  /// to remove duplicates and get the first 5:
  ///
  /// // This will process 5 items:
  /// var newList = list.removeDuplicates().take(5).toList();
  ///
  /// // This will process a million items:
  /// var newList = list.distinct().sublist(0, 5);
  ///
  Iterable<T> removeDuplicates({
    dynamic Function(T item)? by,
    bool removeNulls = false,
  }) sync* {
    if (by != null) {
      Set<dynamic> ids = <dynamic>{};
      for (T item in this) {
        if (removeNulls && item == null) continue;
        dynamic id = by(item);
        if (!ids.contains(id)) yield item;
        ids.add(id);
      }
    } else {
      Set<T> items = {};
      for (T item in this) {
        if (removeNulls && item == null) continue;
        if (!items.contains(item)) yield item;
        items.add(item);
      }
    }
  }

  /// Returns a list, sorted according to the order specified by the [ordering] iterable.
  /// Items which don't appear in [ordering] will be included in the end, in their original order.
  /// Items of [ordering] which are not found in the original list are ignored.
  ///
  List<T?> sortedLike(Iterable ordering) {
    Set<T> thisSet = Set.of(this);
    Set<dynamic> otherSet = Set<dynamic>.of(ordering);

    IListOf4<List?> result = thisSet.diffAndIntersect<dynamic>(
      otherSet,
      diffThisMinusOther: true,
      diffOtherMinusThis: false,
      intersectThisWithOther: false,
      intersectOtherWithThis: true,
    );

    List<T?> intersectOtherWithThis = result.fourth as List<T?>;
    List<T?> diffThisMinusOther = result.first as List<T?>;
    return intersectOtherWithThis.followedBy(diffThisMinusOther).toList();
  }
}
