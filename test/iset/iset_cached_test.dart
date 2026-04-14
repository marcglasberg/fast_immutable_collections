// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

final _sumKey = CacheKey<ISet<int>, int>(
  (set) => set.fold(0, (a, b) => a + b),
);

var _computeCount = 0;

final _countingKey = CacheKey<ISet<int>, List<int>>(
  (set) {
    _computeCount++;
    return set.toList();
  },
);

final _indexByValue = CacheKey<ISet<String>, Map<String, bool>>(
  (set) => {for (var s in set) s: true},
);

void main() {
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("cached | basic computation and retrieval", () {
    final set = {10, 20, 30}.lock;
    expect(set.cached(_sumKey), 60);
  });

  test("cached | returns same result on repeated calls", () {
    final set = {10, 20, 30}.lock;
    final first = set.cached(_sumKey);
    final second = set.cached(_sumKey);
    expect(first, 60);
    expect(identical(first, second), isTrue);
  });

  test("cached | computation runs only once for the same key", () {
    _computeCount = 0;
    final set = {1, 2, 3}.lock;

    set.cached(_countingKey);
    set.cached(_countingKey);
    set.cached(_countingKey);

    expect(_computeCount, 1);
  });

  test("cached | different keys cache independently", () {
    final intSet = {10, 20, 30}.lock;
    final strSet = {"a", "b", "c"}.lock;

    final sum = intSet.cached(_sumKey);
    final index = strSet.cached(_indexByValue);

    expect(sum, 60);
    expect(index, {"a": true, "b": true, "c": true});
  });

  test("cached | different ISet instances have independent caches", () {
    _computeCount = 0;

    final set1 = {1, 2, 3}.lock;
    final set2 = {1, 2, 3}.lock;

    set1.cached(_countingKey);
    set2.cached(_countingKey);

    expect(_computeCount, 2);
  });

  test("cached | works with empty ISet", () {
    final set = <int>{}.lock;
    expect(set.cached(_sumKey), 0);
  });

  test("cached | works with const ISet.empty()", () {
    const set = ISet<int>.empty();
    expect(set.cached(_sumKey), 0);
  });

  test("cached | const ISet.empty() computes every time", () {
    _computeCount = 0;
    const set = ISet<int>.empty();

    set.cached(_countingKey);
    set.cached(_countingKey);

    expect(_computeCount, 2);
  });

  test("cached | cache survives flush", () {
    _computeCount = 0;

    var set = ISet<int>({1, 2});
    set = set.add(3);

    set.cached(_countingKey);
    set.flush;
    set.cached(_countingKey);

    expect(_computeCount, 1);
  });

  test("cached | returned cached instance is identical", () {
    final set = {"a", "b", "c"}.lock;
    final map1 = set.cached(_indexByValue);
    final map2 = set.cached(_indexByValue);
    expect(identical(map1, map2), isTrue);
  });
}
