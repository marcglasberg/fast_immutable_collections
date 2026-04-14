Sponsored by [MyText.ai](https://mytext.ai)

[![](./example/SponsoredByMyTextAi.png)](https://mytext.ai)

## 11.2.0

* Added `cached` method and `CacheKey` class for caching derived computations
  on `IList`, `ISet`, and `IMap`.

  Since immutable collections never change, any value derived from their contents
  is stable and can be safely cached. The new `cached` method lets you lazily compute
  and cache a derived value (like an index map) inside the collection instance itself,
  so subsequent calls return the cached result in O(1).

  Define a `CacheKey<C, R>` that pairs a cache identity with a typed computation
  function. Use `static final` or top-level variables for keys so the same object
  reference is reused across calls:

  ```dart
  class PairState {
    final IList<Pair> pairs;
  
    static final _byId = CacheKey<IList<Pair>, Map<Id, Pair>>(
      (list) => {for (var p in list) p.id: p},
    );
  
    Pair? findById(Id id) => pairs.cached(_byId)[id];
  }
  ```

  The first call to `cached` builds the map in O(n) and caches it. Every subsequent
  call is O(1). When the collection is replaced with a new instance (e.g., an item
  is added), the old cache is garbage-collected with the old instance, and the new
  one builds its own cache on first access.

  Multiple cache keys can be used on the same collection, each caching independently:

  ```dart
  static final _byId = CacheKey<IList<User>, Map<String, User>>(
    (list) => {for (var u in list) u.id: u},
  );

  static final _byEmail = CacheKey<IList<User>, Map<String, User>>(
    (list) => {for (var u in list) u.email: u},
  );
  ```

  Notes:
  - The cache adds zero overhead to collections that don't use it (a single null pointer).
  - The cache survives `flush()` since the collection identity is preserved.
  - Constant collections (`const IList.empty()`, `const IListConst(...)`, etc.) support
    `cached` but compute the value each time without caching, since they cannot hold
    mutable state.
  - `CacheKey` can be `const` when using a static or top-level function reference.

## 11.1.0

* Added helper extension method `IList<IList<T>>.putXY()` for setting values in   
  2D lists, using x,y coordinates.

## 11.0.4

* Doc improvements.

## 10.2.4

* Optimized `IMap.update()`.

## 10.2.3

* Improved `IList.zip()` generic typing.

## 10.2.2

* You can now declare empty lists, sets and maps like
  this (https://github.com/marcglasberg/fast_immutable_collections/pull/74):

  ```dart
  const IList<String>.empty();
  const ISet<String>.empty();
  const IMap<String, int>.empty();
  ```         

* Better inference for sumBy returning
  zero (https://github.com/marcglasberg/fast_immutable_collections/pull/71).

## 10.1.2

* Fixed https://github.com/marcglasberg/fast_immutable_collections/pull/71

## 10.1.1

* Fixed https://github.com/marcglasberg/fast_immutable_collections/issues/69

## 10.1.0

* Fixed https://github.com/marcglasberg/fast_immutable_collections/issues/68

## 10.0.0

* Removed tuples in favor of records.

## 9.2.1

* @useResult annotation to signal that a method should return a copy of the
  collection, instead of
  mutating it.

## 9.1.6

* Small docs improvement.

## 9.1.5

* Fixed type erasure in IMap.toJson and build issue for benchmark app.

## 9.1.4

* Removed unnecessary map creation when deserializing IMap from Json.
* Bumped environment to '>=2.14.0 <3.0.0'

## 9.1.1

* Function `compareObject` now also compares enums by their name.

## 9.0.0

* Version bump of dependencies: collection: ^1.17.0, meta: ^1.8.0

## 8.2.0

* `IList.replaceBy` method lets you define a function to transform an item at a
  specific index
  location.

## 8.1.1

* `IList.indexOf` extension fix (doesn't break anymore when list is empty and
  start is zero).

## 8.1.0

* `Iterable.intersectsWith` extension.

## 8.0.0

* Breaking change: `IList.replaceFirstWhere` signature is now
  `IList<T> replaceFirstWhere(bool Function(T item) test, T Function(T? item) replacement, {bool addIfNotFound = false})`
  instead of
  `IList<T> replaceFirstWhere(bool Function(T item) test, T to, {bool addIfNotFound = false})`
  In case this change breaks your code, the fix is simple. Instead of something
  like
  `ilist.replaceFirstWhere((String item) => item=="1", "2")`
  do this: `ilist.replaceFirstWhere((String item) => item=="1", (_) => "2")`

## 1.0.0

* Initial version: 2021/01/12
