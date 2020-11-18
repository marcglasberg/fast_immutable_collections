import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("Non-mutable operations | UnmodifiableMapView.[] operator", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapView<String, int> unmodifiableMapView = UnmodifiableMapView(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapView.fromMap(baseMap);
    final List<UnmodifiableMapView<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapView<String, int> view) {
      expect(view["a"], 1);
      expect(view["b"], 2);
      expect(view["c"], 3);
      expect(view["d"], isNull);
    });
  });

  test("Non-mutable operations | UnmodifiableMapView.keys getter", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapView<String, int> unmodifiableMapView = UnmodifiableMapView(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapView.fromMap(baseMap);
    final List<UnmodifiableMapView<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapView<String, int> view) {
      baseMap.keys.forEach((String key) => expect(view.keys.contains(key), isTrue));
      expect(baseMap.keys.length, view.keys.length);
    });
  });

  test("Non-mutable operations | UnmodifiableMapView.lock getter", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapView<String, int> unmodifiableMapView = UnmodifiableMapView(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapView.fromMap(baseMap);
    final List<UnmodifiableMapView<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapView<String, int> view) => expect(view.lock, baseMap.lock));
  });

  test("Mutations are not allowed | UnmodifiableMapView.[]= operator", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapView<String, int> unmodifiableMapView = UnmodifiableMapView(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapView.fromMap(baseMap);
    final List<UnmodifiableMapView<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapView<String, int> view) =>
        expect(() => view["a"] = 10, throwsUnsupportedError));
  });

  test("Mutations are not allowed | UnmodifiableMapView.clear()", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapView<String, int> unmodifiableMapView = UnmodifiableMapView(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapView.fromMap(baseMap);
    final List<UnmodifiableMapView<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapView<String, int> view) =>
        expect(() => view.clear(), throwsUnsupportedError));
  });

  test("Mutations are not allowed | UnmodifiableMapView.remove()", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapView<String, int> unmodifiableMapView = UnmodifiableMapView(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapView.fromMap(baseMap);
    final List<UnmodifiableMapView<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapView<String, int> view) =>
        expect(() => view.remove("a"), throwsUnsupportedError));
  });
}
