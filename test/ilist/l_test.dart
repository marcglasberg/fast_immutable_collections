import "dart:collection";

import "package:flutter_test/flutter_test.dart";
import "package:matcher/matcher.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

/// These tests are mainly for coverage purposes, it tests methods inside the [L] class which were
/// not reached by its implementations.
void main() {
  //////////////////////////////////////////////////////////////////////////////

  test("sort", () {
    final L sorted = LExample<MapEntry<String, int>>(
        [const MapEntry<String, int>("c", 3), const MapEntry<String, int>("b", 2)]).sort();
    expect(
        sorted.unlock, [const MapEntry<String, int>("b", 2), const MapEntry<String, int>("c", 3)]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("sortOrdered", () {
    final L sorted = LExample<MapEntry<String, int>>(
        [const MapEntry<String, int>("c", 3), const MapEntry<String, int>("b", 2)]).sortOrdered();
    expect(
        sorted.unlock, [const MapEntry<String, int>("b", 2), const MapEntry<String, int>("c", 3)]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("sortLike", () {
    final LExample<int> lExample = LExample<int>([1, 3, 5, 4, 2]);

    // 1) Regular usage
    expect(lExample.sortLike([1, 2]), [1, 2, 3, 5, 4]);

    // 2) Assertion error
    expect(() => lExample.sortLike(null), throwsAssertionError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("isEmpty | isNotEmpty", () {
    expect(LExample([]).isEmpty, isTrue);
    expect(LExample([]).isNotEmpty, isFalse);

    expect(LExample([1, 2, 3]).isEmpty, isFalse);
    expect(LExample([1, 2, 3]).isNotEmpty, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("any", () {
    final LExample<int> ilist = LExample([1, 2, 3, 4, 5, 6]);
    expect(ilist.any((int v) => v == 4), isTrue);
    expect(ilist.any((int v) => v == 100), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("cast", () {
    const TypeMatcher<TypeError> isTypeError = TypeMatcher<TypeError>();
    final Matcher throwsTypeError = throwsA(isTypeError);

    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.cast<num>(), isA<Iterable<num>>());
    expect(() => lExample.cast<String>(), throwsTypeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("elementAt", () {
    final LExample<String> lExample = LExample(["a", "b", "c", "d", "e", "f"]);
    expect(lExample.elementAt(0), "a");
    expect(lExample.elementAt(1), "b");
    expect(lExample.elementAt(2), "c");
    expect(lExample.elementAt(3), "d");
    expect(lExample.elementAt(4), "e");
    expect(lExample.elementAt(5), "f");

    expect(() => lExample.elementAt(6), throwsRangeError);
    expect(() => lExample.elementAt(-1), throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("every", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.every((int v) => v > 0), isTrue);
    expect(lExample.every((int v) => v < 0), isFalse);
    expect(lExample.every((int v) => v != 4), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("expand", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.expand((int v) => [v, v]),
        allOf(isA<Iterable<int>>(), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6].lock));
    expect(lExample.expand((int v) => <int>[]), allOf(isA<Iterable<int>>(), <int>[].lock));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("length, first, last, single", () {
    final LExample lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.length, 6);
    expect(lExample.first, 1);
    expect(lExample.last, 6);
    expect([10].lock.single, 10);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("firstWhere", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.firstWhere((int v) => v > 1, orElse: () => 100), 2);
    expect(lExample.firstWhere((int v) => v > 4, orElse: () => 100), 5);
    expect(lExample.firstWhere((int v) => v > 5, orElse: () => 100), 6);
    expect(lExample.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("fold", () {
    expect(LExample([1, 2, 3, 4, 5, 6]).fold(100, (int p, int e) => p * (1 + e)), 504000);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("followedBy", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.followedBy([7, 8]), [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(
        lExample.followedBy(LExample(<int>[]).add(7).addAll([8, 9])), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("forEach", () {
    int result = 100;
    LExample([1, 2, 3, 4, 5, 6]).forEach((int v) => result *= 1 + v);
    expect(result, 504000);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("join", () {
    expect(LExample([1, 2, 3, 4, 5, 6]).join(","), "1,2,3,4,5,6");
    expect([].lock.join(","), "");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("lastWhere", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect(lExample.lastWhere((int v) => v < 5, orElse: () => 100), 4);
    expect(lExample.lastWhere((int v) => v < 6, orElse: () => 100), 5);
    expect(lExample.lastWhere((int v) => v < 7, orElse: () => 100), 6);
    expect(lExample.lastWhere((int v) => v < 50, orElse: () => 100), 6);
    expect(lExample.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("map", () {
    expect(LExample([1, 2, 3]).map((int v) => v + 1), [2, 3, 4]);
    expect(LExample([1, 2, 3, 4, 5, 6]).map((int v) => v + 1), [2, 3, 4, 5, 6, 7]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reduce", () {
    expect(LExample([1, 2, 3, 4, 5, 6]).reduce((int p, int e) => p * (1 + e)), 2520);
    expect(LExample([5]).reduce((int p, int e) => p * (1 + e)), 5);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("singleWhere", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.singleWhere((int v) => v == 4, orElse: () => 100), 4);
    expect(lExample.singleWhere((int v) => v == 50, orElse: () => 100), 100);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("skip", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.skip(1), [2, 3, 4, 5, 6]);
    expect(lExample.skip(3), [4, 5, 6]);
    expect(lExample.skip(5), [6]);
    expect(lExample.skip(10), <int>[]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("skipWhile", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.skipWhile((int v) => v < 3), [3, 4, 5, 6]);
    expect(lExample.skipWhile((int v) => v < 5), [5, 6]);
    expect(lExample.skipWhile((int v) => v < 6), [6]);
    expect(lExample.skipWhile((int v) => v < 100), []);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("take", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.take(0), []);
    expect(lExample.take(1), [1]);
    expect(lExample.take(3), [1, 2, 3]);
    expect(lExample.take(5), [1, 2, 3, 4, 5]);
    expect(lExample.take(10), [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("takeWhile", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.takeWhile((int v) => v < 3), [1, 2]);
    expect(lExample.takeWhile((int v) => v < 5), [1, 2, 3, 4]);
    expect(lExample.takeWhile((int v) => v < 6), [1, 2, 3, 4, 5]);
    expect(lExample.takeWhile((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("where", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.where((int v) => v < 0), []);
    expect(lExample.where((int v) => v < 3), [1, 2]);
    expect(lExample.where((int v) => v < 5), [1, 2, 3, 4]);
    expect(lExample.where((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("whereType", () {
    expect((LExample(<num>[1, 2, 1.5]).whereType<double>()), [1.5]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("toList", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
    expect(lExample, [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("toSet", () {
    final LExample<int> lExample = LExample([1, 2, 3, 4, 5, 6]);
    expect(lExample.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
    expect(
        lExample
          ..add(6)
          ..toSet(),
        {1, 2, 3, 4, 5, 6});
    expect(lExample.unlock, [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("toHashSet", () {
    final LExample<int> lExample = LExample([1, 2, 3, 3, 4, 5, 6]);
    expect(lExample.toHashSet(), allOf(isA<HashSet<int>>(), {1, 2, 3, 4, 5, 6}));
  });

  //////////////////////////////////////////////////////////////////////////////
}

//////////////////////////////////////////////////////////////////////////////

@visibleForTesting
class LExample<T> extends L<T> {
  final IList<T> _ilist;

  LExample(Iterable<T> iterable) : _ilist = IList(iterable);

  @override
  Iterator<T> get iterator => _ilist.iterator;
}

//////////////////////////////////////////////////////////////////////////////
