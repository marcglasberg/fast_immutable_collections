# Undocumented Features Report

This report lists features present in the code that are NOT documented in README.md.

Generated: 2026-01-26

---

## 1. IList Methods (Not in README)

### Functional/FP Methods
| Method | Signature | Description |
|--------|-----------|-------------|
| `scan` | `IList<E> scan<E>(E initialValue, E Function(E, T) combine)` | Like fold but returns all intermediate values |
| `iterate` | `static IList<U> iterate<U>(U base, int count, Op<U> op)` | Creates list by repeatedly applying operation |
| `iterateWhile` | `static IList<U> iterateWhile<U>(U base, Predicate<U> test, Op<U> op)` | Creates list while predicate holds |
| `process` | `IList<T> process({test, required convert})` | Complex conditional transformation |
| `divideIn2` | `IListOf2<IList<T>> divideIn2(bool Function(T) test)` | Splits list into two based on predicate |

### Haskell-style List Methods
| Method | Signature | Description |
|--------|-----------|-------------|
| `head` | `Iterable<T> get head` | First element (as Iterable) |
| `tail` | `Iterable<T> get tail` | All but first element |
| `init` | `Iterable<T> get init` | All but last element |
| `tails` | `Iterable<Iterable<T>> tails()` | All suffixes of the list |
| `inits` | `Iterable<Iterable<T>> inits()` | All prefixes of the list |
| `heads` | `Iterable<T> heads()` | (synonym for head iteration) |
| `span` | `(Iterable<T>, Iterable<T>) span(Predicate<T> p)` | Split at first element not satisfying predicate |
| `splitAt` | `(Iterable<T>, Iterable<T>) splitAt(int index)` | Split at index |

### Zip Methods
| Method | Signature | Description |
|--------|-----------|-------------|
| `zipWithIndex` | `Iterable<(int, T)> zipWithIndex()` | Pairs each element with its index |
| `zip` | `Iterable<(T, U)> zip<U>(Iterable<U> other)` | Zips two iterables together |
| `zipAll` | `Iterable<(T?, U?)> zipAll<U>(Iterable<U> other, {currentFill, otherFill})` | Zip with fill values for unequal lengths |

### Query Methods
| Method | Signature | Description |
|--------|-----------|-------------|
| `count` | `int count(Predicate<T> p)` | Count elements satisfying predicate |
| `corresponds` | `bool corresponds<U>(Iterable<U> others, EQ eq)` | Check if corresponding elements satisfy equality |
| `lengthCompare` | `bool lengthCompare(Iterable others)` | Compare lengths |
| `whereNot` | `Iterable<T> whereNot(Predicate<T> test)` | Filter elements NOT satisfying predicate |

### Other Methods
| Method | Signature | Description |
|--------|-----------|-------------|
| `maxLength` | `IList<T> maxLength(int maxLength, {priority})` | Limit list to max length with optional priority |
| `putXY` | `IList<IList<T>> putXY({x, y, value})` | Put value at x,y in 2D list (extension on `IList<IList<T>>`) |

---

## 2. ISet Methods (Not in README)

| Method | Signature | Description |
|--------|-----------|-------------|
| `anyItem` | `T get anyItem` | Returns any item from the set (useful when you just need one) |
| `lookup` | `T? lookup(T element)` | Returns the actual stored element equal to the given one |

---

## 3. IMap Methods (Not in README)

| Method | Signature | Description |
|--------|-----------|-------------|
| `entry` | `MapEntry<K, V?> entry(K key)` | Get entry for key (value may be null) |
| `entryOrNull` | `MapEntry<K, V>? entryOrNull(K key)` | Get entry or null if not found |
| `comparableEntries` | `Iterable<Entry<K, V>> get comparableEntries` | Entries as comparable Entry objects |
| `unlockSorted` | `Map<K, V> get unlockSorted` | Unlock to a sorted map |

---

## 4. IMapOfSets Methods (Most are not documented)

The README only shows usage examples. These methods are not listed:

### Lookup Methods
| Method | Signature | Description |
|--------|-----------|-------------|
| `getEntryWithValue` | `MapEntry<K, ISet<V>>? getEntryWithValue(V value)` | Find first entry containing value |
| `getKeyWithValue` | `K? getKeyWithValue(V value)` | Find first key whose set contains value |
| `allEntriesWithValue` | `Set<MapEntry<K, ISet<V>>> allEntriesWithValue(V value)` | All entries containing value |
| `allKeysWithValue` | `Set<K> allKeysWithValue(V value)` | All keys whose sets contain value |
| `firstValueWhere` | `V firstValueWhere(bool Function(V) test, {orElse})` | Find first value across all sets |
| `firstValueWhereOrNull` | `V? firstValueWhereOrNull(bool Function(V) test)` | Find first value or null |

### Transformation Methods
| Method | Signature | Description |
|--------|-----------|-------------|
| `invertKeysAndValues` | `IMapOfSets<V, K> invertKeysAndValues()` | Swap keys and values |
| `invertKeysAndValuesKeepingNullKeys` | `IMapOfSets<V?, K> invertKeysAndValuesKeepingNullKeys()` | Invert, keeping null keys |
| `flatten` | `Iterable<MapEntry<K, V>> flatten()` | Flatten to key-value pairs |
| `toggle` | `IMapOfSets<K, V> toggle(K key, V value, {state})` | Toggle value presence in set |

---

## 5. Utility Classes (Not in README)

| Class | Description |
|-------|-------------|
| `IListOf2<T>` | Immutable list of exactly 2 items with `first` and `last` |
| `IListOf3<T>` | Immutable list of exactly 3 items with `first`, `second`, `third` |
| `IListOf4<T>` | Immutable list of exactly 4 items with `first`, `second`, `third`, `fourth` |
| `Output<T>` | Wrapper class for capturing output values from methods |

---

## 6. Type Aliases (Not in README)

| Alias | Definition | Description |
|-------|------------|-------------|
| `Predicate<T>` | `bool Function(T element)` | Common predicate function type |
| `Op<T>` | `T Function(T element)` | Operation that preserves type |
| `EQ<T, U>` | `bool Function(T item, U other)` | Equality comparison function |

---

## 7. Extensions (Not in README)

### FicNumberExtension on num
| Method | Signature | Description |
|--------|-----------|-------------|
| `isInRange` | `bool isInRange(num ini, num fim)` | Check if number is in range |
| `isNotInRange` | `bool isNotInRange(num ini, num fim)` | Check if number is NOT in range |
| `inRange` | `T inRange(T min, T max)` | Clamp number to range |

### FicZipExtension on Iterable<(U, V)>
| Method | Signature | Description |
|--------|-----------|-------------|
| `unzip` | `(Iterable<U>, Iterable<V>) unzip()` | Unzip pairs into two iterables |

### FicIterableExtension (additional methods not in README)
| Method | Signature | Description |
|--------|-----------|-------------|
| `mapIndexedAndLast` | `Iterable<R> mapIndexedAndLast<R>(R Function(int, T, bool) convert)` | Map with index and isLast flag |
| `intersectsWith` | `bool intersectsWith(Iterable<T> other)` | Check if iterables have common elements |

---

## 8. Methods Mentioned in README but with Missing Details

These are mentioned but without full documentation:

- `IList.fromISet` - Factory to create IList from ISet
- `IMap.fromIterable` - Factory with key/value mappers
- Many IMapOfSets methods are shown in examples but not listed systematically

---

## Summary

### High-Priority Items to Document (Functional/FP features likely added by your friend):

1. **`scan`** - Important FP method, like fold but returns intermediates
2. **`iterate` / `iterateWhile`** - List generation from operations
3. **Haskell-style methods**: `head`, `tail`, `init`, `tails`, `inits`, `span`, `splitAt`
4. **Zip methods**: `zipWithIndex`, `zip`, `zipAll`, `unzip`
5. **`corresponds`** - Element-wise comparison
6. **`divideIn2`** - Split by predicate into two lists
7. **`IListOf2`, `IListOf3`, `IListOf4`** - Fixed-size immutable lists
8. **Type aliases**: `Predicate<T>`, `Op<T>`, `EQ<T,U>`

### Medium-Priority Items:

1. **IMapOfSets detailed method list** - Most methods undocumented
2. **`FicNumberExtension`** - Number range utilities
3. **`whereNot`** - Opposite of `where`
4. **`count`** - Count matching elements
5. **`maxLength`** - Limit list size with priority

### Lower-Priority Items:

1. **`anyItem`** on ISet
2. **`lookup`** on ISet
3. **`entry`/`entryOrNull`** on IMap
4. **`unlockSorted`** on IMap
5. **`mapIndexedAndLast`**, `intersectsWith` on Iterable
