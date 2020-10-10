import 'package:test/test.dart';

import 'package:fast_immutable_collections/src/imap/m_add_all.dart';
import 'package:fast_immutable_collections/src/imap/m_flat.dart';

void main() {
  group("Basic Methods |", () {
    final Map<String, int> originalMap = {'a': 1};
    final MFlat<String, int> mFlat = MFlat(originalMap), mFlatToAdd = MFlat({'b': 2, 'c': 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);

    test("Emptiness Properties", () {
      expect(mAddAll.isEmpty, isFalse);
      expect(mAddAll.isNotEmpty, isTrue);
    });

    test("MAddAll.contains method", () {
      expect(mAddAll.contains('a', 1), isTrue);
      expect(mAddAll.contains('b', 2), isTrue);
      expect(mAddAll.contains('c', 3), isTrue);
      expect(mAddAll.contains('d', 4), isFalse);
    });

    test("MAddAll.containsKey method", () {
      expect(mAddAll.containsKey('a'), isTrue);
      expect(mAddAll.containsKey('b'), isTrue);
      expect(mAddAll.containsKey('c'), isTrue);
      expect(mAddAll.containsKey('d'), isFalse);
    });

    test("MAddAll.containsValue method", () {
      expect(mAddAll.containsValue(1), isTrue);
      expect(mAddAll.containsValue(2), isTrue);
      expect(mAddAll.containsValue(3), isTrue);
      expect(mAddAll.containsValue(4), isFalse);
    });

    test("MAddAll.entries getter", () {
      final Map<String, int> finalMap = {'a': 1, 'b': 2, 'c': 3};

      mAddAll.entries
          .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
    });

    test("MAddAll.keys getter", () {
      expect(mAddAll.keys.contains('a'), isTrue);
      expect(mAddAll.keys.contains('b'), isTrue);
      expect(mAddAll.keys.contains('c'), isTrue);
      expect(mAddAll.keys.contains('d'), isFalse);
    });

    test("MAddAll.values getter", () {
      expect(mAddAll.values.contains(1), isTrue);
      expect(mAddAll.values.contains(2), isTrue);
      expect(mAddAll.values.contains(3), isTrue);
      expect(mAddAll.values.contains(4), isFalse);
    });

    test("MAddAll [] Operator", () {
      expect(mAddAll['a'], 1);
      expect(mAddAll['b'], 2);
      expect(mAddAll['c'], 3);
      expect(mAddAll['d'], isNull);
    });

    test("MAddAll.length getter", () => expect(mAddAll.length, 3));

    group("Iterator |", () {
      test("Iterator", () {
        final Iterator<MapEntry<String, int>> iterator = mAddAll.iterator;

        int count = 0;
        Map<String, int> result = {};
        while (iterator.moveNext()) {
          count++;
          result[iterator.current.key] = iterator.current.value;
        }
        expect(count, 3);
        expect(result, {'a': 1, 'b': 2, 'c': 3});
      });
    });
  });

  // TODO: tests for ensuring immutability.
}
