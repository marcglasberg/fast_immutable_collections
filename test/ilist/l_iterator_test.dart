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

/// Tests for the iterator of chains of [LAdd] and [LAddAll] nodes, which goes
/// through the nodes from the bottom up, without nesting one iterator per node.
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  /// Uses only the iterator (a for-in loop).
  List<T> iterate<T>(Iterable<T> iterable) {
    final List<T> result = [];
    for (final T item in iterable) result.add(item);
    return result;
  }

  test("Chains of adds of many lengths", () {
    // Lengths around the sizes where the iterator splits the chain.
    for (final int adds in [
      for (int i = 0; i <= 40; i++) i,
      63,
      64,
      65,
      100,
      127,
      128,
      129,
      257,
      1000,
    ]) {
      L<int> l = LFlat<int>([-2, -1]);
      final List<int> expected = [-2, -1];
      for (int i = 0; i < adds; i++) {
        l = LAdd(l, i);
        expected.add(i);
      }
      expect(iterate(l), expected, reason: "adds: $adds");
    }
  });

  test("Chains of addAlls, including empty ones", () {
    for (final int addAlls in [1, 7, 8, 9, 17, 50]) {
      L<int> l = LFlat<int>([]);
      final List<int> expected = [];
      for (int i = 0; i < addAlls; i++) {
        final List<int> items = [for (int j = 0; j < i % 4; j++) i * 10 + j];
        l = LAddAll(l, items);
        expected.addAll(items);
      }
      expect(iterate(l), expected, reason: "addAlls: $addAlls");
    }
  });

  test("Random chains, including addAlls of other chains", () {
    final Random random = Random(42);
    for (int round = 0; round < 50; round++) {
      final List<int> expected = [for (int i = 0; i < random.nextInt(5); i++) i];
      L<int> l = LFlat<int>(expected);
      final int nodes = random.nextInt(60);
      for (int i = 0; i < nodes; i++) {
        switch (random.nextInt(3)) {
          case 0:
            l = LAdd(l, i);
            expected.add(i);
          case 1:
            final List<int> items = [for (int j = 0; j < random.nextInt(4); j++) j];
            l = LAddAll(l, items);
            expected.addAll(items);
          default:
            // An addAll of another (unflushed) chain.
            L<int> other = LFlat<int>([1000 + i]);
            final List<int> otherExpected = [1000 + i];
            for (int j = 0; j < random.nextInt(12); j++) {
              other = LAdd(other, 2000 + j);
              otherExpected.add(2000 + j);
            }
            l = LAddAll(l, other);
            expected.addAll(otherExpected);
        }
      }
      expect(iterate(l), expected, reason: "round: $round");
    }
  });

  test("Nodes with a more specific type than the chain", () {
    L<int?> l = LAddAll<int>(LFlat<int>([1]), [2, 3]);
    final List<int?> expected = [1, 2, 3];
    for (int i = 0; i < 20; i++) {
      l = (i.isEven) ? LAdd<int?>(l, null) : LAddAll<int?>(l, <int?>[i, null]);
      expected.addAll((i.isEven) ? [null] : [i, null]);
    }
    expect(iterate(l), expected);
  });

  test("Iterator protocol", () {
    L<int> l = LFlat<int>([1]);
    for (int i = 2; i <= 20; i++) l = LAdd(l, i);

    final Iterator<int> iterator = l.iterator;

    // Throws StateError before the first moveNext().
    expect(() => iterator.current, throwsStateError);

    for (int i = 1; i <= 20; i++) {
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, i);
    }
    expect(iterator.moveNext(), isFalse);

    // Throws StateError after the last moveNext(), which keeps returning false.
    expect(() => iterator.current, throwsStateError);
    expect(iterator.moveNext(), isFalse);

    // An empty chain.
    final Iterator<int> empty = LAddAll(LAddAll(LFlat<int>([]), <int>[]), <int>[]).iterator;
    expect(empty.moveNext(), isFalse);
    expect(() => empty.current, throwsStateError);
  });

  test("Two iterators of chains that share nodes, used at the same time", () {
    L<int> shared = LFlat<int>([0]);
    for (int i = 1; i < 30; i++) shared = LAdd(shared, i);
    final L<int> b = LAdd(LAdd(shared, 100), 101);
    final L<int> c = LAddAll(shared, [200, 201, 202]);

    final Iterator<int> iteratorB = b.iterator, iteratorC = c.iterator;
    final List<int> resultB = [], resultC = [];
    bool hasB = true, hasC = true;
    while (hasB || hasC) {
      if (hasB && (hasB = iteratorB.moveNext())) resultB.add(iteratorB.current);
      if (hasC && (hasC = iteratorC.moveNext())) resultC.add(iteratorC.current);
    }
    expect(resultB, [for (int i = 0; i < 30; i++) i, 100, 101]);
    expect(resultC, [for (int i = 0; i < 30; i++) i, 200, 201, 202]);
  });

  test("A very deep chain doesn't overflow the stack", () {
    const int depth = 100000;
    L<int> l = LFlat<int>([-1]);
    for (int i = 0; i < depth; i++) l = (i % 3 == 0) ? LAddAll(l, [i]) : LAdd(l, i);

    int count = 0, sum = 0, previous = -2;
    bool ordered = true;
    for (final int item in l) {
      count++;
      sum += item;
      if (item <= previous) ordered = false;
      previous = item;
    }
    expect(count, depth + 1);
    expect(sum, -1 + depth * (depth - 1) ~/ 2);
    expect(ordered, isTrue);
  });

  test("IList with a very deep chain doesn't overflow the stack", () {
    const int depth = 100000;
    IList<int> ilist = IList<int>([-1]);
    for (int i = 0; i < depth; i++) ilist = ilist.add(i);
    expect(ilist.isFlushed, isFalse);

    int count = 0, sum = 0;
    for (final int item in ilist) {
      count++;
      sum += item;
    }
    expect(count, depth + 1);
    expect(sum, -1 + depth * (depth - 1) ~/ 2);
  });
}
