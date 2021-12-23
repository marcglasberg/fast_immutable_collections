import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/iset/s_add.dart';
import 'package:fast_immutable_collections/src/iset/s_add_all.dart';
import 'package:fast_immutable_collections/src/iset/s_flat.dart';

abstract class S<T> implements Iterable<T> {
  //

  /// The [S] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  ///
  /// Note these fallback methods need to calculate the flushed set, but
  /// because that's immutable, we **cache** it.
  ListSet<T>? _flushed;

  /// Returns the flushed set (flushes it only once).
  /// It is an error to use the flushed set outside of the [S] class.
  ListSet<T> getFlushed(ConfigSet? config) {
    _flushed ??= ListSet.of(this, sort: (config ?? ISet.defaultConfig).sort);
    return _flushed!;
  }

  /// Returns a Dart [Set] (*mutable, ordered, of type [LinkedHashSet]*).
  Set<T> get unlock => LinkedHashSet.of(this);

  /// Returns a new [Iterator] that allows iterating the items of the [ISet].
  @override
  Iterator<T> get iterator;

  @override
  bool get isEmpty => iter.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  Iterable<T> get iter;

  /// Returns any item from the set.
  T get anyItem;

  /// Returns a new set containing the current set plus the given item.
  /// However, if the given item already exists in the set,
  /// it will return the current set (same instance).
  S<T> add(T item) => contains(item) ? this : SAdd(this, item);

  /// Returns a new set containing the current set plus all the given items.
  /// However, if all given items already exists in the set,
  /// it will return the current set (same instance).
  /// Note: The items of [items] which are already in the original set will be ignored.
  S<T> addAll(Iterable<T> items) {
    final Set<T> setToBeAdded = ListSet.of(items.where((item) => !contains(item)));
    return setToBeAdded.isEmpty ? this : SAddAll.unsafe(this, setToBeAdded);
  }

  // TODO: Still need to implement efficiently.
  S<T> remove(T element) => !contains(element) ? this : SFlat<T>.unsafe(unlock..remove(element));

  @override
  bool any(Predicate<T> test) => iter.any(test);

  @override
  Iterable<R> cast<R>() => iter.cast<R>();

  @override
  bool contains(covariant T? element);

  bool containsAll(Iterable<T> other);

  T? lookup(T element);

  Set<T> difference(Set<T> other);

  Set<T> intersection(Set<T> other);

  Set<T> union(Set<T> other);

  @override
  bool every(Predicate<T> test) => iter.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => iter.expand(f);

  @override
  int get length => iter.length;

  @override
  T get first => iter.first;

  @override
  T get last => iter.last;

  @override
  T get single => iter.single;

  @override
  T firstWhere(Predicate<T> test, {T Function()? orElse}) => iter.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      iter.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => iter.followedBy(other);

  @override
  void forEach(void Function(T element) f) => iter.forEach(f);

  @override
  String join([String separator = ""]) => iter.join(separator);

  @override
  T lastWhere(Predicate<T> test, {T Function()? orElse}) => iter.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T element) f) => iter.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => iter.reduce(combine);

  @override
  T singleWhere(Predicate<T> test, {T Function()? orElse}) =>
      iter.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => iter.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => iter.skipWhile(test);

  @override
  Iterable<T> take(int count) => iter.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => iter.takeWhile(test);

  @override
  Iterable<T> where(Predicate<T> test) => iter.where(test);

  @override
  Iterable<E> whereType<E>() => iter.whereType<E>();

  @override
  List<T> toList({bool growable = true}) => List.of(this, growable: growable);

  @override
  Set<T> toSet() => LinkedHashSet.of(this);

  @override
  T elementAt(int index) => this[index];

  T operator [](int index);
}
