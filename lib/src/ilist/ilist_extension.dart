import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:collection/collection.dart";

extension IListExtension<T> on List<T> {
  //
  /// Locks the list, returning an *immutable* list ([IList]).
  IList<T> get lock => IList<T>(this);

  /// Locks the list, returning an *immutable* list ([IList]).
  ///
  /// This is **unsafe**: Use it at your own peril.
  ///
  /// This constructor is fast, since it makes no defensive copies of the list.
  /// However, you should only use this with a new list you've created yourself,
  /// when you are sure no external copies exist. If the original list is modified,
  /// it will break the [IList] and any other derived lists in unpredictable ways.
  ///
  /// Note you can optionally disallow unsafe constructors in the global configuration
  /// by doing: `ImmutableCollection.disallowUnsafeConstructors = true` (and then optionally
  /// preventing further configuration changes by calling `ImmutableCollection.lockConfig()`).
  ///
  /// See also: [ImmutableCollection]
  IList<T> get lockUnsafe => IList<T>.unsafe(this, config: IList.defaultConfig);

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// This is similar to [sort], but uses a [merge sort algorithm](https://en.wikipedia.org/wiki/Merge_sort).
  ///
  /// Contrary to [sort], [orderedSort] is stable, meaning distinct objects
  /// that compare as equal end up in the same order as they started in.
  ///
  void sortOrdered([int Function(T a, T b) compare]) {
    mergeSort(this, compare: compare);
  }

  /// Sorts this list according to the order specified by the [ordering] iterable.
  /// Elements which don't appear in [ordering] will be included in the end, in no particular order.
  /// Note: This is not very efficient. Only use for a small number of elements.
  void sortLike(Iterable<T> ordering) {
    assert(ordering != null);
    Set<T> orderingSet = Set.of(ordering);
    Set<T> newSet = Set.of(this);
    Set<T> intersection = orderingSet.intersection(newSet);
    Set<T> difference = newSet.difference(orderingSet);
    clear();
    addAll(ordering.where((element) => intersection.contains(element)).followedBy(difference));
  }

  /// Moves all items that satisfy the provided [test] to the end of the list.
  /// Keeps the relative order of the moved items.
  void whereMoveToTheEnd(bool Function(T item) test) {
    var compare = (T f1, T f2) {
      bool test1 = test(f1);
      return (test1 == test(f2))
          ? 0
          : test1
              ? 1
              : -1;
    };
    sortOrdered(compare);
  }

  /// Moves all items that satisfy the provided [test] to the start of the list.
  /// Keeps the relative order of the moved items.
  void whereMoveToTheFront(bool Function(T item) test) {
    var compare = (T f1, T f2) {
      bool test1 = test(f1);
      return (test1 == test(f2))
          ? 0
          : test1
              ? -1
              : 1;
    };
    sortOrdered(compare);
  }
}
