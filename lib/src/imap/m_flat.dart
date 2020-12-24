import "dart:collection";
import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "imap.dart";

class MFlat<K, V> extends M<K, V> {
  //
  static M<K, V> empty<K, V>() => MFlat<K, V>.unsafe(<K, V>{});

  final Map<K, V> _map;

  MFlat(Map<K, V> _map)
      : assert(_map != null),
        _map = HashMap<K, V>.of(_map);

  MFlat.unsafe(this._map) : assert(_map != null);

  @override
  Iterable<MapEntry<K, V>> get entries =>
      _map.entries.map((entry) => MapEntry(entry.key, entry.value));

  @override
  Iterable<K> get keys => IList(_map.keys);

  @override
  Iterable<V> get values => IList(_map.values);

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  Map<RK, RV> cast<RK, RV>() => _map.cast<RK, RV>();

  @override
  bool any(bool Function(K, V) test) => _map.entries.any((entry) => test(entry.key, entry.value));

  @override
  bool contains(K key, V value) => (value != null) //
      ? (_map[key] == value)
      : (_map.containsKey(key) && (_map[key] == null));

  @override
  bool containsKey(K key) => _map.containsKey(key);

  @override
  bool containsValue(V value) => _map.containsValue(value);

  @override
  V operator [](K key) => _map[key];

  @override
  int get length => _map.length;

  /// Map equality but with an [Iterable] of [MapEntry].
  /// Like the other [Map] equalities, it doesn't  take order into consideration.
  bool deepMapEquals_toIterable(Iterable<MapEntry<K, V>> entries) {
    if (entries == null) return false;
    Map<K, V> map = Map<K, V>.fromEntries(entries);
    return const MapEquality().equals(_map, map);
  }

  bool deepMapEquals(MFlat<K, V> other) =>
      (other == null) ? false : const MapEquality().equals(_map, other._map);

  int deepMapHashcode() => const MapEquality().hash(_map);
}
