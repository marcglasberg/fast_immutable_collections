import 'dart:collection';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import '../imap/imap.dart';
import '../iset/iset.dart';
import '../utils/immutable_collection.dart';
import 'ilist_of_2.dart';
import 'l_add.dart';
import 'l_add_all.dart';
import 'l_flat.dart';
import 'modifiable_list_view.dart';
import 'unmodifiable_list_view.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension IListExtension<T> on List<T> {
  //
  /// Locks the list, returning an *immutable* list ([IList]).
  IList<T> get lock => IList<T>(this);

  /// Locks the list, returning an *immutable* list ([IList]).
  /// This is unsafe: Use it at your own peril.
  /// This constructor is fast, since it makes no defensive copies of the list.
  /// However, you should only use this with a new list you've created yourself,
  /// when you are sure no external copies exist. If the original list is modified,
  /// it will break the IList and any other derived lists in unpredictable ways.
  /// Note you can optionally disallow unsafe constructors in the global configuration
  /// by doing: `disallowUnsafeConstructors = true` (and then optionally preventing
  /// further configuration changes by calling `lockConfig()`).
  IList<T> get lockUnsafe => IList<T>.unsafe(this, config: defaultConfigList);

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// This is similar to [sort], but uses a merge sort algorithm
  /// (https://en.wikipedia.org/wiki/Merge_sort).
  ///
  /// On contrary to [sort], [orderedSort] is stable, meaning distinct objects
  /// that compare as equal end up in the same order as they started in.
  ///
  void sortOrdered([int Function(T a, T b) compare]) {
    mergeSort(this, compare: compare);
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

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// An **immutable** list.
@immutable
class IList<T> // ignore: must_be_immutable
    extends ImmutableCollection<IList<T>> implements Iterable<T> {
  //
  L<T> _l;

  /// The list configuration.
  final ConfigList config;

  static IList<T> empty<T>([ConfigList config]) =>
      IList._unsafe(LFlat.empty<T>(), config: config ?? defaultConfigList);

  /// Create an [IList] from any [Iterable].
  /// Fast, if the Iterable is another [IList].
  factory IList([Iterable<T> iterable]) => //
      IList.withConfig(iterable, defaultConfigList);

  /// Create an [IList] from any [Iterable] and a [ConfigList].
  /// Fast, if the Iterable is another [IList].
  factory IList.withConfig(
    Iterable<T> iterable,
    ConfigList config,
  ) =>
      iterable is IList<T>
          ? iterable
          : (iterable == null) || iterable.isEmpty
              ? IList.empty<T>(config)
              : IList<T>._unsafe(LFlat<T>(iterable), config: config);

  /// Special IList constructor from ISet.
  factory IList.fromISet(
    ISet<T> iSet, {
    int Function(T a, T b) compare,
    @required ConfigList config,
  }) {
    List<T> list = iSet.toList(growable: false, compare: compare);
    var l = (list == null) ? LFlat.empty<T>() : LFlat<T>.unsafe(list);
    return IList._unsafe(l, config: config ?? defaultConfigList);
  }

  /// Safe. Fast if the iterable is an IList.
  IList._(Iterable<T> iterable, {@required this.config})
      : assert(config != null),
        _l = iterable is IList<T>
            ? iterable._l
            : iterable == null
                ? LFlat.empty<T>()
                : LFlat<T>(iterable);

  /// Unsafe constructor. Use this at your own peril.
  /// This constructor is fast, since it makes no defensive copies of the list.
  /// However, you should only use this with a new list you've created yourself,
  /// when you are sure no external copies exist. If the original list is modified,
  /// it will break the IList and any other derived lists in unpredictable ways.
  /// Note you can optionally disallow unsafe constructors in the global configuration
  /// by doing: `disallowUnsafeConstructors = true` (and then optionally preventing
  /// further configuration changes by calling `lockConfig()`).
  IList.unsafe(List<T> list, {@required this.config})
      : assert(config != null),
        _l = (list == null) ? LFlat.empty<T>() : LFlat<T>.unsafe(list) {
    if (disallowUnsafeConstructors) throw UnsupportedError("IList.unsafe is disallowed.");
  }

  /// Unsafe.
  IList._unsafe(this._l, {@required this.config}) : assert(config != null);

  /// Unsafe.
  IList._unsafeFromList(List<T> list, {@required this.config})
      : assert(config != null),
        _l = (list == null) ? LFlat.empty<T>() : LFlat<T>.unsafe(list);

  /// Creates a new list with the given [config].
  ///
  /// To copy the config from another [IList]:
  ///    `list = list.withConfig(other.config)`.
  ///
  /// To change the current config:
  ///    `list = list.withConfig(list.config.copyWith(isDeepEquals: isDeepEquals))`.
  ///
  /// See also: [withIdentityEquals] and [withDeepEquals].
  ///
  IList<T> withConfig(ConfigList config) {
    assert(config != null);
    return (config == this.config) ? this : IList._unsafe(_l, config: config);
  }

  /// Creates a list with `identityEquals` (compares the internals by `identity`).
  IList<T> get withIdentityEquals =>
      config.isDeepEquals ? IList._unsafe(_l, config: config.copyWith(isDeepEquals: false)) : this;

  /// Creates a list with `deepEquals` (compares all list items by equality).
  IList<T> get withDeepEquals =>
      config.isDeepEquals ? this : IList._unsafe(_l, config: config.copyWith(isDeepEquals: true));

  IList<T> withConfigFrom(IList<T> other) => withConfig(other.config);

  bool get isDeepEquals => config.isDeepEquals;

  bool get isIdentityEquals => !config.isDeepEquals;

  /// Unlocks the list, returning a regular (mutable, growable) [List].
  /// This list is "safe", in the sense that is independent from the original [IList].
  List<T> get unlock => List.of(_l, growable: true);

  /// Unlocks the list, returning a safe, unmodifiable (immutable) [List] view.
  /// The word "view" means the list is backed by the original [IList].
  /// Using this is very fast, since it makes no copies of the [IList] items.
  /// However, if you try to use methods that modify the list, like [add],
  /// it will throw an [UnsupportedError].
  /// It is also very fast to lock this list back into an [IList].
  List<T> get unlockView => UnmodifiableListView(this);

  /// Unlocks the list, returning a safe, modifiable (mutable) [List].
  /// Using this is very fast at first, since it makes no copies of the [IList]
  /// items. However, if and only if you use a method that mutates the list,
  /// like [add], it will unlock internally (make a copy of all IList items). This is
  /// transparent to you, and will happen at most only once. In other words,
  /// it will unlock the IList, lazily, only if necessary.
  /// If you never mutate the list, it will be very fast to lock this list
  /// back into an [IList].
  List<T> get unlockLazy => ModifiableListView(this);

  @override
  Iterator<T> get iterator => _l.iterator;

  @override
  bool get isEmpty => _l.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  /// If [isDeepEquals] configuration is true:
  /// Will return true only if the list items are equal (and in the same order),
  /// and the list configurations are equal. This may be slow for very
  /// large lists, since it compares each item, one by one.
  ///
  /// If [isDeepEquals] configuration is false:
  /// Will return true only if the lists internals are the same instances
  /// (comparing by identity). This will be fast even for very large lists,
  /// since it doesn't compare each item.
  /// Note: This is not the same as `identical(list1, list2)` since it doesn't
  /// compare the lists themselves, but their internal state. Comparing the
  /// internal state is better, because it will return true more often.
  ///
  @override
  bool operator ==(Object other) => (other is IList<T>)
      ? isDeepEquals
          ? equalItemsAndConfig(other)
          : same(other)
      : false;

  /// Will return true only if the IList items are equal to the iterable items,
  /// and in the same order. This may be slow for very large lists, since it compares each item,
  /// one by one. You can compare the list with ordered sets, but unordered sets will throw a
  /// `StateError`. To compare the IList with unordered sets, try method [unorderedEqualItems].
  @override
  bool equalItems(covariant Iterable<T> other) {
    if (identical(this, other)) return true;
    if (other is IList<T>) return (flush._l as LFlat<T>).deepListEquals(other.flush._l as LFlat<T>);
    if (other is List<T>) return const ListEquality().equals(UnmodifiableListView(this), other);
    if (other is HashSet || other is ISet) throw StateError("Can't compare to unordered set.");
    return const IterableEquality().equals(_l, other);
  }

  /// Will return true only if the IList and the iterable items have the same number of elements,
  /// and the elements of the IList can be paired with the elements of the iterable, so that each
  /// pair is equal. This may be slow for very large lists, since it compares each item,
  /// one by one.
  bool unorderedEqualItems(covariant Iterable<T> other) {
    if (identical(this, other) || (other is IList<T> && same(other))) return true;
    return const UnorderedIterableEquality().equals(_l, other);
  }

  /// Will return true only if the list items are equal and in the same order,
  /// and the list configurations are equal. This may be slow for very
  /// large lists, since it compares each item, one by one.
  @override
  bool equalItemsAndConfig(IList<T> other) =>
      identical(this, other) ||
      other is IList<T> &&
          runtimeType == other.runtimeType &&
          config == other.config &&
          (flush._l as LFlat<T>).deepListEquals(other.flush._l as LFlat<T>);

  /// Will return `true` only if the lists internals are the same instances
  /// (comparing by identity). This will be fast even for very large lists,
  /// since it doesn't compare each item.
  /// Note: This is not the same as `identical(list1, list2)` since it doesn't
  /// compare the lists themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  @override
  bool same(IList<T> other) => identical(_l, other._l) && (config == other.config);

  @override
  int get hashCode => isDeepEquals
      ? (flush._l as LFlat<T>).deepListHashcode() ^ config.hashCode
      : identityHashCode(_l) ^ config.hashCode;

  /// Compacts the list. Chainable method.
  IList<T> get flush {
    if (!isFlushed) _l = LFlat<T>(_l);
    return this;
  }

  bool get isFlushed => _l is LFlat;

  /// Return a new list with [item] added to the end of the current list,
  /// (thus extending the length by one).
  IList<T> add(T item) => IList<T>._unsafe(_l.add(item), config: config);

  /// Returns a new list with all [items] added to the end of the current list,
  /// (thus extending the length by the length of items).
  IList<T> addAll(Iterable<T> items) => IList<T>._unsafe(_l.addAll(items), config: config);

  /// Removes the first occurrence of [item] from this list.
  ///
  ///     IList<String> parts = ['head', 'shoulders', 'knees', 'toes'].lock;
  ///     parts.remove('head');
  ///     parts.join(', ');     // 'shoulders, knees, toes'
  ///
  /// The method has no effect if [item] was not in the list.
  ///
  IList<T> remove(T item) {
    final L<T> result = _l.remove(item);
    return identical(result, _l) ? this : IList<T>._unsafe(result, config: config);
  }

  /// Removes all occurrences of all [items] from this list.
  /// Same as calling [removeMany] for each item in [items].
  ///
  /// The method has no effect if [item] was not in the list.
  ///
  IList<T> removeAll(Iterable<T> items) {
    final L<T> result = _l.removeAll(items);
    return identical(result, _l) ? this : IList<T>._unsafe(result, config: config);
  }

  /// Removes all occurrences of [item] from this list.
  ///
  ///     IList<String> parts = ['head', 'shoulders', 'knees', 'head', 'toes'].lock;
  ///     parts.remove('head');
  ///     parts.join(', ');     // 'shoulders, knees, toes'
  ///
  /// The method has no effect if [item] was not in the list.
  ///
  IList<T> removeMany(T item) {
    final L<T> result = _l.removeMany(item);
    return identical(result, _l) ? this : IList<T>._unsafe(result, config: config);
  }

  /// Removes all nulls from this list.
  IList<T> removeNulls() => removeAll(null);

  /// Removes duplicates (but keeps items which appear only
  /// once, plus the first time other items appear).
  IList<T> removeDuplicates() {
    LinkedHashSet<T> set = _l.toLinkedHashSet();
    return IList<T>.withConfig(set, config);
  }

  /// Removes duplicates (but keeps items which appear only
  /// once, plus the first time other items appear).
  IList<T> removeNullsAndDuplicates() {
    LinkedHashSet<T> set = _l.toLinkedHashSet();
    set.remove(null);
    return IList<T>.withConfig(set, config);
  }

  /// Removes the element, if it exists in the list.
  /// Otherwise, adds it to the list.
  IList<T> toggle(T element) => contains(element) ? remove(element) : add(element);

  T operator [](int index) => _l[index];

  @override
  bool any(bool Function(T) test) => _l.any(test);

  @override
  IList<R> cast<R>() {
    var result = _l.cast<R>();
    return (result is L<R>)
        ? IList._unsafe(result, config: ConfigList(isDeepEquals: config.isDeepEquals))
        : IList._(result, config: ConfigList(isDeepEquals: config.isDeepEquals));
  }

  @override
  bool contains(Object element) => _l.contains(element);

  @override
  T elementAt(int index) => _l[index];

  @override
  bool every(bool Function(T) test) => _l.every(test);

  @override
  IList<E> expand<E>(Iterable<E> Function(T) f, {ConfigList config}) =>
      IList._(_l.expand(f), config: config ?? (T == E ? this.config : defaultConfigList));

  @override
  int get length {
    final int length = _l.length;
    if (length == 0 && _l is! LFlat) _l = LFlat.empty<T>();
    return length;
  }

  /// Returns the first element.
  /// Throws a [StateError] if the list is empty.
  @override
  T get first => _l.first;

  /// Returns the last element.
  /// Throws a [StateError] if the list is empty.
  @override
  T get last => _l.last;

  /// Checks that this iterable has only one element, and returns that element.
  /// Throws a [StateError] if the list is empty or has more than one element.
  @override
  T get single => _l.single;

  /// Returns the first element, or `null` if the list is empty.
  T get firstOrNull => isEmpty ? null : _l.first;

  /// Returns the last element, or `null` if the list is empty.
  T get lastOrNull => isEmpty ? null : _l.last;

  /// Checks that the list has only one element, and returns that element.
  /// Return `null` if the list is empty or has more than one element.
  T get singleOrNull => (length != 1) ? null : _l.last;

  /// Returns the first element, or [orElse] if the list is empty.
  T firstOr(T orElse) => isEmpty ? orElse : _l.first;

  /// Returns the last element, or [orElse] if the list is empty.
  T lastOr(T orElse) => isEmpty ? orElse : _l.last;

  /// Checks if the list has only one element, and returns that element.
  /// Return `null` if the list is empty or has more than one element.
  T singleOr(T orElse) => (length != 1) ? orElse : _l.first;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) => _l.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _l.fold(initialValue, combine);

  @override
  IList<T> followedBy(Iterable<T> other) => IList._(_l.followedBy(other), config: config);

  @override
  void forEach(void Function(T element) f) => _l.forEach(f);

  @override
  String join([String separator = '']) => _l.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _l.lastWhere(test, orElse: orElse);

  @override
  IList<E> map<E>(E Function(T element) f, {ConfigList config}) =>
      IList._(_l.map(f), config: config ?? (T == E ? this.config : defaultConfigList));

  @override
  T reduce(T Function(T value, T element) combine) => _l.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _l.singleWhere(test, orElse: orElse);

  @override
  IList<T> skip(int count) => IList._(_l.skip(count), config: config);

  @override
  IList<T> skipWhile(bool Function(T value) test) => IList._(_l.skipWhile(test), config: config);

  @override
  IList<T> take(int count) => IList._(_l.take(count), config: config);

  @override
  IList<T> takeWhile(bool Function(T value) test) => IList._(_l.takeWhile(test), config: config);

  @override
  IList<T> where(bool Function(T element) test) => IList._(_l.where(test), config: config);

  @override
  IList<E> whereType<E>() => IList._(_l.whereType<E>(), config: config);

  /// If the list has more than `maxLength` elements, removes the last elements so it remains
  /// with only `maxLength` elements. If the list has `maxLength` or less elements, doesn't
  /// change anything.
  IList<T> maxLength(int maxLength) => IList._unsafe(_l.maxLength(maxLength), config: config);

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// The [compare] function must act as a [Comparator].
  ///
  ///     IList<String> numbers = ['two', 'three', 'four'].lock;
  ///     // Sort from shortest to longest.
  ///     numbers = numbers.sort((a, b) => a.length.compareTo(b.length));
  ///     print(numbers);  // [two, four, three]
  ///
  /// The default List implementations use [Comparable.compare] if
  /// [compare] is omitted.
  ///
  ///     IList<int> nums = [13, 2, -11].lock;
  ///     nums = nums.sort();
  ///     print(nums);  // [-11, 2, 13]
  ///
  /// A [Comparator] may compare objects as equal (return zero), even if they
  /// are distinct objects.
  /// The sort function is not guaranteed to be stable, so distinct objects
  /// that compare as equal may occur in any order in the result:
  ///
  ///     IList<String> numbers = ['one', 'two', 'three', 'four'].lock;
  ///     numbers = numbers.sort((a, b) => a.length.compareTo(b.length));
  ///     print(numbers);  // [one, two, four, three] OR [two, one, four, three]
  ///
  IList<T> sort([int Function(T a, T b) compare]) =>
      IList._unsafe(_l.sort(compare), config: config);

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// This is similar to [sort], but uses a merge sort algorithm
  /// (https://en.wikipedia.org/wiki/Merge_sort).
  ///
  /// On contrary to [sort], [sortOrdered] is stable, meaning distinct objects
  /// that compare as equal end up in the same order as they started in.
  ///
  ///     IList<String> numbers = ['one', 'two', 'three', 'four'].lock;
  ///     numbers = numbers.sort((a, b) => a.length.compareTo(b.length));
  ///     print(numbers);  // [one, two, four, three]
  ///
  IList<T> sortOrdered([int Function(T a, T b) compare]) {
    List<T> list = unlock..sortOrdered(compare);
    return IList._unsafeFromList(list, config: config);
  }

  /// Divides the list into two.
  /// The first one contains all items which satisfy the provided [test].
  /// The last one contains all the other items.
  /// The relative order of the items will be maintained.
  IListOf2<IList<T>> divideIn2(bool Function(T item) test) {
    List<T> first = [];
    List<T> last = [];
    for (T item in this) {
      if (test(item))
        first.add(item);
      else
        last.add(item);
    }
    return IListOf2(
      IList._unsafeFromList(first, config: config),
      IList._unsafeFromList(last, config: config),
    );
  }

  /// Moves all items that satisfy the provided [test] to the end of the list.
  /// Keeps the relative order of the moved items.
  IList<T> whereMoveToTheEnd(bool Function(T item) test) {
    IListOf2<IList<T>> lists = divideIn2(test);
    return lists.last + lists.first;
  }

  /// Moves all items that satisfy the provided [test] to the start of the list.
  /// Keeps the relative order of the moved items.
  IList<T> whereMoveToTheStart(bool Function(T item) test) {
    IListOf2<IList<T>> lists = divideIn2(test);
    return lists.first + lists.last;
  }

  @override
  List<T> toList({bool growable = true}) => _l.toList(growable: growable);

  @override
  Set<T> toSet() => _l.toSet();

  @override
  String toString() => "[${_l.join(", ")}]";

  /// Returns the concatenation of this list and [other].
  /// Returns a new list containing the elements of this list followed by
  /// the elements of [other].
  IList<T> operator +(Iterable<T> other) => addAll(other);

  /// Returns an [IMap] view of this list.
  /// The map uses the indices of this list as keys and the corresponding objects
  /// as values. The `Map.keys` [Iterable] iterates the indices of this list
  /// in numerical order.
  ///
  /// ```dart
  /// final IList<String> words = ['hel', 'lo', 'there'].lock;
  /// final IMap<int, String> iMap = words.asMap();
  /// print(iMap[0] + iMap[1]); // Prints 'hello';
  /// iMap.keys.toList(); // [0, 1, 2, 3]
  /// ```
  IMap<int, T> asMap() => IMap<int, T>(UnmodifiableListView(this).asMap());

  /// Returns an empty list with the same configuration.
  IList<T> clear() => empty<T>(config);

  /// Returns the index of the first [element] in the list.
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object [:o:] is encountered so that [:o == element:],
  /// the index of [:o:] is returned.
  ///
  /// If [start] is not provided, this method searches from the start of the list.
  ///
  /// ```dart
  /// final IList<String> notes = ['do', 're', 'mi', 're'].lock;
  /// notes.indexOf('re');    // 1
  /// notes.indexOf('re', 2); // 3
  /// ```
  ///
  /// Returns -1 if [element] is not found.
  ///
  /// ```dart
  /// notes.indexOf('fa');    // -1
  /// ```
  int indexOf(T element, [int start = 0]) {
    start ??= 0;
    var _length = length;
    if (start < 0 || start >= _length)
      throw ArgumentError.value(start, "index", "Index out of range");
    for (int i = start; i <= _length - 1; i++) if (this[i] == element) return i;
    return -1;
  }

  /// This is the equivalent to `void operator []=(int index, T value);`
  /// Sets the value at the given [index] in the list to [value]
  /// or throws a [RangeError] if [index] is out of bounds.
  ///
  IList<T> put(int index, T value) {
    // TODO: Still need to implement efficiently.
    var list = toList(growable: false);
    list[index] = value;
    return IList._unsafeFromList(list, config: config);
  }

  /// Finds the first occurrence of [from], and replace it with [to].
  IList<T> replaceFirst({@required T from, @required T to}) {
    var index = indexOf(from);
    return (index == -1) ? this : put(index, to);
  }

  /// Finds all occurrences of [from], and replace them with [to].
  IList<T> replaceAll({@required T from, @required T to}) =>
      map((element) => (element == from) ? to : element);

  /// Finds the first item that satisfies the provided [test],
  /// and replace it with [to]. If [addIfNotFound] is false,
  /// return the unchanged list if no item satisfies the [test].
  /// If [addIfNotFound] is true, add the item to the end of the list
  /// if no item satisfies the [test].
  IList<T> replaceFirstWhere(bool Function(T item) test, T to, {bool addIfNotFound = false}) {
    var index = indexWhere(test);
    return (index != -1)
        ? put(index, to)
        : addIfNotFound
            ? add(to)
            : this;
  }

  /// Finds all items that satisfy the provided [test],
  /// and replace it with [to].
  IList<T> replaceAllWhere(bool Function(T element) test, T to) =>
      map((element) => test(element) ? to : element);

  /// Iterates through each item. If the item satisfies the provided [test],
  /// replace it with applying [apply]. Otherwise, keep the item unchanged.
  /// If [test] is not provided, it will apply [apply] to all items.
  IList<T> process({
    bool Function(IList<T> list, int index, T item) test,
    @required Iterable<T> Function(IList<T> list, int index, T item) apply,
  }) {
    assert(apply != null);
    // ---

    List<T> result = [];
    int _length = length;
    for (int index = 0; index < _length; index++) {
      T item = this[index];
      var satisfiesTest = test == null ? true : test(this, index, item);
      if (satisfiesTest)
        result.add(item);
      else
        result.addAll(apply(this, index, item));
    }
    return IList._unsafeFromList(result, config: config);
  }

  /// Returns the first index in the list that satisfies the provided [test].
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `o` is encountered so that `test(o)` is true,
  /// the index of `o` is returned.
  ///
  /// ```dart
  /// final IList<String> notes = ['do', 're', 'mi', 're'].lock;
  /// notes.indexWhere((note) => note.startsWith('r'));       // 1
  /// notes.indexWhere((note) => note.startsWith('r'), 2);    // 3
  /// ```
  ///
  /// Returns -1 if [element] is not found.
  ///
  /// ```dart
  /// notes.indexWhere((note) => note.startsWith('k'));       // -1
  /// ```
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    start ??= 0;
    var _length = length;
    if (start < 0 || start >= _length)
      throw ArgumentError.value(start, "index", "Index out of range");
    for (int i = start; i <= _length - 1; i++) if (test(this[i])) return i;
    return -1;
  }

  /// Returns the last index of [element] in this list.
  ///
  /// Searches the list backwards from index [start] to 0.
  ///
  /// The first time an object [:o:] is encountered so that [:o == element:],
  /// the index of [:o:] is returned.
  ///
  /// ```dart
  /// final IList<String> notes = ['do', 're', 'mi', 're'].lock;
  /// notes.lastIndexOf('re', 2); // 1
  /// ```
  ///
  /// If [start] is not provided, this method searches from the end of the list.
  ///
  /// ```dart
  /// notes.lastIndexOf('re');    // 3
  /// ```
  ///
  /// Returns -1 if [element] is not found.
  ///
  /// ```dart
  /// notes.lastIndexOf('fa');    // -1
  /// ```
  int lastIndexOf(T element, [int start]) {
    var _length = length;
    start ??= _length;
    if (start < 0 || start >= _length)
      throw ArgumentError.value(start, "index", "Index out of range");
    for (int i = _length - 1; i >= start; i--) if (this[i] == element) return i;
    return -1;
  }

  /// Returns the last index in the list that satisfies the provided [test].
  ///
  /// Searches the list from index [start] to 0.
  /// The first time an object `o` is encountered so that `test(o)` is true,
  /// the index of `o` is returned.
  /// If [start] is omitted, it defaults to the [length] of the list.
  ///
  /// ```dart
  /// final IList<String> notes = ['do', 're', 'mi', 're'].lock;
  /// notes.lastIndexWhere((note) => note.startsWith('r'));       // 3
  /// notes.lastIndexWhere((note) => note.startsWith('r'), 2);    // 1
  /// ```
  ///
  /// Returns -1 if [element] is not found.
  ///
  /// ```dart
  /// notes.lastIndexWhere((note) => note.startsWith('k'));       // -1
  /// ```
  int lastIndexWhere(bool Function(T element) test, [int start]) {
    var _length = length;
    start ??= _length;
    if (start < 0 || start >= _length)
      throw ArgumentError.value(start, "index", "Index out of range");
    for (int i = _length - 1; i >= start; i--) if (test(this[i])) return i;
    return -1;
  }

  /// Removes the objects in the range [start] inclusive to [end] exclusive
  /// and inserts the contents of [replacement] in its place.
  ///
  /// ```dart
  /// final IList<int> iList = [1, 2, 3, 4, 5].lock;
  /// iList.replaceRange(1, 4, [6, 7]).join(', '); // '1, 6, 7, 5'
  /// ```
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` is this list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  ///
  /// This method does not work on fixed-length lists, even when [replacement]
  /// has the same number of elements as the replaced range. In that case use
  /// [setRange] instead.
  ///
  IList<T> replaceRange(int start, int end, Iterable<T> replacement) {
    // TODO: Still need to implement efficiently.
    return IList._unsafeFromList(toList(growable: true)..replaceRange(start, end, replacement),
        config: config);
  }

  /// Sets the objects in the range [start] inclusive to [end] exclusive
  /// to the given [fillValue].
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` is this list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  ///
  /// Example with [List]:
  ///
  /// ```dart
  /// final List<int> list = List(3);
  /// list.fillRange(0, 2, 1);
  /// print(list);  // [1, 1, null]
  /// ```
  ///
  /// Example with [IList]:
  ///
  /// ```dart
  /// final IList<int> iList = IList();
  /// iList.fillRange(0, 2, 1);
  /// print(iList); // [1, 1, null]
  /// ```
  ///
  /// If the element type is not nullable, omitting [fillValue] or passing `null`
  /// as [fillValue] will make the `fillRange` fail.
  ///
  IList<T> fillRange(int start, int end, [T fillValue]) {
    // TODO: Still need to implement efficiently.
    return IList._unsafeFromList(toList(growable: false)..fillRange(start, end, fillValue),
        config: config);
  }

  /// Returns an [Iterable] that iterates over the objects in the range
  /// [start] inclusive to [end] exclusive.
  ///
  /// The provided range, given by [start] and [end], must be valid at the time
  /// of the call.
  ///
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` is this list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  ///
  /// The returned [Iterable] behaves like `skip(start).take(end - start)`.
  /// That is, it does *not* throw if this list changes size.
  ///
  /// ```dart
  /// final IList<String> colors = ['red', 'green', 'blue', 'orange', 'pink'].lock;
  /// final Iterable<String> range = colors.getRange(1, 4);
  /// range.join(', ');  // 'green, blue, orange'
  /// colors.length = 3;
  /// range.join(', ');  // 'green, blue'
  /// ```
  Iterable<T> getRange(int start, int end) {
    // TODO: Still need to implement efficiently.
    return toList(growable: false).getRange(start, end);
  }

  /// Returns a new list containing the elements between [start] and [end].
  ///
  /// The new list is a `List<E>` containing the elements of this list at
  /// positions greater than or equal to [start] and less than [end] in the same
  /// order as they occur in this list.
  ///
  /// ```dart
  /// final IList<String> colors = ["red", "green", "blue", "orange", "pink"].lock;
  /// print(colors.sublist(1, 3)); // [green, blue]
  /// ```
  ///
  /// If [end] is omitted, it defaults to the [length] of this list.
  ///
  /// ```dart
  /// print(colors.sublist(1));    // [green, blue, orange, pink]
  /// ```
  ///
  /// The `start` and `end` positions must satisfy the relations
  /// 0 ≤ `start` ≤ `end` ≤ `this.length`
  /// If `end` is equal to `start`, then the returned list is empty.
  IList<T> sublist(int start, [int end]) {
    // TODO: Still need to implement efficiently.
    return IList._unsafeFromList(toList(growable: false).sublist(start, end), config: config);
  }

  /// Inserts the object at position [index] in this list.
  ///
  /// This increases the length of the list by one and shifts all objects
  /// at or after the index towards the end of the list.
  ///
  /// The list must be growable.
  /// The [index] value must be non-negative and no greater than [length].
  IList<T> insert(int index, T element) {
    // TODO: Still need to implement efficiently.
    return IList._unsafeFromList(toList(growable: true)..insert(index, element), config: config);
  }

  /// Inserts all objects of [iterable] at position [index] in this list.
  ///
  /// This increases the length of the list by the length of [iterable] and
  /// shifts all later objects towards the end of the list.
  ///
  /// The list must be growable.
  /// The [index] value must be non-negative and no greater than [length].
  IList<T> insertAll(int index, Iterable<T> iterable) {
    // TODO: Still need to implement efficiently.
    return IList._unsafeFromList(toList(growable: true)..insertAll(index, iterable),
        config: config);
  }

  /// Removes the object at position [index] from this list.
  ///
  /// This method reduces the length of `this` by one and moves all later objects
  /// down by one position.
  ///
  /// Returns the removed object.
  ///
  /// The [index] must be in the range `0 ≤ index < length`.
  ///
  /// If you want to recover the removed item, you can pass a mutable [removedItem].
  IList<T> removeAt(int index, [Item<T> removedItem]) {
    // TODO: Still need to implement efficiently.
    var list = toList(growable: true);
    var value = list.removeAt(index);
    removedItem?.set(value);
    return IList._unsafeFromList(list, config: config);
  }

  /// Pops and returns the last object in this list.
  ///
  /// The list must not be empty.
  ///
  /// If you want to recover the removed item, you can pass a mutable [removedItem].
  IList<T> removeLast([Item<T> removedItem]) {
    return removeAt(length - 1, removedItem);
  }

  /// Removes the objects in the range [start] inclusive to [end] exclusive.
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` is this list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  ///
  IList<T> removeRange(int start, int end) {
    // TODO: Still need to implement efficiently.
    var list = toList(growable: true);
    list.removeRange(start, end);
    return IList._unsafeFromList(list, config: config);
  }

  /// Removes all objects from this list that satisfy [test].
  ///
  /// An object [:o:] satisfies [test] if [:test(o):] is true.
  ///
  /// ```dart
  /// final IList<String> numbers = ['one', 'two', 'three', 'four'].lock;
  /// final IList<String> newNumbers = numbers.removeWhere((item) => item.length == 3);
  /// newNumbers.join(', '); // 'three, four'
  /// ```
  IList<T> removeWhere(bool Function(T element) test) {
    // TODO: Still need to implement efficiently.
    var list = toList(growable: true);
    list.removeWhere(test);
    return IList._unsafeFromList(list, config: config);
  }

  /// Removes all objects from this list that fail to satisfy [test].
  ///
  /// An object [:o:] satisfies [test] if [:test(o):] is true.
  ///
  /// ```dart
  /// final IList<String> numbers = ['one', 'two', 'three', 'four'].lock;
  /// final IList<String> newNumbers = numbers.retainWhere((item) => item.length == 3);
  /// newNumbers.join(', '); // 'one, two'
  /// ```
  IList<T> retainWhere(bool Function(T element) test) {
    // TODO: Still need to implement efficiently.
    var list = toList(growable: true);
    list.retainWhere(test);
    return IList._unsafeFromList(list, config: config);
  }

  /// Returns an [Iterable] of the objects in this list in reverse order.
  IList<T> get reversed {
    // TODO: Still need to implement efficiently.
    var list = UnmodifiableListView(this).reversed;
    return IList.withConfig(list, config);
  }

  /// Overwrites objects of `this` with the objects of [iterable], starting
  /// at position [index] in this list.
  ///
  /// ```dart
  /// final IList<String> iList = ['a', 'b', 'c'].lock;
  /// iList.setAll(1, ['bee', 'sea']).join(', '); // 'a, bee, sea'
  /// ```
  ///
  /// This operation does not increase the length of `this`.
  ///
  /// The [index] must be non-negative and no greater than [length].
  ///
  /// The [iterable] must not have more elements than what can fit from [index]
  /// to [length].
  ///
  /// If `iterable` is based on this list, its values may change /during/ the
  /// `setAll` operation.
  IList<T> setAll(int index, Iterable<T> iterable) {
    // TODO: Still need to implement efficiently.
    var list = toList(growable: true);
    list.setAll(index, iterable);
    return IList._unsafeFromList(list, config: config);
  }

  /// Copies the objects of [iterable], skipping [skipCount] objects first,
  /// into the range [start], inclusive, to [end], exclusive, of the list.
  ///
  /// ```dart
  /// final IList<int> iList1 = [1, 2, 3, 4].lock;
  /// final IList<int> iList2 = [5, 6, 7, 8, 9].lock;
  /// // Copies the 4th and 5th items in iList2 as the 2nd and 3rd items of iList1.
  /// iList1.setRange(1, 3, iList2, 3).join(', '); // '1, 8, 9, 4'
  /// ```
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` is this list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  ///
  /// The [iterable] must have enough objects to fill the range from `start`
  /// to `end` after skipping [skipCount] objects.
  ///
  /// If `iterable` is this list, the operation copies the elements
  /// originally in the range from `skipCount` to `skipCount + (end - start)` to
  /// the range `start` to `end`, even if the two ranges overlap.
  ///
  /// If `iterable` depends on this list in some other way, no guarantees are
  /// made.
  ///
  IList<T> setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    // TODO: Still need to implement efficiently.
    var list = toList(growable: true);
    list.setRange(start, end, iterable, skipCount);
    return IList._unsafeFromList(list, config: config);
  }

  /// Shuffles the elements of this list randomly.
  IList<T> shuffle([Random random]) =>
      IList._unsafeFromList(toList()..shuffle(random), config: config);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

@visibleForOverriding
abstract class L<T> implements Iterable<T> {
  //

  /// The [L] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  /// Note these fallback methods need to calculate the flushed list, but
  /// because that's immutable, we cache it.
  List<T> _flushed;

  /// Returns the flushed set (flushes it only once).
  /// It is an error to use the flushed map outside of the [M] class.
  List<T> get _getFlushed {
    _flushed ??= unlock;
    return _flushed;
  }

  /// Returns a regular Dart (mutable, growable) List.
  List<T> get unlock => List<T>.of(this, growable: true);

  @override
  Iterator<T> get iterator;

  L<T> add(T item) {
    return LAdd<T>(this, item);
  }

  L<T> addAll(Iterable<T> items) => LAddAll<T>(
        this,
        (items is IList<T>) ? items._l : items,
      );

  // TODO: Still need to implement efficiently.
  L<T> remove(T element) => !contains(element) ? this : LFlat<T>.unsafe(unlock..remove(element));

  L<T> removeAll(Iterable<T> elements) {
    var list = unlock;
    var originalLength = list.length;
    var set = HashSet.of(elements);
    list = unlock..removeWhere((e) => set.contains(e));
    if (list.length == originalLength) return this;
    return LFlat<T>.unsafe(list);
  }

  // TODO: Still need to implement efficiently.
  L<T> removeMany(T element) =>
      !contains(element) ? this : LFlat<T>.unsafe(unlock..removeWhere((e) => e == element));

  // TODO: Still need to implement efficiently.
  /// If the list has more than `maxLength` elements, removes the last elements so it remains
  /// with only `maxLength` elements. If the list has `maxLength` or less elements, doesn't
  /// change anything.
  L<T> maxLength(int maxLength) => maxLength < 0
      ? throw ArgumentError(maxLength)
      : length <= maxLength
          ? this
          : LFlat<T>.unsafe(unlock..length = maxLength);

  /// Sorts this list according to the order specified by the [compare] function.
  /// If [compare] is not provided, it will use the natural ordering of the type [T].
  L<T> sort([int Function(T a, T b) compare]) => LFlat<T>.unsafe(unlock..sort(compare));

  L<T> orderedSort([int Function(T a, T b) compare]) {
    return LFlat<T>.unsafe(unlock..sort(compare));
  }

  /// Sorts this list according to the order specified by the [ordering] iterable.
  /// Elements which don't appear in [ordering] will be included in the end, in no particular order.
  /// Note: This is not very efficient. Only use for a small number of elements.
  L<T> sortLike(Iterable<T> ordering) {
    assert(ordering != null);
    Set<T> orderingSet = Set.of(ordering);
    Set<T> newSet = Set.of(this);
    Set<T> intersection = orderingSet.intersection(newSet);
    Set<T> difference = newSet.difference(orderingSet);
    List<T> result = ordering.where((element) => intersection.contains(element)).toList();
    result.addAll(difference);
    return LFlat<T>.unsafe(result);
  }

  @override
  bool get isEmpty => _getFlushed.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  bool any(bool Function(T) test) => _getFlushed.any(test);

  @override
  Iterable<R> cast<R>() => _getFlushed.cast<R>();

  @override
  bool contains(Object element) => _getFlushed.contains(element);

  T operator [](int index) => _getFlushed[index];

  @override
  T elementAt(int index) => _getFlushed[index];

  @override
  bool every(bool Function(T) test) => _getFlushed.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => _getFlushed.expand(f);

  @override
  int get length => _getFlushed.length;

  @override
  T get first => _getFlushed.first;

  @override
  T get last => _getFlushed.last;

  @override
  T get single => _getFlushed.single;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      _getFlushed.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _getFlushed.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _getFlushed.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _getFlushed.forEach(f);

  @override
  String join([String separator = '']) => _getFlushed.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _getFlushed.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T element) f) => _getFlushed.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => _getFlushed.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _getFlushed.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _getFlushed.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _getFlushed.skipWhile(test);

  @override
  Iterable<T> take(int count) => _getFlushed.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _getFlushed.takeWhile(test);

  @override
  Iterable<T> where(bool Function(T element) test) => _getFlushed.where(test);

  @override
  Iterable<E> whereType<E>() => _getFlushed.whereType<E>();

  @override
  List<T> toList({bool growable = true}) => List.of(this, growable: growable);

  @override
  Set<T> toSet() => Set.of(this);

  /// Ordered set.
  LinkedHashSet<T> toLinkedHashSet() => LinkedHashSet.of(this);

  /// Unordered set.
  HashSet<T> toHashSet() => HashSet.of(this);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
