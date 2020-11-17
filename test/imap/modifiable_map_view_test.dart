import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("ModifiableMapView.[] operator", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> iMap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(iMap);
    expect(modifiableMapView["a"], 1);
    expect(modifiableMapView["b"], 2);
    expect(modifiableMapView["c"], 3);
    expect(modifiableMapView["d"], isNull);
  });

  test("Non-mutable methods | ModifiableMapView.lock getter", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> iMap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(iMap);
    modifiableMapView.lock.forEach((String key, int value) => expect(baseMap[key], value));
  });

  test("Non-mutable methods | ModifiableMapView.keys", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> iMap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(iMap);
    modifiableMapView.keys.forEach((String key) => expect(baseMap.containsKey(key), isTrue));
  });

  test("Mutations are allowed | ModifiableMapView.[]= operator", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> iMap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(iMap);
    
    expect(modifiableMapView["a"], 1);
    modifiableMapView["a"] = 2;
    expect(modifiableMapView["a"], 2);

    expect(modifiableMapView["d"], isNull);
    modifiableMapView["d"] = 10;
    expect(modifiableMapView["d"], 10);
  });

  test("Mutations are allowed | ModifiableMapView.clear()", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> iMap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(iMap);

    modifiableMapView.clear();

    expect(modifiableMapView["a"], isNull);
    expect(modifiableMapView["b"], isNull);
    expect(modifiableMapView["c"], isNull);
    expect(modifiableMapView.lock, <String, int>{}.lock);
  });

  test("Mutations are allowed | ModifiableMapView.remove()", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> iMap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(iMap);

    expect(modifiableMapView["a"], 1);
    modifiableMapView.remove("a");
    expect(modifiableMapView["a"], isNull);

    expect(modifiableMapView["d"], isNull);
    modifiableMapView.remove("d");
    expect(modifiableMapView["d"], isNull);
  });
}
