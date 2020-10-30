import "package:fast_immutable_collections/fast_immutable_collections.dart";

extension ISetExtension<T> on Set<T> {
  /// Locks the set, returning an *immutable* set ([ISet]).
  ISet<T> get lock => ISet<T>(this);
}
