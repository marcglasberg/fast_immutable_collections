import "dart:collection";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// See also: [ListExtension], [SetExtension]
extension IterableExtension<T> on Iterable<T> {
  //
  /// Creates an *immutable* list ([IList]) from the iterable.
  IList<T> toIList() => (this == null) ? null : IList<T>(this);

  /// Creates an *immutable* set ([ISet]) from the iterable.
  ISet<T> toISet() => (this == null) ? null : ISet<T>(this);

  bool get isNullOrEmpty => this == null || isEmpty;

  bool get isNotNullOrEmpty => this != null && isNotEmpty;

  /// Compare all items, in order, using [identical].
  /// Return true if they are all the same, in the same order.
  ///
  /// Note: Since this is an extension, it works with nulls:
  /// ```dart
  /// Iterable iterable1 = null;
  /// Iterable iterable2 = null;
  /// iterable1.deepEqualsByIdentity(iterable2) == true;
  /// ```
  ///
  bool deepEqualsByIdentity(Iterable other) {
    if (identical(this, other)) return true;
    if (this == null || other == null) return false;

    if ((this is List) && (other is List)) {
      List list = this as List;
      if (length != other.length) return false;
      for (int i = 0; i < length; i++) {
        if (!identical(list[i], other[i])) return false;
      }
      return true;
    } else {
      var iterator1 = iterator;
      var iterator2 = other.iterator;
      while (iterator1.moveNext() && iterator2.moveNext()) {
        if (!identical(iterator1.current, iterator2.current)) return false;
      }
      return (iterator1.moveNext() || iterator2.moveNext()) ? false : true;
    }
  }

  /// Finds duplicates and then returns a [Set] with the elements which were duplicated.
  /// If there are no duplicates, an empty [Set] is returned.
  Set<T> findDuplicates() {
    final Set<T> duplicates = HashSet<T>();
    final Set<T> auxSet = HashSet<T>();
    for (T elements in this) {
      if (!auxSet.add(elements)) duplicates.add(elements);
    }
    return duplicates;
  }

  /// Removes `null`s from the [Iterable].
  ///
  /// Note: This is done through a [*synchronous generator*](https://dart.dev/guides/language/language-tour#generators).
  Iterable<T> removeNulls() sync* {
    for (T item in this) {
      if (item != null) yield item;
    }
  }

  /// Removes all duplicates, leaving only the distinct items.
  /// Optionally, you can provide an [id] function to compare the items.
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
  Iterable<T> removeDuplicates([dynamic Function(T item) id]) sync* {
    if (id != null) {
      Set<dynamic> ids = {};
      for (T item in this) {
        var _id = id(item);
        if (!ids.contains(_id)) yield item;
        ids.add(_id);
      }
    } else {
      Set<T> items = {};
      for (T item in this) {
        if (!items.contains(item)) yield item;
        items.add(item);
      }
    }
  }

  /// Removes `null`s and duplicates.
  ///
  /// Note: This is done through a [*synchronous generator*](https://dart.dev/guides/language/language-tour#generators).
  Iterable<T> removeNullAndDuplicates() sync* {
    Set<T> items = {};
    for (T item in this) {
      if (item != null && !items.contains(item)) yield item;
      items.add(item);
    }
  }

  /// Returns a list, sorted according to the order specified by the [ordering] iterable.
  /// Items which don't appear in [ordering] will be included in the end, in no particular order.
  ///
  /// Note: Not very efficient at the moment (will be improved in the future).
  /// Please use for a small number of items.
  ///
  List<T> toListSortedLike(Iterable<T> ordering) {
    assert(ordering != null);
    Set<T> originalSet = Set.of(ordering);
    Set<T> newSet = (this is Set<T>) ? (this as Set<T>) : Set.of(this);
    Set<T> intersection = originalSet.intersection(newSet);
    Set<T> difference = newSet.difference(originalSet);
    List<T> result = ordering.where((element) => intersection.contains(element)).toList();
    result.addAll(difference);
    return result;
  }
}
