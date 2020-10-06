import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/imap/m_flat.dart';

void main() {
  final Map<String, int> originalMap = {'a': 1, 'b': 2, 'c': 3};
  final MFlat<String, int> mFlat = MFlat(originalMap);

  group("Basic Tests |", () {
    test("Runtime type", () => expect(mFlat, isA<MFlat<String, int>>()));

    test("MFlat.unlock getter", () {
      expect(mFlat.unlock, isA<Map<String, int>>());
      expect(mFlat.unlock, <String, int>{'a': 1, 'b': 2, 'c': 3});
      expect(mFlat.unlock, originalMap);
    });

    test("Emptiness Properties", () {
      expect(mFlat.isEmpty, isFalse);
      expect(mFlat.isNotEmpty, isTrue);
    });

    test("MFlat.length getter", () => expect(mFlat.length, 3));

    test("MFlat.cast method", () {
      final mFlatAsNum = mFlat.cast<String, num>();
      expect(mFlatAsNum, isA<Map<String, num>>());
    });

    test("Static MFlat.empty method", () {
      final M<String, int> empty = MFlat.empty();

      expect(empty.unlock, <String, int>{});
      expect(empty.isEmpty, isTrue);
      expect(empty.isNotEmpty, isFalse);
    });
  });

  group("Hash Code and Equals |", () {
    test("MFlat.deepMapHashCode method",
        () => expect(mFlat.deepMapHashcode(), MapEquality().hash(originalMap)));

    test("MFlat.deepMapEquals method", () {
      expect(mFlat.deepMapEquals(null), isFalse);
      expect(mFlat.deepMapEquals(MFlat<String, int>({})), isFalse);
      expect(mFlat.deepMapEquals(MFlat<String, int>({'a': 1, 'b': 2, 'c': 3})), isTrue);
      expect(mFlat.deepMapEquals(MFlat<String, int>({'a': 1, 'b': 2, 'c': 4})), isFalse);
    });
  });

  group("Ensuring Immutability", () {
    
  });
}
