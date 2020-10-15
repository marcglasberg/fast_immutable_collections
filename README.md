# Fast Immutable Collections

[![Dart || Tests | Formatting | Analyzer][github_ci_badge]][github_actions]
[![codecov.io][codecov_badge]][codecov]

> **THIS IS VERY EARLY STAGE. DON'T USE IT.**

Immutable lists and other collections, which are as fast as their native Flutter mutable counterparts.


[codecov]: https://codecov.io/gh/marcglasberg/fast_immutable_collections/
[codecov_badge]: https://codecov.io/gh/marcglasberg/fast_immutable_collections/branch/master/graphs/badge.svg
[github_actions]: https://github.com/marcglasberg/fast_immutable_collections/actions
[github_ci_badge]: https://github.com/marcglasberg/fast_immutable_collections/workflows/Dart%20%7C%7C%20Tests%20%7C%20Formatting%20%7C%20Analyzer/badge.svg?branch=master

## 1. Why?

<!-- TODO: Add motivation for this project and its use. -->

### 1.1. Benchmarks Summary

<!-- TODO: Add summarized tables that, hopefully, quickly justify this package's existence.-->

### 1.2. The Motivation for the Different Equalities

Comparing for identity isn't always what you want. If the internals of two different objects are the same, they might be considered the same in the end. That's one of the reasons this package adds the `deepEquals` option, which lets you compare the internal setup of the collection.

Beware, thought, that, due to implementation details, comparing big collections will likely be slower for this package than other packages' implementations.

<!-- TODO: Complete. -->

### 1.3. The Motivation for the `IMapOfSets` Collection Class

<!-- TODO: Complete. -->

## 2. How?

### 2.1. How do I use it?

#### 2.1.1. `IList`

<!-- TODO: Complete. -->

#### 2.1.2. `ISet`

<!-- TODO: Complete. -->

#### 2.1.3. `IMap`

<!-- TODO: Complete. -->

#### 2.1.4. `IMapOfSets`

<!-- TODO: Complete. -->

### 2.2. The Implementation's Idea

Basically, behind the scenes, this is what happens when you pass a `List` to an `IList` &mdash; the other collection objects follow the same idea &mdash;:

1. A *new* copy of the object is made with `List.of`, so the original object won't be modified at all.
    1. When you add an element to the `IList`, it will be registered as an *immutable* property behind the scenes, and not `add`ed to the original `List`.
    1. When you add a collection of elements (`Iterable`) to the `IList`, it will also be registered as an *immutable* property, as a new copy of the `Iterable` if necessary to ensure the original won't be changed.

## 3. Other Resources & Documentation

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

## 4. For the Developer or Contributor

### 4.1. Formatting 

This project uses 100-character lines instead of the typical 80. If you're on VS Code, simply add this line to your `settings.json`:

```json
"dart.lineLength": 100,
```

If you're going to use the `dartfmt` CLI, you can add the `-l` option when formatting, e.g.:

```sh
dartfmt -l 100 -w . 
```

### 4.2. Micro Changelog

Since this package is quite big and even has inner packages, I think it would be easier on everyone if changes were summarized in some way. The [`CHANGELOG.md`][changelog] is usually used for this type annotations, however it contains a much more summarized view of the changes than what day to day routine looks like.

So that's why the [micro changelog][microchangelog] file was created. There you will find summarized comments on what changes were added on a daily basis, which will hopefully ease development.


[microchangelog]: docs/microchangelog.md