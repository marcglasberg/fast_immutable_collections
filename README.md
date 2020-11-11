# 1. Fast Immutable Collections

[![Dart || Tests | Formatting | Analyzer][github_ci_badge]][github_actions]
[![codecov.io][codecov_badge]][codecov]

> **THIS IS UNDER ACTIVE DEVELOPMENT. DON'T USE IT.**

> **THIS IS UNDER ACTIVE DEVELOPMENT. DON'T USE IT.**

> **THIS IS UNDER ACTIVE DEVELOPMENT. DON'T USE IT.**


[codecov]: https://codecov.io/gh/marcglasberg/fast_immutable_collections/
[codecov_badge]: https://codecov.io/gh/marcglasberg/fast_immutable_collections/branch/master/graphs/badge.svg
[github_actions]: https://github.com/marcglasberg/fast_immutable_collections/actions
[github_ci_badge]: https://github.com/marcglasberg/fast_immutable_collections/workflows/Dart%20%7C%7C%20Tests%20%7C%20Formatting%20%7C%20Analyzer/badge.svg?branch=master

# 2. Introduction

This package provides:

- `IList`, an immutable list
- `ISet`, an immutable set
- `IMap`, an immutable map
- `IMapOfSets`, an immutable map of sets

Other valuable features are:

- Extensions to the typical collections &mdash; `List`, `Set`, `Map` &mdash; so you can easily transform a mutable object into an immutable one (`.lock`).
- Global configurations for altering, locking, etc. your immutable collections.
- Mixins for you to build your own immutable collections or objects.
- Collection views so you can work with immutable objects as if they were the mutable ones.
- Native deep equalities, which create a more friendly of treating your objects as value objects.

**Fast Immutable Collections** is a competitor to the excellent
[built_collection][built_collection] and [kt_dart][kt_dart] packages, 
but it's much **easier** to use than the former, 
and orders of magnitude **faster** than the latter.

The reason it's **easier** than [built_collection][built_collection] is that there is no need for mutable/immutable cycles.
You just create your immutable collections and use them directly. 

The reason it's **faster** than [kt_dart][kt_dart] is that it creates immutable collections by 
internally saving only the difference between each collection, 
instead of copying the whole collection each time.
This is transparent to the developer, which doesn't need to know about these implementation details. 
Later in this document, we provide benchmarks so that you can compare speeds
(and you can also run the benchmarks yourself).


[built_collection]: https://pub.dev/packages/built_collection
[kt_dart]: https://pub.dev/packages/kt_dart


<br />


<!-- Using this extension in VS Code: https://marketplace.visualstudio.com/items?itemName=AlanWalk.markdown-toc -->
<!-- TOC depthFrom:2 orderedList:true updateOnSave:false -->

- [1. Fast Immutable Collections](#1-fast-immutable-collections)
- [2. Introduction](#2-introduction)
- [3. IList](#3-ilist)
    - [3.1. IList Equality](#31-ilist-equality)
    - [3.2. Global IList Configuration](#32-global-ilist-configuration)
    - [3.3. Usage in tests](#33-usage-in-tests)
    - [3.4. IList reuse by composition](#34-ilist-reuse-by-composition)
    - [3.5. Advanced usage](#35-advanced-usage)
- [4. ISet](#4-iset)
    - [4.1. Similarities and Differences to the IList](#41-similarities-and-differences-to-the-ilist)
    - [4.2. Global ISet Configuration](#42-global-iset-configuration)
- [5. IMap](#5-imap)
    - [5.1. Similarities and Differences to the IList/ISet](#51-similarities-and-differences-to-the-ilistiset)
    - [5.2. Global IMap Configuration](#52-global-imap-configuration)
- [6. IMapOfSets](#6-imapofsets)
- [7. Comparators](#7-comparators)
    - [7.1. CompareObject function](#71-compareobject-function)
    - [7.2. CompareObjectTo extension](#72-compareobjectto-extension)
    - [7.3. SortBy function](#73-sortby-function)
    - [7.4. SortLike function](#74-sortlike-function)
    - [7.5. if0 extension](#75-if0-extension)
    - [7.6. Flushing](#76-flushing)
    - [7.7. Auto-flush](#77-auto-flush)
        - [7.7.1. Sync Auto-flush](#771-sync-auto-flush)
        - [7.7.2. Async Auto-flush](#772-async-auto-flush)
    - [7.8. Why Immutable Collections (and immutable objects in general) are useful?](#78-why-immutable-collections-and-immutable-objects-in-general-are-useful)
    - [7.9. Benchmarks Summary](#79-benchmarks-summary)
    - [7.10. The Motivation for the `IMapOfSets` Collection Class](#710-the-motivation-for-the-imapofsets-collection-class)
    - [7.11. The Implementation's Idea](#711-the-implementations-idea)
    - [7.12. Other Resources & Documentation](#712-other-resources--documentation)
    - [7.13. For the Developer or Contributor](#713-for-the-developer-or-contributor)
        - [7.13.1. Formatting](#7131-formatting)

<!-- /TOC -->


# 3. IList

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
                                                  
// Wrong
ilist.add(3);              
print(ilist); // 1, 2

// Also wrong
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

IList constructors:

`IList()`,
`IList.withConfig()`,
`IList.fromISet()`,
`IList.unsafe()`.

IList methods and getters:

`empty`,
`withConfig`,
`withIdentityEquals`,
`withDeepEquals`,
`withConfigFrom`,
`isDeepEquals`,
`isIdentityEquals`,
`unlock`,
`unlockView`,
`unlockLazy`,
`unorderedEqualItems`,
`flush`,
`isFlushed`,
`add`,
`addAll`,
`remove`,
`removeAll`,
`removeMany`,
`removeNulls`,
`removeDuplicates`,
`removeNullsAndDuplicates`,
`toggle`,
`[]`,
`+`,
`firstOrNull`,
`lastOrNull`,
`singleOrNull`,
`firstOr`,
`lastOr`,
`singleOr`,
`maxLength`,
`sort`,
`sortLike`,
`asMap`,
`clear`,
`indexOf`,
`put`,
`replaceFirst`,
`replaceAll`,
`replaceFirstWhere`,
`replaceAllWhere`,
`process`,
`indexWhere`,
`lastIndexOf`,
`lastIndexWhere`,
`replaceRange`,
`fillRange`,
`getRange`,
`sublist`,
`insert`,
`insertAll`,
`removeAt`,
`removeLast`,
`removeRange`,
`removeWhere`,
`retainWhere`,
`reversed`,
`setAll`,
`setRange`,
`shuffle`.
                                                                        
## 3.1. IList Equality 
   
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

This also means `IList`s can be used as **map keys**, 
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
 
1. You can use getters `withIdentityEquals` and `withDeepEquals`:

    ```dart                    
    var ilist = [1, 2].lock;
    
    var ilist1 = [1, 2].lock;              // By default use deep equals.
    var ilist2 = ilist.withIdentityEquals; // Change it to identity equals.
    var ilist3 = ilist2.withDeepEquals;    // Change it back to deep equals.
    
    print(ilist == ilist1); // True!
    print(ilist == ilist2); // False!
    print(ilist == ilist3); // True!
    ```

1. You can also use the `withConfig` method 
and the `ConfigList` class to change the configuration:

    ```dart
    var list = [1, 2];
    var ilist1 = list.lock.withConfig(ConfigList(isDeepEquals: true));
    var ilist2 = list.lock.withConfig(ConfigList(isDeepEquals: false));
    
    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
    ```

1. Or you can use the `withConfig` constructor to
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

- `equalItems` will return true only if the IList items are equal to the iterable items,
  and in the same order. This may be slow for very large lists, since it compares each item,
  one by one. You can compare the list with ordered sets, but unordered sets will throw an error.
- `unorderedEqualItems` will return true only if the IList and the iterable items have the same number of elements,
and the elements of the IList can be paired with the elements of the iterable, so that each
pair is equal. This may be slow for very large lists, since it compares each item,
one by one.
- `equalItemsAndConfig` will return true only if the list items are equal and in the same order,
and the list configurations are equal. This may be slow for very large lists, since it compares each item, one by one.
- `same` will return true only if the lists internals are the same instances
(comparing by identity). This will be fast even for very large lists,
since it doesn't compare each item.
Note: This is not the same as `identical(list1, list2)` since it doesn't
compare the lists themselves, but their internal state. Comparing the
internal state is better, because it will return `true` more often.
  
## 3.2. Global IList Configuration

As explained above, the **default** configuration of the `IList` is that it compares by 
deep equality: They are equal if they have the same items in the same order.

You can globally change this default if you want, by using the `defaultConfig` setter:

```dart
var list = [1, 2];

/// The default is deep-equals.
var ilistA1 = IList(list);
var ilistA2 = IList(list);
print(ilistA1 == ilistA2); // True!

/// Now we change the default to identity-equals. 
/// This will affect lists created from now on.
defaultConfig = ConfigList(isDeepEquals: false);
var ilistB1 = IList(list);
var ilistB2 = IList(list);
print(ilistB1 == ilistB2); // False!

/// Configuration changes don't affect existing lists.
print(ilistA1 == ilistA2); // True!
```                                                                        

**Important Note:** 

The global configuration is meant to be decided during your app's initialization, and then not changed again.
We strongly suggest that you prohibit further changes to the global configuration by calling `lockConfig();`
after you set your desired configuration.


## 3.3. Usage in tests

An `IList` is not a `List`, so this is false:

```dart
[1, 2] == [1, 2].lock // False!
```

However, when you are writing tests, 
the `expect` method actually compares all `Iterables` by comparing their items.
Since `List` and `IList` are iterables, you can write the following tests: 

```dart                                 
/// All these tests pass:

expect([1, 2], [1, 2]); // List with List, same order.
expect([1, 2].lock, [1, 2]); // IList with List, same order.
expect([1, 2], [1, 2].lock); // List with IList, same order.
expect([1, 2].lock, [1, 2].lock); // IList with IList, same order.

expect([2, 1], isNot([1, 2])); // List with List, wrong order.
expect([2, 1].lock, isNot([1, 2])); // IList with List, wrong order.
expect([2, 1], isNot([1, 2].lock)); // List with IList, wrong order.
expect([2, 1].lock, isNot([1, 2].lock)); // IList with IList, wrong order.
```                   

So, for comparing `List` with `IList` and vice-versa this is fine.

However, `expect` treats `Set`s differently, resulting that 
`expect(a, b)` may be different from `expect(b, a)`. For example:

```dart
expect([1, 2], {2, 1}); // This test passes.
expect({2, 1}, [1, 2]); // This test does NOT pass.
```                                               

If you ask me, this is all very confusing. 
A good rule of thumb to avoid all these `expect` complexities 
is only comparing lists with lists, set with sets, etc.

## 3.4. IList reuse by composition

Classes `IListMixin` and `IterableIListMixin` let you easily 
create your own immutable classes based on the `IList`.
This helps you create more strongly typed collections, 
and add your own methods to them.

For example, suppose you have some `Student` class:

```dart
class Student {
   final String name;

   Student(this.name);

   String toString() => name; 

   bool operator ==(Object other) => identical(this, other) || other is Student && runtimeType == other.runtimeType && name == other.name;  

   int get hashCode => name.hashCode;
}
```

And suppose you want to create a `Students` class 
which is an immutable collection of `Student`s. 

You can easily implement it using the `IListMixin`:

```dart  
class Students with IListMixin<Student, Students> {

   /// This is the boilerplate to create the collection:
   final IList<Student> _students;

   Students([Iterable<Student> students]) : _students = IList(students);

   Students newInstance(IList<Student> iList) => Students(iList);

   IList<Student> get iList => _students;   
                                                        
   /// And then you can add your own specific methods:
   String greetings() => "Hello ${_students.join(", ")}.";
}
```    

And then use the class:

```dart  
var james = Student("James");
var sara = Student("Sara");
var lucy = Student("Lucy");
              
// Most IList methods are available:
var students = Students().add(james).addAll([sara, lucy]);

expect(students, [james, sara, lucy]);
                             
// Prints: "Hello James, Sara, Lucy."
print(students.greetings()); 
```   


## 3.5. Advanced usage

There are a few ways to lock and unlock a list, 
which will have different results in speed and safety.

```dart
IList<int> ilist = [1, 2, 3].lock;       // Safe
IList<int> ilist = [1, 2, 3].lockUnsafe; // Only this one is dangerous
List<int> list = ilist.unlock;           // Safe and mutable
List<int> list = ilist.unlockView;       // Safe, fast and immutable
List<int> list = ilist.unlockLazy;       // Safe, fast and mutable
```

Suppose you have some `List`.
These are your options to create an `IList` from it:

- Getter `lock` will create an internal defensive copy of the original list, 
which will be used to back the `IList`.
This is the same doing: `IList(list)`.

- Getter `lockUnsafe` is fast, since it makes no defensive copies of the list.
However, you should only use this with a new list you've created yourself,
when you are sure no external copies exist. If the original list is modified,
it will break the `IList` and any other derived lists in unpredictable ways.
Use this at your own peril. This is the same doing: `IList.unsafe(list)`.
Note you can optionally disallow unsafe constructors in the global configuration 
by doing: `disallowUnsafeConstructors = true` (and then optionally preventing 
further configuration changes by calling `lockConfig()`).                  

These are your options to obtain a regular `List` back from an `IList`:

- Getter `unlock` unlocks the list, returning a regular (mutable, growable) `List`.
This returned list is "safe", in the sense that is newly created, 
independent of the original `IList` or any other lists.

- Getter `unlockView` unlocks the list, returning a safe, unmodifiable (immutable) `List` view.
The word "view" means the list is backed by the original `IList`.
This is very fast, since it makes no copies of the `IList` items.
However, if you try to use methods that modify the list, like `add`,
it will throw an `UnsupportedError`.
It is also very fast to lock this list back into an `IList`.

- Getter `unlockLazy` unlocks the list, returning a safe, modifiable (mutable) `List`.
Using this is very fast at first, since it makes no copies of the `IList` items. 
However, if (and only if) you use a method that mutates the list, like `add`, 
it will unlock it internally (make a copy of all `IList` items). 
This is transparent to you, and will happen at most only once. 
In other words, it will unlock the `IList` lazily, only if necessary.
If you never mutate the list, it will be very fast to lock this list
back into an `IList`.


# 4. ISet

An `ISet` is an immutable set, meaning once it's created it cannot be modified.
An `ISet` is always **unordered** 
(though, as we'll see, it can be automatically sorted when you use it).  

You can create an `ISet` by passing an iterable to its constructor, 
or you can simply "lock" a regular set. 
Other iterables (which are not sets) can also be locked as sets:  

```dart          
/// Ways to build an ISet

// Using the ISet constructor                                                                      
ISet<String> iset = ISet({1, 2});
                              
// Locking a regular set
ISet<String> iset = {1, 2}.lock;
                          
// Locking a list as set
ISet<String> iset = [1, 2].lockAsSet;
```                                                                           

To create a regular `Set` from an `ISet`,
you can use `Set.of`, or simply "unlock" an immutable set:

```dart  
/// Going back from ISet to Set
                 
var iset = {1, 2}.lock;
                                    
// Using Set.of                                  
Set<String> set = Set.of(iset);                               
                                  
// Is the same as unlocking the ISet
Set<String> set = iset.unlock; 
```             

ISet constructors:
`ISet()`,
`ISet.withConfig()`,
`ISet.unsafe()`.
                                                              
## 4.1. Similarities and Differences to the IList

> Since I don't want to repeat myself, 
> all the topics below are explained in much less detail here than for the IList.
> Please read the IList explanation first, before trying to understand the ISet.

- An `ISet` is an `Iterable`, so you can iterate over it.

- `ISet` has **all** the methods of `Set`, plus some other new and useful ones.
`ISet` methods always return a new `ISet`, instead of modifying the original one. 
Because of that, you can easily chain methods.
But since `ISet` methods always return a new `ISet`, 
it is an **error** to call some method and then discard the result. 

- `ISet`s with "deep equals" configuration are equal if they have the same items in **any** order. 
They can be used as **map keys**, which is a very useful property in itself, 
but can also help when implementing some other interesting data structures.
  
- However, `ISet`s are configurable, and you can actually create `ISet`s which
compare their internals by identity or deep equals, as desired.
   
- To choose a configuration you can use getters `withIdentityEquals` and `withDeepEquals`;
or else use the `withConfig` method and the `ConfigSet` class to change the configuration;
or else use the `withConfig` constructor to explicitly create the `ISet` with your desired configuration.
 
- The configurations affect how the `== operator` works, 
but you can also choose how to compare sets by using the following `ISet` methods:
`equalItems`, `equalItemsAndConfig` and `same`.
Note, however, there is no `unorderedEqualItems` like in the `IList`, 
because since `ISets` are unordered the `equalItems` method already disregards the order.

- Classes `ISetMixin` and `IterableISetMixin` let you easily 
create your own immutable classes based on the `ISet`.
This helps you create more strongly typed collections, 
and add your own methods to them.

- You can flush some `ISet` by using the getter `.flush`.
Note flush just optimizes the set **internally**, 
and no external difference will be visible.
Depending on the global configuration, the `ISet`s 
will flush automatically for you, once per asynchronous gap.  

- There are a few ways to lock and unlock a set, 
which will have different results in speed and safety.
Getter `lock` will create an internal defensive copy of the original set.
Getter `lockUnsafe` is fast, since it makes no defensive copies of the set.
Getter `unlock` unlocks the set, returning a regular (mutable, growable) set.
Getter `unlockView` unlocks the set, returning a safe, unmodifiable (immutable) set view.
And getter `unlockLazy` unlocks the set, returning a safe, modifiable (mutable) set.

    ```dart
    ISet<int> iset = {1, 2, 3}.lock;       // Safe
    ISet<int> iset = {1, 2, 3}.lockUnsafe; // Only this one is dangerous
    Set<int> set = iset.unlock;            // Safe, mutable and unordered
    Set<int> set = iset.unlockSorted;      // Safe, mutable and ordered 
    Set<int> set = iset.unlockView;        // Safe, fast and immutable
    Set<int> set = iset.unlockLazy;        // Safe, fast and mutable
    ```                                                        

  
## 4.2. Global ISet Configuration

The **default** configuration of the `ISet` is `ConfigSet(isDeepEquals: true, sort: true)`:

1. `isDeepEquals: true` compares by deep equality: They are equal if they have the same items in the same order.

1. `sort: true` means `ISet.iterator`, and methods `ISet.toList`, `ISet.toIList` and `ISet.toSet`
   will return sorted outputs.

You can globally change this default if you want, by using the `defaultConfig` setter:
`defaultConfig = ConfigSet(isDeepEquals: false, sort: false);`
                                                                        
Note that `ConfigSet` is similar to `ConfigList`, but it has an extra parameter: `Sort`:

```dart
/// Prints sorted: "1,2,3,4,9"
var iset = {2, 4, 1, 9, 3}.lock;  
print(iset.join(","));

/// Prints in any order: "2,4,1,9,3"
var iset = {2, 4, 1, 9, 3}.lock.withConfig(ConfigSet(sort: false));  
print(iset.join(","));
``` 
  
As previously discussed with the `IList`, 
the global configuration is meant to be decided during your app's initialization, and then not changed again.
We strongly suggest that you prohibit further changes to the global configuration by calling `lockConfig();`
after you set your desired configuration.


# 5. IMap

An `IMap` is an immutable map, meaning once it's created it cannot be modified.
An `IMap` is always **unordered** 
(though, as we'll see, it can be automatically sorted when you use it).  

You can create an `IMap` by passing a regular map to its constructor, 
or you can simply "lock" a regular map. 
There are also a few other specialized constructors:  

```dart          
/// Ways to build an IMap

// Using the IMap constructor                                                                      
IMap<String, int> imap = IMap({"a": 1, "b": 2});
                              
// Locking a regular map
IMap<String, int> imap = {"a": 1, "b": 2}.lock;
                          
// From map entries
IMap<String, int> imap = IMap.fromEntries([MapEntry("a", 1), MapEntry("b", 2)]);

// From keys and a value-mapper
// This results in {"Jim": 3, "David": 5}
IMap<String, int> imap = 
    IMap.fromKeys(keys: ["Jim", "David"], 
                  valueMapper: (name) => name.length);

// From a key-mapper and values          
// This results in {3: "Jim", 5: "David"}
IMap<int, String> imap = 
    IMap.fromValues(keyMapper: (name) => name.length, 
                    values: ["Jim", "David"]);

// From an Iterable and key/value mappers          
// This results in {"JIM": 3, "DAVID": 5}
IMap<int, String> imap = 
    IMap.fromIterable(["Jim", "David"], 
                      keyMapper: (name) => name.toUppercase(),
                      valueMapper: (name) => name.length);

// From key and value Iterables          
// This results in {"a": 1, "b": 2}
IMap<int, String> imap = IMap.fromIterables(["a", "b"], [1, 2]);                      
```                                                                           

To create a regular `Map` from an `IMap`, you can "unlock" an immutable map:

```dart  
/// Going back from IMap to Map
                 
IMap<String, int> imap = {"a": 1, "b": 2}.lock;
Map<String, int> map = imap.unlock; 
```             
                                                             
## 5.1. Similarities and Differences to the IList/ISet

> Since I don't want to repeat myself, 
> all the topics below are explained in much less detail here than for the IList.
> Please read the IList explanation first, before trying to understand the IMap.

- Just like a regular map, an `IMap` is **not**an `Iterable`.
However, you can iterate over its entries, keys and values:

```dart               
/// Unordered
Iterable<MapEntry<K, V>> get entries;  
Iterable<K> get keys;
Iterable<V> get values;

/// Ordered (according to the configuration)
IList<MapEntry<K, V>> entryList();
IList<K> keyList();
IList<V> valueList();                       
             
/// Unordered
ISet<MapEntry<K, V>> entrySet();
ISet<K> keySet();
ISet<V> valueSet();

/// Ordered (according to the configuration)
List<MapEntry<K, V>> toEntryList();
List<K> toKeyList();
List<V> toValueList();

/// Ordered (according to the configuration)
Set<MapEntry<K, V>> toEntrySet();
Set<K> toKeySet();
Set<V> toValueSet();
                                            
/// Ordered (according to the configuration)
Iterator<MapEntry<K, V>> get iterator;
             
/// Unordered, but fast
Iterator<MapEntry<K, V>> get fastIterator;
```

- `IMap` has **all** the methods of `Map`, plus some other new and useful ones. 
`IMap` methods always return a new `IMap`, instead of modifying the original one. 
Because of that, you can easily chain methods.
But since `IMap` methods always return a new `IMap`, 
it is an **error** to call some method and then discard the result. 

- `IMap`s with "deep equals" configuration are equal if they have the same entries in **any** order. 
These maps can be used as **map keys** themselves.
  
- However, `IMap`s are configurable, and you can actually create `IMap`s which
compare their internals by identity or deep equals, as desired.
   
- To choose a configuration you can use getters `withIdentityEquals` and `withDeepEquals`;
or else use the `withConfig` method and the `ConfigMap` class to change the configuration;
or else use the `withConfig` constructor to explicitly create the `IMap` with your desired configuration.
 
- The configurations affect how the `== operator` works, 
but you can also choose how to compare sets by using the following `IMap` methods:
`equalItems`, `equalItemsAndConfig`, `equalItemsToIMap` and `same`.
Note, however, there is no `unorderedEqualItems` like in the `IList`, 
because since `IMaps` are unordered the `equalItems` method already disregards the order.

- You can flush some `IMap` by using the getter `.flush`.
Note flush just optimizes the set **internally**, 
and no external difference will be visible.
Depending on the global configuration, the `IMap`s 
will flush automatically for you, once per asynchronous gap.  

- There are a few ways to lock and unlock a map, 
which will have different results in speed and safety.
Getter `lock` will create an internal defensive copy of the original map.
Getter `lockUnsafe` is fast, since it makes no defensive copies of the map.
Getter `unlock` unlocks the map, returning a regular (mutable, growable) set.
Getter `unlockView` unlocks the map, returning a safe, unmodifiable (immutable) map view.
And getter `unlockLazy` unlocks the map, returning a safe, modifiable (mutable) map.

    ```dart
    IMap<String, int> imap = {"a": 1, "b": 2}.lock;        // Safe
    IMap<String, int> imap = {"a": 1, "b": 2}.lockUnsafe;  // Only this one is dangerous
    Map<String, int> set = imap.unlock;                    // Safe, mutable and unordered
    Map<String, int> set = imap.unlockSorted;              // Safe, mutable and ordered 
    Map<String, int> set = imap.unlockView;                // Safe, fast and immutable
    Map<String, int> set = imap.unlockLazy;                // Safe, fast and mutable
    ```                                                        

  
## 5.2. Global IMap Configuration

The **default** configuration of the `IMap` is 
`ConfigMap(isDeepEquals: true, sortKeys: true, sortValues: true)`:

1. `isDeepEquals: true` compares by deep equality: They are equal if they have the same entries in the same order.

1. `sortKeys: true` means `IMap.iterator`, and methods `IMap.entryList`, `IMap.keyList`, `IMap.toEntryList`,
`IMap.toKeyList`, `IMap.toEntrySet` and `IMap.toKeySet` will return sorted outputs.

1. `sortValues: true` means methods `IMap.valueList`, `IMap.toValueList`, and `IMap.toValueSet` 
will return sorted outputs.

You can globally change this default if you want, by using the `defaultConfig` setter:
`defaultConfig = ConfigMap(isDeepEquals: false, sortKeys: false, sortValues: false);`
                                                                        
Note that `ConfigMap` is similar to `ConfigSet`, 
but it has separate sort parameters for keys and values: `sortKeys` and `sortValues`:

```dart
/// Prints sorted: "1,2,4,9"
var imap = {2: "a", 4: "x", 1: "z", 9: "k"}.lock;  
print(imap.keyList.join(","));

/// Prints in any order: "2,4,1,9"
var imap = {2: "a", 4: "x", 1: "z", 9: "k"}.lock.withConfig(ConfigMap(sortKeys: false));  
print(imap.keyList.join(","));
``` 
  
As previously discussed with `IList` and `ISet`, 
the global configuration is meant to be decided during your app's initialization, 
and then not changed again.
We strongly suggest that you prohibit further changes to the global configuration 
by calling `lockConfig();` after you set your desired configuration.


# 6. IMapOfSets

When you lock a `Map<K, V>` it turns into an `IMap<K, V>`.

However, a locked `Map<K, Set<V>>` turns into an `IMapOfSets<K, V>`.  
 
 ```dart
/// Map to IMap
IMap<K, V> map = {'a': 1, 'b': 2}.lock;

/// Map to IMapOfSets
IMapOfSets<K, V> map = {'a': {1, 2}, 'b': {3, 4}}.lock;
```

The `IMapOfSets` lets you add / remove **values**, 
without having to think about the **sets** that contain them.
For example:

 ```dart
IMapOfSets<K, V> map = {'a': {1, 2}, 'b': {3, 4}}.lock;

// Prints {'a': {1, 2, 3}, 'b': {3, 4}}
print(map.add('a', 3)); 
```
 

Suppose you want to create an immutable structure 
that lets you arrange `Student`s into `Course`s.
Each student can be enrolled into one or more courses. 

This can be modeled by a map where the keys are the courses, and the values are sets of students.

Implementing structures that **nest** immutable collections like this can be quite tricky.
That's when an `IMapOfSets` comes handy:

```dart
class StudentsPerCourse {
  final IMapOfSets<Course, Student> imap;

  StudentsPerCourse([Map<Course, Set<Student>> studentsPerCourse])
      : _studentsPerCourse = (studentsPerCourse ?? {}).lock;

  StudentsPerCourse._(this._studentsPerCourse);

  ISet<Course> courses() => imap.keysAsSet;

  ISet<Student> students() => imap.valuesAsSet;

  IMapOfSets<Student, Course> getCoursesPerStudent() => imap.invertKeysAndValues();

  ISet<Student> studentsInAlphabeticOrder() =>
      imap.valuesAsSet.toIList(compare: (s1, s2) => s1.name.compareTo(s2.name));

  ISet<String> studentNamesInAlphabeticOrder() => imap.valuesAsSet.map((s) => s.name).toIList();

  StudentsPerCourse addStudentToCourse(Student student, Course course) =>
      StudentsPerCourse._(imap.add(course, student));

  StudentsPerCourse addStudentToCourses(Student student, Iterable<Course> courses) =>
      StudentsPerCourse._(imap.addValuesToKeys(courses, [student]));

  StudentsPerCourse addStudentsToCourse(Iterable<Student> students, Course course) =>
      StudentsPerCourse._(imap.addValues(course, students));

  StudentsPerCourse addStudentsToCourses(Map<Course, Set<Student>> studentsPerCourse) =>
      StudentsPerCourse._(imap.addMap(studentsPerCourse));

  StudentsPerCourse removeStudentFromCourse(Student student, Course course) =>
      StudentsPerCourse._(imap.remove(course, student));

  StudentsPerCourse removeStudentFromAllCourses(Student student) =>
      StudentsPerCourse._(imap.removeValues([student]));

  StudentsPerCourse removeCourse(Course course) => StudentsPerCourse._(imap.removeSet(course));
  Map<Course, Set<Student>> toMap() => imap.unlock;

  int get numberOfCourses => imap.lengthOfKeys;
  
  int get numberOfStudents => imap.lengthOfNonRepeatingValues;
}     
```

Note: The `IMapOfSets` configuration (`ConfigMapOfSets.allowEmptySets`) 
lets you choose if empty sets should be removed or not.
In the above example, this would mean allowing courses with no students, 
or else removing the course automatically when the last student leaves.

```dart
/// Using the default configuration: Empty sets are removed.
StudentsPerCourse([Map<Course, Set<Student>> studentsPerCourse]) 
   : _studentsPerCourse = (studentsPerCourse ?? {}).lock;

/// Specifying that a course can be empty (have no students).
StudentsPerCourse([Map<Course, Set<Student>> studentsPerCourse]) 
   : _studentsPerCourse = (studentsPerCourse ?? {}).lock
       .withConfig(ConfigMapOfSets(allowEmptySets: true));
```  
  
  
# 7. Comparators

To help you sort collections, 
we provide the global comparator functions `compareObject`, `sortBy` and `sortLike`, 
and the `compareObjectTo` and `if0` extensions,
which make it easy for you to create other complex comparators,
as described below. 

## 7.1. CompareObject function

The `compareObject` function lets you easily compare `a` and `b`, as follows:

If `a` or `b` is `null`, it will come later (the default), 
unless the `nullsBefore` parameter is `true`, 
in which case the `null` one will come before.

If `a` and `b` are both of type `Comparable`, it compares them with their natural comparator.

If `a` and `b` are map-entries, it compares their keys first, and then, if necessary, their values. 

If `a` and `b` are booleans, it compares them such as `true > false`.

If all the above can't distinguish them, it will return `0` (which means unordered).

You can use the comparator in sorts:

```dart
// Results in: [1, 2, null]
[1, 2, null, 3].sort(compareObject);

// Results in: [null, 1, 2]
[1, 2, null, 3].sort((a, b) => compareObject(a, b, nullsBefore: true));
```             


## 7.2. CompareObjectTo extension

Beside the `compareObject` function above, 
you can also use the `compareObjectTo` extension.

For example: 
 
```dart
// Results in: [1, 2, null]
[1, 2, null, 3].sort((a, b) => a.compareObjectTo(b));

// Results in: [null, 1, 2]
[1, 2, null, 3].sort((a, b) => a.compareObjectTo(b, nullsBefore: true));
```              


## 7.3. SortBy function

The `sortBy` function lets you define a rule, 
and then possibly nest it with other rules with lower priority.
For example, suppose you have a list of numbers 
which you want to sort according to the following rules:

> 1. If present, number 14 is always the first, followed by number 15.
> 1. Otherwise, odd numbers come before even ones.
> 1. Otherwise, come numbers which are multiples of 3,
> 1. Otherwise, come numbers which are multiples of 5,
> 1. Otherwise, numbers come in their natural order.

You start by creating the first rule: `sortBy((x) => x == 15)` and
then nesting the next rule in the `then` parameter:
`sortBy((x) => x == 15, then: sortBy((x) => x % 2 == 1)`.

After all the rules are in place you have this: 

```dart
int Function(int, int) compareTo = sortBy((x) => x == 14,
   then: sortBy((x) => x == 15,
       then: sortBy((x) => x % 2 == 1,
           then: sortBy((x) => x % 3 == 0,
               then: sortBy((x) => x % 5 == 0,
                   then: (int a, int b) => a.compareTo(b),
               )))));
``` 


## 7.4. SortLike function

The `sortLike` function lets you define a list with the desired sort order. 
For example, if you want to sort numbers in this order: `[7, 3, 4, 21, 2]`
you can do it like this: `sortLike([7, 3, 4, 21, 2])`.

You can also nest other comparators, including mixing `sortBy` and `sortLike`.
For example, to implement the following rules:  

> 1. Order should be [7, 3, 4, 21, 2] when these values appear.
> 1. Otherwise, odd numbers come before even ones.
> 1. Otherwise, numbers come in their natural order.

```dart                  
int Function(int, int) compareTo = sortLike([7, 3, 4, 21, 2],
   then: sortBy((x) => x % 2 == 1,
       then: (int a, int b) => a.compareTo(b),
           ));
``` 

Important: When nested comparators are used, make sure you don't create
inconsistencies. For example, a rule that states `a<b then a>c then b<c`
may result in different orders for the same items depending on their initial 
position. This also means inconsistent rules may not be followed precisely.

Please note, your order list may be of a different type than the values you
are sorting. If this is the case, you can provide a `mapper` function, 
to convert the values into the `order` type. See the `sort_test.dart`
file for more information and runnable examples. 


## 7.5. if0 extension

The `if0` function lets you nest comparators.

You can think of `if0` as a "then",
so that these two comparators are equivalent:

```dart
/// This:
var compareTo = (String a, String b) 
       => a.length.compareTo(b.length).if0(a.compareTo(b));

/// Is the same as this:
var compareTo = (String a, String b) {
   int result = a.length.compareTo(b.length);
   if (result == 0) result = a.compareTo(b);
   return result;
}
```

Examples:

```dart
var list = ["aaa", "ccc", "b", "c", "bbb", "a", "aa", "bb", "cc"];
                  
/// Example 1. 
/// String come in their natural order.
var compareTo = (String a, String b) => a.compareTo(b);
list.sort(compareTo);
expect(list, ["a", "aa", "aaa", "b", "bb", "bbb", "c", "cc", "ccc"]);

/// Example 2. 
/// Strings are ordered according to their length.
/// Otherwise, they come in their natural order.
compareTo = (String a, String b) => a.length.compareTo(b.length).if0(a.compareTo(b));
list.sort(compareTo);
expect(list, ["a", "b", "c", "aa", "bb", "cc", "aaa", "bbb", "ccc"]);

/// Example 3. 
/// Strings are ordered according to their length.
/// Otherwise, they come in their natural order, inverted.
compareTo = (String a, String b) => a.length.compareTo(b.length).if0(-a.compareTo(b));
list.sort(compareTo);
expect(list, ["c", "b", "a", "cc", "bb", "aa", "ccc", "bbb", "aaa"]);
``` 

## 7.6. Flushing 

As explained, `fast_immutable_collections` is fast because it creates a new collection 
by internally "composing" the source collection with some other information, 
saving only the difference between the source and destination collections, 
instead of copying the whole collection each time.

After a lot of modifications, 
these composed collections may end up with lots of information to coordinate the composition, 
and may become slower than a regular mutable collection.

The loss of speed depends on the type of collection. 
For example, `IList` doesn't suffer much from deep compositions,
while `ISet` and `IMap` will take more of a hit.  

If you call `flush` on an immutable collection, 
it will internally remove all the composition,
making sure it is perfectly optimized again. For example:

```dart
var ilist = [1.2].lock.add([3, 4]).add(5);
ilist.flush;
```         

Please note, `flush` is a getter which returns the exact same instance, 
just so you can chain other methods on it, if you wish. 
But it does NOT create a new list. 
It actually just optimizes the current list, internally.

If you flush a list which is already flushed, nothing will happen,
and it won't take any time to flush the list again.
So you don't need to worry about flushing the list more than once.

Also, note that flushing just optimizes the list **internally**, 
and no external difference will be visible. 
So, for all intents and purposes, you may consider that `flush` doesn't mutate the list.


## 7.7. Auto-flush      

Usually you don't need to flush your collections manually.
Depending on the global configuration, 
the collections will flush automatically for you.
The global configuration default is to have auto-flush on. It's easy to disable this:

```dart
autoFlush = false;

// You can also lock further changes to the global configuration, if desired:                                              
lockConfig();
```                                                    

If you leave it on, you can configure auto-flush to happen after you use a collection a few times.
And you can also configure it to flush at most once per asynchronous gap.   

Auto-flush is an advanced topic, 
and you don't need to read the following detailed explanation at all to use the immutable collections.
However, in case you want to tweak the auto-flush configuration, here it goes:

### 7.7.1. Sync Auto-flush

If your auto-flush is set to occur synchronously:

Each collection keeps a `counter` variable which starts at `0` 
and is incremented each time some collection methods are called. 
As soon as this counter reaches a certain value called the `flushFactor`, 
the collection is flushed.

### 7.7.2. Async Auto-flush

If your auto-flush is set to occur asynchronously: 

If you take a collection and add or remove a lot of items synchronously,
no flushing will take place.

Each collection still keeps a `counter` variable which starts at `0`, 
but it will be incremented during method calls only while `counter >= 0`. 
As soon as this counter reaches a certain value called the `flushFactor`, 
the collection is marked for flushing.

But after the asynchronous gap, as soon as you try to get, add or remove an item from it,
it will flush automatically.  

There is also a global counter called an `asyncCounter` which starts at `1`. 
When a collection is marked for flushing, 
it first creates a future to increment the `asyncCounter`. 
Then, the collection's own `counter` is set to be `-asyncCounter`. 
Having a negative value means the collection's `counter` will not
be incremented anymore. However, when `counter` is negative and different from `-asyncCounter` 
it means we are one async gap after the collection was marked for flushing. 

At this point, the collection will be flushed and its `counter` will return to zero. 

An example, as an ordered list with summarized states and as an ordered list with a narrative:

1. The initial setup:
    - `flushFactor = 3`
    - `asyncCounter = 1`
1. The `IList` is created.
    - `counter = 0`
    - `counter < flushFactor`
1. `IList` is used.
    - `counter = 1`
    - `counter < flushFactor`
1. `IList` is used.
    - `counter = 2`
    - `counter < flushFactor`
1. `IList` is used.
    - `counter = 3`
    - `counter = flushFactor`
    - `counter = -asyncCounter = -1`
    - `asyncCounter` is now  set to increment in the future.
1. `IList` is used.
    - Since `counter < 0`, it's not incremented.
    - Since `counter = -asyncCounter < 0`, it is not flushed.
1. Here comes the async gap.
    - The `asyncCounter` was set to increment, so: `asyncCounter = 2`.
1. `IList` is used.
    - Since `counter < 0`, it is not incremented.
    - Since `counter < 0 && counter != -asyncCounter`, the list is flushed.
    - And `counter = 0`.

```text
1. The flushFactor is 3. The asyncCounter is 1.
 
2. IList is created. Its counter is 0, smaller than the flushFactor.

3. IList is used. Its counter is now 1, smaller than the flushFactor.
 
4. IList is used. Its counter is now 2, smaller than the flushFactor.

5. IList is used. Its counter is now 3, equal to the flushFactor.
   For this reason, the list counter is set at negative asyncCounter (-1), 
   and the asyncCounter is set to increment in the future.    

6. IList is used. Since its counter is negative, it's not incremented.
   Since the counter is negative and equal to negative asyncCounter, it is not flushed.  
  
7. Here comes the async gap. The asyncCounter was set to increment, so it now becomes 2.

8. IList is used. Since its counter is negative, it is not incremented.
   Since the counter is negative and different than negative asyncCounter, the list is flushed.
   Also, its counter reverts to 0.                                   
```   

The auto-flush process is a heuristic only.
However, note the process is very fast (uses only simple integer operations) 
and uses just a few bytes of memory to work.
It guarantees that, if a collection is being used a lot, it will flush more often than one which is not being used that often.
It also guarantees a collection will not auto-flush in the middle of sync operations.
Finally, it saves no references to the collections, so it doesn't prevent them from being garbage collected.

If you think about the update/publish cycle of the `built_collections` package, 
it has an intermediate state (the builder) which is not a valid collection, 
and then you publish it manually.
In contrast, `fast_immutable_collections` does have a valid intermediate state (unflushed)
which you can use as a valid collection, 
and then it publishes automatically (flushes) after the async gap.

As discussed, the default is to have auto-flush turned on, but you can turn it off. 
If you leave it on, you can tweak the `flushFactor` for lists, sets and maps. 
Usually, lists should have a higher `flushFactor` because they are generally still very efficient when unflushed.

The minimum `flushFactor` you can choose is `1`, which means the collections will always flush in the 
next async gap after they are touched.    

```dart
ilistflushFactor = 150;
isetflushFactor = 15;
imapflushFactor = 15;

// Lock further changes, if desired:                                              
lockConfig();
```                                                    
    

***************************************
***************************************
***************************************

## 7.8. Why Immutable Collections (and immutable objects in general) are useful?

<!-- TODO: Add motivation for this project and its use. -->

## 7.9. Benchmarks Summary

<!-- TODO: Add summarized tables that, hopefully, quickly justify this package's existence.-->

## 7.10. The Motivation for the `IMapOfSets` Collection Class

<!-- TODO: Complete. -->

## 7.11. The Implementation's Idea

Basically, behind the scenes, this is what happens when you pass a `List` to an `IList`, 
the other collection objects follow the same idea:

1. A *new* copy of the object is made with `List.of`, so the original object won't be modified at all.
    1. When you add an element to the `IList`, it will be registered as an *immutable* property behind the scenes, and not `add`ed to the original `List`.
    1. When you add a collection of elements (`Iterable`) to the `IList`, it will also be registered as an *immutable* property, as a new copy of the `Iterable` if necessary to ensure the original won't be changed.

## 7.12. Other Resources & Documentation

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

## 7.13. For the Developer or Contributor

### 7.13.1. Formatting 

This project uses 100-character lines instead of the typical 80. If you're on VS Code, simply add this line to your `settings.json`:

```json
"dart.lineLength": 100,
```

If you're going to use the `dartfmt` CLI, you can add the `-l` option when formatting, e.g.:

```sh
dartfmt -l 100 -w . 
```
