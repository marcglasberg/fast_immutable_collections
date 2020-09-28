import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 's_flat.dart';
import 's_add.dart';
import 's_add_all.dart';
import 'package:meta/meta.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension ISetExtension<T> on Set<T> {
  //

  /// Locks the set, returning an immutable set (ISet).
  /// The equals operator compares by identity (it's only
  /// equal when the set instance is the same).
  ISet<T> get lock => ISet<T>(this);

  /// Locks the set, returning an immutable set (ISet).
  /// The equals operator compares all items, unordered.
  ISet<T> get deep => ISet<T>(this).deepEquals;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// An immutable unordered set.
@immutable
class ISet<T> // ignore: must_be_immutable
    extends ImmutableCollection<ISet<T>> implements Iterable<T> {
  //

  S<T> _s;

  /// If false (the default), the equals operator compares by identity.
  /// If true, the equals operator compares all items, unordered.
  final bool isDeepEquals;

  static ISet<T> empty<T>() => ISet.__(SFlat.empty<T>(), isDeepEquals: false);

  factory ISet([
    Iterable<T> iterable,
  ]) =>
      iterable is ISet<T>
          ? iterable
          : (iterable == null || iterable.isEmpty)
              ? ISet.empty<T>()
              : ISet<T>.__(SFlat<T>(iterable), isDeepEquals: false);

  ISet._(Iterable<T> iterable, {@required this.isDeepEquals})
      : _s = iterable is ISet<T>
            ? iterable._s
            : (iterable == null)
                ? SFlat.empty<T>()
                : SFlat<T>(iterable);

  ISet.__(this._s, {@required this.isDeepEquals});

  /// Convert this set to identityEquals (compares by identity).
  ISet<T> get identityEquals => isDeepEquals ? ISet.__(_s, isDeepEquals: false) : this;

  /// Convert this set to deepEquals (compares all set items).
  ISet<T> get deepEquals => isDeepEquals ? this : ISet.__(_s, isDeepEquals: true);

  Set<T> get unlock => Set<T>.of(_s);

  @override
  Iterator<T> get iterator => _s.iterator;

  @override
  bool get isEmpty => _s.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  bool operator ==(Object other) =>
      (!isDeepEquals) ? identical(this, other) : (other is ISet<T> && equals(other));

  @override
  bool equals(ISet<T> other) =>
      runtimeType == other.runtimeType &&
      isDeepEquals == other.isDeepEquals &&
      (flush._s as SFlat<T>).setEquals(other.flush._s);

  @override
  int get hashCode {
    if (!isDeepEquals)
      return _s.hashCode ^ isDeepEquals.hashCode;
    else
      return (flush._s as SFlat).setHashcode();
  }

  // --- ISet methods: ---------------

  /// Compacts the set *and* returns it.
  ISet<T> get flush {
    if (!isFlushed) _s = SFlat<T>.unsafe(Set<T>.of(_s));
    return this;
  }

  bool get isFlushed => _s is SFlat;

  /// Returns a new set containing the current set plus the given item.
  /// However, if the given item already exists in the set,
  /// it will return the current set (same instance).
  ISet<T> add(T item) =>
      contains(item) ? this : ISet<T>.__(_s.add(item), isDeepEquals: isDeepEquals);

  /// Returns a new set containing the current set plus all the given items.
  /// However, if all given items already exists in the set,
  /// it will return the current set (same instance).
  ISet<T> addAll(Iterable<T> items) {
    final Set<T> setToBeAdded = {};
    for (T item in items) {
      if (!_s.contains(item)) setToBeAdded.add(item);
    }
    return (setToBeAdded.isEmpty)
        ? this
        : ISet<T>.__(_s.addAll(setToBeAdded), isDeepEquals: isDeepEquals);
  }

  /// Returns a new set containing the current set minus the given item.
  /// However, if the given item didn't exist in the current set,
  /// it will return the current set (same instance).
  ISet<T> remove(T item) {
    var result = _s.remove(item);
    if (identical(result, _s))
      return this;
    else
      return ISet<T>.__(result, isDeepEquals: isDeepEquals);
  }

  /// Removes the element, if it exists in the set.
  /// Otherwise, adds it to the set.
  ISet<T> toggle(T item) =>
      ISet<T>.__(contains(item) ? _s.remove(item) : _s.add(item), isDeepEquals: isDeepEquals);

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
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => _s.expand(f);

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
  ISet<T> followedBy(Iterable<T> other) => ISet._(_s.followedBy(other), isDeepEquals: isDeepEquals);

  @override
  void forEach(void Function(T element) f) => _s.forEach(f);

  @override
  String join([String separator = '']) => _s.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _s.lastWhere(test, orElse: orElse);

  @override
  ISet<E> map<E>(E Function(T e) f) => ISet._(_s.map(f), isDeepEquals: isDeepEquals);

  @override
  T reduce(T Function(T value, T element) combine) => _s.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _s.singleWhere(test, orElse: orElse);

  @override
  ISet<T> skip(int count) => ISet._(_s.skip(count), isDeepEquals: isDeepEquals);

  @override
  ISet<T> skipWhile(bool Function(T value) test) =>
      ISet._(_s.skipWhile(test), isDeepEquals: isDeepEquals);

  @override
  ISet<T> take(int count) => ISet._(_s.take(count), isDeepEquals: isDeepEquals);

  @override
  ISet<T> takeWhile(bool Function(T value) test) =>
      ISet._(_s.takeWhile(test), isDeepEquals: isDeepEquals);

  @override
  ISet<T> where(bool Function(T element) test) =>
      ISet._(_s.where(test), isDeepEquals: isDeepEquals);

  @override
  ISet<E> whereType<E>() => ISet._(_s.whereType<E>(), isDeepEquals: isDeepEquals);

  @override
  List<T> toList({bool growable = true}) => _s.toList(growable: growable);

  IList<T> toIList() => IList(_s);

  @override
  Set<T> toSet() => _s.toSet();
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

abstract class S<T> implements Iterable<T> {
  /// The [S] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  /// Note these fallback methods need to calculate the flushed set, but
  /// because that's immutable, we **cache** it.
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

  S<T> addAll(Iterable<T> items) => SAddAll<T>.unsafe(this, items);

  /// TODO: FALTA FAZER!!!
  S<T> remove(T element) =>
      !contains(element) ? this : SFlat<T>.unsafe(Set<T>.of(this)..remove(element));

  @override
  bool get isEmpty => _getFlushed.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  bool any(bool Function(T) test) => _getFlushed.any(test);

  @override
  Iterable<R> cast<R>() => throw UnsupportedError('cast');

  // TODO: FALTA FAZER!!!
  // ISet<R> cast<R>() => _getFlushed.cast<R>();

  @override
  bool contains(Object element) => _getFlushed.contains(element);

  @override
  bool every(bool Function(T) test) => _getFlushed.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => _getFlushed.expand(f);

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
  Iterable<T> followedBy(Iterable<T> other) => _getFlushed.followedBy(other);

  @override
  void forEach(void Function(T element) f) => _getFlushed.forEach(f);

  @override
  String join([String separator = '']) => _getFlushed.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _getFlushed.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T e) f) => _getFlushed.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => _getFlushed.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _getFlushed.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _getFlushed.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _getFlushed.skipWhile(test);

  @override
  Iterable<T> take(int count) => _getFlushed.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _getFlushed.takeWhile(test);

  @override
  Iterable<T> where(bool Function(T element) test) => _getFlushed.where(test);

  @override
  Iterable<E> whereType<E>() => _getFlushed.whereType<E>();

  @override
  List<T> toList({bool growable = true}) => List.of(this, growable: growable);

  @override
  Set<T> toSet() => Set.of(this);

  @override
  T elementAt(int index) => throw UnsupportedError('elementAt in ISet is not allowed');
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
