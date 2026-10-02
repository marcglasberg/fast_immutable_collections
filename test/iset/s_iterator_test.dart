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

/// Tests for the iterator of chains of [SAdd] and [SAddAll] nodes, which goes
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
      S<int> s = SFlat<int>({-2, -1});
      final List<int> expected = [-2, -1];
      for (int i = 0; i < adds; i++) {
        s = SAdd(s, i);
        expected.add(i);
      }
      expect(iterate(s), expected, reason: "adds: $adds");
    }
  });

  test("Random chains, including empty addAlls and addAlls of other chains", () {
    final Random random = Random(42);
    int next = 0;
    for (int round = 0; round < 50; round++) {
      final List<int> expected = [for (int i = 0; i < random.nextInt(5); i++) next++];
      S<int> s = SFlat<int>(expected);
      final int nodes = random.nextInt(60);
      for (int i = 0; i < nodes; i++) {
        switch (random.nextInt(3)) {
          case 0:
            s = SAdd(s, next);
            expected.add(next++);
          case 1:
            final List<int> items = [for (int j = 0; j < random.nextInt(4); j++) next++];
            s = SAddAll(s, items.toSet());
            expected.addAll(items);
          default:
            // An addAll of another (unflushed) chain.
            S<int> other = SFlat<int>({next});
            final List<int> otherExpected = [next++];
            for (int j = 0; j < random.nextInt(12); j++) {
              other = SAdd(other, next);
              otherExpected.add(next++);
            }
            s = SAddAll(s, other);
            expected.addAll(otherExpected);
        }
      }
      expect(iterate(s), expected, reason: "round: $round");
    }
  });

  test("Nodes with a more specific type than the chain", () {
    S<int?> s = SAddAll<int>(SFlat<int>({1}), {2, 3});
    final List<int?> expected = [1, 2, 3];
    s = SAdd<int?>(s, null);
    expected.add(null);
    for (int i = 4; i < 24; i++) {
      s = (i.isEven) ? SAdd<int?>(s, i) : SAddAll<int?>(s, <int?>{i});
      expected.add(i);
    }
    expect(iterate(s), expected);
  });

  test("Iterator protocol", () {
    S<int> s = SFlat<int>({1});
    for (int i = 2; i <= 20; i++) s = SAdd(s, i);

    final Iterator<int> iterator = s.iterator;
    expect(() => iterator.current, throwsStateError);
    for (int i = 1; i <= 20; i++) {
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, i);
    }
    expect(iterator.moveNext(), isFalse);
    expect(() => iterator.current, throwsStateError);
    expect(iterator.moveNext(), isFalse);

    final Iterator<int> empty = SAddAll(SAddAll(SFlat<int>({}), <int>{}), <int>{}).iterator;
    expect(empty.moveNext(), isFalse);
    expect(() => empty.current, throwsStateError);
  });

  test("Two iterators of chains that share nodes, used at the same time", () {
    S<int> shared = SFlat<int>({0});
    for (int i = 1; i < 30; i++) shared = SAdd(shared, i);
    final S<int> b = SAdd(SAdd(shared, 100), 101);
    final S<int> c = SAddAll(shared, {200, 201, 202});

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
    S<int> s = SFlat<int>({-1});
    for (int i = 0; i < depth; i++) s = (i % 3 == 0) ? SAddAll(s, {i}) : SAdd(s, i);

    int count = 0, sum = 0, previous = -2;
    bool ordered = true;
    for (final int item in s) {
      count++;
      sum += item;
      if (item <= previous) ordered = false;
      previous = item;
    }
    expect(count, depth + 1);
    expect(sum, -1 + depth * (depth - 1) ~/ 2);
    expect(ordered, isTrue);
  });
}
