import "package:fast_immutable_collections/src/base/hash.dart";
import "package:test/test.dart";

void main() {
  test("hashObj2 | Repeating the hash yields the same result",
      () => expect(hashObj2(1, 2), hashObj2(1, 2)));

  test("hashObj2 | Is asymmetric", () => expect(hashObj2(1, 2), isNot(hashObj2(2, 1))));

  test("hashObj2 | Different values and objects", () {
    expect(hashObj2(1, 2), isNot(hashObj2(11, 12)));
    expect(hashObj2(1, 2), isNot(hashObj2("a", [1, 2])));
    expect(hashObj2(11, 12), isNot(hashObj2("a", [1, 2])));
  });

  test("hashObj2 | Transitiveness", () {
    final int h1 = hashObj2(1, 2);
    final int h2 = hashObj2(1, 2);
    expect(h1, h2);
    expect(h1, isNot(hashObj2(2, 1)));
    expect(h2, isNot(hashObj2(2, 1)));
  });

  test("hashObj3 | Repeating the hash yields the same result",
      () => expect(hashObj3(1, 2, 3), hashObj3(1, 2, 3)));

  test("hashObj3 | Is asymmetric", () {
    expect(hashObj3(1, 2, 3), isNot(hashObj3(3, 2, 1)));
    expect(hashObj3(1, 2, 3), isNot(hashObj3(2, 1, 3)));
    expect(hashObj3(1, 2, 3), isNot(hashObj3(1, 3, 2)));
  });

  test("hashObj3 | Different values and objects", () {
    expect(hashObj3(1, 2, 3), isNot(hashObj3(11, 12, 13)));
    expect(hashObj3(1, 2, 3), isNot(hashObj3("a", 99, ["d", "e"])));
    expect(hashObj3(11, 12, 13), isNot(hashObj3("a", 99, ["d", "e"])));
  });

  test("hashObj3 | Transitiveness", () {
    final int h1 = hashObj3(1, 2, 3);
    final int h2 = hashObj3(1, 2, 3);
    final int h3 = hashObj3(1, 2, 4);
    expect(h1, h2);
    expect(h1, isNot(h3));
    expect(h2, isNot(h3));
  });

  // Not the complete permutations...
  // Shouldn't this all be some sort of recursive algorithm anyway? Why hash1, hash2, etc?

  test("hashObj4 | Repeating the hash yields the same result",
      () => expect(hashObj4(1, 2, 3, 4), hashObj4(1, 2, 3, 4)));

  test("hashObj4 | Is asymmetric", () {
    expect(hashObj4(1, 2, 3, 4), isNot(hashObj4(1, 2, 4, 3)));
    expect(hashObj4(1, 2, 3, 4), isNot(hashObj4(1, 4, 2, 3)));
    expect(hashObj4(1, 2, 3, 4), isNot(hashObj4(4, 1, 2, 3)));
  });

  test("hashObj4 | Different values for different objects", () {
    expect(hashObj4(1, 2, 3, 4), isNot(hashObj4(11, 12, 13, 14)));
    expect(hashObj4(1, 2, 3, 4), isNot(hashObj4(1, "a", [1, 2], ["a", "b"])));
    expect(hashObj4(11, 12, 13, 14), isNot(hashObj4(1, "a", [1, 2], ["a", "b"])));
  });

  test("hashObj4 | Transitiveness", () {
    final int h1 = hashObj4(1, 2, 3, 4);
    final int h2 = hashObj4(1, 2, 3, 4);
    final int h3 = hashObj4(1, 2, 4, 3);
    expect(h1, h2);
    expect(h1, isNot(h3));
    expect(h2, isNot(h3));
  });

  test("hashObj5 | Repeating the hash yields the same result",
      () => expect(hashObj5(1, 2, 3, 4, 5), hashObj5(1, 2, 3, 4, 5)));

  test("hashObj5 | Is asymmetric", () {
    expect(hashObj5(1, 2, 3, 4, 5), isNot(hashObj5(1, 2, 3, 5, 4)));
    expect(hashObj5(1, 2, 3, 4, 5), isNot(hashObj5(1, 2, 5, 3, 4)));
    expect(hashObj5(1, 2, 3, 4, 5), isNot(hashObj5(1, 5, 2, 3, 4)));
    expect(hashObj5(1, 2, 3, 4, 5), isNot(hashObj5(5, 1, 2, 3, 4)));
  });

  test("hashObj5 | Different values for different objects", () {
    expect(hashObj5(1, 2, 3, 4, 5), isNot(hashObj5(11, 12, 13, 14, 15)));
    expect(hashObj5(1, 2, 3, 4, 5), isNot(hashObj5(1, "a", [1, 2], ["a", "b"], {1, 2})));
    expect(hashObj5(1, 2, 3, 4, 5), isNot(hashObj5(1, "a", [1, 2], {"a": 1, "b": 2}, {1, 2})));
  });

  test("hashObj5 | Trainsitiveness", () {
    final int h1 = hashObj5(1, 2, 3, 4, 5);
    final int h2 = hashObj5(1, 2, 3, 4, 5);
    final int h3 = hashObj5(1, 2, 3, 5, 4);
    expect(h1, h2);
    expect(h1, isNot(h3));
    expect(h2, isNot(h3));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("hash2 | Repeating the hash yields the same result", () => expect(hash2(1, 2), hash2(1, 2)));

  test("hash2 | Is asymmetric", () => expect(hash2(1, 2), isNot(hash2(2, 1))));

  test("hash2 | Different values", () {
    expect(hash2(1, 2), isNot(hash2(11, 12)));
    expect(hash2(1, 2), isNot(hash2(100, 1000)));
    expect(hash2(11, 12), isNot(hash2(3, 4)));
  });

  test("hash2 | Transitiveness", () {
    final int h1 = hash2(1, 2);
    final int h2 = hash2(1, 2);
    expect(h1, h2);
    expect(h1, isNot(hash2(2, 1)));
    expect(h2, isNot(hash2(2, 1)));
  });

  test("hash3 | Repeating the hash yields the same result",
      () => expect(hash3(1, 2, 3), hash3(1, 2, 3)));

  test("hash3 | Is asymmetric", () {
    expect(hash3(1, 2, 3), isNot(hash3(3, 2, 1)));
    expect(hash3(1, 2, 3), isNot(hash3(2, 1, 3)));
    expect(hash3(1, 2, 3), isNot(hash3(1, 3, 2)));
  });

  test("hash3 | Different values and objects", () {
    expect(hash3(1, 2, 3), isNot(hash3(11, 12, 13)));
    expect(hash3(1, 2, 3), isNot(hash3(100, 99, 98)));
  });

  test("hash3 | Transitiveness", () {
    final int h1 = hash3(1, 2, 3);
    final int h2 = hash3(1, 2, 3);
    final int h3 = hash3(1, 2, 4);
    expect(h1, h2);
    expect(h1, isNot(h3));
    expect(h2, isNot(h3));
  });

  test("hash4 | Repeating the hash yields the same result",
      () => expect(hash4(1, 2, 3, 4), hash4(1, 2, 3, 4)));

  test("hash4 | Is asymmetric", () {
    expect(hash4(1, 2, 3, 4), isNot(hash4(1, 2, 4, 3)));
    expect(hash4(1, 2, 3, 4), isNot(hash4(1, 4, 2, 3)));
    expect(hash4(1, 2, 3, 4), isNot(hash4(4, 1, 2, 3)));
  });

  test("hash4 | Different values for different objects", () {
    expect(hash4(1, 2, 3, 4), isNot(hash4(11, 12, 13, 14)));
    expect(hash4(1, 2, 3, 4), isNot(hash4(1, 10, 100, 1000)));
  });

  test("hash4 | Transitiveness", () {
    final int h1 = hash4(1, 2, 3, 4);
    final int h2 = hash4(1, 2, 3, 4);
    final int h3 = hash4(1, 2, 4, 3);
    expect(h1, h2);
    expect(h1, isNot(h3));
    expect(h2, isNot(h3));
  });

  test("hash5 | Repeating the hash yields the same result",
      () => expect(hash5(1, 2, 3, 4, 5), hash5(1, 2, 3, 4, 5)));

  test("hash5 | Is asymmetric", () {
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(1, 2, 3, 5, 4)));
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(1, 2, 5, 3, 4)));
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(1, 5, 2, 3, 4)));
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(5, 1, 2, 3, 4)));
  });

  test("hash5 | Different values for different objects", () {
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(11, 12, 13, 14, 15)));
    expect(hash5(1, 2, 3, 4, 5), isNot(hash5(1, 10, 100, 1000, 10000)));
  });

  test("hash5 | Trainsitiveness", () {
    final int h1 = hash5(1, 2, 3, 4, 5);
    final int h2 = hash5(1, 2, 3, 4, 5);
    final int h3 = hash5(1, 2, 3, 5, 4);
    expect(h1, h2);
    expect(h1, isNot(h3));
    expect(h2, isNot(h3));
  });
}
