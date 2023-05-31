// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import 'imap.dart';

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
  IMap<K, V>? _iMap;
  Map<K, V>? _map;

  ModifiableMapFromIMap(IMap<K, V>? imap)
      : _iMap = imap,
        _map = imap == null ? {} : null;

  /// Associates the [key] with the given [value].
  ///
  /// If the key was already in the map, its associated value is changed.
  /// Otherwise the key/value pair is added to the map.
  @override
  void operator []=(K key, V value) {
    _switchToMutableMapIfNecessary();
    _map![key] = value;
  }

  void _switchToMutableMapIfNecessary() {
    if (_map == null) {
      _map = _iMap!.unlock;
      _iMap = null;
    }
  }

  /// The value for the given [key], or `null` if [key] is not in the map.
  ///
  /// Some maps allow `null` as a value.
  /// For those maps, a lookup using this operator cannot distinguish between a
  /// key not being in the map, and the key being there with a `null` value.
  /// Methods like [containsKey] or [putIfAbsent] can be used if the distinction
  /// is important.
  @override
  V? operator [](Object? key) => _iMap != null ? _iMap![key as K] : _map![key as K];

  /// Removes all entries from the map.
  ///
  /// After this, the map is empty.
  @override
  void clear() {
    _iMap = IMapImpl.empty<K, V>(_iMap?.config);
    _map = null;
  }

  /// Removes [key] and its associated value, if present, from the map.
  ///
  /// Returns the value associated with `key` before it was removed.
  /// Returns `null` if `key` was not in the map.
  ///
  /// Note that some maps allow `null` as a value,
  /// so a returned `null` value doesn't always mean that the key was absent.
  @override
  V? remove(Object? key) {
    _switchToMutableMapIfNecessary();
    return _mapRemove(key);
  }

  V? _mapRemove(Object? key) {
    if (_map!.containsKey(key)) {
      final V? value = _map![key as K];
      _map!.remove(key);
      return value;
    } else {
      return null;
    }
  }

  @override
  Iterable<K> get keys => _iMap?.keys ?? _map!.keys;

  IMap<K, V> get lock => _iMap ?? _map!.lock;
}
