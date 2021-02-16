import "dart:math";
import "list_map.dart";

class ListMapView<K, V> implements ListMap<K, V> {
  final Map<K, V> _map;

  ListMapView(this._map) : assert(_map != null);

  @override
  V operator [](Object key) => _map[key];

  @override
  void operator []=(K key, V value) {
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
  bool containsKey(covariant K key) => _map.containsKey(key);

  @override
  bool containsValue(covariant V value) => _map.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => _map.entries;

  @override
  MapEntry<K, V> entry(K key) => MapEntry(key, _map[key]);

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
  V remove(Object key) {
    throw UnsupportedError("Can't remove from a ListMap.");
  }

  @override
  void removeWhere(bool Function(K key, V value) predicate) {
    throw UnsupportedError("Can't removeWhere from a ListMap.");
  }

  @override
  V update(K key, Function(V value) update, {Function() ifAbsent}) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void updateAll(V Function(K key, V value) update) {
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
  void shuffle([Random random]) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void sort([int Function(K a, K b) compare]) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }
}
