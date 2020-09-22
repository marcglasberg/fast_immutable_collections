# Benchmarks Specifications

This is a summary of the benchmarks and how they are executed.

> **Note that the specifications below have not been programmatically tied to the benchmark files, so please do check the code itself if you want to *really* confirm what's going on in the benchmarks, specially when it comes to how many times they're run.**

## 1. Lists

> Note that, currently, with the [`benchmark_harness`][benchmark_harness] package, both `setup` and `teardown` are equivalent to `setUpAll` and `tearDownAll` in the [`test`][test] package.


[benchmark_harness]: https://pub.dev/packages/benchmark_harness
[test]: https://pub.dev/packages/test

### 1.1. Empty Initialization

| Data Object      | Setup | Run                   |
| ---------------- | ----- | --------------------- |
| `List` (Mutable) | -     | `<int>[]`             |
| `IList`          | -     | `IList<int>()`        |
| `KtList`         | -     | `KtList<int>.empty()` |
| `BuiltList`      | -     | `BuiltList<int>()`    |

### 1.2. Reading an Element

Size here is the *length* of the list being read.

| Size |
| ---- |
| 10k  |

| Data Object      | Setup                         | Run  |
| ---------------- | ----------------------------- | ---- |
| `List` (Mutable) | `List.generate`               | `[]` |
| `IList`          | `IList(List.generate)`        | `[]` |
| `KtList`         | `KtList.from(List.generate)`  | `[]` |
| `BuiltList`      | `BuiltList.of(List.generate)` | `[]` |

### 1.3. Adding 1 or Multiple Elements

Size refers to the *length* of the original list before the insertion of the new element(s).

| Size |
| ---- |
| 10   |
| 1k   |
| 100k |

| Data Object      | Setup                         | Run                                  |
| ---------------- | ----------------------------- | ------------------------------------ |
| `List` (Mutable) | `List.generate`               | 3x `..add()`                         |
| `IList`          | N times `IList().add()`       | 3x `.add()`                          |
| `KtList`         | `KtList.from(List.generate)`  | 3x `.plusElement()`                  |
| `BuiltList`      | `BuiltList.of(List.generate)` | 3x `.rebuild(.add())`                |
| `BuiltList`      | `BuiltList.of(List.generate)` | (# Runs / 50)x `ListBuilder.build()` |

### 1.4. Removing 1 Element

| Size |
| ---- |
| 10   |
| 1k   |
| 100k |

| Data Object      | Setup                         | Run                                  |
| ---------------- | ----------------------------- | ------------------------------------ |
| `List` (Mutable) | `List.generate`               | 3x `..remove()`                      |
| `IList`          | `IList(List.generate)`        | 3x `.remove()`                       |
| `KtList`         | `KtList.from(List.generate)`  | 3x `.minusElement()`                 |
| `BuiltList`      | `BuiltList.of(List.generate)` | 3x `.rebuild(.remove())`             |
| `BuiltList`      | `BuiltList.of(List.generate)` | (# Runs / 50)x `ListBuilder.build()` |

### 1.5. Adding Multiple Elements at Once with `addAll`

| Size of the Original List | Size of the List to be Added |
| ------------------------- | ---------------------------- |
| 10                        | 10                           |
| 1k                        | 1k                           |
| 10k                       | 10k                          |

| Data Object      | Setup          | Run                    |
| ---------------- | -------------- | ---------------------- |
| `List` (Mutable) | `List.of`      | `.addAll()`            |
| `IList`          | `IList`        | `.addAll()`            |
| `KtList`         | `KtList.from`  | `.plus(KtList.from())` |
| `BuiltList`      | `BuiltList.of` | `.rebuild(.addAll())`  |

### 1.6. Contains

This benchmark tests contains for *all* elements and, lastly, tries an inexistent one.

| Size |
| ---- |
| 100  |
| 1k   |
| 10k  |
| 100k |

| Data Object      | Setup           | Run                                  |
| ---------------- | --------------- | ------------------------------------ |
| `List` (Mutable) | `List.generate` | `.contains()` on `length + elements` |
