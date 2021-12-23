import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';

import 'm_add.dart';
import 'm_add_all.dart';
import 'm_flat.dart';
import 'm_replace.dart';

abstract class M<K, V> {
  //

  /// The [M] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  ///
  /// Note these fallback methods need to calculate the flushed map, but
  /// because that"s immutable, we cache it.
  Map<K, V>? _flushed;

  /// Returns the flushed map (flushes it only once).
  /// **It is an error to use the flushed map outside of the [M] class.**
  Map<K, V> getFlushed(ConfigMap? config) {
    _flushed ??= ListMap.fromEntries(entries, sort: (config ?? IMap.defaultConfig).sort);
    return _flushed!;
  }

  /// Returns a regular Dart (*mutable*) Map.
  Map<K, V> get unlock => <K, V>{}..addEntries(entries);

  Iterable<MapEntry<K, V>> get entries;

  Iterable<K> get keys;

  Iterable<V> get values;

  Iterator<MapEntry<K, V>> get iterator;

  int get length;

  /// Used by tail-call-optimisation.
  /// Returns type [V] or [M].
  @protected
  dynamic getVOrM(K key);

  /// Used by tail-call-optimisation.
  /// Returns type [bool] or [M].
  @protected
  dynamic containsKeyOrM(K? key);

  /// Returns a new map containing the current map plus the given key:value.
  /// However, if the given key already exists in the set,
  /// it will remove the old one and add the new one.
  M<K, V> add({required K key, required V value}) {
    bool contains = containsKey(key);
    if (!contains)
      return MAdd<K, V>(this, key, value);
    else {
      V? oldValue = this[key];
      return (oldValue == value) //
          ? this
          : MReplace<K, V>(this, key, value);
    }
  }

  /// The entries of the given [imap] will be added to the original map.
  /// Note: [imap] entries that already exist in the original map will overwrite
  /// those of the original map.
  ///
  /// If the current map is sorted, then if [keepOrder] is `false` (the default),
  /// those entries that already exist will go to the end of the new map. If
  /// [keepOrder] is `true`, those entries that already exist will be replaced in
  /// place.
  ///
  /// If the current map is NOT sorted, the [keepOrder] parameter is ignored.
  ///
  /// Note: This will NOT sort anything.
  ///
  @useCopy
  M<K, V> addAll(M<K, V> m, {bool keepOrder = false}) {
    if (keepOrder) {
      Map<K, V> map = Map.fromEntries(entries.followedBy(m.entries));
      return MFlat<K, V>.unsafe(map);
    }
    //
    else {
      // We want the entries being added to overwrite those of the original add.
      // So we have to remove the entries that are already present in the second map.
      Map<K, V> firstMap =
          ListMap.fromEntries(entries.where((entry) => !m.containsKey(entry.key)));

      M<K, V> firstM = MFlat<K, V>.unsafe(firstMap);

      return MAddAll<K, V>.unsafe(firstM, m);
    }
  }

  /// The [map] entries will be added to the original map.
  /// Note: [map] entries that already exist in the original map will overwrite
  /// those of the original map, in place (keeping order).
  ///
  /// Note: This will NOT sort anything.
  ///
  M<K, V> addMap(Map<K, V> map) {
    Map<K, V> newMap = Map.fromEntries(entries.followedBy(map.entries));
    return MFlat<K, V>.unsafe(newMap);
  }

  /// The [entries] will be added to the original map.
  /// Note: [entries] that already exist in the original map will overwrite
  /// those of the original map, in place (keeping order).
  ///
  /// Note: This will NOT sort anything.
  ///
  M<K, V> addEntries(Iterable<MapEntry<K, V>> entries) {
    Map<K, V> map = Map.fromEntries(this.entries.followedBy(entries));
    return MFlat<K, V>.unsafe(map);
  }

  // TODO: Still need to implement efficiently.
  M<K, V> remove(K key) {
    return !containsKey(key) ? this : MFlat<K, V>.unsafe(unlock..remove(key));
  }

  /// Removes all entries of this map that satisfy the given [predicate].
  M<K, V> removeWhere(bool Function(K key, V value) predicate) {
    Map<K, V> oldMap = unlock;
    int oldLength = oldMap.length;
    Map<K, V> newMap = oldMap..removeWhere(predicate);
    return (newMap.length == oldLength) ? this : MFlat<K, V>.unsafe(newMap);
  }

  /// Provides a view of this map as having [RK] keys and [RV] instances.
  /// May return `M<RK, RV>` or `Map<RK, RV>`.
  Map<RK, RV> cast<RK, RV>(ConfigMap config) =>
      (RK == K && RV == V) ? (this as Map<RK, RV>) : getFlushed(config).cast<RK, RV>();

  /// Returns `true` if there is no key/value pair in the map.
  bool get isEmpty => length == 0;

  /// Returns `true` if there is at least one key/value pair in the map.
  bool get isNotEmpty => !isEmpty;

  V? operator [](K key);

  /// Returns `true` if this map contains the given [key] with the given [value].
  bool contains(K key, V value) {
    V? _value = this[key];
    return (_value == null) ? containsKey(key) : (_value == value);
  }

  /// Returns `true` if this map contains the given [key].
  ///
  /// Returns `true` if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  bool containsKey(K? key);

  /// Returns `true` if this map contains the given [value].
  ///
  /// Returns `true` if any of the values in the map are equal to `value`
  /// according to the `==` operator.
  bool containsValue(V? value);

  bool containsEntry(MapEntry<K, V> entry) => contains(entry.key, entry.value);

  bool any(bool Function(K key, V value) test) =>
      entries.any((entry) => test(entry.key, entry.value));

  bool anyEntry(bool Function(MapEntry<K, V>) test) => entries.any(test);

  bool everyEntry(bool Function(MapEntry<K, V>) test) => entries.every(test);

  void forEach(void Function(K key, V value) f) =>
      entries.forEach((entry) => f(entry.key, entry.value));

  Map<K, V> where(bool Function(K key, V value) test) {
    final Map<K, V> matches = {};
    entries.forEach((entry) {
      if (test(entry.key, entry.value)) matches[entry.key] = entry.value;
    });
    return matches;
  }
}
