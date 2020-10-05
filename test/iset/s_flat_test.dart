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

      test("If the item being passed is a variable, a pointer to it shouldn't exist inside SFlat",
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

  group("Other overrides belonging to S but also coming from Iterable |", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);

    test("SFlat.any method", () {
      expect(sFlat.any((int v) => v == 4), isTrue);
      expect(sFlat.any((int v) => v == 100), isFalse);
    });

    test("SFlat.contains method", () {
      expect(sFlat.contains(2), isTrue);
      expect(sFlat.contains(4), isTrue);
      expect(sFlat.contains(5), isTrue);
      expect(sFlat.contains(100), isFalse);
    });

    test("SFlat.every method", () {
      expect(sFlat.every((int v) => v > 0), isTrue);
      expect(sFlat.every((int v) => v < 0), isFalse);
      expect(sFlat.every((int v) => v != 4), isFalse);
    });

    test("SFlat.expand method", () {
      expect(sFlat.expand((int v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
      expect(sFlat.expand((int v) => []), []);
    });

    test("SFlat.first method", () => expect(sFlat.first, 1));

    test("SFlat.last method", () => expect(sFlat.last, 6));

    group("SFlat.single method |", () {
      test("State exception", () => expect(() => sFlat.single, throwsStateError));

      test("Access", () => expect([10].lock.single, 10));
    });

    test("SFlat.firstWhere method", () {
      expect(sFlat.firstWhere((int v) => v > 1, orElse: () => 100), 2);
      expect(sFlat.firstWhere((int v) => v > 4, orElse: () => 100), 5);
      expect(sFlat.firstWhere((int v) => v > 5, orElse: () => 100), 6);
      expect(sFlat.firstWhere((int v) => v > 6, orElse: () => 100), 100);
    });

    test("SFlat.fold method", () => expect(sFlat.fold(100, (int p, int e) => p * (1 + e)), 504000));

    test("SFlat.followedBy method", () {
      expect(sFlat.followedBy([7, 8]), [1, 2, 3, 4, 5, 6, 7, 8]);
      expect(sFlat.followedBy([7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });

    test("SFlat.followedBy method", () {
      expect(sFlat.followedBy([7, 8]), [1, 2, 3, 4, 5, 6, 7, 8]);
      expect(sFlat.followedBy([7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });

    test("SFlat.forEach method", () {
      int result = 100;
      sFlat.forEach((int v) => result *= 1 + v);
      expect(result, 504000);
    });

    test("SFlat.join method", () {
      expect(sFlat.join(','), '1,2,3,4,5,6');
      expect(SFlat(<int>[]).join(','), '');
      expect(SFlat.empty().join(','), '');
    });

    test("SFlat.lastWhere method", () {
      expect(sFlat.lastWhere((int v) => v < 2, orElse: () => 100), 1);
      expect(sFlat.lastWhere((int v) => v < 5, orElse: () => 100), 4);
      expect(sFlat.lastWhere((int v) => v < 6, orElse: () => 100), 5);
      expect(sFlat.lastWhere((int v) => v < 7, orElse: () => 100), 6);
      expect(sFlat.lastWhere((int v) => v < 50, orElse: () => 100), 6);
      expect(sFlat.lastWhere((int v) => v < 1, orElse: () => 100), 100);
    });

    test("SFlat.map method", () {
      expect(SFlat([1, 2, 3]).map((int v) => v + 1), [2, 3, 4]);
      expect(sFlat.map((int v) => v + 1), [2, 3, 4, 5, 6, 7]);
    });

    group("SFlat.reduce method |", () {
      test("Regular usage", () {
        expect(sFlat.reduce((int p, int e) => p * (1 + e)), 2520);
        expect(SFlat([5]).reduce((int p, int e) => p * (1 + e)), 5);
      });

      test(
          "State exception",
          () => expect(() => ISet().reduce((dynamic p, dynamic e) => p * (1 + (e as num))),
              throwsStateError));
    });

    group("SFlat.singleWhere method |", () {
      test("Regular usage", () {
        expect(sFlat.singleWhere((int v) => v == 4, orElse: () => 100), 4);
        expect(sFlat.singleWhere((int v) => v == 50, orElse: () => 100), 100);
      });

      test(
          "State exception",
          () => expect(
              () => sFlat.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError));
    });

    test("SFlat.skip method", () {
      expect(sFlat.skip(1), [2, 3, 4, 5, 6]);
      expect(sFlat.skip(3), [4, 5, 6]);
      expect(sFlat.skip(5), [6]);
      expect(sFlat.skip(10), []);
    });

    test("SFlat.skipWhile method", () {
      expect(sFlat.skipWhile((int v) => v < 3), [3, 4, 5, 6]);
      expect(sFlat.skipWhile((int v) => v < 5), [5, 6]);
      expect(sFlat.skipWhile((int v) => v < 6), [6]);
      expect(sFlat.skipWhile((int v) => v < 100), []);
    });

    test("SFlat.take method", () {
      expect(sFlat.take(0), []);
      expect(sFlat.take(1), [1]);
      expect(sFlat.take(3), [1, 2, 3]);
      expect(sFlat.take(5), [1, 2, 3, 4, 5]);
      expect(sFlat.take(10), [1, 2, 3, 4, 5, 6]);
    });

    test("SFlat.takeWhile method", () {
      expect(sFlat.takeWhile((int v) => v < 3), [1, 2]);
      expect(sFlat.takeWhile((int v) => v < 5), [1, 2, 3, 4]);
      expect(sFlat.takeWhile((int v) => v < 6), [1, 2, 3, 4, 5]);
      expect(sFlat.takeWhile((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
    });

    group("SFlat.toList method |", () {
      test("Regular usage", () {
        expect(sFlat.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
        expect(sFlat.unlock, [1, 2, 3, 4, 5, 6]);
      });

      test("Unsupported exception",
          () => expect(() => sFlat.toList(growable: false)..add(7), throwsUnsupportedError));
    });

    test("SFlat.toSet method", () {
      expect(sFlat.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
      expect(
          sFlat
            ..add(6)
            ..toSet(),
          {1, 2, 3, 4, 5, 6});
      expect(sFlat.unlock, [1, 2, 3, 4, 5, 6]);
    });

    test("SFlat.where method", () {
      expect(sFlat.where((int v) => v < 0), []);
      expect(sFlat.where((int v) => v < 3), [1, 2]);
      expect(sFlat.where((int v) => v < 5), [1, 2, 3, 4]);
      expect(sFlat.where((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
    });

    test("SFlat.whereType method",
        () => expect((SFlat(<num>[1, 2, 1.5]).whereType<double>()), [1.5]));
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
