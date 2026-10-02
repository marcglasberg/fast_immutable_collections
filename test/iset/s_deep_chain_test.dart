// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/iset/iset.dart";
import "package:fast_immutable_collections/src/iset/s_add.dart";
import "package:fast_immutable_collections/src/iset/s_add_all.dart";
import "package:fast_immutable_collections/src/iset/s_flat.dart";
import "package:test/test.dart";

/// Tests that the methods of chains of [SAdd] and [SAddAll] nodes work for
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

  /// Checks the methods of [s] against the [expected] items, in iteration order.
  void checkAll(Iterable<int> s, List<int> expected) {
    final int length = expected.length;
    final Set<int> expectedSet = expected.toSet();
    expect(s.length, length);
    expect(s.isEmpty, expected.isEmpty);
    expect(s.isNotEmpty, expected.isNotEmpty);

    final List<int> iterated = [];
    for (final int item in s) iterated.add(item);
    expect(iterated, expected);
    expect(s.toList(), expected);

    if (length == 0) {
      expect(() => s.first, throwsStateError);
      expect(() => s.last, throwsStateError);
      expect(() => s.single, throwsStateError);
    } else {
      expect(s.first, expected.first);
      expect(s.last, expected.last);
      if (length == 1)
        expect(s.single, expected.single);
      else
        expect(() => s.single, throwsStateError);
      for (final int index in {0, length ~/ 3, length ~/ 2, length - 1}) {
        expect(s.elementAt(index), expected[index]);
        if (s is S<int>) expect(s[index], expected[index]);
        if (s is ISet<int>) expect(s[index], expected[index]);
      }
      expect(s.contains(expected[length ~/ 2]), isTrue);
      expect(s.reduce((a, b) => a + b), expected.reduce((a, b) => a + b));
      if (s is S<int>) {
        expect(expected, contains(s.anyItem));
        expect(s.lookup(expected[length ~/ 2]), expected[length ~/ 2]);
        expect(s.containsAll([expected.first, expected.last]), isTrue);
      }
      if (s is ISet<int>) {
        expect(expected, contains(s.anyItem));
        expect(s.lookup(expected[length ~/ 2]), expected[length ~/ 2]);
        expect(s.containsAll([expected.first, expected.last]), isTrue);
      }
    }
    expect(s.contains(-999999), isFalse);
    if (s is S<int>) {
      expect(s.lookup(-999999), isNull);
      expect(s.containsAll([-999999]), isFalse);
    }

    expect(s.join(","), expected.join(","));
    expect(s.where((x) => x.isEven).toList(), expected.where((x) => x.isEven).toList());
    expect(s.map((x) => x * 2).toList(), expected.map((x) => x * 2).toList());
    expect(s.every((x) => x > -999999), isTrue);
    expect(s.fold<int>(0, (a, b) => a + b), expected.fold<int>(0, (a, b) => a + b));
    expect(s.skip(length ~/ 2).toList(), expected.skip(length ~/ 2).toList());
    expectSameSet(s.toSet(), expectedSet);

    final Set<int> other = {-999999, if (length > 0) expected.first, if (length > 0) expected.last};
    if (s is S<int>) {
      expectSameSet(s.difference(other), expectedSet.difference(other));
      expectSameSet(s.intersection(other), expectedSet.intersection(other));
      expectSameSet(s.union(other), expectedSet.union(other));
      expect(s.unlock.toList(), expected);
      expect(s.getFlushed(ISet.defaultConfig).toList(), expected);
    }
    if (s is ISet<int>) {
      expectSameSet(s.difference(other), expectedSet.difference(other));
      expectSameSet(s.intersection(other), expectedSet.intersection(other));
      expect(s.unlock.toList(), expected);
      expect(s.flush.toList(), expected);
    }
  }

  test("Random shallow chains", () {
    final Random random = Random(42);
    for (int round = 0; round < 100; round++) {
      int next = 0;
      final List<int> expected = [for (int i = 0; i < random.nextInt(4); i++) next++];
      S<int> s = SFlat<int>(expected);
      for (int i = 0; i < random.nextInt(20); i++) {
        switch (random.nextInt(3)) {
          case 0:
            s = SAdd(s, next);
            expected.add(next++);
          case 1:
            final List<int> items = [for (int j = 0; j < random.nextInt(3); j++) next++];
            s = SAddAll(s, items.toSet());
            expected.addAll(items);
          default:
            S<int> other = SFlat<int>({next});
            final List<int> otherExpected = [next++];
            for (int j = 0; j < random.nextInt(4); j++) {
              other = SAdd(other, next);
              otherExpected.add(next++);
            }
            s = SAddAll(s, other);
            expected.addAll(otherExpected);
        }
      }
      checkAll(s, expected);
    }
  });

  test("A very deep chain", () {
    const int depth = 100000;
    S<int> s = SFlat<int>({-1});
    final List<int> expected = [-1];
    for (int i = 0; i < depth; i++) {
      s = (i % 3 == 0) ? SAddAll(s, {i}) : SAdd(s, i);
      expected.add(i);
    }
    checkAll(s, expected);
  });

  test("A very deep chain of empty addAlls", () {
    const int depth = 100000;
    S<int> s = SFlat<int>({});
    for (int i = 0; i < depth; i++) s = SAddAll(s, <int>{});
    checkAll(s, []);
    checkAll(SAdd(s, 5), [5]);
    checkAll(SAddAll(SAdd(s, 5), <int>{}), [5]);
  });

  test("ISet with a very deep chain", () {
    // Note: Each ISet.add checks if the item exists, which walks the chain, so we
    // use a smaller depth to keep the test fast.
    const int depth = 20000;
    ISet<int> iset = ISet<int>({-1});
    final List<int> expected = [-1];
    for (int i = 0; i < depth; i++) {
      iset = (i % 3 == 0) ? iset.addAll([i]) : iset.add(i);
      expected.add(i);
    }
    expect(iset.isFlushed, isFalse);
    checkAll(iset, expected);
  });
}
