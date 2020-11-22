import "dart:collection";
import "dart:math";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:collection/collection.dart";
import "package:meta/meta.dart";
import "m_add.dart";
import "m_add_all.dart";
import "m_flat.dart";
import "m_replace.dart";
import "unmodifiable_map_view.dart";

/// An **immutable**, unordered map.
@immutable
class IMap<K, V> // ignore: must_be_immutable
    extends ImmutableCollection<IMap<K, V>> {
  //
  M<K, V> _m;

  /// The map configuration.
  final ConfigMap config;

  /// Create an [IMap] from a [Map].
  factory IMap([Map<K, V> map]) => //
      IMap.withConfig(map, defaultConfig);

  /// Create an [IMap] from a [Map] and a [ConfigMap].
  factory IMap.withConfig(Map<K, V> map, ConfigMap config) {
    config = config ?? defaultConfig;
    return (map == null || map.isEmpty)
        ? IMap.empty<K, V>(config)
        : IMap<K, V>._unsafe(MFlat<K, V>(map), config: config);
  }

  /// Creates a new map with the given [config].
  ///
  /// To copy the config from another [IMap]:
  ///    `map = map.withConfig(other.config)`.
  ///
  /// To change the current config:
  ///    `map = map.withConfig(map.config.copyWith(isDeepEquals: isDeepEquals))`.
  ///
  /// See also: [withIdentityEquals] and [withDeepEquals].
  ///
  IMap<K, V> withConfig(ConfigMap config) {
    assert(config != null);
    return (config == this.config) ? this : IMap._unsafe(_m, config: config);
  }

  /// Returns a new map with the contents of the present [IMap],
  /// but the config of [other].
  IMap<K, V> withConfigFrom(IMap<K, V> other) => withConfig(other.config);

  /// Create an [IMap] from an [Iterable] of [MapEntry].
  /// If multiple [entries] have the same key,
  /// later occurrences overwrite the earlier ones.
  ///
  factory IMap.fromEntries(Iterable<MapEntry<K, V>> entries, {ConfigMap config}) {
    if (entries is IMap<K, V>)
      return IMap._unsafe((entries as IMap<K, V>)._m, config: config ?? defaultConfig);
    else {
      var map = HashMap<K, V>();
      map.addEntries(entries);
      return IMap._unsafe(MFlat.unsafe(map), config: config ?? defaultConfig);
    }
  }

  /// Create an [IMap] from the given [keys].
  /// The values will be the result of applying [valueMapper] to the [keys].
  /// If a key repeats, later occurrences overwrite the earlier ones.
  ///
  ///     // Results in {"Jim": 3, "David": 5}
  ///     IMap<String, int> imap = IMap.fromKeys(
  ///                        ["Jim", "David"], (String name) => name.length);
  ///
  factory IMap.fromKeys({
    @required Iterable<K> keys,
    @required V Function(K) valueMapper,
    ConfigMap config,
  }) {
    assert(keys != null);
    assert(valueMapper != null);

    var map = HashMap<K, V>();

    for (K key in keys) {
      map[key] = valueMapper(key);
    }

    return IMap._(map, config: config ?? defaultConfig);
  }

  /// Create an [IMap] from the given [values].
  /// The keys will be the result of applying [keyMapper] to the [values].
  /// If a key repeats, later occurrences overwrite the earlier ones.
  ///
  ///     // Results in {3: "Jim", 5: "David"}
  ///     IMap<int, String> imap = IMap.fromValues(
  ///                        (String name) => name.length, ["Jim", "David"]);
  ///
  factory IMap.fromValues({
    @required K Function(V) keyMapper,
    @required Iterable<V> values,
    ConfigMap config,
  }) {
    assert(keyMapper != null);
    assert(values != null);

    var map = HashMap<K, V>();

    for (V value in values) {
      map[keyMapper(value)] = value;
    }

    return IMap._(map, config: config ?? defaultConfig);
  }

  /// Creates a Map instance in which the keys and values are computed
  /// from the [iterable].
  ///
  /// For each element of the [iterable] this constructor computes a key/value
  /// pair, by applying [keyMapper] and [valueMapper] respectively.
  ///
  /// The example below creates a new Map from a List. The keys of `map` are
  /// `list` values converted to strings, and the values of the `map` are the
  /// squares of the `list` values:
  ///
  ///     List<int> list = [1, 2, 3];
  ///     IMap<String, int> map = new IMap.fromIterable(list,
  ///         keyMapper: (item) => item.toString(),
  ///         valueMapper: (item) => item * item);
  ///
  /// If no values are specified for [keyMapper] and [valueMapper],
  /// the default is the identity function.
  ///
  /// The keys computed by the source [iterable] do not need to be unique. The
  /// last occurrence of a key will simply overwrite any previous value.
  ///
  factory IMap.fromIterable(
    Iterable iterable, {
    K Function(dynamic) keyMapper,
    V Function(dynamic) valueMapper,
    ConfigMap config,
  }) {
    Map<K, V> map = Map.fromIterable(iterable, key: keyMapper, value: valueMapper);
    return IMap._(map, config: config ?? defaultConfig);
  }

  factory IMap.fromIterables(Iterable<K> keys, Iterable<V> values, {ConfigMap config}) {
    Map<K, V> map = Map.fromIterables(keys, values);
    return IMap._(map, config: config ?? defaultConfig);
  }

  /// Unsafe constructor. Use this at your own peril.
  /// This constructor is fast, since it makes no defensive copies of the map.
  /// However, you should only use this with a new map you"ve created yourself,
  /// when you are sure no external copies exist. If the original map is modified,
  /// it will break the IMap and any other derived maps in unpredictable ways.
  IMap.unsafe(Map<K, V> map, {@required this.config})
      : assert(config != null),
        _m = (map == null) ? MFlat.empty<K, V>() : MFlat<K, V>.unsafe(map) {
    if (ImmutableCollection.disallowUnsafeConstructors)
      throw UnsupportedError("IMap.unsafe is disallowed.");
  }

  /// Returns an empty [IMap], with the given configuration. If a
  /// configuration is not provided, it will use the default configuration.
  /// Note: If you want to create an empty immutable collection of the same
  /// type and same configuration as a source collection, simply call [clear]
  /// in the source collection.
  static IMap<K, V> empty<K, V>([ConfigMap config]) =>
      IMap._unsafe(MFlat.empty<K, V>(), config: config ?? defaultConfig);

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
  /// before it is eligible for auto-flush. Must be larger than 0.
  static int get flushFactor => _flushFactor;

  /// Global configuration that specifies if auto-flush of [IMap]s should be
  /// async. The default is true. When the autoflush is async, it will only
  /// happen after the async gap, no matter how many operations a collection
  /// undergoes. When the autoflush is sync, it may flush one or more times
  /// during the same task.
  static bool get asyncAutoflush => _asyncAutoflush;

  static set defaultConfig(ConfigMap config) {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _defaultConfig =
        config ?? const ConfigMap(isDeepEquals: true, sortKeys: true, sortValues: true);
  }

  static set flushFactor(int value) {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    if (value > 0)
      _flushFactor = value;
    else
      throw StateError("flushFactor can't be $value.");
  }

  static set asyncAutoflush(bool value) {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    if (value != null) _asyncAutoflush = value;
  }

  static ConfigMap _defaultConfig =
      const ConfigMap(isDeepEquals: true, sortKeys: true, sortValues: true);

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
  /// in methods which create new IMaps or flush the map.
  void _count() {
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

  /// Unsafe.
  IMap._(Map<K, V> map, {@required this.config}) : _m = MFlat<K, V>.unsafe(map);

  /// Unsafe.
  IMap._unsafe(this._m, {@required this.config});

  /// Unsafe.
  IMap._unsafeFromMap(Map<K, V> map, {@required this.config})
      : assert(config != null),
        _m = (map == null) ? MFlat.empty<K, V>() : MFlat<K, V>.unsafe(map);

  /// Creates a map with `identityEquals` (compares the internals by `identity`).
  IMap<K, V> get withIdentityEquals =>
      config.isDeepEquals ? IMap._unsafe(_m, config: config.copyWith(isDeepEquals: false)) : this;

  /// Creates a map with `deepEquals` (compares all map entries by equality).
  IMap<K, V> get withDeepEquals =>
      config.isDeepEquals ? this : IMap._unsafe(_m, config: config.copyWith(isDeepEquals: true));

  bool get isDeepEquals => config.isDeepEquals;

  bool get isIdentityEquals => !config.isDeepEquals;

  /// Returns an [Iterable] of the map entries of type [MapEntry].
  /// Note this is always fast and UNORDERED.
  /// If you need order, please use [entryList].
  Iterable<MapEntry<K, V>> get entries => _m.entries;

  /// Returns an [Iterable] of the map entries of type [Entry]. On contrary to
  /// [MapEntry], [Entry] is comparable and implements equals and hashcode by
  /// using its key and value. Note this is always fast and UNORDERED.
  Iterable<Entry<K, V>> get comparableEntries => _m.entries.map((e) => e.asEntry);

  /// Returns an [Iterable] of the map keys. Note this is always fast
  /// and UNORDERED. If you need order, please use [keyList].
  Iterable<K> get keys {
    _count();
    return _m.keys;
  }

  /// Returns an [Iterable] of the map values. Note this is always fast
  /// and UNORDERED. If you need order, please use [valueList].
  Iterable<V> get values {
    _count();
    return _m.values;
  }

  /// Returns an [IList] of the map entries.
  /// Optionally, you may provide a [config] for the list.
  /// The list will be sorted if the map's [sortKeys] configuration is true,
  /// or if you explicitly provide a [compare] method.
  ///
  IList<MapEntry<K, V>> entryList({
    int Function(MapEntry<K, V> a, MapEntry<K, V> b) compare,
    ConfigList config,
  }) {
    _count();
    var result = IList<MapEntry<K, V>>.withConfig(entries, config);
    if (compare != null || this.config.sortKeys) result = result.sort(compare);
    return result;
  }

  /// Returns an [IList] of the map keys.
  /// Optionally, you may provide a [config] for the list.
  /// The list will be sorted if the map's [sortKeys] configuration is true,
  /// or if you explicitly provide a [compare] method.
  ///
  IList<K> keyList({
    int Function(K a, K b) compare,
    ConfigList config,
  }) {
    _count();
    var result = IList.withConfig(keys, config);
    if (compare != null || this.config.sortKeys) result = result.sort(compare);
    return result;
  }

  /// Returns an [IList] of the map values.
  /// Optionally, you may provide a [config] for the list.
  /// The list will be sorted if the map's [sortValues] configuration is true,
  /// or if you explicitly provide a [compare] method.
  ///
  IList<V> valueList({
    int Function(V a, V b) compare,
    ConfigList config,
  }) {
    _count();
    var result = IList.withConfig(values, config);
    if (compare != null || this.config.sortValues) result = result.sort(compare);
    return result;
  }

  /// Returns an [ISet] of the map entries.
  /// Optionally, you may provide a [config] for the set.
  ISet<MapEntry<K, V>> entrySet({
    ConfigSet config,
  }) =>
      ISet.withConfig(entries, config);

  /// Returns an [ISet] of the map keys.
  /// Optionally, you may provide a [config] for the set.
  ISet<K> keySet({
    ConfigSet config,
  }) {
    _count();
    return ISet.withConfig(keys, config);
  }

  /// Returns an [ISet] of the map values.
  /// Optionally, you may provide a [config] for the set.
  ISet<V> valueSet({
    ConfigSet config,
  }) {
    _count();
    return ISet.withConfig(values, config);
  }

  /// Returns a [List] of the map entries.
  /// The list will be sorted if the map's [sortKeys] configuration is true,
  /// or if you explicitly provide a [compare] method.
  ///
  List<MapEntry<K, V>> toEntryList([int Function(MapEntry<K, V> a, MapEntry<K, V> b) compare]) {
    _count();
    var result = List<MapEntry<K, V>>.of(entries);
    if (compare != null || config.sortKeys) result.sort(compare ?? compareObject);
    return result;
  }

  /// Returns a [List] of the map keys.
  /// The list will be sorted if the map's [sortKeys] configuration is true,
  /// or if you explicitly provide a [compare] method.
  ///
  List<K> toKeyList([int Function(K a, K b) compare]) {
    _count();
    var result = List.of(keys);
    if (compare != null || config.sortKeys) result.sort(compare);
    return result;
  }

  /// Returns a [List] of the map values.
  /// The list will be sorted if the map's [sortValues] configuration is true,
  /// or if you explicitly provide a [compare] method.
  ///
  List<V> toValueList([int Function(V a, V b) compare]) {
    _count();
    var result = List.of(values);
    if (compare != null || config.sortValues) result.sort(compare);
    return result;
  }

  /// Returns an [ISet] of the map entries.
  /// The set will be sorted if the map's [sortKeys] configuration is true,
  /// or if you explicitly provide a [compare] method.
  Set<MapEntry<K, V>> toEntrySet([int Function(MapEntry<K, V> a, MapEntry<K, V> b) compare]) {
    _count();
    return toEntryList(compare).toSet();
  }

  /// Returns a [Set] of the map keys.
  /// The set will be sorted if the map's [sortKeys] configuration is true,
  /// or if you explicitly provide a [compare] method.
  ///
  Set<K> toKeySet([int Function(K a, K b) compare]) {
    _count();
    return toKeyList(compare).toSet();
  }

  /// Returns a [Set] of the map values.
  /// The set will be sorted if the map's [sortValues] configuration is true,
  /// or if you explicitly provide a [compare] method.
  ///
  Set<V> toValueSet([int Function(V a, V b) compare]) {
    _count();
    return toValueList(compare).toSet();
  }

  /// Returns a new `Iterator` that allows iterating the entries of the [IMap].
  /// 1) If the map's [config] has [ConfigMap.sortKeys] `true` (the default),
  /// it will iterate in the natural order of entries. In other words, if the
  /// keys/values are [Comparable], they will be sorted first by
  /// `keyA.compareTo(keyB)`
  /// and then by `valueA.compareTo(valueB)`.
  /// 2) If the map's [config] has [ConfigMap.sortKeys] `false`, or if the
  /// keys/values are not [Comparable], the iterator order is undefined.
  ///
  Iterator<MapEntry<K, V>> get iterator => config.sortKeys ? toEntryList().iterator : _m.iterator;

  /// This iterator is very fast to create, but won't iterate in any particular
  /// order, no matter what the map configuration is.
  Iterator<MapEntry<K, V>> get fastIterator => _m.iterator;

  /// Unlocks the map, returning a regular (mutable, unordered) [Map] of type
  /// [HashMap]. This map is "safe", in the sense that is independent from
  /// the original [IMap].
  Map<K, V> get unlock => _m.unlock;

  /// Unlocks the map, returning a regular (mutable, ordered, sorted) [Map]
  /// of type [LinkedHashMap]. This map is "safe", in the sense that is
  /// independent from the original [IMap].
  Map<K, V> get unlockSorted => <K, V>{}..addEntries(entryList());

  /// Unlocks the map, returning a safe, unmodifiable (immutable) [Map] view.
  /// The word "view" means the set is backed by the original [IMap].
  /// Using this is very fast, since it makes no copies of the [IMap] entries.
  /// However, if you try to use methods that modify the map, like [add],
  /// it will throw an [UnsupportedError].
  /// It is also very fast to lock this map back into an [IMap].
  Map<K, V> get unlockView => UnmodifiableMapView(this);

  /// Unlocks the map, returning a safe, modifiable (mutable) [Map].
  /// Using this is very fast at first, since it makes no copies of the [IMap]
  /// entries. However, if and only if you use a method that mutates the map,
  /// like [add], it will unlock internally (make a copy of all [IMap] entries).
  /// This is transparent to you, and will happen at most only once. In other
  /// words, it will unlock the [IMap], lazily, only if necessary.
  /// If you never mutate the map, it will be very fast to lock this map
  /// back into an [IMap].
  Map<K, V> get unlockLazy => ModifiableMapView(this);

  @override
  bool get isEmpty => _m.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  /// If [isDeepEquals] configuration is `true`:
  /// Will return `true` only if the map entries are equal (not necessarily in
  /// the same order), and the map configurations are equal. This may be slow
  /// for very large maps, since it compares each entry, one by one.
  ///
  /// If [isDeepEquals] configuration is `false`:
  /// Will return `true` only if the maps internals are the same instances
  /// (comparing by identity). This will be fast even for very large maps,
  /// since it doesn't  compare each entry.
  /// Note: This is not the same as `identical(map1, map2)` since it doesn't
  /// compare the maps themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  ///
  @override
  bool operator ==(Object other) => (other is IMap<K, V>)
      ? isDeepEquals
          ? equalItemsAndConfig(other)
          : same(other)
      : false;

  /// Will return `true` only if the [IMap] entries are equal to the entries in
  /// the [Iterable]. Order is irrelevant. This may be slow for very large maps,
  /// since it compares each entry, one by one. To compare with a map, use
  /// method [equalItemsToMap] or [equalItemsToIMap].
  @override
  bool equalItems(covariant Iterable<MapEntry<K, V>> other) =>
      (other == null) ? false : (flush._m as MFlat<K, V>).deepMapEquals_toIterable(other);

  /// Will return true only if the two maps have the same number of entries, and
  /// if the entries of the two maps are pairwise equal on both key and value.
  bool equalItemsToMap(Map<K, V> other) =>
      const MapEquality().equals(UnmodifiableMapView(this), other);

  /// Will return true only if the two maps have the same number of entries, and
  /// if the entries of the two maps are pairwise equal on both key and value.
  bool equalItemsToIMap(IMap<K, V> other) =>
      (flush._m as MFlat<K, V>).deepMapEquals(other.flush._m as MFlat<K, V>);

  @override
  bool equalItemsAndConfig(IMap<K, V> other) =>
      identical(this, other) ||
      (other != null &&
          runtimeType == other.runtimeType &&
          config == other.config &&
          (identical(_m, other._m) ||
              (flush._m as MFlat<K, V>).deepMapEquals(other.flush._m as MFlat<K, V>)));

  /// Will return `true` only if the maps internals are the same instances
  /// (comparing by identity). This will be fast even for very large maps,
  /// since it doesn't  compare each entry.
  /// Note: This is not the same as `identical(map1, map2)` since it doesn't
  /// compare the maps themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  @override
  bool same(IMap<K, V> other) => identical(_m, other._m) && (config == other.config);

  @override
  int get hashCode => isDeepEquals //
      ? (flush._m as MFlat<K, V>).deepMapHashcode() ^ config.hashCode
      : identityHashCode(_m) ^ config.hashCode;

  /// Flushes the map, if necessary. Chainable method.
  /// If the map is already flushed, don't do anything.
  @override
  IMap<K, V> get flush {
    if (!isFlushed) {
      // Flushes the original _m because maybe it's used elsewhere.
      // Or maybe it was flushed already, and we can use it as is.
      _m = MFlat<K, V>.unsafe(_m.getFlushed);
      _counter = 0;
    }
    return this;
  }

  /// Whether this map is already flushed or not.
  @override
  bool get isFlushed => _m is MFlat;

  /// Returns a new map containing the current map plus the given key:value.
  /// (if necessary, the given will override the current).
  IMap<K, V> add(K key, V value) {
    var result = IMap<K, V>._unsafe(_m.add(key: key, value: value), config: config);

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

  /// Returns a new map containing the current map plus the given map.
  /// (if necessary, the given entries will override the current ones).
  IMap<K, V> addAll(IMap<K, V> iMap) {
    var result = IMap<K, V>._unsafe(_m.addAll(iMap), config: config);

    // A map created with `addAll` has a larger counter than both its source
    // maps. This improves the order in which maps are flushed.
    // If the outer map is used, it will be flushed before the source maps.
    // If the source maps are not used directly, they will not flush
    // unnecessarily, and also may be garbage collected.
    result._counter = max(_counter, ((iMap is IMap<K, V>) ? iMap._counter : 0)) + 1;

    return result;
  }

  /// Returns a new map containing the current map plus the given map.
  /// (if necessary, the given entries will override the current ones).
  IMap<K, V> addMap(Map<K, V> map) {
    var result = IMap<K, V>._unsafe(_m.addMap(map), config: config);
    result._counter = _counter + 1;
    return result;
  }

  /// Returns a new map containing the current map plus the given map entries.
  /// (if necessary, the given will override the current).
  IMap<K, V> addEntries(Iterable<MapEntry<K, V>> entries) {
    var result = IMap<K, V>._unsafe(_m.addEntries(entries), config: config);
    result._counter = _counter + 1;
    return result;
  }

  /// Returns a new map containing the current map minus the given key and its
  /// value. However, if the current map doesn't  contain the key, it will
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

  V operator [](K k) {
    _count();
    return _m[k];
  }

  V get(K k) {
    _count();
    return _m[k];
  }

  bool any(bool Function(K key, V value) test) {
    _count();
    return _m.any(test);
  }

  /// Provides a view of this map as having [RK] keys and [RV] instances,
  /// if necessary.
  ///
  /// If this map is already an `IMap<RK, RV>`, it is returned unchanged.
  ///
  /// If this map contains only keys of type [RK] and values of type [RV],
  /// all read operations will work correctly.
  /// If any operation exposes a non-[RK] key or non-[RV] value,
  /// the operation will throw instead.
  ///
  /// Entries added to the map must be valid for both a `IMap<K, V>` and a
  /// `IMap<RK, RV>`.
  IMap<RK, RV> cast<RK, RV>() {
    Object result = _m.cast<RK, RV>();
    if (result is M<RK, RV>)
      return IMap._unsafe(result, config: config);
    else if (result is Map<RK, RV>)
      return IMap._(result, config: config);
    else
      throw AssertionError(result.runtimeType);
  }

  bool anyEntry(bool Function(MapEntry<K, V>) test) {
    _count();
    return _m.anyEntry(test);
  }

  bool contains(K key, V value) {
    _count();
    return _m.contains(key, value);
  }

  bool containsKey(K key) {
    _count();
    return _m.containsKey(key);
  }

  bool containsValue(V value) {
    _count();
    return _m.containsValue(value);
  }

  bool containsEntry(MapEntry<K, V> entry) {
    _count();
    return _m.contains(entry.key, entry.value);
  }

  int get length {
    final int length = _m.length;

    /// Optimization: Flushes the map, if free.
    if (length == 0 && _m is! MFlat)
      _m = MFlat.empty<K, V>();
    else
      _count();

    return length;
  }

  void forEach(void Function(K key, V value) f) {
    _count();
    _m.forEach(f);
  }

  IMap<K, V> where(bool Function(K key, V value) test) =>
      IMap<K, V>._(_m.where(test), config: config);

  IMap<RK, RV> map<RK, RV>(MapEntry<RK, RV> Function(K key, V value) mapper, {ConfigMap config}) =>
      IMap<RK, RV>._(_m.map(mapper),
          config: config ?? ((RK == K && RV == V) ? this.config : defaultConfig));

  @override
  String toString() => "{${entries.map((entry) => "${entry.key}: ${entry.value}").join(", ")}}";

  /// Returns an empty map with the same configuration.
  IMap<K, V> clear() => empty<K, V>(config);

  /// Look up the value of [key], or add a new value if it isn't there.
  ///
  /// Returns the modified map, and sets the [value] associated to [key],
  /// if there is one. Otherwise calls [ifAbsent] to get a new value,
  /// associates [key] to that value, and then sets the new [value].
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
  IMap<K, V> putIfAbsent(K key, V Function() ifAbsent, {Output<V> value}) {
    // TODO: Still need to implement efficiently.
    Map<K, V> map = unlock;
    var result = map.putIfAbsent(key, ifAbsent);
    if (value != null) value.set(result);
    return IMap._unsafeFromMap(map, config: config);
  }

  /// Updates the value for the provided [key].
  ///
  /// Returns the modified map and sets the new [value] of the key.
  ///
  /// If the key is present, invokes [update] with the current value and stores
  /// the new value in the map.
  ///
  /// If the key is not present and [ifAbsent] is provided, calls [ifAbsent]
  /// and adds the key with the returned value to the map.
  ///
  /// It's an error if the key is not present and [ifAbsent] is not provided.
  ///
  IMap<K, V> update(
    K key,
    V Function(V value) update, {
    V Function() ifAbsent,
    Output<V> value,
  }) {
    // TODO: Still need to implement efficiently.
    Map<K, V> map = unlock;
    var result = map.update(key, update, ifAbsent: ifAbsent);
    if (value != null) value.set(result);
    return IMap._unsafeFromMap(map, config: config);
  }

  /// Updates all values.
  ///
  /// Iterates over all entries in the map and updates them with the result
  /// of invoking [update].
  IMap<K, V> updateAll(V Function(K key, V value) update) {
    return IMap._unsafeFromMap(unlock..updateAll(update), config: config);
  }
}

// /////////////////////////////////////////////////////////////////////////////

@visibleForOverriding
abstract class M<K, V> {
  //

  /// The [M] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  /// Note these fallback methods need to calculate the flushed map, but
  /// because that"s immutable, we cache it.
  Map<K, V> _flushed;

  /// Returns the flushed map (flushes it only once).
  /// It is an error to use the flushed map outside of the [M] class.
  Map<K, V> get getFlushed {
    // Note: Flush must be of type LinkedHashMap. It can't sort, but
    // the flush is not suppose to change the order of the items.
    _flushed ??= <K, V>{}..addEntries(entries);
    return _flushed;
  }

  /// Returns a regular Dart (mutable) Map.
  Map<K, V> get unlock => HashMap<K, V>()..addEntries(entries);

  Iterable<MapEntry<K, V>> get entries;

  Iterable<K> get keys => getFlushed.keys;

  Iterable<V> get values => getFlushed.values;

  Iterator<MapEntry<K, V>> get iterator => getFlushed.entries.iterator;

  int get length;

  /// Returns a new map containing the current map plus the given key:value.
  /// However, if the given key already exists in the set,
  /// it will remove the old one and add the new one.
  M<K, V> add({@required K key, @required V value}) {
    bool contains = containsKey(key);
    if (!contains)
      return MAdd<K, V>(this, key, value);
    else {
      var oldValue = this[key];
      return (oldValue == value) //
          ? this
          : MReplace<K, V>(this, key, value);
    }
  }

  /// Adds all key/value pairs of [imap] to this map.
  ///
  /// If a key of [imap] is already in this map, its value is overwritten
  /// (the old value is discarded).
  ///
  /// The operation is equivalent to doing `this[key] = value` for each key
  /// and associated value in imap.
  M<K, V> addAll(IMap<K, V> imap) => MAddAll<K, V>.unsafe(this, imap._m);

  M<K, V> addMap(Map<K, V> map) =>
      MAddAll<K, V>.unsafe(this, MFlat<K, V>.unsafe(Map<K, V>.of(map)));

  M<K, V> addEntries(Iterable<MapEntry<K, V>> entries) =>
      MAddAll<K, V>.unsafe(this, MFlat<K, V>.unsafe(Map<K, V>.fromEntries(entries)));

  /// TODO: FALTA FAZER!!!
  M<K, V> remove(K key) {
    return !containsKey(key) ? this : MFlat<K, V>.unsafe(Map<K, V>.of(getFlushed)..remove(key));
  }

  /// Removes all entries of this map that satisfy the given [predicate].
  ///
  M<K, V> removeWhere(bool Function(K key, V value) predicate) {
    Map<K, V> oldMap = unlock;
    int oldLength = oldMap.length;
    Map<K, V> newMap = oldMap..removeWhere(predicate);
    return (newMap.length == oldLength) ? this : MFlat<K, V>.unsafe(newMap);
  }

  /// Provides a view of this map as having [RK] keys and [RV] instances.
  /// May return M<RK, RV> or Map<RK, RV>.
  Object cast<RK, RV>() => (RK == K && RV == V) ? this : getFlushed.cast<RK, RV>();

  /// Returns true if there is no key/value pair in the map.
  bool get isEmpty => getFlushed.isEmpty;

  /// Returns true if there is at least one key/value pair in the map.
  bool get isNotEmpty => !isEmpty;

  V operator [](K key);

  /// Returns true if this map contains the given [key] with the given [value].
  bool contains(K key, V value) {
    var _value = getFlushed[key];
    return (_value == null) ? _flushed.containsKey(key) : (_value == value);
  }

  /// Returns true if this map contains the given [key].
  ///
  /// Returns true if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  bool containsKey(K key) => getFlushed.containsKey(key);

  /// Returns true if this map contains the given [value].
  ///
  /// Returns true if any of the values in the map are equal to `value`
  /// according to the `==` operator.
  bool containsValue(V value) => getFlushed.containsKey(value);

  bool containsEntry(MapEntry<K, V> entry) => contains(entry.key, entry.value);

  bool any(bool Function(K key, V value) test) =>
      getFlushed.entries.any((entry) => test(entry.key, entry.value));

  bool anyEntry(bool Function(MapEntry<K, V>) test) => getFlushed.entries.any(test);

  bool everyEntry(bool Function(MapEntry<K, V>) test) => getFlushed.entries.every(test);

  // TODO: Marcelo, por favor, verifique a implementação.
  void forEach(void Function(K key, V value) f) => getFlushed.forEach(f);

  // TODO: Is this optimal?
  Map<K, V> where(bool Function(K key, V value) test) {
    final Map<K, V> matches = {};
    getFlushed.forEach((K key, V value) {
      if (test(key, value)) matches[key] = value;
    });
    return matches;
  }

  Map<RK, RV> map<RK, RV>(MapEntry<RK, RV> Function(K key, V value) mapper) =>
      getFlushed.map(mapper);
}

// /////////////////////////////////////////////////////////////////////////////

/// Don't use this class.
@visibleForTesting
class InternalsForTestingPurposesIMap {
  IMap imap;

  InternalsForTestingPurposesIMap(this.imap);

  /// To access the private counter, add this to the test file:
  ///     extension TestExtension on IMap {
  ///        int get counter => InternalsForTestingPurposesIMap(this).counter;}
  int get counter => imap._counter;
}

// /////////////////////////////////////////////////////////////////////////////
