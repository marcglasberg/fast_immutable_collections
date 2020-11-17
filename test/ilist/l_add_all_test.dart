import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/ilist/l_add.dart";
import "package:fast_immutable_collections/src/ilist/l_add_all.dart";
import "package:fast_immutable_collections/src/ilist/l_flat.dart";

void main() {
  test("Runtime Type", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll, isA<LAddAll<int>>());
  });

  test("LAddAll.unlock", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll.unlock, <int>[1, 2, 3, 4, 5]);
    expect(lAddAll.unlock, isA<List<int>>());
  });

  test("isEmpty | isNotEmpty", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll.isEmpty, isFalse);
    expect(lAddAll.isNotEmpty, isTrue);
  });

  test("LAddAll.length", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll.length, 5);
  });

  test("Index Access | LAddAll[index] method", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll[0], 1);
    expect(lAddAll[1], 2);
    expect(lAddAll[2], 3);
    expect(lAddAll[3], 4);
    expect(lAddAll[4], 5);
  });

  test("Index Access | Range Errors", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(() => lAddAll[5], throwsA(isA<RangeError>()));
    expect(() => lAddAll[-1], throwsA(isA<RangeError>()));
  });

  test("LAddAll.contains()", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll.contains(1), isTrue);
    expect(lAddAll.contains(6), isFalse);
  });

  test("IteratorLAddAll Class | Iterating on the underlying iterator", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    final Iterator<int> iter = lAddAll.iterator;

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

  group("Combining various LAddAlls, LAdds, LFlats and Lists |", () {
    test("Runtime Type", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      expect(lAddAll, isA<LAddAll<int>>());
    });

    test("LAddAll.unlock method", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      expect(lAddAll.unlock, <int>[1, 2, 3, 4, 5, 6, 7, 8]);
      expect(lAddAll.unlock, isA<List<int>>());
    });

    test("isEmpty | isNotEmpty", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      expect(lAddAll.isEmpty, isFalse);
      expect(lAddAll.isNotEmpty, isTrue);
    });

    test("LAddAll.length", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      expect(lAddAll.length, 8);
    });

    test("Index Access | LAdd[index] method", () {
      final LAddAll<int> lAddAll = LAddAll(LFlat([1, 2, 3]), [4, 5, 6, 7]);

      expect(lAddAll[0], 1);
      expect(lAddAll[1], 2);
      expect(lAddAll[2], 3);
      expect(lAddAll[3], 4);
      expect(lAddAll[4], 5);
      expect(lAddAll[5], 6);
      expect(lAddAll[6], 7);
    });

    test("Index Access | Range Errors", () {
      final LAddAll<int> lAddAll = LAddAll(LFlat([1, 2, 3]), [4, 5, 6, 7]);

      expect(() => lAddAll[7], throwsA(isA<RangeError>()));
      expect(() => lAddAll[-1], throwsA(isA<RangeError>()));
    });

    test("LAddAll.contains()", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      expect(lAddAll.contains(1), isTrue);
      expect(lAddAll.contains(8), isTrue);
    });

    test("IteratorLAddAll Class | Iterating on the underlying iterator", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      final Iterator<int> iter = lAddAll.iterator;

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

  test(
      "Ensuring Immutability | LAddAll.add method | "
      "Changing the passed mutable list doesn't change the LAddAll", () {
    final List<int> original = [3, 4, 5];
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    original.add(6);

    expect(original, <int>[3, 4, 5, 6]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
  });

  test(
      "Ensuring Immutability | LAddAll.add method | "
      "Adding to the original LAddAll doesn't change it", () {
    final List<int> original = [3, 4, 5];
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    final L<int> l = lAddAll.add(6);

    expect(original, <int>[3, 4, 5]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
    expect(l, <int>[1, 2, 3, 4, 5, 6]);
  });

  test(
      "Ensuring Immutability | LAddAll.add method | "
      "If the item being passed is a variable, "
      "a pointer to it shouldn't exist inside LAddAll", () {
    final List<int> original = [3, 4, 5];
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    int willChange = 6;
    final L<int> l = lAddAll.add(willChange);

    willChange = 7;

    expect(original, <int>[3, 4, 5]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
    expect(willChange, 7);
    expect(l, <int>[1, 2, 3, 4, 5, 6]);
  });

  test(
      "Ensuring Immutability | LAddAll.addAll method | "
      "Changing the passed mutable list doesn't change the LAddAll", () {
    final List<int> original = [3, 4, 5];
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    original.addAll(<int>[6, 7]);

    expect(original, <int>[3, 4, 5, 6, 7]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
  });

  test(
      "Ensuring Immutability | LAddAll.addAll method | "
      "Changing the passed immutable list doesn't change the original LAddAll", () {
    final List<int> original = [3, 4, 5];
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    final L<int> l = lAddAll.addAll([6, 7]);

    expect(original, <int>[3, 4, 5]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
    expect(l, <int>[1, 2, 3, 4, 5, 6, 7]);
  });

  test(
      "Ensuring Immutability | LAddAll.addAll method | "
      "If the items being passed are from a variable, "
      "it shouldn't have a pointer to the variable", () {
    final List<int> original = [3, 4, 5];
    final LAddAll<int> lAddAll1 = LAddAll(LFlat<int>([1, 2]), original);
    final LAddAll<int> lAddAll2 = LAddAll(LFlat<int>([8, 9]), original);

    expect(lAddAll1, <int>[1, 2, 3, 4, 5]);
    expect(lAddAll2, <int>[8, 9, 3, 4, 5]);

    final L<int> l = lAddAll1.addAll(lAddAll2);
    original.add(6);

    expect(original, <int>[3, 4, 5, 6]);
    expect(lAddAll1, <int>[1, 2, 3, 4, 5]);
    expect(lAddAll2, <int>[8, 9, 3, 4, 5]);
    expect(l, <int>[1, 2, 3, 4, 5, 8, 9, 3, 4, 5]);
  });

  test(
      "Ensuring Immutability | LAddAll.remove method | "
      "Changing the passed mutable list doesn't change the LAddAll", () {
    final List<int> original = [3, 4, 5];
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    original.remove(3);

    expect(original, <int>[4, 5]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
  });

  test(
      "Ensuring Immutability | LAddAll.remove method | "
      "Removing from the original LAddAll doesn't change it", () {
    final List<int> original = [3, 4, 5];
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    final L<int> l = lAddAll.remove(1);

    expect(original, <int>[3, 4, 5]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
    expect(l, <int>[2, 3, 4, 5]);
  });
}
