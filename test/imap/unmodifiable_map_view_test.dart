import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  const Map<String, int> baseMap = {'a': 1, 'b': 2, 'c': 3};
  final IMap<String, int> iMap = baseMap.lock;
  final UnmodifiableMapView<String, int> unmodifiableMapView = UnmodifiableMapView(iMap),
      unmodifiableMapViewFromMap = UnmodifiableMapView.fromMap(baseMap);
  final List<UnmodifiableMapView<String, int>> views = [
    unmodifiableMapView,
    unmodifiableMapViewFromMap,
  ];

  group("Non-mutable operations |", () {
    test("UnmodifiableMapView.[] operator", () {
      views.forEach((UnmodifiableMapView<String, int> view) {
        expect(view['a'], 1);
        expect(view['b'], 2);
        expect(view['c'], 3);
        expect(view['d'], isNull);
      });
    });

    test(
        "UnmodifiableMapView.keys getter",
        () => views.forEach((UnmodifiableMapView<String, int> view) {
              baseMap.keys.forEach((String key) => expect(view.keys.contains(key), isTrue));
              expect(baseMap.keys.length, view.keys.length);
            }));

    test(
        "UnmodifiableMapView.lock getter",
        () => views
            .forEach((UnmodifiableMapView<String, int> view) => expect(view.lock, baseMap.lock)));
  });

  group("Mutations are not allowed |", () {
    test(
        "UnmodifiableMapView.[]= operator",
        () => views.forEach((UnmodifiableMapView<String, int> view) =>
            expect(() => view['a'] = 10, throwsUnsupportedError)));
            
    test("UnmodifiableMapView.clear method", () {
      views.forEach((UnmodifiableMapView<String, int> view) =>
          expect(() => view.clear(), throwsUnsupportedError));
    });

    test("UnmodifiableMapView.remove method", () {
      views.forEach((UnmodifiableMapView<String, int> view) =>
          expect(() => view.remove('a'), throwsUnsupportedError));
    });
  });
}
