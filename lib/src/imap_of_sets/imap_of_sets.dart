import 'dart:collection';

import 'package:meta/meta.dart';

import '../ilist/ilist.dart';
import '../imap/imap.dart';
import '../iset/iset.dart';

/// An immutable unordered map of sets.
@immutable
class IMapOfSets<K, V> {
  final IMap<K, ISet<V>> _mapOfSets;

  /// If given, will be used to sort list of keys or lists of entries.
  final int Function(K, K) compareKey;

  /// If given, will be used to sort list of values.
  final int Function(V, V) compareValue;

  factory IMapOfSets([
    Map<K, Set<V>> mapOfSets,
  ]) =>
      IMapOfSets._unsafe(
        IMap.fromIterables(
          mapOfSets.keys,
          mapOfSets.values.map((value) => ISet(value).deepEquals),
        ),
        null,
        null,
      );


  IMapOfSets.from(
    IMap<K, ISet<V>> mapOfSets, {
    this.compareKey,
    this.compareValue,
  }) : _mapOfSets = mapOfSets ?? IMap.empty<K, ISet<V>>().deepEquals {
    if (mapOfSets != null && mapOfSets.values.any((set) => set.isIdentityEquals))
      throw ArgumentError("All sets in a MapOfSets must be deepEquals.");
  }

  IMapOfSets._unsafe(
    this._mapOfSets,
    this.compareKey,
    this.compareValue,
  );

  IMapOfSets<K, V> config({
    int Function(K, K) keyCompare,
    int Function(V, V) valueCompare,
  }) =>
      IMapOfSets._unsafe(_mapOfSets, keyCompare, valueCompare);

  static IMapOfSets<K, V> empty<K, V>() => IMapOfSets<K, V>.from(null);

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

  ISet<MapEntry<K, ISet<V>>> get entriesAsSet => ISet(entries).deepEquals;

  ISet<K> get keysAsSet => ISet(keys).deepEquals;

  ISet<ISet<V>> get setsAsSet => ISet(sets).deepEquals;

  /// Return all values of all sets, removing duplicates.
  ISet<V> get valuesAsSet {
    var result = HashSet<V>();
    for (MapEntry<K, ISet<V>> entry in _mapOfSets.entries) {
      var set = entry.value;
      result.addAll(set);
    }
    return ISet<V>(result).deepEquals;
  }

  /// Order is undefined.
  IList<K> get keysAsList => IList(keys).deepEquals;

  IList<ISet<V>> get setsAsList => IList(sets).deepEquals;

  bool get isEmpty => _mapOfSets.isEmpty;

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
            compareKey: compareKey,
            compareValue: compareValue,
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
            compareKey: compareKey,
            compareValue: compareValue,
          );
  }

  /// Return the [set] for the given [key].
  /// If the [key] doesn't exist, return an empty set (never return `null`).
  ISet<V> get(K key) => _mapOfSets[key] ?? ISet.empty<V>();

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IMapOfSets && runtimeType == other.runtimeType && _mapOfSets == other._mapOfSets;

  @override
  int get hashCode => _mapOfSets.hashCode;
}
