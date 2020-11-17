import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/ilist/l_add.dart";
import "package:fast_immutable_collections/src/ilist/l_flat.dart";

void main() {
  test("Runtime Type", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd, isA<LAdd<int>>());
  });

  test("LAdd.unlock", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd.unlock, <int>[1, 2, 3, 4]);
    expect(lAdd.unlock, isA<List<int>>());
  });

  test("isEmpty | isNotEmpty", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd.isEmpty, isFalse);
    expect(lAdd.isNotEmpty, isTrue);
  });

  test("LAdd.length method", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd.length, 4);
  });

  test("Index Access | LAdd[index]", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd[0], 1);
    expect(lAdd[1], 2);
    expect(lAdd[2], 3);
    expect(lAdd[3], 4);
  });

  test("Index Access | Range Errors", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(() => lAdd[4], throwsA(isA<RangeError>()));
    expect(() => lAdd[-1], throwsA(isA<RangeError>()));
  });

  test("LAdd.contains() method", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd.contains(1), isTrue);
    expect(lAdd.contains(5), isFalse);
  });

  test("IteratorLAdd Class | Iterating on the underlying iterator", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    final Iterator<int> iter = lAdd.iterator;

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

  test(
      "Ensuring Immutability | LAdd.add() | "
      "Changing the passed mutable list doesn't change the LAdd", () {
    final List<int> original = [1, 2];
    final LFlat<int> lFlat = LFlat(original);
    final LAdd<int> lAdd = LAdd(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    original.add(3);
    original.add(4);

    expect(original, <int>[1, 2, 3, 4]);
    expect(lAdd, <int>[1, 2, 3]);
  });

  test(
      "Ensuring Immutability | LAdd.add() | "
      "Adding to the original LAdd doesn't change it", () {
    final List<int> original = [1, 2];
    final LFlat<int> lFlat = LFlat(original);
    final LAdd<int> lAdd = LAdd<int>(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    final L<int> l = lAdd.add(4);

    expect(original, <int>[1, 2]);
    expect(lAdd, <int>[1, 2, 3]);
    expect(l, <int>[1, 2, 3, 4]);
  });

  test(
      "Ensuring Immutability | LAdd.add() | "
      "If the item being passed is a variable, a pointer to it shouldn't exist inside LAdd", () {
    final List<int> original = [1, 2];
    final LFlat<int> lFlat = LFlat(original);
    final LAdd<int> lAdd = LAdd(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    int willChange = 4;
    final L<int> l = lAdd.add(willChange);

    willChange = 5;

    expect(original, <int>[1, 2]);
    expect(lAdd, <int>[1, 2, 3]);
    expect(willChange, 5);
    expect(l, <int>[1, 2, 3, 4]);
  });

  test(
      "Ensuring Immutability | LAdd.addAll() | "
      "Changing the passed mutable list doesn't change the LAdd", () {
    final List<int> original = [1, 2];
    final LFlat<int> lFlat = LFlat(original);
    final LAdd<int> lAdd = LAdd(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    original.addAll(<int>[3, 4]);

    expect(original, <int>[1, 2, 3, 4]);
    expect(lAdd, <int>[1, 2, 3]);
  });

  test(
      "Ensuring Immutability | LAdd.addAll() | "
      "Changing the passed immutable list doesn't change the original LAdd", () {
    final List<int> original = [1, 2];
    final LFlat<int> lFlat = LFlat(original);
    final LAdd<int> lAdd = LAdd<int>(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    final L<int> l = lAdd.addAll([4, 5]);

    expect(original, <int>[1, 2]);
    expect(lAdd, <int>[1, 2, 3]);
    expect(l, <int>[1, 2, 3, 4, 5]);
  });

  test(
      "Ensuring Immutability | LAdd.addAll() | "
      "If the items being passed are from a variable, "
      "it shouldn't have a pointer to the variable", () {
    final List<int> original = [1, 2];
    final LFlat<int> lFlat = LFlat(original);
    final LAdd<int> lAdd1 = LAdd<int>(lFlat, 3), lAdd2 = LAdd<int>(lFlat, 4);

    expect(lAdd1, <int>[1, 2, 3]);
    expect(lAdd2, <int>[1, 2, 4]);

    final L<int> l = lAdd1.addAll(lAdd2);
    original.add(5);

    expect(original, <int>[1, 2, 5]);
    expect(lAdd1, <int>[1, 2, 3]);
    expect(lAdd2, <int>[1, 2, 4]);
    expect(l, <int>[1, 2, 3, 1, 2, 4]);
  });

  test(
      "Ensuring Immutability | LAdd.remove() | "
      "Changing the passed mutable list doesn't change the LAdd", () {
    final List<int> original = [1, 2];
    final LFlat<int> lFlat = LFlat(original);
    final LAdd<int> lAdd = LAdd(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    original.remove(2);

    expect(original, <int>[1]);
    expect(lAdd, <int>[1, 2, 3]);
  });

  test(
      "Ensuring Immutability | LAdd.remove() | "
      "Removing from the original LAdd doesn't change it", () {
    final List<int> original = [1, 2];
    final LFlat<int> lFlat = LFlat(original);
    final LAdd<int> lAdd = LAdd(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    final L<int> l = lAdd.remove(1);

    expect(original, <int>[1, 2]);
    expect(lAdd, <int>[1, 2, 3]);
    expect(l, <int>[2, 3]);
  });
}
