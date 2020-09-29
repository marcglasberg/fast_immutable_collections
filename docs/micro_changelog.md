# Micro Changelog

A summary of detailed changes, aimed at developers. This constrasts with the [`CHANGELOG.md`][changelog] file, which is log for changes over versions, and thus even more summarized.


[changelog]: ../CHANGELOG.md

## 29/09/2020

### 1. Philippe Fanaro

> Shouldn't the `length` on `LAdd` et al. be cached/initialized on object creation? This way we wouldn't have to worry about nested `length` calls in the background... It's more costly memory-wise, but it's not the same as caching everything from every object. And it would make the cost of accessing the `length` constant instead of dependent on the random nested underlying structure.

1. Changed casting to return an `Iterable`.
    - Now, all of the tests are passing.
    - The `TODO`s still remain, as I'm not 100% sure it's the intended behavior.
1. Changes to `cast`ing for `L`, `S` and `M`.
    - Shouldn't `M` extend `Map`?
1. For `iMap`, I've implemented and tested &mdash; some of those methods will have siblings inside `M` &mdash; the missing:
    - `every`
    - `forEach`
    - `toMap`
    - `where`
    - `whereKeyType`
    - `whereValueType`
    - `map`

> **I thought I was supposed to implement and test the above, but it turns out I was only supposed to test for desired behavior, even if it ends up in a lot of broken tests...** 🤦‍♂️