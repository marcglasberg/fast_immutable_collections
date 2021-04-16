import "dart:math";

import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "ilist.dart";

/// This mixin implements all [IList] methods (without `config` ([ConfigList])), plus
/// `operator []`, but it does **NOT** implement [Iterable] nor [IList].
///
/// It is meant to help you wrap an [IList] into another class (composition).
/// You must override the [iter] getter to return the inner [IList].
/// All other methods are efficiently implemented in terms of the [iter].
///
/// To use this mixin, your class must:
///
/// 1. Override the [iter] getter to return the inner [IList].
/// 1. Override the [newInstance] method to return a new instance of the class.
///
/// Example:
///
/// ```dart
/// class Students with FromIListMixin<Student, Students> {
///   final IList<Student> _students;
///
///   Students([Iterable<Student> students]) : _students = IList(students);
///
///   @override
///   Students newInstance(IList<Student> ilist) => Students(ilist);
///
///   @override
///   IList<Student> get iter => _students;
/// }
///
/// class Student implements Comparable<Student>{
///   final String name;
///
///   const Student(this.name);
///
///   int compareTo(Student other) => name.compareTo(other.name);
/// }
/// ```
///
/// Note: Why does this class NOT implement [Iterable]? Unfortunately, the
/// [expect] method in tests compares [Iterable]s by comparing its items. So if
/// you create a class that implements [Iterable] and then, when you want to use the
/// [expect] method, it will just compare its items, completely ignoring its
/// `operator ==`.
///
/// If you need to iterate over this class, you can use the [iter] getter:
///
/// ```dart
/// class MyClass with FromIListMixin<T, I> { ... }
///
/// MyClass obj = MyClass([1, 2, 3]);
///
/// for (int value in obj.iter) print(value);
/// ```
///
/// Please note: if you really want to make your class [Iterable],
/// you can simply add the `implements Iterable<T>` to its declaration.
/// For example:
///
/// ```dart
/// class MyClass with FromIListMixin<T, I> implements Iterable<T> { ... }
///
/// MyClass obj = MyClass([1, 2, 3]);
///
/// for (int value in obj) print(value);
/// ```
///
/// See also: [FromIterableIListMixin].
///
mixin FromIListMixin<T, I extends FromIListMixin<T, I>> implements CanBeEmpty {
  //

  /// Classes `with` [FromIListMixin] must override this.
  IList<T> get iter;

  /// Classes `with` [FromIListMixin] must override this.
  I newInstance(IList<T> ilist);

  Iterator<T> get iterator => iter.iterator;

  bool any(bool Function(T) test) => iter.any(test);

  Iterable<R> cast<R>() => iter.cast<R>();

  bool contains(covariant T element) => iter.contains(element);

  T? operator [](int index) => iter[index];

  T elementAt(int index) => iter[index];

  bool every(bool Function(T) test) => iter.every(test);

  Iterable<E> expand<E>(Iterable<E> Function(T) f) => iter.expand(f);

  int get length => iter.length;

  T get first => iter.first;

  T get last => iter.last;

  T get single => iter.single;

  T? get firstOrNull => iter.firstOrNull;

  T? get lastOrNull => iter.lastOrNull;

  T? get singleOrNull => iter.singleOrNull;

  T firstWhere(bool Function(T) test, {T Function()? orElse}) =>
      iter.firstWhere(test, orElse: orElse);

  T? firstWhereOrNull(bool Function(T) test) => iter.firstWhereOrNull(test);

  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iter.fold(initialValue, combine);

  Iterable<T> followedBy(Iterable<T> other) => iter.followedBy(other);

  void forEach(void Function(T element) f) => iter.forEach(f);

  String join([String separator = ""]) => iter.join(separator);

  T lastWhere(bool Function(T element) test, {T Function()? orElse}) =>
      iter.lastWhere(test, orElse: orElse);

  Iterable<E> map<E>(E Function(T element) f) => iter.map(f);

  T reduce(T Function(T value, T element) combine) => iter.reduce(combine);

  T singleWhere(bool Function(T element) test, {T Function()? orElse}) =>
      iter.singleWhere(test, orElse: orElse);

  Iterable<T> skip(int count) => iter.skip(count);

  Iterable<T> skipWhile(bool Function(T value) test) => iter.skipWhile(test);

  Iterable<T> take(int count) => iter.take(count);

  Iterable<T> takeWhile(bool Function(T value) test) => iter.takeWhile(test);

  Iterable<T> where(bool Function(T element) test) => iter.where(test);

  Iterable<E> whereType<E>() => iter.whereType<E>();

  @override
  bool get isEmpty => iter.isEmpty;

  @override
  bool get isNotEmpty => iter.isNotEmpty;

  List<T> toList({bool growable = true}) => List.of(iter, growable: growable);

  Set<T> toSet() => Set.of(iter);

  I operator +(Iterable<T> other) => newInstance(iter + other);

  I add(T item) => newInstance(iter.add(item));

  I addAll(Iterable<T> items) => newInstance(iter.addAll(items));

  IMap<int, T> asMap() => iter.asMap();

  I clear() => newInstance(iter.clear());

  bool equalItems(covariant Iterable<T> other) => iter.equalItems(other);

  bool unorderedEqualItems(covariant Iterable<T> other) => iter.unorderedEqualItems(other);

  bool same(I other) => iter.same(other.iter);

  I fillRange(int start, int end, [T? fillValue]) =>
      newInstance(iter.fillRange(start, end, fillValue));

  T? firstOr(T orElse) => iter.firstOr(orElse);

  Iterable<T> getRange(int start, int end) => iter.getRange(start, end);

  int indexOf(T element, [int start = 0]) => iter.indexOf(element, start);

  int indexWhere(bool Function(T element) test, [int start = 0]) => iter.indexWhere(test, start);

  I insert(int index, T element) => newInstance(iter.insert(index, element));

  I insertAll(int index, Iterable<T> iterable) => newInstance(iter.insertAll(index, iterable));

  int lastIndexOf(T element, [int? start]) => iter.lastIndexOf(element, start);

  int lastIndexWhere(bool Function(T element) test, [int? start]) =>
      iter.lastIndexWhere(test, start);

  T lastOr(T orElse) => iter.lastOr(orElse);

  I maxLength(int maxLength, {int Function(T a, T b)? priority}) =>
      newInstance(iter.maxLength(maxLength, priority: priority));

  I process(
          {bool Function(IList<T> list, int index, T item)? test,
          required Iterable<T> Function(IList<T> list, int index, T item) apply}) =>
      newInstance(iter.process(test: test, convert: apply));

  I put(int index, T value) => newInstance(iter.put(index, value));

  I remove(T item) => newInstance(iter.remove(item));

  I removeAt(int index, [Output<T>? removedItem]) => newInstance(iter.removeAt(index, removedItem));

  I removeLast([Output<T>? removedItem]) => newInstance(iter.removeLast(removedItem));

  I removeRange(int start, int end) => newInstance(iter.removeRange(start, end));

  I removeWhere(bool Function(T element) test) => newInstance(iter.removeWhere(test));

  I replaceAll({required T from, required T to}) =>
      newInstance(iter.replaceAll(from: from, to: to));

  I replaceAllWhere(bool Function(T element) test, T to) =>
      newInstance(iter.replaceAllWhere(test, to));

  I replaceFirst({required T from, required T to}) =>
      newInstance(iter.replaceFirst(from: from, to: to));

  I replaceFirstWhere(bool Function(T item) test, T to) =>
      newInstance(iter.replaceFirstWhere(test, to));

  I replaceRange(int start, int end, Iterable<T> replacement) =>
      newInstance(iter.replaceRange(start, end, replacement));

  I retainWhere(bool Function(T element) test) => newInstance(iter.retainWhere(test));

  I get reversed => newInstance(iter.reversed);

  I setAll(int index, Iterable<T> iterable) => newInstance(iter.setAll(index, iterable));

  I setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) =>
      newInstance(iter.setRange(start, end, iterable, skipCount));

  I shuffle([Random? random]) => newInstance(iter.shuffle(random));

  T singleOr(T orElse) => iter.singleOr(orElse);

  I sort([int Function(T a, T b)? compare]) => newInstance(iter.sort(compare));

  I sublist(int start, [int? end]) => newInstance(iter.sublist(start, end));

  I toggle(T element) => newInstance(iter.toggle(element));

  List<T> get unlock => iter.unlock;

  List<T> get unlockView => iter.unlockView;

  @override
  String toString() => "$runtimeType$iter";
}

extension FromIListMixinExtension on FromIListMixin? {
  /// Checks if [this] is `null` or empty.
  bool get isNullOrEmpty => (this == null) || this!.isEmpty;

  /// Checks if [this] is **not** `null` and **not** empty.
  bool get isNotNullNotEmpty => (this != null) && this!.isNotEmpty;

  /// Checks if [this] is empty but **not** `null`.
  bool get isEmptyNotNull => (this != null) && this!.isEmpty;
}
