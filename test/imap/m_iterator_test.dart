// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/imap/imap.dart";
import "package:fast_immutable_collections/src/imap/m_add.dart";
import "package:fast_immutable_collections/src/imap/m_add_all.dart";
import "package:fast_immutable_collections/src/imap/m_flat.dart";
import "package:fast_immutable_collections/src/imap/m_replace.dart";
import "package:test/test.dart";

/// Tests for the iterator of chains of [MAdd] and [MAddAll] nodes, which goes
/// through the nodes from the bottom up, without nesting one iterator per node.
/// Chains with [MReplace] nodes must keep working too.
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  /// Uses only the iterator.
  List<List<Object?>> iterate<K, V>(M<K, V> m) {
    final List<List<Object?>> result = [];
    final Iterator<MapEntry<K, V>> iterator = m.iterator;
    while (iterator.moveNext()) result.add([iterator.current.key, iterator.current.value]);
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
      M<int, int> m = MFlat<int, int>({-2: 2, -1: 1});
      final List<List<Object?>> expected = [
        [-2, 2],
        [-1, 1],
      ];
      for (int i = 0; i < adds; i++) {
        m = MAdd(m, i, i * 10);
        expected.add([i, i * 10]);
      }
      expect(iterate(m), expected, reason: "adds: $adds");
    }
  });

  test("Random chains, including addAlls of other chains, and updates", () {
    final Random random = Random(42);
    int next = 0;
    for (int round = 0; round < 50; round++) {
      // The expected entries, in order (a LinkedHashMap keeps the order of the
      // keys when their values are updated).
      final Map<int, int> expected = {for (int i = 0; i < random.nextInt(5); i++) next++: i};
      M<int, int> m = MFlat<int, int>(Map.of(expected));
      final bool withUpdates = round.isOdd;
      final int nodes = random.nextInt(60);
      for (int i = 0; i < nodes; i++) {
        switch (random.nextInt(withUpdates ? 3 : 2)) {
          case 0:
            m = MAdd(m, next, i);
            expected[next++] = i;
          case 1:
            // An addAll of another (unflushed) chain.
            M<int, int> other = MFlat<int, int>({next: -i});
            final Map<int, int> otherExpected = {next++: -i};
            for (int j = 0; j < random.nextInt(12); j++) {
              other = MAdd(other, next, j);
              otherExpected[next++] = j;
            }
            m = MAddAll.unsafe(m, other);
            expected.addAll(otherExpected);
          default:
            if (expected.isNotEmpty) {
              final int key = expected.keys.elementAt(random.nextInt(expected.length));
              m = MReplace(m, key, 1000 + i);
              expected[key] = 1000 + i;
            }
        }
      }
      expect(
          iterate(m),
          [
            for (final e in expected.entries) [e.key, e.value]
          ],
          reason: "round: $round");
    }
  });

  test("Nodes with a more specific type than the chain", () {
    M<String, int?> m = MAdd<String, int>(MFlat<String, int>({"a": 1}), "b", 2);
    final List<List<Object?>> expected = [
      ["a", 1],
      ["b", 2],
    ];
    for (int i = 0; i < 20; i++) {
      m = MAdd<String, int?>(m, "k$i", i.isEven ? null : i);
      expected.add(["k$i", i.isEven ? null : i]);
    }
    expect(iterate(m), expected);
  });

  test("Iterator protocol", () {
    M<int, int> m = MFlat<int, int>({1: 1});
    for (int i = 2; i <= 20; i++) m = MAdd(m, i, i);

    final Iterator<MapEntry<int, int>> iterator = m.iterator;
    expect(() => iterator.current, throwsStateError);
    for (int i = 1; i <= 20; i++) {
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current.key, i);
    }
    expect(iterator.moveNext(), isFalse);
    expect(() => iterator.current, throwsStateError);
    expect(iterator.moveNext(), isFalse);
  });

  test("Two iterators of chains that share nodes, used at the same time", () {
    M<int, int> shared = MFlat<int, int>({0: 0});
    for (int i = 1; i < 30; i++) shared = MAdd(shared, i, i);
    final M<int, int> b = MAdd(MAdd(shared, 100, 100), 101, 101);
    final M<int, int> c = MAdd(shared, 200, 200);

    final Iterator<MapEntry<int, int>> iteratorB = b.iterator, iteratorC = c.iterator;
    final List<int> resultB = [], resultC = [];
    bool hasB = true, hasC = true;
    while (hasB || hasC) {
      if (hasB && (hasB = iteratorB.moveNext())) resultB.add(iteratorB.current.key);
      if (hasC && (hasC = iteratorC.moveNext())) resultC.add(iteratorC.current.key);
    }
    expect(resultB, [for (int i = 0; i < 30; i++) i, 100, 101]);
    expect(resultC, [for (int i = 0; i < 30; i++) i, 200]);
  });

  test("A very deep chain doesn't overflow the stack", () {
    const int depth = 100000;
    M<int, int> m = MFlat<int, int>({-1: -1});
    for (int i = 0; i < depth; i++) m = MAdd(m, i, i);

    int count = 0, sum = 0;
    final Iterator<MapEntry<int, int>> iterator = m.iterator;
    while (iterator.moveNext()) {
      count++;
      sum += iterator.current.value;
    }
    expect(count, depth + 1);
    expect(sum, -1 + depth * (depth - 1) ~/ 2);
  });

  test("IMap with a very deep chain doesn't overflow the stack", () {
    // Note: Each IMap.add checks if the key exists, which walks the chain, so we
    // use a smaller depth to keep the test fast.
    const int depth = 20000;
    IMap<int, int> imap = IMap<int, int>({-1: -1});
    for (int i = 0; i < depth; i++) imap = imap.add(i, i);
    expect(imap.isFlushed, isFalse);

    int count = 0, sum = 0;
    final Iterator<MapEntry<int, int>> iterator = imap.iterator;
    while (iterator.moveNext()) {
      count++;
      sum += iterator.current.value;
    }
    expect(count, depth + 1);
    expect(sum, -1 + depth * (depth - 1) ~/ 2);
  });
}
