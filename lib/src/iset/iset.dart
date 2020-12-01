import "dart:collection";
import "dart:math";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/base/hash.dart";
import "package:meta/meta.dart";
import "s_flat.dart";
import "s_add.dart";
import "s_add_all.dart";

/// An **immutable**, unordered set.
@immutable
class ISet<T> // ignore: must_be_immutable
    extends ImmutableCollection<ISet<T>> implements Iterable<T> {
  //
  S<T> _s;

  /// The set configuration.
  final ConfigSet config;

  /// Create an [ISet] from any [Iterable].
  /// Fast, if the Iterable is another [ISet].
  factory ISet([Iterable<T> iterable]) => //
      ISet.withConfig(iterable, defaultConfig);

  /// Create an [ISet] from any [Iterable] and a [ConfigSet].
  /// Fast, if the Iterable is another [ISet].
  factory ISet.withConfig(
    Iterable<T> iterable,
    ConfigSet config,
  ) {
    config = config ?? defaultConfig;
    return iterable is ISet<T>
        ? (config == iterable.config)
            ? iterable
            : iterable.isEmpty
                ? ISet.empty<T>(config)
                : ISet<T>._(iterable, config: config)
        : ((iterable == null) || iterable.isEmpty)
            ? ISet.empty<T>(config)
            : ISet<T>._unsafe(SFlat<T>(iterable), config: config);
  }

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

  /// Returns a new set with the contents of the present [ISet],
  /// but the config of [other].
  ISet<T> withConfigFrom(ISet<T> other) => withConfig(other.config);

  /// Unsafe constructor. Use this at your own peril.
  /// This constructor is fast, since it makes no defensive copies of the set.
  /// However, you should only use this with a new set you"ve created yourself,
  /// when you are sure no external copies exist. If the original set is modified,
  /// it will break the [ISet] and any other derived sets in unpredictable ways.
  ISet.unsafe(Set<T> set, {@required this.config})
      : _s = (set == null) ? SFlat.empty<T>() : SFlat<T>.unsafe(set) {
    if (ImmutableCollection.disallowUnsafeConstructors)
      throw UnsupportedError("ISet.unsafe is disallowed.");
  }

  /// Returns an empty [ISet], with the given configuration. If a configuration
  /// is not provided, it will use the default configuration. Note: If you want
  /// to create an empty immutable collection of the same type and same
  /// configuration as a source collection, simply call [clear] in the source
  /// collection.
  static ISet<T> empty<T>([ConfigSet config]) => ISet._unsafe(
        SFlat.empty<T>(),
        config: config ?? defaultConfig,
      );

  static void resetAllConfigurations() {
    if (ImmutableCollection.isConfigLocked)
      throw StateError(
          "Can't change the configuration of immutable collections.");
    ISet.flushFactor = _defaultFlushFactor;
    ISet.defaultConfig = _defaultConfig;
  }

  /// Global configuration that specifies if, by default, the [ISet]s
  /// use equality or identity for their [operator ==].
  /// By default `isDeepEquals: true` (sets are compared by equality)
  /// and `sort: true` (certain sets outputs are sorted).
  static ConfigSet get defaultConfig => _defaultConfig;

  /// Indicates the number of operations an [ISet] may perform
  /// before it is eligible for auto-flush. Must be larger than 0.
  static int get flushFactor => _flushFactor;

  /// Global configuration that specifies if auto-flush of [ISet]s should be
  /// async. The default is true. When the autoflush is async, it will only
  /// happen after the async gap, no matter how many operations a collection
  /// undergoes. When the autoflush is sync, it may flush one or more times
  /// during the same task.
  static bool get asyncAutoflush => _asyncAutoflush;

  static set defaultConfig(ConfigSet config) {
    if (_defaultConfig == config) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError(
          "Can't change the configuration of immutable collections.");
    _defaultConfig = config ?? const ConfigSet();
  }

  static set flushFactor(int value) {
    if (ImmutableCollection.isConfigLocked)
      throw StateError(
          "Can't change the configuration of immutable collections.");
    if (value > 0)
      _flushFactor = value;
    else
      throw StateError("flushFactor can't be $value.");
  }

  static set asyncAutoflush(bool value) {
    if (ImmutableCollection.isConfigLocked)
      throw StateError(
          "Can't change the configuration of immutable collections.");
    if (value != null) _asyncAutoflush = value;
  }

  static ConfigSet _defaultConfig = const ConfigSet();

  static const _defaultFlushFactor = 20;

  static int _flushFactor = _defaultFlushFactor;

  static bool _asyncAutoflush = true;

  int _counter = 0;

  /// Sync Auto-flush:
  /// Keeps a counter variable which starts at `0` and is incremented each
  /// time some collection methods are used.
  /// As soon as counter reaches the refresh-factor, the collection is flushed
  /// and `counter` returns to `0`.
  ///
  /// Async Auto-flush:
  /// Keeps a counter variable which starts at `0` and is incremented each
  /// time some collection methods are used, as long as `counter >= 0`.
  /// As soon as counter reaches the refresh-factor, the collection is marked
  /// for flushing. There is also a global counter called an `asyncCounter`
  /// which starts at `1`. When a collection is marked for flushing, it first
  /// creates a future to increment the `asyncCounter`. Then, the collection's
  /// own `counter` is set to be `-asyncCounter`. Having a negative value means
  /// the collection's `counter` will not be incremented anymore. However, when
  /// `counter` is negative and different from `-asyncCounter` it means we are
  /// one async gap after the collection was marked for flushing.
  /// At this point, the collection will flush and `counter` returns to zero.
  /// Note: _count is called in methods which read values. It's not called
  /// in methods which create new ISets or flush the set.
  void _count() {
    if (!ImmutableCollection.autoFlush) return;
    if (isFlushed) {
      _counter = 0;
    } else {
      if (_counter >= 0) {
        _counter++;
        if (_counter == _flushFactor) {
          if (asyncAutoflush) {
            ImmutableCollection.markAsyncCounterToIncrement();
            _counter = -ImmutableCollection.asyncCounter;
          } else {
            flush;
            _counter = 0;
          }
        }
      } else {
        if (_counter != -ImmutableCollection.asyncCounter) {
          flush;
          _counter = 0;
        }
      }
    }
  }

  /// Safe. Fast if the iterable is an ISet.
  ISet._(
    Iterable<T> iterable, {
    @required this.config,
  }) : _s = iterable is ISet<T>
            ? iterable._s
            : iterable == null
                ? SFlat.empty<T>()
                : SFlat<T>(iterable);

  /// Unsafe.
  ISet._unsafe(this._s, {@required this.config});

  /// Unsafe.
  ISet._unsafeFromSet(Set<T> set, {@required this.config})
      : _s = (set == null) ? SFlat.empty<T>() : SFlat<T>.unsafe(set);

  /// Creates a set with `identityEquals` (compares the internals by `identity`).
  ISet<T> get withIdentityEquals => config.isDeepEquals
      ? ISet._unsafe(_s, config: config.copyWith(isDeepEquals: false))
      : this;

  /// Creates a set with `deepEquals` (compares all set items by equality).
  ISet<T> get withDeepEquals => config.isDeepEquals
      ? this
      : ISet._unsafe(_s, config: config.copyWith(isDeepEquals: true));

  bool get isDeepEquals => config.isDeepEquals;

  bool get isIdentityEquals => !config.isDeepEquals;

  /// Unlocks the set, returning a regular (mutable, unordered) [Set]
  /// of type [HashSet]. This set is "safe", in the sense that is independent
  /// from the original [ISet].
  Set<T> get unlock => _s.unlock;

  /// Unlocks the map, returning a regular (mutable, ordered, sorted) [Set]
  /// of type [LinkedHashSet]. This map is "safe", in the sense that is independent
  /// from the original [ISet].
  Set<T> get unlockSorted {
    var orderedList = toList(growable: false, compare: compareObject);
    return LinkedHashSet.of(orderedList);
  }

  /// Unlocks the set, returning a safe, unmodifiable (immutable) [Set] view.
  /// The word "view" means the set is backed by the original [ISet].
  /// Using this is very fast, since it makes no copies of the [ISet] items.
  /// However, if you try to use methods that modify the set, like [add],
  /// it will throw an [UnsupportedError].
  /// It is also very fast to lock this set back into an [ISet].
  Set<T> get unlockView => UnmodifiableSetView(this);

  /// Unlocks the set, returning a safe, modifiable (mutable) [Set].
  /// Using this is very fast at first, since it makes no copies of the [ISet]
  /// items. However, if and only if you use a method that mutates the set,
  /// like [add], it will unlock internally (make a copy of all [ISet] items).
  /// This is transparent to you, and will happen at most only once. In other
  /// words, it will unlock the [ISet], lazily, only if necessary.
  /// If you never mutate the set, it will be very fast to lock this set
  /// back into an [ISet].
  Set<T> get unlockLazy => ModifiableSetView(this);

  /// 1) If the set's [config] has [ConfigSet.sort] `true` (the default),
  /// it will iterate in the natural order of items. In other words, if the
  /// items are [Comparable], they will be sorted by `a.compareTo(b)`.
  /// 2) If the set's [config] has [ConfigSet.sort] `false`, or if the items
  /// are not [Comparable], the iterator order is undefined.
  ///
  @override
  Iterator<T> get iterator {
    if (config.sort) {
      var sortedList = _s.toList(growable: false)..sort(compareObject);
      return sortedList.iterator;
    } else
      return _s.iterator;
  }

  /// This iterator is very fast to create, but won't iterate in any particular
  /// order, no matter what the set configuration is.
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
  /// since it doesn't  compare each item.
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

  /// Returns the concatenation of this set and [other].
  /// Returns a new set containing the elements of this set followed by
  /// the elements of [other].
  ISet<T> operator +(Iterable<T> other) => addAll(other);

  /// Will return true only if the ISet has the same number of items as the
  /// iterable, and the ISet items are equal to the iterable items, in whatever
  /// order. This may be slow for very large sets, since it compares each item,
  /// one by one.
  @override
  bool equalItems(covariant Iterable<T> other) {
    if (identical(this, other)) return true;

    if (other is ISet<T>) {
      if (_isUnequalByHashCode(other)) return false;
      return (flush._s as SFlat<T>).deepSetEquals(other.flush._s as SFlat<T>);
    }

    return (other == null)
        ? false
        : (flush._s as SFlat<T>).deepSetEquals_toIterable(other);
  }

  @override
  bool equalItemsAndConfig(ISet<T> other) {
    if (identical(this, other)) return true;

    // Objects with different hashCodes are not equal.
    if (_isUnequalByHashCode(other)) return false;

    return runtimeType == other.runtimeType &&
        config == other.config &&
        (identical(_s, other._s) ||
            (flush._s as SFlat<T>).deepSetEquals(other.flush._s as SFlat<T>));
  }

  /// Return true if other is null or the cached hashCodes proves the
  /// collections are NOT equal.
  /// Explanation: Objects with different hashCodes are not equal. However,
  /// if the hashCodes are the same, then nothing can be said about the equality.
  /// Note: We use the CACHED hashCodes. If any of the hashCodes is null it
  /// means we don't have this information yet, and we don't calculate it.
  bool _isUnequalByHashCode(ISet<T> other) {
    return (other == null) ||
        (_hashCode != null &&
            other._hashCode != null &&
            _hashCode != other._hashCode);
  }

  /// Will return true only if the sets internals are the same instances
  /// (comparing by identity). This will be fast even for very large sets,
  /// since it doesn't  compare each item.
  /// Note: This is not the same as `identical(set1, set2)` since it doesn't
  /// compare the sets themselves, but their internal state. Comparing the
  /// internal state is better, because it will return true more often.
  @override
  bool same(ISet<T> other) =>
      identical(_s, other._s) && (config == other.config);

  // HashCode cache. Must be null if hashCode is not cached.
  int _hashCode;

  @override
  int get hashCode {
    if (_hashCode != null) return _hashCode;

    var hashCode = isDeepEquals //
        ? hash2((flush._s as SFlat<T>).deepSetHashcode(), config.hashCode)
        : hash2(identityHashCode(_s), config.hashCode);

    if (config.cacheHashCode) _hashCode = hashCode;

    return hashCode;
  }

  /// Flushes the set, if necessary. Chainable method.
  /// If the set is already flushed, don't do anything.
  @override
  ISet<T> get flush {
    if (!isFlushed) {
      // Flushes the original _s because maybe it's used elsewhere.
      // Or maybe it was flushed already, and we can use it as is.
      _s = SFlat<T>.unsafe(_s.getFlushed);
      _counter = 0;
    }
    return this;
  }

  /// Whether this set is already flushed or not.
  @override
  bool get isFlushed => _s is SFlat;

  /// Returns a new set containing the current set plus the given item.
  ISet<T> add(T item) {
    var result = ISet<T>._unsafe(_s.add(item), config: config);

    // A set created with `add` has a larger counter than its source set.
    // This improves the order in which sets are flushed.
    // If the outer set is used, it will be flushed before the source set.
    // If the source set is not used directly, it will not flush unnecessarily,
    // and also may be garbage collected.
    result._counter = _counter + 1;

    return result;
  }

  /// Returns a new set containing the current set plus all the given items.
  ISet<T> addAll(Iterable<T> items) {
    var result = ISet<T>._unsafe(_s.addAll(items), config: config);

    // A set created with `addAll` has a larger counter than both its source
    // sets. This improves the order in which sets are flushed.
    // If the outer set is used, it will be flushed before the source sets.
    // If the source sets are not used directly, they will not flush
    // unnecessarily, and also may be garbage collected.
    result._counter =
        max(_counter, ((items is ISet<T>) ? items._counter : 0)) + 1;

    return result;
  }

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

  @override
  bool any(bool Function(T) test) {
    _count();
    return _s.any(test);
  }

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
    return (result is S<R>)
        ? ISet._unsafe(result, config: config)
        : ISet._(result, config: config);
  }

  @override
  bool contains(Object element) {
    _count();
    return _s.contains(element);
  }

  @override
  T elementAt(int index) =>
      throw UnsupportedError("elementAt in ISet is not allowed");

  @override
  bool every(bool Function(T) test) {
    _count();
    return _s.every(test);
  }

  @override
  ISet<E> expand<E>(Iterable<E> Function(T) f, {ConfigSet config}) =>
      ISet._(_s.expand(f),
          config: config ?? (T == E ? this.config : defaultConfig));

  @override
  int get length {
    final int length = _s.length;

    /// Optimization: Flushes the set, if free.
    if (length == 0 && _s is! SFlat)
      _s = SFlat.empty<T>();
    else
      _count();

    return length;
  }

  /// 1) If the set's [config] has [ConfigSet.sort] `true` (the default),
  /// will return the first element in the natural order of items.
  /// 2) If the set's [config] has [ConfigSet.sort] `false`, or if the items
  /// are not [Comparable], any item may be returned.
  /// Note: This method is not efficient, as `ISets` are not naturally sorted.
  @override
  T get first {
    _count();

    if (config.sort) {
      bool initial = true;
      T result;
      for (T item in _s) {
        if (initial) {
          initial = false;
          result = item;
        } else if (compareObject(result, item) > 0) result = item;
      }
      return result;
    } else
      return _s.first;
  }

  /// 1) If the set's [config] has [ConfigSet.sort] `true` (the default),
  /// will return the last element in the natural order of items.
  /// 2) If the set's [config] has [ConfigSet.sort] `false`, or if the items
  /// are not [Comparable], any item may be returned.
  /// Note: This method is not efficient, as `ISets` are not naturally sorted.
  @override
  T get last {
    _count();

    if (config.sort) {
      bool initial = true;
      T result;
      for (T item in _s) {
        if (initial) {
          initial = false;
          result = item;
        } else if (compareObject(result, item) < 0) result = item;
      }
      return result;
    } else
      return _s.last;
  }

  /// Checks that this iterable has only one element, and returns that element.
  /// Throws a [StateError] if the set is empty or has more than one element.
  @override
  T get single => _s.single;

  /// Returns the first element, or `null` if the set is empty.
  T get firstOrNull => firstOr(null);

  /// Returns the last element, or `null` if the set is empty.
  T get lastOrNull => lastOr(null);

  /// Checks that the set has only one element, and returns that element.
  /// Return `null` if the set is empty or has more than one element.
  T get singleOrNull => singleOr(null);

  /// Returns the first element, or [orElse] if the set is empty.
  T firstOr(T orElse) => isEmpty ? orElse : first;

  /// Returns the last element, or [orElse] if the set is empty.
  T lastOr(T orElse) => isEmpty ? orElse : last;

  /// Checks if the set has only one element, and returns that element.
  /// Return `null` if the set is empty or has more than one element.
  T singleOr(T orElse) => (length != 1) ? orElse : single;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) {
    _count();
    return _s.firstWhere(test, orElse: orElse);
  }

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) {
    _count();
    return _s.fold(initialValue, combine);
  }

  @override
  ISet<T> followedBy(Iterable<T> other) =>
      ISet._(_s.followedBy(other), config: config);

  @override
  void forEach(void Function(T element) f) {
    _count();
    _s.forEach(f);
  }

  @override
  String join([String separator = ""]) =>
      config.sort ? toSet().join(separator) : _s.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) {
    _count();
    return _s.lastWhere(test, orElse: orElse);
  }

  @override
  ISet<E> map<E>(E Function(T element) f, {ConfigSet config}) {
    _count();
    return ISet._(_s.map(f),
        config: config ?? (T == E ? this.config : defaultConfig));
  }

  @override
  T reduce(T Function(T value, T element) combine) {
    _count();
    return _s.reduce(combine);
  }

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) {
    _count();
    return _s.singleWhere(test, orElse: orElse);
  }

  @override
  ISet<T> skip(int count) => ISet._(_s.skip(count), config: config);

  @override
  ISet<T> skipWhile(bool Function(T value) test) =>
      ISet._(_s.skipWhile(test), config: config);

  @override
  ISet<T> take(int count) => ISet._(_s.take(count), config: config);

  @override
  ISet<T> takeWhile(bool Function(T value) test) =>
      ISet._(_s.takeWhile(test), config: config);

  @override
  ISet<T> where(bool Function(T element) test) =>
      ISet._(_s.where(test), config: config);

  @override
  ISet<E> whereType<E>() => ISet._(_s.whereType<E>(), config: config);

  /// Returns a [List] with all items from the set.
  ///
  /// 1) If you provide a [compare] function, the list will be sorted with it.
  ///
  /// 2) If no [compare] function is provided, the list will be sorted according to the
  /// set's [config] field:
  /// - If [ConfigSet.sort] is `true` (the default), the list will be sorted with
  /// `a.compareTo(b)`, in other words, with the natural order of items. This assumes the
  /// items implement [Comparable]. Otherwise, the list order is undefined.
  /// - If [ConfigSet.sort] is `false`, the list order is undefined.
  ///
  @override
  List<T> toList({bool growable = true, int Function(T a, T b) compare}) {
    _count();
    var result = _s.toList(growable: growable);

    if (compare != null) {
      result.sort(compare);
    } else {
      if (config.sort) result.sort(compare ?? compareObject);
    }

    return result;
  }

  /// Returns a [IList] with all items from the set.
  ///
  /// 1) If you provide a [compare] function, the list will be sorted with it.
  ///
  /// 2) If no [compare] function is provided, the list will be sorted
  /// according to the set's [ISet.config] field:
  /// - If [ConfigSet.sort] is `true` (the default), the list will be sorted
  /// with `a.compareTo(b)`, in other words, with the natural order of items.
  /// This assumes the items implement [Comparable]. Otherwise, the list order
  /// is undefined.
  /// - If [ConfigSet.sort] is `false`, the list order is undefined.
  ///
  /// You can also provide a [config] for the [IList].
  ///
  IList<T> toIList({int Function(T a, T b) compare, ConfigList config}) {
    _count();
    return IList.fromISet(this, compare: compare, config: config);
  }

  /// Returns a [Set] with all items from the [ISet].
  ///
  /// 1) If you provide a [compare] function, the resulting set will be sorted with it,
  /// and it will be a [LinkedHashSet], which is ORDERED, meaning further iteration of
  /// its items will maintain insertion order.
  ///
  /// 2) If no [compare] function is provided, the list will be sorted according to the
  /// set's [ISet.config] field:
  /// - If [ConfigSet.sort] is `true` (the default), the set will be sorted with
  /// `a.compareTo(b)`, in other words, with the natural order of items. This assumes the
  /// items implement [Comparable]. Otherwise, the set order is undefined.
  /// The set will be a [LinkedHashSet], which is ORDERED, meaning further iteration of
  /// its items will maintain insertion order.
  /// - If [ConfigSet.sort] is `false`, the set order is undefined. The set will
  /// be a [HashSet], which is NOT ordered. Note this is the same as unlocking the
  /// set with [ISet.unlock].
  ///
  @override
  Set<T> toSet({int Function(T a, T b) compare}) {
    _count();

    if (compare != null) {
      var orderedList = toList(growable: false, compare: compare);
      return LinkedHashSet.of(orderedList);
    } else {
      if (config.sort) {
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
    _count();
    // TODO: Still need to implement efficiently.
    return unlock.containsAll(other);
  }

  /// Returns a new set with the elements of this that are not in [other].
  ///
  /// That is, the returned set contains all the elements of this [ISet] that
  /// are not elements of [other] according to `other.contains`.
  ISet<T> difference(Set<Object> other) {
    _count();
    // TODO: Still need to implement efficiently.
    return ISet._unsafeFromSet(unlock.difference(other), config: config);
  }

  /// Returns a new set which is the intersection between this set and [other].
  ///
  /// That is, the returned set contains all the elements of this [ISet] that
  /// are also elements of [other] according to `other.contains`.
  ISet<T> intersection(Set<Object> other) {
    _count();
    // TODO: Still need to implement efficiently.
    return ISet._unsafeFromSet(unlock.intersection(other), config: config);
  }

  /// Returns a new set which contains all the elements of this set and [other].
  ///
  /// That is, the returned set contains all the elements of this [ISet] and
  /// all the elements of [other].
  ISet<T> union(Set<T> other) {
    _count();
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
    _count();
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

// /////////////////////////////////////////////////////////////////////////////

@visibleForOverriding
abstract class S<T> implements Iterable<T> {
  //

  /// The [S] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  /// Note these fallback methods need to calculate the flushed set, but
  /// because that"s immutable, we **cache** it.
  Set<T> _flushed;

  /// Returns the flushed set (flushes it only once).
  /// It is an error to use the flushed set outside of the [S] class.
  Set<T> get getFlushed {
    // Note: Flush must be of type LinkedHashSet. It can't sort, but
    // the flush is not suppose to change the order of the items.
    _flushed ??= LinkedHashSet.of(this);
    return _flushed;
  }

  /// Returns a Dart [Set] (mutable, unordered, of type [HashSet]).
  HashSet<T> get unlock => HashSet.of(this);

  /// Returns a new `Iterator` that allows iterating the items of the [IList].
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

  // TODO: Still need to implement efficiently.
  S<T> remove(T element) =>
      !contains(element) ? this : SFlat<T>.unsafe(unlock..remove(element));

  @override
  bool get isEmpty => getFlushed.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  bool any(bool Function(T) test) => getFlushed.any(test);

  @override
  Iterable<R> cast<R>() => getFlushed.cast<R>();

  @override
  bool contains(Object element);

  @override
  bool every(bool Function(T) test) => getFlushed.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => getFlushed.expand(f);

  @override
  int get length => getFlushed.length;

  @override
  T get first => getFlushed.first;

  @override
  T get last => getFlushed.last;

  @override
  T get single => getFlushed.single;

  @override
  T firstWhere(bool Function(T) test, {T Function() orElse}) =>
      getFlushed.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      getFlushed.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => getFlushed.followedBy(other);

  @override
  void forEach(void Function(T element) f) => getFlushed.forEach(f);

  @override
  String join([String separator = ""]) => getFlushed.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      getFlushed.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T element) f) => getFlushed.map(f);

  @override
  T reduce(T Function(T value, T element) combine) =>
      getFlushed.reduce(combine);

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      getFlushed.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => getFlushed.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) =>
      getFlushed.skipWhile(test);

  @override
  Iterable<T> take(int count) => getFlushed.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) =>
      getFlushed.takeWhile(test);

  @override
  Iterable<T> where(bool Function(T element) test) => getFlushed.where(test);

  @override
  Iterable<E> whereType<E>() => getFlushed.whereType<E>();

  @override
  List<T> toList({bool growable = true}) => List.of(this, growable: growable);

  @override
  Set<T> toSet() => HashSet.of(this);

  @override
  T elementAt(int index) =>
      throw UnsupportedError("elementAt in ISet is not allowed");
}

// /////////////////////////////////////////////////////////////////////////////

/// Don't use this class.
@visibleForTesting
class InternalsForTestingPurposesISet {
  ISet iset;

  InternalsForTestingPurposesISet(this.iset);

  /// To access the private counter, add this to the test file:
  ///
  /// ```dart
  /// extension TestExtension on ISet {
  ///   int get counter => InternalsForTestingPurposesISet(this).counter;
  /// }
  /// ```
  int get counter => iset._counter;
}

// /////////////////////////////////////////////////////////////////////////////
