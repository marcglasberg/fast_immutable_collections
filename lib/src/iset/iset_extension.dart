import "iset.dart";

/// See also: [IListExtension]
extension ISetExtension<T> on Set<T> {
  /// Locks the set, returning an *immutable* set ([ISet]).
  ISet<T> get lock => ISet<T>(this);

  /// Locks the set, returning an *immutable* set ([ISet]).
  ///
  /// **This is unsafe: Use it at your own peril**.
  ///
  /// This constructor is fast, since it makes no defensive copies of the set.
  /// However, you should only use this with a new set you've created yourself,
  /// when you are sure no external copies exist. If the original set is modified,
  /// it will break the [ISet] and any other derived sets in unpredictable ways.
  ///
  /// Note you can optionally disallow unsafe constructors in the global configuration
  /// by doing: `ImmutableCollection.disallowUnsafeConstructors = true` (and then optionally
  /// preventing further configuration changes by calling `lockConfig()`).
  ///
  /// See also: [ImmutableCollection]
  ISet<T> get lockUnsafe => ISet<T>.unsafe(this, config: ISet.defaultConfig);
}
