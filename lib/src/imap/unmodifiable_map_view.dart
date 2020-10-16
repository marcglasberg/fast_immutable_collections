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

  UnmodifiableMapView.fromMap(Map<K, V> map)
      : _iMap = null,
        _map = map;

  @override
  void operator []=(K key, V value) => throw UnimplementedError('Not implemented yet.');

  // TODO: Marcelo, talvez seja melhor mudar o tipo da chave dentro do `IMap` para `Object`?
  // Assim ficaria igual ao `Map`...
  @override
  V operator [](Object key) => _iMap != null ? _iMap[key as K] : _map[key];

  @override
  void clear() => throw UnimplementedError('Not implemented yet.');

  @override
  V remove(Object key) => throw UnimplementedError('Not implemented yet.');

  @override
  Iterable<K> get keys => _iMap?.keys ?? _map.keys;

  IMap<K, V> get lock => _iMap ?? _map.lock;
}
