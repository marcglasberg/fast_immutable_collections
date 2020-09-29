# Micro Changelog

A summary of detailed changes, aimed at developers. This constrasts with the [`CHANGELOG.md`][changelog] file, which is log for changes over versions, and thus even more summarized.


[changelog]: ../CHANGELOG.md

## 29/09/2020

### 1. Philippe Fanaro

1. Changed casting to return an `Iterable`.
    - Now, all of the tests are passing.
    - The `TODO`s still remain, as I'm not 100% sure it's the intended behavior.
1. Changes to `cast`ing for `L`, `S` and `M`.
    - Shouldn't `M` extend `Map`?
1. For `iMap`, I've implemented and tested &mdash; some of those methods will have siblings inside `M` &mdash; the missing:
    - `every`
    - `forEach`
    - `toMap`