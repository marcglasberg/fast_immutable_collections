// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

extension FicListExtension<T> on List<T> {
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

  /// Returns the [index]th element.
  /// If that index doesn't exist (negative, or out of range), will return
  /// the result of calling [orElse]. In this case, if [orElse] is not provided,
  /// will throw an error.
  T get(int index, {T Function(int index)? orElse}) {
    if (orElse == null) return this[index];
    return (index < 0 || index >= length) //
        ? orElse(index)
        : this[index];
  }

  /// Returns the [index]th element.
  /// If that index doesn't exist (negative or out of range), will return null.
  /// This method will never throw an error.
  T? getOrNull(int index) => (index < 0 || index >= length) //
      ? null
      : this[index];

  /// Gets the [index]th element, and then apply the [map] function to it, returning the result.
  /// If that index doesn't exist (negative, or out of range), will the [map] method
  /// will be called with `inRange` false and `value` null.
  T getAndMap(
    int index,
    T Function(int index, bool inRange, T? value) map,
  ) {
    final bool inRange = (index >= 0 && index < length);

    final T? value = inRange ? this[index] : null;
    return map(index, inRange, value);
  }

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// This is similar to [sort], but uses a [merge sort algorithm](https://en.wikipedia.org/wiki/Merge_sort).
  ///
  /// Contrary to [sort], [orderedSort] is stable, meaning distinct objects
  /// that compare as equal end up in the same order as they started in.
  ///
  void sortOrdered([int Function(T a, T b)? compare]) {
    mergeSort<T>(this, compare: compare);
  }

  /// Sorts this list according to the order specified by the [ordering] iterable.
  /// Items which don't appear in [ordering] will be included in the end, in their original order.
  /// Items of [ordering] which are not found in the original list are ignored.
  ///
  void sortLike(Iterable ordering) {
    final List<T> result = sortedLike(ordering);
    clear();
    addAll(result);
  }

  /// Sorts this list in reverse order in relation to the default [sort] method.
  ///
  void sortReversed([int Function(T a, T b)? compare]) {
    if (compare != null)
      sort((T a, T b) => compare(b, a));
    else
      sort((T a, T b) => compareObject(b, a));
  }

  /// Moves the first occurrence of the [item] to the start of the list.
  void moveToTheFront(T item) {
    final int pos = indexOf(item);
    if (pos != -1 && pos != 0) {
      removeAt(pos);
      insert(0, item);
    }
  }

  /// Moves the first occurrence of the [item] to the end of the list.
  void moveToTheEnd(T item) {
    final int pos = indexOf(item);
    if (pos != -1 && pos != length - 1) {
      removeAt(pos);
      add(item);
    }
  }

  /// Moves all items that satisfy the provided [test] to the start of the list.
  /// Keeps the relative order of the moved items.
  void whereMoveToTheFront(bool Function(T item) test) {
    int compare(T f1, T f2) {
      final bool test1 = test(f1);
      return (test1 == test(f2))
          ? 0
          : test1
              ? -1
              : 1;
    }

    sortOrdered(compare);
  }

  /// Moves all items that satisfy the provided [test] to the end of the list.
  /// Keeps the relative order of the moved items.
  void whereMoveToTheEnd(bool Function(T item) test) {
    int compare(T f1, T f2) {
      final bool test1 = test(f1);
      return (test1 == test(f2))
          ? 0
          : test1
              ? 1
              : -1;
    }

    sortOrdered(compare);
  }

  /// If the item does not exist in the list, add it and return `true`.
  /// If it already exists, remove the first instance of it and return `false`.
  bool toggle(T item) {
    final result = contains(item);
    if (result)
      remove(item);
    else
      add(item);
    return !result;
  }

  /// Return `true` if the lists contain the same items (in any order).
  /// Ignores repeated items.
  bool compareAsSets(List other) {
    if (identical(this, other)) return true;
    return const SetEquality<dynamic>(MapEntryEquality<dynamic>()).equals(
      Set<dynamic>.of(this),
      Set<dynamic>.of(other),
    );
  }

  /// Split a list, according to a predicate,
  /// removing the list item that satisfies the predicate.
  ///
  /// ```
  /// [1,2,3,4,5].splitList((v)=>v==2 || v==4) ➜ [[1], [3], [5]]
  /// ```
  ///
  Iterable<List<T>> splitList(
    bool Function(T item) test, {
    bool emptyParts = false,
  }) sync* {
    if (isEmpty) return;
    int start = 0;
    for (int i = 0; i < length; i++) {
      final T element = this[i];
      if (test(element)) {
        if (start < i || emptyParts) {
          yield sublist(start, i);
        }
        start = i + 1;
      }
    }
    if (start < length || emptyParts) {
      yield sublist(start);
    }
  }

  /// Search a list for items that satisfy a [test] predicate (matching items),
  /// and then divide that list into parts, such as each part contains one matching item.
  /// Except maybe for the first matching item, it will keep the matching items as
  /// the first item in each part.
  ///
  /// Example: Suppose you have a list with Chapters, Texts and Images.
  /// You can break it into separate chapters, like this:
  ///
  /// ```
  /// bookInfo.divideList((item) => item is Chapter);
  /// ```
  ///
  /// In the example below the matching items are `2` and `4`. This means we'll divide
  /// this list into 2 lists, one containing `2`, and another containing `4`.
  /// The `4` will be the first item in its part:
  ///
  /// ```
  /// [1,2,3,4,5].divideList((v)=>v==2 || v==4) ➜ [[1,2,3], [4,5]]
  /// ```
  ///
  List<List<T>> divideList(
    Predicate<T> test,
  ) {
    if (isEmpty) return [];

    final List<List<T>> result = [];
    final List<int> indexes = [];

    for (int i = 0; i < length; i++) {
      if (test(this[i])) indexes.add(i);
    }

    if (indexes.isEmpty)
      return [this];
    else {
      for (int i = 0; i < indexes.length; i++) {
        final ini = (i == 0) ? 0 : indexes[i];
        final end = (i == indexes.length - 1) ? (length - 1) : (indexes[i + 1] - 1);
        result.add(sublist(ini, end + 1));
      }
      return result;
    }
  }

  /// Search a list for items that satisfy a [test] predicate (matching items),
  /// and then divide that list into a [Map] of parts, such as each part contains
  /// one matching item, and the keys are given by the [key] function.
  ///
  /// If no items satisfy the [test], it will return an empty map.
  ///
  /// if [includeFirstItems] is false (the default), each matching item will be the
  /// first item of its respective part. If [includeFirstItems] is true, the items
  /// before the first matched item will be included in the first part (otherwise, they
  /// will be discarded).
  ///
  ///
  /// Example: Suppose you have a list with Chapters, Texts and Images.
  /// You can break it into chapters, by the chapter's id, like this:
  ///
  /// ```
  /// bookInfo.divideListAsMap(
  ///         (item) => item is Chapter,
  ///         key: (item) => (item as Chapter).id);
  /// ```
  ///
  /// In another example, the matching items are `2` and `4`. We'll divide
  /// the following list into 2, one containing `2`, and another containing `4`.
  /// Note `2` and `4` will be the first items in their part:
  ///
  /// ```
  /// [1,2,3,4,5].divideListAsMap((v)=>v==2 || v==4, (v)=>v) ➜ {2:[2,3], 4:[4,5]}
  /// ```
  ///
  /// However, if we do `includeFirstItems: true`, the number `1` will be included:
  ///
  /// ```
  /// [1,2,3,4,5].divideListAsMap((v)=>v==2 || v==4, (v)=>v, includeFirstItems: true)
  ///   ➜ {2:[1,2,3], 4:[4,5]}
  /// ```
  ///
  /// If there is no matching item, the result list will be empty:
  ///
  /// ```
  /// [1,2,3].divideListAsMap((v)=>v==10, (v)=>v) ➜ {}
  /// ```
  ///
  /// Note: Repeating keys will be joined together, but it probably doesn't
  /// make much sense to use this with repeating keys.
  ///
  /// See also: [groupBy] from `package:collection`
  ///
  Map<G, List<T>> divideListAsMap<G>(
    bool Function(T item) test, {
    G Function(T item)? key,
    bool includeFirstItems = false,
  }) {
    if (isEmpty) return {};

    final Map<G, List<T>> result = {};
    final List<int> indexes = [];
    final List<G> keys = [];

    int? firstMatch;
    for (int i = 0; i < length; i++) {
      final T item = this[i];

      if (test(item)) {
        indexes.add(i);
        final _key = (key == null) ? (item as G) : key(item);
        keys.add(_key);

        if (!includeFirstItems) firstMatch ??= i;
      }
    }

    firstMatch ??= 0;

    if (indexes.isEmpty)
      return {};
    else {
      for (int i = 0; i < indexes.length; i++) {
        final ini = i == 0 ? firstMatch : indexes[i];
        final fim = i == indexes.length - 1 ? length - 1 : indexes[i + 1] - 1;
        final repeating = result[keys[i]];
        result[keys[i]] = (repeating != null)
            ? //
            repeating + sublist(ini, fim + 1)
            : sublist(ini, fim + 1);
      }
      return result;
    }
  }

  /// Return a new list, adding a separator between the original list items
  /// (but not before the first and after the last).
  ///
  /// ```
  /// ["A", "B", "C"].addBetween("|") = ["A", "|", "B", "|", "C"];
  /// ```
  ///
  /// It may be used with widgets:
  ///
  /// ```
  /// [Container(), Container()].addBetween(SizedBox());
  /// ```
  ///
  List<T> addBetween(T separator) {
    if (length <= 1)
      return toList();
    //
    else {
      final List<T> newItems = <T>[];
      for (int i = 0; i < length - 1; i++) {
        newItems.add(this[i]);
        newItems.add(separator);
      }
      newItems.add(this[length - 1]);
      return newItems;
    }
  }

  /// Return an efficient concatenation of up to 5 lists:
  ///
  /// ```dart
  /// list = list1.concat(list2, list3, list4, list5);
  /// ```
  ///
  /// The resulting list has fixed size, but is not unmodifiable/immutable.
  /// Passing null is the same as passing empty lists (they will be ignored).
  /// You should only use this if you need to concatenate lists as efficient as possible,
  /// or if your lists may be null. Otherwise, just add the lists like this:
  ///
  /// ```dart
  /// list = list1 + list2 + list3 + list4 + list5;
  /// ```
  List<T> concat(List<T>? list2, [List<T>? list3, List<T>? list4, List<T>? list5]) {
    final List<T> list1 = this;
    list2 ??= const [];
    list3 ??= const [];
    list4 ??= const [];
    list5 ??= const [];

    final totalLength = list1.length + list2.length + list3.length + list4.length + list5.length;

    // Return a non-const list, so that it can be sorted.
    if (totalLength == 0) return [];

    final T anyItem = list1.isNotEmpty
        ? list1.first
        : list2.isNotEmpty
            ? list2.first
            : list3.isNotEmpty
                ? list3.first
                : list4.isNotEmpty
                    ? list4.first
                    : list5.first;

    /// Preallocate the necessary number of items, and then copy directly into place.
    return List<T>.filled(totalLength, anyItem)
      ..setAll(0, list1)
      ..setAll(list1.length, list2)
      ..setAll(list1.length + list2.length, list3)
      ..setAll(list1.length + list2.length + list3.length, list4)
      ..setAll(list1.length + list2.length + list3.length + list4.length, list5);
  }

  /// Cut the original list into one or more lists with at most [length] items.
  List<List<T>> splitByLength(int length) {
    assert(length > 0);
    final List<List<T>> chunks = <List<T>>[];
    for (var i = 0; i < this.length; i += length) {
      final end = (i + length < this.length) ? i + length : this.length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }

  /// Returns a new list, which is equal to the original one, but without
  /// duplicates. In other words, the new list has only distinct items.
  /// Optionally, you can provide an [id] function to compare the items.
  ///
  /// See also: [whereNoDuplicates] in [FicIterableExtension] for a lazy version.
  ///
  /// See also: [removeDuplicates] to mutate the current list.
  ///
  List<T> distinct({dynamic Function(T item)? by}) => by != null
      ? whereNoDuplicates(by: by).toList()
      : [
          ...{...this}
        ];

  /// Removes all duplicates from the list, leaving only the distinct items.
  /// Optionally, you can provide an [id] function to compare the items.
  ///
  /// If you pass [removeNulls] as true, it will also remove the nulls
  /// (it will check the item is null, before applying the [by] function).
  ///
  /// See also: [distinct] to return a new list and keep the original unchanged.
  ///
  /// See also: [whereNoDuplicates] in [FicIterableExtension] for a lazy version.
  ///
  void removeDuplicates({
    dynamic Function(T item)? by,
    bool removeNulls = false,
  }) {
    if (by != null) {
      final Set<dynamic> ids = <dynamic>{};
      removeWhere((item) {
        if (removeNulls && item == null) return true;
        final dynamic id = by(item);
        return !ids.add(id);
      });
    } else {
      final Set<T> items = {};
      removeWhere((item) {
        if (removeNulls && item == null) return true;
        return !items.add(item);
      });
    }
  }

  /// Removes all `null`s from the [List].
  ///
  /// See also: [whereNotNull] in [FicIterableExtension] for a lazy version.
  ///
  /// See also: [removeDuplicates] which can also remove nulls.
  ///
  void removeNulls() {
    removeWhere((element) => element == null);
  }

  /// Returns a [List] of the objects in this list in reverse order.
  /// Very efficient since it returns a view (which means, if you change the original list
  /// this one will also change, and vice-versa).
  ///
  /// Note: `List.reversed` returns an `Iterable`, while `List.reversedView` returns
  /// a `List`. This difference is important because if you do `list.reversed.toList()`
  /// you don't have a view anymore, and it's not efficient.
  ///
  /// Beware when using [reversedView] with NNBD:
  ///
  ///     // The runtimeType here is <int>, not <int?>
  ///     List<int?> reversed = [1, 2, 3].reversedView;
  ///
  ///     // The runtimeType here is <int?>
  ///     List<int?> reversed = <int ?>[1, 2, 3].reversedView;
  ///
  List<T> get reversedView => ReversedListView<T>(this);
}

extension FicListExtensionNullable<T> on List<T?> {
  //
  /// Returns a new [List] with all `null`s removed.
  /// This may return a list with a non-nullable type.
  ///
  /// See also: [removeNulls], which mutates the list (and does not change its type).
  ///
  /// Example:
  ///
  /// ```dart
  /// List<String?> myList = ["a", "b", null];
  ///
  /// // Is ["a", "b"]
  /// List<String> myNewList = myList.withNullsRemoved();
  /// ```
  ///
  List<T> withNullsRemoved() {
    Iterable<T> _whereNotNull() sync* {
      for (final element in this) {
        if (element != null) yield element;
      }
    }

    return _whereNotNull().toList();
  }
}
