## 0.0.1

- Implementations of and tests for:
    - `IList`
    - `ISet`
    - `IMap`
    - `IMapOfSets`
    - (Un)Modifiable Views for each of the immutable collections.
        - These will help the user integrate his/her current code &mdash; which probably uses other collections &mdash; with this package.
    - Configuration classes for the different possible internal behaviors of the collections.
- Initial version of a [`benchmark`][benchmark_pkg] package for performance comparisons and improvements.
- Initial version of running the benchmarks inside Flutter ([`example`][benchmark_example]).


[benchmark_example]: benchmark/example
[benchmark_pkg]: benchmark/