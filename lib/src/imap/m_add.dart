import 'package:fast_immutable_collections/src/ilist/iterator_add.dart';

import "imap.dart";

class MAdd<K, V> extends M<K, V> {
  final M<K, V> _m;
  final K _key;
  final V _value;

  MAdd(this._m, this._key, this._value);

  @override
  bool get isEmpty => false;

  @override
  Iterable<MapEntry<K, V>> get entries => _m.entries.followedBy([MapEntry<K, V>(_key, _value)]);

  @override
  Iterable<K> get keys => _m.keys.followedBy(<K>[_key]);

  @override
  Iterable<V> get values => _m.values.followedBy(<V>[_value]);

  /// Implicitly uniting the maps.
  @override
  V? operator [](K key) => (key == _key) ? _value : _m[key];

  @override
  bool contains(K key, V value) => (key == _key && value == _value) || _m.contains(key, value);

  @override
  bool containsKey(K key) => (key == _key) || _m.containsKey(key);

  @override
  bool containsValue(V value) => (value == _value) || _m.containsValue(value);

  @override
  int get length => _m.length + 1;

  @override
  Iterator<MapEntry<K, V>> get iterator => IteratorAdd(_m.iterator, MapEntry(_key, _value));
}
