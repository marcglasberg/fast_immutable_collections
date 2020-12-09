import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////
  test("Empty Initialization", () {
    expect(ModifiableMapView({}.lock).isEmpty, isTrue);
    expect(ModifiableMapView(null).isEmpty, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("[]", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> imap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(imap);
    expect(modifiableMapView["a"], 1);
    expect(modifiableMapView["b"], 2);
    expect(modifiableMapView["c"], 3);
    expect(modifiableMapView["d"], isNull);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("lock", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> imap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(imap);
    modifiableMapView.lock.forEach((String key, int value) => expect(baseMap[key], value));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("keys", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> imap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(imap);
    modifiableMapView.keys.forEach((String key) => expect(baseMap.containsKey(key), isTrue));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("[]=", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> imap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(imap);

    expect(modifiableMapView["a"], 1);
    modifiableMapView["a"] = 2;
    expect(modifiableMapView["a"], 2);

    expect(modifiableMapView["d"], isNull);
    modifiableMapView["d"] = 10;
    expect(modifiableMapView["d"], 10);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("clear", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> imap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(imap);

    modifiableMapView.clear();

    expect(modifiableMapView["a"], isNull);
    expect(modifiableMapView["b"], isNull);
    expect(modifiableMapView["c"], isNull);
    expect(modifiableMapView.lock, <String, int>{}.lock);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("remove", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final IMap<String, int> imap = baseMap.lock;
    final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(imap);

    expect(modifiableMapView["a"], 1);
    modifiableMapView.remove("a");
    expect(modifiableMapView["a"], isNull);

    expect(modifiableMapView["d"], isNull);
    modifiableMapView.remove("d");
    expect(modifiableMapView["d"], isNull);
  });

  /////////////////////////////////////////////////////////////////////////////
}
