import "imap.dart";

class MAdd<K, V> extends M<K, V> {
  final M<K, V> _m;
  final K _key;
  final V _value;

  MAdd(this._m, this._key, this._value) : assert(_m != null);

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
  V operator [](K key) => (key == _key) ? _value : _m[key];

  @override
  bool contains(K key, V value) =>
      (key == _key && value == _value) ? true : _m.contains(key, value);

  @override
  bool containsKey(K key) => (key == _key) ? true : _m.containsKey(key);

  @override
  bool containsValue(V value) => (value == _value) ? true : _m.containsValue(value);

  @override
  int get length => _m.length + 1;

  @override
  Iterator<MapEntry<K, V>> get iterator => IteratorMAdd(_m.iterator, MapEntry(_key, _value));
}

// /////////////////////////////////////////////////////////////////////////////

class IteratorMAdd<K, V> implements Iterator<MapEntry<K, V>> {
  Iterator<MapEntry<K, V>> iterator;
  MapEntry<K, V> item, _current;
  int extraMove;

  IteratorMAdd(this.iterator, this.item)
      : _current = iterator.current,
        extraMove = 0;

  @override
  MapEntry<K, V> get current => _current;

  @override
  bool moveNext() {
    final bool isMoving = iterator.moveNext();
    if (isMoving) {
      _current = iterator.current;
    } else {
      extraMove++;
      _current = extraMove == 1 ? item : null;
    }
    return extraMove <= 1;
  }
}

// /////////////////////////////////////////////////////////////////////////////
