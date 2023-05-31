// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/imap/imap.dart';
import "package:fast_immutable_collections/src/imap/m_add.dart";
import "package:fast_immutable_collections/src/imap/m_flat.dart";
import "package:test/test.dart";

void main() {
  //
  test("isEmpty | isNotEmpty", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, "d", 4);
    expect(mAdd.isEmpty, isFalse);
    expect(mAdd.isNotEmpty, isTrue);
  });

  test("contains", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, "d", 4);
    expect(mAdd.contains("a", 1), isTrue);
    expect(mAdd.contains("b", 2), isFalse);
    expect(mAdd.contains("d", 4), isTrue);
  });

  test("containsKey", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String?, int> mAdd = MAdd(mFlat, "d", 4);
    expect(mAdd.containsKey("a"), isTrue);
    expect(mAdd.containsKey("b"), isFalse);
    expect(mAdd.containsKey("d"), isTrue);
    expect(mAdd.containsKey(null), isFalse);
  });

  test("containsValue", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, "d", 4);
    expect(mAdd.containsValue(1), isTrue);
    expect(mAdd.containsValue(2), isFalse);
    expect(mAdd.containsValue(4), isTrue);
    expect(mAdd.containsValue(null), isFalse);
  });

  test("entries", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, "d", 4);
    const Map<String, int> finalMap = {"a": 1, "d": 4};

    mAdd.entries.forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("keys", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, "d", 4);
    expect(mAdd.keys.contains("a"), isTrue);
    expect(mAdd.keys.contains("b"), isFalse);
    expect(mAdd.keys.contains("d"), isTrue);
    expect(mAdd.keys.contains(null), isFalse);
  });

  test("values", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, "d", 4);
    expect(mAdd.values.contains(1), isTrue);
    expect(mAdd.values.contains(2), isFalse);
    expect(mAdd.values.contains(4), isTrue);
    expect(mAdd.values.contains(null), isFalse);
  });

  test("[]", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, "d", 4);
    expect(mAdd["a"], 1);
    expect(mAdd["b"], isNull);
    expect(mAdd["d"], 4);
  });

  test("length", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, "d", 4);
    expect(mAdd.length, 2);
  });

  test("iterator", () {
    const Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, "d", 4);
    final Iterator<MapEntry<String, int>> iterator = mAdd.iterator;
    Map<String, int> result = iterator.toMap();
    expect(result, {"a": 1, "d": 4});
  });

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable map doesn't change the MAdd
    Map<String, int> original = {"a": 1, "b": 2};
    MFlat<String, int> mFlat = MFlat(original);
    MAdd<String, int> mAdd = MAdd(mFlat, "c", 3);

    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    original.addAll({"c": 3, "d": 4, "e": 5});

    expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5});
    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    // 1.2) Adding to the original MAdd doesn't change it
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mAdd = MAdd(mFlat, "c", 3);

    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    M<String, int> m = mAdd.add(key: "d", value: 4);

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside MAdd
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mAdd = MAdd(mFlat, "c", 3);

    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    int willChange = 4;
    m = mAdd.add(key: "d", value: willChange);

    willChange = 5;

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(willChange, 5);
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});

    // 2) addAll

    // 2.1) Changing the passed immutable map doesn't change the original MAdd
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mAdd = MAdd(mFlat, "c", 3);

    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    m = mAdd.addAll(<String, int>{"c": 3, "d": 4}.lock);

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});

    // 2.2) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    final MAdd<String, int> mAdd1 = MAdd(mFlat, "c", 3), mAdd2 = MAdd(mFlat, "d", 4);

    expect(mAdd1.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(mAdd2.unlock, <String, int>{"a": 1, "b": 2, "d": 4});

    m = mAdd1.addAll(IMap(mAdd2.unlock));
    original.addAll({"z": 5});

    expect(original, <String, int>{"a": 1, "b": 2, "z": 5});
    expect(mAdd1.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(mAdd2.unlock, <String, int>{"a": 1, "b": 2, "d": 4});
    expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});

    // 3) remove

    // 3.1) Changing the passed mutable map doesn't change the MAdd
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mAdd = MAdd(mFlat, "c", 3);

    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    original.remove("b");

    expect(original, <String, int>{"a": 1});
    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    // 3.2) Removing from the original MAdd doesn't change it
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mAdd = MAdd(mFlat, "c", 3);

    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

    m = mAdd.remove("c");

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
    expect(m.unlock, <String, int>{"a": 1, "b": 2});
  });

  test("AddAll", () {
    // keepOrder: false
    expect(
        MFlat({"a": 1, "b": 2, "c": 3})
            .addAll({"a": 1, "b": 8, "d": 10}.lock)
            .entries
            .asComparableEntries,
        [
          MapEntry("c", 3),
          MapEntry("a", 1),
          MapEntry("b", 8),
          MapEntry("d", 10),
        ].asComparableEntries);

    // keepOrder: true
    expect(
        MFlat({"a": 1, "b": 2, "c": 3})
            .addAll({"a": 1, "b": 8, "d": 10}.lock, keepOrder: true)
            .entries
            .asComparableEntries,
        [
          MapEntry("a", 1),
          MapEntry("b", 8),
          MapEntry("c", 3),
          MapEntry("d", 10),
        ].asComparableEntries);
  });
}
