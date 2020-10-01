import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  group('Basic Operations |', () {
    IMapOfSets<String, int> mapOfSets = IMapOfSets();

    test('Runtime Type', () => expect(mapOfSets, isA<IMapOfSets<String, int>>()));

    test('Emptiness properties', () {
      expect(mapOfSets.isEmpty, isTrue);
      expect(mapOfSets.isNotEmpty, isFalse);
    });

    test('Adding an element', () {
      mapOfSets = mapOfSets.add('a', 1);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets['a'], ISet<int>([1]));
    });

    test('Adding a second element with the same key', () {
      mapOfSets = mapOfSets.add('a', 2);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets['a'], ISet<int>([1, 2]));
    });

    test('Adding a third, different element', () {
      mapOfSets = mapOfSets.add('b', 3);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets['a'], ISet<int>([1, 2]));
      expect(mapOfSets['b'], ISet<int>([3]));
    });

    test('Removing an element with an existing key of multiple elements', () {
      mapOfSets = mapOfSets.remove('a', 1);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets['a'], ISet<int>([2]));
    });

    test('Removing an element completely', () {
      mapOfSets = mapOfSets.remove('b', 3);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets['a'], ISet<int>([2]));
      expect(mapOfSets['b'], isNull);
    });
  });
}
