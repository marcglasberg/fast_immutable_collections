<p align="center">
  <img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/logo.png" alt="Logo" />
</p>

<p align="center">
  <a href="https://pub.dartlang.org/packages/fast_immutable_collections"><img src="https://img.shields.io/pub/v/fast_immutable_collections.svg"></a>
  <a href="https://codecov.io/gh/marcglasberg/fast_immutable_collections/"><img src="https://codecov.io/gh/marcglasberg/fast_immutable_collections/branch/master/graphs/badge.svg" alt="Codecov.io Coverage" /></a>
</p>

---

# Fast Immutable Collections

> _This package is brought to you by <a href="https://github.com/psygo">Philippe Fanaro</a>, and
myself,
<a href="https://github.com/marcglasberg">Marcelo Glasberg</a>._
> The below documentation is very detailed. For an overview, go to my
> <a href="https://medium.com/flutter-community/announcing-fic-fast-immutable-collections-5eb091d1e31f">
> Medium story</a>.
> You may also check <a href="https://fanaro.io/articles/fic/fic.html">Philippe's article</a>.

> IntelliJ plugin that supports this package coming soon:<br>
<a href="https://plugins.jetbrains.com/files/21898/340924/icon/pluginIcon.svg"><img src="https://plugins.jetbrains.com/files/21898/340924/icon/pluginIcon.svg" height="20px" style="position: relative;top: 5px;"/>
https://plugins.jetbrains.com/plugin/21898-marcelo-s-flutter-dart-essentials
</a>

&nbsp;<br>

This package, called **FIC** for short, provides:

- `IList`, an immutable list
- `ISet`, an immutable set
- `IMap`, an immutable map
- `IMapOfSets`, an immutable map of sets (a multimap)
- Lock and unlock extensions, so you can easily transform mutable collections into immutable ones,
  and vice-versa. For example: `[1, 2].lock`
- Global and local configurations that alter how your immutable collections behave with respect to
  equality, sorting, caching, and flushing.
- Optional deep equalities and cached `hashCodes`, which let you treat your collections as
  value-objects
- Mixins for you to build your own immutable collections or objects
- View wrappers, so that you can work with immutable collection as if they were mutable

Other valuable features are:

- It's possible to create const `IList`, `ISet` and `IMap`.

- `ListSet`, a very efficient fixed-size mutable collection which is at the same time an
  ordered `Set` and a `List`.

- `ListMap`  is a mutable, fixed-sized, and ordered map which has some very efficient `List`
  methods, like `sort` and `shuffle`, and lets you efficiently read its information by index.

- General purpose extensions to the native collections: `List`, `Set`, `Map`. See
  classes `FicListExtension`, `FicSetExtension`, and `FicMapExtension`. For
  example: `[1, 2, 1].removeDuplicates()`

- Other extensions: `FicIterableExtension`, `FicIteratorExtension`, `FicMapIteratorExtension`,
  `FicComparatorExtension`, `FicComparableExtension` and `FicBooleanExtension`. For example:
  `false.compareTo(true)`

- Comparators and related helpers to be used with native or immutable collections, or any sort
  algorithms, such as `compareObject`, `sortBy`, `sortLike`, `if0`, in `sort.dart`.

<br>

**Fast Immutable Collections** is a competitor to the excellent
[built_collection][built_collection] and [kt_dart][kt_dart] packages, but it's much **easier** to
use than the former, and orders of magnitude **faster** than the latter.

The reason it's **easier** than [built_collection][built_collection]
is that there is no need for manual mutable/immutable cycles. You just create your immutable
collections and use them directly.

The reason it's **faster** than [kt_dart][kt_dart] is that it creates immutable collections by
internally saving only the difference between each collection, instead of copying the whole
collection each time. This is transparent to the developer, who doesn't need to know about these
implementation details. Later in this document, we provide benchmarks so that you can compare speeds
— and you can also run the benchmarks yourself.

<p align="center">
  <img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/demo.gif" alt="Benckmarks GIF" />
</p>

<p align="center">
  <sub>The <a href="https://github.com/marcglasberg/fast_immutable_collections/tree/master/example/benchmark/benchmark_app"><code>benchmark_app</code></a> compares FIC's performance to other packages &mdash; you might need to run it with <code>flutter run --no-sound-null-safety</code> since some of its dependencies haven't yet transitioned into NNBD.</sub>
</p>

[built_collection]: https://pub.dev/packages/built_collection

[kt_dart]: https://pub.dev/packages/kt_dart


<br />

---

**Table of Contents**

<div id="user-content-toc">
  <ul>
    <li>
      <a href="#fast-immutable-collections">1. Fast Immutable Collections</a>      
    </li>
    <li>
      <a href="#2-ilist">2. IList</a>
      <ul>
        <li><a href="#21-ilist-equality">2.1. IList Equality</a></li>
        <li><a href="#211-cached-hashcode">2.1.1 Cached HashCode</a></li>
        <li>
          <a href="#22-global-ilist-configuration"
            >2.2. Global IList Configuration</a
          >
        </li>
        <li><a href="#23-usage-in-tests">2.3. Usage in tests</a></li>
        <li>
          <a href="#24-ilist-reuse-by-composition"
            >2.4. IList reuse by composition</a
          >
        </li>
        <li><a href="#25-advanced-usage">2.5. Advanced usage</a></li>
        <li>
          <a href="#26-iterables-to-create-ilist-fields"
            >2.6. Iterables to create IList fields</a
          >
          <ul>
            <li>
              <a href="#261-forcing-non-default-configurations"
                >2.6.1. Forcing non-default configurations</a
              >
            </li>
            <li><a href="#262-copywith">2.6.2. copyWith</a></li>
            <li><a href="#263-nullable-fields">2.6.3. Nullable fields</a></li>
          </ul>
        </li>
      </ul>
    </li>
    <li>
      <a href="#3-iset">3. ISet</a>
      <ul>
        <li>
          <a href="#31-similarities-and-differences-to-the-ilist"
            >3.1. Similarities and Differences to the IList</a
          >
        </li>
        <li>
          <a href="#32-global-iset-configuration"
            >3.2. Global ISet Configuration</a
          >
        </li>
      </ul>
    </li>
    <li>
      <a href="#4-imap">4. IMap</a>
      <ul>
        <li>
          <a href="#41-similarities-and-differences-to-ilistiset"
            >4.1. Similarities and Differences to IList/ISet</a
          >
        </li>
        <li>
          <a href="#42-global-imap-configuration"
            >4.2. Global IMap Configuration</a
          >
        </li>
      </ul>
    </li>
    <li><a href="#5-imapofsets">5. IMapOfSets</a></li>
    <li><a href="#6-listset">6. ListSet</a></li>
    <li><a href="#7-listmap">7. ListMap</a></li>
    <li>
      <a href="#8-extensions-and-helpers">8. Extensions and Helpers</a>
      <ul>
        <li>
          <a href="#81-iterable-helpers-and-extensions"
            >8.1 Iterable Helpers and Extensions</a
          >
        </li>
        <li><a href="#82-list-extensions">8.2 List Extensions</a></li>
        <li><a href="#82-list-extensions-1">8.2 List Extensions</a></li>
        <li><a href="#83-iterator-extensions">8.3 Iterator Extensions</a></li>
        <li><a href="#84-boolean-extensions">8.4 Boolean Extensions</a></li>
      </ul>
    </li>
    <li>
      <a href="#9-comparators">9. Comparators</a>
      <ul>
        <li>
          <a href="#91-compareobject-function">9.1. CompareObject function</a>
        </li>
        <li>
          <a href="#92-compareobjectto-extension"
            >9.2. CompareObjectTo extension</a
          >
        </li>
        <li><a href="#93-sortby-function">9.3. SortBy function</a></li>
        <li><a href="#94-sortlike-function">9.4. SortLike function</a></li>
        <li><a href="#95-sortreversed-function">9.5. SortReversed function</a></li>
        <li><a href="#96-if0-extension">9.5. if0 extension</a></li>
      </ul>
    </li>
    <li>
      <a href="#10-flushing">10. Flushing</a>
      <ul>
        <li><a href="#101-auto-flush">10.1. Auto-Flush</a></li>                
      </ul>
    </li>
    <li><a href="#11-json-support">11. JSON Support</a></li>
    <li>
      <a href="#12-benchmarks">12. Benchmarks</a>
      <ul>
        <li>
          <a href="#121-list-benchmarks">12.1. List Benchmarks</a>
          <ul>
            <li><a href="#1211-list-add">12.1.1. List Add</a></li>
            <li><a href="#1212-list-addall">12.1.2. List AddAll</a></li>
            <li><a href="#1213-list-contains">12.1.3. List Contains</a></li>
            <li><a href="#1214-list-empty">12.1.4. List Empty</a></li>
            <li><a href="#1215-list-insert">12.1.5. List Insert</a></li>
            <li><a href="#1216-list-read">12.1.6. List Read</a></li>
            <li><a href="#1217-list-remove">12.1.7. List Remove</a></li>
          </ul>
        </li>
        <li>
          <a href="#122-map-benchmarks">12.2. Map Benchmarks</a>
          <ul>
            <li><a href="#1221-map-add">12.2.1. Map Add</a></li>
            <li><a href="#1222-map-addall">12.2.2. Map AddAll</a></li>
            <li>
              <a href="#1223-map-containsvalue">12.2.3. Map ContainsValue</a>
            </li>
            <li><a href="#1224-map-empty">12.2.4. Map Empty</a></li>
            <li><a href="#1225-map-read">12.2.5. Map Read</a></li>
            <li><a href="#1225-map-remove">12.2.5. Map Remove</a></li>
          </ul>
        </li>
        <li>
          <a href="#123-set-benchmarks">12.3. Set Benchmarks</a>
          <ul>
            <li><a href="#1225-set-add">12.2.5. Set Add</a></li>
            <li><a href="#1226-set-addall">12.2.6. Set AddAll</a></li>
            <li><a href="#1226-set-contains">12.2.6. Set Contains</a></li>
            <li><a href="#1226-set-empty">12.2.6. Set Empty</a></li>
            <li><a href="#1226-set-remove">12.2.6. Set Remove</a></li>
          </ul>
        </li>
      </ul>
    </li>
    <li>
      <a href="#13-immutable-objects">13. Immutable Objects</a>
      <ul>
        <li>
          <a href="#131-whats-the-difference-between-unmodifiable-and-immutable"
            >13.1. What&#39;s the difference between Unmodifiable and
            Immutable?</a
          >
        </li>
        <li><a href="#132-clean-code">13.2. Clean-code</a></li>
      </ul>
    </li>
    <li>
      <a href="#14-performance-and-memory-savings"
        >14. Performance and Memory Savings</a
      >
    </li>
    <li>
      <a
        href="#15-the-above-text-has-about-10-of-original-content-the-rest-is-shamelessly-copied-from-the-following-pages-please-visit-them"
        >15. The above text has about 10% of original content. The rest is
        shamelessly copied from the following pages. Please, visit them:</a
      >
    </li>
    <li>
      <a href="#16-should-i-use-this-package">16. Should I use this package?</a>
    </li>
    <li><a href="#17-implementation-details">17. Implementation details</a></li>
    <li>
      <a href="#18-bibliography">18. Bibliography</a>
      <ul>
        <li>
          <a href="#181-projects">18.1. Projects</a>
          <ul>
            <li><a href="#1811-dart">18.1.1. Dart</a></li>
            <li><a href="#1812-java">18.1.2. Java</a></li>
            <li><a href="#1813-js">18.1.3. JS</a></li>
          </ul>
        </li>
        <li><a href="#182-articles">18.2. Articles</a></li>
        <li><a href="#183-other-resources">18.3. Other Resources</a></li>
      </ul>
    </li>
    <li><a href="#19-thanks">19. Thanks</a></li>
  </ul>
</div>

---

# 2. IList

An `IList` is an immutable list, meaning once it's created it cannot be modified. You can create
an `IList` by passing an iterable to its constructor, or you can simply "lock" a regular list. Other
iterables (which are not lists) can also be locked as lists:

```
/// Ways to build an IList

// Using the IList constructor                                                                      
IList<String> ilist = IList([1, 2]);
                              
// Locking a regular list
IList<String> ilist = [1, 2].lock;
                          
// Locking a set as list
IList<String> ilist = {1, 2}.toIList();

// Creating an empty IList
IList<String> ilist = const IList.empty();
```

To create a regular `List` from an `IList`, you can use `List.of`, or simply "unlock" an immutable
list:

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

`IList` methods to add and remove items return a new `IList`, instead of modifying the original one.
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

Since `IList` methods always return a new `IList`, it is a **mistake** to call a method on it and
then discard the result:

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

`IList` has **all** the methods of `List`, plus some other new and useful ones. Those `List` methods
that return iterables also return iterables for the `IList`. You can turn an `Iterable` into
a `List` by calling `.toList()`, and into an `IList` by calling `.toIList()`. For example:

```
IList<int> ilist = ['Bob', 'Alice', 'Dominic', 'Carl'].lock   
   .sort() // Alice, Bob, Carl, Dominic
   .map((name) => name.length) // 5, 3, 4, 7
   .take(3) // 5, 3, 4
   .toIList()
   .sort() // 3, 4, 5
   .toggle(4) // 3, 5,
   .toggle(2); // 3, 5, 2;
```

The `replace` method is the equivalent of `operator []=` for the `IList`. For example:

```
IList<int> ilist = ['Bob', 'Alice', 'Dominic'].lock;

// Results in ['Bob', 'John', 'Dominic'] 
ilist = ilist.replace(1, 'John');     
```

The `replaceBy` method lets you define a function to transform an item at a specific index location.

## 2.1. Const IList

It's actually possible to create a const `IList`, but you must follow these rules:

1. Instantiate an `IListConst` (or use `IListConst.empty()`).
2. Explicitly assign it to an `IList`.
3. Use the const keyword.

Examples:

```
const IList<int> ilist1 = IList.empty();
const IList<int> ilist2 = IListConst([]);
const IList<int> ilist3 = IListConst([1, 2, 3]);
const IList<int> ilist4 = IListConst([1, 2], ConfigList(isDeepEquals: false));
```

If you don't follow the above rules, it may seem to work, but you will have problems later.
So, for example, those are wrong:

```
// Wrong: Not using the const keyword.
IList<int> ilist = IListConst([]);
IList<int> ilist = IList.empty();

// Wrong: Not explicitly assigning it to an `IList`.
const ilist = IListConst([]);
```

One other thing to keep in mind is that the `IListConst()` constructor always uses
`ConfigList(isDeepEquals: true, cacheHashCode: true)`, completely ignoring the global
`defaultConfig` (which will be explained below). This means if you want a specific a config you must
provide it in the constructor.

_Note: While the FIC collections are generally intuitive to use, the **const** `IList` is a bit
cumbersome to use, because of these rules you have to remember. Unfortunately it can't be avoided
because of the limitations of the Dart language._

## 2.1. IList Equality

By default, `IList`s are equal if they have the same items in the same order.

```
var ilist1 = [1, 2, 3].lock;
var ilist2 = [1, 2, 3].lock;
                                    
// False!
print(identical(ilist1, ilist2));
                         
// True!
print(ilist1 == ilist2);
```

This is in sharp contrast to regular `List`s, which are compared by identity:

```
var list1 = [1, 2, 3];
var list2 = [1, 2, 3];
                      
// Regular Lists compare by identity:
print(identical(ilist1, ilist2)); // False!
print(list1 == list2); // False!

// While ILists compare by deep equals:
print(list1.lock == list2.lock); // True!
```

This also means `IList`s can be used as **map keys**, which is a very useful property in itself, but
can also help when implementing some other interesting data structures. For example, to
implement **caches**:

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

However, `IList`s are configurable, and you can actually create `IList`s which compare their
internals by **identity**
or **deep equals**, as desired. There are 3 main ways to do it:

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

2. You can also use the `withConfig` method and the `ConfigList` class to change the configuration:

    ```
    var list = [1, 2];
    var ilist1 = list.lock.withConfig(ConfigList(isDeepEquals: true));
    var ilist2 = list.lock.withConfig(ConfigList(isDeepEquals: false));
    
    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
    ```

3. Or you can use the `withConfig` constructor to explicitly create the `IList` already with your
   desired configuration:

    ```
    var list = [1, 2];
    var ilist1 = IList.withConfig(list, ConfigList(isDeepEquals: true));
    var ilist2 = IList.withConfig(list, ConfigList(isDeepEquals: false));
    
    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
    ```

The above described configurations affect how the `== operator` works, but you can also choose how
to compare lists by using the following `IList` methods:

- `equalItems` will return true only if the IList items are equal to the iterable items, and in the
  same order. This may be slow for very large lists, since it compares each item, one by one. You
  can compare the list with ordered sets, but unordered sets will throw an error.

- `unorderedEqualItems` will return true only if the IList and the iterable items have the same
  number of elements, and the elements of the IList can be paired with the elements of the iterable,
  so that each pair is equal. This may be slow for very large lists, since it compares each item,
  one by one.

- `equalItemsAndConfig` will return true only if the list items are equal and in the same order, and
  the list configurations are equal. This may be slow for very large lists, since it compares each
  item, one by one.

- `same` will return true only if the lists internals are the same instances
  (comparing by identity). This will be fast even for very large lists, since it doesn't compare
  each item. Note: This is not the same as `identical(list1, list2)` since it doesn't compare the
  lists themselves, but their internal state. Comparing the internal state is better, because it
  will return `true` more often.

## 2.1.1 Cached HashCode

By default, the hashCode of `IList` and the other immutable collections is **cached** once
calculated.

This not only speeds up the use of these collections inside of sets and maps, but it also speeds up
their deep equals. The reason is simple: Two equal objects always have the same hashCode. So, if the
cashed hashCode of two immutable collections are not the same, we know the collections are
different, and there is no need to check each collection item, one by one.

However, this only works if the collections are really _immutable_, and not simply _unmodifiable_.
If you put modifiable objects into an `IList` and then later modify those objects, this breaks the
immutability of the `IList`, which then becomes simply unmodifiable.

In other words, even if you can't change which objects the list contains, if the objects themselves
will be changed, then the hashCode must not be cached. Therefore, if you intend on using the `IList`
to hold modifiable objects, you should think about turning off the hashCode cache. For example:

```
var ilist1 = [1, 2].lock.withConfig(ConfigList(cacheHashCode: false));
var ilist2 = IList.withConfig([1, 2], ConfigList(cacheHashCode: false));
```

Note: Modifying mutable objects in a collection could only make sense for lists anyway, since lists
don't rely on the equality and hashCode of their items to structure themselves. If objects are
modified after you put them into both mutable or immutable sets and maps, this most likely breaks
the sets/maps they belong to.

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

The global configuration is meant to be decided during your app's initialization, and then not
changed again. We strongly suggest that you prohibit further changes to the global configuration by
calling `ImmutableCollection.lockConfig();`
after you set your desired configuration.

## 2.3. Usage in tests

An `IList` is not a `List`, so this is false:

```
[1, 2] == [1, 2].lock // False!
```

However, when you are writing tests, the `expect` method actually compares all `Iterables` by
comparing their items. Since `List` and `IList` are iterables, you can write the following tests:

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

If you ask me, this is all very confusing. A good rule of thumb to avoid all these `expect`
complexities is only comparing lists to lists, sets to sets, etc.

## 2.4. IList reuse by composition

Classes `FromIListMixin` and `FromIterableIListMixin` let you easily create your own immutable
classes based on the `IList`. This helps you create more strongly typed collections, and add your
own methods to them.

For example, suppose you have a `Student` class:

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

And suppose you want to create a `Students` class which is an immutable collection of `Student`s.

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

And then use it like this:

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

There are a few aspects of native Dart collection mixins which I don't like, so I've tried to
improve on those here.

- First is that some Dart mixins let you create inefficient methods
  (like fore example, a `length` getter which has to iterate through all items to yield a result).
  All mixins within **FIC** are as efficient as the underlying immutable collection, so you don't
  need to worry about this problem.

- Second is that the native Dart mixins implement their respective collections. For example,
  a `ListMixin`
  implements `List`. I don't think this is desirable. For example, should a `Students`
  class be an `IList` by default? I don't think so. For this reason, the `FromIListMixin` is not
  called `IListMixin`, and it does not implement `IList` nor `Iterable`.

- Third, unfortunately, the `expect` method in tests compares iterables by comparing their items.
  So, if the `Students`
  class were to implement `Iterable`, the `expect` method would completely ignore its
  `operator ==`, which probably is not what you want.

Note, you can still iterate through the `Students` class in the example by calling `.iter` on it:

```
for (Student student in students.iter) { ... }
```

And also, if you really do want it to implement `Iterable`, you can do so by explicitly declaring
it:

```
class Students with FromIListMixin<Student, Students> implements Iterable<Student> { ... }

class Students with FromIterableIListMixin<Student> implements Iterable<Student> { ... }
```

Please refer to the `FromIListMixin`'s and `FromIterableIListMixin`'s own documentation to learn how
to use these mixins in detail.

## 2.5. Advanced usage

There are a few ways to lock and unlock a list, which will have different results in speed and
safety.

```
IList<int> ilist = [1, 2, 3].lock;       // Safe
IList<int> ilist = [1, 2, 3].lockUnsafe; // Unsafe, fast

List<int> list = ilist.unlock;           // Safe and mutable
List<int> list = ilist.unlockView;       // Safe, fast and immutable
List<int> list = ilist.unlockLazy;       // Safe, fast and mutable
```

Suppose you have a `List`. These are your options to create an `IList` from it:

- Getter `lock` will create an internal defensive copy of the original list, which will be used to
  back the `IList`. This is the same as doing: `IList(list)`.

- Getter `lockUnsafe` is fast, since it makes no defensive copies of the list. However, you should
  only use this with a new list you've created yourself, when you are sure no external copies exist.
  If the original list is modified, it will break the `IList` and any other derived lists in
  unpredictable ways. Use this at your own peril. This is the same as doing: `IList.unsafe(list)`.
  Note you can optionally disallow unsafe constructors in the global configuration by
  doing: `disallowUnsafeConstructors = true` — and then optionally prevent further configuration
  changes by calling `ImmutableCollection.lockConfig()`.

These are your options to obtain a regular `List` back from an `IList`:

- Getter `unlock` unlocks the list, returning a regular (mutable, growable) `List`. This returned
  list is "safe", in the sense that is newly created, independent of the original `IList` or any
  other lists.

- Getter `unlockView` unlocks the list, returning a safe, unmodifiable (immutable) `List` view. The
  word "view" means the list is backed by the original `IList`. This is very fast, since it makes no
  copies of the `IList` items. However, if you try to use methods that modify the list, like `add`,
  it will throw an `UnsupportedError`. It is also very fast to lock this list back into an `IList`.

- Getter `unlockLazy` unlocks the list, returning a safe, modifiable (mutable) `List`. Using this is
  very fast at first, since it makes no copies of the `IList` items. However, if (and only if) you
  use a method that mutates the list, like `add`, it will unlock it internally (make a copy of
  all `IList` items). This is transparent to you, and will happen at most only once. In other words,
  it will unlock the `IList` lazily, only if necessary. If you never mutate the list, it will be
  very fast to lock this list back into an `IList`.

## 2.6. Iterables to create IList fields

If you have a class that has an `IList` field, you may be tempted to accept an `IList` in its
constructor:

```
class Students {
   final IList<String> names;   
   Students(this.names);
}
```

However, it's more flexible if you allow for any `Iterable` in the constructor:

```
class Students {
   final IList<String> names;   
   Students(Iterable<String> names) : names = IList(names);
}
```

Note, this constructor is very fast, because `IList(names)` will return the same `names` instance
if `names` is already an `IList`.

### 2.6.1. Forcing non-default configurations

This can also be used to enforce custom **configurations**. For example:

```
class Students {
   static const config = ConfigList(isDeepEquals: false);  
   final IList<String> names;
      
   Students(Iterable<String> names) : 
      names = IList.withConfig(names, config);
}
```

The above code guarantees the `names` field will have the desired `ConfigList` configuration. Note,
this constructor is still very fast, because `IList(names)` will return the same `names` instance
if `names` is already an `IList` with the correct configuration. It will only create a new `IList`
if `names` is not an `IList`
or if it is but the configuration is different.

### 2.6.2. copyWith

The `IList.orNull()` factory is useful if you want your `copyWith()` method to accept `Iterable`s.
For example :

```
class Students {
   static const config = ConfigList(isDeepEquals: false);  
   final IList<String> names;
      
   Students(Iterable<String>? names) : 
      names = IList.withConfig(names, config);
   
   Students copyWith({Iterable<String>? names}) => 
      Students(names: IList.orNull(names) ?? this.names);
}
```

### 2.6.3. Nullable fields

In case your `names` field is a nullable `IList`, you can use the `IList.orNull()` factory in your
class constructor:

```
class Students {
   static const config = ConfigList(isDeepEquals: false);  
   final IList<String>? names;
      
   Students(Iterable<String>? names) : 
      names = IList.orNull(names, config);
}
```

# 3. ISet

An `ISet` is an immutable set, meaning once it's created it cannot be modified. An `ISet` may keep
the insertion order, or it may be sorted, depending on its configuration.

You can create an `ISet` by passing an iterable to its constructor, or you can simply "lock" a
regular set. Other iterables (which are not sets) can also be locked as sets:

```
/// Ways to build an ISet

// Using the ISet constructor                                                                      
ISet<String> iset = ISet({1, 2});
                              
// Locking a regular set
ISet<String> iset = {1, 2}.lock;
                          
// Locking a list as set
ISet<String> iset = [1, 2].toISet();

// Creating an empty ISet
ISet<String> iset = const ISet.empty();
```

To create a regular `Set` from an `ISet`, you can use `Set.of`, or simply "unlock" an immutable set:

```
/// Going back from ISet to Set
                 
var iset = {1, 2}.lock;
                                    
// Using Set.of                                  
Set<String> set = Set.of(iset);                               
                                  
// Is the same as unlocking the ISet
Set<String> set = iset.unlock; 
```

## 3.1. Const ISet

It's actually possible to create a const `ISet`, but you must follow these rules:

1. Instantiate an `ISetConst` (or use `ISet.empty()`).
2. Explicitly assign it to an `ISet`.
3. Use the const keyword.
4. You can only create a sorted set (`ConfigSet(sort: true)`) if the set is empty.

Examples:

```
const ISet<int> iset1 = ISet.empty();
const ISet<int> iset2 = ISetConst({});
const ISet<int> iset3 = ISetConst({1, 2, 3});
const ISet<int> iset4 = ISetConst({1, 2}, ConfigSet(isDeepEquals: false));
const ISet<int> iset5 = ISetConst({}, ConfigSet(sort: true));
```

If you don't follow the above rules, it may seem to work, but you will have problems later. So, for
example, those are wrong:

```
// Wrong: Not using the const keyword.
ISet<int> iset = ISetConst({});
ISet<int> iset = ISet.empty();

// Wrong: Not explicitly assigning it to an `ISet`.
const iset = ISetConst({});

// Wrong: Const sorted set is not empty.
const ISet<int> iset = ISetConst({1, 2}, ConfigSet(sort: true));
```

The reason you can't have a non-empty const set is that we can't sort it in the constructor (
since it's constant). If you try to create a non-empty const set it will seem to work, but will
throw an error when you try to use it.

One other thing to keep in mind is that the `ISetConst()` constructor always uses
`ConfigSet(isDeepEquals: true, sort: false, cacheHashCode: true)`, completely ignoring the global
`defaultConfig` (which will be explained below). This means if you want a specific a config you must
provide it in the constructor.

_Note: While the FIC collections are generally intuitive to use, the **const** `ISet` is a bit
cumbersome to use, because of these rules you have to remember. Unfortunately it can't be avoided
because of the limitations of the Dart language._

## 3.1. Similarities and Differences to the IList

Since I don't want to repeat myself, all the topics below are explained in much less detail here
than for `IList`. Please read the `IList` explanation first, before trying to understand `ISet`.

- An `ISet` is an `Iterable`, so you can iterate over it.

- `ISet` has **all** the methods of `Set`, plus some other new and useful ones.
  `ISet` methods to add or remove items return a new `ISet`, instead of modifying the original one.
  Because of that, you can easily chain methods. But since `ISet` methods return a new `ISet`, it is
  an **error** to call a method on it and then discard the result.

- `ISet`s with "deep equals" configuration are equal if they have the same items in **any** order.
  They can be used as **map keys**, which is a very useful property in itself, but can also help
  when implementing some other interesting data structures.

- However, `ISet`s are configurable, and you can actually create `ISet`s which compare their
  internals by identity or deep equals, as desired.

- To choose a configuration, you can use getters `withIdentityEquals` and `withDeepEquals`; or else
  use the `withConfig`
  method and the `ConfigSet` class to change the configuration; or else use the `withConfig`
  constructor to explicitly create the `ISet` with your desired configuration.

- The configuration affects how the `== operator` works, but you can also choose how to compare sets
  by using the following `ISet` methods:
  `equalItems`, `equalItemsAndConfig` and `same`. Note, however, there is no `unorderedEqualItems`
  like in the `IList`, because since `ISets` are unordered the `equalItems` method already
  disregards the order.

- Classes `FromISetMixin` and `FromIterableISetMixin` let you easily create your own immutable
  classes based on the `ISet`. This helps you create more strongly typed collections, and add your
  own methods to them.

- You can flush an `ISet` by using the getter `.flush`. Note flush just optimizes the
  set **internally**, and no external difference will be visible. Depending on the global
  configuration, the `ISet`s will flush automatically for you.

- There are a few ways to lock and unlock a set, which will have different results in speed and
  safety. Getter `lock`
  will create an internal defensive copy of the original set. Getter `lockUnsafe` is fast, since it
  makes no defensive copies of the set. Getter `unlock`
  unlocks the set, returning a regular (mutable, growable) set. Getter `unlockView` unlocks the set,
  returning a safe, unmodifiable (immutable) set view. And getter `unlockLazy` unlocks the set,
  returning a safe, modifiable (mutable)
  set.

    ```
    ISet<int> iset = {1, 2, 3}.lock;       // Safe, immutable
    ISet<int> iset = {1, 2, 3}.lockUnsafe; // Unsafe, fast
    Set<int> set = iset.unlock;            // Safe, mutable, defensive copy
    Set<int> set = iset.unlockView;        // Safe, fast and immutable
    Set<int> set = iset.unlockLazy;        // Safe, fast and mutable
    ```

## 3.2. Global ISet Configuration

The **default** configuration of the `ISet`
is `ConfigSet(isDeepEquals: true, sort: false, cacheHashCode: true)`:

1. `isDeepEquals: true` compares by deep equality: They are equal if they have the same items in the
   same order.

2. `sort: false` means it keeps insertion order. But `sort: true` means it will iterate in sorted
   order.

3. `cacheHashCode: true` means the hashCode is cached. It's not recommended turning this cache off
   for sets.

You can globally change this default if you want, by using the `defaultConfig` setter:
`defaultConfig = ConfigSet(isDeepEquals: false, sort: true, cacheHashCode: false);`.

Note that `ConfigSet` is similar to `ConfigList`, but it has the extra parameter `sort`:

```
/// The default is to use insertion order. Prints: "2,4,1,9,3"
var iset = {2, 4, 1, 9, 3}.lock;  
print(iset.join(","));

/// Prints sorted: "1,2,3,4,9"
var iset = {2, 4, 1, 9, 3}.lock.withConfig(ConfigSet(sort: true));  
print(iset.join(","));
```

As previously discussed with the `IList`, the global configuration is meant to be decided during
your app's initialization, and then not changed ever again. We strongly suggest you prohibit further
changes to the global configuration by calling `ImmutableCollection.lockConfig();`
after you set your desired configuration.

# 4. IMap

An `IMap` is an immutable map, meaning once it's created it cannot be modified. An `IMap` may keep
the insertion order, or it may be sorted, depending on its configuration.

You can create an `IMap` by passing a regular map to its constructor, or you can simply "lock" a
regular map. There are also a few other specialized constructors:

```
/// Ways to build an IMap

// Using the IMap constructor                                                                      
IMap<String, int> imap = IMap({"a": 1, "b": 2});
                              
// Locking a regular map
IMap<String, int> imap = {"a": 1, "b": 2}.lock;
                          
// From map entries
IMap<String, int> imap = IMap.fromEntries([MapEntry("a", 1), MapEntry("b", 2)]);

// Creating an empty IMap
IMap<String> imap = const IMap.empty();

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

## 4.1. Similarities and Differences to IList/ISet

Since I don't want to repeat myself, all the topics below are explained in much less detail here
than for IList. Please read the IList explanation first, before trying to understand IMap.

- Just like a regular map, an `IMap` is **not** an `Iterable`. However, you can iterate over its
  entries, keys and values:

    ```
    /// To Iterable (lazy)
    Iterable<MapEntry<K, V>> get entries;  
    Iterable<K> get keys;
    Iterable<V> get values;
    
    /// To IList
    IList<MapEntry<K, V>> toEntryIList();
    IList<K> toKeyIList();
    IList<V> toValueIList();                       
                 
    /// To ISet
    ISet<MapEntry<K, V>> toEntryISet();
    ISet<K> toKeyISet();
    ISet<V> toValueISet();
    
    /// To List
    List<MapEntry<K, V>> toEntryList();
    List<K> toKeyList();
    List<V> toValueList();
    
    /// To Set
    Set<MapEntry<K, V>> toEntrySet();
    Set<K> toKeySet();
    Set<V> toValueSet();
                                                
    /// To Iterator
    Iterator<MapEntry<K, V>> get iterator;                     
    ```

- `IMap` has **all** the methods of `Map`, plus some other new and useful ones.
  `IMap` methods to add and remove entries return a new `IMap`, instead of modifying the original
  one. Because of that, you can easily chain methods. But since `IMap` methods return a new `IMap`,
  it is an **error** to call some method and then discard the result.

- `IMap`s with "deep equals" configuration are equal if they have the same entries in **any** order.
  These maps can be used as **map keys** themselves.

- However, `IMap`s are configurable, and you can actually create `IMap`s which compare their
  internals by identity or deep equals, as desired.

- To choose a configuration, you can use getters `withIdentityEquals` and `withDeepEquals`; or else
  use the `withConfig`
  method and the `ConfigMap` class to change the configuration; or else use the `withConfig`
  constructor to explicitly create the `IMap` with your desired configuration.

- The configuration affects how the `== operator` works, but you can also choose how to compare sets
  by using the following `IMap` methods:
  `equalItems`, `equalItemsAndConfig`, `unorderedEqualItems`, `equalItemsToIMap` and `same`.

- You can flush an `IMap` by using the getter `.flush`. Note flush just optimizes the
  map **internally**, and no external difference will be visible. Depending on the global
  configuration, the `IMap`s will flush automatically for you.

- There are a few ways to lock and unlock a map, which will have different results in speed and
  safety. Getter `lock`
  will create an internal defensive copy of the original map. Getter `lockUnsafe` is fast, since it
  makes no defensive copies of the map. Getter `unlock`
  unlocks the map, returning a regular (mutable, growable) set. Getter `unlockView` unlocks the map,
  returning a safe, unmodifiable (immutable) map view. And getter `unlockLazy` unlocks the map,
  returning a safe, modifiable (mutable)
  map.

    ```
    IMap<String, int> imap = {"a": 1, "b": 2}.lock;        // Safe
    IMap<String, int> imap = {"a": 1, "b": 2}.lockUnsafe;  // Unsafe and fast
  
    Map<String, int> set = imap.unlock;                    // Safe, mutable and unordered
    Map<String, int> set = imap.unlockSorted;              // Safe, mutable and ordered 
    Map<String, int> set = imap.unlockView;                // Safe, fast and immutable
    Map<String, int> set = imap.unlockLazy;                // Safe, fast and mutable
    ```

## 4.1.2. Const IMap

It's actually possible to create a const `IMap`, but you must follow these rules:

1. Instantiate an `IMapConst` (or use `IMap.empty()`).
2. Explicitly assign it to an `IMap`.
3. Use the const keyword.
4. You can only create a sorted map (`ConfigMap(sort: true)`) if the map is empty.

Examples:

```
const IMap<String, int> imap1 = IMap.empty();
const IMap<String, int> imap2 = IMapConst({});
const IMap<String, int> imap3 = IMapConst({'a': 1, 'b':2});
const IMap<String, int> imap4 = IMapConst({'a': 1, 'b':2}, ConfigMap(isDeepEquals: false));
const IMap<String, int> imap5 = IMapConst({}, ConfigMap(sort: true));
```

If you don't follow the above rules, it may seem to work, but you will have problems later.
So, for example, those are wrong:

```
// Wrong: Not using the const keyword.
IMap<String, int> imap = IMapConst({});
IMap<String, int> imap = IMap.empty();

// Wrong: Not explicitly assigning it to an `IMap`.
const imap = IMapConst({});

// Wrong: Const sorted map is not empty.
const IMap<int> imap = IMapConst({1, 2}, ConfigMap(sort: true));
```

The reason you can't have a non-empty const map is that we can't sort it in the constructor
(since it's constant). If you try to create a non-empty const map it will seem to work, but will
throw an error when you try to use it.

One other thing to keep in mind is that the `IMapConst()` constructor always uses
`ConfigMap(isDeepEquals: true, sort: false, cacheHashCode: true)`, completely ignoring the global
`defaultConfig` (which will be explained below). This means if you want a specific a config you 
must provide it in the constructor.

_Note: While the FIC collections are generally intuitive to use, the **const** `IMap` is a bit
cumbersome to use, because of these rules you have to remember. Unfortunately it can't be avoided
because of the limitations of the Dart language._

## 4.2. Global IMap Configuration

The **default** configuration of the `IMap`
is `ConfigMap(isDeepEquals: true, sort: false, cacheHashCode: true)`:

1. `isDeepEquals: true` compares by deep equality: They are equal if they have the same entries in
   the same order.

2. `sort: false` means it keeps insertion order, while `sort: true` means it will sort by keys.

3. `cacheHashCode: true` means the `hashCode` is cached. It's not recommended turning this cache off
   for maps.

You can globally change this default if you want, by using the `defaultConfig` setter:
`defaultConfig = ConfigMap(isDeepEquals: false, sort: true, cacheHashCode: false);`

```
/// Prints sorted: "1,2,4,9"
var imap = {2: "a", 4: "x", 1: "z", 9: "k"}.lock;  
print(imap.keyList.join(","));

/// Prints in any order: "2,4,1,9"
var imap = {2: "a", 4: "x", 1: "z", 9: "k"}.lock.withConfig(ConfigMap(sort: false));  
print(imap.keyList.join(","));
```

As previously discussed with `IList` and `ISet`, the global configuration is meant to be decided
during your app's initialization, and then not changed again. We strongly suggest that you prohibit
further changes to the global configuration by calling `ImmutableCollection.lockConfig();` after you
set your desired configuration.

# 5. IMapOfSets

When you lock a `Map<K, V>` it turns into an `IMap<K, V>`.

However, a locked `Map<K, Set<V>>` turns into an `IMapOfSets<K, V>`.

```
/// Map to IMap
IMap<K, V> map = {'a': 1, 'b': 2}.lock;

/// Map to IMapOfSets
IMapOfSets<K, V> map = {'a': {1, 2}, 'b': {3, 4}}.lock;
```

A "map of sets" is a type of **<a href="https://en.wikipedia.org/wiki/Multimap">multimap</a>**.
The `IMapOfSets` lets you add and remove **values**, without having to think about the **sets** that
contain them. For example:

```
IMapOfSets<K, V> map = {'a': {1, 2}, 'b': {3, 4}}.lock;

// Prints {'a': {1, 2, 3}, 'b': {3, 4}}
print(map.add('a', 3)); 
```

Suppose you want to create an immutable structure that lets you arrange `Student`s into `Course`s.
Each student can be enrolled into one or more courses.

This can be modeled by a map where the keys are the courses, and the values are sets of students.

Implementing structures that **nest** immutable collections like this can be quite tricky and
error-prone. That's where an `IMapOfSets`
comes handy:

```
class StudentsPerCourse {
  final IMapOfSets<Course, Student> imap;

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
lets you choose if empty sets should be automatically removed or not. In the above example, this
would mean removing the course automatically when the last student leaves, or else allowing courses
with no students.

```
/// Using the default configuration: Empty sets are removed.
StudentsPerCourse([Map<Course, Set<Student>> studentsPerCourse])
   : imap = (studentsPerCourse ?? {}).lock;   

/// Specifying that a course can be empty (have no students).
StudentsPerCourse([Map<Course, Set<Student>> studentsPerCourse])
   : imap = (studentsPerCourse ?? {}).lock   
       .withConfig(ConfigMapOfSets(removeEmptySets: false));
```

Note: The `IMapOfSets` is an immutable multimap. If you need a mutable one, check the
<a href="https://pub.dev/packages/quiver">Quiver</a> package.

## 5.1. Const IMapOfSets

It's actually possible to create a const `IMapOfSets`, but you must follow these rules:

1. Instantiate an `IMapOfSetsConst`.
2. Explicitly assign it to an `IMapOfSets`.
3. Use the const keyword.
4. You can only create a map with sorted keys or values (`ConfigMapOfSets(sortKeys: true)`
   or `ConfigMapOfSets(sortValues: true)`) if the map is empty.
5. Your map values can't be empty sets, unless your config
   is `ConfigMapOfSets(removeEmptySets: false)`.

Examples:

```
const IMap<String, int> imap1 = IMapOfSetsConst(IMapConst({'a': ISetConst({1, 2})}));
const IMap<String, int> imap2 = IMapOfSetsConst(IMapConst({}));
const IMap<String, int> imap3 = IMapOfSetsConst(IMapConst({'a': ISetConst({})}, ConfigMapIfSets(removeEmptySets: false));
const IMap<String, int> imap4 = IMapOfSetsConst(IMapConst({}), ConfigMapIfSets(sortKeys: true));
```

If you don't follow the above rules, it may seem to work, but you will have problems later. So, for
example, those are wrong:

```
// Wrong: Not using the const keyword.
IMapOfSets<int> imapOfSets = IMapOfSetsConst({});

// Wrong: Not explicitly assigning it to an `IMapOfSets`.
const imapOfSets = IMapOfSetsConst({});
```

One other thing to keep in mind is that the `IMapOfSetsConst()` constructor always uses
`ConfigMapOfSets(isDeepEquals = true, sortKeys = false, sortValues = false, removeEmptySets = true, cacheHashCode = true,)`
, completely ignoring the global `defaultConfig`. This means if you want a specific a config you
must provide it in the constructor.

_Note: While the FIC collections are generally intuitive to use, the **const** `IMapOfSets` is a bit
cumbersome to use, because of these rules you have to remember. Unfortunately it can't be avoided
because of the limitations of the Dart language._

# 6. ListSet

A `ListSet` is, at the same time:

1. A mutable, fixed-sized, ordered, `Set`.
2. A mutable, fixed-sized, `List`, in which values can't repeat.

```
ListSet<int> listSet = ListSet.of([1, 2, 3]);
expect(listSet[2], 3);
expect(listSet.contains(2), isTrue);

List<int> list = listSet;
Set<int> set = listSet;

expect(list[2], 3);
expect(set.contains(2), isTrue);
```

When viewed as a `Set` and compared to a `LinkedHashSet`, a `ListSet` is also ordered and has a
similar performance. But a `ListSet` takes less memory and can be sorted or otherwise rearranged,
just like a list. Also, you can directly get its items by index, very efficiently (constant time).

The disadvantage, of course, is that `ListSet` has a fixed size, while a `LinkedHashSet` does not.
The `ListSet` is efficient both as a `List` and as a `Set`. So, for example, it has an
efficient `sort` method, while a `LinkedHashSet` would force you to turn it into a `List`, then sort
it, then turn it back into a `Set`.

# 7. ListMap

A `ListMap`  is a mutable, fixed-sized, and ordered map.

Compared to a `LinkedHashMap`, a `ListMap` is also ordered, has a slightly worse performance, but
uses less memory. It is not a `List`, but has some very efficient list methods, like `sort` and
`shuffle`.

Also, you can efficiently read its information by index, by using the `entryAt`, `keyAt`
and `valueAt` methods. The disadvantage, of course, is that `ListMap` has a fixed size, while
a `LinkedHashMap` does not.

# 8. Extensions and Helpers

These are some provided helpers and extensions:

## 8.1 Iterable Extensions and Helpers

* `whereNotNull` is similar to `.where((x) => x != null)`, but the returned iterable has a
  non-nullable type. (Note: This has been removed from FIC, because it's now present in package
  `collection` provided by the Dart team).

* `mapNotNull` is similar to map, but the returned iterable has a non-nullable type.

* `combineIterables` is a top-level function that combines two iterables into one, by applying
  a `combine` function.

* `Iterable.deepEquals` compare all items, in order, using `operator ==`.

* `Iterable.deepEqualsByIdentity` compare all items, in order, using `identical`.

* `Iterable.sumBy()` calculates the sum of the values returned by a `mapper` function.

* `Iterable.averageBy()` calculates the average of the values returned by a `mapper` function.

* `Iterable.restrict()` restricts some item to one of those present in this iterable.

* `Iterable.findDuplicates` finds duplicates and then returns a set with the duplicated elements.

* `Iterable.everyIs` returns true if all items are equal to some value.

* `Iterable.anyIs` returns true if any item is equal to some value.

* `Iterable.removeNulls` removes `null`s from the iterable.

* `Iterable.whereNoDuplicates` removes all duplicates. Optionally, you can provide an `by` function
  to compare the items. If you pass `removeNulls` true, it will also remove the nulls.

* `Iterable.sortedLike` returns a list, sorted according to the order specified by the ordering
  iterable. Items which don't appear in the ordering iterable will be included in the end.

* `Iterable.sortedReversed` returns a reversed sorted list of the elements of the iterable. Note
  that `Iterable.sorted` can be found in `package:collection/collection.dart`.

* `Iterable.updateById` returns a new list where new items are added or updated, by their id.

* `Iterable.isFirst`, `isNotFirst`, `isLast` and `isNotLast` return true if the given item is the
  same (by identity) as the first/last/not-first/not-last of the items. This is useful for
  non-indexed loops where you need to know when you have the given item.

* `Iterable.as` and `asSet` return a List or Set containing the elements of the iterable.
  If the Iterable is already a List/Set, return the same instance (nothing new is created).
  Otherwise, create a new List/Set from it.

## 8.2 List extensions

* `get` returns the index-th element. If index is out of range, will call `orElse` (not throw an
  error).

* `getOrNull` returns the index-th element. If index is out of range, will return `null` (not throw
  an error).

* `getAndMap` gets the index-th element, and then apply the `map` function to it.

* `List.sortOrdered` is similar to `sort`, but uses
  a [merge sort algorithm](https://en.wikipedia.org/wiki/Merge_sort). Contrary to `sort`,
  `orderedSort` is stable, meaning distinct objects that compare as equal end up in the same order
  as they started in.

* `List.sortLike` sorts this list according to the order specified by an `ordering` iterable. Items
  which don't appear in `ordering` will be included in the end, in no particular order.

* `List.sortReversed` sorts this list in reverse order in relation to the default sort method.

* `List.moveToTheFront` moves the first occurrence of the item to the start of the list.

* `List.moveToTheEnd` moves the first occurrence of the item to the end of the list.

* `List.whereMoveToTheFront` moves all items that satisfy the provided test to the start of the
  list.

* `List.whereMoveToTheEnd` moves all items that satisfy the provided test to the end of the list.

* `List.toggle` If the item does not exist in the list, add it and return `true`. If it already
  exists, remove the first instance of it and return `false`.

* `List.compareAsSets` returns `true` if the lists contain the same items (in any order). Ignores
  repeated items.

* `List.splitList` splits a list, according to a predicate, removing the list item that satisfies
  the predicate.

* `List.divideList` Search a list for items that satisfy a test predicate (matching items), and then
  divide that list into parts, such as each part contains one matching item. Except maybe for the
  first matching item, it will keep the matching items as the first item in each part.

* `List.divideListAsMap` searches a list for items that satisfy a test predicate (matching items),
  and then divide that list into a map of parts, such as each part contains one matching item, and
  the keys are given by the key function.

* `List.addBetween` return a new list, adding a separator between the original list items.

* `List.concat` returns an efficient concatenation of up to 5 lists

* `List.splitByLength` cuts the original list into one or more lists with at most `length` items.

* `List.distinct` removes all duplicates, leaving only the distinct items.

* `List.reversedView` returns a list of the objects in this list, in reverse order.

* `List.removeDuplicates` removes all duplicates (mutates the list). Optionally, you can provide
  an `by` function to compare the items. If you pass `removeNulls` true, it will also remove the
  nulls.

* `List.removeNulls` removes all nulls from the list (mutates the list).

* `List.withNullsRemoved` returns a new list with all nulls removed (does not mutate the original
  list). This may return a list with a non-nullable type.

## 8.3 Set extensions

* `Set.toggle` If the item doesn't exist in the set, add it and return `true`. Otherwise, if the
  item already exists in the set, remove it and return `false`.

* `Set.removeNulls` removes all `null`s from the Set.

* `Set.diffAndIntersect` finds diffs and intersections between sets.

## 8.3 Map extensions

* `Map.mapTo` Returns a new lazy Iterable with elements that are created by calling a mapper
  function.

## 8.4 Iterator Extensions

* `toIterable`, `toList`, `toSet`, `toIList`, and `toISet` convert the iterator into an
  `Iterable`, `List`, `Set`, `IList`, and `ISet`, respectively.

## 8.5 Boolean Extensions

* `compareTo` makes `true` > `false`.

## 8.6 Object extensions

* `isOfExactGenericType` checks if some object in the format "Obj<T>" has a generic type T.

* `isOfExactGenericTypeAs` checks if some object in the format "Obj1<T>" has a generic type equal
  to "Obj2<T>".

# 9. Comparators

To help you sort collections (from FIC or any other), we provide the global comparator
functions `compareObject`, `sortBy`, `sortLike` and `sortReversed`, as well as the `compareObjectTo`
and `if0` extensions. These make it easy for you to create other complex comparators, as described
below.

## 9.1. CompareObject function

The `compareObject` function lets you easily compare `a` and `b`, as follows:

- If `a` or `b` is `null`, the null one will come later (the default), unless the `nullsBefore`
  parameter is `true`, in which case the `null` one will come before.

- If `a` and `b` are both of type `Comparable`, it compares them with their natural comparator.

- If `a` and `b` are map-entries, it compares their keys first, and then, if necessary, their
  values.

- If `a` and `b` are booleans, it compares them such as `true > false`.

- If all the above can't distinguish them, it will return `0` (which means unordered).

You can use the comparator in sorts:

```
// Results in: [1, 2, null]
[1, 2, null, 3].sort(compareObject);

// Results in: [null, 1, 2]
[1, 2, null, 3].sort((a, b) => compareObject(a, b, nullsBefore: true));
```

## 9.2. CompareObjectTo extension

Besides the `compareObject` function above, you can also use the `compareObjectTo` extension.

For example:

```
// Results in: [1, 2, null]
[1, 2, null, 3].sort((a, b) => a.compareObjectTo(b));

// Results in: [null, 1, 2]
[1, 2, null, 3].sort((a, b) => a.compareObjectTo(b, nullsBefore: true));
```

## 9.3. SortBy function

The `sortBy` function lets you define a rule, and then possibly nest it with other rules with lower
priority. For example, suppose you have a list of numbers which you want to sort according to the
following rules:

> 1. If present, number 14 is always the first, followed by number 15.
> 2. Otherwise, odd numbers come before even ones.
> 3. Otherwise, come numbers which are multiples of 3,
> 4. Otherwise, come numbers which are multiples of 5,
> 5. Otherwise, numbers come in their natural order.

You start by creating the first rule: `sortBy((x) => x == 15)` and then nesting the next rule in
the `then` parameter:
`sortBy((x) => x == 15, then: sortBy((x) => x % 2 == 1)`.

After all the rules are in place you have this:

```
int Function(int, int) compareTo = sortBy((x) => x == 14, then: sortBy((x) => x == 15, then:
sortBy((x) => x % 2 == 1, then: sortBy((x) => x % 3 == 0, then: sortBy((x) => x % 5 == 0, then: (int
a, int b) => a.compareTo(b),
)))));
```

## 9.4. SortLike function

The `sortLike` function lets you define a list with the desired sort order. For example, if you want
to sort numbers in this order: `[7, 3, 4, 21, 2]`
you can do it like this: `sortLike([7, 3, 4, 21, 2])`.

You can also nest other comparators, including mixing `sortBy` and `sortLike`. For example, to
implement the following rules:

> 1. Order should be `[7, 3, 4, 21, 2]` when these values appear.
> 2. Otherwise, odd numbers come before even ones.
> 3. Otherwise, numbers come in their natural order.

```
int Function(int, int) compareTo = sortLike([7, 3, 4, 21, 2], then: sortBy((x) => x % 2 == 1,
then: (int a, int b) => a.compareTo(b),
));
```

Important: When nested comparators are used, make sure you don't create inconsistencies. For
example, a rule that states `a < b then a > c then b < c`
may result in different orders for the same items depending on their initial position. This also
means inconsistent rules may not be followed precisely.

Please note, your order list may be of a different type than the values you are sorting. If this is
the case, you can provide a `mapper` function, to convert the values into the `order` type. See
the [`sort_test.dart`][sort_test]
file for more information and runnable examples.

[sort_test]: https://github.com/marcglasberg/fast_immutable_collections/tree/master/test/base/sort_test.dart

## 9.5. SortReversed function

The `sortReversed` function sorts this list in reverse order in relation to the default `sort`
method.

## 9.6. if0 extension

The `if0` function lets you nest comparators.

You can think of `if0` as a "then", so that these two comparators are equivalent:

```
/// This:
var compareTo = (String a, String b)
=> a.length.compareTo(b.length).if0(a.compareTo(b));

/// Is the same as this:
var compareTo = (String a, String b) { int result = a.length.compareTo(b.length); if (result == 0)
result = a.compareTo(b); return result; }
```

Examples:

```
var list = ["aaa", "ccc", "b", "c", "bbb", "a", "aa", "bb", "cc"];

/// Example 1. /// String come in their natural order. var compareTo = (String a, String b) =>
a.compareTo(b); list.sort(compareTo); expect(
list, ["a", "aa", "aaa", "b", "bb", "bbb", "c", "cc", "ccc"]);

/// Example 2. /// Strings are ordered according to their length. /// Otherwise, they come in their
natural order. compareTo = (String a, String b) => a.length.compareTo(b.length).if0(a.compareTo(b));
list.sort(compareTo); expect(list, ["a", "b", "c", "aa", "bb", "cc", "aaa", "bbb", "ccc"]);

/// Example 3. /// Strings are ordered according to their length. /// Otherwise, they come in their
natural order, inverted. compareTo = (String a, String b) => a.length.compareTo(b.length).if0(
-a.compareTo(b)); list.sort(compareTo); expect(
list, ["c", "b", "a", "cc", "bb", "aa", "ccc", "bbb", "aaa"]);
```

# 10. Flushing

As explained above, **FIC** is fast because it creates a new collection by internally "composing"
the source collection with some other information, saving only the difference between the source and
destination collections, instead of copying the whole collection each time.

After a lot of modifications, these composed collections may end up with lots of information to
coordinate the composition, and may become slower than a regular mutable collection.

The loss of speed depends on the type of collection. For example, `IList` doesn't suffer much from
deep compositions, while `ISet` and `IMap` will take more of a hit.

If you call `flush` on an immutable collection, it will internally remove all the composition,
making sure it is perfectly optimized again. For example:

```
var ilist = [1.2].lock.add([3, 4]).add(5); ilist.flush;
```

Please note, `flush` is a getter which returns the exact same instance, just so you can chain other
methods on it, if you wish. But it does NOT create a new list. It actually just optimizes the
current list, internally.

If you flush a list which is already flushed, nothing will happen, and it won't take any time to
flush the list again. So you don't need to worry about flushing the list more than once.

Also, note that flushing just optimizes the list **internally**, and no external difference will be
visible. So, for all intents and purposes, you may consider that `flush` doesn't mutate the list.

## 10.1. Auto-Flush

Usually you don't need to flush your collections manually. Depending on the global configuration,
the collections will flush automatically for you. The global configuration default is to have
auto-flush on. It's easy to disable it (not recommended):

```
ImmutableCollection.autoFlush = false;

// You can also lock further changes to the global configuration, if desired:                                              
ImmutableCollection.lockConfig();
```

If you think about the update/publish cycle of the `built_collections` package, it has an
intermediate state (the builder) which is not a valid collection, and then you publish it manually.
In contrast, **FIC** *does* have a valid intermediate state (unflushed) which you can use as a valid
collection, and then it publishes automatically (flushes) after some use.

You can configure auto-flush to happen after you use a collection a few times.

You don't need to read the following detailed explanation at all to use the immutable collections.
However, in case you want to tweak the auto-flush configuration, here it goes:

Each collection keeps a `counter` variable which starts at `0` and is incremented each time some
collection methods are called. As soon as this counter reaches a certain value called the
`flushFactor`, the collection is flushed. You can tweak the `flushFactor` for lists, sets and maps,
separately. Usually, lists should have a higher `flushFactor` because they are generally still very
efficient when unflushed. The minimum `flushFactor` you can choose is `1`, which means the
collections will flush almost always when they are changed.

```
IList.flushFactor = 500;
ISet.flushFactor = 50;
IMap.flushFactor = 50;

// Lock further changes, if desired:                                              
ImmutableCollection.lockConfig();
```

# 11. JSON Support

With some help from <a href="https://github.com/knaeckeKami">Martin Kamleithner</a> and
<a href="https://github.com/rrousselGit">Remi Rousselet</a>, now most FIC collections convert to and
from Json, through `.fromJson()` and `.toJson()`.

This means those FIC collections can be used with
<a href="https://pub.dev/packages/json_serializable">json_serializable</a> in classes annotated
with `@JsonSerializable`.

For example:

```
@JsonSerializable()
class MyClass {
  final IList<String> myList;
  MyClass(this.myList);
  factory MyClass.fromJson(Map<String, dynamic> json) => _$MyClassFromJson(json);
  Map<String, dynamic> toJson() => _$MyClassToJson(this);
}
```

# 12. Benchmarks

Having benchmarks for this project is necessary for justifying its existence.
The [`benchmark` package][benchmark] — and its companion app [benchmark_app][benchmark_app] —
demonstrates that FIC immutable collections perform similarly to even its mutable counterparts in
many operations.

You can either run the benchmarks:

- With pure Dart, through, for example:
    ```
    dart benchmark/lib/src/benchmarks.dart
    ```
- Or with Flutter, by running the [benchmark_app][benchmark_app].

You can find more info on the benchmarks, by reading [its documentation][benchmark_docs].

Note: The benchmarks cover what we have done so far, which are the most common operations. There are
many collection operations within **FIC** which are not yet made as efficient as they can. Most of
these corresponding methods are marked with `// TODO: Still needs to implement efficiently` and will
be updated in future versions.

[benchmark]: https://github.com/marcglasberg/fast_immutable_collections/tree/master/example/benchmark

[benchmark_docs]: https://github.com/marcglasberg/fast_immutable_collections/blob/master/example/benchmark/README.md

<br>

**Benchmarks Results**

Run the benchmarks preferably in *release mode*, and a green message on the snackbar will then
appear:

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/Example%20Run.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/FIC%20Opening.png" height="500px"/>

### 12.1. List Benchmarks

#### 12.1.1. List Add

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/list_add_1k.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/list_add_10k.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/list_add_100k.png" height="500px"/>

<br />
<br />

If you wish to use larger parameters, you can modify them in the [benchmark_app][benchmark_app]
project.

<br />
<br />

#### 12.1.2. List AddAll

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/list_addAll_10k.png" height="500px"/>

#### 12.1.3. List Contains

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/list_contains_10k.png" height="500px"/>

#### 12.1.4. List Empty

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/list_empty.png" height="500px"/>

#### 12.1.5. List Insert

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/list_insert_1k.png" height="500px"/>

*Note: We haven't implemented the fast code for list inserts yet. When we do, it will become faster
than the mutable List insert.*

#### 12.1.6. List Read

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/list_read_100k.png" height="500px"/>

#### 12.1.7. List Remove

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/list_remove_10k.png" height="500px"/>

### 12.2. Map Benchmarks

#### 12.2.1. Map Add

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/map_add_10.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/map_add_1k.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/map_add_10k.png" height="500px"/>

#### 12.2.2. Map AddAll

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/map_addAll_100k.png" height="500px"/>

#### 12.2.3. Map ContainsValue

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/map_containsValue_10k.png" height="500px"/>

#### 12.2.4. Map Empty

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/map_empty.png" height="500px"/>

#### 12.2.5. Map Read

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/map_read_100k.png" height="500px"/>

#### 12.2.5. Map Remove

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/map_remove_100k.png" height="500px"/>

### 12.3. Set Benchmarks

#### 12.2.5. Set Add

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_add_10.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_add_1k.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_add_10k.png" height="500px"/>

#### 12.2.6. Set AddAll

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_addAll_10k.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_addAll_100k.png" height="500px"/>

#### 12.2.6. Set Contains

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_contains_1k.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_contains_10k.png" height="500px"/>

#### 12.2.6. Set Empty

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_empty.png" height="500px"/>

#### 12.2.6. Set Remove

<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_remove_100.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_remove_1k.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_remove_10k.png" height="500px"/>
<img src="https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/benchmark_screenshots/set_remove_100k.png" height="500px"/>

---

# 13. Immutable Objects

Immutable objects are those that cannot be changed once created. A Dart `String` is a typical
example of a commonly used immutable object.

To create an immutable object **in Dart** you must follow these 5 rules:

1. Make all immutable fields `final` or private, so that they cannot be changed.

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
like Redux — and I have developed this package mainly to use it with my
own <a href="https://pub.dev/packages/async_redux">Async Redux</a>. But the co-author of the present
package, <a href="https://github.com/psygo">Philippe Fanaro</a> likes
using <a href="https://bloclibrary.dev/">BLoC</a> with immutable state. All state management
solutions in Flutter can benefit from making your state immutable. Your widgets subscribe to data
objects throughout your application. If those objects are mutable, and if your widgets mutate them,
this creates opportunities for areas of your application to get out of sync with each other. If
those objects are immutable, since they can't change, subscribing to changes throughout the model is
a dead-end, and new data can only ever be passed from above. In other words, immutability can be
used to enforce boundaries between layers of abstractions. Typically, on the bottom-most layer of
your application, where you will find data-value objects, as long as the object exists, its data is
permanent and should not be changed.

<br>

## 13.1. What's the difference between Unmodifiable and Immutable?

Doesn't <a href="https://api.dart.dev/stable/2.10.4/dart-core/List/List.unmodifiable.html">
`List.unmodifiable()`</a>
create an immutable list?

It is a misconception that immutability is just the absence of something: take a list, remove the
mutating code, and you've got an immutable list. But that's not how it works. If we simply remove
mutating methods from `List`, we end up with a list that is read-only. Or, as we can call it,
an **unmodifiable list**. It can still change under you, it's just that you won't be the one
changing it.
Immutability, as a feature, is not an absence of mutation, it's a **guarantee** that there won't be
mutation. A feature isn't necessarily something you can use to do good, it may also be the promise
that something bad won't happen.

In Dart's `List.unmodifiable()` case, it actually
<a href="https://stackoverflow.com/questions/50311900/in-dart-does-list-unmodifiable-create-an-unmodifiable-view-or-a-whole-new-in">
creates a defensive copy</a>, so the resulting list is in fact immutable, though performance will be
bad. However, it does have the mutating methods, only that they will throw an error if used. Ideally
you don't want mutable methods to appear in front of the programmer if the object is supposed
to **not** change, it will inevitably result in more confusion and debugging. All in all, this
constructor is basically an unfortunate workaround when it comes to the language design.

If you pass around an **unmodifiable list**, other code that accepts a `List` can't assume it's
immutable. There are now, in fact, more ways to fail, because calling any mutating method of an
unmodifiable list will throw an error. So it makes it harder to reason about the code, not easier.
For clean-code reasons what is needed is a **different type**, one that guarantees the object can't
be mutated. That's why `IList` does not extend `List`.

## 13.2. Clean-code

Late in the evening, exhausted and frustrated you find out that the people who implemented

```
int computeLength(Map<String, dynamic> responseMap)
```

got the great idea, that, instead of just computing the response length, they also
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

# 14. Performance and Memory Savings

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
  the inequality is determined very quickly. In contrast, when comparing two collections
  with **reference equality**, only the references to memory need to be compared, which has an O(1)
  time complexity.

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
  supposed to know it changed? It has a reference to the original list, now mutated. There is no way
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
  but you must discard the cached value as soon as a mutating method is called. Also, once you have
  cached `hashCode`s you can use them to speed up equality comparisons, since (by the `hashCode`'s
  definition) two collections with different `hashCode`s are always different.

* In Flutter, when deciding if you should rebuild a widget or not, there are performance tradeoffs
  between value equality and identity equality. For example, if you use an immutable collection and
  it has not been mutated, then it is equal by identity (which is a very cheap comparison). On the
  other hand, when it's not equal by identity this does not rule out the possibility that they may
  be value-equal. But in practice, when possible, **FIC** avoids creating new objects for updates
  where no change in value occurred. For this reason, if some state and its next state are immutable
  collections not equal by identity, they are almost certainly NOT value-equal, otherwise why would
  you have mutated the collection to begin with? If you are ok with doing some rare unnecessary
  rebuilds, you can decide whether to rebuild the widget without having to compare each item of the
  collections.

* Caching can speed things up significantly. But how do you cache results of a function?

  ```
  List findSuspiciousEntries(List<Map> entries)
  ```

  One possible workaround would be to JSONize entries to `String` and use such string as a hashing
  key. However, it's much more elegant, safe, performant and memory-wise with immutable structures.
  If the function parameters are all immutable and equal by identity (which is a very cheap
  comparison) you can return the cached value.

# 15. The above text has about 10% of original content. The rest is shamelessly copied from the following pages. Please, visit them:

* <a href="https://medium.com/dartlang/darts-built-collection-for-immutable-collections-db662f705eff">
  built_collection</a>
* <a href="https://github.com/immutable-js/immutable-js">immutable-js</a>
* <a href="https://hypirion.com/musings/understanding-persistent-vector-pt-1">Understanding
  Clojure's Persistent Vectors</a>
* <a href="https://github.com/vacuumlabs/persistent">Vacuumlabs: Efficient Persistent Data
  Structures</a>
* <a href="https://groups.google.com/g/guava-discuss/c/hfyhraawwUc?pli=1">Performance of immutable
  collections</a>
* <a href="https://tinyurl.com/javaPracticesCom" original="www.javapractices.com/topic/TopicAction.do?Id=29">
  Java Practices: Immutable objects</a>
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

# 16. Should I use this package?

The performance differences discussed above are nearly always dwarfed by bigger concerns like I/O,
memory leaks, algorithms of the wrong Big-O complexity, sheer coding errors, failure to properly
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

Our [benchmarks][benchmark] try to give a first approximation on the speed of our collections, but
as discussed those results may not be as meaningful to you under all circumstances. That said, we're
trying to do it anyway. One thing is for sure, though:
in terms of architecture, immutability beats mutability any day of the week. Even if few people will
try to convince you to switch to the immutable collections for the performance gains, the main
reason to use them is readability, maintainability, and general sanity. It will remove distractions
and leave you more energy for creativity and problem-solving. And for that you need a package, since
it offers you a low-cost way of using immutability at the bottom-most layer of your program: it's
not always easy to create immutable data structures by hand in a compact, maintainable ways.

The immutable collections in **FIC** all use the simple approach of recording changes, while
periodically "flushing"
them internally into regular mutable Dart collections and hiding their mutability. This approach
works well, and the benchmarks seem to indicate they improve performance by an order of magnitude.
However, the best possible approach would be to
implement <a href="https://en.wikipedia.org/wiki/Hash_array_mapped_trie">hash array mapped
tries</a> (HAMTs), which are dedicated immutable structures that are not built on top of regular
mutable collections. The reason we did not use HAMTs is that it would be much more work, and also
because I am unsure if the results would be as good as expected. The reason is that regular Dart
collections use "external"
code which is very fast, while HAMTs would be a completely separate implementation. So I believe
HAMT implementations should be created by the Dart team natively, in an effort to complement the
native Dart collections. In any case, there
are <a href="https://github.com/dart-lang/language/issues/117">discussions</a> to integrate
immutability into Dart itself, which could be used to improve our collections or create more
efficient ones. In any case, if and when better immutable collections arise, we'll run the
benchmarks again, and if necessary switch the implementation so that the collections in this package
keep performing as well as possible.

# 17. Implementation details

I haven't been able to check the source code of the native Dart collections, but I am assuming here
they work similarly to their corresponding Java collections of the same name. A `HashMap` has no
fixed order of elements. To add order to it, an internal linked list is used, thus creating
a `LinkedHashMap`. In other words, a `LinkedHashMap` has both a `HashMap`
and a linked-list, internally. In fact, even though we just iterate the map in ascending order, it
has to maintain a DOUBLY-linked list, so that elements can be removed from it.

Note a linked-list is only necessary because the `LinkedHashMap` can change size. For an *immutable*
map, we could keep its order by maintaining a `HashMap` and a regular `List` with fixed size (an
array-list). This not only saves a lot of memory, but it also lets us access items by index.

Regarding a `LinkedHashSet`, it is just basically a `LinkedHashMap` whose value is ignored (the set
items are stored as the map keys).

With the goal of allowing the `ISet` to be both sorted and insertion-ordered (depending on its
configuration), we have developed the `ListSet` class in this package, which has both a `HashMap`
and an **array-list**, internally (not a linked-list). The `ListSet` is used internally by
the `ISet`. An analogous data structure for maps was also created, called `ListMap`.

* [Java `LinkedHashSet`][java_linkedHashSet]
* [Java `LinkedHashMap` implementation details][java_linkedHashMap]
* [Java `LinkedHashSet` implementation details][java_linkedHashSet_details]

[java_linkedHashSet]: https://docs.oracle.com/javase/7/docs/api/java/util/LinkedHashSet.html

[java_linkedHashMap]: https://www.geeksforgeeks.org/linkedhashmap-class-java-examples/

[java_linkedHashSet_details]: https://javaconceptoftheday.com/how-linkedhashset-works-internally-in-java/

***************************

# 18. Bibliography

## 18.1. Projects

### 18.1.1. Dart

1. [persistent][persistent_dart]

- They've implemented *operators* for all the objects, something which converges to the assumption
  that immutable objects should be treated just like values.
- It depends on Dart `>=0.8.10+6 <2.0.0`. It's old enough so that *typing* is very weak throughout
  the package. So a major refactor would be necessary in order to use it with more recent versions
  of Dart, which would be very costly, given the complexity of the package.

1. [kt.dart][kt_dart]

- Follows Kotlin conventions.
- Doesn't use a persistent data structure.
- Not that many worries about speed.
- Featured some interesting annotations that became unnecessary after NNBD.

1. [built_collection][built_collection]

- Each of the core SDK collections is split into two: a mutable builder class and an
  immutable "built" class. Builders are for computation, "built" classes are for safely sharing with
  no need of a defensive copy.
- Uses the [Builder Pattern][builder_pattern], which simplifies the creation of objects, and even
  allows for lazy optimizations.
- Uses (deep) hash codes.
- (...) do not make a copy, but return a copy-on-write wrapper.

1. [Rémi Rousselet's Example Gist of Performance Testing in Dart][remi_performance_testing_dart]

- Uses the official package for benchmarking, [`benchmark_harness`][benchmark_harness].

1. [Make it easy/efficient to create immutable collections via literals][dart_lang_117]

- Nice overview of the different types of "immutable" definitions.
- Good idea to simplify the use of unmodifiable data types.

1. [Dart should provide a — standard — way of combining hashes][dart_lang_11617]

- Nice discussion on the — very surprising — absence of basic good hashing methods inside Dart's
  basic packages.

1. [Dart's Immutable Collections' Feature Specification][dart_immutable_feature_spec]

- Dart apparently already has plans of incorporating immutable objects. The question is how long
  will they take to make it happen?

[benchmark_harness]: https://pub.dev/packages/benchmark_harness

[builder_pattern]: https://en.wikipedia.org/wiki/Builder_pattern

[built_collection]: https://github.com/google/built_collection.dart

[dart_immutable_feature_spec]: https://github.com/dart-lang/language/blob/master/working/0125-static-immutability/feature-specification.md

[dart_lang_117]: https://github.com/dart-lang/language/issues/117

[dart_lang_11617]: https://github.com/dart-lang/sdk/issues/11617

[kt_dart]: https://github.com/passsy/kt.dart

[persistent_dart]: https://github.com/vacuumlabs/persistent

[remi_performance_testing_dart]: https://gist.github.com/rrousselGit/5a047bd4ec36515a4cfcc6bd275f05f5

### 18.1.2. Java

1. [Dexx][dexx]

- Port of Scala's immutable, persistent collections to Java and Kotlin.
- [Class Hierarchy][dexx_class_hierarchy]
- Interesting feature: Explore annotating methods that return a new collection
  with `@CheckReturnValue` to allow static verification of collection usage.

1. [Paguro][paguro]

- Immutable Collections and Functional Transformations for the JVM.
- Inspired by Clojure — which is built on top of the Java platform.
- Is based on the question-discussion — mentioned in the next section
  —: [Why doesn't Java 8 include immutable collections?][why_no_immutable_on_java_8]

1. Brian Burton's [Java Immutable Collections][java_immutable_collections]

- [Comparative Performance of Java Immutable Collections][performance_java_immutable]
    - The real questions are: how much faster are mutable collections and will you really notice the
      difference? Based on benchmark runs a `JImmutableHashMap` is about 2-3 times slower than a
      `HashMap` but is about 1.5x faster than a `TreeMap`. Unless your application spends most of
      its time CPU bound updating collections you generally won't notice much of a difference using
      an immutable collection.
- [List Tutorial][java_immutable_collections_list_tutorial]
    - The current implementation uses a balanced binary tree with leaf nodes containing up to 64
      values each which provides `O(log2(n))` performance for all operations.

[dexx]: https://github.com/andrewoma/dexx

[dexx_class_hierarchy]: https://github.com/andrewoma/dexx/raw/master/docs/dexxcollections.png

[java_immutable_collections]: https://github.com/brianburton/java-immutable-collections

[java_immutable_collections_list_tutorial]: https://github.com/brianburton/java-immutable-collections/wiki/List-Tutorial

[paguro]: https://github.com/GlenKPeterson/Paguro

[performance_java_immutable]: https://github.com/brianburton/java-immutable-collections/wiki/Comparative-Performance

### 18.1.3. JS

1. [immutable-js][immutable_js]

- Immutable data cannot be changed once created, leading to much simpler application development, no
  defensive copying, and enabling advanced memoization and change detection techniques with simple
  logic. Persistent data presents a mutative API which does not update the data in-place, but
  instead always yields new updated data.
- Alan Kay: The last thing you wanted any programmer to do is mess with internal state even if
  presented figuratively. It is unfortunate that much of what is called "object-oriented
  programming" today is simply old style programming with fancier constructs.
    - [React.js Conf 2015 &ndash; Immutable Data and React][immutable_data_react_lecture]
- These data structures are highly efficient on modern JavaScript VMs by using structural sharing
  via hash maps tries and vector tries as popularized by Clojure and Scala, minimizing the need to
  copy or cache data.
- Immutable collections should be treated as *values* rather than *objects*. While objects represent
  something which could change over time, a value represents the state of that thing at a particular
  instance of time. This principle is most important to understanding the appropriate use of
  immutable data. In order to treat Immutable.js collections as values, it's important to use
  the `Immutable.is()` function or `.equals()` method to determine value equality instead of
  the `===` operator which determines object *reference identity*.
- If an object is immutable, it can be "copied" simply by making another reference to it instead of
  copying the entire object. Because a reference is much smaller than the object itself, this
  results in memory savings and a potential boost in execution speed for programs which rely on
  copies (such as an undo-stack).

[immutable_data_react_lecture]: https://youtu.be/I7IdS-PbEgI

[immutable_js]: https://github.com/immutable-js/immutable-js

## 18.2. Articles

1. [Discussion on the Performance of Immutable Collections][performance_discussion]

- Kevin Bourrillion: "Raw CPU speed? To a first order of approximation, the performance is the same.
  Heck, to a second order of approximation, it's the same, too. These kinds of performance
  differences are nearly always absolutely dwarfed by bigger concerns — I/O, lock contention, memory
  leaks, algorithms of the wrong big-O complexity, sheer coding errors, failure to properly reuse
  data once obtained (which may be solved by "caching" or simply by structuring the code better),
  etc. etc. etc."
- If you measure your isolated component and it performs better than competitors, then it is better
  in isolation. If it doesn't perform as expected in the system, it's because its design doesn't
  fit, the specifications are probably wrong.
    - Systems are bigger than the sum of its components, but they are finite and can have their
      external interactions abstracted away, so I kind of disagree with Bourrillion's answer.

1. [Why doesn't Java 8 include immutable collections?][why_no_immutable_on_java_8]

- [The difference between readable, read-only and immutable collections][3_types_of_collections].
- Basically, the `UnmodifiableListMixin` also exists in Java. For more,
  check [Arkanon's answer][arkanon_answer].
- I enjoy entertaining the idea that of all the code written in Java and running on millions of
  computers all over the world, every day, around the clock, about half the total clock cycles must
  be wasted doing nothing but making safety copies of collections that are being returned by
  functions. (And garbage-collecting these collections milliseconds after their creation.)
    - From [Mike Nakis' answer][mike_nakis_answer].
    - Now, an interface like Collection which would be missing the `add()`, `remove()`
      and `clear()`
      methods would not be an `ImmutableCollection` interface; it would be
      an `UnmodifiableCollection` interface. As a matter of fact, there could never be
      an `ImmutableCollection` interface, because immutability is a nature of an implementation, not
      a characteristic of an interface. I know, that's not very clear; let me explain.
- [Ben Rayfield on recursiveness][ben_rayfield_recursiveness]

1. [Question on the behavior of `List.unmodifiable`][marcelo_list_unmodifiable]

- `List.unmodifiable` does create a new list. And it's `O(N)`.

1. [Immutable Collections In Java &ndash; Not Now, Not Ever][immutable_collections_java_not_now_not_ever]

- Originally, unmodifiable marked an instance that offered no mutability (by throwing
  `UnsupportedOperationException` on mutating methods) but may be changed in other ways (maybe
  because it was just a wrapper around a mutable collection).
- An immutable collection of secret agents might sound an awful lot like an immutable collection of
  immutable secret agents, but the two are not the same. The immutable collection may not be
  editable by adding/removing/clearing/etc, but, if secret agents are mutable (although the lack of
  character development in spy movies seems to suggest otherwise), that doesn’t mean the collection
  of agents as a whole is immutable.
- *Immutability is not an absence of mutation, it’s a guarantee there won’t be mutation*.
- Converting old code to a new immutability hierarchy may be source-incompatible.

1. [Faster Purely Functional Data Structures for Java][faster_java_functional_data_structures]

- Use unifying interfaces for more flexibility with respect to implementations.
- Laziness in copying is key to performance.
- *Persistent collections are immutable collections with efficient copy-on-write operations.*
- [Chris Osaki's thesis on *Purely Functional Data Structures*][osaki_thesis]
- [Extreme Cleverness: Functional Data Structures in Scala - Daniel Spiewak][spiewak_lecture]
- [Clojure Data Structures Part 1 - Rich Hickey (the creator of Clojure)][hickey_lecture]

[3_types_of_collections]: https://softwareengineering.stackexchange.com/a/222052/344810

[arkanon_answer]: https://softwareengineering.stackexchange.com/a/222323/344810

[ben_rayfield_recursiveness]: https://softwareengineering.stackexchange.com/a/330179/344810

[faster_java_functional_data_structures]: https://medium.com/@johnmcclean/the-rise-and-rise-of-java-functional-data-structures-63782436f93b

[hickey_lecture]: https://youtu.be/ketJlzX-254

[immutable_collections_java_not_now_not_ever]: https://nipafx.dev/immutable-collections-in-java/

[list_github]: https://github.com/funkia/list

[marcelo_list_unmodifiable]: https://stackoverflow.com/q/50311900/4756173

[mike_nakis_answer]: https://softwareengineering.stackexchange.com/a/285839/344810

[osaki_thesis]: https://www.cs.cmu.edu/~rwh/theses/okasaki.pdf

[performance_discussion]: https://groups.google.com/g/guava-discuss/c/hfyhraawwUc?pli=1

[spiewak_lecture]: https://youtu.be/pNhBQJN44YQ

[why_no_immutable_on_java_8]: https://softwareengineering.stackexchange.com/q/221762/344810

## 18.3. Other Resources

1. [Is Dart Compiled or Interpreted?][dart_compiled_or_interpreted]

- Both. It ultimately depends onto which platform you're deploying.

1. [Introduction to the Dart VM][intro_dart_vm]

1. [What does `external` mean in Dart?][external_in_dart]

- Basically that the method is implemented elsewhere, probably by a subclass. It's kind of like an
  abstract method but not in an abstract class.

1. [An example of how to graph benchmarks][funkia].

[dart_compiled_or_interpreted]: https://www.quora.com/Is-Dart-a-compiled-or-interpreted-language

[external_in_dart]: https://stackoverflow.com/q/24929659/4756173

[funkia]: https://funkia.github.io/list/benchmarks/

[intro_dart_vm]: https://mrale.ph/dartvm/

<br>

# 19. Thanks

<a href="https://turtleos.com">TurtleOS</a> (<a href="https://turtleos.com">turtleos.com</a>)
sponsored the development of `IMapConst` and `IMapOfSetsConst`  (the constant versions of `IMap`
and `IMapOfSets`)
.

TurtleOS is a complete solution to online hiring. It brings together everything you and your team
need to do your best work online, from team chat and task management to contracts and payments.

***

*The Flutter packages I've authored:*

* <a href="https://pub.dev/packages/async_redux">async_redux</a>
* <a href="https://pub.dev/packages/provider_for_redux">provider_for_redux</a>
* <a href="https://pub.dev/packages/i18n_extension">i18n_extension</a>
* <a href="https://pub.dev/packages/align_positioned">align_positioned</a>
* <a href="https://pub.dev/packages/network_to_file_image">network_to_file_image</a>
* <a href="https://pub.dev/packages/image_pixels">image_pixels</a>
* <a href="https://pub.dev/packages/matrix4_transform">matrix4_transform</a>
* <a href="https://pub.dev/packages/back_button_interceptor">back_button_interceptor</a>
* <a href="https://pub.dev/packages/indexed_list_view">indexed_list_view</a>
* <a href="https://pub.dev/packages/animated_size_and_fade">animated_size_and_fade</a>
* <a href="https://pub.dev/packages/assorted_layout_widgets">assorted_layout_widgets</a>
* <a href="https://pub.dev/packages/weak_map">weak_map</a>
* <a href="https://pub.dev/packages/themed">themed</a>
* <a href="https://pub.dev/packages/bdd_framework">bdd_framework</a>

*My Medium Articles:*

* <a href="https://medium.com/flutter-community/https-medium-com-marcglasberg-async-redux-33ac5e27d5f6">
  Async Redux: Flutter’s non-boilerplate version of Redux</a> 
  (versions: <a href="https://medium.com/flutterando/async-redux-pt-brasil-e783ceb13c43">
  Português</a>)
* <a href="https://medium.com/flutter-community/i18n-extension-flutter-b966f4c65df9">
  i18n_extension</a> 
  (versions: <a href="https://medium.com/flutterando/qual-a-forma-f%C3%A1cil-de-traduzir-seu-app-flutter-para-outros-idiomas-ab5178cf0336">
  Português</a>)
* <a href="https://medium.com/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2">
  Flutter: The Advanced Layout Rule Even Beginners Must Know</a> 
  (versions: <a href="https://habr.com/ru/post/500210/">русский</a>)
* <a href="https://medium.com/flutter-community/the-new-way-to-create-themes-in-your-flutter-app-7fdfc4f3df5f">
  The New Way to create Themes in your Flutter App</a> 

*My article in the official Flutter documentation*:

* <a href="https://flutter.dev/docs/development/ui/layout/constraints">Understanding constraints</a>

<br>_Marcelo Glasberg:_<br>

<a href="https://github.com/marcglasberg">_github.com/marcglasberg_</a>
<br>
<a href="https://www.linkedin.com/in/marcglasberg/">_linkedin.com/in/marcglasberg/_</a>
<br>
<a href="https://twitter.com/glasbergmarcelo">_twitter.com/glasbergmarcelo_</a>
<br>
<a href="https://stackoverflow.com/users/3411681/marcg">_stackoverflow.com/users/3411681/marcg_</a>
<br>
<a href="https://medium.com/@marcglasberg">_medium.com/@marcglasberg_</a>
<br>
