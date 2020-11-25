import "package:flutter_test/flutter_test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "package:fast_immutable_collections/src/imap/m_add_all.dart";
import "package:fast_immutable_collections/src/imap/m_flat.dart";

void main() {
  test("Initialization Assertion Errors", () {
    expect(() => MAddAll.unsafe(null, MFlat({"b": 2, "c": 3})), throwsAssertionError);
    expect(() => MAddAll.unsafe(MFlat({"a": 1}), null), throwsAssertionError);
    expect(() => MAddAll.unsafe(null, null), throwsAssertionError);
  });

  test("isEmpty | isNotEmpty", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.isEmpty, isFalse);
    expect(mAddAll.isNotEmpty, isTrue);
  });

  test("MAddAll.contains()", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.contains("a", 1), isTrue);
    expect(mAddAll.contains("b", 2), isTrue);
    expect(mAddAll.contains("c", 3), isTrue);
    expect(mAddAll.contains("d", 4), isFalse);
  });

  test("MAddAll.containsKey()", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.containsKey("a"), isTrue);
    expect(mAddAll.containsKey("b"), isTrue);
    expect(mAddAll.containsKey("c"), isTrue);
    expect(mAddAll.containsKey("d"), isFalse);
  });

  test("MAddAll.containsValue()", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.containsValue(1), isTrue);
    expect(mAddAll.containsValue(2), isTrue);
    expect(mAddAll.containsValue(3), isTrue);
    expect(mAddAll.containsValue(4), isFalse);
  });

  test("MAddAll.entries getter", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3};

    mAddAll.entries
        .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("MAddAll.keys getter", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.keys.contains("a"), isTrue);
    expect(mAddAll.keys.contains("b"), isTrue);
    expect(mAddAll.keys.contains("c"), isTrue);
    expect(mAddAll.keys.contains("d"), isFalse);
  });

  test("MAddAll.values getter", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.values.contains(1), isTrue);
    expect(mAddAll.values.contains(2), isTrue);
    expect(mAddAll.values.contains(3), isTrue);
    expect(mAddAll.values.contains(4), isFalse);
  });

  test("MAddAll.[] Operator", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll["a"], 1);
    expect(mAddAll["b"], 2);
    expect(mAddAll["c"], 3);
    expect(mAddAll["d"], isNull);
  });

  test("MAddAll.length getter", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.length, 3);
  });

  test("Iterator", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    final Iterator<MapEntry<String, int>> iterator = mAddAll.iterator;
    Map<String, int> result = iterator.toMap();
    expect(result, {"a": 1, "b": 2, "c": 3});
  });

  test(
      "Ensuring Immutability | MAddAll.add() | "
      "Changing the passed mutable map doesn't change the MAddAll", () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final MFlat<String, int> mFlat = MFlat(original);
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    original.addAll({"c": 3, "d": 4, "e": 5});

    expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
  });

  test(
      "Ensuring Immutability | MAddAll.add() | " "Adding to the original MAddAll doesn't change it",
      () {
    const Map<String, int> original = {"a": 1, "b": 2};
    final MFlat<String, int> mFlat = MFlat(original);
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    final M<String, int> m = mAddAll.add(key: "d", value: 4);

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
  });

  test(
      "Ensuring Immutability | MAddAll.add() | "
      "If the item being passed is a variable, a pointer to it shouldn't exist inside MAddAll", () {
    const Map<String, int> original = {"a": 1, "b": 2};
    final MFlat<String, int> mFlat = MFlat(original);
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    int willChange = 4;
    final M<String, int> m = mAddAll.add(key: "d", value: willChange);

    willChange = 5;

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(willChange, 5);
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
  });

  test(
      "Ensuring Immutability | MAddAll.addAll() | "
      "Changing the passed immutable map doesn't change the original MAdd", () {
    const Map<String, int> original = {"a": 1, "b": 2};
    final MFlat<String, int> mFlat = MFlat(original);
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    final M<String, int> m = mAddAll.addAll(<String, int>{"c": 3, "d": 4}.lock);

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
  });

  test(
      "Ensuring Immutability | MAddAll.addAll() | "
      "If the items being passed are from a variable, "
      "it shouldn't have a pointer to the variable", () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final MFlat<String, int> mFlat = MFlat(original);
    final MAddAll<String, int> mAddAll1 = MAddAll.unsafe(mFlat, MFlat({"c": 3})),
        mAddAll2 = MAddAll.unsafe(mFlat, MFlat({"d": 4}));

    expect(mAddAll1.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(mAddAll2.unlock, <String, int>{"a": 1, "b": 2, "d": 4});

    final M<String, int> m = mAddAll1.addAll(IMap(mAddAll2.unlock));
    original.addAll({"z": 5});

    expect(original, <String, int>{"a": 1, "b": 2, "z": 5});
    expect(mAddAll1.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(mAddAll2.unlock, <String, int>{"a": 1, "b": 2, "d": 4});
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
  });

  test(
      "Ensuring Immutability | MAddAll.remove() | "
      "Changing the passed mutable map doesn't change the MAddAll", () {
    final Map<String, int> original = {"a": 1, "b": 2};
    final MFlat<String, int> mFlat = MFlat(original);
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    original.remove("b");

    expect(original, <String, int>{"a": 1});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
  });

  test(
      "Ensuring Immutability | MAddAll.remove() | "
      "Removing from the original MAddAll doesn't change it", () {
    const Map<String, int> original = {"a": 1, "b": 2};
    final MFlat<String, int> mFlat = MFlat(original);
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    final M<String, int> m = mAddAll.remove("c");

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(m.unlock, <String, int>{"a": 1, "b": 2});
  });
}
