import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  const Map<String, int> baseMap = {'a': 1, 'b': 2, 'c': 3};
  final IMap<String, int> iMap = baseMap.lock;
  final ModifiableMapView<String, int> modifiableMapView = ModifiableMapView(iMap);

  group("Non-mutable methods |", () {
    test("ModifiableMapView.[] operator", () {
      expect(modifiableMapView['a'], 1);
      expect(modifiableMapView['b'], 2);
      expect(modifiableMapView['c'], 3);
      expect(modifiableMapView['d'], isNull);
    });
  });

  group("Mutations are allowed", () {
    test("ModifiableMapView.[]= operator", () {
      
    });
  });
}
