// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/imap/imap.dart';
import "package:fast_immutable_collections/src/imap/m_add_all.dart";
import "package:fast_immutable_collections/src/imap/m_flat.dart";
import "package:test/test.dart";

void main() {
  //
  test("isEmpty | isNotEmpty", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.isEmpty, isFalse);
    expect(mAddAll.isNotEmpty, isTrue);
  });

  test("contains", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.contains("a", 1), isTrue);
    expect(mAddAll.contains("b", 2), isTrue);
    expect(mAddAll.contains("c", 3), isTrue);
    expect(mAddAll.contains("d", 4), isFalse);
  });

  test("containsKey", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String?, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.containsKey("a"), isTrue);
    expect(mAddAll.containsKey("b"), isTrue);
    expect(mAddAll.containsKey("c"), isTrue);
    expect(mAddAll.containsKey("d"), isFalse);
    expect(mAddAll.keys.contains("a"), isTrue);
    expect(mAddAll.keys.contains("b"), isTrue);
    expect(mAddAll.keys.contains("c"), isTrue);
    expect(mAddAll.keys.contains("d"), isFalse);
    expect(mAddAll.containsKey(null), isFalse);
  });

  test("containsValue", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.containsValue(1), isTrue);
    expect(mAddAll.containsValue(2), isTrue);
    expect(mAddAll.containsValue(3), isTrue);
    expect(mAddAll.containsValue(4), isFalse);
    expect(mAddAll.containsValue(null), isFalse);
  });

  test("entries", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    const Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3};

    mAddAll.entries
        .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("keys", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.keys.contains(null), isFalse);
  });

  test("values", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.values.contains(1), isTrue);
    expect(mAddAll.values.contains(2), isTrue);
    expect(mAddAll.values.contains(3), isTrue);
    expect(mAddAll.values.contains(4), isFalse);
    expect(mAddAll.keys.contains("a"), isTrue);
    expect(mAddAll.keys.contains("b"), isTrue);
    expect(mAddAll.keys.contains("c"), isTrue);
    expect(mAddAll.keys.contains("d"), isFalse);
    expect(mAddAll.values.contains(null), isFalse);
  });

  test("[]", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll["a"], 1);
    expect(mAddAll["b"], 2);
    expect(mAddAll["c"], 3);
    expect(mAddAll["d"], isNull);
  });

  test("length", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    expect(mAddAll.length, 3);
  });

  test("iterator", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);
    final Iterator<MapEntry<String, int>> iterator = mAddAll.iterator;
    Map<String, int> result = iterator.toMap();
    expect(result, {"a": 1, "b": 2, "c": 3});
  });

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable map doesn't change the MAddAll
    Map<String, int> original = {"a": 1, "b": 2};
    MFlat<String, int> mFlat = MFlat(original);
    MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    original.addAll({"c": 3, "d": 4, "e": 5});

    expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    // 1.2) Adding to the original MAddAll doesn't change it
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    M<String, int> m = mAddAll.add(key: "d", value: 4);

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside MAddAll
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    int willChange = 4;
    m = mAddAll.add(key: "d", value: willChange);

    willChange = 5;

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(willChange, 5);
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});

    // 2) addAll

    // 2.1) Changing the passed immutable map doesn't change the original MAdd
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    m = mAddAll.addAll(<String, int>{"c": 3, "d": 4}.lock);

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});

    // 2.2) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    final MAddAll<String, int> mAddAll1 = MAddAll.unsafe(mFlat, MFlat({"c": 3})),
        mAddAll2 = MAddAll.unsafe(mFlat, MFlat({"d": 4}));

    expect(mAddAll1.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(mAddAll2.unlock, <String, int>{"a": 1, "b": 2, "d": 4});

    m = mAddAll1.addAll(IMap(mAddAll2.unlock));
    original.addAll({"z": 5});

    expect(original, <String, int>{"a": 1, "b": 2, "z": 5});
    expect(mAddAll1.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(mAddAll2.unlock, <String, int>{"a": 1, "b": 2, "d": 4});
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});

    // 2.3) Changing the passed mutable map doesn't change the MAddAll
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    original.remove("b");

    expect(original, <String, int>{"a": 1});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    // 3) remove

    // 3.1) Removing from the original MAddAll doesn't change it
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    m = mAddAll.remove("c");

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(m.unlock, <String, int>{"a": 1, "b": 2});
  });
}
