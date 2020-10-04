import 'package:meta/meta.dart';

import '../immutable_collection.dart';
import 'l_add.dart';
import 'l_add_all.dart';
import 'l_flat.dart';

extension IListExtension<T> on List<T> {
  //

  /// Locks the list, returning an *immutable* list ([IList]).
  IList<T> get lock => IList<T>(this);

  /// Locks the list, returning an *immutable* list ([IList]).
  /// The equals operator (`==`) compares all items, ordered.
  IList<T> get lockDeep => IList<T>(this).deepEquals;

  /// Locks the list, returning an *immutable* list ([IList]).
  /// The equals operator (`==`) compares by identity.
  IList<T> get lockIdentity => IList<T>(this).identityEquals;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// An *immutable* list.
@immutable
class IList<T> // ignore: must_be_immutable
    extends ImmutableCollection<IList<T>> implements Iterable<T> {
  //

  L<T> _l;

  /// If `false` (the default), the equals operator (`==`) compares by identity.
  /// If `true`, the equals operator (`==`) compares all items, ordered.
  final bool isDeepEquals;

  bool get isIdentityEquals => !isDeepEquals;

  static IList<T> empty<T>() => IList.__(LFlat.empty<T>(), isDeepEquals: defaultIsDeepEquals);

  factory IList([
    Iterable<T> iterable,
  ]) =>
      iterable is IList<T>
          ? iterable
          : iterable == null || iterable.isEmpty
              ? IList.empty<T>()
              : IList<T>.__(LFlat<T>(iterable), isDeepEquals: defaultIsDeepEquals);

  IList._(Iterable<T> iterable, {@required this.isDeepEquals})
      : _l = iterable is IList<T>
            ? iterable._l
            : iterable == null
                ? LFlat.empty<T>()
                : LFlat<T>(iterable);

  /// Unsafe.
  IList.__(this._l, {@required this.isDeepEquals});

  /// Converts `this` list to `identityEquals` (compares by `identity`).
  IList<T> get identityEquals => isDeepEquals ? IList.__(_l, isDeepEquals: false) : this;

  /// Convert `this` list to `deepEquals` (compares all list items).
  IList<T> get deepEquals => isDeepEquals ? this : IList.__(_l, isDeepEquals: true);

  List<T> get unlock => List.of(_l);

  @override
  Iterator<T> get iterator => _l.iterator;

  @override
  bool get isEmpty => _l.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  bool operator ==(Object other) =>
      !isDeepEquals ? identical(this, other) : (other is IList<T> && equals(other));

  @override
  bool equals(IList<T> other) =>
      runtimeType == other.runtimeType &&
      isDeepEquals == other.isDeepEquals &&
      (flush._l as LFlat<T>).deepListEquals(other.flush._l as LFlat<T>);

  @override
  int get hashCode => !isDeepEquals
      ? identityHashCode(_l) ^ isDeepEquals.hashCode
      : (flush._l as LFlat<T>).deepListHashcode();

  // --- IList methods: ---------------

  /// Compacts the list. Chainable method.
  IList get flush {
    if (!isFlushed) _l = LFlat<T>(_l);
    return this;
  }

  bool get isFlushed => _l is LFlat;

  IList<T> add(T item) => IList<T>.__(_l.add(item), isDeepEquals: isDeepEquals);

  IList<T> addAll(Iterable<T> items) => IList<T>.__(_l.addAll(items), isDeepEquals: isDeepEquals);

  IList<T> remove(T item) {
    final L<T> result = _l.remove(item);
    return identical(result, _l) ? this : IList<T>.__(result, isDeepEquals: isDeepEquals);
  }

  /// Removes the element, if it exists in the list.
  /// Otherwise, adds it to the list.
  IList<T> toggle(T element) => contains(element) ? remove(element) : add(element);

  T operator [](int index) => _l[index];

  // --- Iterable methods: ---------------

  @override
  bool any(bool Function(T) test) => _l.any(test);

  @override
  IList<R> cast<R>() => IList._(_l.cast<R>(), isDeepEquals: isDeepEquals);

  @override
  bool contains(Object element) => _l.contains(element);

  @override
  T elementAt(int index) => _l[index];

  @override
  bool every(bool Function(T) test) => _l.every(test);

  @override
  IList<E> expand<E>(Iterable<E> Function(T) f) =>
      IList._(_l.expand(f), isDeepEquals: isDeepEquals);

  @override
  int get length {
    final int length = _l.length;
    if (length == 0 && _l is! LFlat) _l = LFlat.empty<T>();
    return length;
  }

  @override
  T get first => _l.first;

  @override
  T get last => _l.last;

  @override
  T get single => _l.single;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) => _l.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _l.fold(initialValue, combine);

  @override
  IList<T> followedBy(Iterable<T> other) =>
      IList._(_l.followedBy(other), isDeepEquals: isDeepEquals);

  @override
  void forEach(void Function(T element) f) => _l.forEach(f);

  @override
  String join([String separator = '']) => _l.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _l.lastWhere(test, orElse: orElse);

  @override
  IList<E> map<E>(E Function(T e) f) => IList._(_l.map(f), isDeepEquals: isDeepEquals);

  @override
  T reduce(T Function(T value, T element) combine) => _l.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _l.singleWhere(test, orElse: orElse);

  @override
  IList<T> skip(int count) => IList._(_l.skip(count), isDeepEquals: isDeepEquals);

  @override
  IList<T> skipWhile(bool Function(T value) test) =>
      IList._(_l.skipWhile(test), isDeepEquals: isDeepEquals);

  @override
  IList<T> take(int count) => IList._(_l.take(count), isDeepEquals: isDeepEquals);

  @override
  IList<T> takeWhile(bool Function(T value) test) =>
      IList._(_l.takeWhile(test), isDeepEquals: isDeepEquals);

  @override
  IList<T> where(bool Function(T element) test) =>
      IList._(_l.where(test), isDeepEquals: isDeepEquals);

  @override
  IList<E> whereType<E>() => IList._(_l.whereType<E>(), isDeepEquals: isDeepEquals);

  /// If the list has more than `maxLength` elements, it gets cut on
  /// `maxLength`. Otherwise, it removes the last elements so it remains with
  /// only `maxLength` elements.
  IList<T> maxLength(int maxLength) =>
      IList.__(_l.maxLength(maxLength), isDeepEquals: isDeepEquals);

  @override
  List<T> toList({bool growable = true}) => _l.toList(growable: growable);

  @override
  Set<T> toSet() => _l.toSet();

  @override
  String toString() => "[${_l.join(", ")}]";
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

@visibleForOverriding
abstract class L<T> implements Iterable<T> {
  //

  /// The [L] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  /// Note these fallback methods need to calculate the flushed list, but
  /// because that's immutable, we cache it.
  List<T> _flushed;

  List<T> get _getFlushed {
    _flushed ??= unlock;
    return _flushed;
  }

  /// Returns a regular Dart (mutable) List.
  List<T> get unlock => List<T>.of(this);

  @override
  Iterator<T> get iterator;

  L<T> add(T item) {
    return LAdd<T>(this, item);
  }

  L<T> addAll(Iterable<T> items) => LAddAll<T>(
        this,
        (items is IList<T>) ? items._l : items,
      );

  /// TODO: FALTA FAZER!!!
  L<T> remove(T element) =>
      !contains(element) ? this : LFlat<T>.unsafe(List.of(this)..remove(element));

  /// TODO: FALTA FAZER!!!
  /// If the list has more than `maxLength` elements, it gets cut on
  /// `maxLength`. Otherwise, it removes the last elements so it remains with
  /// only `maxLength` elements.
  L<T> maxLength(int maxLength) => maxLength < 0
      ? throw ArgumentError(maxLength)
      : length <= maxLength
          ? this
          : LFlat<T>.unsafe(List.of(this)..length = maxLength);

  @override
  bool get isEmpty => _getFlushed.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  bool any(bool Function(T) test) => _getFlushed.any(test);

  // TODO: FALTA FAZER!!! Isso é o ideal realmente?
  @override
  Iterable<R> cast<R>() => _getFlushed.cast<R>();

  @override
  bool contains(Object element) => _getFlushed.contains(element);

  T operator [](int index) => _getFlushed[index];

  @override
  T elementAt(int index) => _getFlushed[index];

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
  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
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
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
