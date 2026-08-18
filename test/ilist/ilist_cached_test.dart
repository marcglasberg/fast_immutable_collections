// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

// --- Keys defined at top level (stable references) ---

final _sumKey = CacheKey<IList<int>, int>(
  (list) => list.fold(0, (a, b) => a + b),
);

final _indexByString = CacheKey<IList<String>, Map<String, int>>(
  (list) {
    final map = <String, int>{};
    for (var i = 0; i < list.length; i++) {
      map[list[i]] = i;
    }
    return map;
  },
);

var _computeCount = 0;

final _countingKey = CacheKey<IList<int>, List<int>>(
  (list) {
    _computeCount++;
    return list.toList();
  },
);

final _byName = CacheKey<IList<_Person>, Map<String, _Person>>(
  (list) => {for (var p in list) p.name: p},
);

final _nullKey = CacheKey<IList<int>, int?>(
  (list) => null,
);

int _staticSum(IList<int> list) => list.fold(0, (a, b) => a + b);

void main() {
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("cached | basic computation and retrieval", () {
    final list = [10, 20, 30].lock;
    expect(list.cached(_sumKey), 60);
  });

  test("cached | returns same result on repeated calls", () {
    final list = [10, 20, 30].lock;
    final first = list.cached(_sumKey);
    final second = list.cached(_sumKey);
    expect(first, 60);
    expect(second, 60);
    expect(identical(first, second), isTrue);
  });

  test("cached | computation runs only once for the same key", () {
    _computeCount = 0;
    final list = [1, 2, 3].lock;

    list.cached(_countingKey);
    list.cached(_countingKey);
    list.cached(_countingKey);

    expect(_computeCount, 1);
  });

  test("cached | different keys cache independently", () {
    final intList = [10, 20, 30].lock;
    final strList = ["a", "b", "c"].lock;

    final sum = intList.cached(_sumKey);
    final index = strList.cached(_indexByString);

    expect(sum, 60);
    expect(index, {"a": 0, "b": 1, "c": 2});
  });

  test("cached | different IList instances have independent caches", () {
    _computeCount = 0;

    final list1 = [1, 2, 3].lock;
    final list2 = [1, 2, 3].lock;

    list1.cached(_countingKey);
    list2.cached(_countingKey);

    // Each instance computes separately.
    expect(_computeCount, 2);
  });

  test("cached | map index lookup", () {
    final alice = _Person("Alice", 30);
    final bob = _Person("Bob", 25);
    final list = [alice, bob].lock;

    expect(list.cached(_byName)["Alice"], alice);
    expect(list.cached(_byName)["Bob"], bob);
    expect(list.cached(_byName)["Charlie"], isNull);
  });

  test("cached | works with empty IList", () {
    final list = <int>[].lock;
    expect(list.cached(_sumKey), 0);
  });

  test("cached | works with const IList.empty()", () {
    const list = IList<int>.empty();
    expect(list.cached(_sumKey), 0);
  });

  test("cached | cache survives flush", () {
    _computeCount = 0;

    // Build a non-flushed IList by adding items.
    var list = IList<int>([1, 2]);
    list = list.add(3);

    list.cached(_countingKey);

    // Flush the list.
    list.flush;

    // Should still return the cached result.
    list.cached(_countingKey);

    expect(_computeCount, 1);
  });

  test("cached | cache result can be null", () {
    final list = [1, 2, 3].lock;
    expect(list.cached(_nullKey), isNull);

    // Calling again should still return null (and not recompute).
    expect(list.cached(_nullKey), isNull);
  });

  test("CacheKey | can be const", () {
    const key = CacheKey<IList<int>, int>(_staticSum);
    final list = [1, 2, 3].lock;
    expect(list.cached(key), 6);
  });

  test("cached | returned cached instance is identical", () {
    final list = ["a", "b", "c"].lock;
    final map1 = list.cached(_indexByString);
    final map2 = list.cached(_indexByString);
    expect(identical(map1, map2), isTrue);
  });
}

class _Person {
  final String name;
  final int age;
  _Person(this.name, this.age);
}
