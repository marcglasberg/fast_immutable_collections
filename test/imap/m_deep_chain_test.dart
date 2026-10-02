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

/// Tests that the methods of chains of [MAdd], [MAddAll] and [MReplace] nodes
/// work for chains of any length, without recursion (which would overflow the
/// stack). The [expected] map is a `LinkedHashMap`, which keeps the position
/// of a key when its value is updated, just like [MReplace].
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  List<List<Object?>> entriesOf(Iterable<MapEntry<int, int>> entries) => [
        for (final e in entries) [e.key, e.value]
      ];

  /// Checks the methods of [m] (an [M] or an [IMap]) against the [expected] map.
  void checkAll(dynamic m, Map<int, int> expected) {
    final List<List<Object?>> expectedEntries = entriesOf(expected.entries);
    final int length = expected.length;
    expect(m.length, length);
    expect(m.isEmpty, expected.isEmpty);
    expect(m.isNotEmpty, expected.isNotEmpty);

    final List<List<Object?>> iterated = [];
    final Iterator<MapEntry<int, int>> iterator = m.iterator as Iterator<MapEntry<int, int>>;
    while (iterator.moveNext()) iterated.add([iterator.current.key, iterator.current.value]);
    expect(iterated, expectedEntries);

    expect(entriesOf(m.entries as Iterable<MapEntry<int, int>>), expectedEntries);
    expect((m.keys as Iterable<int>).toList(), expected.keys.toList());
    expect((m.values as Iterable<int>).toList(), expected.values.toList());
    expect((m.keys as Iterable<int>).length, length);
    expect((m.values as Iterable<int>).length, length);
    expect((m.entries as Iterable<MapEntry<int, int>>).length, length);
    expect((m.values as Iterable<int>).where((v) => v.isEven).length,
        expected.values.where((v) => v.isEven).length);

    for (final int key in expected.keys.toList().sublist(0, min(length, 3))) {
      expect(m[key], expected[key]);
      expect(m.containsKey(key), isTrue);
      expect(m.contains(key, expected[key]), isTrue);
      expect(m.contains(key, -999999), isFalse);
      expect(m.containsValue(expected[key]), isTrue);
    }
    if (length > 0) {
      final int key = expected.keys.last;
      expect(m[key], expected[key]);
      expect(m.containsValue(expected[key]), isTrue);
    }
    expect(m[-999999], isNull);
    expect(m.containsKey(-999999), isFalse);
    expect(m.containsValue(-999999), isFalse);

    expect(entriesOf((m.unlock as Map<int, int>).entries), expectedEntries);
    if (m is M<int, int>)
      expect(entriesOf(m.getFlushed(IMap.defaultConfig).entries), expectedEntries);
    if (m is IMap<int, int>) expect(entriesOf(m.flush.entries), expectedEntries);
  }

  test("Random shallow chains, with updates", () {
    final Random random = Random(42);
    for (int round = 0; round < 100; round++) {
      int next = 0;
      final Map<int, int> expected = {for (int i = 0; i < random.nextInt(4); i++) next++: i};
      M<int, int> m = MFlat<int, int>(Map.of(expected));
      for (int i = 0; i < random.nextInt(20); i++) {
        switch (random.nextInt(3)) {
          case 0:
            m = MAdd(m, next, i);
            expected[next++] = i;
          case 1:
            M<int, int> other = MFlat<int, int>({next: -i});
            final Map<int, int> otherExpected = {next++: -i};
            for (int j = 0; j < random.nextInt(4); j++) {
              other = MAdd(other, next, j);
              otherExpected[next++] = j;
            }
            if (otherExpected.length > 1 && random.nextBool()) {
              final int key = otherExpected.keys.first;
              other = MReplace(other, key, 500 + i);
              otherExpected[key] = 500 + i;
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
      checkAll(m, expected);
    }
  });

  test("A very deep chain, with some updates", () {
    const int depth = 100000;
    M<int, int> m = MFlat<int, int>({-1: -1});
    final Map<int, int> expected = {-1: -1};
    for (int i = 0; i < depth; i++) {
      if (i % 1000 == 999) {
        m = MReplace(m, i - 500, -i);
        expected[i - 500] = -i;
      } else {
        m = MAdd(m, i, i);
        expected[i] = i;
      }
    }
    checkAll(m, expected);
  });

  test("A very deep chain of empty addAlls", () {
    const int depth = 100000;
    M<int, int> m = MFlat<int, int>({});
    for (int i = 0; i < depth; i++) m = MAddAll.unsafe(m, MFlat<int, int>({}));
    checkAll(m, {});
    checkAll(MAdd(m, 5, 50), {5: 50});
  });

  test("IMap with a very deep chain, with some updates", () {
    // Note: Each IMap.add checks if the key exists, which walks the chain, so we
    // use a smaller depth to keep the test fast.
    const int depth = 20000;
    IMap<int, int> imap = IMap<int, int>({-1: -1});
    final Map<int, int> expected = {-1: -1};
    for (int i = 0; i < depth; i++) {
      final int key = (i % 100 == 99) ? i - 50 : i; // Some updates of existing keys.
      imap = imap.add(key, -i);
      expected[key] = -i;
    }
    expect(imap.isFlushed, isFalse);
    checkAll(imap, expected);
  });
}
