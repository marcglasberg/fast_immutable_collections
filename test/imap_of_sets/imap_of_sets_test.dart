import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/imap_of_sets/imap_of_sets.dart';
import 'package:test/test.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  group('A map of sets |', () {
    //

    test('Basic test.', () {
      IMapOfSets<String, int> mapOfSets = IMapOfSets();
      expect(mapOfSets, isA<IMapOfSets<String, int>>());
      expect(mapOfSets.isEmpty, isTrue);
      expect(mapOfSets.isNotEmpty, isFalse);

      mapOfSets = mapOfSets.add('a', 1);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets['a'], ISet<int>([1]));

      mapOfSets = mapOfSets.add('a', 2);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets['a'], ISet<int>([1, 2]));

      mapOfSets = mapOfSets.add('b', 3);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets['a'], ISet<int>([1, 2]));
      expect(mapOfSets['b'], ISet<int>([3]));

      mapOfSets = mapOfSets.remove('a', 1);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets['a'], ISet<int>([2]));

      mapOfSets = mapOfSets.remove('b', 3);
      expect(mapOfSets.isEmpty, isFalse);
      expect(mapOfSets.isNotEmpty, isTrue);
      expect(mapOfSets['a'], ISet<int>([1, 2]));
      expect(mapOfSets['b'].isEmpty, true);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}
