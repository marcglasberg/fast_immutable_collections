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



