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

- `IList` is an immutable list
- `ISet` is an immutable set
- `IMap` is an immutable map
- `IMapOfSets` is an immutable map of sets

**Fast Immutable Collections** is a competitor to the excellent
[built_collection][built_collection] and [kt_dart][kt_dart] packages, 
but it's much **easier** to use than the former, 
and orders of magnitude **faster** than the latter.

The reason it's easier than _built_collection_ is that there is no need for mutable/immutable cycles.
You just create your immutable collections and use them directly. 

The reason it's faster than _kt_dart_ is that it creates immutable collections by 
internally saving only the difference between each collection, 
instead of copying the whole collection each time.
This is transparent to the developer, which doesn't need to know about these implementation details. 
Later in this document, we provide benchmarks so that you can compare speeds
(and you can also run the benchmarks yourself).

<br />


[built_collection]: https://pub.dev/packages/built_collection
[kt_dart]: https://pub.dev/packages/kt_dart

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
  
### Global IList Configuration

As explained above, the **default** configuration of the `IList` is that it compares by 
deep equality: They are equal if they have the same items in the same order.

You can globally change this default if you want, by using the `defaultConfigList` setter:

```dart
var list = [1, 2];

/// The default is deep-equals.
var ilistA1 = IList(list);
var ilistA2 = IList(list);
print(ilistA1 == ilistA2); // True!

/// Now we change the default to identity-equals. 
/// This will affect lists created from now on.
defaultConfigList = ConfigList(isDeepEquals: false);
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


### Usage in tests

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

### IList reuse by composition

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

### Flushing the IList

As explained, `fast_immutable_collections` is fast because it creates a new collection 
by internally "composing" the source collection with some other information, 
saving only the difference between the source and destination collections, 
instead of copying the whole collection each time.

After a lot of modifications, 
these composed collections may end up with lots of information to coordinate the composition, 
and may become slower than a regular mutable collection.

The loss of speed depends on the type of collection. 
For example, the `IList` doesn't suffer much from deep compositions,
while the `ISet` and the `IMap` will take more of a hit.  

If you call `flush` in an immutable collection, 
it will internally remove all the composition,
making sure the is perfectly optimized again. For example:

```dart
var ilist = [1.2].lock.add([3, 4]).add(5);
ilist.flush;
```         

Please note, `flush` is a getter which returns the exact same instance, 
just so that you can chain other methods to it if you want. 
But it does NOT create a new list. 
It actually just optimizes the current list, internally.

If you flush a list which is already flushed, nothing will happen,
and it won't take any time to flush the list again.
So you don't need to worry about flushing the list more than once.

Also, note flush just optimizes the list **internally**, 
and no external difference will be visible. 
So, for all intents and purposes, you may consider that `flush` doesn't mutate the list.

#### Auto-flush      
  
Depending on the global configuration, 
the collections will flush automatically for you, 
once per asynchronous gap, as soon as you use them again.   

For example, suppose you take a collection and add and remove a lot of items, synchronously.
No flushing will take place during these process.
After the asynchronous gap, as soon as you try to get, add or remove an item from it,
it will flush automatically.  

The global configuration default is to have auto-flush on.


### Advanced usage

There are a few ways to lock and unlock a list, 
which will have different results in speed and safety.

Suppose you have some `List`.
These are your options to create an `IList` from it:

- `.lock` will create an internal defensive copy of the original list, 
which will be used to back the `IList`.
This is the same doing: `IList(list)`.

- `.lockUnsafe` is fast, since it makes no defensive copies of the list.
However, you should only use this with a new list you've created yourself,
when you are sure no external copies exist. If the original list is modified,
it will break the `IList` and any other derived lists in unpredictable ways.
Use this at your own peril. This is the same doing: `IList.unsafe(list)`.
Note you can optionally disallow unsafe constructors in the global configuration 
by doing: `disallowUnsafeConstructors = true` (and then optionally preventing 
further configuration changes by calling `lockConfig()`).                  

These are your options to obtain a regular `List` back from an `IList`:

- `.unlock` unlocks the list, returning a regular (mutable, growable) `List`.
This returned list is "safe", in the sense that is newly created, 
independent of the original `IList` or any other lists.

- `.unlockView` unlocks the list, returning a safe, unmodifiable (immutable) `List` view.
The word "view" means the list is backed by the original `IList`.
This is very fast, since it makes no copies of the `IList` items.
However, if you try to use methods that modify the list, like `add`,
it will throw an `UnsupportedError`.
It is also very fast to lock this list back into an `IList`.

- `unlockLazy` unlocks the list, returning a safe, modifiable (mutable) `List`.
Using this is very fast at first, since it makes no copies of the `IList` items. 
However, if (and only if) you use a method that mutates the list, like `add`, 
it will unlock it internally (make a copy of all `IList` items). 
This is transparent to you, and will happen at most only once. 
In other words, it will unlock the `IList` lazily, only if necessary.
If you never mutate the list, it will be very fast to lock this list
back into an `IList`.

# IMapOfSets

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
  StudentsPerCourse([Map<Course, Set<Student>> studentsPerCourse]) : _studentsPerCourse = (studentsPerCourse ?? {}).lock;
  StudentsPerCourse._(this._studentsPerCourse);
  ISet<Course> courses() => imap.keysAsSet;
  ISet<Student> students() => imap.valuesAsSet;
  IMapOfSets<Student, Course> getCoursesPerStudent() => imap.invertKeysAndValues();
  IList<Student> studentsInAlphabeticOrder() => imap.valuesAsSet.toIList(compare: (s1, s2) => s1.name.compareTo(s2.name));
  IList<String> studentNamesInAlphabeticOrder() => imap.valuesAsSet.map((s) => s.name).toIList();
  StudentsPerCourse addStudentToCourse(Student student, Course course) => StudentsPerCourse._(imap.add(course, student));
  StudentsPerCourse addStudentToCourses(Student student, Iterable<Course> courses) => StudentsPerCourse._(imap.addValuesToKeys(courses, [student]));
  StudentsPerCourse addStudentsToCourse(Iterable<Student> students, Course course) => StudentsPerCourse._(imap.addValues(course, students));
  StudentsPerCourse addStudentsToCourses(Map<Course, Set<Student>> studentsPerCourse) => StudentsPerCourse._(imap.addMap(studentsPerCourse));
  StudentsPerCourse removeStudentFromCourse(Student student, Course course) => StudentsPerCourse._(imap.remove(course, student));
  StudentsPerCourse removeStudentFromAllCourses(Student student) => StudentsPerCourse._(imap.removeValues([student]));
  StudentsPerCourse removeCourse(Course course) => StudentsPerCourse._(imap.removeSet(course));
  Map<Course, Set<Student>> toMap() => imap.unlock;
  int get numberOfCourses => imap.lengthOfKeys;  
  int get numberOfStudents => imap.lengthOfNonRepeatingValues;
}        
```

Note: The `IMapOfSets` configuration (`ConfigMapOfSets.allowEmptySets`) 
lets you choose if empty sets should be removed or not.
In the above example, this would mean having courses with no students, 
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
