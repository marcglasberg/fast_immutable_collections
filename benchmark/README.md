# Benchmarks for the `Fast Immutable Collections` Package

[![GIF][gif]][example]

This is a separate package for the benchmarking of the [`fast_immutable_collections`][fast_immutable_collections] package.

Note that there are no tests (TDD), but the code is simple enough and just a simple client on the overarching project. Use the [`example`][example] project to run the benchmarks on a mobile device, preferably on `release` mode.


[example]: example/
[fast_immutable_collections]: ../

# 1. Resources and Documentation

| File                                                        | Purpose                                                       |
| ----------------------------------------------------------- | ------------------------------------------------------------- |
| [`how_to_create_a_benchmark.md`][how_to_create_a_benchmark] | How to create a benchmark in the context of this project      |
| [`benchmarks_specifications.md`][benchmarks_specifications] | Summarized specifications of the benchmarks                   |
| [`uml.puml`][uml]                                           | The UML diagram for this package (Uses [PlantUML][plant_uml]) |


[benchmarks_specifications]: docs/benchmarks_specifications.md
[example]: example/
[gif]: assets/demo.gif
[how_to_create_a_benchmark]: docs/how_to_create_a_benchmark.md
[plant_uml]: https://plantuml.com/
[uml]: docs/uml.puml