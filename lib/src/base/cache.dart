import "package:fast_immutable_collections/fast_immutable_collections.dart";

// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

/// A typed key for caching derived computations on immutable collections.
///
/// Since immutable collections never change, any computation derived from their
/// contents is stable and can be safely cached. [CacheKey] pairs a cache
/// identity with a computation function, so the collection can lazily build
/// and cache the result on first access.
///
/// Usage:
///
/// ```dart
/// // Define a static cache key (static ensures same reference every time).
/// static final byId = CacheKey<IList<User>, Map<String, User>>(
///   (list) => {for (var u in list) u.id: u},
/// );
///
/// // Use it — first call computes, subsequent calls return cached value.
/// final user = users.cached(byId)[userId];
/// ```
///
/// **Important:** Always use a `static final` or top-level variable for
/// [CacheKey] instances so that the same key object is reused across calls.
/// Creating a new [CacheKey] on every call defeats caching, since identity
/// is used to look up cached values.
///
class CacheKey<C, R> {
  final R Function(C collection) _compute;

  const CacheKey(this._compute);

  R computeFrom(C collection) => _compute(collection);
}

final _cache = Expando<Expando>('fast_immutable_collections cache');

class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

@pragma('vm:prefer-inline')
R _cached<C extends Object, R>(C collection, CacheKey<C, R> key) {
  var thisCache = _cache[collection];
  if (thisCache != null) {
    switch (thisCache[key]) {
      case null:
        break;
      case _sentinel:
        return null as R;
      case final result:
        return result as R;
    }
  } else {
    thisCache = Expando<Object>('cache for $collection');
    _cache[collection] = thisCache;
  }
  final result = key.computeFrom(collection);
  thisCache[key] = result ?? _sentinel;
  return result;
}

extension IListCacheExtension<T> on IList<T> {
  /// Returns a cached value derived from this list, computing it on first access.
  ///
  /// Since [IList] is immutable, any value derived from its contents is stable and
  /// can be safely cached. Use a [CacheKey] to define the computation and retrieve
  /// the cached result.
  ///
  /// The [CacheKey] should be a `static final` or top-level variable so that the
  /// same object is reused across calls. Creating a new [CacheKey] on each call
  /// defeats caching.
  ///
  /// Example:
  ///
  /// ```dart
  /// class UserState {
  ///   final IList<User> users;
  ///
  ///   static final _byId = CacheKey<IList<User>, Map<String, User>>(
  ///     (list) => {for (var u in list) u.id: u},
  ///   );
  ///
  ///   User? findById(String id) => users.cached(_byId)[id];
  /// }
  /// ```
  ///
  R cached<R>(CacheKey<IList<T>, R> key) => _cached(this, key);
}

extension IMapCacheExtension<K, V> on IMap<K, V> {
  /// Returns a cached value derived from this map, computing it on first access.
  ///
  /// Since [IMap] is immutable, any value derived from its contents is stable and
  /// can be safely cached. Use a [CacheKey] to define the computation and retrieve
  /// the cached result.
  ///
  /// The [CacheKey] should be a `static final` or top-level variable so that the
  /// same object is reused across calls. Creating a new [CacheKey] on each call
  /// defeats caching.
  ///
  /// Example:
  ///
  /// ```dart
  /// class SettingsState {
  ///   final IMap<String, Setting> settings;
  ///
  ///   static final _byCategory = CacheKey<IMap<String, Setting>, Map<Category, List<Setting>>>(
  ///     (map) {
  ///       final result = <Category, List<Setting>>{};
  ///       for (var entry in map.entries) {
  ///         (result[entry.value.category] ??= []).add(entry.value);
  ///       }
  ///       return result;
  ///     },
  ///   );
  ///
  ///   List<Setting> findByCategory(Category cat) => settings.cached(_byCategory)[cat] ?? [];
  /// }
  /// ```
  ///
  R cached<R>(CacheKey<IMap<K, V>, R> key) => _cached(this, key);
}

extension ISetCacheExtension<T> on ISet<T> {
  /// Returns a cached value derived from this set, computing it on first access.
  ///
  /// Since [ISet] is immutable, any value derived from its contents is stable and
  /// can be safely cached. Use a [CacheKey] to define the computation and retrieve
  /// the cached result.
  ///
  /// The [CacheKey] should be a `static final` or top-level variable so that the
  /// same object is reused across calls. Creating a new [CacheKey] on each call
  /// defeats caching.
  ///
  /// Example:
  ///
  /// ```dart
  /// class TagState {
  ///   final ISet<Tag> tags;
  ///
  ///   static final _byName = CacheKey<ISet<Tag>, Map<String, Tag>>(
  ///     (set) => {for (var t in set) t.name: t},
  ///   );
  ///
  ///   Tag? findByName(String name) => tags.cached(_byName)[name];
  /// }
  /// ```
  ///
  R cached<R>(CacheKey<ISet<T>, R> key) => _cached(this, key);
}
