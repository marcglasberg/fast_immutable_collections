// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:math";

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

/// Returns a [List] of the objects in this list in reverse order.
/// Very efficient since it returns a view, which means if you change the
/// original list this one will also change, and vice-versa.
///
/// Note: `List.reversed` returns an [Iterable], while this is a [List].
///
class ReversedListView<T> implements List<T> {
  //
  final List<T> list;

  ReversedListView(this.list);

  @override
  T get first => list.last;

  @override
  T get last => list.first;

  @override
  int get length => list.length;

  @override
  set length(int value) {
    final newList = list.sublist(value - 1, length);
    list
      ..clear()
      ..addAll(newList);
  }

  @override
  set first(T value) => this[0] = value;

  @override
  set last(T value) => list[0] = value;

  @override
  int indexWhere(Predicate<T> test, [int start = 0]) {
    final index = list.lastIndexWhere(test, start == 0 ? null : start);
    return (index == -1) ? -1 : list.length - index - 1;
  }

  @override
  int lastIndexWhere(Predicate<T> test, [int? start]) {
    final index = list.indexWhere(test, start ?? 0);
    return (index == -1) ? -1 : list.length - index - 1;
  }

  @override
  List<T> operator +(List<T> other) => [...list.reversed, ...other];

  @override
  T operator [](int index) => list[list.length - index - 1];

  @override
  void operator []=(int index, T value) => list[list.length - index - 1] = value;

  @override
  void add(T value) => list.insert(0, value);

  @override
  void addAll(Iterable<T> iterable) => list.insertAll(0, iterable.toList().reversed);

  @override
  bool any(Predicate<T> test) => list.reversed.any(test);

  @override
  Map<int, T> asMap() => list.reversed.toList().asMap();

  @override
  List<R> cast<R>() => ReversedListView(list.cast<R>());

  @override
  void clear() => list.clear();

  @override
  bool contains(covariant T? element) => list.contains(element);

  @override
  T elementAt(int index) => this[index];

  @override
  bool every(Predicate<T> test) => list.reversed.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T element) f) => list.reversed.expand(f);

  @override
  void fillRange(int start, int end, [T? fillValue]) =>
      list.fillRange(length - end, length - start, fillValue);

  @override
  T firstWhere(Predicate<T> test, {T Function()? orElse}) =>
      list.reversed.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      list.reversed.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => list.reversed.followedBy(other);

  @override
  void forEach(void Function(T element) f) => list.reversed.forEach(f);

  @override
  Iterable<T> getRange(int start, int end) sync* {
    RangeError.checkValidRange(start, end, length);
    for (int i = end - 1; i >= start; i--) yield list[i];
  }

  @override
  int indexOf(T element, [int start = 0]) {
    final pos = list.lastIndexOf(element, length - start - 1);
    return (pos == -1) ? -1 : length - pos - 1;
  }

  @override
  int lastIndexOf(T element, [int? start]) {
    start ??= length - 1;
    final pos = list.indexOf(element, length - start - 1);
    return (pos == -1) ? -1 : length - pos - 1;
  }

  @override
  void insert(int index, T element) => list.insert(length - index, element);

  @override
  void insertAll(int index, Iterable<T> iterable) =>
      list.insertAll(length - index, iterable.toList().reversed);

  @override
  bool get isEmpty => list.isEmpty;

  @override
  bool get isNotEmpty => list.isNotEmpty;

  @override
  Iterator<T> get iterator => list.reversed.iterator;

  @override
  String join([String separator = ""]) => list.reversed.join(separator);

  @override
  T lastWhere(Predicate<T> test, {T Function()? orElse}) =>
      list.reversed.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T e) f) => list.reversed.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => list.reversed.reduce(combine);

  @override
  bool remove(Object? value) => list.remove(value);

  @override
  T removeAt(int index) => list.removeAt(list.length - 1 - index);

  @override
  T removeLast() => list.removeAt(0);

  @override
  void removeRange(int start, int end) => list.removeRange(length - end, length - start);

  @override
  void removeWhere(Predicate<T> test) => list.removeWhere(test);

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) =>
      list.replaceRange(length - end, length - start, replacement.toList().reversed);

  @override
  void retainWhere(Predicate<T> test) => list.retainWhere(test);

  @override
  Iterable<T> get reversed => list;

  @override
  void setAll(int index, Iterable<T> iterable) =>
      list.setAll(length - index - 2, iterable.toList().reversed);

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) => list.setRange(
      length - end, length - start, iterable.skip(skipCount).take(end - start).toList().reversed);

  @override
  void shuffle([Random? random]) => list.shuffle(random);

  @override
  T get single => list.single;

  @override
  T singleWhere(Predicate<T> test, {T Function()? orElse}) =>
      list.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => list.reversed.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => list.reversed.skipWhile(test);

  @override
  void sort([int Function(T a, T b)? compare]) {
    if (compare == null) {
      list.sort();
      for (var i = 0; i < list.length / 2; i++) {
        final temp = list[i];
        list[i] = list[list.length - 1 - i];
        list[list.length - 1 - i] = temp;
      }
    } else
      list.sort((T a, T b) => -compare(a, b));
  }

  @override
  List<T> sublist(int start, [int? end]) => list.reversed.toList().sublist(start, end);

  @override
  Iterable<T> take(int count) => list.reversed.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => list.reversed.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => list.reversed.toList(growable: growable);

  @override
  Set<T> toSet() => list.reversed.toSet();

  @override
  Iterable<T> where(Predicate<T> test) => list.reversed.where(test);

  @override
  Iterable<E> whereType<E>() => list.reversed.whereType<E>();
}
