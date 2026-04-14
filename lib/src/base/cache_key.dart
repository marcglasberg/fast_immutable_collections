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
