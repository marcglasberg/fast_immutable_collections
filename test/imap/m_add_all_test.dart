import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "package:fast_immutable_collections/src/imap/m_add_all.dart";
import "package:fast_immutable_collections/src/imap/m_flat.dart";

void main() {
  group("Basic Methods |", () {
    final Map<String, int> originalMap = {"a": 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MFlat<String, int> mFlatToAdd = MFlat({"b": 2, "c": 3});
    final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, mFlatToAdd);

    test("Emptiness Properties", () {
      expect(mAddAll.isEmpty, isFalse);
      expect(mAddAll.isNotEmpty, isTrue);
    });

    test("MAddAll.contains method", () {
      expect(mAddAll.contains("a", 1), isTrue);
      expect(mAddAll.contains("b", 2), isTrue);
      expect(mAddAll.contains("c", 3), isTrue);
      expect(mAddAll.contains("d", 4), isFalse);
    });

    test("MAddAll.containsKey method", () {
      expect(mAddAll.containsKey("a"), isTrue);
      expect(mAddAll.containsKey("b"), isTrue);
      expect(mAddAll.containsKey("c"), isTrue);
      expect(mAddAll.containsKey("d"), isFalse);
    });

    test("MAddAll.containsValue method", () {
      expect(mAddAll.containsValue(1), isTrue);
      expect(mAddAll.containsValue(2), isTrue);
      expect(mAddAll.containsValue(3), isTrue);
      expect(mAddAll.containsValue(4), isFalse);
    });

    test("MAddAll.entries getter", () {
      final Map<String, int> finalMap = {"a": 1, "b": 2, "c": 3};

      mAddAll.entries
          .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
    });

    test("MAddAll.keys getter", () {
      expect(mAddAll.keys.contains("a"), isTrue);
      expect(mAddAll.keys.contains("b"), isTrue);
      expect(mAddAll.keys.contains("c"), isTrue);
      expect(mAddAll.keys.contains("d"), isFalse);
    });

    test("MAddAll.values getter", () {
      expect(mAddAll.values.contains(1), isTrue);
      expect(mAddAll.values.contains(2), isTrue);
      expect(mAddAll.values.contains(3), isTrue);
      expect(mAddAll.values.contains(4), isFalse);
    });

    test("MAddAll [] Operator", () {
      expect(mAddAll["a"], 1);
      expect(mAddAll["b"], 2);
      expect(mAddAll["c"], 3);
      expect(mAddAll["d"], isNull);
    });

    test("MAddAll.length getter", () => expect(mAddAll.length, 3));

    group("Iterator |", () {
      test("Iterator", () {
        final Iterator<MapEntry<String, int>> iterator = mAddAll.iterator;
        Map<String, int> result = iterator.toMap();
        expect(result, {"a": 1, "b": 2, "c": 3});
      });
    });
  });

  group("Ensuring Immutability |", () {
    group("MAddAll.add method |", () {
      test("Changing the passed mutable map doesn't change the MAddAll", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

        expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

        original.addAll({"c": 3, "d": 4, "e": 5});

        expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5});
        expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
      });

      test("Adding to the original MAddAll doesn't change it", () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

        expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

        final M<String, int> m = mAddAll.add(key: "d", value: 4);

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
        expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
      });

      test("If the item being passed is a variable, a pointer to it shouldn't exist inside MAddAll",
          () {
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
    });

    group("MAddAll.addAll method |", () {
      test("Changing the passed immutable map doesn't change the original MAdd", () {
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
    });

    group("MAddAll.remove method |", () {
      test("Changing the passed mutable map doesn't change the MAddAll", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

        expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

        original.remove("b");

        expect(original, <String, int>{"a": 1});
        expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
      });

      test("Removing from the original MAddAll doesn't change it", () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAddAll<String, int> mAddAll = MAddAll.unsafe(mFlat, MFlat({"c": 3}));

        expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

        final M<String, int> m = mAddAll.remove("c");

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mAddAll.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
        expect(m.unlock, <String, int>{"a": 1, "b": 2});
      });
    });
  });
}
