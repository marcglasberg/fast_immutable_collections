import 'package:fast_immutable_collections/src/imap/m_add.dart';
import 'package:test/test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/imap/m_flat.dart';

void main() {
  group("Basic Methods |", () {
    final Map<String, int> originalMap = {'a': 1};
    final MFlat<String, int> mFlat = MFlat(originalMap);
    final MAdd<String, int> mAdd = MAdd(mFlat, 'd', 4);

    test("Emptiness Properties", () {
      expect(mAdd.isEmpty, isFalse);
      expect(mAdd.isNotEmpty, isTrue);
    });

    test("MAdd.contains method", () {
      expect(mAdd.contains('a', 1), isTrue);
      expect(mAdd.contains('b', 2), isFalse);
      expect(mAdd.contains('d', 4), isTrue);
    });

    test("MAdd.containsKey method", () {
      expect(mAdd.containsKey('a'), isTrue);
      expect(mAdd.containsKey('b'), isFalse);
      expect(mAdd.containsKey('d'), isTrue);
    });

    test("MAdd.containsValue method", () {
      expect(mAdd.containsValue(1), isTrue);
      expect(mAdd.containsValue(2), isFalse);
      expect(mAdd.containsValue(4), isTrue);
    });

    test("MAdd.entries getter", () {
      final Map<String, int> finalMap = {'a': 1, 'd': 4};

      mAdd.entries
          .forEach((MapEntry<String, int> entry) => expect(finalMap[entry.key], entry.value));
    });

    test("MAdd.keys getter", () {
      expect(mAdd.keys.contains('a'), isTrue);
      expect(mAdd.keys.contains('b'), isFalse);
      expect(mAdd.keys.contains('d'), isTrue);
    });

    test("MAdd.values getter", () {
      expect(mAdd.values.contains(1), isTrue);
      expect(mAdd.values.contains(2), isFalse);
      expect(mAdd.values.contains(4), isTrue);
    });

    test("MAdd [] Operator", () {
      expect(mAdd['a'], 1);
      expect(mAdd['b'], isNull);
      expect(mAdd['d'], 4);
    });

    test("MAdd.length getter", () => expect(mAdd.length, 2));

    group("Iterator |", () {
      test("Iterator", () {
        final Iterator<MapEntry<String, int>> iterator = mAdd.iterator;
        Map<String, int> result = iterator.toMap();
        expect(result, {'a': 1, 'd': 4});
      });
    });
  });

  group("Ensuring Immutability |", () {
    group("MAdd.add method |", () {
      test("Changing the passed mutable map doesn't change the MAdd", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAdd<String, int> mAdd = MAdd(mFlat, "c", 3);

        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

        original.addAll({"c": 3, "d": 4, "e": 5});

        expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5});
        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
      });

      test("Adding to the original MAdd doesn't change it", () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAdd<String, int> mAdd = MAdd(mFlat, "c", 3);

        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

        final M<String, int> m = mAdd.add(key: "d", value: 4);

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
        expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
      });

      test("If the item being passed is a variable, a pointer to it shouldn't exist inside MAdd",
          () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAdd<String, int> mAdd = MAdd(mFlat, "c", 3);

        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

        int willChange = 4;
        final M<String, int> m = mAdd.add(key: "d", value: willChange);

        willChange = 5;

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
        expect(willChange, 5);
        expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
      });
    });

    group("MAdd.addAll method |", () {
      test("Changing the passed immutable map doesn't change the original MAdd", () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAdd<String, int> mAdd = MAdd(mFlat, "c", 3);

        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

        final M<String, int> m = mAdd.addAll(<String, int>{"c": 3, "d": 4}.lock);

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
        expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
      });

      test(
          "If the items being passed are from a variable, "
          "it shouldn't have a pointer to the variable", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAdd<String, int> mAdd1 = MAdd(mFlat, "c", 3), mAdd2 = MAdd(mFlat, "d", 4);

        expect(mAdd1.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
        expect(mAdd2.unlock, <String, int>{"a": 1, "b": 2, "d": 4});

        final M<String, int> m = mAdd1.addAll(IMap(mAdd2.unlock));
        original.addAll({"z": 5});

        expect(original, <String, int>{"a": 1, "b": 2, "z": 5});
        expect(mAdd1.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
        expect(mAdd2.unlock, <String, int>{"a": 1, "b": 2, "d": 4});
        expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
      });
    });

    group("MAdd.remove method |", () {
      test("Changing the passed mutable map doesn't change the MAdd", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAdd<String, int> mAdd = MAdd(mFlat, "c", 3);

        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

        original.remove("b");

        expect(original, <String, int>{"a": 1});
        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
      });

      test("Removing from the original MAdd doesn't change it", () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);
        final MAdd<String, int> mAdd = MAdd(mFlat, "c", 3);

        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});

        final M<String, int> m = mAdd.remove("c");

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mAdd.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
        expect(m.unlock, <String, int>{"a": 1, "b": 2});
      });
    });
  });
}
