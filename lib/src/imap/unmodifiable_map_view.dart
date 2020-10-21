import 'dart:collection';

import 'package:meta/meta.dart';

import '../imap/imap.dart';
import '../utils/immutable_collection.dart';

@immutable
class UnmodifiableMapView<K, V> with MapMixin<K, V> implements Map<K, V>, CanBeEmpty {
  final IMap<K, V> _iMap;
  final Map<K, V> _map;

  UnmodifiableMapView(IMap<K, V> iMap)
      : _iMap = iMap ?? IMap.empty<K, V>(),
        _map = null;

  UnmodifiableMapView.fromMap(Map<K, V> map)
      : _iMap = null,
        _map = map;

  @override
  void operator []=(K key, V value) => UnsupportedError("Map is unmodifiable.");

  @override
  V operator [](Object key) => _iMap != null ? _iMap[key as K] : _map[key];

  @override
  void clear() => throw UnsupportedError("Map is unmodifiable.");

  @override
  V remove(Object key) => throw UnsupportedError("Map is unmodifiable.");

  @override
  Iterable<K> get keys => _iMap?.keys ?? _map.keys;

  IMap<K, V> get lock => _iMap ?? _map.lock;
}
