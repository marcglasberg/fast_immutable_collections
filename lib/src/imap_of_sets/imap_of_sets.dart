import 'dart:collection';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/utils/hash.dart';
import 'package:meta/meta.dart';
import '../ilist/ilist.dart';
import '../imap/imap.dart';
import '../iset/iset.dart';

/// An **immutable**, unordered, map of sets.
@immutable
class IMapOfSets<K, V> //
    extends ImmutableCollection<IMapOfSets<K, V>> {
  //

  final IMap<K, ISet<V>> _mapOfSets;

  /// The map-of-sets configuration.
  final ConfigMapOfSets config;

  static IMapOfSets<K, V> empty<K, V>() => IMapOfSets<K, V>.from(null);

  factory IMapOfSets([Map<K, Iterable<V>> mapOfSets]) => //
      IMapOfSets.withConfig(mapOfSets, defaultConfigMapOfSets);

  factory IMapOfSets.withConfig(
    Map<K, Iterable<V>> mapOfSets,
    ConfigMapOfSets config,
  ) {
    ConfigSet configSet = config?.asConfigSet ?? defaultConfigSet;
    ConfigMap configMap = config?.asConfigMap ?? defaultConfigMap;

    return (mapOfSets == null)
        ? empty<K, V>()
        : IMapOfSets._unsafe(
            IMap.fromIterables(
              mapOfSets.keys,
              mapOfSets.values.map((value) => ISet.withConfig(value, configSet)),
              config: configMap,
            ),
            config: config ?? defaultConfigMapOfSets,
          );
  }

  /// If you provide [config], the map and all sets will use it.
  IMapOfSets.from(IMap<K, ISet<V>> mapOfSets, {ConfigMapOfSets config})
      : config = config ?? defaultConfigMapOfSets,
        _mapOfSets = (config == null)
            ? mapOfSets ?? IMap.empty<K, ISet<V>>()
            : mapOfSets.map((key, value) => MapEntry(key, value.withConfig(config.asConfigSet)),
                    config: config.asConfigMap) ??
                IMap.empty<K, ISet<V>>(config.asConfigMap);

  IMapOfSets._unsafe(this._mapOfSets, {@required this.config});

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

  /// Return a flattened iterable of each value (including eventual duplicates),
  /// as <K, V> entries. For example, if the map is {1: {a, b}, 2: {x, y}}, it
  /// will return [(1:a), (1:b), (2:x), (2:y)].
  Iterable<MapEntry<K, V>> flatten() sync* {
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      for (V value in entry.value) {
        yield MapEntry<K, V>(entry.key, value);
      }
    }
  }

  // TODO: shouldn't the names for these be like `entriesAsISet`, `keysAsISet`, etc?
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
    return identical(set, newSet) ? this : addSet(key, newSet);
  }

  /// Find the [key]/[set] entry, and remove the [value] from the [set].
  /// If the [key] doesn't exist, don't do anything.
  /// It the [set] becomes empty, the [key] will be removed entirely.
  ///
  IMapOfSets<K, V> remove(K key, V value) {
    ISet<V> set = _mapOfSets[key];
    if (set == null) return this;
    ISet<V> newSet = set.remove(value);

    if (identical(set, newSet))
      return this;
    else if (newSet.isEmpty)
      return removeSet(key);
    else
      return addSet(key, newSet);
  }

  /// Removes the [value] from the [set] of the corresponding [key],
  /// if it exists in the [set]. Otherwise, adds it to the [set].
  IMapOfSets<K, V> toggle(K key, V value) =>
      contains(key, value) ? remove(key, value) : add(key, value);

  /// If the given [set] is not empty, add the [key]/[set] entry.
  /// If the [key] already exists, replace it with the new [set] entirely.
  ///
  /// If the given [set] is empty, the [key]/[set] entry will be removed
  /// (same as calling [removeSet]).
  ///
  IMapOfSets<K, V> addSet(K key, ISet<V> set) {
    assert(set != null);
    return set.isEmpty
        ? removeSet(key)
        : IMapOfSets<K, V>.from(
            _mapOfSets.add(key, set),
            config: config,
          );
  }

  /// Remove the given [key], if it exists, and its corresponding [set].
  /// If the [key] doesn't exist, don't do anything.
  ///
  IMapOfSets<K, V> removeSet(K key) {
    IMap<K, ISet<V>> newMapOfSets = _mapOfSets.remove(key);
    return identical(_mapOfSets, newMapOfSets)
        ? this
        : IMapOfSets<K, V>.from(
            newMapOfSets,
            config: config,
          );
  }

  /// Return the [set] for the given [key].
  /// If the [key] doesn't exist, return an empty set (never return `null`).
  ISet<V> get(K key) => _mapOfSets[key] ?? ISet.empty<V>(config.asConfigSet);

  /// Return the [set] for the given [key].
  /// If the [key] doesn't exist, return an empty set (never return `null`).
  ISet<V> getOrNull(K key) => _mapOfSets[key];

  /// Return the [set] for the given [key].
  /// If the [key] doesn't exist, return `null`.
  ISet<V> operator [](K key) => _mapOfSets[key];

  /// Return `true` if the given [key] exists (with a non-empty [set]).
  bool containsKey(K key) => _mapOfSets.containsKey(key);

  /// Return any `key:set` entry where the value exists in the set.
  /// If that entry doesn't exist, return `null`.
  MapEntry<K, ISet<V>> entryWithValue(V value) {
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      if (set.contains(value)) return entry;
    }
    return null;
  }

  /// Return any key entry where the value exists in its set.
  /// If it doesn't find the value, return `null`.
  K keyWithValue(V value) => entryWithValue(value)?.key;

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

  Set<K> allKeysWithValue(V value) {
    Set<K> keysWithValue = {};
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      if (set.contains(value)) keysWithValue.add(entry.key);
    }
    return keysWithValue;
  }

  /// Return true if the value exists in any of the sets.
  bool containsValue(V value) => entryWithValue(value) != null;

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
  /// since it doesn't compare each entry.
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

  @override
  bool equalItems(Iterable other) => throw UnsupportedError("Work in progress!");

  @override
  bool equalItemsAndConfig(IMapOfSets<K, V> other) =>
      identical(this, other) ||
      other is IMapOfSets<K, V> &&
          runtimeType == other.runtimeType &&
          config == other.config &&
          _mapOfSets == other._mapOfSets;

  /// Will return `true` only if the maps internals are the same instances
  /// (comparing by identity). This will be fast even for very large maps,
  /// since it doesn't compare each entry.
  /// Note: This is not the same as `identical(map1, map2)` since it doesn't
  /// compare the maps themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  @override
  bool same(IMapOfSets<K, V> other) =>
      identical(_mapOfSets, other._mapOfSets) && (config == other.config);

  @override
  int get hashCode => isDeepEquals //
      ? hash2(_mapOfSets, config)
      : identityHashCode(_mapOfSets) ^ config.hashCode;

  void addAll(Map<K, Set<V>> other) {
    // TODO: implement addAll
    throw UnimplementedError("MISSING");
  }

  void addEntries(Iterable<MapEntry<K, Set<V>>> newEntries) {
    // TODO: implement addEntries
    throw UnimplementedError("MISSING");
  }

  Map<RK, RV> cast<RK, RV>() {
    // TODO: implement cast
    throw UnimplementedError("MISSING");
  }

  void clear() {
    // TODO: implement clear
    throw UnimplementedError("MISSING");
  }

  void forEach(void Function(K key, Set<V> value) f) {
    // TODO: implement forEach
    throw UnimplementedError("MISSING");
  }

  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, Set<V> value) f) {
    // TODO: implement map
    throw UnimplementedError("MISSING");
  }

  Set<V> putIfAbsent(K key, Set<V> Function() ifAbsent) {
    // TODO: implement putIfAbsent
    throw UnimplementedError();
  }

  void removeWhere(bool Function(K key, Set<V> value) predicate) {
    // TODO: implement removeWhere
    throw UnimplementedError("MISSING");
  }

  Set<V> update(K key, Set<V> Function(Set<V> value) update, {Set<V> Function() ifAbsent}) {
    // TODO: implement update
    throw UnimplementedError("MISSING");
  }

  void updateAll(Set<V> Function(K key, Set<V> value) update) {
    // TODO: implement updateAll
    throw UnimplementedError("MISSING");
  }
}
