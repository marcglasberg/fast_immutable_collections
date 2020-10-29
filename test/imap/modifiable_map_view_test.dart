import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
  final IMap<String, int> iMap = baseMap.lock;

  group("Non-mutable methods |", () {
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(iMap);

    test("ModifiableMapView.[] operator", () {
      expect(modifiableMapView["a"], 1);
      expect(modifiableMapView["b"], 2);
      expect(modifiableMapView["c"], 3);
      expect(modifiableMapView["d"], isNull);
    });

    test(
        "ModifiableMapView.lock getter",
        () =>
            modifiableMapView.lock.forEach((String key, int value) => expect(baseMap[key], value)));

    test(
        "ModifiableMapView.keys",
        () => modifiableMapView.keys
            .forEach((String key) => expect(baseMap.containsKey(key), isTrue)));
  });

  group("Mutations are allowed |", () {
    ModifiableMapView<String, int> modifiableMapView;

    setUp(() => modifiableMapView = ModifiableMapView(iMap));

    test("ModifiableMapView.[]= operator", () {
      expect(modifiableMapView["a"], 1);
      modifiableMapView["a"] = 2;
      expect(modifiableMapView["a"], 2);

      expect(modifiableMapView["d"], isNull);
      modifiableMapView["d"] = 10;
      expect(modifiableMapView["d"], 10);
    });

    test("ModifiableMapView.clear method", () {
      modifiableMapView.clear();
      expect(modifiableMapView["a"], isNull);
      expect(modifiableMapView["b"], isNull);
      expect(modifiableMapView["c"], isNull);
      expect(modifiableMapView.lock, <String, int>{}.lock);
    });

    test("ModifiableMapView.remove", () {
      expect(modifiableMapView["a"], 1);
      modifiableMapView.remove("a");
      expect(modifiableMapView["a"], isNull);

      expect(modifiableMapView["d"], isNull);
      modifiableMapView.remove("d");
      expect(modifiableMapView["d"], isNull);
    });
  });
}
