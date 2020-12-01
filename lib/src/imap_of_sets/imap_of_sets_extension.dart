import "imap_of_sets.dart";

/// See also: [IMapExtension]
extension IMapOfSetsExtension<K, V> on Map<K, Set<V>> {
  /// Locks the map of sets, returning an *immutable* map ([IMapOfSets]).
  IMapOfSets<K, V> get lock => IMapOfSets<K, V>(this);
}
