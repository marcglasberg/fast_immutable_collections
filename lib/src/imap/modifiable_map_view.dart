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
  void operator []=(K key, V value) => throw UnimplementedError('Not implemented yet.');

  @override
  V operator [](Object key) => _iMap != null ? _iMap[key as K] : _map[key];

  @override
  void clear() => throw UnimplementedError('Not implemented yet.');

  @override
  V remove(Object key) => throw UnimplementedError('Not implemented yet.');

  @override
  Iterable<K> get keys => throw UnimplementedError('Not implemented yet.');

  IMap<K, V> get lock => throw UnimplementedError('Not implemented yet.');
}
