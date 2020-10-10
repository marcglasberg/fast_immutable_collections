import 'package:meta/meta.dart';
import '../immutable_collection.dart';
import '../ilist/ilist.dart';
import 's_flat.dart';
import 's_add.dart';
import 's_add_all.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension ISetExtension<T> on Set<T> {
  //
  /// Locks the set, returning an *immutable* set ([ISet]).
  ISet<T> get lock => ISet<T>(this);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// An immutable unordered set.
@immutable
class ISet<T> // ignore: must_be_immutable
    extends ImmutableCollection<ISet<T>> implements Iterable<T> {
  //

  S<T> _s;

  /// If given, will be used to sort list of values.
  final int Function(T, T) compare;

  /// If `false` (the default), the equals operator (`==`)  compares by identity.
  /// If `true`, the equals operator (`==`) compares all items, unordered.
  final bool isDeepEquals;

  bool get isIdentityEquals => !isDeepEquals;

  static ISet<T> empty<T>() => ISet._unsafe(
        SFlat.empty<T>(),
        compare: null,
        isDeepEquals: defaultIsDeepEquals,
      );

  factory ISet([Iterable<T> iterable]) => iterable is ISet<T>
      ? iterable
      : iterable == null || iterable.isEmpty
          ? ISet.empty<T>()
          : ISet<T>._unsafe(
              SFlat<T>(iterable),
              compare: null,
              isDeepEquals: defaultIsDeepEquals,
            );

  /// Unsafe constructor. Use this at your own peril.
  /// This constructor is fast, since it makes no defensive copies of the set.
  /// However, you should only use this with a new set you've created yourself,
  /// when you are sure no external copies exist. If the original set is modified,
  /// it will break the IList and any other derived lists.
  ISet.unsafe(Set<T> set, {@required this.compare, @required this.isDeepEquals})
      : _s = (set == null) ? SFlat.empty<T>() : SFlat<T>.unsafe(set);

  ISet._(
    Iterable<T> iterable, {
    @required this.compare,
    @required this.isDeepEquals,
  }) : _s = iterable is ISet<T>
            ? iterable._s
            : iterable == null
                ? SFlat.empty<T>()
                : SFlat<T>(iterable);

  ISet._unsafe(
    this._s, {
    @required this.compare,
    @required this.isDeepEquals,
  });

  ISet<T> config({
    int Function(T, T) compare,
    bool isDeepEquals,
  }) =>
      ISet._unsafe(
        _s,
        compare: compare ?? this.compare,
        isDeepEquals: isDeepEquals ?? this.isDeepEquals,
      );

  /// Convert this set to `identityEquals` (compares by identity).
  ISet<T> get identityEquals => isDeepEquals
      ? ISet._unsafe(
          _s,
          compare: compare,
          isDeepEquals: false,
        )
      : this;

  /// Convert this set to `deepEquals` (compares all set items).
  ISet<T> get deepEquals => isDeepEquals
      ? this
      : ISet._unsafe(
          _s,
          compare: compare,
          isDeepEquals: true,
        );

  Set<T> get unlock => Set<T>.of(_s);

  @override
  Iterator<T> get iterator => _s.iterator;

  @override
  bool get isEmpty => _s.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  /// If [isDeepEquals] configuration is true:
  /// Will return true only if the set items are equal (and in the same order),
  /// and the set configurations are the same instance. This may be slow for very
  /// large sets, since it compares each item, one by one.
  ///
  /// If [isDeepEquals] configuration is false:
  /// Will return true only if the sets internals are the same instances
  /// (comparing by identity). This will be fast even for very large sets,
  /// since it doesn't compare each item.
  /// Note: This is not the same as `identical(set1, set2)` since it doesn't
  /// compare the sets themselves, but their internal state. Comparing the
  /// internal state is better, because it will return true more often.
  ///
  @override
  bool operator ==(Object other) => (other is ISet<T>)
      ? isDeepEquals
          ? equals(other)
          : same(other)
      : false;

  /// Will return true only if the set items are equal (and in the same order),
  /// and the set configurations are the same instance. This may be slow for very
  /// large sets, since it compares each item, one by one.
  @override
  bool equals(ISet<T> other) =>
      identical(this, other) ||
      other is ISet<T> &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals &&
          (flush._s as SFlat<T>).deepSetEquals(other.flush._s as SFlat<T>);

  /// Will return true only if the sets internals are the same instances
  /// (comparing by identity). This will be fast even for very large sets,
  /// since it doesn't compare each item.
  /// Note: This is not the same as `identical(set1, set2)` since it doesn't
  /// compare the sets themselves, but their internal state. Comparing the
  /// internal state is better, because it will return true more often.
  @override
  bool same(ISet<T> other) =>
      identical(_s, other._s) && (isDeepEquals == other.isDeepEquals) && (compare == other.compare);

  @override
  int get hashCode => isDeepEquals //
      ? (flush._s as SFlat<T>).deepSetHashcode()
      : identityHashCode(_s);

  /// Compacts the set *and* returns it.
  ISet<T> get flush {
    if (!isFlushed) _s = SFlat<T>.unsafe(Set<T>.of(_s));
    return this;
  }

  bool get isFlushed => _s is SFlat;

  /// Returns a new set containing the current set plus the given item.
  ISet<T> add(T item) => ISet<T>._unsafe(
        _s.add(item),
        compare: compare,
        isDeepEquals: isDeepEquals,
      );

  /// Returns a new set containing the current set plus all the given items.
  ISet<T> addAll(Iterable<T> items) => ISet<T>._unsafe(
        _s.addAll(items),
        compare: compare,
        isDeepEquals: isDeepEquals,
      );

  /// Returns a new set containing the current set minus the given item.
  /// However, if the given item didn't exist in the current set,
  /// it will return the current set (same instance).
  ISet<T> remove(T item) {
    final S<T> result = _s.remove(item);
    return identical(result, _s)
        ? this
        : ISet<T>._unsafe(
            result,
            compare: compare,
            isDeepEquals: isDeepEquals,
          );
  }

  /// Removes the element, if it exists in the set.
  /// Otherwise, adds it to the set.
  ISet<T> toggle(T item) => ISet<T>._unsafe(
        contains(item) ? _s.remove(item) : _s.add(item),
        compare: compare,
        isDeepEquals: isDeepEquals,
      );

  // --- Iterable methods: ---------------

  @override
  bool any(bool Function(T) test) => _s.any(test);

  @override
  ISet<R> cast<R>() {
    var result = _s.cast<R>();
    return (result is S<R>)
        ? ISet._unsafe(result, compare: null, isDeepEquals: isDeepEquals)
        : ISet._(result, compare: null, isDeepEquals: isDeepEquals);
  }

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
  T firstWhere(bool Function(T) test, {T Function() orElse}) => _s.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _s.fold(initialValue, combine);

  @override
  ISet<T> followedBy(Iterable<T> other) => ISet._(
        _s.followedBy(other),
        compare: compare,
        isDeepEquals: isDeepEquals,
      );

  @override
  void forEach(void Function(T element) f) => _s.forEach(f);

  @override
  String join([String separator = '']) => _s.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _s.lastWhere(test, orElse: orElse);

  @override
  ISet<E> map<E>(E Function(T e) f) => ISet._(
        _s.map(f),
        compare: null,
        isDeepEquals: isDeepEquals,
      );

  @override
  T reduce(T Function(T value, T element) combine) => _s.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _s.singleWhere(test, orElse: orElse);

  @override
  ISet<T> skip(int count) => ISet._(
        _s.skip(count),
        compare: compare,
        isDeepEquals: isDeepEquals,
      );

  @override
  ISet<T> skipWhile(bool Function(T value) test) => ISet._(
        _s.skipWhile(test),
        compare: compare,
        isDeepEquals: isDeepEquals,
      );

  @override
  ISet<T> take(int count) => ISet._(
        _s.take(count),
        compare: compare,
        isDeepEquals: isDeepEquals,
      );

  @override
  ISet<T> takeWhile(bool Function(T value) test) => ISet._(
        _s.takeWhile(test),
        compare: compare,
        isDeepEquals: isDeepEquals,
      );

  @override
  ISet<T> where(bool Function(T element) test) => ISet._(
        _s.where(test),
        compare: compare,
        isDeepEquals: isDeepEquals,
      );

  @override
  ISet<E> whereType<E>() => ISet._(
        _s.whereType<E>(),
        compare: null,
        isDeepEquals: isDeepEquals,
      );

  @override
  List<T> toList({bool growable = true}) => _s.toList(growable: growable);

  IList<T> toIList() => IList(_s);

  @override
  Set<T> toSet() => _s.toSet();

  @override
  String toString() => "{${_s.join(", ")}}";
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

@visibleForOverriding
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

  /// Returns a new set containing the current set plus the given item.
  /// However, if the given item already exists in the set,
  /// it will return the current set (same instance).
  S<T> add(T item) => contains(item) ? this : SAdd(this, item);

  /// Returns a new set containing the current set plus all the given items.
  /// However, if all given items already exists in the set,
  /// it will return the current set (same instance).
  S<T> addAll(Iterable<T> items) {
    final Set<T> setToBeAdded = {};
    for (T item in items) {
      if (!contains(item)) setToBeAdded.add(item);
    }
    return setToBeAdded.isEmpty ? this : SAddAll(this, setToBeAdded);
  }

  /// TODO: FALTA FAZER!!!
  S<T> remove(T element) =>
      !contains(element) ? this : SFlat<T>.unsafe(Set<T>.of(this)..remove(element));

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
  bool contains(Object element);

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

  @override
  T elementAt(int index) => throw UnsupportedError('elementAt in ISet is not allowed');
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
