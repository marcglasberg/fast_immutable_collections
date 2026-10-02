// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals
import "package:fast_immutable_collections/src/iset/iset.dart";
import "package:fast_immutable_collections/src/iset/s_add.dart";
import "package:fast_immutable_collections/src/iset/s_add_all.dart";
import "package:fast_immutable_collections/src/iset/s_flat.dart";
import "package:test/test.dart";

/// A chain of nodes may contain a node of a more specific type than the nodes
/// above it, for example an `SFlat<int>` below an `SAdd<int?>`, since an
/// `S<int>` is also an `S<int?>`. These tests make sure such chains work.
void main() {
  //
  void expectItems(S<int?> s, List<int?> expected) {
    expect(s.toList(), expected);
    expect(s.where((_) => true).toList(), expected);
    expect(s.map((item) => item).toList(), expected);
    expect(s.followedBy([100]).toList(), [...expected, 100]);
    expect(s.skip(1).toList(), expected.skip(1).toList());
    expect(s.take(1).toList(), expected.take(1).toList());
    expect(s.join(","), expected.join(","));
    expect(s.toSet(), expected.toSet());
    expect(s.any((item) => item == null), expected.contains(null));
    expect(s.every((item) => item != 100), isTrue);
    expect(s.fold<int>(0, (count, _) => count + 1), expected.length);
    expect(s.unlock.toList(), expected);
    expect(s.getFlushed(ISet.defaultConfig).toList(), expected);
  }

  test("SAdd", () {
    expectItems(SAdd<int?>(SFlat<int>({1, 2}), null), [1, 2, null]);
    expectItems(SAdd<int?>(SAdd<int>(SFlat<int>({1}), 2), null), [1, 2, null]);
  });

  test("SAddAll", () {
    expectItems(SAddAll<int?>(SFlat<int>({1}), <int?>{null, 2}), [1, null, 2]);
    expectItems(SAddAll<int?>(SAdd<int>(SFlat<int>({1}), 2), <int?>{null}), [1, 2, null]);
  });

  void expectSetOperations(S<int?> s, Set<int?> items) {
    final Set<int?> other = {2, null, 100};
    expect(s.difference(other), items.difference(other));
    expect(s.intersection(other), items.intersection(other));
    expect(s.union(other), items.union(other));
  }

  test("difference | intersection | union", () {
    expectSetOperations(SAdd<int?>(SFlat<int>({1, 2}), null), {1, 2, null});
    expectSetOperations(SAdd<int?>(SFlat<int>({1, 2}), 3), {1, 2, 3});
    expectSetOperations(SAddAll<int?>(SFlat<int>({1, 2}), <int?>{null, 3}), {1, 2, null, 3});
    expectSetOperations(SAddAll<int?>(SFlat<int>({1}), <int?>{3}), {1, 3});

    S<int?> s = SAdd<int?>(SAddAll<int>(SFlat<int>({1}), {2, 3}), null);
    s = SAddAll<int?>(s, <int?>{4, 5});
    s = SAdd<int?>(s, 6);
    expectSetOperations(s, {1, 2, 3, null, 4, 5, 6});
  });

  test("Mixed chain", () {
    S<int?> s = SAdd<int?>(SAddAll<int>(SFlat<int>({1}), {2, 3}), null);
    s = SAddAll<int?>(s, <int?>{4, 5});
    s = SAdd<int?>(s, 6);
    expectItems(s, [1, 2, 3, null, 4, 5, 6]);
  });
}
