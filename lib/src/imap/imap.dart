import "dart:collection";
import "dart:math";

import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/base/hash.dart";
import "package:fast_immutable_collections/src/list_map/list_map.dart";
import "package:meta/meta.dart";

import "entry.dart";
import "m_add.dart";
import "m_add_all.dart";
import "m_flat.dart";
import "m_replace.dart";
import "modifiable_map_from_imap.dart";
import "unmodifiable_map_from_imap.dart";

/// An **immutable**, **unordered** map.
@immutable
class IMap<K, V> // ignore: must_be_immutable
    extends ImmutableCollection<IMap<K, V>> {
  //
  M<K, V> _m;

  /// The map configuration.
  final ConfigMap config;

  /// Create an [IMap] from a [Map].
  factory IMap([Map<K, V>? map]) => //
      IMap.withConfig(map, defaultConfig);

  /// Create an [IMap] from a [Map] and a [ConfigMap].
  factory IMap.withConfig(
    Map<K, V>? map,
    ConfigMap config,
  ) {
    return (map == null || map.isEmpty)
        ? IMap.empty<K, V>(config)
        : IMap<K, V>._unsafe(MFlat<K, V>(map, config: config), config: config);
  }

  /// Creates a new map with the given [config].
  ///
  /// To copy the config from another [IMap]:
  ///
  /// ```dart
  /// map = map.withConfig(other.config)
  /// ```
  ///
  /// To change the current config:
  ///
  /// ```dart
  /// map = map.withConfig(map.config.copyWith(isDeepEquals: isDeepEquals))
  /// ```
  ///
  /// See also: [withIdentityEquals] and [withDeepEquals].
  ///
  IMap<K, V> withConfig(ConfigMap config) {
    if (config == this.config)
      return this;
    else {
      // If the new config is not sorted it can use sorted or not sorted.
      // If the new config is sorted it can only use sorted.
      if (!config.sort || this.config.sort)
        return IMap._unsafe(_m, config: config);
      //
      // If the new config is sorted and the previous is not, it must sort.
      else
        return IMap._unsafe(MFlat.from(_m, config: config), config: config);
    }
  }

  /// Returns a new map with the contents of the present [IMap],
  /// but the config of [other].
  IMap<K, V> withConfigFrom(IMap<K, V> other) => withConfig(other.config);

  /// Create an [IMap] from an [Iterable] of [MapEntry].
  /// If multiple [entries] have the same [key],
  /// later occurrences overwrite the earlier ones.
  ///
  factory IMap.fromEntries(Iterable<MapEntry<K, V>> entries, {ConfigMap? config}) {
    config ??= defaultConfig;
    Map<K, V> map = ListMap.fromEntries(
      entries,
      sort: config.sort,
    );
    return IMap._(map, config: config);
  }

  /// Create an [IMap] from the given [keys].
  /// The [values] will be the result of applying [valueMapper] to the [keys].
  /// If a [key] repeats, later occurrences overwrite the earlier ones.
  ///
  /// ```dart
  /// // Results in {"Jim": 3, "David": 5}
  /// IMap<String, int> imap = IMap.fromKeys(
  ///     ["Jim", "David"], (String name) => name.length);
  /// ```
  factory IMap.fromKeys({
    required Iterable<K> keys,
    required V Function(K) valueMapper,
    ConfigMap? config,
  }) {
    config ??= defaultConfig;

    Map<K, V> map = ListMap.fromEntries(
      keys.map((key) => MapEntry(key, valueMapper(key))),
      sort: config.sort,
    );

    return IMap._(map, config: config);
  }

  /// Create an [IMap] from the given [values].
  /// The [keys] will be the result of applying [keyMapper] to the [values].
  /// If a [key] repeats, later occurrences overwrite the earlier ones.
  ///
  /// ```dart
  /// // Results in {3: "Jim", 5: "David"}
  /// IMap<int, String> imap = IMap.fromValues(
  ///     (String name) => name.length, ["Jim", "David"]);
  /// ```
  factory IMap.fromValues({
    required K Function(V) keyMapper,
    required Iterable<V> values,
    ConfigMap? config,
  }) {
    config ??= defaultConfig;

    Map<K, V> map = ListMap.fromEntries(
      values.map((value) => MapEntry(keyMapper(value), value)),
      sort: config.sort,
    );

    return IMap._(map, config: config);
  }

  /// Creates an IMap instance in which the [keys] and [values] are computed
  /// from the [iterable].
  ///
  /// For each element of the [iterable] it computes a key/value pair,
  /// by applying [keyMapper] and [valueMapper] respectively.
  ///
  /// The example below creates a new [Map] from a [List]. The keys of `map` are
  /// `list` values converted to strings, and the values of the `map` are the
  /// squares of the `list` values:
  ///
  /// ```dart
  /// List<int> list = [1, 2, 3];
  /// IMap<String, int> map = IMap.fromIterable(
  ///   list,
  ///   keyMapper: (item) => item.toString(),
  ///   valueMapper: (item) => item * item),
  /// );
  /// // The code above will yield:
  /// // {
  /// //   "1": 1,
  /// //   "2": 4,
  /// //   "3": 9,
  /// // }
  /// ```
  ///
  /// If no values are specified for [keyMapper] and [valueMapper],
  /// the default is the identity function.
  ///
  /// The keys computed by the source [iterable] do not need to be unique. The
  /// last occurrence of a key will simply overwrite any previous value.
  ///
  /// See also: [IMap.fromIterables]
  ///
  static IMap<K, V> fromIterable<K, V, I>(
    Iterable<I> iterable, {
    K Function(I)? keyMapper,
    V Function(I)? valueMapper,
    ConfigMap? config,
  }) {
    config ??= defaultConfig;
    keyMapper ??= (I i) => i as K;
    valueMapper ??= (I i) => i as V;

    Map<K, V> map = ListMap.fromEntries(
      iterable.map(
        (item) => MapEntry(keyMapper!(item), valueMapper!(item)),
      ),
      sort: config.sort,
    );

    return IMap._(map, config: config);
  }

  /// Creates an IMap instance associating the given [keys] to [values].
  ///
  /// This constructor iterates over [keys] and [values] and maps each element of
  /// [keys] to the corresponding element of [values].
  ///
  ///     List<String> letters = ['b', 'c'];
  ///     List<String> words = ['bad', 'cat'];
  ///     IMap<String, String> map = IMap.fromIterables(letters, words);
  ///     map['b'] + map['c'];  // badcat
  ///
  /// If [keys] contains the same object multiple times, the last occurrence
  /// overwrites the previous value.
  ///
  /// The two [Iterable]s must have the same length.
  ///
  /// See also: [fromIterable]
  ///
  factory IMap.fromIterables(Iterable<K> keys, Iterable<V> values, {ConfigMap? config}) {
    Map<K, V> map = ListMap.fromIterables(keys, values, sort: (config ?? defaultConfig).sort);
    return IMap._(map, config: config ?? defaultConfig);
  }

  /// **Unsafe constructor**. Use this at your own peril.
  ///
  /// This constructor is fast, since it makes no defensive copies of the map.
  /// However, you should only use this with a new map you've created yourself,
  /// when you are sure no external copies exist. If the original map is modified,
  /// it will break the [IMap] and any other derived maps in unpredictable ways.
  ///
  /// Also, if [config] is [ConfigMap.sort] `true`, it assumes you will pass it a
  /// sorted mao. It will not sort the map for you. In this case, if [map] is
  /// not sorted, it will break the [IMap] and any other derived sets in unpredictable
  /// ways.
  ///
  IMap.unsafe(Map<K, V>? map, {required this.config})
      : _m = (map == null) ? MFlat.empty<K, V>() : MFlat<K, V>.unsafe(map) {
    if (ImmutableCollection.disallowUnsafeConstructors)
      throw UnsupportedError("IMap.unsafe is disallowed.");
  }

  /// If [Map] is `null`, return `null`.
  ///
  /// Otherwise, create an [IMap] from the [Map].
  ///
  /// This static factory is useful for implementing a `copyWith` method
  /// that accepts maps. For example:
  ///
  /// ```dart
  /// IMap<Id, String> studentsPerId;
  ///
  /// Students copyWith({Map<Id, String>? studentsPerId}) =>
  ///   Students(studentsPerId: IMap.orNull(studentsPerId) ?? this.studentsPerId);
  /// ```
  ///
  /// Of course, if your `copyWith` accepts an [IMap], this is not necessary:
  ///
  /// ```dart
  /// IMap<Id, String> studentsPerId;
  ///
  /// Students copyWith({IMap<Id, String>? studentsPerId}) =>
  ///   Students(studentsPerId: studentsPerId ?? this.studentsPerId);
  /// ```
  ///
  static IMap<K, V>? orNull<K, V>(
    Map<K, V>? map, [
    ConfigMap? config,
  ]) =>
      (map == null) ? null : IMap.withConfig(map, config ?? defaultConfig);

  /// Returns an empty [IMap], with the given configuration. If a
  /// configuration is not provided, it will use the default configuration.
  ///
  /// Note: If you want to create an empty immutable collection of the same
  /// type and same configuration as a source collection, simply call [clear]
  /// in the source collection.
  static IMap<K, V> empty<K, V>([ConfigMap? config]) =>
      IMap._unsafe(MFlat.empty<K, V>(), config: config ?? defaultConfig);

  /// Converts from JSon. Json serialization support for json_serializable with @JsonSerializable.
  factory IMap.fromJson(
    Map<String, Object?> json,
    K Function(Object?) fromJsonK,
    V Function(Object?) fromJsonV,
  ) =>
      json.map<K, V>((key, value) => MapEntry(fromJsonK(key), fromJsonV(value))).lock;

  /// Converts to JSon. Json serialization support for json_serializable with @JsonSerializable.
  Object toJson(Object Function(K) toJsonK, Object Function(V) toJsonV) =>
      unlock.map((key, value) => MapEntry(toJsonK(key), toJsonV(value)));

  /// See also: [ImmutableCollection], [ImmutableCollection.lockConfig],
  /// [ImmutableCollection.isConfigLocked],[flushFactor], [defaultConfig]
  static void resetAllConfigurations() {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    IMap.flushFactor = _defaultFlushFactor;
    IMap.defaultConfig = _defaultConfig;
  }

  /// Global configuration that specifies if, by default, the [IMap]s
  /// use equality or identity for their [operator ==].
  /// By default `isDeepEquals: true` (maps are compared by equality),
  /// and `sortKeys: true` and `sortValues: true` (certain map outputs are sorted).
  static ConfigMap get defaultConfig => _defaultConfig;

  /// Indicates the number of operations an [IMap] may perform
  /// before it is eligible for auto-flush. Must be larger than `0`.
  static int get flushFactor => _flushFactor;

  /// Global configuration that specifies if auto-flush of [IMap]s should be
  /// async. The default is `true`. When the autoflush is async, it will only
  /// happen after the async gap, no matter how many operations a collection
  /// undergoes. When the autoflush is sync, it may flush one or more times
  /// during the same task.
  static bool get asyncAutoflush => _asyncAutoflush;

  /// See also: [ConfigList], [ImmutableCollection], [resetAllConfigurations]
  static set defaultConfig(ConfigMap config) {
    if (_defaultConfig == config) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _defaultConfig = config;
  }

  /// See also: [ImmutableCollection]
  static set flushFactor(int value) {
    if (_flushFactor == value) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    if (value > 0)
      _flushFactor = value;
    else
      throw StateError("flushFactor can't be $value.");
  }

  /// See also: [ImmutableCollection]
  static set asyncAutoflush(bool value) {
    if (_asyncAutoflush == value) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _asyncAutoflush = value;
  }

  static ConfigMap _defaultConfig = const ConfigMap();

  static const _defaultFlushFactor = 30;

  static int _flushFactor = _defaultFlushFactor;

  static bool _asyncAutoflush = true;

  int _counter = 0;

  /// ## Sync Auto-flush
  ///
  /// Keeps a counter variable which starts at `0` and is incremented each
  /// time some collection methods are used.
  ///
  /// As soon as counter reaches the refresh-factor, the collection is flushed
  /// and `counter` returns to `0`.
  ///
  /// ## Async Auto-flush
  ///
  /// Keeps a counter variable which starts at `0` and is incremented each
  /// time some collection methods are used, as long as `counter >= 0`.
  ///
  /// As soon as counter reaches the refresh-factor, the collection is marked
  /// for flushing. There is also a global counter called an `asyncCounter`
  /// which starts at `1`. When a collection is marked for flushing, it first
  /// creates a future to increment the `asyncCounter`. Then, the collection's
  /// own `counter` is set to be `-asyncCounter`. Having a negative value means
  /// the collection's `counter` will not be incremented anymore. However, when
  /// `counter` is negative and different from `-asyncCounter` it means we are
  /// one async gap after the collection was marked for flushing.
  /// At this point, the collection will flush and `counter` returns to zero.
  ///
  /// Note: [_count] is called in methods which read values. It's not called
  /// in methods which create new IMaps or flush the map.
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

  /// **Unsafe**. Note: Does not sort, so the map should already respect config.
  IMap._(Map<K, V> map, {required this.config}) : _m = MFlat<K, V>.unsafe(map);

  /// **Unsafe**. Note: Does not sort.
  IMap._unsafe(this._m, {required this.config});

  /// **Unsafe**.
  IMap._unsafeFromMap(Map<K, V> map, {required this.config}) : _m = MFlat<K, V>.unsafe(map);

  /// Creates a map with `identityEquals` (compares the internals by `identity`).
  IMap<K, V> get withIdentityEquals =>
      config.isDeepEquals ? IMap._unsafe(_m, config: config.copyWith(isDeepEquals: false)) : this;

  /// Creates a map with `deepEquals` (compares all map entries by equality).
  IMap<K, V> get withDeepEquals =>
      config.isDeepEquals ? this : IMap._unsafe(_m, config: config.copyWith(isDeepEquals: true));

  /// See also: [ConfigList]
  bool get isDeepEquals => config.isDeepEquals;

  /// See also: [ConfigList]
  bool get isIdentityEquals => !config.isDeepEquals;

  /// Returns an [Iterable] of the map entries of type [MapEntry].
  Iterable<MapEntry<K, V>> get entries => _m.entries;

  /// Return the [MapEntry] for the given [key].
  /// For key/value pairs that don't exist, it will return `MapEntry(key, null);`.
  MapEntry<K, V?> entry(K key) => MapEntry(key, _m[key]);

  /// Return the [MapEntry] for the given [key].
  /// For key/value pairs that don't exist, it will return null.
  MapEntry<K, V>? entryOrNull(K key) => _m.containsKey(key) ? MapEntry(key, _m[key]!) : null;

  /// Returns an [Iterable] of the map entries of type [Entry]. Contrary to
  /// [MapEntry], [Entry] is comparable and implements equals (`==`) and [hashcode] by
  /// using its key and value.
  Iterable<Entry<K, V>> get comparableEntries => _m.entries.map((e) => e.asComparableEntry);

  /// Returns an [Iterable] of the map keys.
  Iterable<K> get keys {
    _count();
    return _m.keys;
  }

  /// Returns an [Iterable] of the map values, in the same order as the keys.
  /// If you need to sort the values, please use [toValueIList].
  Iterable<V> get values {
    _count();
    return _m.values;
  }

  /// Returns an [IList] of the map entries.
  ///
  /// Optionally, you may provide a [config] for the list.
  ///
  /// The list will be sorted if the map's [sort] configuration is `true`,
  /// or if you explicitly provide a [compare] method.
  ///
  IList<MapEntry<K, V>> toEntryIList({
    int Function(MapEntry<K, V>? a, MapEntry<K, V>? b)? compare,
    ConfigList? config,
  }) {
    _count();
    var result = IList<MapEntry<K, V>>.withConfig(entries, config ?? IList.defaultConfig);
    if (compare != null || this.config.sort) result = result.sort(compare);
    return result;
  }

  /// Returns an [IList] of the map keys.
  ///
  /// Optionally, you may provide a [config] for the list.
  ///
  /// The list will be sorted if the map's [sort] configuration is `true`,
  /// or if you explicitly provide a [compare] method.
  ///
  IList<K> toKeyIList({
    int Function(K? a, K? b)? compare,
    ConfigList? config,
  }) {
    _count();
    var result = IList.withConfig(keys, config ?? IList.defaultConfig);
    if (compare != null || this.config.sort) result = result.sort(compare);
    return result;
  }

  /// Returns an [IList] of the map values.
  ///
  /// Optionally, you may provide a [config] for the list.
  ///
  /// If [sort] is true, then the list will be sorted with [compare], if
  /// provided, or with [compareObject] if not provided. If [sort] is
  /// false, [compare] will be ignored.
  ///
  IList<V> toValueIList({
    bool sort = false,
    int Function(V a, V b)? compare,
    ConfigList? config,
  }) {
    assert(compare == null || sort == true);

    _count();
    var result = IList.withConfig(values, config ?? IList.defaultConfig);
    if (sort) result = result.sort(compare ?? compareObject);
    return result;
  }

  /// Returns an [ISet] of the map entries.
  /// Optionally, you may provide a [config] for the set.
  ISet<MapEntry<K, V>> toEntryISet({
    ConfigSet? config,
  }) =>
      ISet.withConfig(entries, config ?? ISet.defaultConfig);

  /// Returns an [ISet] of the map keys.
  /// Optionally, you may provide a [config] for the set.
  ISet<K> toKeyISet({
    ConfigSet? config,
  }) {
    _count();
    return ISet.withConfig(keys, config ?? ISet.defaultConfig);
  }

  /// Returns an [ISet] of the map values.
  /// Optionally, you may provide a [config] for the set.
  ISet<V> toValueISet({
    ConfigSet? config,
  }) {
    _count();
    return ISet.withConfig(values, config ?? ISet.defaultConfig);
  }

  /// Returns a [List] of the map entries.
  ///
  /// The list will be sorted if the map's [sort] configuration is `true`,
  /// or if you explicitly provide a [compare] method.
  ///
  List<MapEntry<K, V>> toEntryList({int Function(MapEntry<K, V> a, MapEntry<K, V> b)? compare}) {
    _count();
    var result = List<MapEntry<K, V>>.of(entries);
    if (compare != null || config.sort) result.sort(compare ?? compareObject);
    return result;
  }

  /// Returns a [List] of the map keys.
  ///
  /// The list will be sorted if the map's [sort] configuration is `true`,
  /// or if you explicitly provide a [compare] method.
  ///
  List<K> toKeyList({int Function(K a, K b)? compare}) {
    _count();
    var result = List.of(keys);
    if (compare != null || config.sort) result.sort(compare);
    return result;
  }

  /// Returns a [List] of the map values.
  ///
  /// If [sort] is true, then the list will be sorted with [compare], if
  /// provided, or with [compareObject] if not provided. If [sort] is
  /// false, [compare] will be ignored.
  ///
  List<V> toValueList({
    bool sort = false,
    int Function(V a, V b)? compare,
  }) {
    assert(compare == null || sort == true);

    _count();
    var result = List.of(values);
    if (sort) result.sort(compare ?? compareObject);
    return result;
  }

  /// Returns a [Set] of the map entries.
  /// The set will be sorted if the map's [sort] configuration is `true`,
  /// or if you explicitly provide a [compare] method.
  Set<MapEntry<K, V>> toEntrySet({int Function(MapEntry<K, V> a, MapEntry<K, V> b)? compare}) {
    _count();

    if (compare == null) {
      return Set<MapEntry<K, V>>.of(entries);
    } else {
      return toEntryList(compare: compare).toSet();
    }
  }

  /// Returns a [Set] of the map keys.
  /// The set will be sorted if the map's [sort] configuration is `true`,
  /// or if you explicitly provide a [compare] method.
  ///
  Set<K> toKeySet({int Function(K a, K b)? compare}) {
    _count();

    if (compare == null) {
      return Set<K>.of(keys);
    } else {
      return toKeyList(compare: compare).toSet();
    }
  }

  /// Returns a [Set] of the map values.
  /// The set will be sorted if the map's [sortValues] configuration is `true`,
  /// or if you explicitly provide a [compare] method.
  ///
  Set<V> toValueSet({int Function(V a, V b)? compare}) {
    _count();
    return toValueList(compare: compare).toSet();
  }

  /// Returns a new `Iterator` that allows iterating the entries of the [IMap].
  ///
  /// 1. If the map's [config] has [ConfigMap.sort] `true` (the default),
  /// it will iterate in the natural order of entries. In other words, if the
  /// keys/values are [Comparable], they will be sorted first by
  /// `keyA.compareTo(keyB)` and then by `valueA.compareTo(valueB)`.
  ///
  /// 2. If the map's [config] has [ConfigMap.sort] `false`, or if the
  /// keys/values are not [Comparable], the iterator order is by insertion order.
  ///
  Iterator<MapEntry<K, V>> get iterator => _m.iterator;

  /// Unlocks the map, returning a regular (mutable, ordered) [Map] of type
  /// [LinkedHashMap]. This map is "safe", in the sense that is independent from
  /// the original [IMap].
  Map<K, V> get unlock => _m.unlock;

  /// Unlocks the map, returning a regular, *mutable, ordered, sorted*, [Map]
  /// of type [LinkedHashMap]. This map is "safe", in the sense that is
  /// independent from the original [IMap].
  Map<K, V> get unlockSorted => <K, V>{}..addEntries(toEntryIList());

  /// Unlocks the map, returning a safe, unmodifiable (immutable) [Map] view.
  /// The word "view" means the set is backed by the original [IMap].
  ///
  /// Using this is very fast, since it makes no copies of the [IMap] entries.
  /// However, if you try to use methods that modify the map, like [add],
  /// it will throw an [UnsupportedError].
  /// It is also very fast to lock this map back into an [IMap].
  ///
  /// See also: [UnmodifiableMapFromIMap]
  Map<K, V> get unlockView => UnmodifiableMapFromIMap(this);

  /// Unlocks the map, returning a safe, modifiable (mutable) [Map].
  ///
  /// Using this is very fast at first, since it makes no copies of the [IMap]
  /// entries. However, if and only if you use a method that mutates the map,
  /// like [add], it will unlock internally (make a copy of all [IMap] entries).
  /// This is transparent to you, and will happen at most only once. In other
  /// words, it will unlock the [IMap], lazily, only if necessary.
  /// If you never mutate the map, it will be very fast to lock this map
  /// back into an [IMap].
  ///
  /// See also: [ModifiableMapFromIMap]
  Map<K, V> get unlockLazy => ModifiableMapFromIMap(this);

  /// Returns `true` if there are no elements in this collection.
  @override
  bool get isEmpty => _m.isEmpty;

  /// Returns `true` if there is at least one element in this collection.
  @override
  bool get isNotEmpty => !isEmpty;

  /// - If [isDeepEquals] configuration is `true`:
  /// Will return `true` only if the map entries are equal (not necessarily in
  /// the same order), and the map configurations are equal. This may be slow
  /// for very large maps, since it compares each entry, one by one.
  ///
  /// - If [isDeepEquals] configuration is `false`:
  /// Will return `true` only if the maps internals are the same instances
  /// (comparing by identity). This will be fast even for very large maps,
  /// since it doesn't compare each entry.
  ///
  /// Note: This is not the same as `identical(map1, map2)` since it doesn't
  /// compare the maps themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  ///
  @override
  bool operator ==(Object other) => (other is IMap) && isDeepEquals
      ? equalItemsAndConfig(other)
      : (other is IMap<K, V>) && same(other);

  /// Will return `true` only if the [IMap] entries are equal to the entries in
  /// the [Iterable]. Order is irrelevant. This may be slow for very large maps,
  /// since it compares each entry, one by one. To compare with a map, use
  /// method [equalItemsToMap] or [equalItemsToIMap].
  @override
  bool equalItems(covariant Iterable<MapEntry> other) {
    return (flush._m as MFlat<K, V>).deepMapEqualsToIterable(other);
  }

  /// Will return `true` only if the two maps have the same number of entries, and
  /// if the entries of the two maps are pairwise equal on both key and value.
  bool equalItemsToMap(Map other) => const MapEquality<dynamic, dynamic>()
      .equals(UnmodifiableMapFromIMap<dynamic, dynamic>(this), other);

  /// Will return `true` only if the two maps have the same number of entries, and
  /// if the entries of the two maps are pairwise equal on both key and value.
  bool equalItemsToIMap(IMap other) {
    if (_isUnequalByHashCode(other)) return false;

    return (flush._m as MFlat).deepMapEquals(other.flush._m as MFlat);
  }

  /// Will return `true` only if the list items are equal, and the map configurations are equal.
  /// This may be slow for very large maps, since it compares each item, one by one.
  @override
  bool equalItemsAndConfig(IMap other) {
    if (identical(this, other)) return true;

    // Objects with different hashCodes are not equal.
    if (_isUnequalByHashCode(other)) return false;

    return config == other.config &&
        (identical(_m, other._m) || (flush._m as MFlat).deepMapEquals(other.flush._m as MFlat));
  }

  /// Return `true` if other is `null` or the cached [hashCode]s proves the
  /// collections are **NOT** equal.
  ///
  /// **Explanation**: Objects with different [hashCode]s are not equal. However,
  /// if the hashCodes are the same, then nothing can be said about the equality.
  ///
  /// Note: We use the **CACHED** hashCodes. If any of the hashCodes is `null` it
  /// means we don't have this information yet, and we don't calculate it.
  bool _isUnequalByHashCode(IMap? other) {
    return (other == null) ||
        (_hashCode != null && other._hashCode != null && _hashCode != other._hashCode);
  }

  /// Will return `true` only if the maps internals are the same instances
  /// (comparing by identity). This will be fast even for very large maps,
  /// since it doesn't  compare each entry.
  ///
  /// Note: This is not the same as `identical(map1, map2)` since it doesn't
  /// compare the maps themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  @override
  bool same(IMap<K, V> other) => identical(_m, other._m) && (config == other.config);

  // HashCode cache. Must be null if hashCode is not cached.
  int? _hashCode;

  @override
  int get hashCode {
    if (_hashCode != null) return _hashCode!;

    var hashCode = isDeepEquals //
        ? hash2((flush._m as MFlat<K, V>).deepMapHashcode(), config.hashCode)
        : hash2(identityHashCode(_m), config.hashCode);

    if (config.cacheHashCode) _hashCode = hashCode;

    return hashCode;
  }

  /// Flushes the map, if necessary. Chainable method.
  /// If the map is already flushed, doesn't do anything.
  @override
  IMap<K, V> get flush {
    if (!isFlushed) {
      // Flushes the original _m because maybe it's used elsewhere.
      // Or maybe it was flushed already, and we can use it as is.
      _m = MFlat<K, V>.unsafe(_m.getFlushed(config));
      _counter = 0;
    }
    return this;
  }

  /// Whether this map is already flushed or not.
  @override
  bool get isFlushed => _m is MFlat;

  /// Returns a new map containing the current map plus the given key:value.
  /// (if necessary, the given key:value pair will override the current).
  IMap<K, V> add(K key, V value) {
    IMap<K, V> result;
    result = config.sort
        ? IMap._unsafe(
            MFlat.fromEntries(_m.entries.followedBy([MapEntry(key, value)]), config: config),
            config: config)
        : IMap<K, V>._unsafe(_m.add(key: key, value: value), config: config);

    // A map created with `add` has a larger counter than its source map.
    // This improves the order in which maps are flushed.
    // If the outer map is used, it will be flushed before the source map.
    // If the source map is not used directly, it will not flush unnecessarily,
    // and also may be garbage collected.
    result._counter = _counter + 1;

    return result;
  }

  /// Returns a new map containing the current map plus the given key:value.
  /// (if necessary, the given entry will override the current one).
  IMap<K, V> addEntry(MapEntry<K, V> entry) => add(entry.key, entry.value);

  /// Returns a new map containing the current map plus the ones in the
  /// given [imap].
  ///
  /// Note: [imap] entries that already exist in the original map will overwrite
  /// those of the original map.
  ///
  /// - If [keepOrder] is `false` (the default), those entries that already exist
  /// will be replaced at the end of the new map.
  /// - If [keepOrder] is `true`, the entries which already exist will be replaced
  /// at their current position.
  ///
  /// Note: [keepOrder] only makes sense if your map is **NOT** ordered, that is
  /// `ConfigMap.sort == false`.
  IMap<K, V> addAll(IMap<K, V> imap, {bool keepOrder = false}) {
    IMap<K, V> result;
    result = config.sort
        ? IMap._unsafe(MFlat.fromEntries(_m.entries.followedBy(imap.entries), config: config),
            config: config)
        : IMap<K, V>._unsafe(_m.addAll(imap, keepOrder: keepOrder), config: config);

    // A map created with `addAll` has a larger counter than both its source
    // maps. This improves the order in which maps are flushed.
    // If the outer map is used, it will be flushed before the source maps.
    // If the source maps are not used directly, they will not flush
    // unnecessarily, and also may be garbage collected.
    result._counter = max(_counter, ((imap is IMap<K, V>) ? imap._counter : 0)) + 1;

    return result;
  }

  /// Returns a new map containing the current map plus the given [map] entries.
  /// Note: [map] entries that already exist in the original map will overwrite
  /// those of the original map, in place (keeping order).
  IMap<K, V> addMap(Map<K, V> map) {
    IMap<K, V> result;
    result = config.sort
        ? IMap._unsafe(MFlat.fromEntries(_m.entries.followedBy(map.entries), config: config),
            config: config)
        : IMap<K, V>._unsafe(_m.addMap(map), config: config);

    result._counter = _counter + 1;
    return result;
  }

  /// Returns a new map containing the current map plus the given [entries].
  /// Note: [entries] that already exist in the original map will overwrite
  /// those of the original map, in place (keeping order).
  IMap<K, V> addEntries(Iterable<MapEntry<K, V>> entries) {
    IMap<K, V> result;
    result = config.sort
        ? IMap._unsafe(MFlat.fromEntries(_m.entries.followedBy(entries), config: config),
            config: config)
        : IMap<K, V>._unsafe(_m.addEntries(entries), config: config);

    result._counter = _counter + 1;
    return result;
  }

  /// Returns a new map containing the current map minus the given key and its
  /// value. However, if the current map doesn't contain the key, it will
  /// return the current map (same instance).
  IMap<K, V> remove(K key) {
    M<K, V> result = _m.remove(key);
    return identical(result, _m) ? this : IMap<K, V>._unsafe(result, config: config);
  }

  /// Returns a new map containing the current map minus the entries that
  /// satisfy the given [predicate]. However, if nothing is removed, it will
  /// return the current map (same instance).
  IMap<K, V> removeWhere(bool Function(K key, V value) predicate) {
    M<K, V> result = _m.removeWhere(predicate);
    return identical(result, _m) ? this : IMap<K, V>._unsafe(result, config: config);
  }

  /// Returns the value for the given [key] or null if [key] is not in the map.
  V? operator [](K k) {
    _count();
    return _m[k];
  }

  /// Returns the value for the given [key] or null if [key] is not in the map.
  V? get(K k) {
    _count();
    return _m[k];
  }

  /// Checks whether any key-value pair of this map satisfies [test].
  bool any(bool Function(K key, V value) test) {
    _count();
    return _m.any(test);
  }

  /// Provides a **view** of this map as having [RK] keys and [RV] instances,
  /// if necessary.
  ///
  /// If this map is already an `IMap<RK, RV>`, it is returned unchanged.
  ///
  /// If this map contains only keys of type [RK] and values of type [RV],
  /// all read operations will work correctly.
  /// If any operation exposes a non-[RK] key or non-[RV] value,
  /// the operation will throw instead.
  ///
  /// Entries added to the map must be valid for both an `IMap<K, V>` and an
  /// `IMap<RK, RV>`.
  IMap<RK, RV> cast<RK, RV>() {
    Object result = _m.cast<RK, RV>(config);
    if (result is M<RK, RV>)
      return IMap._unsafe(result, config: config);
    else if (result is Map<RK, RV>)
      return IMap._(result, config: config);
    else
      throw AssertionError(result.runtimeType);
  }

  /// Checks whether any entry of this iterable satisfies [test].
  bool anyEntry(bool Function(MapEntry<K, V>) test) {
    _count();
    return _m.anyEntry(test);
  }

  /// Checks whether every entry of this iterable satisfies [test].
  bool everyEntry(bool Function(MapEntry<K, V>) test) {
    _count();
    return _m.everyEntry(test);
  }

  /// Returns `true` if the map contains an element equal to the [key]-[value] pair, `false`
  /// otherwise.
  bool contains(K key, V value) {
    _count();
    return _m.contains(key, value);
  }

  /// Returns `true` if the map contains the [key], `false` otherwise.
  bool containsKey(K? key) {
    _count();
    return _m.containsKey(key);
  }

  /// Returns `true` if the map contains the [value], `false` otherwise.
  bool containsValue(V? value) {
    _count();
    return _m.containsValue(value);
  }

  /// Returns `true` if the map contains the [entry], `false` otherwise.
  bool containsEntry(MapEntry<K, V> entry) {
    _count();
    return _m.contains(entry.key, entry.value);
  }

  /// The number of objects in this list.
  int get length {
    final int length = _m.length;

    /// Optimization: Flushes the map, if free.
    if (length == 0 && _m is! MFlat)
      _m = MFlat.empty<K, V>();
    else
      _count();

    return length;
  }

  /// Applies the function [f] to each element.
  void forEach(void Function(K key, V value) f) {
    _count();
    _m.forEach(f);
  }

  /// Returns an [IMap] with all elements that satisfy the predicate [test].
  IMap<K, V> where(bool Function(K key, V value) test) =>
      IMap<K, V>._(_m.where(test), config: config);

  /// Returns a new map where all entries of this map are transformed by
  /// the given [mapper] function. However, if [ifRemove] is provided,
  /// the mapped value will first be tested with it and, if [ifRemove]
  /// returns true, the value will be removed from the result map.
  IMap<RK, RV> map<RK, RV>(
    MapEntry<RK, RV> Function(K key, V value) mapper, {
    bool Function(RK key, RV value)? ifRemove,
    ConfigMap? config,
  }) {
    config ??= defaultConfig;
    Map<RK, RV> map = ListMap.fromEntries(
      entries
          .map((entry) => mapper(entry.key, entry.value))
          .where((entry) => ifRemove == null || !ifRemove(entry.key, entry.value)),
      sort: config.sort,
    );

    return IMap._unsafeFromMap(map, config: config);
  }

  /// Returns a string representation of (some of) the elements of `this`.
  ///
  /// Use either the [prettyPrint] or the [ImmutableCollection.prettyPrint] parameters to get a
  /// prettier print.
  ///
  /// See also: [ImmutableCollection]
  @override
  String toString([bool? prettyPrint]) {
    if ((prettyPrint ?? ImmutableCollection.prettyPrint)) {
      int length = _m.length;
      if (length == 0) {
        return "{}";
      } else if (length == 1) {
        var entry = entries.single;
        return "{${entry.key}: ${entry.value}}";
      } else {
        Iterable<MapEntry<K, V>> sortedEntries = config.sort
            ? (entries.toList()..sort((e1, e2) => e1.key.compareObjectTo(e2.key)))
            : entries;
        return "{\n   ${sortedEntries.map((entry) => entry.print(prettyPrint)).join(",\n   ")}\n}";
      }
    } else {
      Iterable<MapEntry<K, V>> sortedEntries = config.sort
          ? (entries.toList()..sort((e1, e2) => e1.key.compareObjectTo(e2.key)))
          : entries;
      return "{${sortedEntries.map((entry) => entry.print(prettyPrint)).join(", ")}}";
    }
  }

  /// Returns an empty map with the same configuration.
  IMap<K, V> clear() => empty<K, V>(config);

  /// Look up the value of [key], or add a new value if it isn't there.
  ///
  /// Returns the modified map, and sets the [previousValue] associated to [key],
  /// if there is one. Otherwise calls [ifAbsent] to get a new value,
  /// associates [key] to that value, and then sets the new [previousValue].
  ///
  /// ```dart
  /// IMap<String, int> scores = {"Bob": 36}.lock;
  ///
  /// Item<int> item = Item();
  /// for (String key in ["Bob", "Rohan", "Sophia"]) {
  ///   item = Item();
  ///   scores = scores.putIfAbsent(key, () => key.length, value: item);
  ///   print(value);    // 36, 5, 6
  /// }
  ///
  /// scores["Bob"];     // 36
  /// scores["Rohan"];   //  5
  /// scores["Sophia"];  //  6
  /// ```
  ///
  /// Calling [ifAbsent] must not add or remove keys from the map.
  ///
  ///
  IMap<K, V> putIfAbsent(
    K key,
    V Function() ifAbsent, {
    Output<V>? previousValue,
  }) {
    // Is present.
    V? value = this[key];
    if ((value != null) || containsKey(key)) {
      previousValue?.save(value);
      return this;
    }
    //
    // Is absent.
    else {
      var calculatedValue = ifAbsent();
      previousValue?.save(calculatedValue);
      Map<K, V> map = ListMap.fromEntries(
        entries.followedBy([MapEntry(key, calculatedValue)]),
        sort: config.sort,
      );
      return IMap._unsafeFromMap(map, config: config);
    }
  }

  /// Updates the value for the provided [key].
  ///
  /// If the key is present, invokes [update] with the current value and stores
  /// the new value in the map. However, if [ifRemove] is provided, the updated value will
  /// first be tested with it and, if [ifRemove] returns true, the value will be
  /// removed from the map, instead of updated.
  ///
  /// If the key is not present and [ifAbsent] is provided, calls [ifAbsent]
  /// and adds the key with the returned value to the map.
  /// If the key is not present and [ifAbsent] is not provided, return the original map
  /// without modification. Note: If you want [ifAbsent] to throw an error, pass it like
  /// this: `ifAbsent: () => throw ArgumentError();`.
  ///
  /// If you want to get the original value before the update, you can provide the
  /// [previousValue] parameter.
  ///
  IMap<K, V> update(
    K key,
    V Function(V value) update, {
    bool Function(K key, V value)? ifRemove,
    V Function()? ifAbsent,
    Output<V>? previousValue,
  }) {
    // Contains key.
    if (containsKey(key)) {
      Map<K, V> map = unlock;
      V originalValue = map[key]!;
      var updatedValue = update(originalValue);
      if (ifRemove != null && ifRemove(key, updatedValue)) {
        map.remove(key);
      } else {
        map[key] = updatedValue;
      }

      if (previousValue != null) previousValue.save(originalValue);
      return IMap._unsafeFromMap(map, config: config);
    }
    //
    // Does not contain key.
    else {
      if (ifAbsent != null) {
        var updatedValue = ifAbsent();
        if (previousValue != null) previousValue.save(null);
        Map<K, V> map = ListMap.fromEntries(
          entries.followedBy([MapEntry(key, updatedValue)]),
          sort: config.sort,
        );
        return IMap._unsafeFromMap(map, config: config);
      } else {
        if (previousValue != null) previousValue.save(null);
        return this;
      }
    }
  }

  /// Updates all values.
  ///
  /// Iterates over all entries in the map and updates them with the result
  /// of invoking [update].
  IMap<K, V> updateAll(
    V Function(K key, V value) update, {
    bool Function(K key, V value)? ifRemove,
  }) {
    Map<K, V> map = unlock..updateAll(update);
    if (ifRemove != null) map.removeWhere(ifRemove);
    return IMap._unsafeFromMap(map, config: config);
  }
}

// /////////////////////////////////////////////////////////////////////////////

@visibleForOverriding
abstract class M<K, V> {
  //

  /// The [M] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  ///
  /// Note these fallback methods need to calculate the flushed map, but
  /// because that"s immutable, we cache it.
  Map<K, V>? _flushed;

  /// Returns the flushed map (flushes it only once).
  /// **It is an error to use the flushed map outside of the [M] class.**
  Map<K, V> getFlushed(ConfigMap? config) {
    _flushed ??= ListMap.fromEntries(entries, sort: (config ?? IMap.defaultConfig).sort);
    return _flushed!;
  }

  /// Returns a regular Dart (*mutable*) Map.
  Map<K, V> get unlock => <K, V>{}..addEntries(entries);

  Iterable<MapEntry<K, V>> get entries;

  Iterable<K> get keys;

  Iterable<V> get values;

  Iterator<MapEntry<K, V>> get iterator;

  int get length;

  /// Returns a new map containing the current map plus the given key:value.
  /// However, if the given key already exists in the set,
  /// it will remove the old one and add the new one.
  M<K, V> add({required K key, required V value}) {
    bool contains = containsKey(key);
    if (!contains)
      return MAdd<K, V>(this, key, value);
    else {
      V? oldValue = this[key];
      return (oldValue == value) //
          ? this
          : MReplace<K, V>(this, key, value);
    }
  }

  /// The entries of the given [imap] will be added to the original map.
  /// Note: [imap] entries that already exist in the original map will overwrite
  /// those of the original map.
  ///
  /// If the current map is sorted, then if [keepOrder] is `false` (the default),
  /// those entries that already exist will go to the end of the new map. If
  /// [keepOrder] is `true`, those entries that already exist will be replaced in
  /// place.
  ///
  /// If the current map is NOT sorted, the [keepOrder] parameter is ignored.
  ///
  /// Note: This will NOT sort anything.
  ///
  M<K, V> addAll(IMap<K, V> imap, {bool keepOrder = false}) {
    if (keepOrder) {
      Map<K, V> map = Map.fromEntries(entries.followedBy(imap.entries));
      return MFlat<K, V>.unsafe(map);
    }
    //
    else {
      // We want the entries being added to overwrite those of the original add.
      // So we have to remove the entries that are already present in the second map.
      Map<K, V> firstMap =
          ListMap.fromEntries(entries.where((entry) => !imap.containsKey(entry.key)));

      M<K, V> firstM = MFlat<K, V>.unsafe(firstMap);

      return MAddAll<K, V>.unsafe(firstM, imap._m);
    }
  }

  /// The [map] entries will be added to the original map.
  /// Note: [map] entries that already exist in the original map will overwrite
  /// those of the original map, in place (keeping order).
  ///
  /// Note: This will NOT sort anything.
  ///
  M<K, V> addMap(Map<K, V> map) {
    Map<K, V> newMap = Map.fromEntries(entries.followedBy(map.entries));
    return MFlat<K, V>.unsafe(newMap);
  }

  /// The [entries] will be added to the original map.
  /// Note: [entries] that already exist in the original map will overwrite
  /// those of the original map, in place (keeping order).
  ///
  /// Note: This will NOT sort anything.
  ///
  M<K, V> addEntries(Iterable<MapEntry<K, V>> entries) {
    Map<K, V> map = Map.fromEntries(this.entries.followedBy(entries));
    return MFlat<K, V>.unsafe(map);
  }

  // TODO: Still need to implement efficiently.
  M<K, V> remove(K key) {
    return !containsKey(key) ? this : MFlat<K, V>.unsafe(unlock..remove(key));
  }

  /// Removes all entries of this map that satisfy the given [predicate].
  M<K, V> removeWhere(bool Function(K key, V value) predicate) {
    Map<K, V> oldMap = unlock;
    int oldLength = oldMap.length;
    Map<K, V> newMap = oldMap..removeWhere(predicate);
    return (newMap.length == oldLength) ? this : MFlat<K, V>.unsafe(newMap);
  }

  /// Provides a view of this map as having [RK] keys and [RV] instances.
  /// May return `M<RK, RV>` or `Map<RK, RV>`.
  Map<RK, RV> cast<RK, RV>(ConfigMap config) =>
      (RK == K && RV == V) ? (this as Map<RK, RV>) : getFlushed(config).cast<RK, RV>();

  /// Returns `true` if there is no key/value pair in the map.
  bool get isEmpty => length == 0;

  /// Returns `true` if there is at least one key/value pair in the map.
  bool get isNotEmpty => !isEmpty;

  V? operator [](K key);

  /// Returns `true` if this map contains the given [key] with the given [value].
  bool contains(K key, V value) {
    V? _value = this[key];
    return (_value == null) ? containsKey(key) : (_value == value);
  }

  /// Returns `true` if this map contains the given [key].
  ///
  /// Returns `true` if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  bool containsKey(K? key);

  /// Returns `true` if this map contains the given [value].
  ///
  /// Returns `true` if any of the values in the map are equal to `value`
  /// according to the `==` operator.
  bool containsValue(V? value);

  bool containsEntry(MapEntry<K, V> entry) => contains(entry.key, entry.value);

  bool any(bool Function(K key, V value) test) =>
      entries.any((entry) => test(entry.key, entry.value));

  bool anyEntry(bool Function(MapEntry<K, V>) test) => entries.any(test);

  bool everyEntry(bool Function(MapEntry<K, V>) test) => entries.every(test);

  void forEach(void Function(K key, V value) f) =>
      entries.forEach((entry) => f(entry.key, entry.value));

  Map<K, V> where(bool Function(K key, V value) test) {
    final Map<K, V> matches = {};
    entries.forEach((entry) {
      if (test(entry.key, entry.value)) matches[entry.key] = entry.value;
    });
    return matches;
  }
}

// /////////////////////////////////////////////////////////////////////////////

/// **Don't use this class**.
@visibleForTesting
class InternalsForTestingPurposesIMap {
  IMap imap;

  InternalsForTestingPurposesIMap(this.imap);

  /// To access the private counter, add this to the test file:
  ///
  /// ```dart
  /// extension TestExtension on IMap {
  ///   int get counter => InternalsForTestingPurposesIMap(this).counter;
  /// }
  /// ```
  int get counter => imap._counter;
}

// /////////////////////////////////////////////////////////////////////////////
