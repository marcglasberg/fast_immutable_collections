// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals
import "package:fast_immutable_collections/src/ilist/ilist.dart";
import "package:fast_immutable_collections/src/ilist/l_add.dart";
import "package:fast_immutable_collections/src/ilist/l_add_all.dart";
import "package:fast_immutable_collections/src/ilist/l_flat.dart";
import "package:test/test.dart";

/// A chain of nodes may contain a node of a more specific type than the nodes
/// above it, for example an `LFlat<int>` below an `LAdd<int?>`, since an
/// `L<int>` is also an `L<int?>`. These tests make sure such chains work.
void main() {
  //
  void expectItems(L<int?> l, List<int?> expected) {
    expect(l.toList(), expected);
    expect(l.where((_) => true).toList(), expected);
    expect(l.map((item) => item).toList(), expected);
    expect(l.followedBy([100]).toList(), [...expected, 100]);
    expect(l.skip(1).toList(), expected.skip(1).toList());
    expect(l.take(1).toList(), expected.take(1).toList());
    expect(l.join(","), expected.join(","));
    expect(l.toSet(), expected.toSet());
    expect(l.any((item) => item == null), expected.contains(null));
    expect(l.every((item) => item != 100), isTrue);
    expect(l.fold<int>(0, (count, _) => count + 1), expected.length);
    expect(l.unlock, expected);
  }

  test("LAdd", () {
    expectItems(LAdd<int?>(LFlat<int>([1, 2]), null), [1, 2, null]);
    expectItems(LAdd<int?>(LAdd<int>(LFlat<int>([1]), 2), null), [1, 2, null]);
  });

  test("LAddAll", () {
    expectItems(LAddAll<int?>(LFlat<int>([1]), <int?>[null, 2]), [1, null, 2]);
    expectItems(LAddAll<int?>(LAdd<int>(LFlat<int>([1]), 2), <int?>[null]), [1, 2, null]);
  });

  test("Mixed chain", () {
    L<int?> l = LAdd<int?>(LAddAll<int>(LFlat<int>([1]), [2, 3]), null);
    l = LAddAll<int?>(l, <int?>[4, null]);
    l = LAdd<int?>(l, 5);
    expectItems(l, [1, 2, 3, null, 4, null, 5]);
  });
}
