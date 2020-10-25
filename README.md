# Fast Immutable Collections

[![Dart || Tests | Formatting | Analyzer][github_ci_badge]][github_actions]
[![codecov.io][codecov_badge]][codecov]

> **THIS IS UNDER ACTIVE DEVELOPMENT. DON'T USE IT.**

> **THIS IS UNDER ACTIVE DEVELOPMENT. DON'T USE IT.**

> **THIS IS UNDER ACTIVE DEVELOPMENT. DON'T USE IT.**

[codecov]: https://codecov.io/gh/marcglasberg/fast_immutable_collections/
[codecov_badge]: https://codecov.io/gh/marcglasberg/fast_immutable_collections/branch/master/graphs/badge.svg
[github_actions]: https://github.com/marcglasberg/fast_immutable_collections/actions
[github_ci_badge]: https://github.com/marcglasberg/fast_immutable_collections/workflows/Dart%20%7C%7C%20Tests%20%7C%20Formatting%20%7C%20Analyzer/badge.svg?branch=master

# Introduction

This package provides:
 * `IList` is an immutable list
 * `ISet` is an immutable set
 * `IMap` is an immutable map
 * `IMapOfSets` is an immutable map of sets

**Fast Immutable Collections** is a competitor to the excellent
<a href="https://pub.dev/packages/built_collection">built_collection</a> and 
<a href="https://pub.dev/packages/kt_dart">kt_dart</a> packages, 
but it's much **easier** to use than the former, 
and orders of magnitude **faster** than the latter.

The reason it's easier than built_collection is that there is no need for mutable/immutable cycles.
You just create your immutable collections and use them directly. 

The reason it's faster than kt_dart is that it creates immutable collections by 
internally saving only the difference between each collection, 
instead of copying the whole collection each time.
This is transparent to the developer, 
which doesn't need to know about these implementation details. 
Later in this document, we provide benchmarks so that you can compare speeds
(and you can also run the benchmarks yourself).

<br>

## IList

An `IList` is an immutable list, meaning once it's created it cannot be modified. 
You can create an `IList` by passing an iterable to its constructor, 
or you can simply "lock" a regular list. 
Other iterables (which are not lists) can also be locked as lists:  

```dart          
/// Ways to build an IList

// Using the IList constructor                                                                      
IList<String> ilist = IList([1, 2]);
                              
// Locking a regular list
IList<String> ilist = [1, 2].lock;
                          
// Locking a set as list
IList<String> ilist = {1, 2}.lockAsList;
```                                                                           

To create a regular `List` from an `IList`,
you can use `List.of`, or simply "unlock" an immutable list:

```dart  
/// Going back from IList to List
                 
var ilist = [1, 2].lock;
                                    
// Using List.of                                  
List<String> list = List.of(ilist);                               
                                  
// Is the same as unlocking the IList
List<String> list = ilist.unlock; 
```                                                                           

An `IList` is an `Iterable`, so you can iterate over it:

```dart  
var ilist = [1, 2, 3, 4].lock;
                                                            
// Prints 1 2 3 4
for (int value in ilist) print(value);  
```                                                                           

`IList` methods always return a new `IList`, instead of modifying the original one. 
For example:

```dart                                     
var ilist1 = [1, 2].lock;
                                                  
// Results in: 1, 2, 3
var ilist2 = ilist1.add(3);
                                             
// Results in: 1, 3
var ilist3 = ilist2.remove(2);             
               
// Still: 1, 2
print(ilist1); 
```   

Because of that, you can easily chain methods:

```dart                                     
// Results in: 1, 3, 4.
var ilist = [1, 2, 3].lock.add(4).remove(2);
```   

Since `IList` methods always return a new `IList`, 
it is an **error** to call some method and then discard the result: 

```dart                                     
var ilist = [1, 2].lock;
                                                  
// Wrong.
ilist.add(3);              
print(ilist); // 1, 2

// Also wrong.
ilist = ilist..add(3);              
print(ilist); // 1, 2

// Right!
ilist = ilist.add(3);              
print(ilist); // 1, 2, 3                        
```   

`IList` has **all** the methods of `List`,
plus some other new and useful ones.
However, `IList` methods always return a new `IList`, 
instead of modifying the original list or returning iterables. 

For example:

```dart                                     
IList<int> ilist = ['Bob', 'Alice', 'Dominic', 'Carl'].lock   
   .sort() // Alice, Bob, Carl, Dominic
   .map((name) => name.length) // 5, 3, 4, 7
   .take(3) // 5, 3, 4   
   .sort(); // 3, 4, 5
   .toggle(4) // 3, 5
   .toggle(2) // 3, 5, 2
```   
                                                                        
### IList Equality 
   
By default, `IList`s are equal if they have the same items in the same order.

```dart                                     
var ilist1 = [1, 2, 3].lock;
var ilist2 = [1, 2, 3].lock;

print(ilist1 == ilist2); // True!
```                                                                          

This is in sharp contrast to regular `List`s, which are compared by identity:

```dart                                     
var list1 = [1, 2, 3];
var list2 = [1, 2, 3];
                      
// Regular Lists compare by identity:
print(list1 == list2); // False!

// While ILists compare by deep equals:
print(list1.lock == list2.lock); // True!
```                                                                          

This also means `ILists` can be used as **map keys**, 
which is a very useful property in itself, 
but can also help when implementing some other interesting data structures.
For example, to implement **caches**:      

```dart                                     
Map<IList, int> sumResult = {};

String getSum(int a, int b) {
   var keys = [a, b].lock;
   var sum = sumResult[keys];
   if (sum != null) {
     return "Got from cache: $a + $b = $sum";
   } else {
     sum = a + b;
     sumResult[keys] = sum;
     return "Newly calculated: $a + $b = $sum";
   }
}

print(getSum(5, 3)); // Newly calculated: 5 + 3 = 8
print(getSum(8, 9)); // Newly calculated: 8 + 9 = 17                     
print(getSum(5, 3)); // Got from cache: 5 + 3 = 8
```    

However, `IList`s are configurable, and you can actually create `IList`s which
compare their internals by identity or deep equals, as desired.
There are 3 main ways to do achieve:
 
1) You can use getters `withIdentityEquals` and `withDeepEquals`:

    ```dart                    
    var ilist = [1, 2].lock;
    
    var ilist1 = [1, 2].lock;              // By default use deep equals.
    var ilist2 = ilist.withIdentityEquals; // Change it to identity equals.
    var ilist3 = ilist2.withDeepEquals;    // Change it back to deep equals.
    
    print(ilist == ilist1); // True!
    print(ilist == ilist2); // False!
    print(ilist == ilist3); // True!
    ```

2) You can also use the `withConfig` method to change the configuration:
 
    ```dart
    var list = [1, 2];
    var ilist1 = list.lock.withConfig(ConfigList(isDeepEquals: true));
    var ilist2 = list.lock.withConfig(ConfigList(isDeepEquals: false));
    
    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
    ```

3) Or you can use the `withConfig` constructor to
explicitly create the `IList` with your desired configuration:

    ```dart
    var list = [1, 2];
    var ilist1 = IList.withConfig(list, ConfigList(isDeepEquals: true));
    var ilist2 = IList.withConfig(list, ConfigList(isDeepEquals: false));
    
    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
    ```

The above described configurations affects how the `== operator` works, 
but you can also choose how to compare lists by using the following `IList` methods:

* `equalItems` will return true only if the IList items are equal to the iterable items,
  and in the same order. This may be slow for very large lists, since it compares each item,
  one by one. You can compare the list with ordered sets, but unordered sets will throw an error.

* `unorderedEqualItems` will return true only if the IList and the iterable items have the same number of elements,
and the elements of the IList can be paired with the elements of the iterable, so that each
pair is equal. This may be slow for very large lists, since it compares each item,
one by one.

* `equalItemsAndConfig` will return true only if the list items are equal and in the same order,
and the list configurations are equal. This may be slow for very large lists, since it compares each item, one by one.

* `same` will return true only if the lists internals are the same instances
(comparing by identity). This will be fast even for very large lists,
since it doesn't compare each item.
Note: This is not the same as `identical(list1, list2)` since it doesn't
compare the lists themselves, but their internal state. Comparing the
internal state is better, because it will return `true` more often.
  
### Global IList Configuration

### Usage in tests

### IList reuse by composition

### Flushing the IList

### Advanced usage


***************************************
***************************************
***************************************

## 1. Why Immutable Collections (and immutable objects in general) are useful?

<!-- TODO: Add motivation for this project and its use. -->

## 2. Benchmarks Summary

<!-- TODO: Add summarized tables that, hopefully, quickly justify this package's existence.-->

## 3. The Motivation for the `IMapOfSets` Collection Class

<!-- TODO: Complete. -->

## 4. The Implementation's Idea

Basically, behind the scenes, this is what happens when you pass a `List` to an `IList`, 
the other collection objects follow the same idea:

1. A *new* copy of the object is made with `List.of`, so the original object won't be modified at all.
    1. When you add an element to the `IList`, it will be registered as an *immutable* property behind the scenes, and not `add`ed to the original `List`.
    1. When you add a collection of elements (`Iterable`) to the `IList`, it will also be registered as an *immutable* property, as a new copy of the `Iterable` if necessary to ensure the original won't be changed.

## 5. Other Resources & Documentation

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

## 6. For the Developer or Contributor

### 6.1. Formatting 

This project uses 100-character lines instead of the typical 80. If you're on VS Code, simply add this line to your `settings.json`:

```json
"dart.lineLength": 100,
```

If you're going to use the `dartfmt` CLI, you can add the `-l` option when formatting, e.g.:

```sh
dartfmt -l 100 -w . 
```
