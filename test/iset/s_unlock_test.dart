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

/// Tests for unlocking (and flushing) chains of [SAdd] and [SAddAll] nodes,
/// which fill a list from the end instead of iterating the chain.
/// The expected results are always in the iteration order.
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  /// Adds 3 nodes that don't change the set. Chains with at most 2 nodes are
  /// iterated, so this makes sure the chain is walked and filled instead.
  S<T> deepen<T>(S<T> s) {
    for (int i = 0; i < 3; i++) s = SAddAll(s, <T>{});
    return s;
  }

  void expectSameAsIteration<T>(S<T> s, List<T> expected) {
    for (final S<T> chain in [s, deepen(s)]) {
      expect(chain.toList(), expected); // Iteration (the old way).
      expect(chain.unlock.toList(), expected);
      expect(chain.getFlushed(ISet.defaultConfig).toList(), expected);
    }
  }

  test("Chain of adds", () {
    S<int> s = SAdd(SAdd(SFlat<int>({1, 2, 3}), 4), 5);
    expectSameAsIteration(s, [1, 2, 3, 4, 5]);
  });

  test("Chain of addAlls", () {
    S<int> s = SAddAll(SAddAll(SFlat<int>({1, 2}), {3, 4, 5}), {6});
    expectSameAsIteration(s, [1, 2, 3, 4, 5, 6]);
  });

  test("Mixed chain, including an addAll of another chain (an S)", () {
    final S<int> other = SAdd(SAddAll(SFlat<int>({10}), {20, 30}), 40);
    S<int> s = SAdd(SFlat<int>({1, 2}), 3);
    s = SAddAll(s, other);
    s = SAdd(s, 4);
    expectSameAsIteration(s, [1, 2, 3, 10, 20, 30, 40, 4]);
  });

  test("Empty base and empty items", () {
    expectSameAsIteration(SAddAll(SFlat<int>({}), <int>{}), <int>[]);
    expectSameAsIteration(SAddAll(SFlat<int>({}), {1, 2}), [1, 2]);
    expectSameAsIteration(SAdd(SAddAll(SFlat<int>({}), <int>{}), 1), [1]);
  });

  test("Nodes with a more specific type than the chain", () {
    expectSameAsIteration(SAdd<int?>(SFlat<int>({1, 2}), null), [1, 2, null]);
    expectSameAsIteration(SAddAll<int?>(SAdd<int>(SFlat<int>({1}), 2), {null, 3}), [1, 2, null, 3]);
  });

  test("The items of a malformed chain (repeated items) are not repeated", () {
    final S<int> s = deepen(SAddAll(SFlat<int>({1, 2}), {2, 3}));
    expect(s.unlock.toList(), [1, 2, 3]);
    expect(s.getFlushed(ISet.defaultConfig).toList(), [1, 2, 3]);
  });

  test("A node below that was flushed sorted doesn't change the iteration order", () {
    final S<int> middle = SAdd(SAdd(SFlat<int>({3, 1}), 2), 0);
    expect(middle.getFlushed(ConfigSet(sort: true)).toList(), [0, 1, 2, 3]);

    final S<int> top = SAdd(middle, 5);
    expectSameAsIteration(top, [3, 1, 2, 0, 5]);
  });

  test("Sorted flush", () {
    final S<int> s = deepen(SAddAll(SAdd(SFlat<int>({3, 1}), 2), {0, 5, 4}));
    expect(s.getFlushed(ConfigSet(sort: true)).toList(), [0, 1, 2, 3, 4, 5]);
    expect(s.unlock.toList(), [3, 1, 2, 0, 5, 4]);
  });

  test("The unlocked set is independent from the chain", () {
    final S<int> s = deepen(SAdd(SAddAll(SFlat<int>({1, 2}), {3}), 4));
    final Set<int> set = s.unlock;
    set.add(5);
    set.remove(1);
    expect(set, {2, 3, 4, 5});
    expect(s.unlock.toList(), [1, 2, 3, 4]);
  });

  test("ISet with a deep chain of random adds and addAlls", () {
    final Random random = Random(42);
    ISet<int> iset = ISet<int>([for (int i = 0; i < 100; i++) i]);
    for (int i = 0; i < 2000; i++) {
      if (random.nextInt(3) == 0)
        iset = iset.addAll([random.nextInt(5000), random.nextInt(5000)]);
      else
        iset = iset.add(random.nextInt(5000));
    }
    expect(iset.isFlushed, isFalse);
    final List<int> expected = iset.toList(); // Iteration (the old way).
    expect(iset.unlock.toList(), expected);
    expect(iset.flush.isFlushed, isTrue);
    expect(iset.toList(), expected);
    expect(iset.unlock.toList(), expected);
  });
}
