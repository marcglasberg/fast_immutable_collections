import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/imap/m_flat.dart';

void main() {
  final Map<String, int> originalMap = {'a': 1, 'b': 2, 'c': 3};
  final MFlat<String, int> mFlat = MFlat(originalMap);

  group("Basic Tests |", () {
    test("Runtime type", () => expect(mFlat, isA<MFlat<String, int>>()));

    test("MFlat.unlock getter", () {
      expect(mFlat.unlock, isA<Map<String, int>>());
      expect(mFlat.unlock, <String, int>{'a': 1, 'b': 2, 'c': 3});
      expect(mFlat.unlock, originalMap);
    });

    test("Emptiness Properties", () {
      expect(mFlat.isEmpty, isFalse);
      expect(mFlat.isNotEmpty, isTrue);
    });

    test("MFlat.length getter", () => expect(mFlat.length, 3));

    test("MFlat.cast method", () {
      final mFlatAsNum = mFlat.cast<String, num>();
      expect(mFlatAsNum, isA<Map<String, num>>());
    });

    test("Static MFlat.empty method", () {
      final M<String, int> empty = MFlat.empty();

      expect(empty.unlock, <String, int>{});
      expect(empty.isEmpty, isTrue);
      expect(empty.isNotEmpty, isFalse);
    });
  });

  group("Hash Code and Equals |", () {
    test("MFlat.deepMapHashCode method",
        () => expect(mFlat.deepMapHashcode(), MapEquality().hash(originalMap)));

    test("MFlat.deepMapEquals method", () {
      expect(mFlat.deepMapEquals(null), isFalse);
      expect(mFlat.deepMapEquals(MFlat<String, int>({})), isFalse);
      expect(mFlat.deepMapEquals(MFlat<String, int>({'a': 1, 'b': 2, 'c': 3})), isTrue);
      expect(mFlat.deepMapEquals(MFlat<String, int>({'a': 1, 'b': 2, 'c': 4})), isFalse);
    });

    test("MFlat.deepMapEquals_toIterable method", () {
      final Iterable<MapEntry<String, int>> entries1 = [
            MapEntry<String, int>('b', 2),
            MapEntry<String, int>('a', 1),
            MapEntry<String, int>('c', 3),
          ],
          entries2 = [
            MapEntry<String, int>('a', 1),
            MapEntry<String, int>('b', 2),
          ];

      expect(mFlat.deepMapEquals_toIterable(null), isFalse);
      expect(mFlat.deepMapEquals_toIterable(entries1), isTrue);
      expect(mFlat.deepMapEquals_toIterable(entries2), isFalse);
    });
  });

  test("Initialization through the unsafe constructor", () {
    final Map<String, int> original = {'a': 1, 'b': 2, 'c': 3};
    final MFlat<String, int> mFlat = MFlat.unsafe(original);

    expect(mFlat.unlock, original);

    original.addAll({'d': 4});

    expect(original, {'a': 1, 'b': 2, 'c': 3, 'd': 4});
    expect(mFlat.unlock, {'a': 1, 'b': 2, 'c': 3, 'd': 4});
  });

  group("Other Methods and Getters |", () {
    final MFlat<String, int> mFlat = MFlat({'a': 1, 'b': 2, 'c': 3, 'd': 4});

    test(
        "MFlat.entries getter",
        () => mFlat.entries
            .forEach((MapEntry<String, int> entry) => expect(mFlat[entry.key], entry.value)));

    test(
        "MFlat.keys getter", () => expect(mFlat.keys.toSet(), IList(['a', 'b', 'c', 'd']).toSet()));

    test("MFlat.values getter", () => expect(mFlat.values.toSet(), IList([1, 2, 3, 4]).toSet()));

    test("MFlat.any method", () {
      expect(mFlat.any((String key, int value) => key == 'a'), isTrue);
      expect(mFlat.any((String key, int value) => key == 'z'), isFalse);
      expect(mFlat.any((String key, int value) => value == 4), isTrue);
      expect(mFlat.any((String key, int value) => value == 100), isFalse);
    });

    test("MFlat.contains method", () {
      expect(mFlat.contains('a', 1), isTrue);
      expect(mFlat.contains('a', 2), isFalse);
      expect(mFlat.contains('b', 1), isFalse);
    });

    test("MFlat.containsKey method", () {
      expect(mFlat.containsKey('a'), isTrue);
      expect(mFlat.containsKey('z'), isFalse);
    });

    test("MFlat.containsValue method", () {
      expect(mFlat.containsValue(1), isTrue);
      expect(mFlat.containsValue(100), isFalse);
    });

    test("MFlat.[] operator", () {
      expect(mFlat['a'], 1);
      expect(mFlat['z'], isNull);
    });
  });

  group("Ensuring Immutability |", () {
    group("MFlat.add method |", () {
      test("Changing the passed mutable map doesn't change the MAdd", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);

        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});

        original.addAll({"c": 3, "d": 4, "e": 5});

        expect(original, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5});
        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});
      });

      test("Adding to the original MFlat doesn't change it", () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);

        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});

        final M<String, int> m = mFlat.add(key: "c", value: 3);

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});
        expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3});
      });

      test("If the item being passed is a variable, a pointer to it shouldn't exist inside MAdd",
          () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);

        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});

        int willChange = 4;
        final M<String, int> m = mFlat.add(key: "c", value: willChange);

        willChange = 5;

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});
        expect(willChange, 5);
        const Map<String, int> finalMap = <String, int>{"a": 1, "b": 2, "c": 4};
        m.unlock.forEach((String key, int value) => expect(m[key], finalMap[key]));
      });
    });

    group("MFlat.addAll method |", () {
      test("Changing the passed immutable map doesn't change the original MFlat", () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);

        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});

        final M<String, int> m = mFlat.addAll(<String, int>{"c": 3, "d": 4}.lock);

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});
        expect(m.unlock, <String, int>{"a": 1, "b": 2, "c": 3, "d": 4});
      });

      test(
          "If the items being passed are from a variable, "
          "it shouldn't have a pointer to the variable", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat1 = MFlat(original), mFlat2 = MFlat(original);

        expect(mFlat1.unlock, <String, int>{"a": 1, "b": 2});
        expect(mFlat2.unlock, <String, int>{"a": 1, "b": 2});

        final M<String, int> m = mFlat1.addAll(IMap(mFlat2.unlock));
        original.addAll({"z": 5});

        expect(original, <String, int>{"a": 1, "b": 2, "z": 5});
        expect(mFlat1.unlock, <String, int>{"a": 1, "b": 2});
        expect(mFlat2.unlock, <String, int>{"a": 1, "b": 2});
        expect(m.unlock, <String, int>{"a": 1, "b": 2});
      });
    });

    group("MFlat.remove method |", () {
      test("Changing the passed mutable map doesn't change the MFlat", () {
        final Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);

        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});

        original.remove("b");

        expect(original, <String, int>{"a": 1});
        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});
      });

      test("Removing from the original MFlat doesn't change it", () {
        const Map<String, int> original = {"a": 1, "b": 2};
        final MFlat<String, int> mFlat = MFlat(original);

        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});

        final M<String, int> m = mFlat.remove("b");

        expect(original, <String, int>{"a": 1, "b": 2});
        expect(mFlat.unlock, <String, int>{"a": 1, "b": 2});
        expect(m.unlock, <String, int>{"a": 1});
      });
    });
  });
}
