import "imap.dart";

/// The [_m] already contains the [_key]. But the [_value] should be the new one.
class MReplace<K, V> extends M<K, V> {
  final M<K, V> _m;
  final K _key;
  final V _value;

  MReplace(this._m, this._key, this._value) : assert(_m != null);

  @override
  bool get isEmpty => false;

  @override
  Iterable<MapEntry<K, V>> get entries =>
      _m.entries.map((entry) => (entry.key == _key) ? MapEntry(_key, _value) : entry);

  @override
  Iterable<K> get keys => _m.keys;

  @override
  Iterable<V> get values => entries.map((entry) => entry.value);

  /// Implicitly uniting the maps.
  @override
  V operator [](K key) => (key == _key) ? _value : _m[key];

  @override
  bool contains(K key, V value) => (key == _key) //
      ? value == _value
      : _m.contains(key, value);

  @override
  bool containsKey(K key) => (key == _key) ? true : _m.containsKey(key);

  @override
  bool containsValue(V value) => entries.any((entry) => entry.value == value);

  @override
  int get length => _m.length;

  @override
  Iterator<MapEntry<K, V>> get iterator => entries.iterator;
}
