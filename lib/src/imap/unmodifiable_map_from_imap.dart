// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";

/// The [UnmodifiableMapFromIMap] is a relatively safe, unmodifiable [Map] that is built from an
/// [IMap] or another [Map]. The construction of the [UnmodifiableMapFromIMap] is very fast,
/// since it makes no copies of the given map items, but just uses it directly.
///
/// If you try to use methods that modify the [UnmodifiableMapFromIMap], like [add],
/// it will throw an [UnsupportedError].
///
/// If you create it from an [IMap], it is also very fast to lock the [UnmodifiableMapFromIMap]
/// back into an [IMap].
///
/// <br>
///
/// ## How does it compare to Dart's native [Map.unmodifiable] and [UnmodifiableMapView]?
///
/// [Map.unmodifiable] is slow, but it's always safe, because *it is not a view*, and
/// actually creates a new map. On the other hand, [UnmodifiableMapFromIMap] and
/// [UnmodifiableMapView] are fast, but if you create them from a regular [Map] and then modify
/// that original [Map], you will also be modifying the views. Also note, if you create an
/// [UnmodifiableMapFromIMap] from an [IMap], then it's totally safe , then it's totally safe
/// because the original [IMap] can't be modified.
///
/// The only different between an [UnmodifiableMapFromIMap] and an [UnmodifiableMapView] is that
/// [UnmodifiableMapFromIMap] accepts both a [Map] and an [IMap].
///
/// See also: [ModifiableMapFromIMap]
///
@immutable
class UnmodifiableMapFromIMap<K, V> with MapMixin<K, V> implements Map<K, V>, CanBeEmpty {
  final IMap<K, V>? _iMap;
  final Map<K, V>? _map;

  /// Create an unmodifiable [Set] view of type [UnmodifiableSetView], from an [iset].
  UnmodifiableMapFromIMap(IMap<K, V> imap)
      : _iMap = imap,
        _map = null;

  /// Create an unmodifiable [Set] view of type [UnmodifiableSetView], from another [Set].
  UnmodifiableMapFromIMap.fromMap(Map<K, V> map)
      : _iMap = null,
        _map = map;

  @override
  void operator []=(K key, V value) => throw UnsupportedError("Map is unmodifiable.");

  @override
  V? operator [](covariant K key) => _iMap != null ? _iMap[key] : _map![key];

  @override
  void clear() => throw UnsupportedError("Map is unmodifiable.");

  @override
  V remove(covariant K key) => throw UnsupportedError("Map is unmodifiable.");

  @override
  Iterable<K> get keys => _iMap?.keys ?? _map!.keys;

  IMap<K, V> get lock => _iMap ?? _map!.lock;
}
