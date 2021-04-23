import "dart:collection";

import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/base/hash.dart";
import "package:meta/meta.dart";

/// An **immutable**, **unordered**, map of sets.
@immutable
class IMapOfSets<K, V> // ignore: must_be_immutable,
    extends ImmutableCollection<IMapOfSets<K, V>> {
  //
  static ConfigMapOfSets get defaultConfig => _defaultConfig;

  static ConfigMapOfSets _defaultConfig = const ConfigMapOfSets();

  /// Global configuration that specifies if, by default, the [IMapOfSet]s
  /// use equality or identity for their [operator ==].
  ///
  /// By default `isDeepEquals: true` (maps of sets are compared by equality),
  /// and `sortKeys: true` and `sortValues: true` (certain map outputs are sorted).
  static set defaultConfig(ConfigMapOfSets config) {
    if (_defaultConfig == config) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _defaultConfig = config;
  }

  final IMap<K, ISet<V>> _mapOfSets;

  /// The map-of-sets configuration.
  final ConfigMapOfSets config;

  /// Returns this `IMapOfSets<K, V>` as an `IMap<K, ISet<V>>`.
  IMap<K, ISet<V>> asIMap() => _mapOfSets;

  /// Flushes this collection, if necessary. Chainable method.
  ///
  /// If collection list is already flushed, don't do anything.
  ///
  /// Note: This will flush the map and all its internal sets.
  @override
  IMapOfSets<K, V> get flush {
    _mapOfSets.flush;
    _mapOfSets.values.forEach((ISet<V> s) => s.flush);
    return this;
  }

  /// Whether this collection is already flushed or not.
  ///
  /// Note: This will flush the map and all its internal sets.
  @override
  bool get isFlushed => _mapOfSets.isFlushed && _mapOfSets.values.every((ISet<V> s) => s.isFlushed);

  /// Returns an empty [IMapOfSets], with the given configuration. If a
  /// configuration is not provided, it will use the default configuration.
  ///
  /// Note: If you want to create an empty immutable collection of the same
  /// type and same configuration as a source collection, simply call [clear]
  /// in the source collection.
  static IMapOfSets<K, V> empty<K, V>([ConfigMapOfSets? config]) {
    config ??= defaultConfig;
    return IMapOfSets<K, V>._unsafe(IMap.empty(config.asConfigMap), config);
  }

  factory IMapOfSets([Map<K, Iterable<V>>? mapOfSets]) => //
      IMapOfSets.withConfig(mapOfSets, defaultConfig);

  /// Create an [IMapOfSets] from a map of sets and a [ConfigMapOfSets].
  factory IMapOfSets.withConfig(
    Map<K, Iterable<V>>? mapOfSets,
    ConfigMapOfSets config,
  ) {
    ConfigSet configSet = config.asConfigSet;
    ConfigMap configMap = config.asConfigMap;

    return (mapOfSets == null)
        ? empty<K, V>()
        : IMapOfSets._unsafe(
            IMap.fromIterables(
              mapOfSets.keys,
              mapOfSets.values.map((value) => ISet.withConfig(value, configSet)),
              config: configMap,
            ),
            config,
          );
  }

  /// If [mapOfSets] is `null`, return `null`.
  ///
  /// Otherwise, create an [IMapOfSets] from the [mapOfSets].
  ///
  /// This static factory is useful for implementing a `copyWith` method
  /// that accept regular map of sets. For example:
  ///
  /// ```dart
  /// IMapOfSets<Course, String> studentsPerCourse;
  ///
  /// Students copyWith({ Map<Id, Iterable<String>>? studentsPerCourse }) =>
  ///   Students(studentsPerCourse: IMapOfSets.orNull(studentsPerCourse) ?? this.studentsPerCourse);
  /// ```
  ///
  /// Of course, if your `copyWith` accepts an [IMapOfSets], this is not necessary:
  ///
  /// ```dart
  /// IMapOfSets<Id, String> studentsPerCourse;
  ///
  /// Students copyWith({ IMapOfSets<Id, String>? studentsPerCourse }) =>
  ///   Students(studentsPerCourse: studentsPerCourse ?? this.studentsPerCourse);
  /// ```
  ///
  static IMapOfSets<K, V>? orNull<K, V>(
    Map<K, Iterable<V>>? map, [
    ConfigMapOfSets? config,
  ]) =>
      (map == null) ? null : IMapOfSets.withConfig(map, config ?? defaultConfig);

  /// Creates a map of sets instance in which the keys and values are
  /// computed from the [iterable].
  ///
  /// For each element of the [iterable] it computes a key/value pair,
  /// by applying [keyMapper] and [valueMapper] respectively. When the key
  /// is new, it will be created with a set containing the value. When the key
  /// already exists, each following value will be added to the existing set.
  ///
  /// If [keyMapper] and [valueMapper] are not specified, the default is the
  /// identity function.
  ///
  static IMapOfSets<K, V> fromIterable<K, V, I>(
    Iterable<I> iterable, {
    K Function(I)? keyMapper,
    V Function(I)? valueMapper,
    ConfigMapOfSets? config,
  }) {
    Map<K, Set<V>> map = _mutableMapOfSets<K, V, I>(
      iterable,
      keyMapper: keyMapper,
      valueMapper: valueMapper,
    );
    return IMapOfSets.withConfig(map, config ?? defaultConfig);
  }

  /// **Unsafe**. Note: Does not sort.
  IMapOfSets._unsafe(this._mapOfSets, this.config);

  /// Creates an [IMapOfSets] from an `IMap` of sets.
  /// The resulting map and its sets will be sorted according to [config], or,
  /// if not provided, according to the default configuration for [ConfigMapOfSets].
  ///
  IMapOfSets.from(IMap<K, ISet<V>> imap, {ConfigMapOfSets? config})
      : config = config ?? IMapOfSets.defaultConfig,
        _mapOfSets = _setsWithConfig(imap, config ?? IMapOfSets.defaultConfig);

  static IMap<K, ISet<V>> _setsWithConfig<K, V>(
    IMap<K, ISet<V>> mapOfSets,
    ConfigMapOfSets config,
  ) {
    var configMap = config.asConfigMap;
    var configSet = config.asConfigSet;

    if ((mapOfSets.config == configMap) &&
        (mapOfSets.values.every((set) => set.config == configSet))) return mapOfSets;

    return mapOfSets.map(
      (key, value) => MapEntry(key, value.withConfig(configSet)),
      config: configMap,
    );
  }

  /// The internal [ISet] configuration.
  ConfigSet get configSet => config.asConfigSet;

  /// The internal [IMap] configuration.
  ConfigMap get configMap => config.asConfigMap;

  /// See also: [ConfigMapOfSets]
  bool get isDeepEquals => config.isDeepEquals;

  /// See also: [ConfigMapOfSets]
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
    if (config == this.config)
      return this;
    else {
      // If the new config is not sorted it can use sorted or not sorted.
      // If the new config is sorted it can only use sorted.
      if ((!config.sortKeys || this.config.sortKeys) &&
          (!config.sortValues || this.config.sortValues))
        return IMapOfSets._unsafe(_mapOfSets, config);
      //
      // If the new config is sorted and the previous is not, it must sort.
      else
        return IMapOfSets.from(_mapOfSets, config: config);
    }
  }

  /// Unlocks the map, returning a regular (mutable, ordered) `Map<K, Set<V>` of type
  /// [LinkedHashMap]. This map is "safe", in the sense that is independent from
  /// the original [IMap].
  Map<K, Set<V>> get unlock {
    Map<K, Set<V>> result = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      result[entry.key] = entry.value.unlock;
    }
    return result;
  }

  /// The number of [keys].
  int get lengthOfKeys => _mapOfSets.length;

  /// The sum of the number of [values] of all sets.
  int get lengthOfValues => values.length;

  /// The sum of the number of unique [values] of all sets.
  int get lengthOfNonRepeatingValues => valuesAsSet.length;

  /// Return iterable of entries, where each entry is the key:set pair.
  ///
  /// For example, if the map is `{1: {a, b}, 2: {x, y}}`,
  /// it will return `[(1:{a,b}), 2:{x, y}]`.
  Iterable<MapEntry<K, ISet<V>>> get entries => _mapOfSets.entries;

  /// Return the [MapEntry] for the given [key].
  /// For key/value pairs that don't exist, it will return `MapEntry(key, null);`.
  MapEntry<K, ISet<V>?> entry(K key) => _mapOfSets.entry(key);

  /// Return the [MapEntry] for the given [key].
  /// For key/value pairs that don't exist, it will return null.
  MapEntry<K, ISet<V>>? entryOrNull(K key) => _mapOfSets.entryOrNull(key);

  /// Returns an [Iterable] of the map keys.
  Iterable<K> get keys => _mapOfSets.keys;

  /// Returns an [IList] of the map keys.
  /// Optionally, you may provide a [config] for the list.
  IList<K> keyList({ConfigList? config}) => IList.withConfig(keys, config ?? IList.defaultConfig);

  /// Returns an [Iterable] of the map values.
  Iterable<ISet<V>> get sets => _mapOfSets.values;

  /// Return all values of all sets, in order, including duplicates.
  Iterable<V> get values sync* {
    for (ISet<V> sets in _mapOfSets.values) {
      for (V value in sets) {
        yield value!;
      }
    }
  }

  /// Returns an [IList] of the all values in all sets.
  ///
  /// Optionally, you may provide a [config] for the list.
  ///
  /// The list will be sorted if the map's [sortValues] configuration is `true`,
  /// or if you explicitly provide a [compare] method.
  ///
  IList<V> valueList({ConfigList? config}) =>
      IList.withConfig(values, config ?? IList.defaultConfig);

  /// Return a flattened iterable of <K, V> entries (including eventual duplicates),
  /// where each entry is a key:value pair.
  /// For example, if the map is `{1: {a, b}, 2: {x, y}}`,
  /// it will return [(1:a), (1:b), (2:x), (2:y)].
  Iterable<MapEntry<K, V>> flatten() sync* {
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      for (V value in entry.value) {
        yield MapEntry<K, V>(entry.key, value);
      }
    }
  }

  /// Returns an [ISet] of the [MapEntry]'s.
  ISet<MapEntry<K, ISet<V>>> get entriesAsSet => ISet(entries).withDeepEquals;

  /// Returns an [ISet] of the keys.
  ISet<K> get keysAsSet => ISet(keys).withDeepEquals;

  /// Returns an [ISet] of the internal sets.
  ISet<ISet<V>> get setsAsSet => ISet(sets).withDeepEquals;

  /// Return all [values] of all [sets], removing duplicates.
  ISet<V> get valuesAsSet =>
      ISet.fromIterable(_mapOfSets.entries, mapper: ((MapEntry<K, ISet<V>> e) => e.value));

  /// Return all [keys].
  IList<K> get keysAsList => IList(keys).withDeepEquals;

  /// Returns a list of the internal sets.
  IList<ISet<V>> get setsAsList => IList(sets).withDeepEquals;

  /// Returns `true` if there are no elements in this collection.
  @override
  bool get isEmpty => _mapOfSets.isEmpty;

  /// Returns `true` if there is at least one element in this collection.
  @override
  bool get isNotEmpty => _mapOfSets.isNotEmpty;

  /// Find the [key]/[set] entry, and add the [value] to the [set].
  /// If the [key] doesn't exist, will first create it with an empty [set],
  /// and then add the [value] to it. If the [value] already exists in the
  /// [set], nothing happens.
  ///
  IMapOfSets<K, V> add(K key, V value) {
    ISet<V> set = _mapOfSets[key] ?? ISet.empty<V>(config.asConfigSet);
    ISet<V> newSet = set.add(value);
    return set.same(newSet) ? this : replaceSet(key, newSet);
  }

  /// Find the [key]/[set] entry, and add all the [values] to the [set].
  /// If the [key] doesn't  exist, will first create it with an empty [set],
  /// and then add the [values] to it.
  ///
  IMapOfSets<K, V> addValues(K key, Iterable<V> values) {
    ISet<V> set = _mapOfSets[key] ?? ISet.empty<V>(config.asConfigSet);
    ISet<V> newSet = set.addAll(values);
    return set.same(newSet) ? this : replaceSet(key, newSet);
  }

  /// Add all [values] to each [set] of all given [keys].
  /// If the [key] doesn't exist, it will first create it with an empty [set],
  /// and then add the [values] to it.
  ///
  IMapOfSets<K, V> addValuesToKeys(Iterable<K> keys, Iterable<V> values) {
    IMapOfSets<K, V> result = this;
    for (K key in keys) {
      result = result.addValues(key, values);
    }
    return result;
  }

  /// Find the [key]/[set] entry, and remove the [value] from the [set].
  /// If the [key] doesn't  exist, don't do anything.
  /// If the [set] becomes empty and [removeEmptySets] is `true`,
  /// the [key] will be removed entirely. Otherwise, the [key] will be kept
  /// and the [set] will be empty (not `null`).
  ///
  IMapOfSets<K, V> remove(K key, V value) {
    ISet<V>? set = _mapOfSets[key];
    if (set == null) return this;
    ISet<V> newSet = set.remove(value);

    return set.same(newSet)
        ? this
        : (config.removeEmptySets && newSet.isEmpty)
            ? removeSet(key)
            : replaceSet(key, newSet);
  }

  /// Remove all given [values] from all sets.
  /// If a [set] becomes empty and [removeEmptySets] is `true`,
  /// its [key] will be removed entirely. Otherwise, its [key] will be kept
  /// and the [set] will be empty (not `null`).
  /// If you want, you can pass [numberOfRemovedValues] to get the number of
  /// removed values.
  ///
  IMapOfSets<K, V> removeValues(
    List<V> values, {
    Output<int>? numberOfRemovedValues,
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

    if (numberOfRemovedValues != null) numberOfRemovedValues.save(countRemoved);

    return (countRemoved == 0) ? this : IMapOfSets<K, V>._unsafe(map.lock, config);
  }

  /// Remove, from the given [key] set, all values that satisfy the given [test].
  /// If the set becomes empty, the [key] will be removed entirely.
  ///
  /// See also: [removeValuesWhere] that lets you remove values from many keys.
  ///
  IMapOfSets<K, V> removeValuesFromKeyWhere(
    K key,
    bool Function(V value) test,
  ) =>
      update(key, (ISet<V> set) => set.removeWhere(test));

  /// Remove, from all sets, all given [values] that satisfy the given [test].
  /// If a [set] becomes empty, its [key] will be removed entirely.
  /// If you want, you can pass [numberOfRemovedValues] to get the number of removed values.
  ///
  /// See also: [removeValuesFromKeyWhere] that lets you remove values from a single key.
  ///
  IMapOfSets<K, V> removeValuesWhere(
    bool Function(K key, V value) test, {
    Output<int>? numberOfRemovedValues,
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

    if (numberOfRemovedValues != null) numberOfRemovedValues.save(countRemoved);

    return (countRemoved == 0) ? this : IMapOfSets<K, V>._unsafe(map.lock, config);
  }

  /// Removes the [value] from the set of the corresponding [key],
  /// if it exists in the set. Otherwise, adds it to the set.
  /// If the [key] doesn't exist, it will be created and then have the new value
  /// added to the new, corresponding set.
  ///
  /// However, if can force the [value] to be added or removed by providing
  /// [state] true or false.
  ///
  IMapOfSets<K, V> toggle(K key, V value, {bool? state}) =>
      (state ?? !contains(key, value)) ? add(key, value) : remove(key, value);

  /// - When [removeEmptySets] is `true`:
  /// If the given [set] is not empty, add the [key]/[set] entry.
  /// If the [key] already exists, replace it with the new [set] entirely.
  /// If the given [set] is empty, the [key]/[set] entry will be removed
  /// (same as calling [removeSet]).
  ///
  /// - When [removeEmptySets] is `false`:
  /// Add the [key]/[set] entry. If the [key] already exists, replace it with
  /// the new [set] entirely.
  ///
  IMapOfSets<K, V> replaceSet(K key, ISet<V> set) {
    return (config.removeEmptySets && set.isEmpty)
        ? removeSet(key)
        : IMapOfSets<K, V>._unsafe(_mapOfSets.add(key, set), config);
  }

  /// When [removeEmptySets] is `true`, the given [key] and its corresponding
  /// [set] will be removed. This is the same as calling [removeSet].
  ///
  /// When [removeEmptySets] is `false`, the [set] for the corresponding [key]
  /// will become empty.
  ///
  IMapOfSets<K, V> clearSet(K key) => replaceSet(key, ISet.empty<V>());

  /// Remove the given [key], if it exists, and its corresponding [set].
  /// If the [key] doesn't exist, don't do anything.
  ///
  IMapOfSets<K, V> removeSet(K key) {
    IMap<K, ISet<V>> newMapOfSets = _mapOfSets.remove(key);
    return _mapOfSets.same(newMapOfSets) ? this : IMapOfSets<K, V>._unsafe(newMapOfSets, config);
  }

  /// Return the [set] for the given [key].
  /// If the [key] doesn't exist, return an empty set (never return `null`).
  ISet<V> get(K key) => _mapOfSets[key] ?? ISet.empty<V>(config.asConfigSet);

  /// Return the [set] for the given [key].
  /// If the [key] doesn't exist, return `null`.
  ISet<V>? getOrNull(K key) => _mapOfSets[key];

  /// Return the [set] for the given [key].
  /// If the [key] doesn't exist, return `null`.
  ISet<V>? operator [](K key) => _mapOfSets[key];

  /// Return `true` if the given [key] exists.
  bool containsKey(K key) => _mapOfSets.containsKey(key);

  /// Return any `key:set` entry where the value exists in the set.
  /// If that entry doesn't exist, return `null`.
  MapEntry<K, ISet<V>>? getEntryWithValue(V value) {
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      if (set.contains(value)) return entry;
    }
    return null;
  }

  /// Return any key entry where the value exists in its set.
  /// If it doesn't find the value, return `null`.
  K? getKeyWithValue(V value) => getEntryWithValue(value)?.key;

  /// Return any `key:set` entry where the value exists in the set.
  /// If that entry doesn't exist, return `null`.
  Set<MapEntry<K, ISet<V>>> allEntriesWithValue(V value) {
    Set<MapEntry<K, ISet<V>>> entriesWithValue = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      if (set.contains(value)) entriesWithValue.add(entry);
    }
    return entriesWithValue;
  }

  /// Returns a [Set] of the keys which contain [value].
  Set<K> allKeysWithValue(V value) {
    Set<K> keysWithValue = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      if (set.contains(value)) keysWithValue.add(entry.key);
    }
    return keysWithValue;
  }

  /// Return `true` if the value exists in any of the sets.
  bool containsValue(V value) => getEntryWithValue(value) != null;

  /// Return `true` if the given [key] entry exists, and its set contains the given [value].
  bool contains(K key, V value) => get(key).contains(value);

  /// Returns a string representation of (some of) the elements of `this`.
  ///
  /// Use either the [prettyPrint] or the [ImmutableCollection.prettyPrint] parameters to get a
  /// prettier print.
  ///
  /// See also: [ImmutableCollection]
  @override
  String toString([bool? prettyPrint]) => _mapOfSets.toString(prettyPrint);

  /// - If [isDeepEquals] configuration is `true`:
  /// Will return `true` only if the map entries are equal (not necessarily in the same order),
  /// and the map configurations are equal. This may be slow for very
  /// large maps, since it compares each entry, one by one.
  ///
  /// - If [isDeepEquals] configuration is `false`:
  /// Will return `true` only if the maps internals are the same instances
  /// (comparing by identity). This will be fast even for very large maps,
  /// since it doesn't  compare each entry.
  ///
  /// Note: This is not the same as `identical(map1, map2)` since it doesn't
  /// compare the maps themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  ///
  @override
  bool operator ==(Object other) => (other is IMapOfSets) && isDeepEquals
      ? equalItemsAndConfig(other)
      : (other is IMapOfSets<K, V>) && same(other);

  /// Will return `true` only if the [ISet] has the same number of items as the
  /// iterable, and the [ISet] items are equal to the iterable items, in whatever
  /// order. This may be slow for very large sets, since it compares each item,
  /// one by one.
  @override
  bool equalItems(covariant Iterable<MapEntry> other) => _mapOfSets.equalItems(other);

  /// Will return `true` only if the list items are equal, and the map of sets configurations
  /// ([ConfigMapOfSets]) are equal. This may be slow for very large maps, since it compares each
  /// item, one by one.
  @override
  bool equalItemsAndConfig(IMapOfSets other) {
    if (identical(this, other)) return true;

    return config == other.config &&
        (identical(_mapOfSets, other._mapOfSets) || _mapOfSets.equalItemsToIMap(other._mapOfSets));
  }

  /// Will return `true` only if the two maps have the same number of entries, and
  /// if the entries of the two maps are pairwise equal on both key and value.
  bool equalItemsToIMap<RK, RV>(IMap<RK, ISet<RV>> other) => _mapOfSets.equalItemsToIMap(other);

  /// Will return `true` only if the two maps have the same number of entries, and
  /// if the entries of the two maps are pairwise equal on both key and value.
  bool equalItemsToIMapOfSets(IMapOfSets other) => _mapOfSets.equalItemsToIMap(other._mapOfSets);

  /// Will return `true` only if the maps internals are the same instances
  /// (comparing by identity). This will be fast even for very large maps,
  /// since it doesn't  compare each entry.
  ///
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
  /// `{"a": {1, 2, 3}, "b": {4}}`.
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
    return IMapOfSets._unsafe(result, config);
  }

  /// If [removeEmptySets] is `true`, returns an empty map of sets with the same
  /// configuration. However, if [removeEmptySets] is `false`, keep the keys,
  /// but make their sets empty.
  IMapOfSets<K, V> clear() {
    if (config.removeEmptySets)
      return empty<K, V>(config);
    else {
      var emptySet = ISet.empty<V>(config.asConfigSet);
      return updateAll((K key, ISet<V> set) => emptySet);
    }
  }

  /// Applies the function [f] to each element.
  void forEach(void Function(K key, ISet<V> set) f) => _mapOfSets.forEach(f);

  /// Returns a new map where all entries of this map are transformed by the given [mapper]
  /// function. You may provide a [config], otherwise it will be the same as the original map.
  IMapOfSets<RK, RV> map<RK, RV>(
    MapEntry<RK, ISet<RV>> Function(K key, ISet<V> set) mapper, {
    ConfigMapOfSets? config,
  }) {
    bool Function(RK key, ISet<RV> set)? ifRemove;
    if ((config ?? this.config).removeEmptySets) ifRemove = (RK key, ISet<RV> set) => set.isEmpty;

    return IMapOfSets<RK, RV>.from(
      _mapOfSets.map(mapper, ifRemove: ifRemove),
      config: config ?? this.config,
    );
  }

  /// Removes all entries (key:set pair) of this map that satisfy the given [predicate].
  IMapOfSets<K, V> removeWhere(bool Function(K key, ISet<V> set) predicate) =>
      IMapOfSets<K, V>._unsafe(_mapOfSets.removeWhere(predicate), config);

  /// Updates the [set] for the provided [key].
  ///
  /// If the key is present, invokes [update] with the current [set] and stores
  /// the new set in the map.
  ///
  /// If the key is not present and [ifAbsent] is provided, calls [ifAbsent]
  /// and adds the key with the returned [set] to the map.
  ///
  /// If the key is not present and [ifAbsent] is not provided, return the original map
  /// without modification. Note: If you want [ifAbsent] to throw an error, pass it like
  /// this: `ifAbsent: () => throw ArgumentError();`.
  ///
  /// If you want to get the original set before the update, you can provide the
  /// [previousSet] parameter.
  ///
  IMapOfSets<K, V> update(
    K key,
    ISet<V> Function(ISet<V> set) update, {
    ISet<V> Function()? ifAbsent,
    Output<ISet<V>>? previousSet,
  }) {
    bool Function(K key, ISet<V> set)? ifRemove;
    if (config.removeEmptySets) ifRemove = (K key, ISet<V> set) => set.isEmpty;

    return IMapOfSets<K, V>._unsafe(
        _mapOfSets.update(
          key,
          update,
          ifAbsent: ifAbsent,
          ifRemove: ifRemove,
          previousValue: previousSet,
        ),
        config);
  }

  /// Updates all sets.
  ///
  /// Iterates over all key:set entries in the map and updates them with the result
  /// of invoking [update].
  IMapOfSets<K, V> updateAll(ISet<V> Function(K key, ISet<V> set) update) {
    bool Function(K key, ISet<V> set)? ifRemove;
    if (config.removeEmptySets) ifRemove = (K key, ISet<V> set) => set.isEmpty;

    return IMapOfSets<K, V>._unsafe(_mapOfSets.updateAll(update, ifRemove: ifRemove), config);
  }

  /// Return a map where the keys are the values, and the values are the keys.
  /// Keys of empty sets will be removed.
  /// You can pass a new [config] for the map.
  IMapOfSets<V, K> invertKeysAndValues([ConfigMapOfSets? config]) {
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
    return IMapOfSets<V, K>.withConfig(result, config ?? this.config);
  }

  /// Return a map where the keys are the values, and the values are the keys.
  /// Empty sets will become the key `null`.
  /// You can pass a new [config] for the map.
  IMapOfSets<V?, K> invertKeysAndValuesKeepingNullKeys([ConfigMapOfSets? config]) {
    Map<V?, Set<K>> result = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      K key = entry.key;
      ISet<V> set = entry.value;

      if (set.isEmpty) {
        var destSet = result[null];
        if (destSet == null) {
          destSet = {};
          result[null] = destSet;
        }
        destSet.add(key);
      } else
        for (V? value in set) {
          var destSet = result[value];
          if (destSet == null) {
            destSet = {};
            result[value] = destSet;
          }
          destSet.add(key);
        }
    }

    return IMapOfSets<V?, K>.withConfig(result, config ?? this.config);
  }

  /// Iterates through all values of all sets, and returns the first value
  /// it finds that satisfies [test].
  ///
  /// If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned, or if [orElse] is omitted, it defaults to throwing a [StateError].
  ///
  /// See also: [firstValueWhereOrNull]
  ///
  V firstValueWhere(bool Function(V) test, {V Function()? orElse}) {
    for (ISet<V> values in _mapOfSets.values) {
      V? value = values.firstWhereOrNull(test);
      if (value != null) return value;
    }
    if (orElse != null) return orElse();
    throw StateError("No element");
  }

  /// Iterates through all values of all sets, and returns the first value
  /// it finds that satisfies [test].
  ///
  /// If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned, or if [orElse] is omitted, it returns null.
  ///
  /// See also: [firstValueWhere]
  ///
  V? firstValueWhereOrNull(bool Function(V) test, {V? Function()? orElse}) {
    for (ISet<V> values in _mapOfSets.values) {
      V? value = values.firstWhereOrNull(test);
      if (value != null) return value;
    }
    return orElse?.call();
  }

  /// Creates a mutable map of sets from an [Iterable]
  /// and a [keyMapper] and [valueMapper].
  static Map<K, Set<V>> _mutableMapOfSets<K, V, I>(
    Iterable<I> iterable, {
    K Function(I)? keyMapper,
    V Function(I)? valueMapper,
  }) {
    Map<K, Set<V>> map = {};
    for (I item in iterable) {
      K key = keyMapper == null ? (item as K) : keyMapper(item);
      V value = valueMapper == null ? (item as V) : valueMapper(item);
      Set<V>? set = map[key];
      if (set == null) {
        set = <V>{};
        map[key] = set;
      }
      set.add(value);
    }
    return map;
  }
}
