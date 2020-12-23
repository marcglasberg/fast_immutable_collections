<p align="center">
  <img src="assets/logo.png" alt="Logo" />
</p>

<p align="center">
  <a href="https://github.com/marcglasberg/fast_immutable_collections/actions"><img src="https://github.com/marcglasberg/fast_immutable_collections/workflows/Dart%20%7C%7C%20Tests%20%7C%20Formatting%20%7C%20Analyzer/badge.svg?" alt="Github CI"></a>
  <a href="https://codecov.io/gh/marcglasberg/fast_immutable_collections/"><img src="https://codecov.io/gh/marcglasberg/fast_immutable_collections/branch/master/graphs/badge.svg" alt="Codecov.io Coverage" /></a>
  <a href="https://gitter.im/Fast-Immutable-Collections/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"><img src="https://badges.gitter.im/Fast-Immutable-Collections/community.svg" alt="Gitter Chat" /></a>
</p>

---

# 1. Fast Immutable Collections

<p align="center">
  <img src="benchmark/assets/demo.gif" alt="Demo GIF" />
</p>

<p align="center">
  <sub>The <a href="benchmark/example/"><code>benchmark_example</code></a> app for comparing this package's collections to others.</sub>
</p>

> **THIS IS UNDER ACTIVE DEVELOPMENT. DON'T USE IT.**

> **THIS IS UNDER ACTIVE DEVELOPMENT. DON'T USE IT.**

> **THIS IS UNDER ACTIVE DEVELOPMENT. DON'T USE IT.**

[codecov]: https://codecov.io/gh/marcglasberg/fast_immutable_collections/
[codecov_badge]: https://codecov.io/gh/marcglasberg/fast_immutable_collections/branch/master/graphs/badge.svg
[example]: benchmark/example/
[gif]: benchmark/assets/demo.gif
[github_actions]: https://github.com/marcglasberg/fast_immutable_collections/actions
[github_ci_badge]: https://github.com/marcglasberg/fast_immutable_collections/workflows/Dart%20%7C%7C%20Tests%20%7C%20Formatting%20%7C%20Analyzer/badge.svg?branch=master
[github_home]: https://github.com/marcglasberg/fast_immutable_collections
[gitter_svg]: https://badges.gitter.im/Fast-Immutable-Collections/community.svg
[gitter_badge]: https://gitter.im/Fast-Immutable-Collections/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge
[logo]: assets/logo.png

## 1.1. Introduction

This package provides:

- `IList`, an immutable list
- `ISet`, an immutable set
- `IMap`, an immutable map
- `IMapOfSets`, an immutable map of sets (a multimap)

Other valuable features are:

- Extensions to the typical collections &mdash; `List`, `Set`, `Map` &mdash; so you can easily transform a mutable object into an immutable one (`.lock`).
- Global and local configurations that alter how your immutable collections behave.
- Mixins for you to build your own immutable collections or objects.
- Collection views so you can work with immutable objects as if they were the mutable ones.
- Deep equalities and cached hashCodes, which let you treat your collections as value objects.
- Comparators and related helpers to be used with any collections.

<br>

**Fast Immutable Collections** is a competitor to the excellent
[built_collection][built_collection] and [kt_dart][kt_dart] packages, 
but it's much **easier** to use than the former, 
and orders of magnitude **faster** than the latter.

The reason it's **easier** than [built_collection][built_collection] 
is that there is no need for manual mutable/immutable cycles.
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

**Table of Contents**


<!-- TOC -->

- [1. Fast Immutable Collections](#1-fast-immutable-collections)
    - [1.1. Introduction](#11-introduction)
- [2. IList](#2-ilist)
    - [2.1. IList Equality](#21-ilist-equality)
    - [2.1.1 Cached HashCode](#211-cached-hashcode)
    - [2.2. Global IList Configuration](#22-global-ilist-configuration)
    - [2.3. Usage in tests](#23-usage-in-tests)
    - [2.4. IList reuse by composition](#24-ilist-reuse-by-composition)
    - [2.5. Advanced usage](#25-advanced-usage)
- [3. ISet](#3-iset)
    - [3.1. Similarities and Differences to the IList](#31-similarities-and-differences-to-the-ilist)
    - [3.2. Global ISet Configuration](#32-global-iset-configuration)
- [4. IMap](#4-imap)
    - [4.1. Similarities and Differences to the IList/ISet](#41-similarities-and-differences-to-the-ilistiset)
    - [4.2. Global IMap Configuration](#42-global-imap-configuration)
- [5. IMapOfSets](#5-imapofsets)
- [6. Comparators](#6-comparators)
    - [6.1. CompareObject function](#61-compareobject-function)
    - [6.2. CompareObjectTo extension](#62-compareobjectto-extension)
    - [6.3. SortBy function](#63-sortby-function)
    - [6.4. SortLike function](#64-sortlike-function)
    - [6.5. if0 extension](#65-if0-extension)
- [7. Flushing](#7-flushing)
    - [7.1. Auto-flush](#71-auto-flush)
    - [7.2. Sync Auto-flush](#72-sync-auto-flush)
    - [7.3. Async Auto-flush](#73-async-auto-flush)
- [8. About the Benchmarks](#8-about-the-benchmarks)
- [9. Other Resources & Documentation](#9-other-resources--documentation)
- [10. For the Developer or Contributor](#10-for-the-developer-or-contributor)
    - [10.1. Formatting](#101-formatting)

<!-- /TOC -->


# 2. IList

An `IList` is an immutable list, meaning once it's created it cannot be modified. 
You can create an `IList` by passing an iterable to its constructor, 
or you can simply "lock" a regular list. 
Other iterables (which are not lists) can also be locked as lists:  

```          
/// Ways to build an IList

// Using the IList constructor                                                                      
IList<String> ilist = IList([1, 2]);
                              
// Locking a regular list
IList<String> ilist = [1, 2].lock;
                          
// Locking a set as list
IList<String> ilist = {1, 2}.toIList();
```                                                                           

To create a regular `List` from an `IList`,
you can use `List.of`, or simply "unlock" an immutable list:

```  
/// Going back from IList to List
                 
var ilist = [1, 2].lock;
                                    
// Using List.of                                  
List<String> list = List.of(ilist);                               
                                  
// Is the same as unlocking the IList
List<String> list = ilist.unlock; 
```                                                                           

An `IList` is an `Iterable`, so you can iterate over it:

```  
var ilist = [1, 2, 3, 4].lock;
                                                            
// Prints 1 2 3 4
for (int value in ilist) print(value);  
```                                                                           

`IList` methods always return a new `IList`, instead of modifying the original one. 
For example:

```                                     
var ilist1 = [1, 2].lock;
                                                  
// Results in: 1, 2, 3
var ilist2 = ilist1.add(3);
                                             
// Results in: 1, 3
var ilist3 = ilist2.remove(2);             
               
// Still: 1, 2
print(ilist1); 
```   

Because of that, you can easily chain methods:

```                                     
// Results in: 1, 3, 4.
var ilist = [1, 2, 3].lock.add(4).remove(2);
```   

Since `IList` methods always return a new `IList`, 
it is an **error** to call some method and then discard the result: 

```                                     
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

```                                     
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
                                                                        
## 2.1. IList Equality 
   
By default, `IList`s are equal if they have the same items in the same order.

```                                     
var ilist1 = [1, 2, 3].lock;
var ilist2 = [1, 2, 3].lock;
                                    
// False!
print(identical(ilist1 == ilist2));
                         
// True!
print(ilist1 == ilist2);
```                                                                          

This is in sharp contrast to regular `List`s, which are compared by identity:

```                                     
var list1 = [1, 2, 3];
var list2 = [1, 2, 3];
                      
// Regular Lists compare by identity:
print(identical(ilist1 == ilist2)); // False!
print(list1 == list2); // False!

// While ILists compare by deep equals:
print(list1.lock == list2.lock); // True!
```                                                                          

This also means `IList`s can be used as **map keys**, 
which is a very useful property in itself, 
but can also help when implementing some other interesting data structures.
For example, to implement **caches**:      

```                                     
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
compare their internals by **identity** or **deep equals**, as desired.
There are 3 main ways to do it:
 
1. You can use getters `withIdentityEquals` and `withDeepEquals`:

    ```                    
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

    ```
    var list = [1, 2];
    var ilist1 = list.lock.withConfig(ConfigList(isDeepEquals: true));
    var ilist2 = list.lock.withConfig(ConfigList(isDeepEquals: false));
    
    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
    ```

1. Or you can use the `withConfig` constructor to
explicitly create the `IList` already with your desired configuration:

    ```
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
  
  
## 2.1.1 Cached HashCode

By default, the hashCode of `IList` and the other immutable collections is **cached** once calculated.

This not only speeds up the use of these collections inside of sets and maps, 
but it also speeds up their deep equals. 
The reason is simple: Two equal objects always have the same hashCode. 
So, if the cashed hashCode of two immutable collections are not the same, 
we know the collections are different, and there is no need to check each collection item, one by one.

However, this only works if the collections are really _immutable_, and not simply _unmodifiable_.
If you put modifiable objects into an `IList` and then later modify those objects, 
this breaks the immutability of the `IList`, which then becomes simply unmodifiable. 

In other words, even if you can't change which objects the list contains, 
if the objects themselves will be changed, then the hashCode must not be cached.
Therefore, if you intend on using the `IList` to hold modifiable objects, 
you should think about turning off the hashCode cache. For example:    

```
var ilist1 = [1, 2].lock.withConfig(ConfigList(cacheHashCode: false));
var ilist2 = IList.withConfig([1, 2], ConfigList(cacheHashCode: false));
```   

Note: Modifying mutable objects in a collection could only make sense for lists anyway, 
since list don't rely on the equality and hashCode of their items to structure themselves.
If objects are modified after you put them into both mutable or immutable sets and maps,
this most likely breaks the sets/maps they belong to.
    
  
## 2.2. Global IList Configuration

As explained above, the **default** configuration of the `IList` is that:
* It compares by deep equality: They are equal if they have the same items in the same order.
* The hashCode cache is turned on. 

You can globally change this default if you want, by using the `defaultConfig` setter:

```
var list = [1, 2];

/// The default is deep-equals.
var ilistA1 = IList(list);
var ilistA2 = IList(list);
print(ilistA1 == ilistA2); // True!

/// Now we change the default to identity-equals, and hashCode cache off. 
/// This will affect lists created from now on.
defaultConfig = ConfigList(isDeepEquals: false, cacheHashCode: false);
var ilistB1 = IList(list);
var ilistB2 = IList(list);
print(ilistB1 == ilistB2); // False!

/// Configuration changes don't affect existing lists.
print(ilistA1 == ilistA2); // True!
```                                                                        

**Important note:** 

The global configuration is meant to be decided during your app's initialization, and then not changed again.
We strongly suggest that you prohibit further changes to the global configuration by calling `ImmutableCollection.lockConfig();`
after you set your desired configuration.


## 2.3. Usage in tests

An `IList` is not a `List`, so this is false:

```
[1, 2] == [1, 2].lock // False!
```

However, when you are writing tests, 
the `expect` method actually compares all `Iterables` by comparing their items.
Since `List` and `IList` are iterables, you can write the following tests: 

```                                 
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

```
expect([1, 2], {2, 1}); // This test passes.
expect({2, 1}, [1, 2]); // This test does NOT pass.
```                                               

If you ask me, this is all very confusing. 
A good rule of thumb to avoid all these `expect` complexities 
is only comparing lists with lists, set with sets, etc.

## 2.4. IList reuse by composition

Classes `FromIListMixin` and `FromIterableIListMixin` let you easily 
create your own immutable classes based on the `IList`.
This helps you create more strongly typed collections, 
and add your own methods to them.

For example, suppose you have some `Student` class:

```
class Student implements Comparable<Student>{
   final String name;

   Student(this.name);

   String toString() => name; 

   bool operator ==(Object other) => identical(this, other) || other is Student && runtimeType == other.runtimeType && name == other.name;  

   int get hashCode => name.hashCode;

   @override
   int compareTo(Student other) => name.compareTo(other.name);
}
```

And suppose you want to create a `Students` class 
which is an immutable collection of `Student`s. 

You can easily implement it using the `FromIListMixin`:

```  
class Students with FromIListMixin<Student, Students> {

   /// This is the boilerplate to create the collection:
   final IList<Student> _students;

   Students([Iterable<Student> students]) : _students = IList(students);

   Students newInstance(IList<Student> ilist) => Students(ilist);

   IList<Student> get ilist => _students;   
                                                        
   /// And then you can add your own specific methods:
   String greetings() => "Hello ${_students.join(", ")}.";
}
```    

And then use the class:

```  
var james = Student("James");
var sara = Student("Sara");
var lucy = Student("Lucy");
              
// Most IList methods are available:
var students = Students().add(james).addAll([sara, lucy]);

expect(students, [james, sara, lucy]);
                             
// Prints: "Hello James, Sara, Lucy."
print(students.greetings()); 
```     

There are a few aspects of native Dart collection mixins which I don't like, so I've tried to improve on those here.

- First is that some Dart mixins let you create inefficient methods 
(like fore example, a `length` getter which has to iterate through all items to yield a result).
All mixins within `fast_immutable_collections` are as efficient as the underlying immutable collection, 
so you don't need to worry about this problem.

- Second is that the native Dart mixins implement their respective collections. 
For example, a `ListMixin` implements `List`. I don't think this is desirable. 
For example, should a `Students` class be an `IList` by default? I don't think so.
For this reason, the `FromIListMixin` is not called `IListMixin`, and it does not implement `IList` nor `Iterable`.

- Third, unfortunately, the `expect` method in tests compare iterables by comparing their items. 
So, if the `Students` class were to implement `Iterable`, the `expect` method would completely ignore its 
`operator ==`, which probably is not what you want.

Note, you can still iterate through the `Students` class in the example by calling `.iter` on it:

```  
for (Student student in students.iter) { ... }
```
 
And also, if really do want it to implement `Iterable`, you can do so by explicitly declaring it: 

```  
class Students with FromIListMixin<Student, Students> implements Iterable<Student> { ... }

class Students with FromIterableIListMixin<Student> implements Iterable<Student> { ... }
```

Please refer to the `FromIListMixin` and `FromIterableIListMixin` own documentation 
to learn how to use these mixins in detail.


## 2.5. Advanced usage

There are a few ways to lock and unlock a list, 
which will have different results in speed and safety.

```
IList<int> ilist = [1, 2, 3].lock;       // Safe
IList<int> ilist = [1, 2, 3].lockUnsafe; // Only this way to lock a list is dangerous

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
by doing: `disallowUnsafeConstructors = true` (and then optionally prevent 
further configuration changes by calling `ImmutableCollection.lockConfig()`).                  

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


# 3. ISet

An `ISet` is an immutable set, meaning once it's created it cannot be modified.
An `ISet` is always **unordered** 
(though, as we'll see, it can be automatically sorted when you use it).  

You can create an `ISet` by passing an iterable to its constructor, 
or you can simply "lock" a regular set. 
Other iterables (which are not sets) can also be locked as sets:  

```          
/// Ways to build an ISet

// Using the ISet constructor                                                                      
ISet<String> iset = ISet({1, 2});
                              
// Locking a regular set
ISet<String> iset = {1, 2}.lock;
                          
// Locking a list as set
ISet<String> iset = [1, 2].toISet();
```                                                                           

To create a regular `Set` from an `ISet`,
you can use `Set.of`, or simply "unlock" an immutable set:

```  
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
                                                              
## 3.1. Similarities and Differences to the IList

Since I don't want to repeat myself, 
all the topics below are explained in much less detail here than for the IList.
Please read the IList explanation first, before trying to understand the ISet.

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
   
- To choose a configuration, you can use getters `withIdentityEquals` and `withDeepEquals`;
or else use the `withConfig` method and the `ConfigSet` class to change the configuration;
or else use the `withConfig` constructor to explicitly create the `ISet` with your desired configuration.
 
- The configuration affects how the `== operator` works, 
but you can also choose how to compare sets by using the following `ISet` methods:
`equalItems`, `equalItemsAndConfig` and `same`.
Note, however, there is no `unorderedEqualItems` like in the `IList`, 
because since `ISets` are unordered the `equalItems` method already disregards the order.

- Classes `FromISetMixin` and `FromIterableISetMixin` let you easily 
create your own immutable classes based on the `ISet`.
This helps you create more strongly typed collections, 
and add your own methods to them.

- You can flush some `ISet` by using the getter `.flush`.
Note flush just optimizes the set **internally**, 
and no external difference will be visible.
Depending on the global configuration, the `ISet`s 
will flush automatically for you.  

- There are a few ways to lock and unlock a set, 
which will have different results in speed and safety.
Getter `lock` will create an internal defensive copy of the original set.
Getter `lockUnsafe` is fast, since it makes no defensive copies of the set.
Getter `unlock` unlocks the set, returning a regular (mutable, growable) set.
Getter `unlockView` unlocks the set, returning a safe, unmodifiable (immutable) set view.
And getter `unlockLazy` unlocks the set, returning a safe, modifiable (mutable) set.

    ```
    ISet<int> iset = {1, 2, 3}.lock;       // Safe
    ISet<int> iset = {1, 2, 3}.lockUnsafe; // Only this way to lock a set is dangerous
    Set<int> set = iset.unlock;            // Safe, mutable and unordered
    Set<int> set = iset.unlockSorted;      // Safe, mutable and ordered 
    Set<int> set = iset.unlockView;        // Safe, fast and immutable
    Set<int> set = iset.unlockLazy;        // Safe, fast and mutable
    ```                                                        

  
## 3.2. Global ISet Configuration

The **default** configuration of the `ISet` is `ConfigSet(isDeepEquals: true, sort: true, cacheHashCode: true)`:

1. `isDeepEquals: true` compares by deep equality: They are equal if they have the same items in the same order.

2. `sort: true` means `ISet.iterator`, and methods `ISet.toList`, `ISet.toIList` and `ISet.toSet`
   will return sorted outputs.

3. `cacheHashCode: true` means the hashCode is cached. It's not recommended to turn this cache off for sets.

You can globally change this default if you want, by using the `defaultConfig` setter:
`defaultConfig = ConfigSet(isDeepEquals: false, sort: false);`
                                                                        
Note that `ConfigSet` is similar to `ConfigList`, but it has the extra parameter `sort`:

```
/// Prints sorted: "1,2,3,4,9"
var iset = {2, 4, 1, 9, 3}.lock;  
print(iset.join(","));

/// Prints in any order: "2,4,1,9,3"
var iset = {2, 4, 1, 9, 3}.lock.withConfig(ConfigSet(sort: false));  
print(iset.join(","));
``` 
  
As previously discussed with the `IList`, 
the global configuration is meant to be decided during your app's initialization, and then not changed again.
We strongly suggest that you prohibit further changes to the global configuration by calling `ImmutableCollection.lockConfig();`
after you set your desired configuration.


# 4. IMap

An `IMap` is an immutable map, meaning once it's created it cannot be modified.
An `IMap` is always **unordered** 
(though, as we'll see, it can be automatically sorted when you use it).  

You can create an `IMap` by passing a regular map to its constructor, 
or you can simply "lock" a regular map. 
There are also a few other specialized constructors:  

```          
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

```  
/// Going back from IMap to Map
                 
IMap<String, int> imap = {"a": 1, "b": 2}.lock;
Map<String, int> map = imap.unlock; 
```             
                                                             
## 4.1. Similarities and Differences to the IList/ISet

Since I don't want to repeat myself, 
all the topics below are explained in much less detail here than for the IList.
Please read the IList explanation first, before trying to understand the IMap.

- Just like a regular map, an `IMap` is **not** an `Iterable`.
However, you can iterate over its entries, keys and values:

    ```               
    /// Unordered
    Iterable<MapEntry<K, V>> get entries;  
    Iterable<K> get keys;
    Iterable<V> get values;
    
    /// Ordered (or not, according to the configuration)
    IList<MapEntry<K, V>> entryList();
    IList<K> keyList();
    IList<V> valueList();                       
                 
    /// Unordered
    ISet<MapEntry<K, V>> entrySet();
    ISet<K> keySet();
    ISet<V> valueSet();
    
    /// Ordered (or not, according to the configuration)
    List<MapEntry<K, V>> toEntryList();
    List<K> toKeyList();
    List<V> toValueList();
    
    /// Ordered (or not, according to the configuration)
    Set<MapEntry<K, V>> toEntrySet();
    Set<K> toKeySet();
    Set<V> toValueSet();
                                                
    /// Ordered (or not, according to the configuration)
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
   
- To choose a configuration, you can use getters `withIdentityEquals` and `withDeepEquals`;
or else use the `withConfig` method and the `ConfigMap` class to change the configuration;
or else use the `withConfig` constructor to explicitly create the `IMap` with your desired configuration.
 
- The configuration affects how the `== operator` works, 
but you can also choose how to compare sets by using the following `IMap` methods:
`equalItems`, `equalItemsAndConfig`, `equalItemsToIMap` and `same`.
Note, however, there is no `unorderedEqualItems` like in the `IList`, 
because since `IMaps` are unordered the `equalItems` method already disregards the order.

- You can flush some `IMap` by using the getter `.flush`.
Note flush just optimizes the map **internally**, 
and no external difference will be visible.
Depending on the global configuration, the `IMap`s 
will flush automatically for you.  

- There are a few ways to lock and unlock a map, 
which will have different results in speed and safety.
Getter `lock` will create an internal defensive copy of the original map.
Getter `lockUnsafe` is fast, since it makes no defensive copies of the map.
Getter `unlock` unlocks the map, returning a regular (mutable, growable) set.
Getter `unlockView` unlocks the map, returning a safe, unmodifiable (immutable) map view.
And getter `unlockLazy` unlocks the map, returning a safe, modifiable (mutable) map.

    ```
    IMap<String, int> imap = {"a": 1, "b": 2}.lock;        // Safe
    IMap<String, int> imap = {"a": 1, "b": 2}.lockUnsafe;  // Only this way to lock a map is dangerous
  
    Map<String, int> set = imap.unlock;                    // Safe, mutable and unordered
    Map<String, int> set = imap.unlockSorted;              // Safe, mutable and ordered 
    Map<String, int> set = imap.unlockView;                // Safe, fast and immutable
    Map<String, int> set = imap.unlockLazy;                // Safe, fast and mutable
    ```                                                        

  
## 4.2. Global IMap Configuration

The **default** configuration of the `IMap` is 
`ConfigMap(isDeepEquals: true, sortKeys: true, sortValues: true)`:

1. `isDeepEquals: true` compares by deep equality: They are equal if they have the same entries in the same order.

2. `sortKeys: true` means `IMap.iterator`, and methods `IMap.entryList`, `IMap.keyList`, `IMap.toEntryList`,
`IMap.toKeyList`, `IMap.toEntrySet` and `IMap.toKeySet` will return sorted outputs.

3. `sortValues: true` means methods `IMap.valueList`, `IMap.toValueList`, and `IMap.toValueSet` 
will return sorted outputs.

4. `cacheHashCode: true` means the hashCode is cached. It's not recommended to turn this cache off for maps.

You can globally change this default if you want, by using the `defaultConfig` setter:
`defaultConfig = ConfigMap(isDeepEquals: false, sortKeys: false, sortValues: false);`
                                                                        
Note that `ConfigMap` is similar to `ConfigSet`, 
but has separate sort parameters for keys and values: `sortKeys` and `sortValues`:

```
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
by calling `ImmutableCollection.lockConfig();` after you set your desired configuration.


# 5. IMapOfSets

When you lock a `Map<K, V>` it turns into an `IMap<K, V>`.

However, a locked `Map<K, Set<V>>` turns into an `IMapOfSets<K, V>`.  
 
 ```
/// Map to IMap
IMap<K, V> map = {'a': 1, 'b': 2}.lock;

/// Map to IMapOfSets
IMapOfSets<K, V> map = {'a': {1, 2}, 'b': {3, 4}}.lock;
```

The `IMapOfSets` lets you add / remove **values**, 
without having to think about the **sets** that contain them.
For example:

 ```
IMapOfSets<K, V> map = {'a': {1, 2}, 'b': {3, 4}}.lock;

// Prints {'a': {1, 2, 3}, 'b': {3, 4}}
print(map.add('a', 3)); 
```
 

Suppose you want to create an immutable structure 
that lets you arrange `Student`s into `Course`s.
Each student can be enrolled into one or more courses. 

This can be modeled by a map where the keys are the courses, and the values are sets of students.

Implementing structures that **nest** immutable collections like this can be quite tricky.
That's where an `IMapOfSets` comes handy:

```
class StudentsPerCourse {
  final IMapOfSets<Course
  , Student> imap;

  StudentsPerCourse([Map<Course, Set<Student>> studentsPerCourse])
      : imap = (studentsPerCourse ?? {}).lock;

  StudentsPerCourse._(this.imap);

  ISet<Course> courses() => imap.keysAsSet;

  ISet<Student> students() => imap.valuesAsSet;

  IMapOfSets<Student, Course> getCoursesPerStudent() => imap.invertKeysAndValues();

  IList<Student> studentsInAlphabeticOrder() =>
      imap.valuesAsSet.toIList(compare: (s1, s2) => s1.name.compareTo(s2.name));

  IList<String> studentNamesInAlphabeticOrder() => imap.valuesAsSet.map((s) => s.name).toIList();

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

Note: The `IMapOfSets` configuration `ConfigMapOfSets.removeEmptySets` 
lets you choose if empty sets should be automatically removed or not.
In the above example, this would mean removing the course automatically when the last student leaves,
or else allowing courses with no students.

```
/// Using the default configuration: Empty sets are removed.
StudentsPerCourse([Map<Course, Set<Student>> studentsPerCourse])
   : imap = (studentsPerCourse ?? {}).lock;   

/// Specifying that a course can be empty (have no students).
StudentsPerCourse([Map<Course, Set<Student>> studentsPerCourse])
   : imap = (studentsPerCourse ?? {}).lock   
       .withConfig(ConfigMapOfSets(removeEmptySets: false));
```  
        
Note: A `MapOfSets` is an immutable <a href="https://en.wikipedia.org/wiki/Multimap">multimap</a>.
If you need it, <a href="https://pub.dev/packages/quiver">Quiver</a> provides a mutable multimap.
                                                                                                

# 6. Comparators

To help you sort collections, 
we provide the global comparator functions `compareObject`, `sortBy` and `sortLike`, 
as well as the `compareObjectTo` and `if0` extensions.
These make it easy for you to create other complex comparators,
as described below. 

## 6.1. CompareObject function

The `compareObject` function lets you easily compare `a` and `b`, as follows:

If `a` or `b` is `null`, the null one will come later (the default), 
unless the `nullsBefore` parameter is `true`, 
in which case the `null` one will come before.

If `a` and `b` are both of type `Comparable`, it compares them with their natural comparator.

If `a` and `b` are map-entries, it compares their keys first, and then, if necessary, their values. 

If `a` and `b` are booleans, it compares them such as `true > false`.

If all the above can't distinguish them, it will return `0` (which means unordered).

You can use the comparator in sorts:

```
// Results in: [1, 2, null]
[1, 2, null, 3].sort(compareObject);

// Results in: [null, 1, 2]
[1, 2, null, 3].sort((a, b) => compareObject(a, b, nullsBefore: true));
```             


## 6.2. CompareObjectTo extension

Beside the `compareObject` function above, 
you can also use the `compareObjectTo` extension.

For example: 
 
```
// Results in: [1, 2, null]
[1, 2, null, 3].sort((a, b) => a.compareObjectTo(b));

// Results in: [null, 1, 2]
[1, 2, null, 3].sort((a, b) => a.compareObjectTo(b, nullsBefore: true));
```              


## 6.3. SortBy function

The `sortBy` function lets you define a rule, 
and then possibly nest it with other rules with lower priority.
For example, suppose you have a list of numbers 
which you want to sort according to the following rules:

> 1. If present, number 14 is always the first, followed by number 15.
> 2. Otherwise, odd numbers come before even ones.
> 3. Otherwise, come numbers which are multiples of 3,
> 4. Otherwise, come numbers which are multiples of 5,
> 5. Otherwise, numbers come in their natural order.

You start by creating the first rule: `sortBy((x) => x == 15)` and
then nesting the next rule in the `then` parameter:
`sortBy((x) => x == 15, then: sortBy((x) => x % 2 == 1)`.

After all the rules are in place you have this: 

```
int Function(int, int) compareTo = sortBy((x) => x == 14,
   then: sortBy((x) => x == 15,
       then: sortBy((x) => x % 2 == 1,
           then: sortBy((x) => x % 3 == 0,
               then: sortBy((x) => x % 5 == 0,
                   then: (int a, int b) => a.compareTo(b),
               )))));
``` 


## 6.4. SortLike function

The `sortLike` function lets you define a list with the desired sort order. 
For example, if you want to sort numbers in this order: `[7, 3, 4, 21, 2]`
you can do it like this: `sortLike([7, 3, 4, 21, 2])`.

You can also nest other comparators, including mixing `sortBy` and `sortLike`.
For example, to implement the following rules:  

> 1. Order should be [7, 3, 4, 21, 2] when these values appear.
> 2. Otherwise, odd numbers come before even ones.
> 3. Otherwise, numbers come in their natural order.

```                  
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


## 6.5. if0 extension

The `if0` function lets you nest comparators.

You can think of `if0` as a "then",
so that these two comparators are equivalent:

```
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

```
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

# 7. Flushing 

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

```
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


## 7.1. Auto-flush      

Usually you don't need to flush your collections manually.
Depending on the global configuration, 
the collections will flush automatically for you.
The global configuration default is to have auto-flush on. It's easy to disable it:

```
ImmutableCollection.autoFlush = false;

// You can also lock further changes to the global configuration, if desired:                                              
ImmutableCollection.lockConfig();
```                                                    

If you leave it on, you can configure auto-flush to happen after you use a collection a few times.
And you can also configure it to flush at most once per asynchronous gap.   

Auto-flush is an advanced topic, 
and you don't need to read the following detailed explanation at all to use the immutable collections.
However, in case you want to tweak the auto-flush configuration, here it goes:

## 7.2. Sync Auto-flush

If your auto-flush is set to occur synchronously:

Each collection keeps a `counter` variable which starts at `0` 
and is incremented each time some collection methods are called. 
As soon as this counter reaches a certain value called the `flushFactor`, 
the collection is flushed.

## 7.3. Async Auto-flush

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

An example: 

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
However, note the process is very fast, using only simple integer operations and a few bytes of memory.
It guarantees that, if a collection is being used a lot, it will flush more often than one which is not being used that often.
It also guarantees a collection will not auto-flush in the middle of sync operations.
Finally, it saves no references to the collections, so it doesn't prevent them from being garbage collected.

If you think about the update/publish cycle of the `built_collections` package, 
it has an intermediate state (the builder) which is not a valid collection, 
and then you publish it manually.
In contrast, `fast_immutable_collections` does have a valid intermediate state (unflushed)
which you can use as a valid collection, 
and then it publishes automatically (flushes) after the async gap (when so configured).

As discussed, the default is to have auto-flush turned on, but you can turn it off. 
If you leave it on, you can tweak the `flushFactor` for lists, sets and maps. 
Usually, lists should have a higher `flushFactor` because they are generally still very efficient when unflushed.

The minimum `flushFactor` you can choose is `1`, which means the collections will always flush in the 
next async gap after they are touched.    

```
IList.flushFactor = 150;
ISet.flushFactor = 15;
IMap.flushFactor = 15;

// Lock further changes, if desired:                                              
ImmutableCollection.lockConfig();
```                                                    
    
# 8. About the Benchmarks

Having benchmarks for this project is essential to justifying its existence, after all, if it isn't faster or on par 
with competitors, there would be no point in creating/publishing this package. Luckily, that isn't the case.

The [`benchmark` package][benchmark] demonstrates that this package's collections are close to even its mutable 
counterparts, both under development and production environments.

You can either run the benchmarks:

- With pure Dart, through, for example:
    ```cmd
    dart benchmark/lib/src/benchmarks.dart
    ```
- Or with Flutter, by running the [example app][example].

You can find more info on the benchmarks, by reading [its documentation][benchmark_docs].


[benchmark]: benchmark/
[benchmark_docs]: benchmark/README.md
[example]: benchmark/example/

# 9. Other Resources & Documentation

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
                        
*************************

# Immutable Objects

Immutable objects are those that cannot be changed once created. A Dart `String` is a typical
example of a commonly used immutable objects.

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

# Should I use this package?

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

In the old days, studying the performance of code was more like physics or chemistry. You could
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

The immutable collections in fast_immutable_collections all use the simple approach of recording
changes, while periodically "flushing" them internally into regular mutable Dart collections and
hiding their mutability. This approach works well, and the benchmarks seem to indicate they improve
performance by an order of magnitude. However, the best possible approach would be to implement   
<a href="https://en.wikipedia.org/wiki/Hash_array_mapped_trie">hash array mapped tries</a> (HAMTs),
which are dedicated immutable structures that are not built on top of regular mutable collections.
The reason we did not use HAMTs is that it would be much more work, and also because I am unsure if
the results would be as good as expected. The reason is that regular Dart collections use "external"
code which is very fast, while HAMTs would be a completely separate implementation. So I believe
HAMT implementations should be created by the Dart team natively, in an effort to complement the
native Dart collections. In any case, there
are <a href="https://github.com/dart-lang/language/issues/117">discussions</a> to integrate
immutability into Dart itself, which could be used to improve our collections or create more
efficient ones. In any case, if and when better immutable collections arise, we'll run the
benchmarks, and if necessary switch the implementation so that the collections in this package keep
performing as well as possible.
                 
****************************
