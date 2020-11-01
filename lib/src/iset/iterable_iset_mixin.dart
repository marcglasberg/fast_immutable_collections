import "../utils/immutable_collection.dart";
import "iset.dart";

/// This mixin implements all [Iterable] members.
/// It is meant to help you wrap an [ISet] into another iterable class (composition).
/// You must override the [iSet] getter to return the inner [ISet].
/// All other methods are efficiently implemented in terms of the [iSet].
/// Note: Classes which use this mixin are not themselves ISets.
///
/// See also: [ISetMixin].
///
mixin IterableISetMixin<T> implements Iterable<T>, CanBeEmpty {
  ISet<T> get iSet;

  @override
  bool any(bool Function(T) test) => iSet.any(test);

  @override
  Iterable<R> cast<R>() => throw UnsupportedError("cast");

  @override
  bool contains(Object element) => iSet.contains(element);

  @override
  T elementAt(int index) => throw UnsupportedError("elementAt in ISet is not allowed");

  @override
  bool every(bool Function(T) test) => iSet.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => iSet.expand(f);

  @override
  int get length => iSet.length;

  @override
  T get first => iSet.first;

  @override
  T get last => iSet.last;

  @override
  T get single => iSet.single;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      iSet.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iSet.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => iSet.followedBy(other);

  @override
  void forEach(void Function(T element) f) => iSet.forEach(f);

  @override
  String join([String separator = ""]) => iSet.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      iSet.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T element) f) => iSet.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => iSet.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      iSet.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => iSet.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => iSet.skipWhile(test);

  @override
  Iterable<T> take(int count) => iSet.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => iSet.takeWhile(test);

  @override
  ISet<T> where(bool Function(T element) test) => iSet.where(test);

  @override
  Iterable<E> whereType<E>() => iSet.whereType<E>();

  @override
  bool get isEmpty => iSet.isEmpty;

  @override
  bool get isNotEmpty => iSet.isNotEmpty;

  @override
  Iterator<T> get iterator => iSet.iterator;

  @override
  List<T> toList({bool growable = true}) => List.of(this, growable: growable);

  @override
  Set<T> toSet() => Set.of(this);
}
