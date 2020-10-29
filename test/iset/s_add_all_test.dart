import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/iset/s_add_all.dart";
import "package:fast_immutable_collections/src/iset/s_add.dart";
import "package:fast_immutable_collections/src/iset/s_flat.dart";

void main() {
  group("Basic Usage Tests and Checks |", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});

    test("Runtime Type", () => expect(sAddAll, isA<SAddAll<int>>()));

    test("SAddAll.unlock method", () {
      expect(sAddAll.unlock, [1, 2, 3, 4, 5]);
      expect(sAddAll.unlock, isA<Set<int>>());
    });

    test("Emptiness Properties", () {
      expect(sAddAll.isEmpty, isFalse);
      expect(sAddAll.isNotEmpty, isTrue);
    });

    test("SAddAll.length", () => expect(sAddAll.length, 5));

    test("SAddAll.contains method", () {
      expect(sAddAll.contains(1), isTrue);
      expect(sAddAll.contains(6), isFalse);
    });

    group("IteratorSAddAll Class |", () {
      test("Iterating on the underlying iterator", () {
        final Iterator<int> iter = sAddAll.iterator;

        expect(iter.current, isNull);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 1);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 2);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 3);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 4);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 5);
        expect(iter.moveNext(), isFalse);
        expect(iter.current, isNull);
      });
    });
  });

  group("Combining various SAddAlls and SAdds", () {
    final sAddAll = SAddAll(
        SAddAll(SAddAll(SAdd(SAddAll(SFlat.unsafe({1, 2}), {3, 4}), 5), {6, 7}), <int>{}), {8});

    test("Runtime Type", () => expect(sAddAll, isA<SAddAll<int>>()));

    test("SAddAll.unlock", () {
      expect(sAddAll.unlock, [1, 2, 3, 4, 5, 6, 7, 8]);
      expect(sAddAll.unlock, isA<Set<int>>());
    });

    test("Emptiness Properties", () {
      expect(sAddAll.isEmpty, isFalse);
      expect(sAddAll.isNotEmpty, isTrue);
    });

    test("SAddAll.length", () => expect(sAddAll.length, 8));

    test("SAddAll.contains method", () {
      expect(sAddAll.contains(1), isTrue);
      expect(sAddAll.contains(9), isFalse);
    });

    group("IteratorSAddAll Class |", () {
      test("Iterating on the underlying iterator", () {
        final Iterator<int> iter = sAddAll.iterator;

        expect(iter.current, isNull);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 1);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 2);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 3);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 4);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 5);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 6);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 7);
        expect(iter.moveNext(), isTrue);
        expect(iter.current, 8);
        expect(iter.moveNext(), isFalse);
        expect(iter.current, isNull);
      });
    });
  });

  group("Ensuring Immutability |", () {
    group("SAddAll.add method |", () {
      test("Changing the passed mutable set doesn't change the SAddAll", () {
        final Set<int> original = {3, 4, 5};
        final SAddAll<int> sAddAll = SAddAll(SFlat<int>({1, 2}), original);

        expect(sAddAll, <int>{1, 2, 3, 4, 5});

        original.add(5);
        original.add(6);

        expect(original, <int>{3, 4, 5, 6});
        expect(sAddAll, <int>{1, 2, 3, 4, 5});
      });

      test("Adding to the original SAddAll doesn't change it", () {
        final Set<int> original = {3, 4, 5};
        final SAddAll<int> sAddAll = SAddAll(SFlat<int>({1, 2}), original);

        expect(sAddAll, <int>{1, 2, 3, 4, 5});

        final S<int> s1 = sAddAll.add(6);
        final S<int> s2 = sAddAll.add(5);

        expect(original, <int>{3, 4, 5});
        expect(sAddAll, <int>{1, 2, 3, 4, 5});
        expect(s1, <int>{1, 2, 3, 4, 5, 6});
        expect(s2, <int>{1, 2, 3, 4, 5});
      });

      test(
          "If the item being passed is a variable, "
          "a pointer to it shouldn't exist inside SAddAll", () {
        final Set<int> original = {3, 4, 5};
        final SAddAll<int> sAddAll = SAddAll(SFlat<int>({1, 2}), original);

        expect(sAddAll, <int>{1, 2, 3, 4, 5});

        int willChange = 6;
        final S<int> s = sAddAll.add(willChange);

        willChange = 7;

        expect(original, <int>{3, 4, 5});
        expect(sAddAll, <int>{1, 2, 3, 4, 5});
        expect(willChange, 7);
        expect(s, <int>{1, 2, 3, 4, 5, 6});
      });
    });

    group("SAddAll.addAll method |", () {
      test("Changing the passed mutable set doesn't change the SAddAll", () {
        final Set<int> original = {3, 4, 5};
        final SAddAll<int> sAddAll = SAddAll(SFlat<int>({1, 2}), original);

        expect(sAddAll, <int>{1, 2, 3, 4, 5});

        original.addAll(<int>{5, 6, 7});

        expect(original, <int>{3, 4, 5, 6, 7});
        expect(sAddAll, <int>{1, 2, 3, 4, 5});
      });

      test("Changing the passed immutable set doesn't change the original SAddAll", () {
        final Set<int> original = {3, 4, 5};
        final SAddAll<int> sAddAll = SAddAll(SFlat<int>({1, 2}), original);

        expect(sAddAll, <int>{1, 2, 3, 4, 5});

        final S<int> s = sAddAll.addAll({6, 7});

        expect(original, <int>{3, 4, 5});
        expect(sAddAll, <int>{1, 2, 3, 4, 5});
        expect(s, <int>{1, 2, 3, 4, 5, 6, 7});
      });

      test(
          "If the items being passed are from a variable, "
          "it shouldn't have a pointer to the variable", () {
        final Set<int> original = {3, 4, 5};
        final SAddAll<int> sAddAll1 = SAddAll(SFlat<int>({1, 2}), original),
            sAddAll2 = SAddAll(SFlat<int>({8, 9}), original);

        expect(sAddAll1, <int>{1, 2, 3, 4, 5});
        expect(sAddAll2, <int>{8, 9, 3, 4, 5});

        final S<int> s = sAddAll1.addAll(sAddAll2);
        original.add(6);

        expect(original, <int>{3, 4, 5, 6});
        expect(sAddAll1, <int>{1, 2, 3, 4, 5});
        expect(sAddAll2, <int>{8, 9, 3, 4, 5});
        expect(s, <int>{1, 2, 3, 4, 5, 8, 9});
      });
    });

    group("SAddAll.remove method |", () {
      test("Changing the passed mutable set doesn't change SAddAll", () {
        final Set<int> original = {3, 4, 5};
        final SAddAll<int> sAddAll = SAddAll(SFlat<int>({1, 2}), original);

        expect(sAddAll, <int>{1, 2, 3, 4, 5});

        original.remove(3);

        expect(original, <int>{4, 5});
        expect(sAddAll, <int>{1, 2, 3, 4, 5});
      });

      test("Removing from the original SAddAll doesn't change it", () {
        final Set<int> original = {3, 4, 5};
        final SAddAll<int> sAddAll = SAddAll(SFlat<int>({1, 2}), original);

        expect(sAddAll, <int>{1, 2, 3, 4, 5});

        final S<int> s = sAddAll.remove(1);

        expect(original, <int>{3, 4, 5});
        expect(sAddAll, <int>{1, 2, 3, 4, 5});
        expect(s, <int>{2, 3, 4, 5});
      });
    });
  });
}
