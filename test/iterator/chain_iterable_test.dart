// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/ilist/ilist.dart";
import "package:fast_immutable_collections/src/ilist/l_add.dart";
import "package:fast_immutable_collections/src/ilist/l_add_all.dart";
import "package:fast_immutable_collections/src/ilist/l_flat.dart";
import "package:fast_immutable_collections/src/imap/imap.dart";
import "package:fast_immutable_collections/src/imap/m_add.dart";
import "package:fast_immutable_collections/src/imap/m_add_all.dart";
import "package:fast_immutable_collections/src/imap/m_flat.dart";
import "package:fast_immutable_collections/src/imap/m_replace.dart";
import "package:fast_immutable_collections/src/iset/iset.dart";
import "package:fast_immutable_collections/src/iset/s_add.dart";
import "package:fast_immutable_collections/src/iset/s_add_all.dart";
import "package:fast_immutable_collections/src/iset/s_flat.dart";
import "package:fast_immutable_collections/src/iterator/chain_iterator.dart";
import "package:test/test.dart";

/// Tests for the paths of [ChainIterable] (and related chain code) which are
/// not covered by the tests of the collections.
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  /// An unflushed IList (a chain of adds and addAlls) with items 1 to 6.
  IList<int> unflushedIList() => IList<int>([1, 2]).add(3).addAll([4, 5]).add(6);

  /// An unflushed ISet (a chain of adds and addAlls) with items 1 to 6.
  ISet<int> unflushedISet() => ISet<int>({1, 2}).add(3).addAll({4, 5}).add(6);

  /// Checks the members of a [ChainIterable] created by `where`, which can't
  /// use the own lengths of the nodes (because `where` removes items).
  void checkWhere(Iterable<int> result, List<int> expected) {
    // Makes sure this is the `where` of a chain, and not of a flat collection.
    expect(result, isA<ChainIterable<int>>());
    final ChainIterable<int> chain = result as ChainIterable<int>;

    expect(chain.length, expected.length);
    expect(chain.isEmpty, expected.isEmpty);
    expect(chain.isNotEmpty, expected.isNotEmpty);
    expect(chain.toList(), expected);
    expect(chain.toList(growable: false), expected);

    if (expected.isEmpty) {
      expect(() => chain.first, throwsStateError);
      expect(() => chain.last, throwsStateError);
      expect(() => chain.anyItem, throwsStateError);
      expect(() => chain.single, throwsStateError);
      expect(() => chain.elementAt(0), throwsRangeError);
    } else {
      expect(chain.first, expected.first);
      expect(chain.last, expected.last);
      expect(chain.anyItem, expected.first);
      if (expected.length == 1)
        expect(chain.single, expected.single);
      else
        expect(() => chain.single, throwsStateError);
      for (int i = 0; i < expected.length; i++) expect(chain.elementAt(i), expected[i]);
      expect(() => chain.elementAt(expected.length), throwsRangeError);
    }
    expect(() => chain.elementAt(-1), throwsRangeError);
  }

  group("After where (nodes can't use their own lengths):", () {
    //
    test("Unflushed IList, with no items, one item, and many items", () {
      final IList<int> ilist = unflushedIList();
      expect(ilist.isFlushed, isFalse);
      checkWhere(ilist.where((x) => x > 100), []);
      checkWhere(ilist.where((x) => x == 4), [4]);
      checkWhere(ilist.where((x) => x.isEven), [2, 4, 6]);
      checkWhere(ilist.where((x) => true), [1, 2, 3, 4, 5, 6]);
    });

    test("Unflushed ISet, with no items, one item, and many items", () {
      final ISet<int> iset = unflushedISet();
      expect(iset.isFlushed, isFalse);
      checkWhere(iset.where((x) => x > 100), []);
      checkWhere(iset.where((x) => x == 3), [3]);
      checkWhere(iset.where((x) => x.isOdd), [1, 3, 5]);
    });

    test("where, then map (map keeps the fallback paths)", () {
      final Iterable<int> result = unflushedIList().where((x) => x.isEven).map((x) => x * 10);
      expect(result, isA<ChainIterable<int>>());
      expect((result as ChainIterable<int>).anyItem, 20);
      expect(result.length, 3);
      expect(result.last, 60);
      expect(result.elementAt(1), 40);
    });
  });

  group("Without where (nodes use their own lengths):", () {
    //
    test("isNotEmpty", () {
      final L<int> l = LAdd(LAddAll(LFlat<int>([1]), [2]), 3);
      expect(l.chainItems.isNotEmpty, isTrue);

      final L<int> empty = LAddAll(LAddAll(LFlat<int>([]), <int>[]), <int>[]);
      expect(empty.chainItems.isNotEmpty, isFalse);

      // An empty base, with items above it.
      expect(LAdd(empty, 1).chainItems.isNotEmpty, isTrue);
    });

    test("toList(growable: false) returns a fixed-length list", () {
      final L<int> l = LAdd(LAddAll(LFlat<int>([1, 2]), [3]), 4);
      final List<int> fixed = l.chainItems.toList(growable: false);
      expect(fixed, [1, 2, 3, 4]);
      expect(() => fixed.add(5), throwsUnsupportedError);

      final List<int> growable = l.chainItems.toList();
      growable.add(5);
      expect(growable, [1, 2, 3, 4, 5]);
    });

    test("toList, when nodes send whole lists", () {
      // The first list starts the result, and the next lists are added to it.
      final L<int> lists = LAddAll(LAddAll(LFlat<int>([1, 2]), [3, 4]), [5, 6]);
      expect(lists.chainItems.toList(), [1, 2, 3, 4, 5, 6]);

      // Lists mixed with single items.
      final L<int> mixed = LAdd(LAddAll(LAdd(LFlat<int>([1]), 2), [3, 4]), 5);
      expect(mixed.chainItems.toList(), [1, 2, 3, 4, 5]);

      // An empty first list.
      final L<int> emptyBase = LAddAll(LAdd(LFlat<int>([]), 1), [2, 3]);
      expect(emptyBase.chainItems.toList(), [1, 2, 3]);

      // A set node sends its ListSet as a list.
      final S<int> s = SAddAll(SAdd(SFlat<int>({1, 2}), 3), {4, 5});
      expect(s.chainItems.toList(), [1, 2, 3, 4, 5]);
    });

    test("anyItem throws StateError when every node is empty", () {
      final L<int> l = LAddAll(LAddAll(LFlat<int>([]), <int>[]), <int>[]);
      expect(() => l.chainItems.anyItem, throwsStateError);

      final S<int> s = SAddAll(SAddAll(SFlat<int>({}), <int>{}), <int>{});
      expect(() => s.chainItems.anyItem, throwsStateError);
      expect(() => s.anyItem, throwsStateError);

      // When a node has items, it's returned.
      expect(LAddAll(LAdd(l, 7), <int>[]).chainItems.anyItem, 7);
      expect(SAddAll(SAdd(s, 7), <int>{}).anyItem, 7);
    });
  });

  group("toList and toSet of chains:", () {
    //
    /// Checks [toList] and [toSet] of a chain, against the [expected] items.
    /// The [extra] item is added to the results, to check they are modifiable
    /// (and for chains with nodes of a more specific type, that they hold `null`).
    void checkToListAndToSet<T>(Iterable<T> chain, List<T> expected, T extra) {
      // toList, growable.
      final List<T> list = chain.toList();
      expect(list, expected);
      list.add(extra);
      expect(list.length, expected.length + 1);

      // toList, not growable.
      final List<T> fixed = chain.toList(growable: false);
      expect(fixed, expected);
      expect(() => fixed.add(extra), throwsUnsupportedError);

      // toSet keeps the first occurrence of each item, in order.
      final Set<T> set = chain.toSet();
      expect(set.toList(), expected.toSet().toList());
      set.add(extra);
      expect(set.contains(extra), isTrue);

      // The results are independent from the chain.
      expect(chain.toList(), expected);
    }

    test("Unflushed IList", () {
      final IList<int> other = IList<int>([10]).add(11);
      final IList<int> ilist =
          IList<int>([1, 2]).add(3).addAll(<int>[]).addAll([4, 1]).addAll(other).add(2);
      expect(ilist.isFlushed, isFalse);
      checkToListAndToSet(ilist, [1, 2, 3, 4, 1, 10, 11, 2], -999);
    });

    test("IList nodes, including nodes with a more specific type", () {
      L<int?> l = LAddAll<int>(LFlat<int>([1, 2]), [3]);
      l = LAdd<int?>(l, null);
      l = LAddAll<int?>(l, <int?>[4, null]);
      checkToListAndToSet<int?>(l, [1, 2, 3, null, 4, null], null);

      // Empty chain.
      checkToListAndToSet(LAddAll(LAddAll(LFlat<int>([]), <int>[]), <int>[]), <int>[], -999);
    });

    test("Unflushed ISet", () {
      final ISet<int> iset = ISet<int>({3, 1}).add(2).addAll({5, 4}).add(0);
      expect(iset.isFlushed, isFalse);
      checkToListAndToSet(iset, [3, 1, 2, 5, 4, 0], -999);

      // With compare.
      expect(iset.toList(compare: (a, b) => a.compareTo(b)), [0, 1, 2, 3, 4, 5]);
      expect(iset.toSet(compare: (a, b) => a.compareTo(b)).toList(), [0, 1, 2, 3, 4, 5]);
    });

    test("Unflushed sorted ISet", () {
      final ISet<int> iset =
          ISet<int>.withConfig({3, 1}, ConfigSet(sort: true)).add(2).addAll({5, 4}).add(0);
      expect(iset.toList(), [0, 1, 2, 3, 4, 5]);
      expect(iset.toSet().toList(), [0, 1, 2, 3, 4, 5]);
    });

    test("ISet nodes, including nodes with a more specific type", () {
      S<int?> s = SAddAll<int>(SFlat<int>({1, 2}), {3});
      s = SAdd<int?>(s, null);
      s = SAddAll<int?>(s, <int?>{4});
      checkToListAndToSet<int?>(s, [1, 2, 3, null, 4], null);

      // Empty chain.
      checkToListAndToSet(SAddAll(SAddAll(SFlat<int>({}), <int>{}), <int>{}), <int>[], -999);
    });
  });

  group("toList(growable: false) of chains:", () {
    //
    /// Checks that [toList] with `growable: false` returns the [expected] items
    /// in a fixed-length list.
    void checkFixed<T>(Iterable<T> chain, List<T> expected) {
      final List<T> fixed = chain.toList(growable: false);
      expect(fixed, expected);
      // The result is a copy.
      if (expected.isNotEmpty) {
        fixed[0] = fixed.last;
        expect(chain.toList(growable: false), expected);
      }
      // A fixed-length list can't be cleared (a growable one can).
      expect(() => fixed.clear(), throwsUnsupportedError);
    }

    test("IList nodes, with empty nodes at the bottom, middle and top", () {
      L<int> l = LAddAll(LFlat<int>([]), <int>[]);
      l = LAdd(l, 1);
      l = LAddAll(l, <int>[]);
      l = LAddAll(l, [2, 3]);
      l = LAddAll(l, <int>[]);
      checkFixed(l, [1, 2, 3]);
      checkFixed(LAddAll(LAddAll(LFlat<int>([]), <int>[]), <int>[]), <int>[]);
    });

    test("IList nodes that send an iterable (an addAll of another chain)", () {
      final L<int> other = LAdd(LAddAll(LFlat<int>([10]), [11]), 12);
      final L<int> l = LAdd(LAddAll(LAdd(LFlat<int>([1]), 2), other), 3);
      checkFixed(l, [1, 2, 10, 11, 12, 3]);
    });

    test("IList nodes with a more specific type, and a null first item", () {
      checkFixed<int?>(LAdd<int?>(LAddAll<int>(LFlat<int>([1]), [2]), null), [1, 2, null]);
      checkFixed<int?>(LAddAll<int?>(LAdd<int?>(LFlat<int?>([null]), 2), [null]), [null, 2, null]);
    });

    test("Unflushed IList, and after where", () {
      final IList<int> ilist = IList<int>([1, 2]).add(3).addAll([4, 5]).add(6);
      expect(ilist.isFlushed, isFalse);
      checkFixed(ilist, [1, 2, 3, 4, 5, 6]);
      checkFixed(ilist.where((x) => x.isEven), [2, 4, 6]);
      checkFixed(ilist.where((x) => x > 100), <int>[]);
    });

    test("ISet nodes: ListSet base, ListSetView base, and addAll of a set", () {
      checkFixed(SAddAll(SAdd(SFlat<int>({1, 2}), 3), {4, 5}), [1, 2, 3, 4, 5]);
      checkFixed(SAdd(SFlat<int>.unsafe(<int>{3, 1, 2}), 0), [3, 1, 2, 0]);
      checkFixed<int?>(SAdd<int?>(SFlat<int>({1}), null), [1, null]);
      checkFixed(SAddAll(SAddAll(SFlat<int>({}), <int>{}), <int>{}), <int>[]);
    });

    test("The function given to map is called exactly once per item", () {
      final L<int> other = LAdd(LFlat<int>([10]), 11);
      final L<int> l = LAdd(LAddAll(LAddAll(LAdd(LFlat<int>([1, 2]), 3), other), [4]), 5);
      int calls = 0;
      final List<int> result = l.chainItems.map((x) {
        calls++;
        return x * 2;
      }).toList(growable: false);
      expect(result, [2, 4, 6, 20, 22, 8, 10]);
      expect(calls, 7);
    });

    test("IMap keys, values and entries, with addAll of chains and updates", () {
      M<String, int> items = MAdd(MFlat<String, int>({"x": 1}), "y", 2);
      items = MReplace(items, "x", 10);
      M<String, int> m = MAdd(MFlat<String, int>({"a": 1, "b": 2}), "c", 3);
      m = MAddAll.unsafe(m, items);
      m = MReplace(m, "a", 100);
      m = MAdd(m, "z", 26);
      checkFixed(m.keys, ["a", "b", "c", "x", "y", "z"]);
      checkFixed(m.values, [100, 2, 3, 10, 2, 26]);
      expect(m.entries.toList(growable: false).map((e) => "${e.key}:${e.value}").toList(),
          ["a:100", "b:2", "c:3", "x:10", "y:2", "z:26"]);
    });
  });

  group("IMap contains(key, null):", () {
    //
    test("On a chain of nodes", () {
      M<String, int?> m = MAdd<String, int?>(MFlat<String, int?>({"a": 1}), "b", null);
      m = MAdd<String, int?>(m, "c", 3);

      // A key that exists with a null value.
      expect(m.contains("b", null), isTrue);
      expect(m.contains("b", 5), isFalse);

      // A key that exists with a non-null value.
      expect(m.contains("a", null), isFalse);
      expect(m.contains("a", 1), isTrue);

      // A key that doesn't exist.
      expect(m.contains("x", null), isFalse);
      expect(m.contains("x", 1), isFalse);

      // A key whose value was updated to null.
      final M<String, int?> updated = MReplace<String, int?>(m, "a", null);
      expect(updated.contains("a", null), isTrue);
      expect(updated.contains("a", 1), isFalse);
      expect(updated.contains("x", null), isFalse);
    });

    test("On an IMap that isn't flushed yet", () {
      IMap<String, int?> imap = IMap<String, int?>({"a": 1}).add("b", null).add("c", 3);
      expect(imap.isFlushed, isFalse);
      expect(imap.contains("b", null), isTrue);
      expect(imap.contains("a", null), isFalse);
      expect(imap.contains("x", null), isFalse);

      // Updating an existing key to null.
      imap = imap.add("a", null);
      expect(imap.isFlushed, isFalse);
      expect(imap.contains("a", null), isTrue);
      expect(imap.contains("a", 1), isFalse);
    });
  });
}
