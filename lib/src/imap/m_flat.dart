import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'imap.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class MFlat<K, V> extends M<K, V> {
  //
  static M<K, V> empty<K, V>() => MFlat.unsafe(const {});

  final Map<K, V> _map;

  MFlat.unsafe(this._map) : assert(_map != null);

  @override
  Iterable<MapEntry<K, V>> get iterable => _map.entries;

  @override
  IList<MapEntry<K, V>> get entries => IList(_map.entries);

  @override
  IList<K> get keys => IList(_map.keys);

  @override
  IList<V> get values => IList(_map.values);

  @override
  Iterator<MapEntry<K, V>> get iterator => _map.entries.iterator;

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
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
