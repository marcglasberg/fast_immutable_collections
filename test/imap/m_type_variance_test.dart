// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/imap/imap.dart";
import "package:fast_immutable_collections/src/imap/m_add.dart";
import "package:fast_immutable_collections/src/imap/m_add_all.dart";
import "package:fast_immutable_collections/src/imap/m_flat.dart";
import "package:fast_immutable_collections/src/imap/m_replace.dart";
import "package:test/test.dart";

/// A chain of nodes may contain a node of a more specific type than the nodes
/// above it, for example an `MFlat<String, int>` below an `MAdd<String, int?>`,
/// since an `M<String, int>` is also an `M<String, int?>`. These tests make sure
/// such chains work.
void main() {
  //
  void expectEntries(M<String, int?> m, List<List<Object?>> expected) {
    expect([
      for (final e in m.entries) [e.key, e.value]
    ], expected);
    expect(m.keys.toList(), [for (final e in expected) e[0]]);
    expect(m.values.toList(), [for (final e in expected) e[1]]);
    expect(m.entries.where((_) => true).length, expected.length);
    expect([
      for (final e in m.unlock.entries) [e.key, e.value]
    ], expected);
    expect([
      for (final e in m.getFlushed(IMap.defaultConfig).entries) [e.key, e.value]
    ], expected);
  }

  test("MAdd", () {
    expectEntries(MAdd<String, int?>(MFlat<String, int>({"a": 1}), "b", null), [
      ["a", 1],
      ["b", null],
    ]);
  });

  test("MAddAll", () {
    expectEntries(
        MAddAll<String, int?>.unsafe(
            MFlat<String, int>({"a": 1}), MFlat<String, int?>({"b": null})),
        [
          ["a", 1],
          ["b", null],
        ]);
  });

  test("Mixed chain", () {
    M<String, int?> m =
        MAdd<String, int?>(MAdd<String, int>(MFlat<String, int>({"a": 1}), "b", 2), "c", null);
    m = MReplace<String, int?>(m, "a", null);
    m = MAdd<String, int?>(m, "d", 4);
    expectEntries(m, [
      ["a", null],
      ["b", 2],
      ["c", null],
      ["d", 4],
    ]);
  });
}
