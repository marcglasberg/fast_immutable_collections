# Micro Changelog

A summary of detailed changes, aimed at developers. This constrasts with the [`CHANGELOG.md`][changelog] file, which is log for changes over versions, and thus even more summarized.

> The dates below follow the format *DD/MM/YYYY*.


[changelog]: ../CHANGELOG.md

## 12/10/2020

### 1. Philippe Fanaro

1. Improvements to the structure of the top-level [`README`][readme].
1. Included the views and the configuration classes in the [`CHANGELOG`][changelog].
1. Tests to ensure immutability of:
    - `IMap`
1. Current TODOs:
    1. Immutability Tests for `IMapOfSet`.
    1. `.iterator` tests for all collections.
    1. Review `equals`/`same` tests.
    1. Coverage on the CI/CD.
    1. Tests for the views.
    1. Reorganized the configuration classes.
    1. Tests for the configuration classes.


[readme]: ../README.md

## 08/10/2020

### 1. Philippe Fanaro

1. Completed tests for:
    - `IMap`
    - `IMapOfSets`
1. Added tests to ensure that `IMap` won't add repeated keys.

> **I haven't yet added immutability checks for `MAdd`, `MAddAll`, `MReplace`, `IMap` or `IMapOfSets`.**

## 07/10/2020

### 1. Philippe Fanaro

1. Completed basic tests for:
    - `MAdd`
    - `MAddAll`
    - `Entry`

## 06/10/2020

### 1. Philippe Fanaro

1. Improved and completed tests, and ensured immutability for:
    - `IList`
    - `ISet`
1. Completed basic tests for: 
    - `MFlat`
    - `MReplace`

## 05/10/2020

### 1. Philippe Fanaro

1. Completed tests and ensured immutability for:
    - `SFlat`
    - `SAdd`
    - `SAddAll`

## 02/10/2020

### 1. Philippe Fanaro

1. Completed the immutability tests for `LFlat`.
1. Completed the tests for `IMapOfSets`.
    - Apparently, when adding elements to the key, the `IMapOfSets` is still adding the repeated key, which is causing errors.
    - In the `anyKey` method, if `any` returns `null`, we will have an error when we try to calculate `.key` &mdash; just replace it for `?.key`?

## 01/10/2020

### 1. Philippe Fanaro

1. Added a section to the `README.md` about the idea behind the implemantion.
1. More tests to ensure immutability to `LAdd`.
1. Hopefully completed tests for `LAdd`.
1. Reorganized tests for `LAddAll`.
1. Immutability Tests for `LAddAll`.
1. `IMapOfSets` tests that are a little bit easier to follow.
1. Upgraded the highlighting of the docs on the `IMapOfSets`.
1. Added the missing, not tested methods of `IList`:
    - `toggle`
    - `[]`
1. Added more tests to ensure the immutability of `IList`s.

## 30/09/2020

### 1. Philippe Fanaro

1. Cleaning up the unnecessary methods and implementations.
    - If you want to go back to them, this is the commit: `e4a3e63f28c0e1de93fd31759e0bf939772fdfae`
    - I'll leave only the methods which appear on the `Map`'s interface, that is:
        - `forEach`
        - `where`
        - `map`
    - The remaining methods mentioned above now feature `TODO`s on top of them, so we know we have to come back to their implementations in the future.
1. Added a `TODO` to the commented out `everyEntry` method of `IMap`.
1. Created a group of tests inside for `IList` to check if it really is immutable.
1. Created the *essential* tests for `LFlat`.
1. Tested the remaining methods for `LFlat`.
1. Added tests on ensuring immutability to `LAdd`.
1. Added tests for `unlock` on `LFlat` and `Ladd`.

## 29/09/2020

### 1. Philippe Fanaro

> Shouldn't the `length` on `LAdd` et al. be cached/initialized on object creation? This way we wouldn't have to worry about nested `length` calls in the background... It's more costly memory-wise, but it's not the same as caching everything from every object. And it would make the cost of accessing the `length` constant instead of dependent on the random nested underlying structure.

1. Changed casting to return an `Iterable`.
    - Now, all of the tests are passing.
    - The `TODO`s still remain, as I'm not 100% sure it's the intended behavior.
1. Changes to `cast`ing for `L`, `S` and `M`.
    - Shouldn't `M` extend `Map`?
        - Marcelo: we can't because the `Map` abstract class has mutation methods. At any rate we will leave it as is for now.
1. For `IMap`, I've implemented and tested &mdash; some of those methods will have siblings inside `M` &mdash; the missing:
    - `every`
    - `forEach`
    - `toMap`
    - `toSet`
    - `where`
    - `whereKeyType`
    - `whereValueType`
    - `map`

> **I thought I was supposed to implement and test the above, but it turns out I was only supposed to test for desired behavior, even if it ends up in a lot of broken tests...** 🤦‍♂️