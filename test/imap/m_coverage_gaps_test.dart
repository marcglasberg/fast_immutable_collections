// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/imap/imap.dart";
import "package:fast_immutable_collections/src/imap/m_add.dart";
import "package:fast_immutable_collections/src/imap/m_add_all.dart";
import "package:fast_immutable_collections/src/imap/m_replace.dart";
import "package:meta/meta.dart";
import "package:test/test.dart";

/// These tests are for coverage purposes. They test the default implementations of the [M]
/// class which are overridden by all of its implementations, by using a custom subclass
/// ([MLeafExample]) which doesn't override them.
void main() {
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  /// Creates a chain of nodes on top of a custom leaf: {c, a} + d + e + f.
  /// Since it has more than 2 nodes below the top node, it's not "shallow".
  M<String, int> deepChain() {
    final M<String, int> leaf = MLeafExample({"c": 3, "a": 1});
    return MAdd(MAdd(MAdd(leaf, "d", 4), "e", 5), "f", 6);
  }

  test("fillOwnEntriesBefore | default implementation", () {
    final MLeafExample<String, int> m = MLeafExample({"x": 10, "y": 20});
    final Map<Object?, Object?> map = {};
    final List<Object?> keys = List<Object?>.filled(5, "-");
    final Map<Object?, Object?> replacements = {};

    final int start = m.fillOwnEntriesBefore(map, keys, 4, replacements);

    expect(start, 2);
    expect(keys, ["-", "-", "x", "y", "-"]);
    expect(map, {"x": 10, "y": 20});
    expect(replacements, isEmpty);
  });

  test("fillOwnEntriesBefore | empty node", () {
    final MLeafExample<String, int> m = MLeafExample({});
    final Map<Object?, Object?> map = {};
    final List<Object?> keys = List<Object?>.filled(2, "-");

    expect(m.fillOwnEntriesBefore(map, keys, 1, {}), 1);
    expect(keys, ["-", "-"]);
    expect(map, isEmpty);
  });

  test("fillOwnEntriesBefore | adds to existing entries, and overwrites repeated keys", () {
    final MLeafExample<String, int> m = MLeafExample({"a": 1, "b": 2});
    final Map<Object?, Object?> map = {"b": 100, "z": 26};
    final List<Object?> keys = List<Object?>.filled(3, "z");

    expect(m.fillOwnEntriesBefore(map, keys, 3, {}), 1);
    expect(keys, ["z", "a", "b"]);
    expect(map, {"b": 2, "z": 26, "a": 1});
  });

  test("fillBefore | a leaf node uses the default fillOwnEntriesBefore", () {
    final MLeafExample<String, int> m = MLeafExample({"a": 1, "b": 2});
    expect(m.below, isNull);

    final Map<Object?, Object?> map = {};
    final List<Object?> keys = List<Object?>.filled(2, null);

    expect(m.fillBefore(map, keys, 2, {}), 0);
    expect(keys, ["a", "b"]);
    expect(map, {"a": 1, "b": 2});
  });

  test("fillBefore | walks the whole chain, down to the custom leaf", () {
    final M<String, int> m = deepChain();
    expect(m.length, 5);

    final Map<Object?, Object?> map = {};
    final List<Object?> keys = List<Object?>.filled(5, null);

    expect(m.fillBefore(map, keys, 5, {}), 0);
    expect(keys, ["c", "a", "d", "e", "f"]);
    expect(map, {"a": 1, "c": 3, "d": 4, "e": 5, "f": 6});
  });

  test("unlock | deep chain over a custom leaf keeps the insertion order", () {
    final M<String, int> m = deepChain();
    final Map<String, int> unlocked = m.unlock;

    expect(unlocked.keys, ["c", "a", "d", "e", "f"]);
    expect(unlocked.values, [3, 1, 4, 5, 6]);

    // It's a mutable copy.
    unlocked["z"] = 26;
    expect(m.containsKey("z"), isFalse);
    expect(m.length, 5);
  });

  test("getFlushed | deep chain over a custom leaf, sorted and not sorted", () {
    expect(deepChain().getFlushed(ConfigMap(sort: false)).keys, ["c", "a", "d", "e", "f"]);
    expect(deepChain().getFlushed(ConfigMap(sort: true)).keys, ["a", "c", "d", "e", "f"]);
    expect(deepChain().getFlushed(ConfigMap(sort: true)).values, [1, 3, 4, 5, 6]);

    // The flushed map is cached.
    final M<String, int> m = deepChain();
    expect(identical(m.getFlushed(null), m.getFlushed(null)), isTrue);
  });

  test("getFlushed | MAddAll and MReplace over custom leaves", () {
    final M<String, int> leaf1 = MLeafExample({"b": 2, "a": 1});
    final M<String, int> leaf2 = MLeafExample({"y": 25, "x": 24});

    // MAddAll calls fillBefore for its items, which is a custom leaf.
    final M<String, int> addAll = MAdd(MAddAll.unsafe(MAdd(leaf1, "c", 3), leaf2), "z", 26);
    final M<String, int> replaced = MReplace(MAdd(addAll, "w", 23), "a", 100);

    expect(replaced.getFlushed(ConfigMap(sort: false)),
        {"b": 2, "a": 100, "c": 3, "y": 25, "x": 24, "z": 26, "w": 23});
    expect(replaced.getFlushed(ConfigMap(sort: false)).keys,
        ["b", "a", "c", "y", "x", "z", "w"]);
    expect(replaced.unlock.values, [2, 100, 3, 25, 24, 26, 23]);
  });

  test("unlock | shallow chain over a custom leaf", () {
    final M<String, int> m = MAdd(MLeafExample({"b": 2}), "a", 1);
    expect(m.unlock, {"b": 2, "a": 1});
    expect(m.unlock.keys, ["b", "a"]);
  });
}

/// A leaf node (with no node [below] it), which uses the default implementations of the [M] class.
@visibleForTesting
class MLeafExample<K, V> extends M<K, V> {
  final Map<K, V> _map;

  MLeafExample(Map<K, V> map) : _map = Map<K, V>.of(map);

  @override
  Iterable<MapEntry<K, V>> get entries => _map.entries;

  @override
  Iterable<K> get keys => _map.keys;

  @override
  Iterable<V> get values => _map.values;

  @override
  Iterator<MapEntry<K, V>> get iterator => _map.entries.iterator;

  @override
  int get length => _map.length;

  @override
  V? operator [](K key) => _map[key];

  @protected
  @override
  dynamic getVOrM(K key) => _map[key];

  @override
  bool containsKey(K? key) => _map.containsKey(key);

  @protected
  @override
  bool containsKeyOrM(K? key) => _map.containsKey(key);

  @override
  bool containsValue(V? value) => _map.containsValue(value);
}
