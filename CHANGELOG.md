## [7.0.3] - 2021/09/12

* Const `IMap`. Example: `const IMap<String, int> myMap = IMapConst({1:'a', 2:'b'});`
  Example of const empty map: `const IMap<String, int> myMap = IMapConst({});`

* Const `IMapOfSets`.
  Example: `const IMapOfSets<String, int> myMapOfSets = IMapOfSetsConst(IMapConst({}));`
  Example of const empty map of
  sets: `const IMapOfSets<String, int> myMapOfSets = IMapOfSetsConst(IMapConst({'a': ISetConst({1, 2})}));`

* Breaking change: If you use the `IListConst.withConfig()` or `ISetConst.withConfig()`
  constructors, just remove the `.withConfig` and it will work. For example:
  `IListConst.withConfig([], ConfigList(isDeepEquals: false))` should become
  `IListConst([], ConfigList(isDeepEquals: false))`.

## [6.0.0] - 2021/09/05

* Breaking change: Note, unless you know what an "async flush mode" is, and use it explicitly, this
  breaking change is not important to you, and you don't need to do anything to upgrade. If you want
  to know the details, however, keep reading. I have removed the async flush mode. The
  **async** flush mode only flushed after the async gap, but since Dart does not allow
  **tail-call-optimization** (https://github.com/dart-lang/language/issues/1159) it was not possible
  to guarantee that very large collections created within the current microtask would not throw a
  stack-overflow error when reading values from it. The solution to make it work async was to
  tail-call-optimize by hand, which I played with a little bit. For example, check out the
  new `IMap` implementations for `operator []` and `containsKey()`. However, I'd actually would have
  to do that for each and every method that traverses the data tree, for each collection in FIC. The
  amount of work was just too much, so I've decided to remove the async flush mode. The **sync
  mode** was recommended anyway (which now is the only mode, meaning I have removed any references
  to it in the docs), so I guess that won't make much of a difference to anyone.

## [5.1.3] - 2021/08/31

* `FromIListMixin` and `FromISetMixin` improvement to deal with `IListConst<Never>`.

## [5.1.2] - 2021/07/19

* `IList.sortReversed()`.

## [5.1.1] - 2021/07/16

* `ListMap.unsafeFrom()` constructor.

## [5.1.0] - 2021/06/25

* Breaking change: Align head and tail to dart convention as getter like first and last

* Introduce the OP typedef.

* `IList.init` Access init part of the list.

* `IList.inits`, `IList.tails` methods.

* `IList.splitAt` Tuples from original list at specified index.

* `IList.whereNot` Reverse predicate for Where.

* `Iterable<Tuple2<U, V>>.unzip()` extension.

* `IList.count(Predicate)` count positive predicates.

* `IList.iterate` generate IList applying OP multiple times.

* `IList.iterateWhile` generate IList applying OP while Predicate stand.

* `IList.span` Tuple2 will contain the longest consecutive positive predicate then the rest of the
  list.

* `IList.tabulate` Apply function start at 0 on multiples dimensions.

* `IList.corresponds` Check for correspondence between list and applied function on list.

* `IList.lengthCompare` `ISet.lengthCompare` Direct size comparison as convenience for composition.

* Arity property on Abstract Tuple.

## [5.0.5] - 2021/06/27

* MapOfSets.isEmptyForKey() and MapOfSets.isNotEmptyForKey().

## [5.0.4] - 2021/06/24

* Introduce the Predicate typedef.

## [5.0.2] - 2021/06/23

* `List.sortReversed()` extension.

## [5.0.1] - 2021/05/24

* `Iterable.restrict()` restricts some item to one of those present in this iterable.

* Reuse `IList`s and `ISet`s only if they have the exact same generic type.

## [5.0.0] - 2021/05/24

* Const `IList`. Example: `const IList<int> myList = IListConst([1, 2, 3]);`
  Example of const empty list: `const IList<String> myList = IListConst([]);`

* Const `ISet`. Example: `const ISet<int> mySet = ISetConst({1, 2, 3});`
  Example of const empty set: `const ISet<String> mySet = ISetConst({});`

* Methods `IList.get()`, `IList.getOrNull()` and `IList.getAndMap()`.

* Extensions `List.get()`, `List.getOrNull()` and `List.getAndMap()`.

* Better NNBD for `divideListAsMap()` and `sortedLike()`.

* Better Json serialization for NNBD.

* Small IMapOfSets.fromIterable() improvement: added `ignore` parameter.

* Breaking change: Removed `empty()` constructors from `IList` and `ISet`. You can create empty
  collections using `IList()` and `ISet()`, or `myIList.clear()` and `myISet.clear()`, or
  `IList.withConfig(const [], myConfig)` and `ISet.withConfig(const [], myConfig)`, or
  `const IListConst([])` and `const ISetConst({})`.

* Breaking change: Removed all extensions like `isNullOrEmpty` and similar. This was a good idea
  before NNBD, but now if you use this Dart can't infer nullability anymore.

* Breaking change. Please, add `import "package:collection/collection.dart";` to your project. I
  have removed a few methods, like `Iterable.mapIndexed`, because they are now present in the
  `collection` package.

## [4.0.6] - 2021/04/20

* Extension `List.withNullsRemoved()`.

## [4.0.5] - 2021/04/19

* The `contains()` methods now accept `null`.
* Method `toggle()` now returns the correct bool.

## [4.0.4] - 2021/04/18

* `Iterable.isFirst`, `isNotFirst`, `isLast` and `isNotLast`.

## [4.0.3] - 2021/04/16

* Breaking change. Please, add `import "package:collection/collection.dart";` to your project. I
  have removed the following methods because they are now present in the `collection` package:
    * `Iterable.firstwhereOrNull`
    * `Iterable.whereNotNull`

* Breaking change: `inRange()` of nullable num now returns non-null, and `orElse` is not optional.

* Added `Iterable.mapNotNull` extension. It's similar to `map`, but returns `Iterable<T>`, where `T`
  can be a non-nullable type. This is equivalent to `map` plus `cast`, but has a better name when
  you are just using it to solve NNBD problems.

## [3.0.2] - 2021/04/14

* Json serialization support for json_serializable with @JsonSerializable
  (for IList, ISet, IMap, ListSet, ListSetView).

* Renamed extension `isNotNullOrZero` to `isNotNullNotZero`.

## [2.0.4] - 2021/04/12

* Factories `IList<T>.orNull()`, `ISet<T>.orNull()`, `IMap<K, V>.orNull()`,
  and `IMapofSets<K, V>.orNull()`, that help implement `copyWith` methods.

## [2.0.2] - 2021/20/03

* Breaking changes:
    - `Iterable.removeDuplicates` was renamed to `Iterable.whereNoDuplicates` to indicate it returns
      an Iterable.
    - `Iterable.removeNulls` was renamed to `Iterable.whereNotNull` to indicate it returns an
      Iterable.
    - `List.removeNulls` now is a List extension only. It mutates the `List`, removing nulls.
    - `List.removeDuplicates` now is a List extension only. It mutates the `List`, removing all
      duplicates.
    - `Set.removeNulls` now is a Set extension only. It mutates the `Set`, removing all nulls.

## [2.0.1] - 2021/03/03

* Nullsafety improvements.
* isNotNullOrEmpty getter renamed to isNotNullNotEmpty.
* isEmptyButNotNull getter to isEmptyNotNull.

## [1.0.28] - 2021/02/09

* More efficient Iterable.sortedLike() and List.sortLike() extensions.
* Set.diffAndIntersect(), Iterable.everyIs() and Iterable.anyIs() extensions.

## [1.0.26] - 2021/01/28

* Better generics compatibility for `equalItemsAndConfig`.

## [1.0.18] - 2021/01/19

* `IList.replace()`.
* `ISet.difference()`, `intersection`, `union` now accept iterables.

## [1.0.10] - 2021/01/18

* `areSameImmutableCollection()` and `areImmutableCollectionsWithEqualItems()` functions.

## [1.0.9] - 2021/01/12

* Initial version.



