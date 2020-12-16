import "dart:math";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:collection/collection.dart";
import "package:fast_immutable_collections/src/iset/s_flat.dart";

// ////////////////////////////////////////////////////////////////////////////

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

  /// If the item does not exist in the list, add it and return true.
  /// If it already exists, remove it and return false.
  bool toggle(T item) {
    var result = contains(item);
    if (result)
      remove(item);
    else
      add(item);
    return result;
  }

  /// Return true if the lists contain the same items (in any order).
  /// Ignores repeated items.
  bool compareAsSets(List other) {
    if (this == null) return other == null;
    if (identical(this, other)) return true;
    return SetEquality(MapEntryEquality()).equals(Set.of(this), Set.of(other));
  }

  /// Maps each element of the list.
  /// The map function gets both the original item and its index.
  Iterable<E> mapIndexed<E>(E Function(int index, T item) map) sync* {
    for (var index = 0; index < length; index++) {
      yield map(index, this[index]);
    }
  }

  /// Split a list, according to a predicate,
  /// removing the list item that satisfies the predicate.
  ///
  /// ```
  /// [1,2,3].splitList((v)=>v==2) ➜ [[1], [3]]
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

  /// Divide a list, according to a predicate,
  /// keeping the list item that satisfies the predicate as the first segment item.
  /// divideList([1,2,3,4,5], (v)=>v==2 || v==4) ➜ [[1,2,3],[4,5]]
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

  /// Divide a list into a [Map] by using a predicate, keeping as each segment's first item
  /// the list item that satisfies the [test] predicate.
  ///
  /// [1,2,3,4,5].divideListAsMap((v)=>v==2 || v==4, (v)=>v) ➜ {2:[1,2,3], 4:[4,5]}
  /// [1,2,3].divideListAsMap((v)=>v==2, (v)=>v) ➜ {2: [1,2,3]}
  /// [1,2,3].divideListAsMap((v)=>v==10, (v)=>v) ➜ {null: [1,2,3]}
  ///
  Map<G, List<T>> divideListAsMap<G>(
    bool Function(T element) test, {
    G Function(T element) key,
  }) {
    if (isEmpty) return {};

    Map<G, List<T>> result = {};
    List<int> indexes = [];
    List<G> keys = [];

    for (int i = 0; i < length; i++) {
      T element = this[i];
      if (test(element)) {
        indexes.add(i);
        keys.add(key(element));
      }
    }

    if (indexes.isEmpty)
      return {null: this};
    else {
      for (int i = 0; i < indexes.length; i++) {
        var ini = i == 0 ? 0 : indexes[i];
        var fim = i == indexes.length - 1 ? length - 1 : indexes[i + 1] - 1;
        result[keys[i]] = sublist(ini, fim + 1);
      }
      return result;
    }
  }

  /// Return true if the list items are identical, using [identical], in the same order.
  bool deepIdenticalEquals(List other) {
    if (identical(this, other)) return true;
    if (length != other.length) return false;
    for (int i = 0; i < length; i++) {
      if (!identical(this[i], other[i])) return false;
    }
    return true;
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

  /// Return an efficient concatenation of up to 4 lists.
  /// The resulting list has fixed size, buy is not unmodifiable/immutable.
  /// Passing null is the same as passing empty lists.
  /// You should only use this if you need to concatenate lists as efficient as possible.
  List<T> concat(List<T> list2, [List<T> list3, List<T> list4]) {
    List<T> list1 = this ?? <T>[];
    list2 ??= <T>[];
    list3 ??= <T>[];
    list4 ??= <T>[];
    return List<T>(list1.length + list2.length + list3.length + list4.length)
      ..setAll(0, list1)
      ..setAll(list1.length, list2)
      ..setAll(list1.length + list2.length, list3)
      ..setAll(list1.length + list2.length + list3.length, list4);
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
  /// Optionally, you can provide a [id] function to compare the items.
  List<T> distinct([dynamic Function(T item) id]) => id != null
      ? removeDuplicates(id).toList()
      : [
          ...{...this}
        ];

  /// Returns a [List] of the objects in this list in reverse order.
  /// Very efficient since it returns a view (which means, if you change the original list
  /// this one will also change, and vice-versa).
  ///
  /// Note: `List.reversed` returns an `Iterable`, while `List.reversedListView` returns
  /// a `List`. This difference is important because if you do `list.reversed.toList()`
  /// you don't have a view anymore, and it's not efficient.
  ///
  /// Important: At the moment, some of the list methods return `UnimplementedError`.
  /// All methods will be completed in the future.
  ///
  List get reversedListView => _ReversedListView(this);
}

// ////////////////////////////////////////////////////////////////////////////

/// Returns a [List] of the objects in this list in reverse order.
/// Very efficient since it returns a view (which means, if you change the original list
/// this one will also change, and vice-versa).
///
/// Note: `List.reversed` returns an [Iterable], while this is a [List].
///
/// Important: At the moment, many methods are still unimplemented.
///
class _ReversedListView<T> implements List<T> {
  //
  final List<T> list;

  _ReversedListView(this.list);

  @override
  T get first => list.last;

  @override
  T get last => list.first;

  @override
  int get length => list.length;

  @override
  set length(int value) => throw UnimplementedError();

  @override
  set first(T value) => this[0] = value;

  @override
  set last(T value) => list[0] = value;

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    var index = list.lastIndexWhere(test, start == 0 ? null : start);
    return (index == -1) ? null : list.length - index - 1;
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int start]) {
    var index = list.indexWhere(test, start ?? 0);
    return (index == -1) ? null : list.length - index - 1;
  }

  @override
  List<T> operator +(List<T> other) => throw UnimplementedError();

  @override
  T operator [](int index) => list[list.length - index - 1];

  @override
  void operator []=(int index, T value) => list[list.length - index - 1] = value;

  @override
  void add(T value) => list.insert(0, value);

  @override
  void addAll(Iterable<T> iterable) => throw UnimplementedError();

  @override
  bool any(bool Function(T element) test) => list.reversed.any(test);

  @override
  Map<int, T> asMap() => list.reversed.toList().asMap();

  @override
  List<R> cast<R>() => _ReversedListView(list.cast<R>());

  @override
  void clear() => list.clear();

  @override
  bool contains(Object element) => list.contains(element);

  @override
  T elementAt(int index) => this[index];

  @override
  bool every(bool Function(T element) test) => list.reversed.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T element) f) => list.reversed.expand(f);

  @override
  void fillRange(int start, int end, [T fillValue]) => throw UnimplementedError();

  @override
  T firstWhere(bool Function(T element) test, {T Function() orElse}) =>
      list.reversed.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      list.reversed.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => list.reversed.followedBy(other);

  @override
  void forEach(void Function(T element) f) => list.reversed.forEach(f);

  @override
  Iterable<T> getRange(int start, int end) => throw UnimplementedError();

  @override
  int indexOf(T element, [int start = 0]) => throw UnimplementedError();

  @override
  void insert(int index, T element) => throw UnimplementedError();

  @override
  void insertAll(int index, Iterable<T> iterable) => throw UnimplementedError();

  @override
  bool get isEmpty => list.isEmpty;

  @override
  bool get isNotEmpty => list.isNotEmpty;

  @override
  Iterator<T> get iterator => list.reversed.iterator;

  @override
  String join([String separator = ""]) => list.reversed.join(separator);

  @override
  int lastIndexOf(T element, [int start]) => throw UnimplementedError();

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      list.reversed.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T e) f) => list.reversed.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => list.reversed.reduce(combine);

  @override
  bool remove(Object value) => list.remove(value);

  @override
  T removeAt(int index) => list.removeAt(list.length - 1 - index);

  @override
  T removeLast() => list.removeAt(0);

  @override
  void removeRange(int start, int end) => throw UnimplementedError();

  @override
  void removeWhere(bool Function(T element) test) => list.removeWhere(test);

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) => throw UnimplementedError();

  @override
  void retainWhere(bool Function(T element) test) => list.retainWhere(test);

  @override
  Iterable<T> get reversed => list;

  @override
  void setAll(int index, Iterable<T> iterable) => throw UnimplementedError();

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) =>
      throw UnimplementedError();

  @override
  void shuffle([Random random]) => list.shuffle(random);

  @override
  T get single => list.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      list.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => list.reversed.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => list.reversed.skipWhile(test);

  @override
  void sort([int Function(T a, T b) compare]) => throw UnimplementedError();

  @override
  List<T> sublist(int start, [int end]) => list.reversed.toList().sublist(start, end);

  @override
  Iterable<T> take(int count) => list.reversed.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => list.reversed.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => list.reversed.toList();

  @override
  Set<T> toSet() => list.reversed.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => list.reversed.where(test);

  @override
  Iterable<E> whereType<E>() => list.reversed.whereType<E>();
}
