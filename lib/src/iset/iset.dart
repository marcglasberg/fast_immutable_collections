import 'dart:collection';

import 'package:meta/meta.dart';
import '../utils/immutable_collection.dart';
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

/// An **immutable**, unordered set.
@immutable
class ISet<T> // ignore: must_be_immutable
    extends ImmutableCollection<ISet<T>> implements Iterable<T> {
  //
  S<T> _s;

  /// The set configuration.
  final ConfigSet config;

  static ISet<T> empty<T>([ConfigSet config]) => ISet._unsafe(
        SFlat.empty<T>(),
        config: config ?? defaultConfigSet,
      );

  /// Create an [ISet] from any [Iterable].
  /// Fast, if the Iterable is another [ISet].
  factory ISet([Iterable<T> iterable]) => //
      ISet.withConfig(iterable, defaultConfigSet);

  /// Create an [ISet] from any [Iterable] and a [ConfigSet].
  /// Fast, if the Iterable is another [ISet].
  factory ISet.withConfig(
    Iterable<T> iterable,
    ConfigSet config,
  ) =>
      iterable is ISet<T>
          ? iterable
          : (iterable == null) || iterable.isEmpty
              ? ISet.empty<T>(config)
              : ISet<T>._unsafe(
                  SFlat<T>(iterable),
                  config: config ?? defaultConfigSet,
                );

  /// Safe. Fast if the iterable is an ISet.
  ISet._(
    Iterable<T> iterable, {
    @required this.config,
  }) : _s = iterable is ISet<T>
            ? iterable._s
            : iterable == null
                ? SFlat.empty<T>()
                : SFlat<T>(iterable);

  /// Unsafe constructor. Use this at your own peril.
  /// This constructor is fast, since it makes no defensive copies of the set.
  /// However, you should only use this with a new set you've created yourself,
  /// when you are sure no external copies exist. If the original set is modified,
  /// it will break the [ISet] and any other derived sets in unpredictable ways.
  ISet.unsafe(Set<T> set, {@required this.config})
      : _s = (set == null) ? SFlat.empty<T>() : SFlat<T>.unsafe(set) {
    if (disallowUnsafeConstructors) throw UnsupportedError("ISet.unsafe is disallowed.");
  }

  /// Unsafe.
  ISet._unsafe(this._s, {@required this.config});

  /// Unsafe.
  ISet._unsafeFromSet(Set<T> set, {@required this.config})
      : _s = (set == null) ? SFlat.empty<T>() : SFlat<T>.unsafe(set);

  bool get isDeepEquals => config.isDeepEquals;

  bool get isIdentityEquals => !config.isDeepEquals;

  /// Creates a new set with the given [config].
  ///
  /// To copy the config from another [ISet]:
  ///    `set = set.withConfig(other.config)`.
  ///
  /// To change the current config:
  ///    `set = set.withConfig(set.config.copyWith(isDeepEquals: isDeepEquals))`.
  ///
  /// See also: [withIdentityEquals] and [withDeepEquals].
  ///
  ISet<T> withConfig(ConfigSet config) {
    assert(config != null);
    return (config == this.config) ? this : ISet._unsafe(_s, config: config);
  }

  /// Creates a set with `identityEquals` (compares the internals by `identity`).
  ISet<T> get withIdentityEquals =>
      config.isDeepEquals ? ISet._unsafe(_s, config: config.copyWith(isDeepEquals: false)) : this;

  /// Creates a set with `deepEquals` (compares all set items by equality).
  ISet<T> get withDeepEquals =>
      config.isDeepEquals ? this : ISet._unsafe(_s, config: config.copyWith(isDeepEquals: true));

  /// Returns an unordered [Set].
  Set<T> get unlock => _s.unlock;

  /// 1) If the set's [config] has [ConfigSet.autoSort] `true` (the default),
  /// it will iterate in the natural order of items. In other words, if the items
  /// are [Comparable], they will be sorted by `a.compareTo(b)`.
  /// 2) If the set's [config] has [ConfigSet.autoSort] `false`, or if the items
  /// are not [Comparable], the iterator order is undefined.
  ///
  @override
  Iterator<T> get iterator {
    if (config.autoSort) {
      var sortedList = _s.toList(growable: false)..sort(ImmutableCollection.compare);
      return sortedList.iterator;
    } else
      return _s.iterator;
  }

  /// This iterator is very fast to create, but won't iterate in any particular order,
  /// no matter what the set configuration is.
  Iterator<T> get fastIterator => _s.iterator;

  @override
  bool get isEmpty => _s.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  /// If [isDeepEquals] configuration is true:
  /// Will return true only if the set items are equal (and in the same order),
  /// and the set configurations are equal. This may be slow for very
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
          ? equalItemsAndConfig(other)
          : same(other)
      : false;

  @override
  bool equalItems(covariant Iterable<T> other) =>
      (other == null) ? false : (flush._s as SFlat<T>).deepSetEquals_toIterable(other);

  @override
  bool equalItemsAndConfig(ISet<T> other) =>
      identical(this, other) ||
      other is ISet<T> &&
          runtimeType == other.runtimeType &&
          config == other.config &&
          (flush._s as SFlat<T>).deepSetEquals(other.flush._s as SFlat<T>);

  /// Will return true only if the sets internals are the same instances
  /// (comparing by identity). This will be fast even for very large sets,
  /// since it doesn't compare each item.
  /// Note: This is not the same as `identical(set1, set2)` since it doesn't
  /// compare the sets themselves, but their internal state. Comparing the
  /// internal state is better, because it will return true more often.
  @override
  bool same(ISet<T> other) => identical(_s, other._s) && (config == other.config);

  @override
  int get hashCode => isDeepEquals //
      ? (flush._s as SFlat<T>).deepSetHashcode() ^ config.hashCode
      : identityHashCode(_s) ^ config.hashCode;

  /// Compacts the set *and* returns it.
  ISet<T> get flush {
    if (!isFlushed) _s = SFlat<T>.unsafe(_s.unlock);
    return this;
  }

  bool get isFlushed => _s is SFlat;

  /// Returns a new set containing the current set plus the given item.
  ISet<T> add(T item) => ISet<T>._unsafe(
        _s.add(item),
        config: config,
      );

  /// Returns a new set containing the current set plus all the given items.
  ISet<T> addAll(Iterable<T> items) => ISet<T>._unsafe(
        _s.addAll(items),
        config: config,
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
            config: config,
          );
  }

  /// Removes the element, if it exists in the set.
  /// Otherwise, adds it to the set.
  ISet<T> toggle(T item) => ISet<T>._unsafe(
        contains(item) ? _s.remove(item) : _s.add(item),
        config: config,
      );

  // --- Iterable methods: ---------------

  @override
  bool any(bool Function(T) test) => _s.any(test);

  /// Provides a view of this set as a set of [R] instances.
  ///
  /// If this set contains only instances of [R], all read operations
  /// will work correctly. If any operation tries to access an element
  /// that is not an instance of [R], the access will throw instead.
  ///
  /// Elements added to the set (e.g., by using [add] or [addAll])
  /// must be instance of [R] to be valid arguments to the adding function,
  /// and they must be instances of [E] as well to be accepted by
  /// this set as well.
  @override
  ISet<R> cast<R>() {
    var result = _s.cast<R>();
    return (result is S<R>) ? ISet._unsafe(result, config: config) : ISet._(result, config: config);
  }

  @override
  bool contains(Object element) => _s.contains(element);

  @override
  T elementAt(int index) => throw UnsupportedError('elementAt in ISet is not allowed');

  @override
  bool every(bool Function(T) test) => _s.every(test);

  @override
  ISet<E> expand<E>(Iterable<E> Function(T) f, {ConfigSet config}) =>
      ISet._(_s.expand(f), config: config ?? (T == E ? this.config : defaultConfigSet));

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
  ISet<T> followedBy(Iterable<T> other) => ISet._(_s.followedBy(other), config: config);

  @override
  void forEach(void Function(T element) f) => _s.forEach(f);

  @override
  String join([String separator = '']) => _s.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _s.lastWhere(test, orElse: orElse);

  @override
  ISet<E> map<E>(E Function(T e) f, {ConfigSet config}) =>
      ISet._(_s.map(f), config: config ?? (T == E ? this.config : defaultConfigSet));

  @override
  T reduce(T Function(T value, T element) combine) => _s.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _s.singleWhere(test, orElse: orElse);

  @override
  ISet<T> skip(int count) => ISet._(_s.skip(count), config: config);

  @override
  ISet<T> skipWhile(bool Function(T value) test) => ISet._(_s.skipWhile(test), config: config);

  @override
  ISet<T> take(int count) => ISet._(_s.take(count), config: config);

  @override
  ISet<T> takeWhile(bool Function(T value) test) => ISet._(_s.takeWhile(test), config: config);

  @override
  ISet<T> where(bool Function(T element) test) => ISet._(_s.where(test), config: config);

  @override
  ISet<E> whereType<E>() => ISet._(_s.whereType<E>(), config: config);

  /// Returns a [List] with all items from the set.
  ///
  /// 1) If you provide a [compare] function, the list will be sorted with it.
  ///
  /// 2) If no [compare] function is provided, the list will be sorted according to the
  /// set's [config] field:
  /// - If [ConfigSet.autoSort] is `true` (the default), the list will be sorted with
  /// `a.compareTo(b)`, in other words, with the natural order of items. This assumes the
  /// items implement [Comparable]. Otherwise, the list order is undefined.
  /// - If [ConfigSet.autoSort] is `false`, the list order is undefined.
  ///
  @override
  List<T> toList({bool growable = true, int Function(T a, T b) compare}) {
    var result = _s.toList(growable: growable);

    if (compare != null) {
      result.sort(compare);
    } else {
      if (config.autoSort) result.sort(ImmutableCollection.compare);
    }

    return result;
  }

  /// Returns a [IList] with all items from the set.
  ///
  /// 1) If you provide a [compare] function, the list will be sorted with it.
  ///
  /// 2) If no [compare] function is provided, the list will be sorted according to the
  /// set's [ISet.config] field:
  /// - If [ConfigSet.autoSort] is `true` (the default), the list will be sorted with
  /// `a.compareTo(b)`, in other words, with the natural order of items. This assumes the
  /// items implement [Comparable]. Otherwise, the list order is undefined.
  /// - If [ConfigSet.autoSort] is `false`, the list order is undefined.
  ///
  /// You can also provide a [config] for the [IList].
  ///
  IList<T> toIList({int Function(T a, T b) compare, ConfigList config}) =>
      IList.fromISet(this, compare: compare, config: config);

  /// Returns a [Set] with all items from the [ISet].
  ///
  /// 1) If you provide a [compare] function, the resulting set will be sorted with it,
  /// and it will be a [LinkedHashSet], which is ORDERED, meaning further iteration of
  /// its items will maintain insertion order.
  ///
  /// 2) If no [compare] function is provided, the list will be sorted according to the
  /// set's [ISet.config] field:
  /// - If [ConfigSet.autoSort] is `true` (the default), the set will be sorted with
  /// `a.compareTo(b)`, in other words, with the natural order of items. This assumes the
  /// items implement [Comparable]. Otherwise, the set order is undefined.
  /// The set will be a [LinkedHashSet], which is ORDERED, meaning further iteration of
  /// its items will maintain insertion order.
  /// - If [ConfigSet.autoSort] is `false`, the set order is undefined. The set will
  /// be a [HashSet], which is NOT ordered. Note this is the same as unlocking the
  /// set with [ISet.unlock].
  ///
  @override
  Set<T> toSet({int Function(T a, T b) compare}) {
    if (compare != null) {
      var orderedList = toList(growable: false, compare: compare);
      return LinkedHashSet.of(orderedList);
    } else {
      if (config.autoSort) {
        var orderedList = toList(growable: false);
        return LinkedHashSet.of(orderedList);
      } else {
        return HashSet.of(_s);
      }
    }
  }

  @override
  String toString() => "{${_s.join(", ")}}";

  /// Returns an empty set with the same configuration.
  ISet<T> clear() => empty<T>(config);

  /// Returns whether this [ISet] contains all the elements of [other].
  bool containsAll(Iterable<Object> other) {
    // TODO: Still need to implement efficiently.
    return unlock.containsAll(other);
  }

  /// Returns a new set with the elements of this that are not in [other].
  ///
  /// That is, the returned set contains all the elements of this [ISet] that
  /// are not elements of [other] according to `other.contains`.
  ISet<T> difference(Set<Object> other) {
    // TODO: Still need to implement efficiently.
    return ISet._unsafeFromSet(unlock.difference(other), config: config);
  }

  /// Returns a new set which is the intersection between this set and [other].
  ///
  /// That is, the returned set contains all the elements of this [ISet] that
  /// are also elements of [other] according to `other.contains`.
  ISet<T> intersection(Set<Object> other) {
    // TODO: Still need to implement efficiently.
    return ISet._unsafeFromSet(unlock.intersection(other), config: config);
  }

  /// Returns a new set which contains all the elements of this set and [other].
  ///
  /// That is, the returned set contains all the elements of this [ISet] and
  /// all the elements of [other].
  ISet<T> union(Set<T> other) {
    // TODO: Still need to implement efficiently.
    return ISet._unsafeFromSet(unlock.union(other), config: config);
  }

  /// If an object equal to [object] is in the set, return it.
  ///
  /// Checks whether [object] is in the set, like [contains], and if so,
  /// returns the object in the set, otherwise returns `null`.
  ///
  /// If the equality relation used by the set is not identity,
  /// then the returned object may not be *identical* to [object].
  /// Some set implementations may not be able to implement this method.
  /// If the [contains] method is computed,
  /// rather than being based on an actual object instance,
  /// then there may not be a specific object instance representing the
  /// set element.
  T lookup(Object object) {
    // TODO: Still need to implement efficiently.
    return unlock.lookup(object);
  }

  /// Removes each element of [elements] from this set.
  ISet<T> removeAll(Iterable<Object> elements) {
    // TODO: Still need to implement efficiently.
    return ISet._unsafeFromSet(unlock..removeAll(elements), config: config);
  }

  /// Removes all elements of this set that satisfy [test].
  ISet<T> removeWhere(bool Function(T element) test) {
    // TODO: Still need to implement efficiently.
    return ISet._unsafeFromSet(unlock..removeWhere(test), config: config);
  }

  /// Removes all elements of this set that are not elements in [elements].
  /// 
  /// Checks for each element of [elements] whether there is an element in this
  /// set that is equal to it (according to `this.contains`), and if so, the
  /// equal element in this set is retained, and elements that are not equal
  /// to any element in `elements` are removed.
  ISet<T> retainAll(Iterable<Object> elements) {
    // TODO: Still need to implement efficiently.
    return ISet._unsafeFromSet(unlock..retainAll(elements), config: config);
  }

  /// Removes all elements of this set that fail to satisfy [test].
  ISet<T> retainWhere(bool Function(T element) test) {
    // TODO: Still need to implement efficiently.
    return ISet._unsafeFromSet(unlock..retainWhere(test), config: config);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

@visibleForOverriding
abstract class S<T> implements Iterable<T> {
  //

  /// The [S] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  /// Note these fallback methods need to calculate the flushed set, but
  /// because that's immutable, we **cache** it.
  Set<T> _flushed;

  /// Returns the flushed set (flushes it only once).
  /// It is an error to use the flushed map outside of the [M] class.
  Set<T> get _getFlushed {
    _flushed ??= unlock;
    return _flushed;
  }

  /// Returns a Dart [Set] (mutable, unordered, of type [HashSet]).
  HashSet<T> get unlock => HashSet.of(this);

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
  S<T> remove(T element) => !contains(element) ? this : SFlat<T>.unsafe(unlock..remove(element));

  @override
  bool get isEmpty => _getFlushed.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  bool any(bool Function(T) test) => _getFlushed.any(test);

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
  Set<T> toSet() => HashSet.of(this);

  @override
  T elementAt(int index) => throw UnsupportedError('elementAt in ISet is not allowed');
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
