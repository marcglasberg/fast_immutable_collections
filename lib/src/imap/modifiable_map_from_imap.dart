import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "dart:collection";

/// The [ModifiableMapFromIMap] is a safe, modifiable [Map] that is built from an [IMap].
/// The construction of the map is fast at first, since it makes no copies of the
/// [IMap] items, but just uses it directly.
///
/// If and only if you use a method that mutates the map, like [add],
/// it will unlock internally (make a copy of all [IMap] items).
/// This is transparent to you, and will happen at most only once.
/// In other words, it will unlock the [IMap], lazily, only if necessary.
///
/// If you never mutate the map, it will be very fast to lock this map
/// back into an [IMap].
///
/// See also: [UnmodifiableMapFromIMap]
///
class ModifiableMapFromIMap<K, V> with MapMixin<K, V> implements Map<K, V>, CanBeEmpty {
  IMap<K, V> _iMap;
  Map<K, V> _map;

  ModifiableMapFromIMap(IMap<K, V> imap)
      : _iMap = imap,
        _map = imap == null ? {} : null;

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
