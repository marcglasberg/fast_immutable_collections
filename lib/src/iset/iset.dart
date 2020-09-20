import 'package:fast_immutable_collections/src/s_add.dart';
import 'package:fast_immutable_collections/src/s_flat.dart';

import '../s_flat.dart';
import '../s_add.dart';
import '../s_add_all.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension ISetExtension<T> on Iterable<T> {
  ISet<T> get lock => ISet<T>(this);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class ISet<T> implements Iterable<T> {
  S<T> _s;

  factory ISet([Iterable<T> iterable]) =>
      (iterable is ISet) ? (iterable as ISet) : ISet._(iterable);

  ISet._([Iterable<T> iterable])
      : _s = (iterable is ISet)
            ? (iterable as ISet)._s
            : SFlat(iterable == null ? const [] : Set.of(iterable));

  ISet.__(this._s);

  Set<T> get unlock => Set.of(_s);

  @override
  Iterator<T> get iterator => _s.iterator;

  @override
  bool get isEmpty => _s.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  // --- ISet methods: ---------------

  /// Compacts the set.
  ISet<T> get flush {
    if (!isFlushed) _s = SFlat(Set.of(_s));
    return this;
  }

  bool get isFlushed => _s is SFlat;

  ISet<T> add(T item) => ISet<T>.__(_s.add(item));

  ISet<T> addAll(Iterable<T> items) => ISet<T>.__(_s.addAll(items));

  ISet<T> remove(T element) => ISet<T>.__(_s.remove(element));

  /// Removes the element, if it exists in the set.
  /// Otherwise, adds it to the set.
  ISet<T> toggle(T element) => contains(element) ? remove(element) : add(element);

  // --- Iterable methods: ---------------

  @override
  bool any(bool Function(T) test) => _s.any(test);

  @override
  ISet<R> cast<R>() => _s.cast<R>();

  @override
  bool contains(Object element) => _s.contains(element);

  @override
  T elementAt(int index) => throw UnsupportedError('elementAt in ISet is not allowed');

  @override
  bool every(bool Function(T) test) => _s.every(test);

  @override
  ISet<E> expand<E>(Iterable<E> Function(T) f) => _s.expand(f);

  @override
  int get length => _s.length;

  @override
  T get first => _s.first;

  @override
  T get last => _s.last;

  @override
  T get single => _s.single;

  @override
  T firstWhere(bool Function(T) test, {Function() orElse}) => _s.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _s.fold(initialValue, combine);

  @override
  ISet<T> followedBy(Iterable<T> other) => _s.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _s.forEach(f);

  @override
  String join([String separator = '']) => _s.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _s.lastWhere(test, orElse: orElse);

  @override
  ISet<E> map<E>(E Function(T e) f) => _s.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => _s.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _s.singleWhere(test, orElse: orElse);

  @override
  ISet<T> skip(int count) => _s.skip(count);

  @override
  ISet<T> skipWhile(bool Function(T value) test) => _s.skipWhile(test);

  @override
  ISet<T> take(int count) => _s.take(count);

  @override
  ISet<T> takeWhile(bool Function(T value) test) => _s.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _s.toList(growable: growable);

  @override
  Set<T> toSet() => _s.toSet();

  @override
  ISet<T> where(bool Function(T element) test) => _s.where(test);

  @override
  ISet<E> whereType<E>() => _s.whereType<E>();
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

abstract class IterableS<T> implements Iterable<T> {
  //
  @override
  bool any(bool Function(T) test);

  @override
  ISet<R> cast<R>();

  @override
  bool contains(Object element);

  @override
  T elementAt(int index);

  @override
  bool every(bool Function(T) test);

  @override
  ISet<E> expand<E>(Iterable<E> Function(T) f);

  @override
  int get length;

  @override
  T get first;

  @override
  T get last;

  @override
  T get single;

  @override
  T firstWhere(bool Function(T) test, {Function() orElse});

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine);

  @override
  ISet<T> followedBy(Iterable<T> other);

  @override
  void forEach(void Function(T element) f);

  @override
  String join([String separator = '']);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse});

  @override
  ISet<E> map<E>(E Function(T e) f);

  @override
  T reduce(T Function(T value, T element) combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse});

  @override
  ISet<T> skip(int count);

  @override
  ISet<T> skipWhile(bool Function(T value) test);

  @override
  ISet<T> take(int count);

  @override
  ISet<T> takeWhile(bool Function(T value) test);

  @override
  List<T> toList({bool growable = true});

  @override
  Set<T> toSet();

  @override
  ISet<T> where(bool Function(T element) test);

  @override
  ISet<E> whereType<E>();
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

abstract class S<T> implements IterableS<T> {
  //
  /// The [S] class provides the default fallback methods of Iterable, but
  /// ideally all of its methods are implemented in all of its subclasses.
  /// Note these fallback methods need to calculate the flushed set, but
  /// because that's immutable, we cache it.
  Set<T> _flushed;

  Set<T> get _getFlushed {
    _flushed ??= unlock;
    return _flushed;
  }

  /// Returns a regular Dart (mutable) Set.
  Set<T> get unlock => Set<T>.of(this);

  @override
  Iterator<T> get iterator;

  S<T> add(T item) => SAdd<T>(this, item);

  S<T> addAll(Iterable<T> items) => SAddAll<T>(this, items);

  /// TODO: FALTA FAZER!!!
  S<T> remove(T element) {
    return !contains(element) ? this : SFlat<T>(Set.of(this)..remove(element));
  }

  @override
  bool get isEmpty => _getFlushed.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  bool any(bool Function(T) test) => _getFlushed.any(test);

  @override
  ISet<R> cast<R>() => throw UnsupportedError('cast');

//  ISet<R> cast<R>() => _getFlushed.cast<R>();

  @override
  bool contains(Object element) => _getFlushed.contains(element);

  @override
  bool every(bool Function(T) test) => _getFlushed.every(test);

  @override
  ISet<E> expand<E>(Iterable<E> Function(T) f) => ISet._(_getFlushed.expand(f));

  @override
  int get length => _getFlushed.length;

  @override
  T get first => _getFlushed.first;

  @override
  T get last => _getFlushed.last;

  @override
  T get single => _getFlushed.single;

  @override
  T firstWhere(bool Function(T) test, {Function() orElse}) =>
      _getFlushed.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _getFlushed.fold(initialValue, combine);

  @override
  ISet<T> followedBy(Iterable<T> other) => ISet._(_getFlushed.followedBy(other));

  @override
  void forEach(void Function(T element) f) => _getFlushed.forEach(f);

  @override
  String join([String separator = '']) => _getFlushed.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _getFlushed.lastWhere(test, orElse: orElse);

  @override
  ISet<E> map<E>(E Function(T e) f) => ISet._(_getFlushed.map(f));

  @override
  T reduce(T Function(T value, T element) combine) => _getFlushed.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _getFlushed.singleWhere(test, orElse: orElse);

  @override
  ISet<T> skip(int count) => ISet._(_getFlushed.skip(count));

  @override
  ISet<T> skipWhile(bool Function(T value) test) => ISet._(_getFlushed.skipWhile(test));

  @override
  ISet<T> take(int count) => ISet._(_getFlushed.take(count));

  @override
  ISet<T> takeWhile(bool Function(T value) test) => ISet._(_getFlushed.takeWhile(test));

  @override
  ISet<T> where(bool Function(T element) test) => ISet._(_getFlushed.where(test));

  @override
  ISet<E> whereType<E>() => ISet._(_getFlushed.whereType<E>());

  @override
  List<T> toList({bool growable = true}) => List.of(this, growable: growable);

  @override
  Set<T> toSet() => Set.of(this);

  @override
  T elementAt(int index) => throw UnsupportedError('elementAt in ISet is not allowed');
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
