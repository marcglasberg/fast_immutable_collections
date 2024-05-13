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

* @useResult annotation to signal that a method should return a copy of the collection, instead of
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

* `IList.replaceBy` method lets you define a function to transform an item at a specific index
  location.

## 8.1.1

* `IList.indexOf` extension fix (doesn't break anymore when list is empty and start is zero).

## 8.1.0

* `Iterable.intersectsWith` extension.

## 8.0.0

* Breaking change: `IList.replaceFirstWhere` signature is now
  `IList<T> replaceFirstWhere(bool Function(T item) test, T Function(T? item) replacement, {bool addIfNotFound = false})`
  instead of
  `IList<T> replaceFirstWhere(bool Function(T item) test, T to, {bool addIfNotFound = false})`
  In case this change breaks your code, the fix is simple. Instead of something like
  `ilist.replaceFirstWhere((String item) => item=="1", "2")`
  do this: `ilist.replaceFirstWhere((String item) => item=="1", (_) => "2")`

## 1.0.0

* Initial version: 2021/01/12



