import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group('Testing the remaining methods.', () {
    IMapOfSets<String, int> iMapOfSets = IMapOfSets.empty();
    iMapOfSets = iMapOfSets.add('a', 1);
    iMapOfSets = iMapOfSets.add('a', 2);
    iMapOfSets = iMapOfSets.add('b', 3);

    test('`[]`', () {
      expect(iMapOfSets['a'], ISet({1, 2}));
      expect(iMapOfSets['b'], ISet({3}));
    });

    test("entries", () {
      final ISet<MapEntry<String, ISet<int>>> entries = iMapOfSets.entrySet;

      print('iMapOfSets = ${iMapOfSets}');
      expect(
          entries,
          ISet([
            MapEntry('a', ISet({1, 2})),
            MapEntry('b', ISet({3})),
          ]).deepEquals);
    });

    test('`keys`', () {
      expect(iMapOfSets.keys, isA<Iterable<String>>());
      expect(iMapOfSets.keys, ['a', 'b']);
    });

    test('`sets`', () {
      expect(iMapOfSets.sets, isA<Iterable<ISet<int>>>());
      expect(iMapOfSets.sets, [
        ISet<int>({1, 2}),
        ISet<int>({3}),
      ]);
    });

    test('`values`', () => expect(iMapOfSets.values, ISet<int>({1, 2, 3})));

    test('`add`', () {
      final IMapOfSets<String, int> newSet = iMapOfSets.add('a', 5);
      expect(newSet['a'], ISet({1, 2, 5}));
    });

    test('`remove`', () {
      final IMapOfSets<String, int> newSet = iMapOfSets.add('a', 2);
      expect(newSet['a'], ISet({1, 2}));
    });

    test('`addSet`', () {
      final IMapOfSets<String, int> newSet = iMapOfSets.addSet('b', ISet({2, 3, 4}));
      expect(newSet['b'], ISet({2, 3, 4}));
    });

    test('`removeSet`', () {
      final IMapOfSets<String, int> newSet = iMapOfSets.removeSet('a');
      expect(newSet.keys.length, 1);
    });

    // TODO: Marcelo, o nome da função é `getOrNull` mas ela nunca retorna `null`? Pelo menos é isso
    // que está escrito na documentação...
    test('`getOrNull`', () {
      expect(iMapOfSets.getOrNull('a'), ISet<int>({1, 2}));
      expect(iMapOfSets.getOrNull('b'), ISet<int>({3}));
      expect(iMapOfSets.getOrNull('c'), null);
    });

    test('`get`', () {
      expect(iMapOfSets.get('a'), ISet<int>({1, 2}));
      expect(iMapOfSets.get('b'), ISet<int>({3}));
      expect(iMapOfSets.get('c'), ISet<int>());
    });

    test('`containsKey`', () {
      expect(iMapOfSets.containsKey('a'), isTrue);
      expect(iMapOfSets.containsKey('b'), isTrue);
      expect(iMapOfSets.containsKey('c'), isFalse);
    });

    test('`containsValue`', () {
      expect(iMapOfSets.containsValue(1), isTrue);
      expect(iMapOfSets.containsValue(2), isTrue);
      expect(iMapOfSets.containsValue(3), isTrue);
      expect(iMapOfSets.containsValue(4), isFalse);
    });

    test('`contains`', () {
      expect(iMapOfSets.contains('a', 1), isTrue);
      expect(iMapOfSets.contains('a', 2), isTrue);
      expect(iMapOfSets.contains('b', 3), isTrue);
      expect(iMapOfSets.contains('b', 4), isFalse);
      expect(iMapOfSets.contains('c', 1), isFalse);
    });

    test('`entryWithValue`', () {
      expect(iMapOfSets.entryWithValue(1).entry, Entry('a', ISet<int>({1, 2})));
      expect(iMapOfSets.entryWithValue(2).entry, Entry('a', ISet<int>({1, 2})));
      expect(iMapOfSets.entryWithValue(3).entry, Entry('b', ISet<int>({3})));
      expect(iMapOfSets.entryWithValue(4), isNull);
    });

    test('`keyWithValue`', () {
      expect(iMapOfSets.keyWithValue(1), 'a');
      expect(iMapOfSets.keyWithValue(2), 'a');
      expect(iMapOfSets.keyWithValue(3), 'b');
      expect(iMapOfSets.keyWithValue(4), isNull);
    });

    test('`toString`', () => expect(iMapOfSets.toString(), '{a: {1, 2}, b: {3}}'));
  });
}
