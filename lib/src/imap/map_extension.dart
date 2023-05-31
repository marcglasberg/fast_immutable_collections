// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// See also: [FicMapOfSetsExtension]
extension FicMapExtension<K, V> on Map<K, V> {
  /// Locks the map, returning an *immutable* map ([IMap]).
  IMap<K, V> get lock => IMap<K, V>(this);

  /// Locks the map, returning an *immutable* map ([IMap]).
  ///
  /// **This is unsafe: Use it at your own peril**.
  ///
  /// This constructor is fast, since it makes no defensive copies of the map.
  /// However, you should only use this with a new map you've created yourself,
  /// when you are sure no external copies exist. If the original map is modified,
  /// it will break the [IMap] and any other derived map in unpredictable ways.
  ///
  /// Note you can optionally disallow unsafe constructors in the global configuration
  /// by doing: `ImmutableCollection.disallowUnsafeConstructors = true` (and then optionally
  /// preventing further configuration changes by calling `ImmutableCollection.lockConfig()`).
  ///
  /// See also: [ImmutableCollection]
  IMap<K, V> get lockUnsafe => IMap<K, V>.unsafe(this, config: IMap.defaultConfig);

  /// Creates an *immutable* map ([IMap]) from the map.
  IMap<K, V> toIMap([ConfigMap? config]) =>
      IMap<K, V>.withConfig(this, config ?? IMap.defaultConfig);

  /// Returns a new lazy [Iterable] with elements that are created by
  /// calling `mapper` on each entry of this `Map` in
  /// iteration order.
  ///
  /// The returned iterable is lazy, so it won't iterate the elements of
  /// this map until it is itself iterated, and then it will apply
  /// [mapper] to create one element at a time.
  /// The converted elements are not cached.
  /// Iterating multiple times over the returned [Iterable]
  /// will invoke the supplied [mapper] function once per element
  /// for on each iteration.
  ///
  /// Note: While [map] returns a new `Map`, [mapTo] returns an `Iterable`
  /// of elements created by combining the entries keys and values.
  ///
  Iterable<T> mapTo<T>(T Function(K key, V value) mapper) =>
      entries.map((MapEntry<K, V> entry) => mapper(entry.key, entry.value));
}

/// See also: [FicMapExtension]
extension FicMapOfSetsExtension<K, V> on Map<K, Set<V>> {
  /// Locks the map of sets, returning an *immutable* map ([IMapOfSets]).
  IMapOfSets<K, V> get lock => IMapOfSets<K, V>(this);

  /// Creates an *immutable* map of sets ([IMapOfSets]) from the map.
  IMapOfSets<K, V>? toIMapOfSets([ConfigMapOfSets? config]) =>
      IMapOfSets<K, V>.withConfig(this, config ?? IMapOfSets.defaultConfig);
}

/// See also: [FicIterableExtension], [FicIteratorExtension]
extension FicMapIteratorExtension<K, V> on Iterator<MapEntry<K, V>> {
  //
  /// Converts the iterator of map entries into an iterable.
  Iterable<MapEntry<K, V>> toIterable() sync* {
    while (moveNext()) yield current;
  }

  /// Converts the iterator of map entries into a map.
  Map<K, V> toMap() => Map.fromEntries(toIterable());
}
