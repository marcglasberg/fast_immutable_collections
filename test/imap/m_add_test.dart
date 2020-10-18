import 'package:fast_immutable_collections/src/imap/m_add.dart';
import 'package:test/test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/imap/m_flat.dart';

void main() {
  group("Basic Methods |", () {
    final Map<String, int> originalMap = {'a': 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, 'd', 4);

    test("Emptiness Properties", () {
      expect(mAdd.isEmpty, isFalse);
      expect(mAdd.isNotEmpty, isTrue);
    });

    test("MAdd.contains method", () {
      expect(mAdd.contains('a', 1), isTrue);
      expect(mAdd.contains('b', 2), isFalse);
      expect(mAdd.contains('d', 4), isTrue);
    });

    test("MAdd.containsKey method", () {
      expect(mAdd.containsKey('a'), isTrue);
      expect(mAdd.containsKey('b'), isFalse);
      expect(mAdd.containsKey('d'), isTrue);
    });

    test("MAdd.containsValue method", () {
      expect(mAdd.containsValue(1), isTrue);
      expect(mAdd.containsValue(2), isFalse);
      expect(mAdd.containsValue(4), isTrue);
    });

    test("MAdd.entries getter", () {
      final Map<String, int> finalMap = {'a': 1, 'd': 4};

      mAdd.entries
          .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
    });

    test("MAdd.keys getter", () {
      expect(mAdd.keys.contains('a'), isTrue);
      expect(mAdd.keys.contains('b'), isFalse);
      expect(mAdd.keys.contains('d'), isTrue);
    });

    test("MAdd.values getter", () {
      expect(mAdd.values.contains(1), isTrue);
      expect(mAdd.values.contains(2), isFalse);
      expect(mAdd.values.contains(4), isTrue);
    });

    test("MAdd [] Operator", () {
      expect(mAdd['a'], 1);
      expect(mAdd['b'], isNull);
      expect(mAdd['d'], 4);
    });

    test("MAdd.length getter", () => expect(mAdd.length, 2));

    group("Iterator |", () {
      test("Iterator", () {
        final Iterator<MapEntry<String, int>> iterator = mAdd.iterator;
        Map<String, int> result = iterator.toMap();
        expect(result, {'a': 1, 'd': 4});
      });
    });
  });

  // TODO: tests for ensuring immutability.
}
