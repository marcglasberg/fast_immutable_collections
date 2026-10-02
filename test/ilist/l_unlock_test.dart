// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/ilist/ilist.dart";
import "package:fast_immutable_collections/src/ilist/l_add.dart";
import "package:fast_immutable_collections/src/ilist/l_add_all.dart";
import "package:fast_immutable_collections/src/ilist/l_flat.dart";
import "package:test/test.dart";

/// Tests for unlocking (and flushing) chains of [LAdd] and [LAddAll] nodes,
/// which fill the list from the end instead of iterating the chain.
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  test("Chain of adds, where most items are in the base", () {
    L<int> l = LFlat<int>([1, 2, 3, 4, 5]);
    l = LAdd(LAdd(l, 6), 7);
    expect(l.unlock, [1, 2, 3, 4, 5, 6, 7]);
  });

  test("Chain of adds, where most items are not in the base", () {
    L<int> l = LFlat<int>([1]);
    for (int i = 2; i <= 10; i++) l = LAdd(l, i);
    expect(l.unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  });

  test("Chain of addAlls, both when most items are in the base, and when they are not", () {
    L<int> l = LAddAll(LAddAll(LFlat<int>([1, 2, 3, 4, 5, 6]), [7, 8]), [9]);
    expect(l.unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);

    l = LAddAll(LAddAll(LFlat<int>([1]), [2, 3, 4]), [5, 6, 7]);
    expect(l.unlock, [1, 2, 3, 4, 5, 6, 7]);
  });

  test("Mixed chain of adds and addAlls", () {
    L<int> l = LFlat<int>([1, 2]);
    l = LAdd(l, 3);
    l = LAddAll(l, [4, 5]);
    l = LAdd(l, 6);
    l = LAddAll(l, [7, 8, 9]);
    expect(l.unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  test("Empty base and empty addAlls", () {
    expect(LAddAll(LFlat<int>([]), <int>[]).unlock, <int>[]);
    expect(LAddAll(LFlat<int>([]), [1, 2]).unlock, [1, 2]);
    expect(LAdd(LAddAll(LFlat<int>([]), <int>[]), 1).unlock, [1]);
    expect(LAddAll(LAddAll(LFlat<int>([1]), <int>[]), [2]).unlock, [1, 2]);
  });

  test("An addAll of another chain (an L), which is itself unflushed", () {
    L<int> other = LAddAll(LAdd(LFlat<int>([10, 20]), 30), [40, 50]);
    L<int> l = LAddAll(LAdd(LFlat<int>([1, 2]), 3), other);
    l = LAdd(l, 4);
    expect(l.unlock, [1, 2, 3, 10, 20, 30, 40, 50, 4]);
  });

  test("A chain on top of a node that was already flushed", () {
    final L<int> middle = LAdd(LAdd(LFlat<int>([1, 2]), 3), 4);
    final L<int> top = LAdd(LAdd(middle, 5), 6);

    // Flushing the middle node caches its flushed list, which the top node then copies.
    expect(middle.getFlushed, [1, 2, 3, 4]);
    expect(top.unlock, [1, 2, 3, 4, 5, 6]);

    // Same, but now most items are not in the flushed node.
    L<int> big = middle;
    for (int i = 5; i <= 20; i++) big = LAdd(big, i);
    expect(big.unlock, [for (int i = 1; i <= 20; i++) i]);
  });

  test("Nullable items, including a null last item", () {
    L<int?> l = LAddAll(LAdd(LFlat<int?>([null, 1]), null), [2, null]);
    expect(l.unlock, [null, 1, null, 2, null]);

    l = LAdd(LFlat<int?>([null]), null);
    expect(l.unlock, [null, null]);
  });

  test("The unlocked list is growable, and independent from the chain", () {
    final L<int> l = LAdd(LAddAll(LFlat<int>([1, 2]), [3, 4]), 5);
    final List<int> list = l.unlock;
    list.add(6);
    list[0] = 100;
    expect(list, [100, 2, 3, 4, 5, 6]);
    expect(l.unlock, [1, 2, 3, 4, 5]);

    // Also when copying the flushed list of a node below.
    final L<int> top = LAdd(l, 6);
    l.getFlushed;
    final List<int> list2 = top.unlock;
    list2[0] = 100;
    expect(top.unlock, [1, 2, 3, 4, 5, 6]);
    expect(l.getFlushed, [1, 2, 3, 4, 5]);
  });

  test("IList with a deep chain of adds and addAlls", () {
    final List<int> expected = [for (int i = 0; i < 100; i++) i];
    IList<int> ilist = IList<int>(expected);
    for (int i = 0; i < 3000; i++) {
      if (i % 3 == 0) {
        ilist = ilist.addAll([i, -i]);
        expected.addAll([i, -i]);
      } else {
        ilist = ilist.add(i);
        expected.add(i);
      }
    }
    expect(ilist.isFlushed, isFalse);
    expect(ilist.unlock, expected);
    expect(ilist.flush.isFlushed, isTrue);
    expect(ilist, expected);
    expect(ilist.unlock, expected);
  });

  test("IList that adds another unflushed IList", () {
    final IList<int> other = IList<int>([10]).add(20).addAll([30, 40]);
    final IList<int> ilist = IList<int>([1, 2]).add(3).addAll(other).add(4);
    expect(ilist.unlock, [1, 2, 3, 10, 20, 30, 40, 4]);
    expect(ilist.flush, [1, 2, 3, 10, 20, 30, 40, 4]);
  });
}
