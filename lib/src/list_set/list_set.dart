import "dart:collection";
import "dart:math";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// A [ListSet] is, at the same time:
/// 1) A mutable, fixed-sized, ordered, [Set].
/// 2) A mutable, fixed-sized, [List], in which values can't repeat.
///
/// When view as a [Set] and compared to a [LinkedHashSet], a [ListSet] is also ordered and has a
/// similar performance. But a [ListSet] takes less memory and can be sorted, just like a list.
/// Also, you can directly get its items by index. The disadvantage, of course, is that [ListSet]
/// has a fixed size, while a [LinkedHashSet] does not.
///
class ListSet<T> implements Set<T>, List<T> {
  HashSet<T> _set;
  List<T> _list;

  ListSet.empty() {
    _set = HashSet();
    _list = List(0);
  }

  /// Create a [ListSet] from the [items] iterable.
  /// If [sort] is true, it will sort the items. Otherwise, it will keep the [items] order.
  /// If [compare] is provided, it will use it to sort the items.
  ///
  ListSet.of(Iterable<T> items, {bool sort = false, int Function(T a, T b) compare}) {
    _set = HashSet();
    _list = List.of(items.where((item) => _set.add(item)), growable: false);
    if (sort) _list.sort(compare);
  }

  ListSet._(this._set, this._list)
      : assert(_set != null),
        assert(_list != null),
        assert(_set.length == _list.length);

  @override
  bool add(T value) {
    throw UnsupportedError("Can't add to a ListSet.");
  }

  @override
  void addAll(Iterable<T> elements) {
    throw UnsupportedError("Can't add to a ListSet.");
  }

  @override
  bool any(bool Function(T element) test) => _list.any(test);

  @override
  ListSet<E> cast<E>() {
    throw UnsupportedError("Can't cast a ListSet.");
  }

  @override
  void clear() {
    throw UnsupportedError("Can't clear a ListSet.");
  }

  @override
  bool contains(covariant T value) => _set.contains(value);

  @override
  bool containsAll(covariant Iterable<T> other) => _set.containsAll(other);

  @override
  Set<T> difference(Set<Object> other) => _set.difference(other);

  @override
  T elementAt(int index) => _list.elementAt(index);

  @override
  bool every(bool Function(T element) test) => _list.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T element) f) => _list.expand(f);

  @override
  T get first => _list.first;

  @override
  T get last => _list.last;

  @override
  T firstWhere(bool Function(T element) test, {T Function() orElse}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _list.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _list.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _list.forEach(f);

  @override
  Set<T> intersection(Set<Object> other) => _set.intersection(other);

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator<T> get iterator => _list.iterator;

  @override
  String join([String separator = ""]) => _list.join(separator);

  @override
  int get length => _list.length;

  @override
  T lookup(Object object) => _set.lookup(object);

  @override
  Iterable<E> map<E>(E Function(T e) f) => _list.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => _list.reduce(combine);

  @override
  bool remove(Object value) {
    throw UnsupportedError("Can't remove from a ListSet.");
  }

  @override
  void removeAll(Iterable<Object> elements) {
    throw UnsupportedError("Can't removeAll from a ListSet.");
  }

  @override
  void removeWhere(bool Function(T element) test) {
    throw UnsupportedError("Can't removeWhere from a ListSet.");
  }

  @override
  void retainAll(Iterable<Object> elements) {
    throw UnsupportedError("Can't retainAll from a ListSet.");
  }

  @override
  void retainWhere(bool Function(T element) test) {
    throw UnsupportedError("Can't retainWhere from a ListSet.");
  }

  @override
  T get single => _list.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _list.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _list.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _list.skipWhile(test);

  @override
  Iterable<T> take(int count) => _list.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _list.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<T> toSet() => _list.toSet();

  @override
  Set<T> union(Set<T> other) => _set.union(other);

  @override
  Iterable<T> where(bool Function(T element) test) => _list.where(test);

  @override
  Iterable<E> whereType<E>() => _list.whereType();

  @override
  ListSet<T> operator +(List<T> other) => ListSet.of(_list.followedBy(other));

  @override
  T operator [](int index) => _list[index];

  @override
  void operator []=(int index, T value) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  Map<int, T> asMap() => _list.asMap();

  @override
  void fillRange(int start, int end, [T fillValue]) {
    throw UnsupportedError("Can't fillRange from a ListSet.");
  }

  @override
  set first(T value) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  Iterable<T> getRange(int start, int end) => _list.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => _list.indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) => _list.indexWhere(test, start);

  @override
  void insert(int index, T element) {
    throw UnsupportedError("Can't insert in a ListSet.");
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    throw UnsupportedError("Can't insertAll in a ListSet.");
  }

  @override
  set last(T value) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  int lastIndexOf(T element, [int start]) => _list.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int start]) =>
      _list.lastIndexWhere(test, start);

  @override
  set length(int newLength) {
    throw UnsupportedError("Can't set the length of a ListSet.");
  }

  @override
  T removeAt(int index) {
    throw UnsupportedError("Can't removeAt from a ListSet.");
  }

  @override
  T removeLast() {
    throw UnsupportedError("Can't removeLast from a ListSet.");
  }

  @override
  void removeRange(int start, int end) {
    throw UnsupportedError("Can't removeRange from a ListSet.");
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  Iterable<T> get reversed => _list.reversed;

  ListSet<T> get reversedView => ListSet._(_set, ReversedListView(_list));

  @override
  void setAll(int index, Iterable<T> iterable) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void shuffle([Random random]) {
    _list.shuffle(random);
  }

  @override
  void sort([int Function(T a, T b) compare]) {
    _list.sort(compare);
  }

  @override
  List<T> sublist(int start, [int end]) => _list.sublist(start, end);
}
