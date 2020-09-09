# Immutability Resources for Dart

> Resources for studying immutability in the context of OOP languages.

The numbering below is simply for differentiation.

> ~90% of the resources below come from Marcelo Glasberg.

## 0. How do I read this???

The sub, unordered lists are my highlights, it's probably simpler if you go through each of the links in the ordered lists.

## 1. Projects

### 1.1. Dart

1. [persistent][persistent_dart]
    - Dart
    - They've implemented *operators* for the objects, something which converges to the assumption that immutable objects should be treated just like values.
1. [Rémi Rousselet's Example of Performance Testing in Dart][remi_performance_testing_dart]
1. [kt.dart][kt_dart]
    - Features interesting annotations from Kotlin, though some will become useless after non-nullable integration to Dart.
    - Doesn't seem to use a recursive data structure in the background to ease copying, just simple iterators, but I would have to study it more to be sure.
    - Not that many worries about speed.
1. [built_collection][built_collection]
    - Each of the core SDK collections is split in two: a mutable builder class and an immutable "built" class. Builders are for computation, "built" classes are for safely sharing with no need to copy defensively.
    - Uses the [Builder Pattern][builder_pattern], which simplifies the creation of objects, and even allows for lazy optimizations.
    - Uses (deep) hash codes.
    - (...) do not make a copy, but return a copy-on-write wrapper.


[builder_pattern]: https://en.wikipedia.org/wiki/Builder_pattern
[built_collection]: https://github.com/google/built_collection.dart
[kt_dart]: https://github.com/passsy/kt.dart
[persistent_dart]: https://github.com/vacuumlabs/persistent
[remi_performance_testing_dart]: https://gist.github.com/rrousselGit/5a047bd4ec36515a4cfcc6bd275f05f5

### 1.2. Java

1. [Dexx][dexx]
    - Port of Scala's immutable, persistent collections to Java and Kotlin.
    - [Class Hierarchy][dexx_class_hierarchy]
    - Interesting feature: Explore annotating methods that return a new collection with `@CheckReturnValue` to allow static verification of collection usage.
1. [Paguro][paguro]
    - Immutable Collections and Functional Transformations for the JVM.
    - Inspired by Clojure.
    - Is based on the question-discussion &mdash; mentioned in the next section &mdash;: [Why doesn't Java 8 include immutable collections?][why_no_immutable_on_java_8]
1. Brian Burton's [Java Immutable Collections][java_immutable_collections]
    - [Comparative Performance of Java Immutable Collections][performance_java_immutable]
        - The real questions are: how much faster are mutable collections and will you really notice the difference. Based on benchmark runs a JImmutableHashMap is about 2-3 times slower than a HashMap but is about 1.5x faster than a TreeMap. Unless your application spends most of its time CPU bound updating collections you generally won't notice much of a difference using an immutable collection.
    - [List Tutorial][java_immutable_collections_list_tutorial]
        - The current implementation uses a balanced binary tree with leaf nodes containing up to 64 values each which provides `O(log2(n))` performance for all operations.


[dexx]: https://github.com/andrewoma/dexx
[dexx_class_hierarchy]: https://github.com/andrewoma/dexx/raw/master/docs/dexxcollections.png
[java_immutable_collections]: https://github.com/brianburton/java-immutable-collections
[java_immutable_collections_list_tutorial]: https://github.com/brianburton/java-immutable-collections/wiki/List-Tutorial
[paguro]: https://github.com/GlenKPeterson/Paguro
[performance_java_immutable]: https://github.com/brianburton/java-immutable-collections/wiki/Comparative-Performance

### 1.3. JS

1. [immutable-js][immutable_js]
    - Immutable data cannot be changed once created, leading to much simpler application development, no defensive copying, and enabling advanced memoization and change detection techniques with simple logic. Persistent data presents a mutative API which does not update the data in-place, but instead always yields new updated data.
    - Alan Kay: The last thing you wanted any programmer to do is mess with internal state even if presented figuratively. It is unfortunate that much of what is called "object-oriented programming" today is simply old style programming with fancier constructs.
        - [React.js Conf 2015 &ndash; Immutable Data and React][immutable_data_react_lecture]
    - These data structures are highly efficient on modern JavaScript VMs by using structural sharing via hash maps tries and vector tries as popularized by Clojure and Scala, minimizing the need to copy or cache data.
    - Immutable collections should be treated as *values* rather than *objects*. While objects represent some thing which could change over time, a value represents the state of that thing at a particular instance of time. This principle is most important to understanding the appropriate use of immutable data. In order to treat Immutable.js collections as values, it's important to use the `Immutable.is()` function or `.equals()` method to determine value equality instead of the `===` operator which determines object *reference identity*.
    - If an object is immutable, it can be "copied" simply by making another reference to it instead of copying the entire object. Because a reference is much smaller than the object itself, this results in memory savings and a potential boost in execution speed for programs which rely on copies (such as an undo-stack).


[immutable_data_react_lecture]: https://youtu.be/I7IdS-PbEgI
[immutable_js]: https://github.com/immutable-js/immutable-js

## 2. Articles

1. [Discussion on the Performance of Immutable Collections][performance_discussion]
    - Kevin Bourrillion: "Raw CPU speed?  To a first order of approximation, the performance is the same.  Heck, to a second order of approximation, it's the same, too.  These kinds of performance differences are nearly always absolutely dwarfed by bigger concerns &mdash; I/O, lock contention, memory leaks, algorithms of the wrong big-O complexity, sheer coding errors, failure to properly reuse data once obtained (which may be solved by "caching" or simply by structuring the code better), etc. etc. etc."
    - If you measure your isolated component and it performs better than competitors, then it is better in isolation. If it doesn't perform as expected in the system, it's because its design doesn't fit, the specifications are probably wrong.
        - Systems are bigger than the sum of its components, but they are finite and can have their external interactions abstracted away.
            - So I kind of disagree with Bourrillion's answer.
1. [Why doesn't Java 8 include immutable collections?][why_no_immutable_on_java_8]
    - [The difference between *readable*, *read-only* and *immutable* collections][3_types_of_collections].
    - Basically, the `UnmodifiableListMixin` also exists in Java. For more, check [Arkanon's answer][arkanon_answer].
    - I enjoy entertaining the idea that of all the code written in java and running on millions of computers all over the world, every day, around the clock, about half the total clock cycles must be wasted doing nothing but making safety copies of collections that are being returned by functions. (And garbage-collecting these collections milliseconds after their creation.)
        - From [Mike Nakis' answer][mike_nakis_answer].
        - Now, an interface like Collection which would be missing the `add()`, `remove()` and `clear()` methods would not be an `ImmutableCollection` interface; it would be an `UnmodifiableCollection` interface. As a matter of fact, there could never be an `ImmutableCollection` interface, because immutability is a nature of an implementation, not a characteristic of an interface. I know, that's not very clear; let me explain.
    - [Ben Rayfield on recursiveness][ben_rayfield_recursiveness]
1. [MarcG's question on the behavior of `List.unmodifiable`][marcelo_list_unmodifiable]
    - `List.unmodifiable` does create a new list. And it's `O(N)`.
1. [Immutable Collections In Java &ndash; Not Now, Not Ever][immutable_collections_java_not_now_not_ever]
    - Originally, unmodifiable marked an instance that offered no mutability (by throwing UnsupportedOperationException on mutating methods) but may be changed in other ways (maybe because it was just a wrapper around a mutable collection).
    - An immutable collection of secret agents might sound an awful lot like an immutable collection of immutable secret agents, but the two are not the same. The immutable collection may not be editable by adding/removing/clearing/etc, but, if secrets agents are mutable (although the lack of character development in spy movies seems to suggest otherwise), that doesn’t mean the collection of agents as a whole is immutable.
    - *Immutability is not an absence of mutation, it’s a guarantee there won’t be mutation*.
    - Converting old code to a new immutability hierarchy may be source-incompatible.
1. [Faster Purely Functional Data Structures for Java][faster_java_functional_data_structures]
    - Use unifying interfaces for more flexibility with respect to implementations.
    - Laziness in copying is key to performance.
    - *Persistent collections are immutable collections with efficient copy-on-write operations.*
    - [Chris Osaki's thesis on *Purely Functional Data Structures*][osaki_thesis]
    - [Extreme Cleverness: Functional Data Structures in Scala - Daniel Spiewak][spiewak_lecture]
    - [Clojure Data Structures Part 1 - Rich Hickey][hickey_lecture]
1. [How can List be faster than native arrays?][how_can_lists_be_faster_than_arrays]
    - Structural sharing makes an immutable list be faster than a native array in JS.
    - `List` is an implementation of an immutable data-structure called relaxed *radix balanced trees*.
    - Not all operations are faster...
    - [`List` on Github][list_github]


[3_types_of_collections]: https://softwareengineering.stackexchange.com/a/222052/344810
[arkanon_answer]: https://softwareengineering.stackexchange.com/a/222323/344810
[ben_rayfield_recursiveness]: https://softwareengineering.stackexchange.com/a/330179/344810
[faster_java_functional_data_structures]: https://medium.com/@johnmcclean/the-rise-and-rise-of-java-functional-data-structures-63782436f93b
[hickey_lecture]: https://youtu.be/ketJlzX-254
[how_can_lists_be_faster_than_arrays]: http://vindum.io/blog/how-can-list-be-faster-than-native-arrays/
[immutable_collections_java_not_now_not_ever]: http://blog.codefx.org/java/immutable-collections-in-java/
[list_github]: https://github.com/funkia/list
[marcelo_list_unmodifiable]: https://stackoverflow.com/q/50311900/4756173
[mike_nakis_answer]: https://softwareengineering.stackexchange.com/a/285839/344810
[osaki_thesis]: https://www.cs.cmu.edu/~rwh/theses/okasaki.pdf
[performance_discussion]: https://groups.google.com/g/guava-discuss/c/hfyhraawwUc?pli=1
[spiewak_lecture]: https://youtu.be/pNhBQJN44YQ
[why_no_immutable_on_java_8]: https://softwareengineering.stackexchange.com/q/221762/344810

## 3. Other Resources

1. [Is Dart Compiled or Interpreted?][dart_compiled_or_interpreted]
    - Both.
1. [Introduction to Dart VM][intro_dart_vm]
1. [What does `external` mean in Dart?][external_in_dart]
    - Basically that the method is implemented elsewhere, probably by a subclass. It's kind of like an abstract method outside an abstract class.


[dart_compiled_or_interpreted]: https://www.quora.com/Is-Dart-a-compiled-or-interpreted-language
[external_in_dart]: https://stackoverflow.com/q/24929659/4756173
[intro_dart_vm]: https://mrale.ph/dartvm/