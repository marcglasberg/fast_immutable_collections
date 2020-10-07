import 'package:fast_immutable_collections/src/imap/m_add.dart';
import 'package:test/test.dart';

import 'package:fast_immutable_collections/src/imap/m_flat.dart';

void main() {
  final Map<String, int> originalMap = {'a': 1};
  final MFlat<String, int> mFlat = MFlat(originalMap);
  final MAdd<String, int> mAdd = MAdd(mFlat, 'd', 4);

  group("Basic Methods |", () {
    test("Emptiness Properties", () {
      expect(mAdd.isEmpty, isFalse);
      expect(mAdd.isNotEmpty, isTrue);
    });

    test("MAdd.contains method", () {
      expect(mAdd.contains('a', 1), isTrue);
      expect(mAdd.contains('d', 4), isTrue);
    });

    test("MAdd.containsKey method", () {
      expect(mAdd.containsKey('a'), isTrue);
      expect(mAdd.containsKey('d'), isTrue);
    });

    test("MAdd.containsValue method", () {
      expect(mAdd.containsValue(1), isTrue);
      expect(mAdd.containsValue(4), isTrue);
    });

    test("MAdd.entries getter", () {
      mAdd.entries.contains(MapEntry<String, int>('a', 1));
      mAdd.entries.contains(MapEntry<String, int>('d', 4));
    });

    test("MAdd.keys getter", () {
      expect(mAdd.keys.contains('a'), isTrue);
      expect(mAdd.keys.contains('d'), isTrue);
    });

    test("MAdd.values getter", () {
      expect(mAdd.values.contains(1), isTrue);
      expect(mAdd.values.contains(4), isTrue);
    });

    test("MAdd [] Operator", () {
      expect(mAdd['a'], 1);
      expect(mAdd['d'], 4);
    });

    test("MAdd.length getter", () => expect(mAdd.length, 2));
  });

  group("Iterator |", () {
    test("Iterator", () {
      final Iterator<MapEntry<String, int>> iterator = mAdd.iterator;

      expect(iterator.current, isNull);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current.key, 'a');
      expect(iterator.current.value, 1);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current.key, 'd');
      expect(iterator.current.value, 4);
      expect(iterator.moveNext(), isFalse);
      expect(iterator.current, isNull);
    });
  });
}
