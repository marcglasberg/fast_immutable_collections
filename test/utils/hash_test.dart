import 'package:test/test.dart';

import 'package:fast_immutable_collections/src/utils/hash.dart';

void main() {
  group("Hash2 |", () {
    final List<int> hashList = [
      hash2(1, 2),
      hash2(1, 2),
      hash2(2, 1),
      hash2(11, 12),
      hash2('a', [1, 2]),
    ];

    test("Runtime Type", () => expect(hashList, isA<List<int>>()));

    test("Repeating the hash yields the same result", () => expect(hashList[0], hashList[1]));

    test("Is asymmetric", () => expect(hashList[0], isNot(hashList[2])));

    test("Different values and objects", () {
      expect(hashList[0], isNot(hashList[3]));
      expect(hashList[0], isNot(hashList[4]));
      expect(hashList[3], isNot(hashList[4]));
    });

    test("Transitiveness", () {
      expect(hashList[0], hashList[1]);
      expect(hashList[0], isNot(hashList[2]));
      expect(hashList[1], isNot(hashList[2]));
    });
  });

  group("Hash3 |", () {
    final List<int> hashList = [
      hash3(1, 2, 3),
      hash3(1, 2, 3),
      hash3(3, 2, 1),
      hash3(2, 1, 3),
      hash3(1, 3, 2),
      hash3(11, 12, 13),
      hash3('a', 99, ['d', 'e']),
    ];

    test("Runtime Type", () => expect(hashList, isA<List<int>>()));

    test("Repeating the hash yields the same result", () => expect(hashList[0], hashList[1]));

    test("Is asymmetric", () {
      expect(hashList[0], isNot(hashList[2]));
      expect(hashList[0], isNot(hashList[3]));
      expect(hashList[0], isNot(hashList[4]));
    });

    test("Different values and objects", () {
      expect(hashList[0], isNot(hashList[5]));
      expect(hashList[0], isNot(hashList[6]));
      expect(hashList[5], isNot(hashList[6]));
    });

    test("Transitiveness", () {
      expect(hashList[0], hashList[1]);
      expect(hashList[0], isNot(hashList[2]));
      expect(hashList[1], isNot(hashList[2]));
    });
  });

  group("Hash4 |", () {
    // Not the complete permutations...
    // Shouldn't this be some sort of recursive algorithm anyway? Why hash1, hash2, etc?
    final List<int> hashList = [
      hash4(1, 2, 3, 4),
      hash4(1, 2, 3, 4),
      hash4(1, 2, 4, 3),
      hash4(1, 4, 2, 3),
      hash4(4, 1, 2, 3),
      hash4(11, 12, 13, 14),
      hash4(1, 'a', [1, 2], ['a', 'b']),
    ];

    test("Runtime Type", () => expect(hashList, isA<List<int>>()));

    test("Repeating the hash yields the same result", () => expect(hashList[0], hashList[1]));

    test("Is asymmetric", () {
      expect(hashList[0], isNot(hashList[2]));
      expect(hashList[0], isNot(hashList[3]));
      expect(hashList[0], isNot(hashList[4]));
    });

    test("Different values for different objects", () {
      expect(hashList[0], isNot(hashList[5]));
      expect(hashList[0], isNot(hashList[6]));
      expect(hashList[5], isNot(hashList[6]));
    });

    test("Transitiveness", () {
      expect(hashList[0], hashList[1]);
      expect(hashList[0], isNot(hashList[2]));
      expect(hashList[1], isNot(hashList[2]));
    });
  });
}
