// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

class ListSetView<T> implements ListSet<T> {
  final Set<T> _set;

  ListSetView(this._set);

  /// Converts from JSon. Json serialization support for json_serializable with @JsonSerializable.
  factory ListSetView.fromJson(dynamic json, T Function(Object?) fromJsonT) =>
      ListSetView<T>((json as Iterable).map(fromJsonT).toSet());

  /// Converts to JSon. Json serialization support for json_serializable with @JsonSerializable.
  @override
  Object toJson(Object? Function(T) toJsonT) => map(toJsonT).toList();

  @override
  bool add(T value) {
    throw UnsupportedError("Can't add to a ListSetView.");
  }

  @override
  void addAll(Iterable<T> elements) {
    throw UnsupportedError("Can't add to a ListSetView.");
  }

  @override
  bool any(Predicate<T> test) => _set.any(test);

  /// Returns a list-set of [R] instances.
  /// If this list-set contains instances which cannot be cast to [R],
  /// it will throw an error.
  @override
  ListSetView<R> cast<R>() => ListSetView<R>(_set.cast<R>());

  @override
  void clear() {
    throw UnsupportedError("Can't clear a ListSetView.");
  }

  @override
  bool contains(covariant T? value) => _set.contains(value);

  @override
  bool containsAll(covariant Iterable<T?> other) => _set.containsAll(other);

  @override
  Set<T> difference(Set<Object?> other) => _set.difference(other);

  @override
  T elementAt(int index) => _set.elementAt(index);

  @override
  bool every(Predicate<T> test) => _set.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T element) f) => _set.expand(f);

  @override
  T get first => _set.first;

  @override
  T get last => _set.last;

  @override
  T firstWhere(Predicate<T> test, {T Function()? orElse}) => _set.firstWhere(test, orElse: orElse);

  @override
  T lastWhere(Predicate<T> test, {T Function()? orElse}) => _set.lastWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _set.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _set.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _set.forEach(f);

  @override
  Set<T> intersection(Set<Object?> other) => _set.intersection(other);

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
  T? lookup(Object? object) => _set.lookup(object);

  @override
  Iterable<E> map<E>(E Function(T e) f) => _set.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => _set.reduce(combine);

  @override
  bool remove(Object? value) {
    throw UnsupportedError("Can't remove from a ListSetView.");
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    throw UnsupportedError("Can't removeAll from a ListSetView.");
  }

  @override
  void removeWhere(Predicate<T> test) {
    throw UnsupportedError("Can't removeWhere from a ListSetView.");
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    throw UnsupportedError("Can't retainAll from a ListSetView.");
  }

  @override
  void retainWhere(Predicate<T> test) {
    throw UnsupportedError("Can't retainWhere from a ListSetView.");
  }

  @override
  T get single => _set.single;

  @override
  T singleWhere(Predicate<T> test, {T Function()? orElse}) =>
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
  Iterable<T> where(Predicate<T> test) => _set.where(test);

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
  void fillRange(int start, int end, [T? fillValue]) {
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
  int indexWhere(Predicate<T> test, [int start = 0]) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void insert(int index, T element) {
    throw UnsupportedError("Can't insert in a ListSet.");
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    throw UnsupportedError("Can't insertAll in a ListSetView.");
  }

  @override
  set last(T value) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  int lastIndexOf(T element, [int? start]) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  int lastIndexWhere(Predicate<T> test, [int? start]) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  set length(int newLength) {
    throw UnsupportedError("Can't set the length of a ListSetView.");
  }

  @override
  T removeAt(int index) {
    throw UnsupportedError("Can't removeAt from a ListSetView.");
  }

  @override
  T removeLast() {
    throw UnsupportedError("Can't removeLast from a ListSetView.");
  }

  @override
  void removeRange(int start, int end) {
    throw UnsupportedError("Can't removeRange from a ListSetView.");
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  Iterable<T> get reversed {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  ListSet<T> get reversedView {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

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
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  List<T> sublist(int start, [int? end]) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }
}
