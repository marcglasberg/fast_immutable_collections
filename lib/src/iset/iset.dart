// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:collection";
import "dart:math";

import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/base/hash.dart";
import "package:meta/meta.dart";

import "s_add.dart";
import "s_add_all.dart";
import "s_flat.dart";

/// This is an [ISet] which is always empty.
@immutable
class ISetEmpty<T> // ignore: must_be_immutable
    extends ISet<T> {
  /// Creates an empty set. In most cases, you should use `const ISet.empty()`.
  ///
  /// IMPORTANT: You must always use the `const` keyword.
  /// It's always wrong to use an `ISetEmpty()` which is not constant.
  @literal
  const ISetEmpty._([this.config = const ConfigSet()]) : super._gen();

  @override
  final ConfigSet config;

  /// An empty set is always flushed, by definition.
  @override
  bool get isFlushed => true;

  /// Nothing happens when you flush a empty set, by definition.
  @override
  ISetEmpty<T> get flush => this;

  /// An empty set is always empty, by definition
  @override
  bool get isEmpty => true;

  /// An empty set is always empty, by definition
  @override
  bool get isNotEmpty => false;

  /// An empty set does not contain anything, by definition
  @override
  bool contains(covariant T? element) => false;

  /// An empty set is always of length `0`, by definition
  @override
  int get length => 0;

  /// An empty set has no first element, by definition
  @override
  Never get first => throw StateError("No element");

  /// An empty set has no last element, by definition
  @override
  Never get last => throw StateError("No element");

  /// An empty set has no single element, by definition
  @override
  Never get single => throw StateError("No element");

  /// An empty set is always the cleared version of itself, by definition
  @override
  ISetEmpty<T> clear() => this;

  @override
  int get _counter => 0;

  @override
  S<T> get _s => SFlat<T>.unsafe({});

  /// Hash codes must be the same for objects that are equal to each other
  /// according to operator ==.
  @override
  int? get _hashCode {
    return isDeepEquals
        ? hash2(const SetEquality<dynamic>().hash({}), config.hashCode)
        : hash2(identityHashCode(_s), config.hashCode);
  }

  @override
  set _hashCode(int? value) {}

  @override
  bool same(ISet<T>? other) =>
      (other != null) &&
      (other is ISetEmpty || (other is ISetConst && (other as ISetConst)._set.isEmpty)) &&
      (config == other.config);
}

/// This is an [ISet] which can be made constant.
/// Note: Don't ever use it without the "const" keyword, because it will be unsafe.
///
/// The const ISet will always keep insertion order. In other words, you can't make
/// the sort configuration `true`.
///
@immutable
class ISetConst<T> // ignore: must_be_immutable
    extends ISet<T> {
  //
  /// To create an empty constant ISet: `const ISetConst({})`.
  /// To create a constant set with items: `const ISetConst({1, 2, 3})`.
  ///
  /// IMPORTANT: You must always use the `const` keyword.
  /// It's always wrong to use an `ISetConst` which is not constant.
  ///
  @literal
  const ISetConst(this._set,
      // Note: The _set can't be optional. This doesn't work: [this._set = const {}]
      // because when you do this _set will be Set<Never> which is bad.
      [this.config = const ConfigSet()])
      : super._gen();

  final Set<T> _set;

  @override
  final ConfigSet config;

  /// A constant set is always flushed, by definition.
  @override
  bool get isFlushed => true;

  /// Nothing happens when you flush a constant set, by definition.
  @override
  ISetConst<T> get flush => this;

  @override
  int get _counter => 0;

  @override
  S<T> get _s {
    if (config.sort && _set.isNotEmpty)
      throw UnsupportedError("Can't use a const ISet unless it's empty.");
    return SFlat<T>.unsafe(_set);
  }

  /// Hash codes must be the same for objects that are equal to each other
  /// according to operator ==.
  @override
  int? get _hashCode {
    return isDeepEquals
        ? hash2(const SetEquality<dynamic>().hash(_set), config.hashCode)
        : hash2(identityHashCode(_s), config.hashCode);
  }

  @override
  set _hashCode(int? value) {}

  @override
  bool same(ISet<T>? other) =>
      (other != null) &&
      (((other is ISetConst) && identical(_set, (other as ISetConst)._set)) ||
          (((other is ISetEmpty) && _set.isEmpty))) &&
      (config == other.config);
}

@immutable
class ISetImpl<T> // ignore: must_be_immutable
    extends ISet<T> {
  //
  /// The set configuration ([ConfigSet]).
  @override
  final ConfigSet config;

  @override
  late S<T> _s;

  @override
  int _counter = 0;

  @override
  // ignore: use_late_for_private_fields_and_variables
  int? _hashCode;

  /// Flushes the set, if necessary. Chainable method.
  /// If the set is already flushed, don't do anything.
  @override
  ISet<T> get flush {
    if (!isFlushed) {
      // Flushes the original _s because maybe it's used elsewhere.
      // Or maybe it was flushed already, and we can use it as is.
      _s = SFlat<T>.unsafe(_s.getFlushed(config));
      _counter = 0;
    }
    return this;
  }

  ISetImpl.unsafe(Set<T> set, {required this.config})
      : _s = SFlat<T>.unsafe(set),
        super._gen() {
    if (ImmutableCollection.disallowUnsafeConstructors)
      throw UnsupportedError("ISet.unsafe is disallowed.");
  }

  /// **Unsafe**.
  ISetImpl._unsafe(this._s, {required this.config}) : super._gen();

  /// **Unsafe**.
  ISetImpl._unsafeFromSet(Set<T> set, {required this.config})
      : _s = SFlat<T>.unsafe(set),
        super._gen();

  /// Returns an empty [ISet], with the given configuration. If a
  /// configuration is not provided, it will use the default configuration.
  ///
  /// Note: If you want to create an empty immutable collection of the same
  /// type and same configuration as a source collection, simply call [clear]
  /// on the source collection.
  static ISetImpl<T> empty<T>([ConfigSet? config]) =>
      ISetImpl._unsafe(SFlat.empty<T>(), config: config ?? ISet.defaultConfig);

  /// **Safe**. Fast if the [Iterable] is an [ISet].
  ISetImpl._(
    Iterable<T>? iterable, {
    required this.config,
  })  : _s = iterable is ISet<T> //
            ? iterable._s
            : iterable == null
                ? SFlat.empty<T>()
                : SFlat<T>(iterable),
        super._gen();
}

/// An **immutable**, **ordered** set.
/// It can be configured to order by insertion order, or sort.
///
/// You can access its items by index, as efficiently as with a [List],
/// by calling `ISet.elementAt(index)` or by using the `[]` operator.
///
@immutable
abstract class ISet<T> // ignore: must_be_immutable
    extends ImmutableCollection<ISet<T>> implements Iterable<T> {
  //
  /// The set configuration.
  ConfigSet get config;

  S<T> get _s;

  set _s(S<T> value) {}

  int get _counter;

  set _counter(int value) {}

  int? get _hashCode;

  set _hashCode(int? value);

  /// Create an [ISet] from an [iterable], with the default configuration.
  /// Fast, if the iterable is another [ISet].
  ///
  /// To create an empty [ISet] with the default configuration, just omit
  /// the iterable: `ISet()`.
  ///
  /// Note: To create an [ISet] with a specific configuration, use the `ISet.withConfig()`
  /// constructor.
  ///
  /// Note: If you want to create an empty [ISet] of the same configuration as a
  /// source [ISet], simply call [clear] on the source [ISet].
  ///
  factory ISet([Iterable<T>? iterable]) => //
      ISet.withConfig(iterable, defaultConfig);

  /// Create an empty [ISet].
  /// Use it with const: `const ISet.empty()` (It's always an [ISetEmpty]).
  @literal
  const factory ISet.empty() = ISetEmpty<T>._;

  const ISet._gen();

  /// Create an [ISet] from any [Iterable] and a [ConfigSet].
  /// Fast, if the Iterable is another [ISet].
  /// If [iterable] is null, return an empty [ISet].
  factory ISet.withConfig(
    Iterable<T>? iterable,
    ConfigSet config,
  ) {
    return ((iterable is ISet<T>) && (iterable.isOfExactGenericType(T)))
        ? (config == iterable.config)
            ? iterable
            : iterable.isEmpty
                ? ISetImpl.empty<T>(config)
                : ISetImpl<T>._(iterable, config: config)
        : (iterable == null)
            ? ISetImpl.empty<T>(config)
            : ISetImpl<T>._unsafe(SFlat<T>(iterable, config: config), config: config);
  }

  /// Creates a new set with the given [config].
  ///
  /// To copy the config from another [ISet]:
  ///
  /// ```dart
  /// set = set.withConfig(other.config)
  /// ```
  ///
  /// To change the current config:
  ///
  /// ```dart
  /// set = set.withConfig(set.config.copyWith(isDeepEquals: isDeepEquals))
  /// ```
  ///
  /// See also: [withIdentityEquals] and [withDeepEquals].
  ///
  @useResult
  ISet<T> withConfig(ConfigSet config) {
    if (config == this.config)
      return this;
    else {
      // If the new config is not sorted it can use sorted or not sorted.
      // If the new config is sorted it can only use sorted.
      if (!config.sort || this.config.sort)
        return ISetImpl._unsafe(_s, config: config);
      //
      // If the new config is sorted and the previous is not, it must sort.
      else
        return ISetImpl._unsafe(SFlat(_s, config: config), config: config);
    }
  }

  /// Returns a new set with the contents of the present [ISet],
  /// but the config of [other].
  @useResult
  ISet<T> withConfigFrom(ISet<T> other) => withConfig(other.config);

  /// Creates a set in which the items are computed from the [iterable].
  ///
  /// For each element of the [iterable] it computes another iterable of items
  /// by applying [mapper]. The items of this resulting iterable will be added
  /// to the set.
  ///
  @useResult
  static ISet<T> fromIterable<T, I>(
    Iterable<I> iterable, {
    required Iterable<T>? Function(I) mapper,
    ConfigSet? config,
  }) {
    config ??= defaultConfig;
    final result =
        ListSet.of(iterable.expand(mapper as Iterable<T> Function(I)), sort: config.sort);
    return ISetImpl<T>._unsafeFromSet(result, config: config);
  }

  /// **Unsafe constructor**. Use this at your own peril.
  ///
  /// This constructor is fast, since it makes no defensive copies of the set.
  /// However, you should only use this with a new set you've created yourself,
  /// when you are sure no external copies exist. If the original set is modified,
  /// it will break the [ISet] and any other derived sets in unpredictable ways.
  ///
  /// Also, if [config] is [ConfigSet.sort] `true`, it assumes you will pass it a
  /// sorted set. It will not sort the set for you. In this case, if [set] is
  /// not sorted, it will break the [ISet] and any other derived sets in unpredictable
  /// ways.
  ///
  factory ISet.unsafe(Set<T> set, {required ConfigSet config}) =>
      ISetImpl.unsafe(set, config: config);

  /// If [Iterable] is `null`, return `null`.
  ///
  /// Otherwise, create an [ISet] from the [Iterable].
  /// Fast, if the [Iterable] is another [ISet].
  ///
  /// This static factory is useful for implementing a `copyWith` method
  /// that accept an [Iterable]. For example:
  ///
  /// ```dart
  /// ISet<String> names;
  ///
  /// Students copyWith({Iterable<String>? names}) =>
  ///   Students(names: ISet.orNull(names) ?? this.names);
  /// ```
  ///
  /// Of course, if your `copyWith` accepts an [ISet], this is not necessary:
  ///
  /// ```dart
  /// ISet<String> names;
  ///
  /// Students copyWith({ISet<String>? names}) =>
  ///   Students(names: names ?? this.names);
  /// ```
  ///
  @useResult
  static ISet<T>? orNull<T>(
    Iterable<T>? iterable, [
    ConfigSet? config,
  ]) =>
      (iterable == null) ? null : ISet.withConfig(iterable, config ?? defaultConfig);

  /// Converts from JSon. Json serialization support for json_serializable with @JsonSerializable.
  factory ISet.fromJson(dynamic json, T Function(Object?) fromJsonT) =>
      ISet<T>((json as Iterable).map(fromJsonT));

  /// Converts to JSon. Json serialization support for json_serializable with @JsonSerializable.
  Object toJson(Object? Function(T) toJsonT) => map(toJsonT).toList();

  /// See also: [ImmutableCollection], [ImmutableCollection.lockConfig],
  /// [ImmutableCollection.isConfigLocked],[flushFactor], [defaultConfig]
  static void resetAllConfigurations() {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    ISet.flushFactor = _defaultFlushFactor;
    ISet.defaultConfig = _defaultConfig;
  }

  /// Global configuration that specifies if, by default, the [ISet]s
  /// use equality or identity for their [operator ==].
  ///
  /// By default `isDeepEquals: true` (sets are compared by equality)
  /// and `sort: false` (when `true`, certain outputs are sorted).
  static ConfigSet get defaultConfig => _defaultConfig;

  /// Indicates the number of operations an [ISet] may perform
  /// before it is eligible for auto-flush. Must be larger than 0.
  static int get flushFactor => _flushFactor;

  /// See also: [ConfigList], [ImmutableCollection], [resetAllConfigurations]
  static set defaultConfig(ConfigSet config) {
    if (_defaultConfig == config) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _defaultConfig = config;
  }

  /// See also: [ImmutableCollection]
  static set flushFactor(int value) {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    if (value > 0)
      _flushFactor = value;
    else
      throw StateError("flushFactor can't be $value.");
  }

  static ConfigSet _defaultConfig = const ConfigSet();

  static const _defaultFlushFactor = 50;

  static int _flushFactor = _defaultFlushFactor;

  /// ## Auto-flush
  ///
  /// Keeps a counter variable which starts at `0` and is incremented each
  /// time collection methods are used. As soon as counter reaches the
  /// refresh-factor, the collection is flushed and `counter` returns to `0`.
  ///
  /// Note: [_count] is called in all methods that change, and some that read.
  /// It's not called in methods which create new [ILists] or flush the list.
  void _count() {
    if (!ImmutableCollection.autoFlush) return;
    if (isFlushed) {
      _counter = 0;
    } else {
      _counter++;
      if (_counter >= _flushFactor) {
        flush;
        _counter = 0;
      }
    }
  }

  /// **Unsafe**. Note: Does not sort.
  factory ISet._unsafe(S<T> _s, {required ConfigSet config}) =>
      ISetImpl._unsafe(_s, config: config);

  /// **Unsafe**. Note: Does not sort.
  factory ISet._unsafeFromSet(Set<T> set, {required ConfigSet config}) =>
      ISetImpl._unsafeFromSet(set, config: config);

  /// Creates a set with `identityEquals` (compares the internals by `identity`).
  @useResult
  ISet<T> get withIdentityEquals =>
      config.isDeepEquals ? ISet._unsafe(_s, config: config.copyWith(isDeepEquals: false)) : this;

  /// Creates a set with `deepEquals` (compares all set items by equality).
  @useResult
  ISet<T> get withDeepEquals =>
      config.isDeepEquals ? this : ISet._unsafe(_s, config: config.copyWith(isDeepEquals: true));

  /// See also: [ConfigList]
  bool get isDeepEquals => config.isDeepEquals;

  /// See also: [ConfigList]
  bool get isIdentityEquals => !config.isDeepEquals;

  /// Unlocks the set, returning a regular (*mutable, ordered*) [Set]
  /// of type [LinkedHashSet]. This set is "safe", in the sense that is independent
  /// from the original [ISet].
  Set<T> get unlock => _s.unlock;

  /// Unlocks the set, returning a safe, unmodifiable (immutable) [Set] view.
  /// The word "view" means the set is backed by the original [ISet].
  /// Using this is very fast, since it makes no copies of the [ISet] items.
  /// However, if you try to use methods that modify the set, like [add],
  /// it will throw an [UnsupportedError].
  /// It is also very fast to lock this set back into an [ISet].
  ///
  /// See also: [UnmodifiableSetFromISet]
  Set<T> get unlockView => UnmodifiableSetFromISet(this);

  /// Unlocks the set, returning a safe, modifiable (mutable) [Set].
  /// Using this is very fast at first, since it makes no copies of the [ISet]
  /// items. However, if and only if you use a method that mutates the set,
  /// like [add], it will unlock internally (make a copy of all [ISet] items).
  /// This is transparent to you, and will happen at most only once. In other
  /// words, it will unlock the [ISet], lazily, only if necessary.
  /// If you never mutate the set, it will be very fast to lock this set
  /// back into an [ISet].
  ///
  /// See also: [ModifiableSetFromISet]
  Set<T> get unlockLazy => ModifiableSetFromISet(this);

  /// 1. If the set's [config] has [ConfigSet.sort] `true`, it will iterate in
  /// the natural order of items. In other words, if the items are [Comparable],
  /// they will be sorted by `a.compareTo(b)`.
  /// 2. If the set's [config] has [ConfigSet.sort] `false` (the default), or
  /// if the items are not [Comparable], the [iterator] order is the insertion order.
  ///
  @override
  Iterator<T> get iterator => _s.iterator;

  /// Returns `true` if there are no elements in this collection.
  @override
  bool get isEmpty => _s.isEmpty;

  /// Returns `true` if there is at least one element in this collection.
  @override
  bool get isNotEmpty => !isEmpty;

  /// - If [isDeepEquals] configuration is `true`:
  /// Will return `true` only if the set items are equal (and in the same order),
  /// and the set configurations are equal. This may be slow for very
  /// large sets, since it compares each item, one by one.
  ///
  /// - If [isDeepEquals] configuration is `false`:
  /// Will return `true` only if the sets internals are the same instances
  /// (comparing by identity). This will be fast even for very large sets,
  /// since it doesn't  compare each item.
  ///
  /// Note: This is not the same as `identical(set1, set2)` since it doesn't
  /// compare the sets themselves, but their internal state. Comparing the
  /// internal state is better, because it will return true more often.
  ///
  @override
  bool operator ==(Object other) => (other is ISet) && isDeepEquals
      ? equalItemsAndConfig(other)
      : (other is ISet<T>) && same(other);

  /// Returns the concatenation of this set and [other].
  /// Returns a new set containing the elements of this set followed by
  /// the elements of [other].
  @useResult
  ISet<T> operator +(Iterable<T> other) => addAll(other);

  /// Will return `true` only if the [ISet] has the same number of items as the
  /// iterable, and the [ISet] items are equal to the iterable items, in whatever
  /// order. This may be slow for very large sets, since it compares each item,
  /// one by one.
  @override
  bool equalItems(covariant Iterable? other) {
    if (other == null) return false;
    if (identical(this, other)) return true;

    if (other is ISet) {
      if (_isUnequalByHashCode(other)) return false;
      return (flush._s as SFlat).deepSetEquals(other.flush._s as SFlat);
    }

    return (flush._s as SFlat<T>).deepSetEqualsToIterable(other);
  }

  /// Will return `true` only if the [ISet] and the iterable items have the same number of elements,
  /// and the elements of the [ISet] can be paired with the elements of the iterable, so that each
  /// pair is equal. This may be slow for very large sets, since it compares each item,
  /// one by one.
  bool unorderedEqualItems(covariant Iterable? other) {
    if (other == null) return false;
    if (identical(this, other) || (other is ISet<T> && same(other))) return true;
    return const UnorderedIterableEquality<dynamic>().equals(_s, other);
  }

  /// Will return `true` only if the set items are equal and the set configurations are equal.
  /// This may be slow for very large sets, since it compares each item, one by one.
  @override
  bool equalItemsAndConfig(ISet? other) {
    if (identical(this, other)) return true;

    // Objects with different hashCodes are not equal.
    if (_isUnequalByHashCode(other)) return false;

    return config == other!.config &&
        (identical(_s, other._s) || (flush._s as SFlat).deepSetEquals(other.flush._s as SFlat));
  }

  /// Return `true` if other is `null` or the cached [hashCode]s proves the
  /// collections are **NOT** equal.
  ///
  /// Explanation: Objects with different [hashCode]s are not equal. However,
  /// if the hashCodes are the same, then nothing can be said about the equality.
  ///
  /// Note: We use the **CACHED** hashCodes. If any of the hashCodes is null it
  /// means we don't have this information yet, and we don't calculate it.
  bool _isUnequalByHashCode(ISet? other) {
    return (other == null) ||
        (_hashCode != null && other._hashCode != null && _hashCode != other._hashCode);
  }

  /// Will return `true` if the sets internals are the same instances
  /// (comparing by identity). This will be fast even for very large sets,
  /// since it doesn't  compare each item.
  ///
  /// May can also return `true` under some other situations where it's very
  /// cheap to determine that the sets are equal even if the sets internals
  /// are NOT the same.
  ///
  /// Note: This is not the same as `identical(set1, set2)` since it doesn't
  /// compare the sets themselves, but their internal state. Comparing the
  /// internal state is better, because it will return true more often.
  @override
  bool same(ISet<T>? other) =>
      (other != null) && identical(_s, other._s) && (config == other.config);

  @override
  int get hashCode {
    if (_hashCode != null) return _hashCode!;

    final hashCode = isDeepEquals //
        ? hash2((flush._s as SFlat<T>).deepSetHashcode(), config.hashCode)
        : hash2(identityHashCode(_s), config.hashCode);

    if (config.cacheHashCode) _hashCode = hashCode;

    return hashCode;
  }

  /// Flushes the set, if necessary. Chainable method.
  /// If the set is already flushed, don't do anything.
  @override
  ISet<T> get flush;

  /// Whether this set is already flushed or not.
  @override
  bool get isFlushed => _s is SFlat;

  /// Returns a new set containing the current set plus the given item.
  @useResult
  ISet<T> add(T item) {
    final ISet<T> result = config.sort
        ? ISet._unsafe(SFlat(_s.followedBy([item]), config: config), config: config)
        : ISet<T>._unsafe(_s.add(item), config: config);

    // A set created with `add` has a larger counter than its source set.
    // This improves the order in which sets are flushed.
    // If the outer set is used, it will be flushed before the source set.
    // If the source set is not used directly, it will not flush unnecessarily,
    // and also may be garbage collected.
    result._counter = _counter;
    result._count();

    return result;
  }

  /// Returns a new set containing the current set plus all the given items.
  @useResult
  ISet<T> addAll(Iterable<T>? items) {
    ISet<T> result;
    result = config.sort
        ? ISet._unsafe(SFlat(_s.followedBy(items!), config: config), config: config)
        : ISet<T>._unsafe(_s.addAll(items!), config: config);

    // A set created with `addAll` has a larger counter than both its source
    // sets. This improves the order in which sets are flushed.
    // If the outer set is used, it will be flushed before the source sets.
    // If the source sets are not used directly, they will not flush
    // unnecessarily, and also may be garbage collected.
    result._counter = max(_counter, (items is ISet<T>) ? items._counter : 0);
    result._count();

    return result;
  }

  /// Returns a new set containing the current set minus the given item.
  /// However, if the given item didn't exist in the current set,
  /// it will return the current set (same instance).
  @useResult
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
  @useResult
  ISet<T> toggle(T item) => contains(item) ? remove(item) : add(item);

  /// Checks whether any element of this iterable satisfies [test].
  ///
  /// Checks every element in iteration order, and returns `true` if
  /// any of them make [test] return `true`, otherwise returns `false`.
  @override
  bool any(Predicate<T> test) => _s.any(test);

  /// Returns an iterable of [R] instances.
  /// If this set contains instances which cannot be cast to [R],
  /// it will throw an error.
  @override
  Iterable<R> cast<R>() => _s.cast<R>();

  /// Returns `true` if the collection contains an element equal to [element], `false` otherwise.
  @override
  bool contains(covariant T? element) {
    _count();
    return _s.contains(element);
  }

  /// Returns the [index]th element.
  @override
  T elementAt(int index) => _s.elementAt(index);

  /// Returns the [index]th element.
  T operator [](int index) => _s[index];

  /// Checks whether every element of this iterable satisfies [test].
  @override
  bool every(Predicate<T> test) => _s.every(test);

  /// Expands each element of this [ISet] into zero or more elements.
  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f, {ConfigSet? config}) => _s.expand(f);

  /// The number of objects in this set.
  @override
  int get length {
    final int length = _s.length;

    /// Optimization: Flushes the set, if free.
    if (length == 0 && _s is! SFlat) _s = SFlat.empty<T>();

    return length;
  }

  /// Compare with [others] length
  bool lengthCompare(Iterable others) => length == others.length;

  /// Returns any item from the set. This is useful if you need to read
  /// some property that you know all items in the set have.
  ///
  /// Note: getting [anyItem] is faster that getting [first] or [last].
  T get anyItem {
    return _s.anyItem;
  }

  /// 1. If the set's [config] has [ConfigSet.sort] `true`, will return the first
  /// element in the natural order of items. Note: This is not a fast operation,
  /// as [ISet]s are not naturally sorted.
  /// 2. If the set's [config] has [ConfigSet.sort] `false` (the default), or if
  /// the items are not [Comparable], the first item by insertion will be returned.
  ///
  @override
  T get first => config.sort ? (flush._s as SFlat<T>).first : _s.first;

  /// 1. If the set's [config] has [ConfigSet.sort] `true`, will return the last
  /// element in the natural order of items. Note: This is not a fast operation,
  /// as [ISet]s are not naturally sorted.
  /// 2. If the set's [config] has [ConfigSet.sort] `false` (the default), or if
  /// the items are not [Comparable], the last item by insertion will be returned.
  ///
  @override
  T get last => config.sort ? (flush._s as SFlat<T>).last : _s.last;

  /// Checks that this iterable has only one element, and returns that element.
  /// Throws a [StateError] if the set is empty or has more than one element.
  @override
  T get single => _s.single;

  /// Returns the first element, or `null` if the set is empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element, or `null` if the set is empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Checks that the set has only one element, and returns that element.
  /// Return `null` if the set is empty or has more than one element.
  T? get singleOrNull => length != 1 ? null : single;

  /// Returns the first element, or [orElse] if the set is empty.
  T firstOr(T orElse) => isEmpty ? orElse : first;

  /// Returns the last element, or [orElse] if the set is empty.
  T lastOr(T orElse) => isEmpty ? orElse : last;

  /// Checks if the set has only one element, and returns that element.
  /// Return `null` if the set is empty or has more than one element.
  T singleOr(T orElse) => (length != 1) ? orElse : single;

  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// - If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned.
  /// - If [orElse] is omitted, it defaults to throwing a [StateError].
  @override
  T firstWhere(Predicate<T> test, {T Function()? orElse}) => _s.firstWhere(test, orElse: orElse);

  /// Reduces a collection to a single value by iteratively combining eac element of the collection
  /// with an existing value.
  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _s.fold(initialValue, combine);

  /// Returns the lazy concatenation of this iterable and [other].
  @override
  Iterable<T> followedBy(Iterable<T> other) => _s.followedBy(other);

  /// Applies the function [f] to each element of this collection in iteration order.
  @override
  void forEach(void Function(T element) f) {
    _s.forEach(f);
  }

  /// Converts each element to a [String] and concatenates the strings with the [separator]
  /// in-between each concatenation.
  @override
  String join([String separator = ""]) =>
      config.sort ? (flush._s as SFlat<T>).join(separator) : _s.join(separator);

  /// Returns the last element that satisfies the given predicate [test].
  @override
  T lastWhere(Predicate<T> test, {T Function()? orElse}) => _s.lastWhere(test, orElse: orElse);

  /// Returns an [Iterable] with elements that are created by calling [f]
  /// on each element of this [ISet] in iteration order.
  @override
  Iterable<E> map<E>(E Function(T element) f, {ConfigSet? config}) => _s.map(f);

  /// Reduces a collection to a single value by iteratively combining elements of the collection
  /// using the provided function.
  @override
  T reduce(T Function(T value, T element) combine) => _s.reduce(combine);

  /// Returns the single element that satisfies [test].
  @override
  T singleWhere(Predicate<T> test, {T Function()? orElse}) => _s.singleWhere(test, orElse: orElse);

  /// Returns an [ISet] that provides all but the first [count] elements.
  @override
  Iterable<T> skip(int count) => _s.skip(count);

  /// Returns an [ISet] that skips leading elements while [test] is satisfied.
  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _s.skipWhile(test);

  /// Returns an [ISet] of the [count] first elements of this iterable.
  @override
  Iterable<T> take(int count) => _s.take(count);

  /// Returns an [ISet] of the leading elements satisfying [test].
  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _s.takeWhile(test);

  /// Returns an [ISet] with all elements that satisfy the predicate [test].
  @override
  Iterable<T> where(Predicate<T> test) => _s.where(test);

  /// Returns an [ISet] with all elements that have type [E].
  @override
  Iterable<E> whereType<E>() => _s.whereType<E>();

  /// Returns a [List] with all items from the set.
  ///
  /// If you provide a [compare] function, the list will be sorted with it.
  ///
  @override
  List<T> toList({
    bool growable = true,
    int Function(T a, T b)? compare,
  }) {
    if (config.sort && compare == null) {
      return (flush._s as SFlat<T>).toList(growable: growable);
    } else {
      final result = _s.toList(growable: growable);
      if (compare != null) result.sort(compare);
      return result;
    }
  }

  /// Returns a [IList] with all items from the set.
  ///
  /// If you provide a [compare] function, the list will be sorted with it.
  ///
  /// You can also provide a [config] for the [IList].
  ///
  IList<T> toIList({
    int Function(T a, T b)? compare,
    ConfigList? config,
  }) =>
      IList.fromISet(this, compare: compare, config: config);

  /// Returns a [Set] with all items from the [ISet].
  ///
  /// If you provide a [compare] function, the resulting set will be sorted with it.
  ///
  @override
  Set<T> toSet({int Function(T a, T b)? compare}) {
    if (config.sort && compare == null) {
      final List<T> orderedList = (flush._s as SFlat<T>).toList(growable: false);
      return LinkedHashSet.of(orderedList);
    } else {
      if (compare != null) {
        final orderedList = toList(growable: false, compare: compare);
        return LinkedHashSet.of(orderedList);
      } else {
        return LinkedHashSet.of(_s);
      }
    }
  }

  /// Returns a string representation of (some of) the elements of `this`.
  ///
  /// Use either the [prettyPrint] or the [ImmutableCollection.prettyPrint] parameters to get a
  /// prettier print.
  ///
  /// See also: [ImmutableCollection]
  @override
  String toString([bool? prettyPrint]) {
    if (prettyPrint ?? ImmutableCollection.prettyPrint) {
      final int length = _s.length;
      if (length == 0) {
        return "{}";
      } else if (length == 1) {
        return "{${_s.single}}";
      } else {
        return "{\n   ${_s.join(",\n   ")}\n}";
      }
    } else {
      return "{${_s.join(", ")}}";
    }
  }

  /// Returns an empty set with the same configuration.
  @useResult
  ISet<T> clear() => ISetImpl.empty<T>(config);

  /// Returns whether this [ISet] contains all the elements of [other].
  bool containsAll(Iterable<T> other) {
    _count();
    return _s.containsAll(other);
  }

  Set<T> _setFromIterable(Iterable<T> other) {
    Set<T> otherSet;
    if (other is Set<T>)
      otherSet = other;
    else if (other is ISet<T>)
      otherSet = other.unlockView;
    else
      otherSet = Set.of(other);
    return otherSet;
  }

  /// Returns a new set with the elements of this that are not in [other].
  ///
  /// That is, the returned set contains all the elements of this [ISet] that
  /// are not elements of [other] according to `other.contains`.
  @useResult
  ISet<T> difference(Iterable<T> other) {
    final Set<T> otherSet = _setFromIterable(other);
    return ISet._unsafeFromSet(_s.difference(otherSet), config: config);
  }

  /// Returns a new set which is the intersection between this set and [other].
  ///
  /// That is, the returned set contains all the elements of this [ISet] that
  /// are also elements of [other] according to `other.contains`.
  @useResult
  ISet<T> intersection(Iterable<T> other) {
    final Set<T> otherSet = _setFromIterable(other);
    return ISet._unsafeFromSet(_s.intersection(otherSet), config: config);
  }

  /// Returns a new set which contains all the elements of this set and [other].
  ///
  /// That is, the returned set contains all the elements of this [ISet] and
  /// all the elements of [other].
  @useResult
  ISet<T> union(Iterable<T> other) => addAll(other);

  /// If an object equal to [object] is in the set, return it.
  ///
  /// Checks whether [object] is in the set, like [contains], and if so,
  /// returns the object in the set, otherwise returns `null`.
  ///
  /// If the equality relation used by the set is not identity,
  /// then the returned object may not be *identical* to [object].
  /// Some set implementations may not be able to implement this method.
  ///
  /// If the [contains] method is computed,
  /// rather than being based on an actual object instance,
  /// then there may not be a specific object instance representing the
  /// set element.
  T? lookup(T element) {
    _count();
    return _s.lookup(element);
  }

  /// Removes each element of [elements] from this set.
  @useResult
  ISet<T> removeAll(Iterable<Object?> elements) {
    return ISet._unsafeFromSet(unlock..removeAll(elements), config: config);
  }

  /// Removes all elements of this set that satisfy [test].
  @useResult
  ISet<T> removeWhere(Predicate<T> test) {
    return ISet._unsafeFromSet(unlock..removeWhere(test), config: config);
  }

  /// Removes all elements of this set that are not elements in [elements].
  ///
  /// Checks for each element of [elements] whether there is an element in this
  /// set that is equal to it (according to `this.contains`), and if so, the
  /// equal element in this set is retained, and elements that are not equal
  /// to any element in `elements` are removed.
  @useResult
  ISet<T> retainAll(Iterable<Object?> elements) {
    return ISet._unsafeFromSet(unlock..retainAll(elements), config: config);
  }

  /// Removes all elements of this set that fail to satisfy [test].
  @useResult
  ISet<T> retainWhere(Predicate<T> test) {
    return ISet._unsafeFromSet(unlock..retainWhere(test), config: config);
  }
}

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

/// **Don't use this class**.
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
