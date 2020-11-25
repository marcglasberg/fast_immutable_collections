import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("IMapOfSetsExtension.lock", () {
    const Map<String, Set<int>> map = {
      "a": {1, 2},
      "b": {1, 2, 3}
    };

    expect(map.lock, isA<IMapOfSets<String, int>>());
    expect(map.lock.unlock, {
      "a": {1, 2},
      "b": {1, 2, 3}
    });
  });
}
