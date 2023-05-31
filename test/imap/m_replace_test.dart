// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/imap/imap.dart';
import "package:fast_immutable_collections/src/imap/m_flat.dart";
import "package:fast_immutable_collections/src/imap/m_replace.dart";
import "package:test/test.dart";

void main() {
  //
  test("isEmpty | isNotEmpty", () {
    const Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int?> mReplace = MReplace(mFlat, "a", 2);
    expect(mReplace.isEmpty, isFalse);
    expect(mReplace.isNotEmpty, isTrue);
  });

  test("contains", () {
    // 1) Regular usage
    Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    MFlat<String, int> mFlat = MFlat(originalMap);
    MReplace<String, int?> mReplace = MReplace(mFlat, "a", 2);
    expect(mReplace.contains("a", 2), isTrue);
    expect(mReplace.contains("a", 1), isFalse);

    // 2) On the the content that's not been replaced
    originalMap = {"a": 1, "b": 2, "c": 3};
    mFlat = MFlat(originalMap);
    mReplace = MReplace(mFlat, "a", 2);
    expect(mReplace.contains("b", 2), isTrue);
    expect(mReplace.contains("c", 3), isTrue);
  });

  test("containsKey", () {
    const Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int?> mReplace = MReplace(mFlat, "a", 2);
    final Map<String, int> finalMap = {"a": 2, "b": 2, "c": 3};
    mReplace.keys.forEach((String key) => expect(finalMap.containsKey(key), isTrue));
  });

  test("containsValue", () {
    // 1) simple usage
    expect(MReplace(MFlat({"a": 1, "b": 2, "c": 3}), "a", 2).containsValue(2), isTrue);
    expect(MReplace(MFlat({"a": 1, "b": 2, "c": 3}), "a", 2).containsValue(10), isFalse);

    // 2)
    const Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int?> mReplace = MReplace(mFlat, "a", 2);
    final Map<String, int> finalMap = {"a": 2, "b": 2, "c": 3};
    mReplace.values.forEach((int? value) => expect(finalMap.containsValue(value), isTrue));
  });

  test("entries", () {
    const Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int?> mReplace = MReplace(mFlat, "a", 2);
    final Map<String, int> finalMap = {"a": 2, "b": 2, "c": 3};
    mReplace.entries
        .forEach((MapEntry<String, int?> entry) => expect(finalMap[entry.key], entry.value));
  });

  test("keys", () {
    const Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int?> mReplace = MReplace(mFlat, "a", 2);
    final Map<String, int> finalMap = {"a": 2, "b": 2, "c": 3};
    mReplace.keys.forEach((String key) => expect(finalMap.containsKey(key), isTrue));
  });

  test("values", () {
    const Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int?> mReplace = MReplace(mFlat, "a", 2);
    final Map<String, int> finalMap = {"a": 2, "b": 2, "c": 3};
    mReplace.values.forEach((int? value) => expect(finalMap.containsValue(value), isTrue));
  });

  test("[]", () {
    const Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int?> mReplace = MReplace(mFlat, "a", 2);
    final Map<String, int> finalMap = {"a": 2, "b": 2, "c": 3};
    mReplace.forEach((String key, int? value) => expect(value, finalMap[key]));
  });

  test("length", () {
    const Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int?> mReplace = MReplace(mFlat, "a", 2);
    expect(mReplace.length, 3);
  });

  test("iterator", () {
    const Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int> mReplace = MReplace(mFlat, "a", 2);
    final Map<String, int> finalMap = {"a": 2, "b": 2, "c": 3};
    final Iterator<MapEntry<String, int>> iterator = mReplace.iterator;
    Map<String, int> result = iterator.toMap();
    expect(result, finalMap);
  });

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable map doesn't change the MReplace
    Map<String, int> original = {"a": 1, "b": 2};
    MFlat<String, int> mFlat = MFlat(original);
    MReplace<String, int?> mReplace = MReplace(mFlat, "b", 4);

    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

    original.addAll({"c": 3, "d": 4, "e": 5});

    expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5});
    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

    // 1.2) Adding to the original MReplace doesn't change it
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mReplace = MReplace(mFlat, "b", 4);

    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

    M<String, int?> m = mReplace.add(key: "c", value: 3);

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});
    expect(m.unlock, <String, int>{"a": 1, "b": 4, "c": 3});

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside MReplace
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mReplace = MReplace(mFlat, "b", 4);

    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

    int willChange = 4;
    m = mReplace.add(key: "c", value: willChange);

    willChange = 5;

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});
    expect(willChange, 5);
    expect(m.unlock, <String, int>{"a": 1, "b": 4, "c": 4});

    // 2) addAll

    // 2.1) Changing the passed immutable map doesn't change the original MReplace
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mReplace = MReplace(mFlat, "b", 4);

    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

    m = mReplace.addAll(<String, int>{"c": 3, "d": 4}.lock);

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});
    expect(m.unlock, <String, int>{"a": 1, "b": 4, "c": 3, "d": 4});

    // 2.2) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    final MReplace<String, int?> mReplace1 = MReplace(mFlat, "b", 4),
        mReplace2 = MReplace(mFlat, "b", 5);

    expect(mReplace1.unlock, <String, int>{"a": 1, "b": 4});
    expect(mReplace2.unlock, <String, int>{"a": 1, "b": 5});

    m = mReplace1.addAll(IMap(mReplace2.unlock));
    original.addAll({"z": 5});

    expect(original, <String, int>{"a": 1, "b": 2, "z": 5});
    expect(mReplace1.unlock, <String, int>{"a": 1, "b": 4});
    expect(mReplace2.unlock, <String, int>{"a": 1, "b": 5});
    expect(m.unlock, <String, int>{"a": 1, "b": 5});

    // 3) remove

    // 3.1) Changing the passed mutable map doesn't change the MReplace
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mReplace = MReplace(mFlat, "b", 4);

    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

    original.remove("b");

    expect(original, <String, int>{"a": 1});
    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

    // 3.2) Removing from the original MReplace doesn't change it
    original = {"a": 1, "b": 2};
    mFlat = MFlat(original);
    mReplace = MReplace(mFlat, "b", 4);

    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

    m = mReplace.remove("b");

    expect(original, <String, int>{"a": 1, "b": 2});
    expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});
    expect(m.unlock, <String, int>{
      "a": 1,
    });
  });
}
