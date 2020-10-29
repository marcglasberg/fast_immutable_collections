import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/imap/m_flat.dart";
import "package:fast_immutable_collections/src/imap/m_replace.dart";

void main() {
  group("Basic Methods |", () {
    final Map<String, int> originalMap = {"a": 1, "b": 2, "c": 3};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MReplace<String, int> mReplace = MReplace(mFlat, "a", 2);
    final Map<String, int> finalMap = {"a": 2, "b": 2, "c": 3};

    test("Emptiness Properties", () {
      expect(mReplace.isEmpty, isFalse);
      expect(mReplace.isNotEmpty, isTrue);
    });

    test("MReplace.contains method", () {
      expect(mReplace.contains("a", 2), isTrue);
      expect(mReplace.contains("a", 1), isFalse);
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

  group("Ensuring Immutability |", () {
    group("MReplace.add method |", () {
      test("Changing the passed mutable map doesn't change the MReplace", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MReplace<String, int> mReplace = MReplace(mFlat, "b", 4);

        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

        original.addAll({"c": 3, "d": 4, "e": 5});

        expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5});
        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});
      });

      test("Adding to the original MReplace doesn't change it", () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MReplace<String, int> mReplace = MReplace(mFlat, "b", 4);

        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

        final M<String, int> m = mReplace.add(key: "c", value: 3);

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});
        expect(m.unlock, <String, int>{"a": 1, "b": 4, "c": 3});
      });

      test(
          "If the item being passed is a variable, a pointer to it shouldn't exist inside MReplace",
          () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MReplace<String, int> mReplace = MReplace(mFlat, "b", 4);

        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

        int willChange = 4;
        final M<String, int> m = mReplace.add(key: "c", value: willChange);

        willChange = 5;

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});
        expect(willChange, 5);
        expect(m.unlock, <String, int>{"a": 1, "b": 4, "c": 4});
      });
    });

    group("MReplace.addAll method |", () {
      test("Changing the passed immutable map doesn't change the original MReplace", () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MReplace<String, int> mReplace = MReplace(mFlat, "b", 4);

        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

        final M<String, int> m = mReplace.addAll(<String, int>{"c": 3, "d": 4}.lock);

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});
        expect(m.unlock, <String, int>{"a": 1, "b": 4, "c": 3, "d": 4});
      });

      test(
          "If the items being passed are from a variable, "
          "it shouldn't have a pointer to the variable", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MReplace<String, int> mReplace1 = MReplace(mFlat, "b", 4),
            mReplace2 = MReplace(mFlat, "b", 5);

        expect(mReplace1.unlock, <String, int>{"a": 1, "b": 4});
        expect(mReplace2.unlock, <String, int>{"a": 1, "b": 5});

        final M<String, int> m = mReplace1.addAll(IMap(mReplace2.unlock));
        original.addAll({"z": 5});

        expect(original, <String, int>{"a": 1, "b": 2, "z": 5});
        expect(mReplace1.unlock, <String, int>{"a": 1, "b": 4});
        expect(mReplace2.unlock, <String, int>{"a": 1, "b": 5});
        expect(m.unlock, <String, int>{"a": 1, "b": 5});
      });
    });

    group("MReplace.remove method |", () {
      test("Changing the passed mutable map doesn't change the MReplace", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MReplace<String, int> mReplace = MReplace(mFlat, "b", 4);

        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

        original.remove("b");

        expect(original, <String, int>{"a": 1});
        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});
      });

      test("Removing from the original MReplace doesn't change it", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MReplace<String, int> mReplace = MReplace(mFlat, "b", 4);

        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});

        final M<String, int> m = mReplace.remove("b");

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mReplace.unlock, <String, int>{"a": 1, "b": 4});
        expect(m.unlock, <String, int>{
          "a": 1,
        });
      });
    });
  });
}
