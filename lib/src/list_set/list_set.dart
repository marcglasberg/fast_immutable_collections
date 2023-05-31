// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:collection";
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/iterator/iterator_flat.dart";

/// A [ListSet] is, at the same time:
/// 1) A mutable, fixed-sized, ordered, [Set].
/// 2) A mutable, fixed-sized, [List], in which values can't repeat.
///
/// When viewed as a [Set] and compared to a [LinkedHashSet], a [ListSet] is also ordered and has a
/// similar performance. But a [ListSet] takes less memory and can be sorted, just like a list.
/// Also, you can directly get its items by index. The disadvantage, of course, is that [ListSet]
/// has a fixed size, while a [LinkedHashSet] does not.
///
/// The [ListSet] is efficient both as a [List] and as a [Set]. So, for example, it has an
/// efficient [sort] method, while a [LinkedHashSet] would force you to turn it into a [List],
/// then sort it, than turn it back into a [Set].
///
class ListSet<T> implements Set<T>, List<T> {
  late Set<T> _set;
  late List<T> _list;

  ListSet.empty() {
    _set = HashSet();
    _list = List.empty(growable: false);
  }

  /// Create a [ListSet] from the [items] iterable.
  ///
  /// If [sort] is true, it will be sorted with [compare], if provided,
  /// or with [compareObject] if not provided. If [sort] is false,
  /// [compare] will be ignored.
  ///
  ListSet.of(
    Iterable<T> items, {
    bool sort = false,
    int Function(T a, T b)? compare,
  }) : assert(compare == null || sort == true) {
    _set = HashSet();
    _list = List.of(items.where((item) => _set.add(item)), growable: false);
    if (sort) _list.sort(compare ?? compareObject);
  }

  ListSet._(this._set, this._list) : assert(_set.length == _list.length);

  /// Converts from JSon. Json serialization support for json_serializable with @JsonSerializable.
  factory ListSet.fromJson(dynamic json, T Function(Object?) fromJsonT) =>
      ListSet<T>.of((json as Iterable).map(fromJsonT));

  /// Converts to JSon. Json serialization support for json_serializable with @JsonSerializable.
  Object toJson(Object? Function(T) toJsonT) => map(toJsonT).toList();

  @override
  bool add(T value) {
    throw UnsupportedError("Can't add to a ListSet.");
  }

  @override
  void addAll(Iterable<T> elements) {
    throw UnsupportedError("Can't add to a ListSet.");
  }

  @override
  bool any(Predicate<T> test) => _list.any(test);

  @override
  ListSet<E> cast<E>() => ListSet<E>._(_set.cast<E>(), _list.cast<E>());

  @override
  void clear() {
    throw UnsupportedError("Can't clear a ListSet.");
  }

  @override
  bool contains(covariant T? value) => _set.contains(value);

  @override
  bool containsAll(covariant Iterable<T?> other) => _set.containsAll(other);

  @override
  Set<T> difference(covariant Set<T?> other) => _set.difference(other);

  @override
  Set<T> intersection(covariant Set<T?> other) => _set.intersection(other);

  @override
  Set<T> union(covariant Set<T> other) => _set.union(other);

  @override
  T elementAt(int index) => _list[index];

  @override
  bool every(Predicate<T> test) => _list.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T element) f) => _list.expand(f);

  @override
  T get first => _list.first;

  @override
  T get last => _list.last;

  @override
  T firstWhere(Predicate<T> test, {T Function()? orElse}) => _list.firstWhere(test, orElse: orElse);

  @override
  T lastWhere(Predicate<T> test, {T Function()? orElse}) => _list.lastWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _list.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _list.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _list.forEach(f);

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator<T> get iterator => IteratorFlat(_list.iterator);

  @override
  String join([String separator = ""]) => _list.join(separator);

  @override
  int get length => _list.length;

  @override
  T? lookup(Object? object) => _set.lookup(object);

  @override
  Iterable<E> map<E>(E Function(T e) f) => _list.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => _list.reduce(combine);

  @override
  bool remove(Object? value) {
    throw UnsupportedError("Can't remove from a ListSet.");
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    throw UnsupportedError("Can't removeAll from a ListSet.");
  }

  @override
  void removeWhere(Predicate<T> test) {
    throw UnsupportedError("Can't removeWhere from a ListSet.");
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    throw UnsupportedError("Can't retainAll from a ListSet.");
  }

  @override
  void retainWhere(Predicate<T> test) {
    throw UnsupportedError("Can't retainWhere from a ListSet.");
  }

  @override
  T get single => _list.single;

  @override
  T singleWhere(Predicate<T> test, {T Function()? orElse}) =>
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
  Iterable<T> where(Predicate<T> test) => _list.where(test);

  @override
  Iterable<E> whereType<E>() => _list.whereType();

  @override
  ListSet<T> operator +(List<T> other) => ListSet.of(_list.followedBy(other));

  @override
  T operator [](int index) => _list[index];

  @override
  void operator []=(int index, T value) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  Map<int, T> asMap() => _list.asMap();

  @override
  void fillRange(int start, int end, [T? fillValue]) {
    throw UnsupportedError("Can't fillRange from a ListSet.");
  }

  @override
  set first(T value) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  Iterable<T> getRange(int start, int end) => _list.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => _list.indexOf(element, start);

  @override
  int indexWhere(Predicate<T> test, [int start = 0]) => _list.indexWhere(test, start);

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
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  int lastIndexOf(T element, [int? start]) => _list.lastIndexOf(element, start);

  @override
  int lastIndexWhere(Predicate<T> test, [int? start]) => _list.lastIndexWhere(test, start);

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
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  Iterable<T> get reversed => _list.reversed;

  ListSet<T> get reversedView => ListSet._(_set, ReversedListView(_list));

  @override
  void setAll(int index, Iterable<T> iterable) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void shuffle([Random? random]) {
    _list.shuffle(random);
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    _list.sort(compare);
  }

  @override
  List<T> sublist(int start, [int? end]) => _list.sublist(start, end);

  /// Creates a [ListSet] form the given [set].
  /// If the [set] is already of type [ListSet], return the same instance.
  /// This is unsafe because a [ListSetView] is fixed size, but the given [set] may not.
  static ListSet<T> unsafeView<T>(Set<T> set) => (set is ListSet<T>) ? set : ListSetView<T>(set);
}
