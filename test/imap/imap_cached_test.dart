// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

final _reverseKey = CacheKey<IMap<String, int>, Map<int, String>>(
  (map) => {for (var e in map.entries) e.value: e.key},
);

final _sumValues = CacheKey<IMap<String, int>, int>(
  (map) => map.values.fold(0, (a, b) => a + b),
);

var _computeCount = 0;

final _countingKey = CacheKey<IMap<String, int>, Map<String, int>>(
  (map) {
    _computeCount++;
    return map.unlock;
  },
);

void main() {
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("cached | basic computation and retrieval", () {
    final map = {"a": 1, "b": 2, "c": 3}.lock;
    expect(map.cached(_sumValues), 6);
  });

  test("cached | returns same result on repeated calls", () {
    final map = {"a": 1, "b": 2}.lock;
    final first = map.cached(_reverseKey);
    final second = map.cached(_reverseKey);
    expect(first, {1: "a", 2: "b"});
    expect(identical(first, second), isTrue);
  });

  test("cached | computation runs only once for the same key", () {
    _computeCount = 0;
    final map = {"a": 1, "b": 2}.lock;

    map.cached(_countingKey);
    map.cached(_countingKey);
    map.cached(_countingKey);

    expect(_computeCount, 1);
  });

  test("cached | different keys cache independently", () {
    final map = {"a": 1, "b": 2, "c": 3}.lock;

    final reversed = map.cached(_reverseKey);
    final sum = map.cached(_sumValues);

    expect(reversed, {1: "a", 2: "b", 3: "c"});
    expect(sum, 6);
  });

  test("cached | different IMap instances have independent caches", () {
    _computeCount = 0;

    final map1 = {"a": 1}.lock;
    final map2 = {"a": 1}.lock;

    map1.cached(_countingKey);
    map2.cached(_countingKey);

    expect(_computeCount, 2);
  });

  test("cached | works with empty IMap", () {
    final map = <String, int>{}.lock;
    expect(map.cached(_sumValues), 0);
  });

  test("cached | works with const IMap.empty()", () {
    const map = IMap<String, int>.empty();
    expect(map.cached(_sumValues), 0);
  });

  test("cached | const IMap.empty() computes every time", () {
    _computeCount = 0;
    const map = IMap<String, int>.empty();

    map.cached(_countingKey);
    map.cached(_countingKey);

    expect(_computeCount, 2);
  });

  test("cached | cache survives flush", () {
    _computeCount = 0;

    var map = IMap<String, int>({"a": 1});
    map = map.add("b", 2);

    map.cached(_countingKey);
    map.flush;
    map.cached(_countingKey);

    expect(_computeCount, 1);
  });

  test("cached | reverse map lookup", () {
    final map = {"alice": 1, "bob": 2, "charlie": 3}.lock;
    expect(map.cached(_reverseKey)[1], "alice");
    expect(map.cached(_reverseKey)[2], "bob");
    expect(map.cached(_reverseKey)[99], isNull);
  });
}
