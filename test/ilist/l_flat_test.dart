import "package:collection/collection.dart";
import "package:flutter_test/flutter_test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/ilist/l_flat.dart";

void main() {
  test("Initialization Assertion Errors", () => expect(() => LFlat(null), throwsAssertionError));

  test("LFlat.getFlushed", () {
    const List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat(original);

    expect(lFlat.getFlushed, [1, 2, 3]);
    expect(identical(original, lFlat.getFlushed), isFalse);
  });

  test("Runtime Type", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat, isA<LFlat<int>>());
  });

  test("LFlat.unlock", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat.unlock, <int>[1, 2, 3]);
    expect(lFlat.unlock, isA<List<int>>());
  });

  test("isEmpty | isNotEmpty", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat.isEmpty, isFalse);
    expect(lFlat.isNotEmpty, isTrue);
  });

  test("LFlat.length", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat.length, 3);
  });

  test("Index", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat[0], 1);
    expect(lFlat[1], 2);
    expect(lFlat[2], 3);
  });

  test("Range Errors", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(() => lFlat[-1], throwsA(isA<RangeError>()));
    expect(() => lFlat[4], throwsA(isA<RangeError>()));
  });

  test("LFlat.cast()", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    final lFlatAsNum = lFlat.cast<num>();
    expect(lFlatAsNum, isA<Iterable<num>>());
  });

  test("Iterator | Iterating on the underlying iterator", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    final Iterator<int> iter = lFlat.iterator;

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

  test("LFlat.empty()", () {
    final L<int> empty = LFlat.empty();

    expect(empty.unlock, <int>[]);
    expect(empty.isEmpty, isTrue);
  });

  test("Hash Code and Equals | LFlat.deepListHashCode()", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat.deepListHashcode(), ListEquality().hash(original));
  });

  test("Hash Code and Equals | LFlat.deepListEquals()", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat.deepListEquals(null), isFalse);
    expect(lFlat.deepListEquals(LFlat<int>([])), isFalse);
    expect(lFlat.deepListEquals(LFlat<int>(original)), isTrue);
    expect(lFlat.deepListEquals(LFlat<int>([1, 2, 3, 4])), isFalse);
  });

  test(
      "Ensuring Immutability | LFlat.add() | "
      "Changing the passed mutable list doesn't change the LFlat", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);

    expect(lFlat, original);

    original.add(4);

    expect(original, [1, 2, 3, 4]);
    expect(lFlat, [1, 2, 3]);
  });

  test(
      "Ensuring Immutability | LFlat.add() | "
      "Adding to the original LFlat doesn't change it", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat(original);

    expect(lFlat, <int>[1, 2, 3]);

    final L<int> l = lFlat.add(4);

    expect(original, <int>[1, 2, 3]);
    expect(lFlat, <int>[1, 2, 3]);
    expect(l, <int>[1, 2, 3, 4]);
  });

  test(
      "Ensuring Immutability | LFlat.add() | "
      "If the item being passed is a variable, a pointer to it shouldn't exist inside LFlat", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);

    expect(lFlat, original);

    int willChange = 4;
    final L<int> l = lFlat.add(willChange);

    willChange = 5;

    expect(original, <int>[1, 2, 3]);
    expect(lFlat, <int>[1, 2, 3]);
    expect(willChange, 5);
    expect(l, <int>[1, 2, 3, 4]);
  });

  test(
      "Ensuring Immutability | LFlat.addAll() | "
      "Changing the passed mutable list doesn't change the LFlat", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);

    expect(lFlat, original);

    original.addAll([4, 5]);

    expect(original, [1, 2, 3, 4, 5]);
    expect(lFlat, [1, 2, 3]);
  });

  test(
      "Ensuring Immutability | LFlat.addAll() | "
      "Changing the immutable list doesn't change the LFlat", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat(original);

    expect(lFlat, <int>[1, 2, 3]);

    final L<int> l = lFlat.addAll([4, 5]);

    expect(original, <int>[1, 2, 3]);
    expect(lFlat, <int>[1, 2, 3]);
    expect(l, <int>[1, 2, 3, 4, 5]);
  });

  test(
      "Ensuring Immutability | LFlat.addAll() | "
      "If the items being passed are from a variable, "
      "it shouldn't have a pointer to the variable", () {
    final List<int> original = [1, 2];
    final LFlat<int> lFlat1 = LFlat(original), lFlat2 = LFlat(original);

    expect(lFlat1, <int>[1, 2]);
    expect(lFlat2, <int>[1, 2]);

    final L<int> l = lFlat1.addAll(lFlat2);
    original.add(5);

    expect(original, <int>[1, 2, 5]);
    expect(lFlat1, <int>[1, 2]);
    expect(lFlat2, <int>[1, 2]);
    expect(l, <int>[1, 2, 1, 2]);
  });

  test(
      "Ensuring Immutability | LFlat.remove() | "
      "Changing the passed mutable list doesn't change the LFlat", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);

    expect(lFlat, original);

    original.remove(3);

    expect(original, [1, 2]);
    expect(lFlat, [1, 2, 3]);
  });

  test(
      "Ensuring Immutability | LFlat.remove() | "
      "Removing from the original LFlat doesn't change it", () {
    final List<int> original = [1, 2];
    final LFlat<int> lFlat = LFlat(original);

    expect(lFlat, <int>[1, 2]);

    final L<int> l = lFlat.remove(1);

    expect(original, <int>[1, 2]);
    expect(lFlat, <int>[1, 2]);
    expect(l, <int>[2]);
  });

  test("Ensuring Immutability " "Initialization through the unsafe constructor", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat.unsafe(original);

    expect(lFlat, original);

    original.add(4);

    expect(original, [1, 2, 3, 4]);
    expect(lFlat, [1, 2, 3, 4]);
  });

  test("LFlat.any()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.any((int v) => v == 4), isTrue);
    expect(lFlat.any((int v) => v == 100), isFalse);
  });

  test("LFlat.contains()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.contains(2), isTrue);
    expect(lFlat.contains(4), isTrue);
    expect(lFlat.contains(5), isTrue);
    expect(lFlat.contains(100), isFalse);
  });

  test("LFlat.elementAt method | Regular element access", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);

    expect(lFlat.elementAt(0), 1);
    expect(lFlat.elementAt(1), 2);
    expect(lFlat.elementAt(2), 3);
    expect(lFlat.elementAt(3), 4);
    expect(lFlat.elementAt(4), 5);
    expect(lFlat.elementAt(5), 6);
  });

  test("LFlat.elementAt() | Range exceptions", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(() => lFlat.elementAt(6), throwsRangeError);
    expect(() => lFlat.elementAt(-1), throwsRangeError);
  });

  test("LFlat.every()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.every((int v) => v > 0), isTrue);
    expect(lFlat.every((int v) => v < 0), isFalse);
    expect(lFlat.every((int v) => v != 4), isFalse);
  });

  test("LFlat.expand()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.expand((int v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
    expect(lFlat.expand((int v) => []), []);
  });

  test("LFlat.first()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.first, 1);
  });

  test("LFlat.last()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.last, 6);
  });

  test("LFlat.single() | State exception", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(() => lFlat.single, throwsStateError);
  });

  test("LFlat.single() | Access", () => expect([10].lock.single, 10));

  test("LFlat.firstWhere()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.firstWhere((int v) => v > 1, orElse: () => 100), 2);
    expect(lFlat.firstWhere((int v) => v > 4, orElse: () => 100), 5);
    expect(lFlat.firstWhere((int v) => v > 5, orElse: () => 100), 6);
    expect(lFlat.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  });

  test("LFlat.fold()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.fold(100, (int p, int e) => p * (1 + e)), 504000);
  });

  test("LFlat.followedBy()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.followedBy([7, 8]), [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(lFlat.followedBy([7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  test("LFlat.forEach()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    int result = 100;
    lFlat.forEach((int v) => result *= 1 + v);
    expect(result, 504000);
  });

  test("LFlat.join()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.join(","), "1,2,3,4,5,6");
    expect(LFlat(<int>[]).join(","), "");
    expect(LFlat.empty().join(","), "");
  });

  test("LFlat.lastWhere()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect(lFlat.lastWhere((int v) => v < 5, orElse: () => 100), 4);
    expect(lFlat.lastWhere((int v) => v < 6, orElse: () => 100), 5);
    expect(lFlat.lastWhere((int v) => v < 7, orElse: () => 100), 6);
    expect(lFlat.lastWhere((int v) => v < 50, orElse: () => 100), 6);
    expect(lFlat.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  test("LFlat.map()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(LFlat([1, 2, 3]).map((int v) => v + 1), [2, 3, 4]);
    expect(lFlat.map((int v) => v + 1), [2, 3, 4, 5, 6, 7]);
  });

  test("LFlat.reduce() | Regular usage", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.reduce((int p, int e) => p * (1 + e)), 2520);
    expect(LFlat([5]).reduce((int p, int e) => p * (1 + e)), 5);
  });

  test(
      "LFlat.reduce() | State exception",
      () => expect(
          () => IList().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError));

  test("LFlat.singleWhere () | Regular usage", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.singleWhere((int v) => v == 4, orElse: () => 100), 4);
    expect(lFlat.singleWhere((int v) => v == 50, orElse: () => 100), 100);
  });

  test("LFlat.singleWhere () | State exception", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(() => lFlat.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError);
  });

  test("LFlat.skip()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.skip(1), [2, 3, 4, 5, 6]);
    expect(lFlat.skip(3), [4, 5, 6]);
    expect(lFlat.skip(5), [6]);
    expect(lFlat.skip(10), []);
  });

  test("LFlat.skipWhile()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.skipWhile((int v) => v < 3), [3, 4, 5, 6]);
    expect(lFlat.skipWhile((int v) => v < 5), [5, 6]);
    expect(lFlat.skipWhile((int v) => v < 6), [6]);
    expect(lFlat.skipWhile((int v) => v < 100), []);
  });

  test("LFlat.take()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.take(0), []);
    expect(lFlat.take(1), [1]);
    expect(lFlat.take(3), [1, 2, 3]);
    expect(lFlat.take(5), [1, 2, 3, 4, 5]);
    expect(lFlat.take(10), [1, 2, 3, 4, 5, 6]);
  });

  test("LFlat.takeWhile()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.takeWhile((int v) => v < 3), [1, 2]);
    expect(lFlat.takeWhile((int v) => v < 5), [1, 2, 3, 4]);
    expect(lFlat.takeWhile((int v) => v < 6), [1, 2, 3, 4, 5]);
    expect(lFlat.takeWhile((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
  });

  test("LFlat.toList() | Regular usage", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
    expect(lFlat.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("LFlat.toList() | Unsupported exception", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(() => lFlat.toList(growable: false)..add(7), throwsUnsupportedError);
  });

  test("LFlat.toSet()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
    expect(
        lFlat
          ..add(6)
          ..toSet(),
        {1, 2, 3, 4, 5, 6});
    expect(lFlat.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("LFlat.where()", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.where((int v) => v < 0), []);
    expect(lFlat.where((int v) => v < 3), [1, 2]);
    expect(lFlat.where((int v) => v < 5), [1, 2, 3, 4]);
    expect(lFlat.where((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
  });

  test("LFlat.whereType()", () => expect((LFlat(<num>[1, 2, 1.5]).whereType<double>()), [1.5]));
}
