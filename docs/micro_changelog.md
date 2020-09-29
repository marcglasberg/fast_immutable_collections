# Micro Changelog

A summary of detailed changes aimed at developers.

## 29/09/2020

### 1. Philippe Fanaro

1. Changed casting to return an `Iterable`.
    - Now, all of the tests are passing.
    - The `TODO`s still remain, as I'm not 100% sure it's the intended behavior.
1. Changes to `cast`ing for `L`, `S` and `M`.
    - Shouldn't `M` extend `Map`?