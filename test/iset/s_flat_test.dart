import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/iset/s_flat.dart';

void main() {
  final List<int> originalList = [1, 2, 3, 3];
  final Set<int> originalSet = Set.of(originalList);
  final SFlat<int> sFlat = SFlat(originalList);

  test("Runtime Type", () => expect(sFlat, isA<SFlat<int>>()));

  test("SFlat.unlock getter", () {
    expect(sFlat.unlock, <int>{1, 2, 3});
    expect(sFlat.unlock, originalSet);
    expect(sFlat.unlock, isA<Set<int>>());
  });

  test("Emptiness Properties", () {
    expect(sFlat.isEmpty, isFalse);
    expect(sFlat.isNotEmpty, isTrue);
  });

  test("SFlat.length getter", () => expect(sFlat.length, 3));

  test("SFlat.cast method", () {
    final sFlatAsNum = sFlat.cast<num>();
    expect(sFlatAsNum, isA<SFlat<num>>());
  });

  group("Iterator |", () {
    test("Iterating on the underlying iterator", () {
      final Iterator<int> iter = sFlat.iterator;

      expect(iter.current, isNull);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 1);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 2);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 3);
      expect(iter.moveNext(), isFalse);
      expect(iter.current, isNull);
    });
  });

  test("empty", () {
    final S<int> empty = SFlat.empty();

    expect(empty.unlock, <int>{});
    expect(empty.isEmpty, isTrue);
  });

  group("Hash Code and Equals |", () {
    test("SFlat.deepSetHashCode method",
        () => expect(sFlat.deepSetHashcode(), SetEquality().hash(originalSet)));

    test("SFlat.deepSetEquals method", () {
      expect(sFlat.deepSetEquals(null), isFalse);
      expect(sFlat.deepSetEquals(SFlat<int>({})), isFalse);
      expect(sFlat.deepSetEquals(SFlat<int>(originalSet)), isTrue);
      expect(sFlat.deepSetEquals(SFlat<int>([1, 2, 3, 3])), isTrue);
      expect(sFlat.deepSetEquals(SFlat<int>([1, 2, 3, 4])), isFalse);
    });
  });

  group("Ensuring Immutability |", () {
    group("SFlat.add method |", () {
      test("Changing the passed mutable set doesn't change the SFlat", () {
        final Set<int> original = {1, 2, 3};
        final SFlat<int> sFlat = SFlat<int>(original);

        expect(sFlat, original);

        original.add(4);

        expect(original, <int>{1, 2, 3, 4});
        expect(sFlat, <int>{1, 2, 3});
      });

      test("Adding to the original SFlat doesn't change it", () {
        final Set<int> original = {1, 2, 3};
        final SFlat<int> sFlat = SFlat<int>(original);

        expect(sFlat, <int>{1, 2, 3});

        final S<int> s = sFlat.add(4);

        expect(original, <int>{1, 2, 3});
        expect(sFlat, <int>{1, 2, 3});
        expect(s, <int>{1, 2, 3, 4});
      });

      test(
          "If the item being passed is a variable, a pointer to it shouldn't exist inside SFlat",
          () {
        final Set<int> original = {1, 2, 3};
        final SFlat<int> sFlat = SFlat(original);

        expect(sFlat, original);

        int willChange = 4;
        final S<int> s = sFlat.add(willChange);

        willChange = 5;

        expect(original, <int>{1, 2, 3});
        expect(sFlat, <int>{1, 2, 3});
        expect(willChange, 5);
        expect(s, <int>{1, 2, 3, 4});
      });
    });

    group("SFlat.addAll method |", () {
      test("Changing the passed mutable set doesn't change the SFlat", () {
        final Set<int> original = {1, 2, 3};
        final SFlat<int> sFlat = SFlat(original);

        expect(sFlat, original);

        original.addAll([3, 4, 5]);

        expect(original, <int>{1, 2, 3, 4, 5});
        expect(sFlat, <int>{1, 2, 3});
      });

      test("Changing the immutable set doesn't change the SFlat", () {
        final Set<int> original = {1, 2, 3};
        final SFlat<int> sFlat = SFlat(original);

        expect(sFlat, <int>{1, 2, 3});

        final S<int> s = sFlat.addAll([3, 4, 5]);

        expect(original, <int>{1, 2, 3});
        expect(sFlat, <int>{1, 2, 3});
        expect(s, <int>{1, 2, 3, 4, 5});
      });

      test(
          "If the items being passed are from a variable, "
          "it shouldn't have a pointer to the variable", () {
        final Set<int> original = {1, 2};
        final SFlat<int> sFlat1 = SFlat(original), sFlat2 = SFlat(original);

        expect(sFlat1, <int>{1, 2});
        expect(sFlat2, <int>{1, 2});

        final S<int> s = sFlat1.addAll(sFlat2);
        original.add(5);

        expect(original, <int>{1, 2, 5});
        expect(sFlat1, <int>{1, 2});
        expect(sFlat2, <int>{1, 2});
        expect(s, <int>{1, 2});
      });
    });

    group("SFlat.remove method |", () {
      test("Changing the passed mutable set doesn't change the SFlat", () {
        final Set<int> original = {1, 2, 3};
        final SFlat<int> sFlat = SFlat(original);

        expect(sFlat, original);

        original.remove(3);

        expect(original, <int>{1, 2});
        expect(sFlat, <int>{1, 2, 3});
      });

      test("Removing from the original SFlat doesn't change it", () {
        final Set<int> original = {1, 2};
        final SFlat<int> sFlat = SFlat(original);

        expect(sFlat, <int>{1, 2});

        final S<int> s = sFlat.remove(1);

        expect(original, <int>{1, 2});
        expect(sFlat, <int>{1, 2});
        expect(s, <int>{2});
      });
    });

    group("Others |", () {
      test("Initialization through the unsafe constructor", () {
        final Set<int> original = {1, 2, 3};
        final SFlat<int> sFlat = SFlat.unsafe(original);

        expect(sFlat, original);

        original.add(4);

        expect(original, {1, 2, 3, 4});
        expect(sFlat, {1, 2, 3, 4});
      });
    });
  });

  group("MapEntryEquality Class |", () {
    const MapEntry<String, int> mapEntry1 = MapEntry('a', 1),
        mapEntry2 = MapEntry('a', 2),
        mapEntry3 = MapEntry('a', 1);

    test("MapEntryEquality.equals method", () {
      expect(MapEntryEquality().equals(mapEntry1, mapEntry1), isTrue);
      expect(MapEntryEquality().equals(mapEntry1, mapEntry2), isFalse);
      expect(MapEntryEquality().equals(mapEntry1, mapEntry3), isTrue);
    });

    test("MapEntryEquality.hash method", () {
      expect(MapEntryEquality().hash(mapEntry1), 170824771);
      expect(MapEntryEquality().hash(mapEntry2), 170824768);
      expect(MapEntryEquality().hash(mapEntry3), 170824771);
    });

    test('MapEntryEquality.hash method of a different type of object', () {
      expect(MapEntryEquality().hash(1), 1.hashCode);
      expect(MapEntryEquality().hash('a'), 'a'.hashCode);
    });

    test('MapEntryEquality.isValidKey method', () {
      fail('It is not clear what this method is supposed to do yet.'
          'It is always returning `true`');
    }, skip: true);
  });
}
