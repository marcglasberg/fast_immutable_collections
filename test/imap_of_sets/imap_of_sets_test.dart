import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  group('Empty Initialization |', () {
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets(),
        iMapOfSetsFromEmpty = IMapOfSets.empty();

    test('Runtime Type', () {
      expect(iMapOfSets, isA<IMapOfSets<String, int>>());
      expect(iMapOfSetsFromEmpty, isA<IMapOfSets<String, int>>());
    });

    test('Emptiness properties', () {
      expect(iMapOfSets.isEmpty, isTrue);
      expect(iMapOfSetsFromEmpty.isEmpty, isTrue);

      expect(iMapOfSets.isNotEmpty, isFalse);
      expect(iMapOfSetsFromEmpty.isNotEmpty, isFalse);
    });
  });

  group('Initialization from an `IMap` |', () {
    final ISet<int> iSet1 = ISet({1, 2}), iSet2 = ISet({1, 2, 3});
    final IMap<String, ISet<int>> iMap = IMap({
      'a': iSet1,
      'b': iSet2,
    });
    final IMapOfSets<String, int> iMapOfSets = IMapOfSets(iMap);

    test('Checking the values', () {
      expect(iMapOfSets['a'], ISet({1, 2}));
      expect(iMapOfSets['b'], ISet({1, 2, 3}));
    });
  });

  group('Basic Operations and Workflow |', () {
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

  group('Testing the remaining individual methods |', () {
    IMapOfSets<String, int> iMapOfSets = IMapOfSets.empty();
    iMapOfSets = iMapOfSets.add('a', 1);
    iMapOfSets = iMapOfSets.add('a', 2);
    iMapOfSets = iMapOfSets.add('b', 3);

    test('`entries`', () {
      final IList<MapEntry<String, ISet<int>>> entries = iMapOfSets.entries;

      expect(entries[0], MapEntry('a', ISet({1, 2})));
      expect(entries[1], MapEntry('b', ISet({3})));
    });

    test('`keys`', () {
      expect(iMapOfSets, isA<IList<int>>());
      expect(iMapOfSets.keys, ['a', 'b']);
    });

    test('`sets`', () {
      expect(iMapOfSets, isA<IList<ISet<int>>>());
      expect(iMapOfSets.sets, [
        ISet<int>({1, 2}),
        ISet<int>({3}),
      ]);
    });

    test('`values`', () => expect(iMapOfSets.values, ISet<int>({1, 2, 3})));

    test('`addSet`', () {
      
    });
  });
}
