import 'dart:collection';

import '../imap/imap.dart';
import '../immutable_collection.dart';

class ModifiableMapView<K, V> with MapMixin<K, V> implements Map<K, V>, CanBeEmpty {
  IMap<K, V> _iMap;
  Map<K, V> _map;

  ModifiableMapView(IMap<K, V> iMap)
      : _iMap = iMap,
        _map = iMap == null ? {} : null;

  @override
  void operator []=(K key, V value) {
    _switchToMutableMapIfNecessary();
    _map[key] = value;
  }

  void _switchToMutableMapIfNecessary() {
    if (_map == null) {
      _map = _iMap.unlock;
      _iMap = null;
    }
  }

  @override
  V operator [](Object key) => _iMap != null ? _iMap[key as K] : _map[key];

  @override
  void clear() {
    _iMap = IMap.empty<K, V>();
    _map = null;
  }

  @override
  V remove(Object key) {
    _switchToMutableMapIfNecessary();
    return _mapRemove(key);
  }

  V _mapRemove(Object key) {
    if (_map.containsKey(key)) {
      final V value = _map[key];
      _map.remove(key);
      return value;
    } else {
      return null;
    }
  }

  @override
  Iterable<K> get keys => _iMap?.keys ?? _map.keys;

  IMap<K, V> get lock => _iMap ?? _map.lock;
}
