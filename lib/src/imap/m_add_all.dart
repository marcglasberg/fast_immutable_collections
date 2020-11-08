import "imap.dart";

// /////////////////////////////////////////////////////////////////////////////////////////////////

class MAddAll<K, V> extends M<K, V> {
  final M<K, V> _m, _items;

  MAddAll.unsafe(this._m, this._items)
      : assert(_m != null),
        assert(_items != null);

  @override
  bool get isEmpty => _m.isEmpty && _items.isEmpty;

  @override
  Iterable<MapEntry<K, V>> get entries => _m.entries.followedBy(_items.entries);

  @override
  Iterable<K> get keys => _m.keys.followedBy(_items.keys);

  @override
  Iterable<V> get values => _m.values.followedBy(_items.values);

  @override
  // Check the real map first (It's faster).
  V operator [](K key) => _items[key] ?? _m[key];

  @override
  bool contains(K key, V value) {
    final V _value = _items[key] ?? _m[key];
    return value == _value;
  }

  @override
  bool containsKey(K key) {
    // Check the real map first (It's faster).
    if (_items.containsKey(key)) return true;
    return _m.containsKey(key);
  }

  @override
  bool containsValue(V value) {
    // Check the real map first (It's faster).
    if (_items.containsValue(value)) return true;
    return _m.containsValue(value);
  }

  @override
  int get length => _m.length + _items.length;

  @override
  Iterator<MapEntry<K, V>> get iterator => IteratorMAddAll(_m.iterator, _items.iterator);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class IteratorMAddAll<K, V> implements Iterator<MapEntry<K, V>> {
  Iterator<MapEntry<K, V>> iterator1, iterator2;
  MapEntry<K, V> _current;

  IteratorMAddAll(this.iterator1, this.iterator2) : _current = iterator1.current;

  @override
  MapEntry<K, V> get current => _current;

  @override
  bool moveNext() {
    bool isMoving = iterator1.moveNext();
    if (isMoving) {
      _current = iterator1.current;
    } else {
      isMoving = iterator2.moveNext();
      if (isMoving) {
        _current = iterator2.current;
      } else {
        _current = null;
      }
    }
    return isMoving;
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
