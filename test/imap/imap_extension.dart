import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("IMapExtension.lock", () {
    expect({"a": 1, "b": 2}.lock, isA<IMap<String, int>>());
    expect({"a": 1, "b": 2}.lock.unlock, {"a": 1, "b": 2});
  });

  test("IMapExtension.lockUnsafe", () {
    final Map<String, int> map = {"a": 1, "b": 2};
    final IMap<String, int> iMap = map.lockUnsafe;

    expect(map, iMap.unlock);

    map["c"] = 3;
    map["a"] = 10;

    expect(map, iMap.unlock);
  });
}
