# Benchmarks for the `Fast Immutable Collections` Package

[![GIF][gif]][benchmark_app]

This is a separate package for the benchmarking of the [`fast_immutable_collections`][fast_immutable_collections] package.

This package uses TDD to check the results of the benchmarks, and the [benchmark_harness][benchmark_harness] package to create the benchmarks. There's additional code in the [`utils`][utils] folder, and you could add more benchmarks by checking examples in the [cases][cases] folder.


[benchmark_app]: benchmark_app/
[cases]: lib/src/cases/
[gif]: assets/demo.gif
[fast_immutable_collections]: ../
[utils]: lib/src/utils/