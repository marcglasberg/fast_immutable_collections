# Fast Immutable Collections

[![Dart || Tests | Formatting | Analyzer][github_ci_badge]][github_actions]

> **THIS IS VERY EARLY STAGE. DON'T USE IT.**

Immutable lists and other collections, which are as fast as their native Flutter mutable counterparts.


[github_actions]: https://github.com/marcglasberg/fast_immutable_collections/actions
[github_ci_badge]: https://github.com/marcglasberg/fast_immutable_collections/workflows/Dart%20%7C%7C%20Tests%20%7C%20Formatting%20%7C%20Analyzer/badge.svg?branch=master

## 1. Why?

<!-- TODO: Add motivation for this project and its use. -->

## 2. How?

### 2.1. The Implementation's Idea

Basically, behind the scenes, this is what happens when you pass a `List` to an `IList` &mdash; the other collection objects follow the same idea &mdash;:

1. A *new* copy of the object is made with `List.of`, so the original object won't be modified at all.
    1. When you add an element to the `IList`, it will be registered as an *immutable* property behind the scenes, and not `add`ed to the original `List`.
    1. When you add a collection of elements (`Iterable`) to the `IList`, it will also be registered as an *immutable* property, as a new copy of the `Iterable` if necessary to ensure the original won't be changed.

## 3. Resources & Documentation

The [`docs`][docs] folder features information which might be useful for you either as an end user or a developer:

| File                                                                                | Purpose                                                                                          |
| ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [`different_fixed_list_initializations.dart`][different_fixed_list_initializations] | Different ways of creating an *immutable* list in pure Dart and their underlying implementations |
| [`resources.md`][resources]                                                         | Resources for studying the topic of immutable collections                                        |
| [`uml.puml`][uml]                                                                   | The UML diagram for this package (Uses [PlantUML][plant_uml])                                    |


[docs]: docs/
[different_fixed_list_initializations]: docs/different_fixed_list_initializations.dart
[plant_uml]: https://plantuml.com/
[resources]: docs/resources.md
[uml]: docs/uml.puml