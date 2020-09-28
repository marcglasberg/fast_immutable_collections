import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'imap.dart';
import 'package:collection/collection.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class MFlat<K, V> extends M<K, V> {
  //
  static M<K, V> empty<K, V>() => MFlat<K, V>.unsafe(<K, V>{});

  final Map<K, V> _map;

  MFlat(Map<K, V> _map)
      : assert(_map != null),
        _map = Map<K, V>.of(_map);

  MFlat.unsafe(this._map) : assert(_map != null);

  @override
  Iterable<MapEntry<K, V>> get entries => _map.entries;

  @override
  Iterable<K> get keys => IList(_map.keys);

  @override
  Iterable<V> get values => IList(_map.values);

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool any(bool Function(K, V) test) => _map.entries.any((entry) => test(entry.key, entry.value));

  @override
  bool contains(K key, V value) {
    var _value = _map[key];
    return (_value == null) ? false : (_value == _value);
  }

  @override
  bool containsKey(K key) => _map.containsKey(key);

  @override
  bool containsValue(V value) => _map.containsValue(value);

  @override
  V operator [](K key) => _map[key];

  @override
  int get length => _map.length;

  bool mapEquals(MFlat<K, V> other) =>
      (other == null) ? false : const MapEquality().equals(_map, other._map);

  int mapHashcode() => const MapEquality().hash(_map);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
