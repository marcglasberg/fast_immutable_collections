import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("lock", () {
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

  /////////////////////////////////////////////////////////////////////////////

  test("toIMapOfSets", () {
    const Map<String, Set<int>> map = {
      "a": {1, 2},
      "b": {1, 2, 3}
    };

    // 1) No config
    expect(map.toIMapOfSets(), isA<IMapOfSets<String, int>>());
    expect(map.toIMapOfSets()?.unlock, {
      "a": {1, 2},
      "b": {1, 2, 3}
    });

    // 2) With config
    expect(map.toIMapOfSets(ConfigMapOfSets(sortKeys: true)), isA<IMapOfSets<String, int>>());
    expect(map.toIMapOfSets(ConfigMapOfSets(sortKeys: true))?.unlock, {
      "a": {1, 2},
      "b": {1, 2, 3}
    });
    expect(
        map.toIMapOfSets(ConfigMapOfSets(sortKeys: true))?.config, ConfigMapOfSets(sortKeys: true));
  });

  //////////////////////////////////////////////////////////////////////////////
}
