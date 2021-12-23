import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/ilist/l_add.dart';

import 'l_add_all.dart';
import 'l_flat.dart';

abstract class L<T> implements Iterable<T> {
  //

  /// The [L] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  ///
  /// Note these fallback methods need to calculate the flushed list, but
  /// because that's immutable, we cache it.
  List<T>? _flushed;

  /// Returns the flushed list (flushes it only once).
  /// **It is an error to use the flushed list outside of the [L] class**.
  List<T> get getFlushed {
    _flushed ??= unlock;
    return _flushed!;
  }

  /// Returns a regular Dart (*mutable*, `growable`) List.
  List<T> get unlock => List<T>.of(this, growable: true);

  /// Returns a new `Iterator` that allows iterating the items of the [IList].
  @override
  Iterator<T> get iterator;

  @override
  bool get isEmpty => iter.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  Iterable<T> get iter;

  L<T> add(T item) {
    return LAdd<T>(this, item);
  }

  // Note: itemsIterableOrL can't be an IList. If it is, get it's _l.
  L<T> addAll(Iterable<T> itemsIterableOrL) => LAddAll<T>(this, itemsIterableOrL);

  // TODO: Still need to implement efficiently.
  /// Removes the first occurrence of [element] from this list.
  L<T> remove(T element) => !contains(element) ? this : LFlat<T>.unsafe(unlock..remove(element));

  L<T> removeAll(Iterable<T?> elements) {
    var list = unlock;
    var originalLength = list.length;
    var set = HashSet.of(elements);
    list = unlock..removeWhere((e) => set.contains(e));
    if (list.length == originalLength) return this;
    return LFlat<T>.unsafe(list);
  }

  // TODO: Still need to implement efficiently.
  L<T> removeMany(T element) =>
      !contains(element) ? this : LFlat<T>.unsafe(unlock..removeWhere((e) => e == element));

  // TODO: Still need to implement efficiently.
  /// If the list has more than `maxLength` elements, removes the last elements so it remains
  /// with only `maxLength` elements. If the list has `maxLength` or less elements, doesn't
  /// change anything.
  L<T> maxLength(int maxLength) => maxLength < 0
      ? throw ArgumentError(maxLength)
      : length <= maxLength
          ? this
          : LFlat<T>.unsafe(unlock..length = maxLength);

  /// Sorts this list according to the order specified by the [compare] function.
  /// If [compare] is not provided, it will use the natural ordering of the type [T].
  L<T> sort([int Function(T a, T b)? compare]) {
    // Explicitly sorts MapEntry (since MapEntry is not Comparable).
    if ((compare == null) && (T == MapEntry))
      compare = (T a, T b) => (a as MapEntry).compareKeyAndValue(b as MapEntry);

    return LFlat<T>.unsafe(unlock..sort(compare ?? compareObject));
  }

  L<T> sortOrdered([int Function(T a, T b)? compare]) {
    // Explicitly sorts MapEntry (since MapEntry is not Comparable).
    if ((compare == null) && (T == MapEntry))
      compare = (T a, T b) => (a as MapEntry).compareKeyAndValue(b as MapEntry);

    return LFlat<T>.unsafe(unlock..sortOrdered(compare ?? compareObject));
  }

  /// Sorts this list according to the order specified by the [ordering] iterable.
  /// Items which don't appear in [ordering] will be included in the end, in no particular order.
  ///
  /// Note: Not very efficient at the moment (will be improved in the future).
  /// Please use for a small number of items.
  ///
  L<T> sortLike(Iterable<T> ordering) {
    Set<T> orderingSet = Set.of(ordering);
    Set<T> newSet = Set.of(this);
    Set<T> intersection = orderingSet.intersection(newSet);
    Set<T> difference = newSet.difference(orderingSet);
    List<T> result = ordering.where((element) => intersection.contains(element)).toList();
    result.addAll(difference);
    return LFlat<T>.unsafe(result);
  }

  @override
  bool any(Predicate<T> test) => iter.any(test);

  @override
  Iterable<R> cast<R>() => iter.cast<R>();

  @override
  bool contains(covariant T? element) => iter.contains(element);

  T operator [](int index);

  @override
  T elementAt(int index) => this[index];

  @override
  bool every(Predicate<T> test) => iter.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => iter.expand(f);

  @override
  int get length;

  @override
  T get first;

  @override
  T get last;

  @override
  T get single;

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
  List<T> toList({bool growable = true}) => List.of(iter, growable: growable);

  /// Ordered set.
  @override
  Set<T> toSet() => Set.of(iter);

  /// Ordered set. Same as [toSet].
  LinkedHashSet<T> toLinkedHashSet() => LinkedHashSet.of(iter);

  /// Ordered set which is also a list.
  /// Returns a [ListSet], which has the same performance and needs
  /// less memory than a [LinkedHashSet], but can't change size.
  ListSet<T> toListSet() => ListSet.of(iter);

  /// Unordered set. Returns a [HashSet], which is faster than [LinkedHashSet]
  /// and consumes less memory.
  HashSet<T> toHashSet() => HashSet.of(iter);
}
