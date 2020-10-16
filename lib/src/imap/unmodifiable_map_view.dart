import 'dart:collection';

import 'package:meta/meta.dart';

import '../immutable_collection.dart';
import '../imap/imap.dart';

@immutable
class UnmodifiableMapView<K, V> with MapMixin<K, V> implements Map<K, V>, CanBeEmpty {
  final IMap<K, V> _iMap;
  final Map<K, V> _map;

  UnmodifiableMapView(IMap<K, V> iMap)
      : _iMap = iMap ?? IMap.empty<K, V>(),
        _map = null;

  UnmodifiableMapView.from(Map<K, V> map)
      : _iMap = null,
        _map = map;

  @override
  void operator []=(K key, V value) => throw UnimplementedError('Not implemented yet.');

  @override
  V operator [](Object key) => throw UnimplementedError('Not implemented yet.');

  @override
  void clear() => throw UnimplementedError('Not implemented yet.');

  @override
  V remove(Object key) => throw UnimplementedError('Not implemented yet.');

  @override
  Iterable<K> get keys => throw UnimplementedError('Not implemented yet.');
}
