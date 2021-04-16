import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "ilist.dart";

/// This mixin implements all [Iterable] methods, plus `operator []`,
/// but it does **NOT** implement [Iterable] nor [IList].
///
/// It is meant to help you wrap an [IList] into another class (composition).
/// You must override the [iter] getter to return the inner [IList].
/// All other methods are efficiently implemented in terms of the [iter].
///
/// Note: This class does **NOT** implement [Iterable]. Unfortunately, the [expect]
/// method in tests compares [Iterable]s by comparing its items. So if you
/// create a class that implements [Iterable] and then, when you want to use the
/// [expect] method, it will just compare its items, completing ignoring its
/// `operator ==`.
///
/// If you need to iterate over this class, you can use the [iter] getter:
///
/// ```dart
/// class MyClass with IterableLikeIListMixin<T> { ... }
///
/// MyClass obj = MyClass([1, 2, 3]);
///
/// for (int value in obj.iter) print(value);
/// ```
///
/// Please note, if you really want to make your class [Iterable], you can
/// just add the `implements Iterable<T>` to its declaration. For example:
///
/// ```dart
/// class MyClass with IterableLikeIListMixin<T> implements Iterable<T> { ... }
///
/// MyClass obj = MyClass([1, 2, 3]);
///
/// for (int value in obj) print(value);
/// ```
///
/// See also: [FromIListMixin].
mixin FromIterableIListMixin<T> implements CanBeEmpty {
  //
  /// Classes `with` [FromIterableIListMixin] must override this.
  IList<T> get iter;

  Iterator<T> get iterator => iter.iterator;

  bool any(bool Function(T) test) => iter.any(test);

  Iterable<R> cast<R>() => throw UnsupportedError("cast");

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

  @override
  String toString() => "$runtimeType$iter";
}

extension FromIterableIListMixinExtension on FromIterableIListMixin? {
  /// Checks if [this] is `null` or empty.
  bool get isNullOrEmpty => (this == null) || this!.isEmpty;

  /// Checks if [this] is **not** `null` and **not** empty.
  bool get isNotNullNotEmpty => (this != null) && this!.isNotEmpty;

  /// Checks if [this] is empty but **not** `null`.
  bool get isEmptyNotNull => (this != null) && this!.isEmpty;
}
