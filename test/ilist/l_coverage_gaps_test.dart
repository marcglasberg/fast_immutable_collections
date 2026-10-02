// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/ilist/ilist.dart";
import "package:fast_immutable_collections/src/ilist/l_add.dart";
import "package:fast_immutable_collections/src/ilist/l_add_all.dart";
import "package:fast_immutable_collections/src/ilist/l_flat.dart";
import "package:test/test.dart";

/// These tests are mainly for coverage purposes. They test the default methods of the [L] class,
/// which are not reached by its own implementations ([LFlat], [LAdd] and [LAddAll]).
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
  });

  tearDown(() {
    ImmutableCollection.resetAllConfigurations();
  });

  test("below | Is null for a custom L", () {
    expect(LCoverage<int>([1, 2]).below, isNull);
  });

  test("fillOwnItemsBefore | Default implementation", () {
    final List<Object?> target = List<Object?>.filled(5, 0);
    final int start = LCoverage<int>([1, 2, 3]).fillOwnItemsBefore(target, 4);

    expect(start, 1);
    expect(target, [0, 1, 2, 3, 0]);

    // Empty.
    final List<Object?> target2 = List<Object?>.filled(2, 0);
    expect(LCoverage<int>([]).fillOwnItemsBefore(target2, 2), 2);
    expect(target2, [0, 0]);
  });

  test("fillBefore | Uses the default fillOwnItemsBefore", () {
    final List<Object?> target = List<Object?>.filled(4, null);
    final int start = LCoverage<String>(["a", "b"]).fillBefore(target, 3);

    expect(start, 1);
    expect(target, [null, "a", "b", null]);
  });

  test("fillBefore | When the list was already flushed, copies the flushed list", () {
    final L<int> l = LCoverage<int>([1, 2]);
    expect(l.getFlushed, [1, 2]);

    final List<Object?> target = List<Object?>.filled(3, 0);
    expect(l.fillBefore(target, 3), 1);
    expect(target, [0, 1, 2]);
  });

  test("unlock | LAddAll of a custom L, when most items are in the base", () {
    // Base has 2 items, and the custom L has 2 items.
    final L<int> l = LAddAll<int>(LFlat<int>([1, 2]), LCoverage<int>([3, 4]));

    final List<int> unlocked = l.unlock;
    expect(unlocked, [1, 2, 3, 4]);
    expect(l.length, 4);
    expect(l[3], 4);

    // The unlocked list is mutable and independent.
    unlocked.add(5);
    expect(unlocked, [1, 2, 3, 4, 5]);
    expect(l.unlock, [1, 2, 3, 4]);
  });

  test("unlock | LAddAll of a custom L, when most items are NOT in the base", () {
    // Base has 1 item, and the custom L has 3 items.
    final L<int> l = LAddAll<int>(LFlat<int>([1]), LCoverage<int>([2, 3, 4]));

    expect(l.unlock, [1, 2, 3, 4]);
    expect(l.getFlushed, [1, 2, 3, 4]);
  });

  test("unlock | Chain of LAdd and LAddAll on top of a custom L", () {
    final L<int> l = LAdd<int>(LAddAll<int>(LCoverage<int>([1, 2]), [3]), 4);
    expect(l.unlock, [1, 2, 3, 4]);

    final L<int> l2 =
        LAddAll<int>(LFlat<int>([1]), LAdd<int>(LCoverage<int>([2, 3]), 4)).addAll([5, 6]);
    expect(l2.unlock, [1, 2, 3, 4, 5, 6]);
    expect(l2.length, 6);
    expect(l2[2], 3);
  });

  test("sort | Raw MapEntry without a compare function", () {
    final L<MapEntry> sorted = LCoverage<MapEntry>([
      MapEntry("c", 3),
      MapEntry("a", 2),
      MapEntry("b", 2),
      MapEntry("a", 1),
    ]).sort();

    expect(sorted.unlock.map((MapEntry e) => "${e.key}${e.value}"), ["a1", "a2", "b2", "c3"]);
  });

  test("sortOrdered | Raw MapEntry without a compare function", () {
    final L<MapEntry> sorted = LCoverage<MapEntry>([
      MapEntry("c", 3),
      MapEntry("a", 2),
      MapEntry("b", 2),
      MapEntry("a", 1),
    ]).sortOrdered();

    expect(sorted.unlock.map((MapEntry e) => "${e.key}${e.value}"), ["a1", "a2", "b2", "c3"]);
  });

  test("sort | Raw MapEntry with a compare function uses it", () {
    final L<MapEntry> sorted = LCoverage<MapEntry>([
      MapEntry("a", 1),
      MapEntry("b", 3),
      MapEntry("c", 2),
    ]).sort((MapEntry a, MapEntry b) => (b.value as int).compareTo(a.value as int));

    expect(sorted.unlock.map((MapEntry e) => e.key), ["b", "c", "a"]);
  });

  test("removeAll | Removing nothing returns the same L", () {
    final L<int> l = LCoverage<int>([1, 2, 3]);
    expect(l.removeAll([4, null]), same(l));
    expect(l.removeAll([]), same(l));

    // Removing something returns a new LFlat.
    final L<int> removed = l.removeAll([1, 3]);
    expect(removed, isA<LFlat<int>>());
    expect(removed.unlock, [2]);
    expect(l.unlock, [1, 2, 3]);
  });

  test("toLinkedHashSet | Keeps the order and removes duplicates", () {
    final LinkedHashSet<int> set = LCoverage<int>([3, 1, 3, 2, 1]).toLinkedHashSet();
    expect(set, isA<LinkedHashSet<int>>());
    expect(set.toList(), [3, 1, 2]);

    expect(LCoverage<int>([]).toLinkedHashSet(), isEmpty);
  });
}

/// A custom [L] which does NOT override most of the default [L] methods.
class LCoverage<T> extends L<T> {
  final IList<T> _ilist;

  LCoverage([Iterable<T>? iterable]) : _ilist = IList(iterable);

  @override
  Iterator<T> get iterator => _ilist.iterator;

  @override
  T operator [](int index) => _ilist[index];

  @override
  Iterable<T> get iter => _ilist;

  @override
  T get first => _ilist.first;

  @override
  T get last => _ilist.last;

  @override
  int get length => _ilist.length;

  @override
  T get single => _ilist.single;
}
