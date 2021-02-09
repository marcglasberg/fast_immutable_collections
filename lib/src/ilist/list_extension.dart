import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:collection/collection.dart";
import "package:fast_immutable_collections/src/ilist/reversed_list_view.dart";

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
  /// Items which don't appear in [ordering] will be included in the end, in their original order.
  /// Items of [ordering] which are not found in the original list are ignored.
  ///
  void sortLike(Iterable ordering) {
    List<T> result = sortedLike(ordering);
    clear();
    addAll(result);
  }

  /// Moves the first occurrence of the [item] to the start of the list.
  void moveToTheFront(T item) {
    int pos = indexOf(item);
    if (pos != -1 && pos != 0) {
      removeAt(pos);
      insert(0, item);
    }
  }

  /// Moves the first occurrence of the [item] to the end of the list.
  void moveToTheEnd(T item) {
    int pos = indexOf(item);
    if (pos != -1 && pos != length - 1) {
      removeAt(pos);
      add(item);
    }
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

  /// If the item does not exist in the list, add it and return `true`.
  /// If it already exists, remove the first instance of it and return `false`.
  bool toggle(T item) {
    var result = contains(item);
    if (result)
      remove(item);
    else
      add(item);
    return result;
  }

  /// Return `true` if the lists contain the same items (in any order).
  /// Ignores repeated items.
  bool compareAsSets(List other) {
    if (this == null) return other == null;
    if (other == null) return false;
    if (identical(this, other)) return true;
    return SetEquality(MapEntryEquality()).equals(Set.of(this), Set.of(other));
  }

  /// Maps each element of the list.
  /// The [map] function gets both the original [item] and its [index].
  ///
  /// Note: This is done through a [*synchronous generator*](https://dart.dev/guides/language/language-tour#generators).
  Iterable<E> mapIndexed<E>(E Function(int index, T item) map) sync* {
    for (var index = 0; index < length; index++) {
      yield map(index, this[index]);
    }
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
      T element = this[i];
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
    bool Function(T element) test,
  ) {
    if (isEmpty) return [];

    List<List<T>> result = [];
    List<int> indexes = [];

    for (int i = 0; i < length; i++) {
      if (test(this[i])) indexes.add(i);
    }

    if (indexes.isEmpty)
      return [this];
    else {
      for (int i = 0; i < indexes.length; i++) {
        var ini = i == 0 ? 0 : indexes[i];
        var fim = i == indexes.length - 1 ? length - 1 : indexes[i + 1] - 1;
        result.add(sublist(ini, fim + 1));
      }
      return result;
    }
  }

  /// Search a list for items that satisfy a [test] predicate (matching items),
  /// and then divide that list into a [Map] of parts, such as each part contains
  /// one matching item, and the keys are given by the [key] function.
  /// Except maybe for the first matching item, it will keep the matching items as
  /// the first item in each part.
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
  /// The `4` will be the first item in its part:
  ///
  /// ```
  /// [1,2,3,4,5].divideListAsMap((v)=>v==2 || v==4, (v)=>v) ➜ {2:[1,2,3], 4:[4,5]}
  /// ```
  ///
  /// In the example below the single matching item is `2`.
  /// This means the list is unchanged:
  ///
  /// ```
  /// [1,2,3].divideListAsMap((v)=>v==2, (v)=>v) ➜ {2: [1,2,3]}
  /// ```
  ///
  /// In the example below there is no matching item.
  /// This means the list is unchanged:
  ///
  /// ```
  /// [1,2,3].divideListAsMap((v)=>v==10, (v)=>v) ➜ {null: [1,2,3]}
  /// ```
  ///
  /// Note: Repeating keys will be joined together, but it probably doesn't
  /// make much sense to use this with repeating keys.
  ///
  /// See also: [groupBy] from `package:collection`
  ///
  Map<G, List<T>> divideListAsMap<G>(
    bool Function(T item) test, {
    G Function(T item) key,
  }) {
    if (isEmpty) return {};

    Map<G, List<T>> result = {};
    List<int> indexes = [];
    List<G> keys = [];

    for (int i = 0; i < length; i++) {
      T item = this[i];
      if (test(item)) {
        indexes.add(i);
        var _key = (key == null) ? (item as G) : key(item);
        keys.add(_key);
      }
    }

    if (indexes.isEmpty)
      return {null: this};
    else {
      for (int i = 0; i < indexes.length; i++) {
        var ini = i == 0 ? 0 : indexes[i];
        var fim = i == indexes.length - 1 ? length - 1 : indexes[i + 1] - 1;
        var repeating = result[keys[i]];
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
    if (this == null)
      return null;
    //
    else if (length <= 1)
      return toList();
    //
    else {
      List<T> newItems = <T>[];
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
  /// ```
  /// list = list1.concat(list2, list3, list4, list5);
  /// ```
  ///
  /// The resulting list has fixed size, but is not unmodifiable/immutable.
  /// Passing null is the same as passing empty lists (they will be ignored).
  /// You should only use this if you need to concatenate lists as efficient as possible,
  /// or if your lists may be null. Otherwise, just add the lists like this:
  ///
  /// ```
  /// list = list1 + list2 + list3 + list4 + list5;
  /// ```
  List<T> concat(List<T> list2, [List<T> list3, List<T> list4, List<T> list5]) {
    List<T> list1 = this ?? const [];
    list2 ??= const [];
    list3 ??= const [];
    list4 ??= const [];
    list5 ??= const [];

    var totalLength = list1.length + list2.length + list3.length + list4.length + list5.length;

    if (totalLength == 0) return const [];

    T anyItem = list1.isNotEmpty
        ? list1.first
        : list2.isNotEmpty
            ? list2.first
            : list3.isNotEmpty
                ? list3.first
                : list4.isNotEmpty
                    ? list4.first
                    : list5.isNotEmpty
                        ? list5.first
                        : null;

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
    assert(length != null && length > 0);
    var chunks = <List<T>>[];
    for (var i = 0; i < this.length; i += length) {
      var end = (i + length < this.length) ? i + length : this.length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }

  /// Returns a new list where [newItems] are added or updated, by their [id].
  /// 1) Items with the same [id] will be replaced.
  /// 2) Items with new [id]s will go to the end of the list.
  ///
  /// Note: The original list and the [newItems] list won't change.
  ///
  /// Note: If the original list contains more than one item with the same
  /// [id] as some item in [newItems], the first will be replaces, and the
  /// others removed.
  ///
  /// Note: All null items in the original list and in [newItems] will
  /// be removed from the result.
  ///
  List<T> update(
    List<T> newItems,
    dynamic Function(T item) id,
  ) {
    int i = 0;

    Map<dynamic, int> ids = {for (var item in newItems) (item == null) ? null : id(item): i++};

    var newList = map((T item) {
      int pos = ids[(item == null) ? null : id(item)];
      if (pos == null) return item;
      T newItem = newItems[pos];
      newItems[pos] = null;
      return newItem;
    }).where((item) => item != null).toList();

    for (T newItem in newItems) {
      if (newItem != null) newList.add(newItem);
    }

    return newList;
  }

  /// Removes all duplicates, leaving only the distinct items.
  /// Optionally, you can provide an [id] function to compare the items.
  ///
  /// See also `Iterable.removeDuplicates()` in [FicIterableExtension] for a lazy version.
  ///
  List<T> distinct({dynamic Function(T item) by}) => by != null
      ? removeDuplicates(by: by).toList()
      : [
          ...{...this}
        ];

  /// Returns a [List] of the objects in this list in reverse order.
  /// Very efficient since it returns a view (which means, if you change the original list
  /// this one will also change, and vice-versa).
  ///
  /// Note: `List.reversed` returns an `Iterable`, while `List.reversedView` returns
  /// a `List`. This difference is important because if you do `list.reversed.toList()`
  /// you don't have a view anymore, and it's not efficient.
  ///
  List<T> get reversedView => ReversedListView<T>(this);
}
