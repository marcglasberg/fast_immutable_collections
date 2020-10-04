import 'dart:collection';

import 'package:meta/meta.dart';

import '../ilist/ilist.dart';
import '../imap/imap.dart';
import '../iset/iset.dart';

/// An immutable unordered map of sets.
@immutable
class IMapOfSets<K, V> {
  final IMap<K, ISet<V>> _mapOfSets;

  IMapOfSets([IMap<K, ISet<V>> mapOfSets])
      : _mapOfSets = mapOfSets ?? IMap.empty<K, ISet<V>>().deepEquals {
    if (mapOfSets != null && mapOfSets.values.any((set) => set.isIdentityEquals))
      throw ArgumentError("All sets in a MapOfSets must be deepEquals.");
  }

  static IMapOfSets<K, V> empty<K, V>() => IMapOfSets<K, V>();

  Iterable<MapEntry<K, ISet<V>>> get entries => _mapOfSets.entries;

  ISet<MapEntry<K, ISet<V>>> get entrySet => ISet(entries).deepEquals;

  Iterable<K> get keys => _mapOfSets.keys;

  Iterable<ISet<V>> get sets => _mapOfSets.values;

  /// Order is undefined.
  IList<K> get keyList => IList(keys).deepEquals;

  ISet<K> get keySet => ISet(keys).deepEquals;

  IList<ISet<V>> get setList => IList(sets).deepEquals;

  ISet<ISet<V>> get setSet => ISet(sets).deepEquals;

  bool get isEmpty => _mapOfSets.isEmpty;

  bool get isNotEmpty => _mapOfSets.isNotEmpty;

  /// Return all values of all sets.
  ISet<V> get values {
    var result = HashSet<V>();
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      result.addAll(set);
    }
    return ISet<V>(result).deepEquals;
  }

  /// Add the `key:set` entry.
  /// If a set already exists for the key, replace it entirely with the given set.
  /// If the given set is empty, it will not be included, and will remove the `key:set` entry
  /// if it already exists.
  IMapOfSets<K, V> addSet(K key, ISet<V> set) {
    assert(set != null);
    return set.isEmpty ? removeSet(key) : IMapOfSets<K, V>(_mapOfSets.add(key, set));
  }

  /// Remove the `key:set` entry, if it exists.
  /// If it doesn't exist, doesn't do anything.
  IMapOfSets<K, V> removeSet(K key) {
    IMap<K, ISet<V>> newMapOfSets = _mapOfSets.remove(key);
    return identical(_mapOfSets, newMapOfSets) ? this : IMapOfSets<K, V>(newMapOfSets);
  }

  /// Find the `key:set` entry, or create it if necessary,
  /// and then add the value to the set.
  IMapOfSets<K, V> add(K key, V value) {
    ISet<V> set = _mapOfSets[key] ?? ISet<V>();
    ISet<V> newSet = set.add(value);
    return identical(set, newSet) ? this : addSet(key, newSet);
  }

  /// Find the `key:set` entry, and then remove the value from the set.
  /// If the `key:set` doesn't exist, doesn't do anything.
  /// It the `key:set` becomes empty, it is removed entirely.
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

  /// Return the set for the given key.
  /// If the key doesn't exist, return `null`.
  ISet<V> operator [](K key) => _mapOfSets[key];

  /// Return the set for the given key.
  /// If the key doesn't exist, return an empty set (never return `null`).
  ISet<V> getOrNull(K key) => _mapOfSets[key];

  /// Return the set for the given key.
  /// If the key doesn't exist, return an empty set (never return `null`).
  ISet<V> get(K key) => _mapOfSets[key] ?? ISet.empty<V>();

  /// Return `true` if the key exists (with a non-empty set).
  bool containsKey(K key) => _mapOfSets.containsKey(key);

  /// Return a `key:set` entry where the value exists in the set.
  /// If the entry doesn't exist, return `null`.
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

  /// Return true if the value exists in any of the sets.
  bool containsValue(V value) => entryWithValue(value) != null;

  /// Return `true` if the `key:set` entry exists, and the set contains the given value.
  bool contains(K key, V value) => get(key).contains(value);

  @override
  String toString() => _mapOfSets.toString();
}
