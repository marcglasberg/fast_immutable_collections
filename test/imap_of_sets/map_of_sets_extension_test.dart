// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
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
}
