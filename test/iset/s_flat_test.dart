import 'package:test/test.dart';

import 'package:fast_immutable_collections/src/iset/s_flat.dart';

void main() {
  group('MapEntryEquality Class |', () {
    const MapEntry<String, int> mapEntry1 = MapEntry('a', 1),
        mapEntry2 = MapEntry('a', 2),
        mapEntry3 = MapEntry('a', 1);

    test('equals', () {
      expect(MapEntryEquality().equals(mapEntry1, mapEntry1), isTrue);
      expect(MapEntryEquality().equals(mapEntry1, mapEntry2), isFalse);
      expect(MapEntryEquality().equals(mapEntry1, mapEntry3), isTrue);
    });

    test('hash', () {
      expect(MapEntryEquality().hash(mapEntry1), 170824771);
      expect(MapEntryEquality().hash(mapEntry2), 170824768);
      expect(MapEntryEquality().hash(mapEntry3), 170824771);
    });

    test('hash of a different type of object', () {
      expect(MapEntryEquality().hash(1), 1.hashCode);
      expect(MapEntryEquality().hash('a'), 'a'.hashCode);
    });

    test('isValidKey', () {
      fail('It is not clear what this method is supposed to do yet.'
          'It is always returning `true`');
    });
  });
}
