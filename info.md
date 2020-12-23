# Immutable Objects

Immutable objects are those that cannot be changed once created.

To create an immutable object **in Dart** you must follow these 5 rules:

1. Make all immutable fields final or private, so that they cannot be changed.

2. Make all mutable fields private, so that direct access is not allowed.

3. Create defensive copies of all mutable fields passed to the constructor, so that they cannot be
   changed from the outside.

4. Don’t provide any methods that give external access to internal mutable fields.

5. Don’t provide any methods that change any fields, except if you make absolutely sure those
   changes have no external effects (this may be useful for lazy initialization, caching and
   improving performance).

_Note:_ There should also be a 6th rule stating that the class should be `final` (in the Java sense)
, but in Dart it's impossible to prevent a class from being subclassed. The problem is that one can
always subclass an otherwise immutable class and then add mutable fields to it, as well as override
public methods to return changed values according to those mutable fields. This means that in Dart
it's impossible to create strictly immutable classes. However, you can make it as close as possible
to the real thing by at least not invoking overridable methods from the constructor (which in Dart
means not invoking public non-static methods).

<br>

Immutable objects have a very compelling list of positive qualities. Without question, they are
among the simplest and most robust kinds of classes you can possibly build. When you create
immutable classes, entire categories of problems simply disappear.

In Effective Java, Joshua Bloch makes this recommendation:

> Classes should be immutable unless there's a very good reason to make them mutable.
> If a class cannot be made immutable, limit its mutability as much as possible.

The reason for this is that mutability imposes no design constraints on developers, meaning they are
free to sculpt mutable imperative programs how they see fit. While mutability does not prevent us to
achieve good designs, it also doesn't guide us there like immutability does.

Mutable state increases the complexity of our applications. The more parts can change within a
component, the less sure we are of its state at any point in time, and the more unit tests we need
to write to be confident that it works. Once mutable components integrate with other mutable
components, we get a combinatorial effect on complexity, and an application that is challenging to
reason about and fully test.

Flutter's reactive model encourages you to think differently about how data flows through your
application. Of course, immutable objects are mandatory for some Flutter state management solutions
like Redux, and I have developed this package mainly to use it with my
own <a href="https://pub.dev/packages/async_redux">Async Redux</a>. But the co-author of the present
package, <a href="https://github.com/psygo">Philippe Fanaro</a> likes using Bloc with immutable
state. All state management solutions in Flutter can benefit from making your state immutable. Your
widgets subscribe to data objects throughout your application. If those objects are mutable, and if
your widgets mutate them, this creates opportunities for areas of your application to get out of
sync with each other. If those objects are immutable, since they can't change, subscribing to
changes throughout the model is a dead-end, and new data can only ever be passed from above.

<br>

## What's the difference between Unmodifiable and Immutable?

Doesn't <a href="https://api.dart.dev/stable/2.10.4/dart-core/List/List.unmodifiable.html">
List.unmodifiable()</a>
create an immutable list?

It is a misconception that immutability is just the absence of something: Take a list, remove the
mutating code, and you've got an immutable list. But that's not how this works. If we simply remove
mutating methods from `List`, we end up with a list that is read-only. Or, as we can call it, an **
unmodifiable list**. It can still change under you, it's just that you won't be the one changing it.
Immutability, as a feature, is not an absence of mutation, it's a **guarantee**
that there won't be mutation. A feature isn't necessarily something you can use to do good, it may
also be the promise that something bad won't happen.

In Dart's `List.unmodifiable()` case, it actually
<a href="https://stackoverflow.com/questions/50311900/in-dart-does-list-unmodifiable-create-an-unmodifiable-view-or-a-whole-new-in">
creates a defensive copy</a>, so the resulting list is in fact immutable. However, it does have the
mutating methods, only that they will throw an error if used.

If you pass around an **unmodifiable list**, other code that accepts a `List` can't assume it's
immutable. There are now, in fact, more ways to fail, because calling any mutating method of an
unmodifiable list will throw an error. So it makes it harder to reason about the code, not easier.
For clean-code reasons what is needed is a **different type**, one that guarantees the object can't
be mutated. That's why `IList` does not extend `List`.

## Clean-code

Late in the evening, exhausted and frustrated you find out that the people who implemented

```
int computeLength(Map<String, dynamic> responseMap)
```

got the great idea, that instead of just computing the response length, they also
mutated `responseMap` in some tricky way (say, doing some kind of sanitization of `responseMap`).
Even if this is mentioned in the documentation and even if the method name was different, that's
spaghetti code.

On the contrary, when you pass an immutable object to a method, you know the method can't modify it.
This makes it much easier to reason about your code. By using an `IMap`:

```
int computeLength(IMap<String, dynamic> responseMap)
```

Now, both the caller and the callee know the `responseMap` won't be changed. Reasoning about code is
simpler when the underlying data does not change. It also serves as documentation: if a method takes
an immutable collection interface, you know it isn't going to modify that collection. If a method
returns an immutable collection, you know you can't modify it.

A more subtle clean-code benefit is what Joshua Bloch calls "failure atomicity". If an immutable
object throws an exception, it's never left in an undesirable or indeterminate state. That's why
some
people <a href="https://stackoverflow.com/questions/1736146/why-is-exception-handling-bad#:~:text=Exceptions%20are%20not%20bad%20per,for%20control%20of%20program%20flow">
consider exception handling harmful</a>, and immutable objects solve this problem for free. They
have their class invariant established once upon construction, and it never needs to be checked
again.

<br>

# Performance and Memory Savings

Let's start off by stating the obvious. Most mutable collection operations are generally faster than
their immutable counterparts. That's a basic fact of life. Consider a hash table for example. A
mutable hash map can simply replace a value in an internal array in response to an `add()` call,
while an immutable one has to create a number of new objects to build a new version of the map
reflecting the change.

So, yes, mutable collections are generally faster. But sometimes they can be slower. A few examples:

* Suppose you have an array-list with a million items, and you want to add an extra item to its
  start. The array-list maintains a single large array of values, so whenever inserts and deletes
  are done in the middle of the array, values have to be shifted left or right. In contrast, an
  immutable list may just record the change that some item should be considered to be at index `0`.
  Unlike the array-list, the immutable list doesn't have any preference for where values are added.
  Inserting a value in the middle of it is no more expensive than inserting one at the beginning or
  end.

* Another notable example is doing a "deep copy". If you want to deep copy (or clone) a regular
  List, you have to copy all its item references. However, for an immutable list a deep copy is
  instantaneous, because you actually don't need to copy anything. You just have to pass a reference
  to the original list. It's like doing deep copy in O(1). Also, because a reference is much smaller
  than the object itself, you'll save memory if you need to keep many references to an immutable
  collection instead of keeping many defensive copies in memory.

* Yet another example is comparing two collections. Comparing with **value equality** may require
  considering every item in each collection, on an O(N) time complexity. For large collections of
  values, this could become a costly operation, though if the two are not equal and hardly similar,
  the inequality is determined very quickly. In contrast, when comparing two collections with **
  reference equality**, only the references to memory need to be compared, which has an O(1) time
  complexity.

  In Flutter, as soon as you pass a collection of objects, typically a `List<Widget>`, to some
  widget, conceptually you are giving up write ownership to that list. In other words, you should
  consider the list read-only. It is a common mistake to pass a list, mutate it, then expect Flutter
  to update the UI correctly. Nothing in the type system of collections prevents this mistake, and
  it is a very natural one to make when you are coming from a non-functional world.

  Think about it: Suppose you have a list with a million widgets and you pass it to a `ListView` to
  display it on screen. If you add some widget to the middle of it, how is Flutter supposed to know
  about it and rebuild the `ListView`? If Flutter was simply repainting the list for every frame, it
  would display any changes instantly. But in reality Flutter must know something changed before
  repainting, to save resources. So, again, if you pass a list and then mutate it, how is Flutter
  supposed to know it changed? If has a reference to the original list, now mutated. There is no way
  to know that the referenced list mutated since the last frame was displayed.

  By using mutable lists, Flutter only works if you create a new list:

   ```                               
   // This will not work. Wrong operation with mutable list:
   onTap: () {
      setState(() { list.add(newItem); });
   }
  
   // Correct but slow operation with mutable list:
   onTap: () {
      setState(() { list = List.of(list)..add(newItem); });
   }   
  
   // Correct and fast operation with immutable list:
   onTap: () {
      setState(() { ilist = ilist.add(newItem); });
   }   
   ```

* When some code accepts a mutable list but needs to make sure it's not mutated, it must make a
  defensive copy. This requirement is quite common, and you may entertain the idea of all the code
  running on millions of computers all over the world, around the clock, making safety copies of
  collections that are being returned by functions, and then garbage-collecting them milliseconds
  after their creation. Using immutable collections this is not necessary.

* If you want to use collections as map keys, or add them to sets, you must be able to calculate
  their `hashCode`. If a collection is immutable, you can calculate its `hashCode` lazily and only
  if needed, and then cache it. Note: If a collection is mutable you can also cache its `hashCode`,
  but you must discard the cached value as soon as some mutating method is called. Also, once you
  have cached `hashCode`s you can use them to speed up equality comparisons, since (by
  the `hashCode`'s definition) two collections with different `hashCode`s are always different.

* In Flutter, when deciding if you should rebuild a widget or not, there are performance tradeoffs
  between value equality and identity equality. For example, if you use an immutable collection and
  it has not been mutated, then it is equal by identity (which is a very cheap comparison). On the
  other hand, when it's not equal by identity this does not rule out the possibility that they may
  be value-equal. But in practice, when possible, fast_immutable_collections avoids creating new
  objects for updates where no change in value occurred. For this reason, if some state and its next
  state are immutable collections not equal by identity, they are almost certainly NOT value-equal,
  otherwise why would you have mutated the collection to begin with? If you are ok with doing some
  rare unnecessary rebuilds, you can decide whether or not to rebuild the widget without having to
  compare each item of the collections.

* Caching can speed things up significantly. But how do you cache results of a function?

  ```
  List findSuspiciousEntries(List<Map> entries)
  ```

  One possible workaround would be to JSONize entries to String and use such string as a hashing
  key. However, it's much more elegant, safe, performant and memory-wise with immutable structures.
  If the function parameters are all immutable and equal by identity (which is a very cheap
  comparison) you can return the cached value.

### The above text has about 10% of original content. The rest is shamelessly copied from the following pages. Please, visit them:

* <a href="https://en.wikipedia.org/wiki/Hash_array_mapped_trie">Hash array mapped trie</a>
* <a href="https://medium.com/dartlang/darts-built-collection-for-immutable-collections-db662f705eff">
  built_collection</a>
* <a href="https://github.com/immutable-js/immutable-js">immutable-js</a>
* <a href="https://hypirion.com/musings/understanding-persistent-vector-pt-1">Understanding
  Clojure's Persistent Vectors</a>
* <a href="https://github.com/vacuumlabs/persistent">Vacuumlabs: Efficient Persistent Data
  Structures</a>
* <a href="https://groups.google.com/g/guava-discuss/c/hfyhraawwUc?pli=1">Performance of immutable
  collections</a>
* <a href="http://www.javapractices.com/topic/TopicAction.do?Id=29">Java Practices: Immutable
  objects</a>
* <a href="https://softwareengineering.stackexchange.com/questions/221762/why-doesnt-java-8-include-immutable-collections">
  Why doesn't Java 8 include immutable collections?</a>
* <a href="https://medium.com/@johnmcclean/dysfunctional-programming-in-java-2-immutability-a2cff487c224">
  Dysfunctional programming in Java 2 : Immutability</a>
* <a href="https://medium.com/@johnmcclean/the-rise-and-rise-of-java-functional-data-structures-63782436f93b">
  Faster Purely Functional Data Structures for Java</a>
* <a href="https://github.com/andrewoma/dexx">Dexx Collections</a>
* <a href="https://github.com/GlenKPeterson/Paguro">Why Use Paguro?</a>
* <a href="https://github.com/brianburton/java-immutable-collections/wiki/Comparative-Performance">
  Java Immutable Collections: Comparative Performance</a>
* <a href="https://nipafx.dev/immutable-collections-in-java/">Immutable Collections In Java - Not
  Now, Not Ever</a>
* <a href="https://stackoverflow.com/questions/1736146/why-is-exception-handling-bad#:~:text=Exceptions%20are%20not%20bad%20per,for%20control%20of%20program%20flow">
  Why is exception handling bad?</a>
* <a href="https://github.com/dart-lang/language/issues/117">Dart-lang issue: Make it easy to create
  immutable collections via literals</a>

# Should I use mutable or immutable collections?

The performance differences discussed above are nearly always dwarfed by bigger concerns like I/O,
memory leaks, algorithms of the wrong big-O complexity, sheer coding errors, failure to properly
reuse data once obtained (using a cache) etc.

If you really do have an extremely CPU-intensive critical section of code, and it really has been
identified as one of your main performance bottlenecks, then if you want to decide if you should use
mutable or immutable collections, you want to do some real profiling of your own, which means
running your actual application in actual real-world usage. Unless you do that, and even when you do
it, it's difficult to decide, and effectively impossible to really know for sure. Immutable
collections might be faster than native mutable collections for you, but slower for someone else.
They might be good today and bad tomorrow. Even native code will execute on top of many layers of
abstraction that cause its performance to appear nondeterministic; with Dart, the situation is much
worse because it will also depend on the target platform.

In the old days, studying the performance of code was more like physics or chemistry. Y you could
perform controlled experiments and get predictable results. But nowadays, that stack of all those
various bits of genius that sit between your Dart code and the bare metal more closely resemble a
biological system. Asking whether code A or code B will run faster is similar to asking whether
patient A or patient B will have a heart attack tomorrow. If we were omniscient, it may be
theoretically possible to know this, but as it is, all the variables involved (which we can't always
control or even observe) can overwhelm our predictive capability.

Our benchmarks try to give a first approximation on the speed of our collections, but as discussed
those results may not be as meaningful to you under all circumstances. That said, we're trying to do
it anyway. One thing is for sure, though: In terms of architecture, immutability beats mutability
any day of the week. Even if few people will try to convince you to switch to the immutable
collections for the performance gains, the main reason to use them is readability, maintainability,
and general sanity. It will remove distractions and leave you more energy for creativity and
problem-solving. And for that you need a package, since it offers you a low-cost way: It's not
always easy to create immutable data structures by hand in a compact, maintainable way.

# How will this package die

In the 2.0 release, we optimized memory consumption such that the only penalty for using Persistent
comes at lower speed. Although structure sharing makes the whole thing much more effective than
naive copy-it-all approach, Persistents are still slower than their mutable counterparts
(note however, that on the other hand, some operations runs significantly faster, so it's hard to
say something conclusive here).

Following numbers illustrate, how much slow are Persistent data structures when benchmarking either
on DartVM or Dart2JS on Node
(the numbers are quite independent of the structure size):

DartVM read speed: 2 DartVM write speed: 12 (5 by using Transients)
Dart2JS read speed: 3 Dart2JS write speed: 14 (6 by using Transients)

Although the factors are quite big, the whole operation is still very fast and it probably won't be
THE bottleneck which would slow down your app.

All production releases undergo stress testing and pass all junit tests. Of course you should
evaluate the collections for yourself and perform your own tests before deploying the collections to
production systems.


-----

leading to much simpler application development, no defensive copying, and enabling advanced
memoization and change detection techniques with simple logic.

can be passed around without worrying about who might modify them.

A Dart `String` is a typical example of a commonly used immutable objects.

--

Concurrency — immutable collections can be shared safely across threads.

Wins of immutable collections:

With small collections, speed is not an issue.
