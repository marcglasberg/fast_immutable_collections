import 'package:test/test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/imap/m_flat.dart';
import 'package:fast_immutable_collections/src/imap/m_replace.dart';

void main() {
  group("Basic Methods |", () {
    final Map<String, int> originalMap = {'a': 1, 'b': 2, 'c': 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int> mReplace = MReplace(mFlat, 'a', 2);
    final Map<String, int> finalMap = {'a': 2, 'b': 2, 'c': 3};

    test("Emptiness Properties", () {
      expect(mReplace.isEmpty, isFalse);
      expect(mReplace.isNotEmpty, isTrue);
    });

    test("MReplace.contains method", () {
      expect(mReplace.contains('a', 2), isTrue);
      expect(mReplace.contains('a', 1), isFalse);
    });

    test("MReplace.containsKey method",
        () => mReplace.keys.forEach((String key) => expect(finalMap.containsKey(key), isTrue)));

    test(
        "MReplace.containsValue method",
        () =>
            mReplace.values.forEach((int value) => expect(finalMap.containsValue(value), isTrue)));

    test(
        "MReplace.entries getter",
        () => mReplace.entries
            .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value)));

    test("MReplace.keys getter",
        () => mReplace.keys.forEach((String key) => expect(finalMap.containsKey(key), isTrue)));

    test(
        "MReplace.values getter",
        () =>
            mReplace.values.forEach((int value) => expect(finalMap.containsValue(value), isTrue)));

    test("MReplace [] Operator",
        () => mReplace.forEach((String key, int value) => expect(value, finalMap[key])));

    test("MReplace.length getter", () => expect(mReplace.length, 3));

    group("Iterator |", () {
      test("Iterator", () {
        final Iterator<MapEntry<String, int>> iterator = mReplace.iterator;
        Map<String, int> result = iterator.toMap();
        expect(result, finalMap);
      });
    });
  });

  // TODO: tests for ensuring immutability.
}
