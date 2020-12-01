import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/base/hash.dart";
import "dart:collection";
import "package:meta/meta.dart";

/// An **immutable**, unordered, map of sets.
@immutable
class IMapOfSets<K, V> // ignore: must_be_immutable,
    extends ImmutableCollection<IMapOfSets<K, V>> {
  //
  static ConfigMapOfSets get defaultConfig => _defaultConfig;

  static ConfigMapOfSets _defaultConfig = const ConfigMapOfSets();

  /// Global configuration that specifies if, by default, the [IMapOfSet]s
  /// use equality or identity for their [operator ==].
  /// By default `isDeepEquals: true` (maps of sets are compared by equality),
  /// and `sortKeys: true` and `sortValues: true` (certain map outputs are sorted).
  static set defaultConfig(ConfigMapOfSets config) {
    if (_defaultConfig == config) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError(
          "Can't change the configuration of immutable collections.");
    _defaultConfig = config ?? const ConfigMapOfSets();
  }

  final IMap<K, ISet<V>> _mapOfSets;

  /// The map-of-sets configuration.
  final ConfigMapOfSets config;

  /// Flushes this collection, if necessary. Chainable method.
  /// If collection list is already flushed, don't do anything.
  /// Note: This will flush the map and all its internal sets.
  @override
  IMapOfSets<K, V> get flush {
    _mapOfSets.flush;
    _mapOfSets.values.forEach((ISet<V> s) => s.flush);
    return this;
  }

  /// Whether this collection is already flushed or not.
  /// Note: This will flush the map and all its internal sets.
  @override
  bool get isFlushed => _mapOfSets.isFlushed && _mapOfSets.values.every((ISet<V> s) => s.isFlushed);

  /// Returns an empty [IMapOfSets], with the given configuration. If a
  /// configuration is not provided, it will use the default configuration.
  /// Note: If you want to create an empty immutable collection of the same
  /// type and same configuration as a source collection, simply call [clear]
  /// in the source collection.
  static IMapOfSets<K, V> empty<K, V>([ConfigMapOfSets config]) =>
      IMapOfSets<K, V>.from(null, config: config);

  factory IMapOfSets([Map<K, Iterable<V>> mapOfSets]) => //
      IMapOfSets.withConfig(mapOfSets, defaultConfig);

  factory IMapOfSets.withConfig(
    Map<K, Iterable<V>> mapOfSets,
    ConfigMapOfSets config,
  ) {
    ConfigSet configSet = config?.asConfigSet ?? ISet.defaultConfig;
    ConfigMap configMap = config?.asConfigMap ?? IMap.defaultConfig;

    return (mapOfSets == null)
        ? empty<K, V>()
        : IMapOfSets._unsafe(
            IMap.fromIterables(
              mapOfSets.keys,
              mapOfSets.values.map((value) => ISet.withConfig(value, configSet)),
              config: configMap,
            ),
            config: config ?? defaultConfig,
          );
  }

  /// If you provide [config], the map and all sets will use it.
  IMapOfSets.from(IMap<K, ISet<V>> mapOfSets, {ConfigMapOfSets config})
      : config = config ?? defaultConfig,
        _mapOfSets = (config == null)
            ? mapOfSets ?? IMap.empty<K, ISet<V>>()
            : mapOfSets?.map((key, value) => MapEntry(key, value.withConfig(config.asConfigSet)),
                    config: config.asConfigMap) ??
                IMap.empty<K, ISet<V>>(config.asConfigMap);

  IMapOfSets._unsafe(this._mapOfSets, {@required this.config});

  ConfigSet get configSet => config.asConfigSet;

  ConfigMap get configMap => config.asConfigMap;

  bool get isDeepEquals => config.isDeepEquals;

  bool get isIdentityEquals => !config.isDeepEquals;

  /// Creates a new map-of-sets with the given [config] ([ConfigMapOfSets]).
  ///
  /// To copy the config from another [IMapOfSets]:
  ///
  /// ```dart
  /// mapOfSets = mapOfSets.withConfig(other.config);
  /// ```
  ///
  /// To change the current config:
  ///
  /// ```dart
  /// mapOfSets = mapOfSets.withConfig(mapOfSets.config.copyWith(isDeepEquals: isDeepEquals));
  /// ```
  ///
  /// See also: [withIdentityEquals] and [withDeepEquals].
  ///
  IMapOfSets<K, V> withConfig(ConfigMapOfSets config) {
    assert(config != null);
    return (config == this.config) ? this : IMapOfSets._unsafe(_mapOfSets, config: config);
  }

  Map<K, Set<V>> get unlock {
    Map<K, Set<V>> result = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      result[entry.key] = entry.value.unlock;
    }
    return result;
  }

  /// The number of keys.
  int get lengthOfKeys => _mapOfSets.length;

  /// The sum of the number of values of all sets.
  int get lengthOfValues => values.length;

  /// The sum of the number of unique values of all sets.
  int get lengthOfNonRepeatingValues => valuesAsSet.length;

  /// Return iterable of entries, where each entry is the key:set pair.
  ///
  /// For example, if the map is {1: {a, b}, 2: {x, y}},
  /// it will return [(1:{a,b}), 2:{x, y}].
  Iterable<MapEntry<K, ISet<V>>> get entries => _mapOfSets.entries;

  Iterable<K> get keys => _mapOfSets.keys;

  Iterable<ISet<V>> get sets => _mapOfSets.values;

  /// Return all values of all sets, including duplicates.
  Iterable<V> get values sync* {
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      for (V value in entry.value) {
        yield value;
      }
    }
  }

  /// Return a flattened iterable of <K, V> entries (including eventual duplicates),
  /// where each entry is a key:value pair.
  /// For example, if the map is {1: {a, b}, 2: {x, y}},
  /// it will return [(1:a), (1:b), (2:x), (2:y)].
  Iterable<MapEntry<K, V>> flatten() sync* {
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      for (V value in entry.value) {
        yield MapEntry<K, V>(entry.key, value);
      }
    }
  }

  ISet<MapEntry<K, ISet<V>>> get entriesAsSet => ISet(entries).withDeepEquals;

  ISet<K> get keysAsSet => ISet(keys).withDeepEquals;

  ISet<ISet<V>> get setsAsSet => ISet(sets).withDeepEquals;

  /// Return all values of all sets, removing duplicates.
  ISet<V> get valuesAsSet {
    var result = HashSet<V>();
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      result.addAll(set);
    }
    return ISet<V>(result).withDeepEquals;
  }

  /// Order is undefined.
  IList<K> get keysAsList => IList(keys).withDeepEquals;

  IList<ISet<V>> get setsAsList => IList(sets).withDeepEquals;

  @override
  bool get isEmpty => _mapOfSets.isEmpty;

  @override
  bool get isNotEmpty => _mapOfSets.isNotEmpty;

  /// Find the [key]/[set] entry, and add the [value] to the [set].
  /// If the [key] doesn't exist, will first create it with an empty [set],
  /// and then add the [value] to it.
  ///
  IMapOfSets<K, V> add(K key, V value) {
    ISet<V> set = _mapOfSets[key] ?? ISet<V>();
    ISet<V> newSet = set.add(value);
    return set.same(newSet) ? this : replaceSet(key, newSet);
  }

  /// Find the [key]/[set] entry, and add all the [values] to the [set].
  /// If the [key] doesn't  exist, will first create it with an empty [set],
  /// and then add the [values] to it.
  ///
  IMapOfSets<K, V> addValues(K key, Iterable<V> values) {
    ISet<V> set = _mapOfSets[key] ?? ISet<V>();
    ISet<V> newSet = set.addAll(values);
    return set.same(newSet) ? this : replaceSet(key, newSet);
  }

  /// Add all [values] to each [set] of all given [keys].
  /// If the [key] doesn't exist, it will first create it with an empty [set],
  /// and then add the [values] to it.
  ///
  IMapOfSets<K, V> addValuesToKeys(Iterable<K> keys, Iterable<V> values) {
    var result = this;
    for (K key in keys) {
      result = result.addValues(key, values);
    }
    return result;
  }

  /// Find the [key]/[set] entry, and remove the [value] from the [set].
  /// If the [key] doesn't  exist, don't do anything.
  /// It the [set] becomes empty and [removeEmptySets] is true,
  /// the [key] will be removed entirely. Otherwise, the [key] will be kept
  /// and the [set] will be empty (not null).
  ///
  IMapOfSets<K, V> remove(K key, V value) {
    ISet<V> set = _mapOfSets[key];
    if (set == null) return this;
    ISet<V> newSet = set.remove(value);

    return set.same(newSet)
        ? this
        : (config.removeEmptySets && newSet.isEmpty)
            ? removeSet(key)
            : replaceSet(key, newSet);
  }

  /// Remove all given [values] from all sets.
  /// It some [set] becomes empty and [removeEmptySets] is true,
  /// its [key] will be removed entirely. Otherwise, its [key] will be kept
  /// and the [set] will be empty (not null).
  /// If you want, you can pass [numberOfRemovedValues] to get the number of
  /// removed values.
  ///
  IMapOfSets<K, V> removeValues(
    List<V> values, {
    Output<int> numberOfRemovedValues,
  }) {
    int countRemoved = 0;

    Map<K, ISet<V>> map = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      K key = entry.key;
      ISet<V> set = entry.value;
      int setLength = set.length;

      ISet<V> newSet;
      int newSetLength;
      if (setLength == 0) {
        newSet = set;
        newSetLength = 0;
      } else {
        newSet = set.removeAll(values);
        newSetLength = newSet.length;
      }

      countRemoved += setLength - newSetLength;

      if (newSetLength == 0 && config.removeEmptySets) {
        // Set is empty. Discard the key:set.
      } else if (setLength == newSetLength) {
        // Set was NOT modified.
        map[key] = set;
      } else {
        // Set was modified.
        map[key] = newSet;
      }
    }

    if (numberOfRemovedValues != null) numberOfRemovedValues.set(countRemoved);

    return (countRemoved == 0) ? this : IMapOfSets<K, V>._unsafe(map.lock, config: config);
  }

  /// Remove, from all sets, all given [values] that satisfy the given [test].
  /// If some [set] becomes empty, the [key] will be removed entirely.
  /// If you want, you can pass [numberOfRemovedValues] to get the number of removed values.
  ///
  IMapOfSets<K, V> removeValuesWhere(
    bool Function(K key, V value) test, {
    Output<int> numberOfRemovedValues,
  }) {
    int countRemoved = 0;

    Map<K, ISet<V>> map = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      K key = entry.key;
      ISet<V> set = entry.value;
      int setLength = set.length;

      ISet<V> newSet;
      int newSetLength;
      if (setLength == 0) {
        newSet = set;
        newSetLength = 0;
      } else {
        newSet = set.removeWhere((value) => test(key, value));
        newSetLength = newSet.length;
      }

      countRemoved += setLength - newSetLength;

      if (newSetLength == 0 && config.removeEmptySets) {
        // Set is empty. Discard the key:set.
      } else if (setLength == newSetLength) {
        // Set was NOT modified.
        map[key] = set;
      } else {
        // Set was modified.
        map[key] = newSet;
      }
    }

    if (numberOfRemovedValues != null) numberOfRemovedValues.set(countRemoved);

    return (countRemoved == 0) ? this : IMapOfSets<K, V>._unsafe(map.lock, config: config);
  }

  /// Removes the [value] from the [set] of the corresponding [key],
  /// if it exists in the [set]. Otherwise, adds it to the [set].
  IMapOfSets<K, V> toggle(K key, V value) =>
      contains(key, value) ? remove(key, value) : add(key, value);

  /// When [removeEmptySets] is true:
  /// If the given [set] is not empty, add the [key]/[set] entry.
  /// If the [key] already exists, replace it with the new [set] entirely.
  /// If the given [set] is empty, the [key]/[set] entry will be removed
  /// (same as calling [removeSet]).
  ///
  /// When [removeEmptySets] is false:
  /// Add the [key]/[set] entry. If the [key] already exists, replace it with
  /// the new [set] entirely.
  ///
  IMapOfSets<K, V> replaceSet(K key, ISet<V> set) {
    assert(set != null);
    return (config.removeEmptySets && set.isEmpty)
        ? removeSet(key)
        : IMapOfSets<K, V>.from(
            _mapOfSets.add(key, set),
            config: config,
          );
  }

  /// When [removeEmptySets] is true, the given [key] and its corresponding
  /// [set] will be removed. This is the same as calling [removeSet].
  ///
  /// When [removeEmptySets] is false, the [set] for the corresponding [key]
  /// will become empty.
  ///
  IMapOfSets<K, V> clearSet(K key) => replaceSet(key, ISet.empty<V>());

  /// Remove the given [key], if it exists, and its corresponding [set].
  /// If the [key] doesn't  exist, don't do anything.
  ///
  IMapOfSets<K, V> removeSet(K key) {
    IMap<K, ISet<V>> newMapOfSets = _mapOfSets.remove(key);
    return _mapOfSets.same(newMapOfSets)
        ? this
        : IMapOfSets<K, V>.from(newMapOfSets, config: config);
  }

  /// Return the [set] for the given [key].
  /// If the [key] doesn't  exist, return an empty set (never return `null`).
  ISet<V> get(K key) => _mapOfSets[key] ?? ISet.empty<V>(config.asConfigSet);

  /// Return the [set] for the given [key].
  /// If the [key] doesn't  exist, return an empty set (never return `null`).
  ISet<V> getOrNull(K key) => _mapOfSets[key];

  /// Return the [set] for the given [key].
  /// If the [key] doesn't  exist, return `null`.
  ISet<V> operator [](K key) => _mapOfSets[key];

  /// Return `true` if the given [key] exists.
  bool containsKey(K key) => _mapOfSets.containsKey(key);

  /// Return any `key:set` entry where the value exists in the set.
  /// If that entry doesn't exist, return `null`.
  MapEntry<K, ISet<V>> getEntryWithValue(V value) {
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      if (set.contains(value)) return entry;
    }
    return null;
  }

  /// Return any key entry where the value exists in its set.
  /// If it doesn't  find the value, return `null`.
  K getKeyWithValue(V value) => getEntryWithValue(value)?.key;

  /// Return any `key:set` entry where the value exists in the set.
  /// If that entry doesn't  exist, return `null`.
  Set<MapEntry<K, ISet<V>>> allEntriesWithValue(V value) {
    Set<MapEntry<K, ISet<V>>> entriesWithValue = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      if (set.contains(value)) entriesWithValue.add(entry);
    }
    return entriesWithValue;
  }

  Set<K> allKeysWithValue(V value) {
    Set<K> keysWithValue = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      if (set.contains(value)) keysWithValue.add(entry.key);
    }
    return keysWithValue;
  }

  /// Return true if the value exists in any of the sets.
  bool containsValue(V value) => getEntryWithValue(value) != null;

  /// Return `true` if the given [key] entry exists, and its set contains the given [value].
  bool contains(K key, V value) => get(key).contains(value);

  @override
  String toString() => _mapOfSets.toString();

  /// If [isDeepEquals] configuration is `true`:
  /// Will return `true` only if the map entries are equal (not necessarily in the same order),
  /// and the map configurations are equal. This may be slow for very
  /// large maps, since it compares each entry, one by one.
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
  bool operator ==(Object other) => (other is IMapOfSets<K, V>)
      ? isDeepEquals
          ? equalItemsAndConfig(other)
          : same(other)
      : false;

  /// Will return true only if the ISet has the same number of items as the
  /// iterable, and the ISet items are equal to the iterable items, in whatever
  /// order. This may be slow for very large sets, since it compares each item,
  /// one by one.
  @override
  bool equalItems(covariant Iterable<MapEntry<K, ISet<V>>> other) => _mapOfSets.equalItems(other);

  @override
  bool equalItemsAndConfig(IMapOfSets<K, V> other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        config == other.config &&
        (identical(_mapOfSets, other._mapOfSets) || _mapOfSets.equalItemsToIMap(other._mapOfSets));
  }

  /// Will return true only if the two maps have the same number of entries, and
  /// if the entries of the two maps are pairwise equal on both key and value.
  bool equalItemsToIMap(IMap<K, ISet<V>> other) => _mapOfSets.equalItemsToIMap(other);

  /// Will return true only if the two maps have the same number of entries, and
  /// if the entries of the two maps are pairwise equal on both key and value.
  bool equalItemsToIMapOfSets(IMapOfSets<K, V> other) =>
      _mapOfSets.equalItemsToIMap(other._mapOfSets);

  /// Will return `true` only if the maps internals are the same instances
  /// (comparing by identity). This will be fast even for very large maps,
  /// since it doesn't  compare each entry.
  /// Note: This is not the same as `identical(map1, map2)` since it doesn't
  /// compare the maps themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  @override
  bool same(IMapOfSets<K, V> other) =>
      identical(_mapOfSets, other._mapOfSets) && (config == other.config);

  @override
  int get hashCode {
    return isDeepEquals //
        ? hashObj2(_mapOfSets, config)
        : hash2(identityHashCode(_mapOfSets), config.hashCode);
  }

  /// Adds all set values to this map.
  ///
  /// For each key that is already in this map, its resulting set will contain
  /// the values of the original map, plus the ones of the other [map].
  ///
  /// For example: if `map = {"a": {1, 2}}`, then
  /// `map.addAll({"a": {3}, "b": {4}})` will result in
  /// `{"a": {1, 2, 3}, "b": {4}}`
  ///
  /// The operation is equivalent to doing [addValues] for each key:set in [map].
  ///
  IMapOfSets<K, V> addMap(Map<K, Set<V>> map) {
    return addEntries(map.entries);
  }

  /// Adds all set values to this map.
  ///
  /// For each key that is already in this map, its resulting set will contain
  /// the values of the original map, plus the ones of the other [map].
  ///
  /// For example: if `map = {"a": {1, 2}}`, then
  /// `map.addAll({"a": {3}, "b": {4}})` will result in
  /// `{"a": {1, 2, 3}, "b": {4}}`
  ///
  /// The operation is equivalent to doing [addValues] for each key:set in [map].
  ///
  IMapOfSets<K, V> addIMap(IMap<K, Set<V>> map) {
    return addEntries(map.entries);
  }

  /// Adds all set values to this map.
  ///
  /// For each key that is already in this map, its resulting set will contain
  /// the values of the original map, plus the ones of the other [entries].
  ///
  /// For example: if `map = {"a": {1, 2}}`, then
  /// `map.addAll({"a": {3}, "b": {4}})` will result in
  /// `{"a": {1, 2, 3}, "b": {4}}`
  ///
  /// The operation is equivalent to doing [addValues] for each key:set in [entries].
  ///
  IMapOfSets<K, V> addEntries(Iterable<MapEntry<K, Set<V>>> entries) {
    IMapOfSets<K, V> imap = this;
    for (MapEntry<K, Set<V>> entry in entries) {
      var key = entry.key;
      var setOfValues = entry.value;
      imap = imap.addValues(key, setOfValues);
    }
    return imap;
  }

  /// Provides a view of this map of sets as having [RK] keys and [RV] instances,
  /// if necessary.
  ///
  /// If this map is already a `IMapOfSets<RK, RV>`, it is returned unchanged.
  ///
  /// If this map contains only keys of type [RK] and values of type [RV],
  /// all read operations will work correctly.
  /// If any operation exposes a non-[RK] key or non-[RV] value,
  /// the operation will throw instead.
  ///
  /// Entries added to the map must be valid for both a `IMapOfSets<K, V>` and a
  /// `IMapOfSets<RK, RV>`.
  IMapOfSets<RK, RV> cast<RK, RV>() {
    IMap<RK, ISet<RV>> result = _mapOfSets.cast<RK, ISet<RV>>();
    return IMapOfSets.from(result, config: config);
  }

  IMapOfSets<K, V> clear() => empty<K, V>(config);

  void forEach(void Function(K key, ISet<V> set) f) => _mapOfSets.forEach(f);

  IMapOfSets<RK, RV> map<RK, RV>(
    MapEntry<RK, ISet<RV>> Function(K key, ISet<V> set) mapper, {
    ConfigMapOfSets config,
  }) =>
      IMapOfSets<RK, RV>.from(_mapOfSets.map(mapper), config: config ?? defaultConfig);

  /// Removes all entries (key:set pair) of this map that satisfy the given [predicate].
  IMapOfSets<K, V> removeWhere(bool Function(K key, ISet<V> set) predicate) =>
      IMapOfSets<K, V>.from(_mapOfSets.removeWhere(predicate), config: config);

  /// Updates the [set] for the provided [key].
  ///
  /// If the key is present, invokes [update] with the current [set] and stores
  /// the new set in the map.
  ///
  /// If the key is not present and [ifAbsent] is provided, calls [ifAbsent]
  /// and adds the key with the returned [set] to the map.
  ///
  /// It's an error if the key is not present and [ifAbsent] is not provided.
  ///
  IMapOfSets<K, V> update(K key, ISet<V> Function(ISet<V> set) update,
          {ISet<V> Function() ifAbsent}) =>
      IMapOfSets<K, V>.from(_mapOfSets.update(key, update, ifAbsent: ifAbsent), config: config);

  /// Updates all sets.
  ///
  /// Iterates over all key:set entries in the map and updates them with the result
  /// of invoking [update].
  IMapOfSets<K, V> updateAll(ISet<V> Function(K key, ISet<V> set) update) =>
      IMapOfSets<K, V>.from(_mapOfSets.updateAll(update), config: config);

  /// Return a map where the keys are the values, and the values are the keys.
  IMapOfSets<V, K> invertKeysAndValues([ConfigMapOfSets config]) {
    Map<V, Set<K>> result = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      K key = entry.key;
      ISet<V> set = entry.value;
      for (V value in set) {
        var destSet = result[value];
        if (destSet == null) {
          destSet = {};
          result[value] = destSet;
        }
        destSet.add(key);
      }
    }
    return IMapOfSets<V, K>.withConfig(result, config);
  }
}
