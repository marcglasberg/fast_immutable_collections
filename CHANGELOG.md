Sponsored by [MyText.ai](https://mytext.ai)

[![](./example/SponsoredByMyTextAi.png)](https://mytext.ai)

## 12.0.0

* **Breaking change:** `IList`, `ISet` and `IMap` that compare by identity
  (`isDeepEquals: false` in the constructor) now compare the collection objects
  themselves. In other words, `collection1 == collection2` is now the same as
  `identical(collection1, collection2)` when deep equals is turned off.
  Previously, they compared their internal structure, so two different collections that
  shared the same internal structure were considered equal.
  However, this internal structure changes when a collection is flushed (which may also
  happen automatically, just by reading it), so their `==` and `hashCode` could change,
  and they could be lost in a `Set` or as `Map` keys. The `hashCode` of constant ones also
  changed each time it was read. Note: You can still use `same()` to check if two
  collections share the same internal structure. Collections that compare by deep equals
  (`isDeepEquals: true` in the constructor) are the default, and are not affected.

* Fixed `IMap.fromJson` and `IMap.toJson` for non-String keys when used with
  `json_serializable`. IMap keys now work the same as regular `Map` keys, including
  enums (https://github.com/marcglasberg/fast_immutable_collections/issues/39),
  `DateTime`, `BigInt` and `Uri`
  (https://github.com/marcglasberg/fast_immutable_collections/issues/58), and custom
  key types with a `JsonConverter` or their own `fromJson`/`toJson`
  (https://github.com/marcglasberg/fast_immutable_collections/issues/82).
  For example:

  ```dart
  @JsonSerializable()
  class MyClass {
    final IMap<MyEnum, bool> byEnum;
    final IMap<DateTime, String> byDate;    
  }
  ```

  The `fromJsonK` function now receives the JSON key string, except when the key
  type is `bool`, `int`, `double` or `num`, in which case it receives the parsed value (as
  `json_serializable` expects). If the key is not a string, number, bool, `DateTime`,
  `BigInt`, `Uri` or enum, `IMap.toJson` now calls the key's own `toJson` method.

  Note: For `IMap<Object, V>` and `IMap<dynamic, V>`, `fromJsonK` now receives the JSON
  key string. Previously, the key was wrongly converted into a `bool`.

* Much faster iteration (like `for (final item in ilist)`) of `IList`, `ISet` and `IMap`
  that were not yet flushed. Previously, each item went through the iterators of all
  internal nodes created by `add` and `addAll`. Now each item is read only once, using
  very little extra memory, and without creating any lists. For example, iterating an
  `IList` of 10,000 items after 500 `add` calls is now about 480 times faster, and an
  `ISet` or `IMap` after 50 `add` calls, about 9 to 45 times faster. The same is true
  for `IMap.entries`, `IMap.keys` and `IMap.values`, including maps updated with `add`
  or `update` of existing keys, and for methods like `join`, `elementAt` and `[]`. For
  example, after 200 `add` calls, `IList.join` is about 48 times faster, and `IList[]`
  about 90 times faster.

* Much faster `flush` (and `unlock`) of `IList`, `ISet`, `IMap` and `IMapOfSets`
  created by many `add`, `addAll` and `update` calls. These calls create a chain of
  internal nodes, and flushing used to iterate this chain, which was slow because each
  item went through the iterators of all the nodes above it. Now flushing walks down the
  chain only once, without iterating it. Since flushing happens automatically after a
  number of operations, this also makes many consecutive additions much faster. For
  example, adding 1000 items to an `IList` of 10,000 items is now about 800 times faster,
  and to an `ISet` or `IMap` of 10,000 items, about 12 to 20 times faster.

* Faster `where`, `map`, `any`, `every`, `forEach`, `fold`, `toList` and `toSet` of
  `IList` and `ISet` (and of the `keys` and `values` of `IMap`) that were not yet
  flushed, since they no longer go through the iterators of all internal nodes. For
  example, `where` and `any` are now 16 to 50 times faster after 20 `add` calls,
  `IList.toList` is 3 to 12 times faster, and `toList(growable: false)` is 1.5 to 2.9
  times faster.

* `ISet.toList` is about 5 times faster for sets that are already flushed.

* Fixed `ISet.anyItem` throwing `StateError` for a non-empty set created by adding
  items to an empty set. For example: `ISet<int>([]).addAll([1]).anyItem`.

* Fixed `IList.single` and `ISet.single` returning an item, instead of throwing
  `StateError`, after adding items to a list or set with a single item. For example:
  `IList([1]).addAll([2]).single` returned `1`.

* `ISet.difference` and `ISet.intersection` are about 1.4 times faster for sets that
  were not yet flushed, and their results now keep the iteration order of the set.

* Prevented the possibility of stack overflows in many methods (like `length`, `contains`,
  `[]`, `first`, `entries` and iteration) of `IList`, `ISet` and `IMap` with a large
  number of unflushed operations. Note that this was only possible when
  `ImmutableCollection.autoFlush` was `false`.

* Fixed `ImmutableCollection.resetAllConfigurations()` not resetting
  `IList.defaultConfig`, `ISet.defaultConfig` and `IMap.defaultConfig`. It now also
  resets `IMapOfSets.defaultConfig`.

* Fixed `equalItems` of `IList` and `ISet`, and `equalItemsToIMap` of `IMap`, returning
  `false` for collections with equal items but different configurations, after their
  `hashCode` was calculated. Also fixed `equalItemsAndConfig` returning `false` for
  collections that compare by identity and have equal items and configurations, after
  their `hashCode` was calculated.

* Fixed `ISet.withConfig(iset, config)` not sorting the set when `config.sort` is `true`
  and `iset` is an `ISet`. For example,
  `ISet.withConfig({3, 1, 2}.lock, ConfigSet(sort: true))` returned `[3, 1, 2]`.

* Fixed `IMap.cast()` throwing a `TypeError` for maps that were not yet flushed (for
  example, after `add`). Now, as documented, if the map is already an `IMap<RK, RV>`,
  it's returned unchanged.

* Fixed `IMap.toValueSet(compare: ...)` failing an assertion. Now it sorts the values
  with the given `compare` function.

* Fixed `IMap.unlockSorted` not sorting the map when the map's `ConfigMap.sort` is
  `false`.

* Fixed `IMap.entryOrNull` throwing for a key that exists with a `null` value.

* Fixed `IMapOfSets.withConfig(null, config)` ignoring the given `config`, and
  `IMapOfSets.removeValues` and `IMapOfSets.removeValuesWhere` losing the map
  configuration (like `sortKeys`).

* Fixed `remove`, `removeAll` and `removeMany` of constant and empty lists, `remove` of
  constant and empty sets, and `remove` and `removeWhere` of constant and empty maps,
  returning a new collection instead of the same instance when nothing is removed.

* Fixed `IList<Never>().addAll(...)` throwing when
  `ImmutableCollection.disallowUnsafeConstructors` is `true`.

* Fixed `sumBy` throwing `UnsupportedError` for empty iterables when the result type is
  `num`. For example, `<num>[].sumBy((e) => e)` now returns `0`.

* Fixed `compareObject` ignoring `nullsBefore: true` when comparing the keys and values
  of `MapEntry`s.

* Fixed `ListMap.map` not keeping the order of the `ListMap`.

* Fixed `lookup` of `ModifiableSetFromISet` and `UnmodifiableSetFromISet` (returned by
  `ISet.unlockLazy` and `ISet.unlockView`) returning the given element, instead of the
  element that is in the set.

* Fixed the docs of `isFirst`, `isNotFirst`, `isLast` and `isNotLast`, which said
  they return `null` for empty iterables.

## 11.2.1

* Fixed the outdated benchmarks in `example/benchmark`
  (https://github.com/marcglasberg/fast_immutable_collections/issues/85).
  The package code itself is unchanged.

## 11.2.0

* Added `cached` method and `CacheKey` class for caching derived computations
  on `IList`, `ISet`, and `IMap`.

  Since immutable collections never change, any value derived from their contents
  is stable and can be safely cached. The new `cached` method lets you lazily compute
  and cache a derived value (like an index map) inside the collection instance itself,
  so subsequent calls return the cached result in O (1).

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

  The first call to `cached` builds the map in O (n) and caches it. Every subsequent
  call is O (1). When the collection is replaced with a new instance (e.g., an item
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
    - The cache adds zero overhead to collections that don't use it (a single null
      pointer).
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
