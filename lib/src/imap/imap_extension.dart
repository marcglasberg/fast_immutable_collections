import "imap.dart";

extension IMapExtension<K, V> on Map<K, V> {
  /// Locks the map, returning an *immutable* map ([IMap]).
  IMap<K, V> get lock => IMap<K, V>(this);

  /// Locks the map, returning an *immutable* map ([IMap]).
  /// This is unsafe: Use it at your own peril.
  /// This constructor is fast, since it makes no defensive copies of the map.
  /// However, you should only use this with a new map you've created yourself,
  /// when you are sure no external copies exist. If the original map is modified,
  /// it will break the IMap and any other derived map in unpredictable ways.
  /// Note you can optionally disallow unsafe constructors in the global configuration
  /// by doing: `disallowUnsafeConstructors = true` (and then optionally preventing
  /// further configuration changes by calling `ImmutableCollection.lockConfig()`).
  IMap<K, V> get lockUnsafe => IMap<K, V>.unsafe(this, config: IMap.defaultConfig);
}
