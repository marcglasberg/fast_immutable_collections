// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/ilist/ilist.dart";
import "package:fast_immutable_collections/src/ilist/l_add.dart";
import "package:fast_immutable_collections/src/ilist/l_add_all.dart";
import "package:fast_immutable_collections/src/ilist/l_flat.dart";
import "package:test/test.dart";

/// Tests that the methods of chains of [LAdd] and [LAddAll] nodes work for
/// chains of any length, without recursion (which would overflow the stack).
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  /// Note: Comparing sets with `expect(set, otherSet)` is O(n²), which is too
  /// slow for very large sets, so we compare their lengths and items instead.
  void expectSameSet(Iterable<int> actual, Set<int> expected) {
    final Set<int> actualSet = actual.toSet();
    expect(actualSet.length, expected.length);
    expect(expected.containsAll(actualSet), isTrue);
  }

  /// Checks the methods of [l] against the [expected] items.
  void checkAll(Iterable<int> l, List<int> expected) {
    final int length = expected.length;
    expect(l.length, length);
    expect(l.isEmpty, expected.isEmpty);
    expect(l.isNotEmpty, expected.isNotEmpty);

    final List<int> iterated = [];
    for (final int item in l) iterated.add(item);
    expect(iterated, expected);
    expect(l.toList(), expected);
    expect(l.toList(growable: false), expected);

    if (length == 0) {
      expect(() => l.first, throwsStateError);
      expect(() => l.last, throwsStateError);
      expect(() => l.single, throwsStateError);
      expect(() => l.elementAt(0), throwsRangeError);
    } else {
      expect(l.first, expected.first);
      expect(l.last, expected.last);
      if (length == 1)
        expect(l.single, expected.single);
      else
        expect(() => l.single, throwsStateError);
      for (final int index in {0, length ~/ 3, length ~/ 2, length - 1}) {
        expect(l.elementAt(index), expected[index]);
        if (l is L<int>) expect(l[index], expected[index]);
        if (l is IList<int>) expect(l[index], expected[index]);
      }
      expect(() => l.elementAt(length), throwsRangeError);
      expect(l.contains(expected[length ~/ 2]), isTrue);
      expect(l.reduce((a, b) => a + b), expected.reduce((a, b) => a + b));
    }
    expect(l.contains(-999999), isFalse);

    expect(l.join(","), expected.join(","));
    expect(l.where((x) => x.isEven).toList(), expected.where((x) => x.isEven).toList());
    expect(l.map((x) => x * 2).toList(), expected.map((x) => x * 2).toList());
    expect(l.any((x) => x == expected.lastOrNull), expected.isNotEmpty);
    expect(l.every((x) => x > -999999), isTrue);
    expect(l.fold<int>(0, (a, b) => a + b), expected.fold<int>(0, (a, b) => a + b));
    int sum = 0;
    l.forEach((x) => sum += x);
    expect(sum, expected.fold<int>(0, (a, b) => a + b));
    expect(l.firstWhere((x) => x > 5, orElse: () => -1),
        expected.firstWhere((x) => x > 5, orElse: () => -1));
    expect(l.lastWhere((x) => x < 5, orElse: () => -1),
        expected.lastWhere((x) => x < 5, orElse: () => -1));
    expect(l.skip(length ~/ 2).toList(), expected.skip(length ~/ 2).toList());
    expect(l.take(3).toList(), expected.take(3).toList());
    expectSameSet(l.toSet(), expected.toSet());
    expect(l.followedBy([7]).toList(), [...expected, 7]);
    expect(l.cast<num>().toList(), expected);
    if (l is L<int>) {
      expect(l.unlock, expected);
      expect(l.getFlushed, expected);
    }
    if (l is IList<int>) {
      expect(l.unlock, expected);
      expect(l.flush, expected);
    }
  }

  test("Random shallow chains", () {
    final Random random = Random(42);
    for (int round = 0; round < 100; round++) {
      final List<int> expected = [for (int i = 0; i < random.nextInt(4); i++) i];
      L<int> l = LFlat<int>(expected);
      for (int i = 0; i < random.nextInt(20); i++) {
        switch (random.nextInt(3)) {
          case 0:
            l = LAdd(l, i);
            expected.add(i);
          case 1:
            final List<int> items = [for (int j = 0; j < random.nextInt(3); j++) j];
            l = LAddAll(l, items);
            expected.addAll(items);
          default:
            L<int> other = LFlat<int>([100 + i]);
            final List<int> otherExpected = [100 + i];
            for (int j = 0; j < random.nextInt(4); j++) {
              other = LAdd(other, 200 + j);
              otherExpected.add(200 + j);
            }
            l = LAddAll(l, other);
            expected.addAll(otherExpected);
        }
      }
      checkAll(l, expected);
    }
  });

  test("A very deep chain", () {
    const int depth = 100000;
    L<int> l = LFlat<int>([-1]);
    final List<int> expected = [-1];
    for (int i = 0; i < depth; i++) {
      l = (i % 3 == 0) ? LAddAll(l, [i]) : LAdd(l, i);
      expected.add(i);
    }
    checkAll(l, expected);
  });

  test("A very deep chain of empty addAlls", () {
    const int depth = 100000;
    L<int> l = LFlat<int>([]);
    for (int i = 0; i < depth; i++) l = LAddAll(l, <int>[]);
    checkAll(l, []);
    checkAll(LAdd(l, 5), [5]);
    checkAll(LAddAll(LAdd(l, 5), <int>[]), [5]);
  });

  test("IList with a very deep chain", () {
    const int depth = 100000;
    IList<int> ilist = IList<int>([-1]);
    final List<int> expected = [-1];
    for (int i = 0; i < depth; i++) {
      ilist = (i % 3 == 0) ? ilist.addAll([i]) : ilist.add(i);
      expected.add(i);
    }
    expect(ilist.isFlushed, isFalse);
    checkAll(ilist, expected);
  });
}
