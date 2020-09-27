import 'dart:collection';
import 'package:meta/meta.dart';
import '../../fast_immutable_collections.dart';
import 'm_add.dart';
import 'm_add_all.dart';
import 'm_flat.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension IMapExtension<K, V> on Map<K, V> {
  IMap<K, V> get lock => IMap<K, V>(this);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// Doesn't maintain original insertion order when iterating.
class IMap<K, V> {
  M<K, V> _m;

  static IMap<K, V> empty<K, V>() => IMap.__(MFlat.empty<K, V>());

  static Map Function() unlockBuilder = unlockBuilder_HashMap;

  static Map<K, V> unlockBuilder_LinkedHashMap<K, V>() => LinkedHashMap<K, V>();

  static Map<K, V> unlockBuilder_HashMap<K, V>() => HashMap<K, V>();

  factory IMap([Map<K, V> map]) =>
      IMap._(MFlat.unsafe(map == null || map.isEmpty ? const {} : Map.of(map)));

  factory IMap.fromEntries(Iterable<MapEntry<K, V>> entries) {
    if (entries is IMap)
      return IMap.__((entries as IMap)._m);
    else {
      var map = HashMap<K, V>();
      map.addEntries(entries);
      return IMap._(MFlat.unsafe(map));
    }
  }

  factory IMap.fromKeys({
    @required Iterable<K> keys,
    @required V Function(K) valueMapper,
  }) {
    assert(keys != null);
    assert(valueMapper != null);

    var map = HashMap<K, V>();

    for (K key in keys) {
      map[key] = valueMapper(key);
    }

    return IMap._map(map);
  }

  factory IMap.fromValues({
    @required K Function(V) keyMapper,
    @required Iterable<V> values,
  }) {
    assert(keyMapper != null);
    assert(values != null);

    var map = HashMap<K, V>();

    for (V value in values) {
      map[keyMapper(value)] = value;
    }

    return IMap._map(map);
  }

  factory IMap.fromIterable(
    Iterable iterable, {
    K Function(dynamic) keyMapper,
    V Function(dynamic) valueMapper,
  }) {
    Map<K, V> map = Map.fromIterable(iterable, key: keyMapper, value: valueMapper);
    return IMap._map(map);
  }

  factory IMap.fromIterables(Iterable<K> keys, Iterable<V> values) {
    Map<K, V> map = Map.fromIterables(keys, values);
    return IMap._map(map);
  }

  /// Unsafe.
  IMap._map(Map<K, V> map) : _m = MFlat.unsafe(map);

  IMap._([M<K, V> m]) : _m = m is IMap ? (m as IMap)._m : (m ?? MFlat.unsafe(HashMap.of(const {})));

  /// Unsafe.
  IMap.__(this._m);

  IList<MapEntry<K, V>> get entries => IList(_m.entries);

  IList<K> get keys => IList(_m.keys);

  IList<V> get values => IList(_m.values);

  /// Returns a regular Dart (mutable) Map.
  Map<K, V> get unlock => _m.unlock;

  Iterator<MapEntry<K, V>> get iterator => _m.iterator;

  bool get isEmpty => _m.isEmpty;

  bool get isNotEmpty => !isEmpty;

  // --- IMap methods: ---------------

  /// Compacts the list.
  IMap<K, V> get flush {
    if (!isFlushed) _m = MFlat.unsafe(unlock);
    return this;
  }

  bool get isFlushed => _m is MFlat;

  /// Returns a new map containing the current map plus the given key:value.
  /// (if necessary, the given will override the current).
  IMap<K, V> add({@required K key, @required V value}) =>
      IMap<K, V>.__(_m.add(key: key, value: value));

  /// Returns a new map containing the current map plus the given key:value.
  /// (if necessary, the given will override the current).
  IMap<K, V> addEntry(MapEntry<K, V> entry) =>
      IMap<K, V>.__(_m.add(key: entry.key, value: entry.value));

  /// Returns a new map containing the current map plus the given map.
  /// (if necessary, the given will override the current).
  IMap<K, V> addAll(IMap<K, V> iMap) => IMap<K, V>.__(_m.addAll(iMap));

  /// Returns a new map containing the current map plus the given map.
  /// (if necessary, the given will override the current).
  IMap<K, V> addMap(Map<K, V> map) => IMap<K, V>.__(_m.addMap(map));

  /// Returns a new map containing the current map plus the given map entries.
  /// (if necessary, the given will override the current).
  IMap<K, V> addEntries(Iterable<MapEntry<K, V>> entries) => IMap<K, V>.__(_m.addEntries(entries));

  /// Returns a new map containing the current map minus the given key and its value.
  /// However, if the current map doesn't contain the key,
  /// it will return the current map (same instance).
  IMap<K, V> remove(K key) => IMap<K, V>.__(_m.remove(key));

  V operator [](K k) => _m[k];

  V get(K k) => _m[k];

  bool any(bool Function(K key, V value) test) => _m.any(test);

  bool anyEntry(bool Function(MapEntry<K, V>) test) => _m.anyEntry(test);

  bool contains(K key, V value) => _m.contains(key, value);

  bool containsKey(K key) => _m.containsKey(key);

  bool containsValue(V value) => _m.containsValue(value);

  bool containsEntry(MapEntry<K, V> entry) => _m.contains(entry.key, entry.value);

  List<MapEntry<K, V>> toList() => List.of(entries);

  IList<MapEntry<K, V>> toIList() => entries;

  Set<MapEntry<K, V>> toSet() => entries.toSet();

  Set<K> toKeySet() => keys.toSet();

  Set<V> toValueSet() => values.toSet();

  ISet<MapEntry<K, V>> toISet() => ISet(entries);

  ISet<K> toKeyISet() => ISet(keys);

  ISet<V> toValueISet() => ISet(values);

  int get length => _m.length;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

// abstract class M<K, V> implements IterableM<K, V> {
abstract class M<K, V> {
  //
  Iterable<MapEntry<K, V>> get iterable => _getFlushed.entries;

  IList<MapEntry<K, V>> get entries => IList(_getFlushed.entries);

  IList<K> get keys => IList(_getFlushed.keys);

  IList<V> get values => IList(_getFlushed.values);

  /// The [M] class provides the default fallback methods of Iterable, but
  /// ideally all of its methods are implemented in all of its subclasses.
  /// Note these fallback methods need to calculate the flushed list, but
  /// because that's immutable, we cache it.
  Map<K, V> _flushed;

  Map<K, V> get _getFlushed {
    _flushed ??= unlock;
    return _flushed;
  }

  /// Returns a regular Dart (mutable) Map.
  Map<K, V> get unlock {
    Map<K, V> map = IMap.unlockBuilder();
    map.addEntries(iterable);
    return map;
  }

  int get length => _getFlushed.length;

  Iterator<MapEntry<K, V>> get iterator;

  M<K, V> add({@required K key, @required V value}) => MAdd<K, V>(this, key, value);

  M<K, V> addAll(IMap<K, V> imap) => MAddAll<K, V>.unsafe(this, imap._m);

  M<K, V> addMap(Map<K, V> map) => MAddAll<K, V>.unsafe(this, MFlat.unsafe(Map.of(map)));

  M<K, V> addEntries(Iterable<MapEntry<K, V>> items) =>
      MAddAll<K, V>.unsafe(this, MFlat.unsafe(Map.fromEntries(items)));

  /// TODO: FALTA FAZER!!!
  M<K, V> remove(K key) {
    return !containsKey(key) ? this : MFlat<K, V>.unsafe(Map.of(_getFlushed)..remove(key));
  }

  bool get isEmpty => _getFlushed.isEmpty;

  bool get isNotEmpty => !isEmpty;

  V operator [](K key) => _getFlushed[key];

  bool contains(K key, V value) {
    var _value = _getFlushed[key];
    return (_value == null) ? false : (_value == _value);
  }

  bool containsKey(K key) => _getFlushed.containsKey(key);

  bool containsValue(V value) => _getFlushed.containsKey(value);

  bool containsEntry(MapEntry<K, V> entry) => contains(entry.key, entry.value);

  bool any(bool Function(K key, V value) test) =>
      _getFlushed.entries.any((entry) => test(entry.key, entry.value));

  bool anyEntry(bool Function(MapEntry<K, V>) test) => _getFlushed.entries.any(test);

// bool everyEntry(bool Function(MapEntry<K, V>) test) => _getFlushed.entries.every(test);
//
// bool every(bool Function(K key, V value) test) =>
//     _getFlushed.entries.every((entry) => test(entry.key, entry.value));
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
