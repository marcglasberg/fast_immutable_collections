import "package:collection/collection.dart";
import "package:flutter_test/flutter_test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/iset/s_flat.dart";

void main() {
  test("Initialization Assertion Error", () => expect(() => SFlat(null), throwsAssertionError));

  test("SFlat.getFlushed",
      () => expect(SFlat({1, 2, 3}).getFlushed, allOf(isA<Set<int>>(), {1, 2, 3})));

  test("Runtime Type", () => expect(SFlat([1, 2, 3, 3]), isA<SFlat<int>>()));

  test("SFlat.unlock getter", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 3]);
    expect(sFlat.unlock, isA<Set<int>>());
    expect(sFlat.unlock, <int>{1, 2, 3});
  });

  test("isEmpty | isNotEmpty", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 3]);
    expect(sFlat.isEmpty, isFalse);
    expect(sFlat.isNotEmpty, isTrue);
  });

  test("SFlat.length getter", () => expect(SFlat([1, 2, 3, 3]).length, 3));

  test("SFlat.cast()", () {
    final sFlatAsNum = SFlat([1, 2, 3, 3]).cast<num>();
    expect(sFlatAsNum, isA<Iterable<num>>());
  });

  test("Iterating on the underlying iterator", () {
    final Iterator<int> iter = SFlat([1, 2, 3, 3]).iterator;

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

  test("Static SFlat.empty method", () {
    final S<int> empty = SFlat.empty();

    expect(empty.unlock, <int>{});
    expect(empty.isEmpty, isTrue);
    expect(empty.isNotEmpty, isFalse);
  });

  test("Hash Code and Equals | SFlat.deepSetHashCode()",
      () => expect(SFlat([1, 2, 3, 3]).deepSetHashcode(), SetEquality().hash({1, 2, 3})));

  test("Hash Code and Equals | SFlat.deepSetEquals()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 3]);
    expect(sFlat.deepSetEquals(null), isFalse);
    expect(sFlat.deepSetEquals(SFlat<int>({})), isFalse);
    expect(sFlat.deepSetEquals(SFlat<int>({1, 2, 3})), isTrue);
    expect(sFlat.deepSetEquals(SFlat<int>([1, 2, 3, 3])), isTrue);
    expect(sFlat.deepSetEquals(SFlat<int>([1, 2, 3, 4])), isFalse);
  });

  test("Hash Code and Equals | SFlat.deepSetEquals_toIterable()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 3]);
    final Iterable<int> iterable1 = [3, 2, 1];
    final Iterable<int> iterable2 = [1, 2];

    expect(sFlat.deepSetEquals_toIterable(null), isFalse);
    expect(sFlat.deepSetEquals_toIterable(iterable1), isTrue);
    expect(sFlat.deepSetEquals_toIterable(iterable2), isFalse);
  });

  test(
      "Ensuring Immutability | SFlat.add() | "
      "Changing the passed mutable set doesn't change the SFlat", () {
    final Set<int> original = {1, 2, 3};
    final SFlat<int> sFlat = SFlat<int>(original);

    expect(sFlat, original);

    original.add(3);
    original.add(4);

    expect(original, <int>{1, 2, 3, 4});
    expect(sFlat, <int>{1, 2, 3});
  });

  test("Ensuring Immutability | SFlat.add() | " "Adding to the original SFlat doesn't change it",
      () {
    final Set<int> original = {1, 2, 3};
    final SFlat<int> sFlat = SFlat<int>(original);

    expect(sFlat, <int>{1, 2, 3});

    final S<int> s1 = sFlat.add(4);
    final S<int> s2 = sFlat.add(3);

    expect(original, <int>{1, 2, 3});
    expect(sFlat, <int>{1, 2, 3});
    expect(s1, <int>{1, 2, 3, 4});
    expect(s2, <int>{1, 2, 3});
  });

  test(
      "Ensuring Immutability | SFlat.add() | "
      "If the item being passed is a variable, a pointer to it shouldn't exist inside SFlat", () {
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

  test(
      "Ensuring Immutability | SFlat.addAll() | "
      "Changing the passed mutable set doesn't change the SFlat", () {
    final Set<int> original = {1, 2, 3};
    final SFlat<int> sFlat = SFlat(original);

    expect(sFlat, original);

    original.addAll([3, 4, 5]);

    expect(original, <int>{1, 2, 3, 4, 5});
    expect(sFlat, <int>{1, 2, 3});
  });

  test(
      "Ensuring Immutability | SFlat.addAll() | "
      "Changing the immutable set doesn't change the SFlat", () {
    final Set<int> original = {1, 2, 3};
    final SFlat<int> sFlat = SFlat(original);

    expect(sFlat, <int>{1, 2, 3});

    final S<int> s = sFlat.addAll([3, 4, 5]);

    expect(original, <int>{1, 2, 3});
    expect(sFlat, <int>{1, 2, 3});
    expect(s, <int>{1, 2, 3, 4, 5});
  });

  test(
      "Ensuring Immutability | SFlat.addAll() | "
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

  test(
      "Ensuring Immutability | SFlat.remove() | "
      "Changing the passed mutable set doesn't change the SFlat", () {
    final Set<int> original = {1, 2, 3};
    final SFlat<int> sFlat = SFlat(original);

    expect(sFlat, original);

    original.remove(3);

    expect(original, <int>{1, 2});
    expect(sFlat, <int>{1, 2, 3});
  });

  test(
      "Ensuring Immutability | SFlat.remove() | "
      "Removing from the original SFlat doesn't change it", () {
    final Set<int> original = {1, 2};
    final SFlat<int> sFlat = SFlat(original);

    expect(sFlat, <int>{1, 2});

    final S<int> s = sFlat.remove(1);

    expect(original, <int>{1, 2});
    expect(sFlat, <int>{1, 2});
    expect(s, <int>{2});
  });

  test("Ensuring Immutability | Others | " "Initialization through the unsafe constructor", () {
    final Set<int> original = {1, 2, 3};
    final SFlat<int> sFlat = SFlat.unsafe(original);

    expect(sFlat, original);

    original.add(4);

    expect(original, {1, 2, 3, 4});
    expect(sFlat, {1, 2, 3, 4});
  });

  test("SFlat.any()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.any((int v) => v == 4), isTrue);
    expect(sFlat.any((int v) => v == 100), isFalse);
  });

  test("SFlat.contains()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.contains(2), isTrue);
    expect(sFlat.contains(4), isTrue);
    expect(sFlat.contains(5), isTrue);
    expect(sFlat.contains(100), isFalse);
  });

  test("SFlat.every()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.every((int v) => v > 0), isTrue);
    expect(sFlat.every((int v) => v < 0), isFalse);
    expect(sFlat.every((int v) => v != 4), isFalse);
  });

  test("SFlat.expand()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.expand((int v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
    expect(sFlat.expand((int v) => []), []);
  });

  test("SFlat.first()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.first, 1);
  });

  test("SFlat.last()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.last, 6);
  });

  test("SFlat.single method | State exception", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(() => sFlat.single, throwsStateError);
  });

  test("SFlat.single method | Access", () => expect([10].lock.single, 10));

  test("SFlat.firstWhere()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.firstWhere((int v) => v > 1, orElse: () => 100), 2);
    expect(sFlat.firstWhere((int v) => v > 4, orElse: () => 100), 5);
    expect(sFlat.firstWhere((int v) => v > 5, orElse: () => 100), 6);
    expect(sFlat.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  });

  test("SFlat.fold()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.fold(100, (int p, int e) => p * (1 + e)), 504000);
  });

  test("SFlat.followedBy()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.followedBy([7, 8]), [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(sFlat.followedBy([7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  test("SFlat.followedBy()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.followedBy([7, 8]), [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(sFlat.followedBy([7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  test("SFlat.forEach()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    int result = 100;
    sFlat.forEach((int v) => result *= 1 + v);
    expect(result, 504000);
  });

  test("SFlat.join()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.join(","), "1,2,3,4,5,6");
    expect(SFlat(<int>[]).join(","), "");
    expect(SFlat.empty().join(","), "");
  });

  test("SFlat.lastWhere()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect(sFlat.lastWhere((int v) => v < 5, orElse: () => 100), 4);
    expect(sFlat.lastWhere((int v) => v < 6, orElse: () => 100), 5);
    expect(sFlat.lastWhere((int v) => v < 7, orElse: () => 100), 6);
    expect(sFlat.lastWhere((int v) => v < 50, orElse: () => 100), 6);
    expect(sFlat.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  test("SFlat.map()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(SFlat([1, 2, 3]).map((int v) => v + 1), [2, 3, 4]);
    expect(sFlat.map((int v) => v + 1), [2, 3, 4, 5, 6, 7]);
  });

  test("SFlat.reduce() | Regular usage", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.reduce((int p, int e) => p * (1 + e)), 2520);
    expect(SFlat([5]).reduce((int p, int e) => p * (1 + e)), 5);
  });

  test(
      "SFlat.reduce() | State exception",
      () => expect(
          () => ISet().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError));

  test("SFlat.singleWhere() | Regular usage", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.singleWhere((int v) => v == 4, orElse: () => 100), 4);
    expect(sFlat.singleWhere((int v) => v == 50, orElse: () => 100), 100);
  });

  test("SFlat.singleWhere() | State exception", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(() => sFlat.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError);
  });

  test("SFlat.skip()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.skip(1), [2, 3, 4, 5, 6]);
    expect(sFlat.skip(3), [4, 5, 6]);
    expect(sFlat.skip(5), [6]);
    expect(sFlat.skip(10), []);
  });

  test("SFlat.skipWhile()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.skipWhile((int v) => v < 3), [3, 4, 5, 6]);
    expect(sFlat.skipWhile((int v) => v < 5), [5, 6]);
    expect(sFlat.skipWhile((int v) => v < 6), [6]);
    expect(sFlat.skipWhile((int v) => v < 100), []);
  });

  test("SFlat.take()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.take(0), []);
    expect(sFlat.take(1), [1]);
    expect(sFlat.take(3), [1, 2, 3]);
    expect(sFlat.take(5), [1, 2, 3, 4, 5]);
    expect(sFlat.take(10), [1, 2, 3, 4, 5, 6]);
  });

  test("SFlat.takeWhile()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.takeWhile((int v) => v < 3), [1, 2]);
    expect(sFlat.takeWhile((int v) => v < 5), [1, 2, 3, 4]);
    expect(sFlat.takeWhile((int v) => v < 6), [1, 2, 3, 4, 5]);
    expect(sFlat.takeWhile((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
  });

  test("SFlat.toList() | Regular usage", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
    expect(sFlat.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("SFlat.toList() | Unsupported exception", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(() => sFlat.toList(growable: false)..add(7), throwsUnsupportedError);
  });

  test("SFlat.toSet()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
    expect(
        sFlat
          ..add(6)
          ..toSet(),
        {1, 2, 3, 4, 5, 6});
    expect(sFlat.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("SFlat.where()", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.where((int v) => v < 0), []);
    expect(sFlat.where((int v) => v < 3), [1, 2]);
    expect(sFlat.where((int v) => v < 5), [1, 2, 3, 4]);
    expect(sFlat.where((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
  });

  test("SFlat.whereType()", () => expect((SFlat(<num>[1, 2, 1.5]).whereType<double>()), [1.5]));

  test("MapEntryEquality.equals()", () {
    const MapEntry<String, int> mapEntry1 = MapEntry("a", 1);
    const MapEntry<String, int> mapEntry2 = MapEntry("a", 2);
    const MapEntry<String, int> mapEntry3 = MapEntry("a", 1);
    expect(MapEntryEquality().equals(mapEntry1, mapEntry1), isTrue);
    expect(MapEntryEquality().equals(mapEntry1, mapEntry2), isFalse);
    expect(MapEntryEquality().equals(mapEntry1, mapEntry3), isTrue);
  });

  test("MapEntryEquality.hash()", () {
    const MapEntry<String, int> mapEntry1 = MapEntry("a", 1);
    const MapEntry<String, int> mapEntry2 = MapEntry("a", 2);
    const MapEntry<String, int> mapEntry3 = MapEntry("a", 1);
    expect(mapEntry1 == mapEntry2, isFalse);
    expect(mapEntry1 == mapEntry3, isTrue);
    expect(mapEntry1.hashCode, isNot(mapEntry2.hashCode));
    expect(mapEntry1.hashCode, mapEntry3.hashCode);
  });

  test("MapEntryEquality.hash() of a different type of object", () {
    expect(MapEntryEquality().hash(1), 1.hashCode);
    expect(MapEntryEquality().hash("a"), "a".hashCode);
  });

  test("MapEntryEquality.isValidKey()", () => expect(MapEntryEquality().isValidKey(1), isTrue));
}
