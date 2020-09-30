# Micro Changelog

A summary of detailed changes, aimed at developers. This constrasts with the [`CHANGELOG.md`][changelog] file, which is log for changes over versions, and thus even more summarized.


[changelog]: ../CHANGELOG.md

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