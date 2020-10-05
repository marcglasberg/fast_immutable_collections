import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_collections/src/iset/s_add.dart';
import 'package:fast_immutable_collections/src/iset/s_flat.dart';

void main() {
  final SAdd<int> sAdd = SAdd<int>(SFlat<int>.unsafe({1, 2, 3}), 4);

  test("Runtime Type", () => expect(sAdd, isA<SAdd<int>>()));

  test("SAdd.unlock method", () {
    expect(sAdd.unlock, <int>[1, 2, 3, 4]);
    expect(sAdd.unlock, isA<Set<int>>());
  });

  test("Emptiness Properties", () {
    expect(sAdd.isEmpty, isFalse);
    expect(sAdd.isNotEmpty, isTrue);
  });

  test("SAdd.length getter", () => expect(sAdd.length, 4));

  test("SAdd.contains method", () {
    expect(sAdd.contains(1), isTrue);
    expect(sAdd.contains(5), isFalse);
  });

  group("IteratorSAdd Class |", () {
    test("Iterating on the underlying iterator", () {
      final Iterator<int> iter = sAdd.iterator;

      expect(iter.current, isNull);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 1);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 2);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 3);
      expect(iter.moveNext(), isTrue);
      expect(iter.current, 4);
      expect(iter.moveNext(), isFalse);
      expect(iter.current, isNull);
    });
  });

  // TODO: Review the fact that `.add` does check for repeated elements, while the constructor doesn't.
  group("Ensuring Immutability |", () {
    group('SAdd.add method |', () {
      test("Changing the passed mutable set doesn't change the LAdd", () {
        final Set<int> original = {1, 2};
        final SFlat<int> sFlat = SFlat(original);
        final SAdd<int> sAdd = SAdd(sFlat, 3);

        expect(sAdd, <int>{1, 2, 3});

        original.add(2);
        original.add(3);

        expect(original, <int>{1, 2, 3});
        expect(sAdd, <int>{1, 2, 3});
      });

      test("Adding to the original SAdd doesn't change it", () {
        final Set<int> original = {1, 2};
        final SFlat<int> sFlat = SFlat(original);
        final SAdd<int> sAdd = SAdd(sFlat, 3);

        expect(sAdd, <int>{1, 2, 3});

        final S<int> s = sAdd.add(4);

        expect(original, <int>{1, 2});
        expect(sAdd, <int>{1, 2, 3});
        expect(s, <int>{1, 2, 3, 4});
      });

      test("If the item being passed is a variable, a pointer to it shouldn't exist inside SAdd",
          () {
        final Set<int> original = {1, 2};
        final SFlat<int> sFlat = SFlat(original);
        final SAdd<int> sAdd = SAdd(sFlat, 3);

        expect(sAdd, <int>{1, 2, 3});

        int willChange = 4;
        final S<int> s = sAdd.add(willChange);

        willChange = 5;

        expect(original, <int>{1, 2});
        expect(sAdd, <int>{1, 2, 3});
        expect(willChange, 5);
        expect(s, <int>{1, 2, 3, 4});
      });
    });

    group("SAdd.addAll method |", () {
      test("Changing the passed mutable set doesn't change the SAdd", () {
        final Set<int> original = {1, 2};
        final SFlat<int> sFlat = SFlat(original);
        final SAdd<int> sAdd = SAdd(sFlat, 3);

        expect(sAdd, <int>{1, 2, 3});

        original.addAll(<int>{3, 4});

        expect(original, <int>{1, 2, 3, 4});
        expect(sAdd, <int>{1, 2, 3});
      });

      test("Changing the passed immutable set doesn't change the original SAdd", () {
        final Set<int> original = {1, 2};
        final SFlat<int> sFlat = SFlat(original);
        final SAdd<int> sAdd = SAdd(sFlat, 3);

        expect(sAdd, <int>{1, 2, 3});

        final S<int> s = sAdd.addAll({3, 4, 5});

        expect(original, <int>{1, 2});
        expect(sAdd, <int>{1, 2, 3});
        expect(s, <int>{1, 2, 3, 4, 5});
      });

      test(
          "If the items being passed are from a variable, "
          "it shouldn't have a pointer to the variable", () {
        final Set<int> original = {1, 2};
        final SFlat<int> sFlat = SFlat(original);
        final SAdd<int> sAdd1 = SAdd(sFlat, 3), sAdd2 = SAdd(sFlat, 4);

        expect(sAdd1, <int>{1, 2, 3});
        expect(sAdd2, <int>{1, 2, 4});

        final S<int> s = sAdd1.addAll(sAdd2);
        original.add(5);

        expect(original, <int>{1, 2, 5});
        expect(sAdd1, <int>{1, 2, 3});
        expect(sAdd2, <int>{1, 2, 4});
        expect(s, <int>{1, 2, 3, 4});
      });
    });

    group("SAdd.remove method |", () {
      test("Changing the passed mutable set doesn't change the SAdd", () {
        final Set<int> original = {1, 2};
        final SFlat<int> sFlat = SFlat(original);
        final SAdd<int> sAdd = SAdd(sFlat, 3);

        expect(sAdd, <int>{1, 2, 3});

        original.remove(2);

        expect(original, <int>{1});
        expect(sAdd, <int>{1, 2, 3});
      });

      test("Removing from the original SAdd doesn't change it", () {
        final Set<int> original = {1, 2};
        final SFlat<int> sFlat = SFlat(original);
        final SAdd<int> sAdd = SAdd(sFlat, 3);

        expect(sAdd, <int>{1, 2, 3});

        final S<int> s = sAdd.remove(1);

        expect(original, <int>{1, 2});
        expect(sAdd, <int>{1, 2, 3});
        expect(s, <int>{2, 3});
      });
    });
  });
}
