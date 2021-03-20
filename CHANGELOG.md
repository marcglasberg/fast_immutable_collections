## [2.0.2] - 2021/20/03

* Breaking changes:
    - `Iterable.removeDuplicates` was renamed to `Iterable.whereNoDuplicates` to indicate it returns an Iterable.
    - `Iterable.removeNulls` was renamed to `Iterable.whereNotNull` to indicate it returns an Iterable.
    - `List.removeNulls` now is a List extension only. It mutates the `List`, removing nulls.
    - `List.removeDuplicates` now is a List extension only. It mutates the `List`, removing all duplicates.
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



