// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("Empty Initialization", () {
    expect(UnmodifiableMapFromIMap({}.lock).isEmpty, isTrue);
  });

  test("[]", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapFromIMap<String, int> unmodifiableMapView =
            UnmodifiableMapFromIMap(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapFromIMap.fromMap(baseMap);
    final List<UnmodifiableMapFromIMap<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapFromIMap<String, int> view) {
      expect(view["a"], 1);
      expect(view["b"], 2);
      expect(view["c"], 3);
      expect(view["d"], isNull);
    });
  });

  test("keys", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapFromIMap<String, int> unmodifiableMapView =
            UnmodifiableMapFromIMap(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapFromIMap.fromMap(baseMap);
    final List<UnmodifiableMapFromIMap<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapFromIMap<String, int> view) {
      baseMap.keys.forEach((String key) => expect(view.keys.contains(key), isTrue));
      expect(baseMap.keys.length, view.keys.length);
    });
  });

  test("lock", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapFromIMap<String, int> unmodifiableMapView =
            UnmodifiableMapFromIMap(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapFromIMap.fromMap(baseMap);
    final List<UnmodifiableMapFromIMap<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapFromIMap<String, int> view) => expect(view.lock, baseMap.lock));
  });

  test("[]=", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapFromIMap<String, int> unmodifiableMapView =
            UnmodifiableMapFromIMap(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapFromIMap.fromMap(baseMap);
    final List<UnmodifiableMapFromIMap<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapFromIMap<String, int> view) =>
        expect(() => view["a"] = 10, throwsUnsupportedError));
  });

  test("clear", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapFromIMap<String, int> unmodifiableMapView =
            UnmodifiableMapFromIMap(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapFromIMap.fromMap(baseMap);
    final List<UnmodifiableMapFromIMap<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapFromIMap<String, int> view) =>
        expect(() => view.clear(), throwsUnsupportedError));
  });

  test("remove", () {
    const Map<String, int> baseMap = {"a": 1, "b": 2, "c": 3};
    final UnmodifiableMapFromIMap<String, int> unmodifiableMapView =
            UnmodifiableMapFromIMap(baseMap.lock),
        unmodifiableMapViewFromMap = UnmodifiableMapFromIMap.fromMap(baseMap);
    final List<UnmodifiableMapFromIMap<String, int>> views = [
      unmodifiableMapView,
      unmodifiableMapViewFromMap,
    ];

    views.forEach((UnmodifiableMapFromIMap<String, int> view) =>
        expect(() => view.remove("a"), throwsUnsupportedError));
  });
}
