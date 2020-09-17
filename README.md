# Fast Immutable Collections

![Dart || Tests | Formatting | Analyzer][github_ci_badge]

> **THIS IS VERY EARLY STAGE. DON'T USE IT**

Immutable lists and other collections, which are as fast as their native Flutter mutable counterparts.


[github_ci_badge]: https://github.com/marcglasberg/fast_immutable_collections/workflows/Dart%20%7C%7C%20Tests%20%7C%20Formatting%20%7C%20Analyzer/badge.svg?branch=master

## 1. Resources & Documentation

The `docs` folder features information which might be useful for you either as an end user or a developer:

| File                                        | Purpose                                                                                          |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| `different_fixed_list_initializations.dart` | Different ways of creating an *immutable* list in pure Dart and their underlying implementations |
| `how_to_create_a_benchmark.md`              | How to create a benchmark in the context of this project                                         |
| `resources.md`                              | Resources for studying the topic of immutable collections                                        |
| `uml.puml`                                  | The UML diagram for this package (Uses [PlantUML][plant_uml])                                    |


[plant_uml]: https://plantuml.com/

## 2. Example

This project features an `example` folder with a Flutter project where *release-mode* benchmarks will take place.