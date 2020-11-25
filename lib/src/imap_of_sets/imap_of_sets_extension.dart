import "imap_of_sets.dart";

// TODO: Marcelo, talvez também adicionar uma extensão à `Map<K, ISet<V>>`?
extension IMapOfSetsExtension<K, V> on Map<K, Set<V>> {
  /// Locks the map of sets, returning an *immutable* map ([IMapOfSets]).
  IMapOfSets<K, V> get lock => IMapOfSets<K, V>(this);
}
