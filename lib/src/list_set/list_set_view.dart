import "dart:math";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

// ////////////////////////////////////////////////////////////////////////////

class ListSetView<T> implements ListSet<T> {
  final Set<T> _set;

  ListSetView(this._set);

  @override
  bool add(T value) {
    throw UnsupportedError("Can't add to a ListSet.");
  }

  @override
  void addAll(Iterable<T> elements) {
    throw UnsupportedError("Can't add to a ListSet.");
  }

  @override
  bool any(bool Function(T element) test) => _set.any(test);

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
  T elementAt(int index) => _set.elementAt(index);

  @override
  bool every(bool Function(T element) test) => _set.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T element) f) => _set.expand(f);

  @override
  T get first => _set.first;

  @override
  T get last => _set.last;

  @override
  T firstWhere(bool Function(T element) test, {T Function() orElse}) =>
      _set.firstWhere(test, orElse: orElse);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _set.lastWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _set.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _set.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _set.forEach(f);

  @override
  Set<T> intersection(Set<Object> other) => _set.intersection(other);

  @override
  bool get isEmpty => _set.isEmpty;

  @override
  bool get isNotEmpty => _set.isNotEmpty;

  @override
  Iterator<T> get iterator => _set.iterator;

  @override
  String join([String separator = ""]) => _set.join(separator);

  @override
  int get length => _set.length;

  @override
  T lookup(Object object) => _set.lookup(object);

  @override
  Iterable<E> map<E>(E Function(T e) f) => _set.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => _set.reduce(combine);

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
  T get single => _set.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _set.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _set.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _set.skipWhile(test);

  @override
  Iterable<T> take(int count) => _set.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _set.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _set.toList(growable: growable);

  @override
  Set<T> toSet() => _set.toSet();

  @override
  Set<T> union(Set<T> other) => _set.union(other);

  @override
  Iterable<T> where(bool Function(T element) test) => _set.where(test);

  @override
  Iterable<E> whereType<E>() => _set.whereType();

  @override
  ListSet<T> operator +(List<T> other) => ListSet.of(_set.followedBy(other));

  @override
  T operator [](int index) => _set.elementAt(index);

  @override
  void operator []=(int index, T value) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  Map<int, T> asMap() => _set.toList(growable: false).asMap();

  @override
  void fillRange(int start, int end, [T fillValue]) {
    throw UnsupportedError("Can't fillRange from a ListSet.");
  }

  @override
  set first(T value) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  Iterable<T> getRange(int start, int end) => _set.toList(growable: false).getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => _set.toList(growable: false).indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

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
  int lastIndexOf(T element, [int start]) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int start]) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

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
  Iterable<T> get reversed {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  ListSet<T> get reversedView {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

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
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void sort([int Function(T a, T b) compare]) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  List<T> sublist(int start, [int end]) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }
}

// ////////////////////////////////////////////////////////////////////////////
