import 'dart:math';

import '../imap/imap.dart';
import '../utils/immutable_collection.dart';
import 'ilist.dart';

/// This mixin implements all [IList] members.
/// It is meant to help you wrap an [IList] into another class (composition).
/// Note classes which use this mixin are not themselves ILists, but [Iterables].
///
/// To use this mixin, your class must:
/// 1) Override the [iList] getter to return the inner [IList].
/// 2) Override the [newInstance] method to return a new instance of the class.
///
/// All other methods are efficiently implemented in terms of the [iList] and you don't need
/// to worry about them.
///
/// Example:
///
/// ```dart
/// class Students with IListMixin<Student, Students> {
///   final IList<Student> _students;
///
///   Students([Iterable<Student> students]) : _students = IList(students);
///
///   @override
///   Students newInstance(IList<Student> iList) => Students(iList);
///
///   @override
///   IList<Student> get iList => _students;
/// }
/// ```
///
/// See also: [IterableIListMixin].
///
mixin IListMixin<T, I extends IListMixin<T, I>> implements Iterable<T>, CanBeEmpty {
  //

  // Classes with `IListMixin` must override this.
  IList<T> get iList;

  // Classes with `IListMixin` must override this.
  I newInstance(IList<T> iList);

  @override
  bool any(bool Function(T) test) => iList.any(test);

  @override
  IList<R> cast<R>() => iList.cast<R>();

  @override
  bool contains(Object element) => iList.contains(element);

  T operator [](int index) => iList[index];

  @override
  T elementAt(int index) => iList[index];

  @override
  bool every(bool Function(T) test) => iList.every(test);

  @override
  IList<E> expand<E>(Iterable<E> Function(T) f) => iList.expand(f);

  @override
  int get length => iList.length;

  @override
  T get first => iList.first;

  @override
  T get last => iList.last;

  @override
  T get single => iList.single;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      iList.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iList.fold(initialValue, combine);

  @override
  IList<T> followedBy(Iterable<T> other) => iList.followedBy(other);

  @override
  void forEach(void Function(T element) f) => iList.forEach(f);

  @override
  String join([String separator = '']) => iList.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      iList.lastWhere(test, orElse: orElse);

  @override
  IList<E> map<E>(E Function(T element) f) => iList.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => iList.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      iList.singleWhere(test, orElse: orElse);

  @override
  IList<T> skip(int count) => iList.skip(count);

  @override
  IList<T> skipWhile(bool Function(T value) test) => iList.skipWhile(test);

  @override
  IList<T> take(int count) => iList.take(count);

  @override
  IList<T> takeWhile(bool Function(T value) test) => iList.takeWhile(test);

  @override
  IList<T> where(bool Function(T element) test) => iList.where(test);

  @override
  IList<E> whereType<E>() => iList.whereType<E>();

  @override
  bool get isEmpty => iList.isEmpty;

  @override
  bool get isNotEmpty => iList.isNotEmpty;

  @override
  Iterator<T> get iterator => iList.iterator;

  @override
  List<T> toList({bool growable = true}) => List.of(this, growable: growable);

  @override
  Set<T> toSet() => Set.of(this);

  I operator +(Iterable<T> other) => newInstance(iList + other);

  I add(T item) => newInstance(iList.add(item));

  I addAll(Iterable<T> items) => newInstance(iList.addAll(items));

  IMap<int, T> asMap() => iList.asMap();

  void clear() => newInstance(iList.clear());

  bool equalItems(covariant Iterable<T> other) => iList.equalItems(other);

  I fillRange(int start, int end, [T fillValue]) =>
      newInstance(iList.fillRange(start, end, fillValue));

  T firstOr(T orElse) => iList.firstOr(orElse);

  T get firstOrNull => iList.firstOrNull;

  Iterable<T> getRange(int start, int end) => iList.getRange(start, end);

  int indexOf(T element, [int start = 0]) => iList.indexOf(element, start);

  int indexWhere(bool Function(T element) test, [int start = 0]) => iList.indexWhere(test, start);

  I insert(int index, T element) => newInstance(iList.insert(index, element));

  I insertAll(int index, Iterable<T> iterable) => newInstance(iList.insertAll(index, iterable));

  int lastIndexOf(T element, [int start]) => iList.lastIndexOf(element, start);

  int lastIndexWhere(bool Function(T element) test, [int start]) =>
      iList.lastIndexWhere(test, start);

  T lastOr(T orElse) => iList.lastOr(orElse);

  T get lastOrNull => iList.lastOrNull;

  I maxLength(int maxLength) => newInstance(iList.maxLength(maxLength));

  I process(
          {bool Function(IList<T> list, int index, T item) test,
          Iterable<T> Function(IList<T> list, int index, T item) apply}) =>
      newInstance(iList.process(test: test, apply: apply));

  I put(int index, T value) => newInstance(iList.put(index, value));

  I remove(T item) => newInstance(iList.remove(item));

  I removeAt(int index, [Item<T> removedItem]) => newInstance(iList.removeAt(index, removedItem));

  I removeLast([Item<T> removedItem]) => newInstance(iList.removeLast(removedItem));

  I removeRange(int start, int end) => newInstance(iList.removeRange(start, end));

  I removeWhere(bool Function(T element) test) => newInstance(iList.removeWhere(test));

  I replaceAll({T from, T to}) => newInstance(iList.replaceAll(from: from, to: to));

  I replaceAllWhere(bool Function(T element) test, T to) =>
      newInstance(iList.replaceAllWhere(test, to));

  I replaceFirst({T from, T to}) => newInstance(iList.replaceFirst(from: from, to: to));

  I replaceFirstWhere(bool Function(T item) test, T to) =>
      newInstance(iList.replaceFirstWhere(test, to));

  I replaceRange(int start, int end, Iterable<T> replacement) =>
      newInstance(iList.replaceRange(start, end, replacement));

  I retainWhere(bool Function(T element) test) => newInstance(iList.retainWhere(test));

  I get reversed => newInstance(iList.reversed);

  I setAll(int index, Iterable<T> iterable) => newInstance(iList.setAll(index, iterable));

  I setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) =>
      newInstance(iList.setRange(start, end, iterable, skipCount));

  I shuffle([Random random]) => newInstance(iList.shuffle(random));

  T singleOr(T orElse) => iList.singleOr(orElse);

  T get singleOrNull => iList.singleOrNull;

  I sort([int Function(T a, T b) compare]) => newInstance(iList.sort(compare));

  I sublist(int start, [int end]) => newInstance(iList.sublist(start, end));

  I toggle(T element) => newInstance(iList.toggle(element));

  List<T> get unlock => iList.unlock;

  List<T> get unlockView => iList.unlockView;

  bool unorderedEqualItems(covariant Iterable<T> other) => iList.unorderedEqualItems(other);

  bool same(I other) => iList.same(other.iList);
}
