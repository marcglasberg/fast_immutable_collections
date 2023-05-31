// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:math";

import "list_map.dart";

/// A [ListMapView] lets you view a regular map as if it was a [ListMap].
/// At the moment this class is for FIC's internal use only, since a lot of
/// its methods will throw [UnsupportedError].
///
class ListMapView<K, V> implements ListMap<K, V> {
  final Map<K, V> _map;

  ListMapView(this._map);

  @override
  V? operator [](covariant K key) => _map[key];

  @override
  V? get(covariant K key) => _map[key];

  @override
  V getOrThrow(K key) {
    if (containsKey(key)) {
      return (_map[key] as V);
    } else
      throw StateError("Key does not exist: '$key'");
  }

  @override
  void operator []=(K key, V? value) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void addAll(Map other) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void addEntries(Iterable<MapEntry> newEntries) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  ListMap<RK, RV> cast<RK, RV>() => ListMap.unsafe(_map.cast<RK, RV>());

  @override
  void clear() {
    throw UnsupportedError("Can't clear a ListMap.");
  }

  @override
  bool containsKey(covariant K? key) => _map.containsKey(key);

  @override
  bool containsValue(covariant V? value) => _map.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => _map.entries;

  /// Return the key/value entry for the given [key], or throws if [key] is not in the map.
  @override
  MapEntry<K, V> entry(K key) => _map.containsKey(key) //
      ? MapEntry(key, _map[key] as V)
      : throw StateError("Key not found.");

  /// Return the key/value entry for the given [key], or `null` if [key] is not in the map.
  @override
  MapEntry<K, V>? entryOrNull(K key) => _map.containsKey(key) //
      ? MapEntry(key, _map[key] as V)
      : null;

  /// Return the key/value entry for the given [key].
  /// If the [key] is not in the map, return `MapEntry(key, null)`.
  @override
  MapEntry<K, V?> entryOrNullValue(K key) => MapEntry(key, _map[key]);

  @override
  void forEach(void Function(K key, V value) f) => _map.forEach(f);

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  Iterable<K> get keys => _map.keys;

  @override
  int get length => _map.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) f) => _map.map(f);

  @override
  V putIfAbsent(K key, Function() ifAbsent) {
    throw UnsupportedError("Can't putIfAbsent into a ListMap.");
  }

  @override
  V remove(Object? key) {
    throw UnsupportedError("Can't remove from a ListMap.");
  }

  @override
  void removeWhere(bool Function(K key, V value) predicate) {
    throw UnsupportedError("Can't removeWhere from a ListMap.");
  }

  @override
  V update(K key, Function(V value) update, {Function()? ifAbsent}) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void updateAll(V? Function(K key, V value) update) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  Iterable<V> get values => _map.values;

  @override
  MapEntry<K, V> entryAt(int index) => _map.entries.elementAt(index);

  @override
  K keyAt(int index) => _map.keys.elementAt(index);

  @override
  V valueAt(int index) => _map.values.elementAt(index);

  @override
  int indexOfKey(K key, [int start = 0]) {
    final Map<K, V> map = _map;

    if (map is ListMap<K, V>)
      return map.indexOfKey(key, start);
    else {
      int count = 0;
      for (final K _key in _map.keys) {
        if (count >= start && key == _key) return count;
        count++;
      }
      return -1;
    }
  }

  @override
  void shuffle([Random? random]) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void sort([int Function(K a, K b)? compare]) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }
}
