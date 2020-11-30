import "package:fast_immutable_collections/src/base/hash.dart";
import "package:test/test.dart";

void main() {
  test("Hash2 | Repeating the hash yields the same result", () => expect(hash2(1, 2), hash2(1, 2)));

  test("Hash2 | Is asymmetric", () => expect(hash2(1, 2), isNot(hash2(2, 1))));

  test("Hash2 | Different values and objects", () {
    expect(hash2(1, 2), isNot(hash2(11, 12)));
    expect(hash2(1, 2), isNot(hash2("a", [1, 2])));
    expect(hash2(11, 12), isNot(hash2("a", [1, 2])));
  });

  test("Hash2 | Transitiveness", () {
    final int h1 = hash2(1, 2);
    final int h2 = hash2(1, 2);
    expect(h1, h2);
    expect(h1, isNot(hash2(2, 1)));
    expect(h2, isNot(hash2(2, 1)));
  });

  test("Hash3 | Repeating the hash yields the same result",
      () => expect(hash3(1, 2, 3), hash3(1, 2, 3)));

  test("Hash3 | Is asymmetric", () {
    expect(hash3(1, 2, 3), isNot(hash3(3, 2, 1)));
    expect(hash3(1, 2, 3), isNot(hash3(2, 1, 3)));
    expect(hash3(1, 2, 3), isNot(hash3(1, 3, 2)));
  });

  test("Hash3 | Different values and objects", () {
    expect(hash3(1, 2, 3), isNot(hash3(11, 12, 13)));
    expect(hash3(1, 2, 3), isNot(hash3("a", 99, ["d", "e"])));
    expect(hash3(11, 12, 13), isNot(hash3("a", 99, ["d", "e"])));
  });

  test("Hash3 | Transitiveness", () {
    final int h1 = hash3(1, 2, 3);
    final int h2 = hash3(1, 2, 3);
    final int h3 = hash3(1, 2, 4);
    expect(h1, h2);
    expect(h1, isNot(h3));
    expect(h2, isNot(h3));
  });

  // Not the complete permutations...
  // Shouldn't this all be some sort of recursive algorithm anyway? Why hash1, hash2, etc?

  test("Hash4 | Repeating the hash yields the same result",
      () => expect(hash4(1, 2, 3, 4), hash4(1, 2, 3, 4)));

  test("Hash4 | Is asymmetric", () {
    expect(hash4(1, 2, 3, 4), isNot(hash4(1, 2, 4, 3)));
    expect(hash4(1, 2, 3, 4), isNot(hash4(1, 4, 2, 3)));
    expect(hash4(1, 2, 3, 4), isNot(hash4(4, 1, 2, 3)));
  });

  test("Hash4 | Different values for different objects", () {
    expect(hash4(1, 2, 3, 4), isNot(hash4(11, 12, 13, 14)));
    expect(hash4(1, 2, 3, 4), isNot(hash4(1, "a", [1, 2], ["a", "b"])));
    expect(hash4(11, 12, 13, 14), isNot(hash4(1, "a", [1, 2], ["a", "b"])));
  });

  test("Hash4 | Transitiveness", () {
    final int h1 = hash4(1, 2, 3, 4);
    final int h2 = hash4(1, 2, 3, 4);
    final int h3 = hash4(1, 2, 4, 3);
    expect(h1, h2);
    expect(h1, isNot(h3));
    expect(h2, isNot(h3));
  });

  test("Hash5 | Repeating the hash yields the same result",
      () => expect(hash5(1, 2, 3, 4, 5), hash5(1, 2, 3, 4, 5)));

  test("Hash5 | Is asymmetric", () {
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(1, 2, 3, 5, 4)));
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(1, 2, 5, 3, 4)));
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(1, 5, 2, 3, 4)));
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(5, 1, 2, 3, 4)));
  });

  test("Hash5 | Different values for different objects", () {
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(11, 12, 13, 14, 15)));
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(1, "a", [1, 2], ["a", "b"], {1, 2})));
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(1, "a", [1, 2], {"a": 1, "b": 2}, {1, 2})));
  });

  test("Hash5 | Trainsitiveness", () {
    final int h1 = hash5(1, 2, 3, 4, 5);
    final int h2 = hash5(1, 2, 3, 4, 5);
    final int h3 = hash5(1, 2, 3, 5, 4);
    expect(h1, h2);
    expect(h1, isNot(h3));
    expect(h2, isNot(h3));
  });
}
