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

/// Tests for unlocking (and flushing) chains of [MAdd], [MAddAll] and
/// [MReplace] nodes, which walk down the chain only once, instead of
/// iterating it. The expected results are always in the iteration order.
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  List<List<Object?>> entriesOf<K, V>(Map<K, V> map) => [
        for (final entry in map.entries) [entry.key, entry.value]
      ];

  /// The entries in the iteration order, the old way (iterating the chain).
  List<List<Object?>> iterate<K, V>(M<K, V> m) => entriesOf(<K, V>{}..addEntries(m.entries));

  /// Adds 3 nodes that don't change the map. Chains with at most 2 nodes are
  /// iterated, so this makes sure the chain is walked and filled instead.
  M<K, V> deepen<K, V>(M<K, V> m) {
    for (int i = 0; i < 3; i++) m = MAddAll.unsafe(m, MFlat<K, V>.unsafe(<K, V>{}));
    return m;
  }

  void expectSameAsIteration<K, V>(M<K, V> m, List<List<Object?>> expected) {
    for (final M<K, V> chain in [m, deepen(m)]) {
      expect(iterate(chain), expected);
      expect(entriesOf(chain.unlock), expected);
      expect(entriesOf(chain.getFlushed(IMap.defaultConfig)), expected);
    }
  }

  test("Chain of adds", () {
    M<String, int> m = MAdd(MAdd(MFlat<String, int>({"a": 1, "b": 2}), "c", 3), "d", 4);
    expectSameAsIteration(m, [
      ["a", 1],
      ["b", 2],
      ["c", 3],
      ["d", 4],
    ]);
  });

  test("Replacements keep the position, and the topmost one wins", () {
    M<String, int> m = MFlat<String, int>({"a": 1, "b": 2});
    m = MAdd(m, "c", 3);
    m = MReplace(m, "a", 10);
    m = MAdd(m, "d", 4);
    m = MReplace(m, "c", 30);
    m = MReplace(m, "a", 20);
    expectSameAsIteration(m, [
      ["a", 20],
      ["b", 2],
      ["c", 30],
      ["d", 4],
    ]);
  });

  test("AddAll of another chain, with replacements inside and above it", () {
    M<String, int> items = MAdd(MFlat<String, int>({"x": 1}), "y", 2);
    items = MReplace(items, "x", 5);

    M<String, int> m = MAddAll.unsafe(MFlat<String, int>({"a": 1, "b": 2}), items);
    m = MAdd(m, "z", 9);
    m = MReplace(m, "y", 7);
    m = MReplace(m, "a", 100);
    expectSameAsIteration(m, [
      ["a", 100],
      ["b", 2],
      ["x", 5],
      ["y", 7],
      ["z", 9],
    ]);
  });

  test("Empty maps", () {
    expectSameAsIteration(MAddAll.unsafe(MFlat<String, int>({}), MFlat<String, int>({})), []);
    expectSameAsIteration(
        MAdd(MAddAll.unsafe(MFlat<String, int>({}), MFlat<String, int>({})), "a", 1), [
      ["a", 1],
    ]);
  });

  test("Nodes with a more specific type than the chain", () {
    void expectEntries(M<String, int?> m, List<List<Object?>> expected) =>
        expectSameAsIteration(m, expected);

    expectEntries(MAdd<String, int?>(MFlat<String, int>({"a": 1}), "b", null), [
      ["a", 1],
      ["b", null],
    ]);

    expectEntries(
        MReplace<String, int?>(MAdd<String, int>(MFlat<String, int>({"a": 1}), "b", 2), "a", null),
        [
          ["a", null],
          ["b", 2],
        ]);
  });

  test("A malformed chain (repeated keys) gives the same result as iterating it", () {
    final M<String, int> m = deepen(MAdd(
        MAddAll.unsafe(MFlat<String, int>({"a": 1, "b": 2}), MFlat<String, int>({"a": 3})),
        "c",
        4));
    expect(entriesOf(m.unlock), iterate(m));
    expect(entriesOf(m.getFlushed(IMap.defaultConfig)), iterate(m));
  });

  test("A node below that was flushed sorted doesn't change the iteration order", () {
    final M<String, int> middle = MAdd(MFlat<String, int>({"c": 3, "a": 1}), "b", 2);
    expect(middle.getFlushed(ConfigMap(sort: true)).keys.toList(), ["a", "b", "c"]);

    final M<String, int> top = MAdd(middle, "0", 0);
    expectSameAsIteration(top, [
      ["c", 3],
      ["a", 1],
      ["b", 2],
      ["0", 0],
    ]);
  });

  test("Sorted flush", () {
    M<String, int> m = MAdd(MAdd(MFlat<String, int>({"c": 3, "a": 1}), "d", 4), "b", 2);
    m = deepen(MReplace(m, "a", 10));
    expect(entriesOf(m.getFlushed(ConfigMap(sort: true))), [
      ["a", 10],
      ["b", 2],
      ["c", 3],
      ["d", 4],
    ]);
    expect(m.unlock.keys.toList(), ["c", "a", "d", "b"]);
  });

  test("The unlocked map is independent from the chain", () {
    final M<String, int> m = deepen(MReplace(MAdd(MFlat<String, int>({"a": 1}), "b", 2), "a", 10));
    final Map<String, int> map = m.unlock;
    map["c"] = 3;
    map.remove("a");
    expect(map, {"b": 2, "c": 3});
    expect(entriesOf(m.unlock), [
      ["a", 10],
      ["b", 2],
    ]);
  });

  test("IMap with a deep chain of random adds, updates and addAlls", () {
    final Random random = Random(42);
    IMap<int, int> imap = IMap<int, int>({for (int i = 0; i < 100; i++) i: i});
    for (int i = 0; i < 2000; i++) {
      final int op = random.nextInt(4);
      if (op == 0) {
        IMap<int, int> other = IMap<int, int>({random.nextInt(5000): i});
        other = other.add(random.nextInt(5000), -i);
        imap = imap.addAll(other);
      } else
        imap = imap.add(random.nextInt(5000), i);
    }
    expect(imap.isFlushed, isFalse);
    final List<List<Object?>> expected = [
      for (final e in imap.entries) [e.key, e.value]
    ];
    expect(entriesOf(imap.unlock), expected);
    expect(imap.flush.isFlushed, isTrue);
    expect([
      for (final e in imap.entries) [e.key, e.value]
    ], expected);
  });

  test("IMapOfSets flush", () {
    final Random random = Random(42);
    IMapOfSets<int, int> mapOfSets = IMapOfSets<int, int>();
    final Map<int, Set<int>> expected = {};
    for (int i = 0; i < 3000; i++) {
      final int key = random.nextInt(20), value = random.nextInt(1000);
      mapOfSets = mapOfSets.add(key, value);
      expected.putIfAbsent(key, () => {}).add(value);
    }
    expect(mapOfSets.isFlushed, isFalse);
    expect(mapOfSets.flush.isFlushed, isTrue);
    expect(mapOfSets.keys.toSet(), expected.keys.toSet());
    for (final key in expected.keys) expect(mapOfSets[key]!.unlock, expected[key]);
  });
}
