// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/imap/imap.dart';
import 'package:meta/meta.dart';

class MFlat<K, V> extends M<K, V> {
  //
  static M<K, V> empty<K, V>() => MFlat<K, V>.unsafe(<K, V>{});

  final Map<K, V> _map;

  /// **Safe**. Note: This will sort according to the configuration.
  MFlat(Map<K, V> _map, {ConfigMap? config})
      : _map = ListMap.of(_map, sort: (config ?? IMap.defaultConfig).sort);

  MFlat.fromEntries(Iterable<MapEntry<K, V>> entries, {ConfigMap? config})
      : _map = ListMap<K, V>.fromEntries(entries, sort: (config ?? IMap.defaultConfig).sort);

  MFlat.from(M<K, V> _m, {ConfigMap? config})
      : _map = ListMap<K, V>.fromEntries(_m.entries, sort: (config ?? IMap.defaultConfig).sort);

  /// **Unsafe**. Note: Does not sort.
  MFlat.unsafe(Map<K, V> map) : _map = ListMap.unsafeView(map);

  @override
  Iterable<MapEntry<K, V>> get entries => _map.entries;

  @override
  Iterable<K> get keys => _map.keys;

  @override
  Iterable<V> get values => _map.values;

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  Map<RK, RV> cast<RK, RV>(ConfigMap config) => _map.cast<RK, RV>();

  @override
  bool any(bool Function(K, V) test) => _map.entries.any((entry) => test(entry.key, entry.value));

  @override
  V? operator [](K key) => _map[key];

  @override
  bool contains(K key, V value) => (value != null) //
      ? (_map[key] == value)
      : (_map.containsKey(key) && (_map[key] == null));

  @override
  bool containsKey(K? key) => _map.containsKey(key);

  @override
  bool containsValue(V? value) => _map.containsValue(value);

  /// This may be used to help avoid stack-overflow.
  @protected
  @override
  dynamic getVOrM(K key) => _map[key];

  /// Used by tail-call-optimisation.
  /// Returns type [bool] or [M].
  @protected
  @override
  dynamic containsKeyOrM(K? key) => _map.containsKey(key);

  @override
  int get length => _map.length;

  @override
  Iterator<MapEntry<K, V>> get iterator => entries.iterator;

  /// Map equality but with an [Iterable] of [MapEntry].
  /// Like the other [Map] equalities, it doesn't  take order into consideration.
  bool deepMapEqualsToIterable(Iterable<MapEntry>? entries) {
    if (entries == null) return false;
    final Map map = Map<dynamic, dynamic>.fromEntries(entries);
    return const MapEquality<dynamic, dynamic>().equals(_map, map);
  }

  bool deepMapEquals(MFlat? other) =>
      (other != null) && const MapEquality<dynamic, dynamic>().equals(_map, other._map);

  int deepMapHashcode() => const MapEquality<dynamic, dynamic>().hash(_map);
}
