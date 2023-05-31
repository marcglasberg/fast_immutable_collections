// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "dart:collection";
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// A [ListMap] is a mutable, fixed-sized, and ordered map.
///
/// Compared to a [LinkedHashMap], a [ListMap] is also ordered and has a slightly worse
/// performance. But a [ListMap] takes less memory, and has some [List] methods like [sort] and
/// [shuffle]. Also, you can efficiently read its information by index, by using the [entryAt],
/// [keyAt] and [valueAt] methods.
///
/// The disadvantage, of course, is that [ListMap] has a fixed size,
/// while a [LinkedHashMap] does not.
///
class ListMap<K, V> implements Map<K, V> {
  Map<K, V> _map;
  List<K> _list;

  ListMap.empty()
      : _map = HashMap(),
        _list = List.empty(growable: false);

  /// Create a [ListMap] from the [map].
  ///
  /// If [sort] is true, it will sort with [compare], if provided,
  /// or with [compareObject] if not provided. If [sort] is false,
  /// [compare] will be ignored.
  ///
  ListMap.of(
    Map<K, V> map, {
    bool sort = false,
    int Function(K a, K b)? compare,
  })  : assert(compare == null || sort == true),
        _map = HashMap.from(map),
        _list = List.of(map.keys, growable: false) {
    if (sort) _list.sort(compare ?? compareObject);
  }

  ListMap._(this._map, this._list) : assert(_map.length == _list.length);

  /// Creates a [ListMap] from [entries].
  /// If [entries] contains the same keys multiple times, the last occurrence
  /// overwrites the previous value.
  ///
  /// If [sort] is true, the entries will be sorted with [compare],
  /// if provided, or with [compareObject] if not provided. If [sort]
  /// is false, [compare] will be ignored.
  ///
  factory ListMap.fromEntries(
    Iterable<MapEntry<K, V>> entries, {
    bool sort = false,
    int Function(K a, K b)? compare,
  }) {
    assert(compare == null || sort == true);

    Map<K, V> map;
    List<K> list;

    // Sorted:
    if (sort) {
      map = HashMap<K, V>();
      for (final MapEntry<K, V> entry in entries) {
        map[entry.key] = entry.value;
      }
      list = map.entries.map((entry) => entry.key).toList(growable: false);
      list.sort(compare ?? compareObject);
    }
    // Insertion order:
    else {
      // First create a map in insertion order, removing duplicate keys.
      map = LinkedHashMap<K, V>.fromEntries(entries);

      // Then create the list in the insertion order.
      list = map.entries.map((entry) => entry.key).toList(growable: false);

      // Remove the linked-list from the map (by using a HashMap).
      map = HashMap.of(map);
    }

    return ListMap._(map, list);
  }

  /// Creates a [ListMap] from the provided [keys] and [values].
  /// If a key is repeated, the last occurrence overwrites the previous value.
  ///
  /// If [sort] is `true`, it will be sorted with [compare], if provided,
  /// or with [compareObject] if not provided. If [sort] is `false`,
  /// [compare] will be ignored.
  ///
  /// The iterables [keys] and [values] must have the same number of items,
  /// otherwise it throws a [StateError].
  ///
  factory ListMap.fromIterables(
    Iterable<K> keys,
    Iterable<V> values, {
    bool sort = false,
    int Function(K a, K b)? compare,
  }) {
    final Iterable<MapEntry<K, V>> combined =
        combineIterables(keys, values, (K key, V value) => MapEntry(key, value));

    return ListMap.fromEntries(combined, sort: sort, compare: compare);
  }

  /// Creates a [ListMap] backed by the provided map. No defensive copy will be
  /// made, so you have to make sure that the original map won't change after
  /// the [ListMap] is created, since this will render the [ListMap] in an
  /// invalid state.
  ///
  /// If [sort] is true, it will be sorted with [compare], if provided,
  /// or with [compareObject] if not provided. If [sort] is false,
  /// [compare] will be ignored.
  ///
  /// Note: The original map won't be sorted or modified in any way by simply
  /// calling this constructor, even if [sort] is true.
  ///
  ListMap.unsafe(
    this._map, {
    bool sort = false,
    int Function(K a, K b)? compare,
  })  : assert(compare == null || sort == true),
        _list = List.of(_map.keys, growable: false) {
    if (sort) _list.sort(compare ?? compareObject);
  }

  /// Creates a [ListMap] backed by the provided [map] and [list]. No defensive
  /// copies will be made, so you have to make sure that:
  ///
  /// 1) The number of entries of the [map] and [list] won't change after
  /// the [ListMap] is created.
  ///
  /// 2) The [map] and [list] won't change after the [ListMap] is created.
  ///
  /// 3) The [list] items are the [map] keys (but the order of the map items is
  /// irrelevant).
  ///
  ListMap.unsafeFrom({
    required Map<K, V> map,
    required List<K> list,
  })  : _map = map,
        _list = list {
    if (map.length != list.length)
      throw AssertionError('Map has ${map.length} but list has ${list.length} items.');
  }

  /// The value for the given [key], or `null` if [key] is not in the map.
  ///
  /// Some maps allow `null` as a value.
  /// For those maps, a lookup using this operator cannot distinguish between a
  /// key not being in the map, and the key being there with a `null` value.
  /// Methods like [containsKey] or [putIfAbsent] can be used if the distinction
  /// is important.
  @override
  V? operator [](covariant K key) => _map[key];

  /// The value for the given [key], or `null` if [key] is not in the map.
  ///
  /// Some maps allow `null` as a value.
  /// For those maps, a lookup using this operator cannot distinguish between a
  /// key not being in the map, and the key being there with a `null` value.
  /// Methods like [containsKey] or [putIfAbsent] can be used if the distinction
  /// is important.
  ///
  /// See also: [getOrThrow] to throw an error when the value doesn't exist.
  ///
  V? get(covariant K key) => _map[key];

  /// Returns the value if it exists, otherwise throws a `StateError`.
  ///
  /// See also: [get] to return `null` when the value doesn't exist.
  ///
  V getOrThrow(K key) {
    if (containsKey(key)) {
      return (_map[key] as V);
    } else
      throw StateError("Key does not exist: '$key'");
  }

  /// Replaces the [value] of a [key] that already exists in the map.
  /// However, if the key is not already present, this will throw an error.
  @override
  void operator []=(K key, V value) {
    if (containsKey(key)) {
      _map[key] = value;
    } else
      throw UnsupportedError("Can't add a new key to the map.");
  }

  @override
  void addAll(Map<K, V> other) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    // TODO: Implement
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  @override
  ListMap<RK, RV> cast<RK, RV>() => ListMap<RK, RV>._(_map.cast<RK, RV>(), _list.cast<RK>());

  // TODO: Implement
  @override
  void clear() => throw UnsupportedError("Can't clear a ListMap.");

  @override
  bool containsKey(Object? key) => _map.containsKey(key);

  @override
  bool containsValue(Object? value) => _map.containsValue(value);

  @override
  void forEach(void Function(K key, V value) f) => _list.forEach((key) => f(key, _map[key] as V));

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterable<K> get keys => UnmodifiableListView(_list);

  @override
  Iterable<V> get values => _list.map((key) => _map[key] as V);

  /// Return the key/value entry for the given [key], or throws if [key] is not in the map.
  MapEntry<K, V> entry(K key) => _map.containsKey(key) //
      ? MapEntry(key, _map[key] as V)
      : throw StateError("Key not found.");

  /// Return the key/value entry for the given [key], or `null` if [key] is not in the map.
  MapEntry<K, V>? entryOrNull(K key) => _map.containsKey(key) //
      ? MapEntry(key, _map[key] as V)
      : null;

  /// Return the key/value entry for the given [key].
  /// If the [key] is not in the map, return `MapEntry(key, null)`.
  MapEntry<K, V?> entryOrNullValue(K key) => MapEntry(key, _map[key]);

  @override
  Iterable<MapEntry<K, V>> get entries => _list.map((key) => entry(key));

  @override
  int get length => _list.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) f) => _map.map(f);

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
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

  // TODO: Implement
  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  // TODO: Implement
  @override
  void updateAll(V Function(K key, V value) update) {
    throw UnsupportedError("This is not yet supported, but will be in the future.");
  }

  /// Shuffles the keys of this map randomly.
  void shuffle([Random? random]) {
    _list.shuffle(random);
  }

  /// Sorts the keys of this map.
  void sort([int Function(K a, K b)? compare]) {
    _list.sort(compare);
  }

  /// Returns the [index]th entry.
  /// The [index] must be non-negative and less than [length].
  /// Index zero represents the first entry.
  ///
  MapEntry<K, V> entryAt(int index) {
    final K key = _list[index];
    return MapEntry<K, V>(key, _map[key] as V);
  }

  /// Returns the [index]th key.
  /// The [index] must be non-negative and less than [length].
  /// Index zero represents the first key.
  ///
  K keyAt(int index) => _list[index];

  /// The first index of [key] in this list.
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `o` is encountered so that `o == element`,
  /// the index of `o` is returned.
  ///
  /// Returns -1 if the [key] is not found.
  ///
  int indexOfKey(K key, [int start = 0]) => _list.indexOf(key, start);

  /// Returns the [index]th value.
  /// The [index] must be non-negative and less than [length].
  /// Index zero represents the first value.
  ///
  V valueAt(int index) {
    final K key = _list[index];
    return _map[key] as V;
  }

  /// Creates a [ListMap] form the given [map].
  /// If the [map] is already of type [ListMap], return the same instance.
  /// This is unsafe because a [ListMapView] is fixed size, but the given [map] may not.
  static ListMap<K, V> unsafeView<K, V>(Map<K, V> map) =>
      (map is ListMap<K, V>) ? map : ListMapView<K, V>(map);
}
