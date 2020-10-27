import 'package:collection/collection.dart';

import '../utils/hash.dart';
import 'iset.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class SFlat<T> extends S<T> {
  final Set<T> _set;

  static S<T> empty<T>() => SFlat.unsafe(<T>{});

  SFlat(Iterable<T> iterable)
      : assert(iterable != null),
        _set = Set.of(iterable);

  SFlat.unsafe(this._set) : assert(_set != null);

  @override
  bool contains(Object element) => _set.contains(element);

  @override
  Iterator<T> get iterator => _set.iterator;

  @override
  bool get isEmpty => _set.isEmpty;

  @override
  bool any(bool Function(T) test) => _set.any(test);

  @override
  Iterable<R> cast<R>() => _set.cast<R>();

  @override
  bool every(bool Function(T) test) => _set.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => _set.expand(f);

  @override
  int get length => _set.length;

  @override
  T get first => _set.first;

  @override
  T get last => _set.last;

  @override
  T get single => _set.single;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      _set.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _set.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _set.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _set.forEach(f);

  @override
  String join([String separator = '']) => _set.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _set.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T element) f) => ISet(_set.map(f));

  @override
  T reduce(T Function(T value, T element) combine) => _set.reduce(combine);

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
  Iterable<T> where(bool Function(T element) test) => _set.where(test);

  @override
  Iterable<E> whereType<E>() => ISet(_set.whereType<E>());

  bool deepSetEquals_toIterable(Iterable<T> other) {
    if (other == null) return false;
    Set<T> set = (other is Set<T>) ? other : Set<T>.of(other);
    return const SetEquality(MapEntryEquality()).equals(_set, set);
  }

  bool deepSetEquals(SFlat<T> other) =>
      (other == null) ? false : const SetEquality(MapEntryEquality()).equals(_set, other._set);

  int deepSetHashcode() => const SetEquality(MapEntryEquality()).hash(_set);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// This works for any object, not only map entries, but `MapEntry` gets special treatment.
/// We consider two map-entries equal when their respective key and values are equal.
class MapEntryEquality<E> implements Equality<E> {
  const MapEntryEquality();

  @override
  bool equals(Object obj1, Object obj2) => //
      (obj1 is MapEntry && obj2 is MapEntry) //
          ? obj1.key == obj2.key && obj1.value == obj2.value
          : obj1 == obj2;

  @override
  int hash(Object obj) => //
      (obj is MapEntry) //
          ? hash2(obj.key, obj.value)
          : obj.hashCode;

  @override
  bool isValidKey(Object o) => true;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
