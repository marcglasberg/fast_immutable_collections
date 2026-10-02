// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/iset/iset.dart";
import "package:test/test.dart";

extension _TestExtension on ISet {
  int get counter => InternalsForTestingPurposesISet(this).counter;
}

/// An object whose equality depends only on [id], so that we can tell apart
/// equal (but not identical) instances by their [tag].
class _Item {
  final int id;
  final String tag;

  _Item(this.id, this.tag);

  @override
  bool operator ==(Object other) => other is _Item && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => "$id$tag";
}

var _computeCount = 0;

final _countingKey = CacheKey<ISet<int>, int>(
  (set) {
    _computeCount++;
    return set.fold(0, (a, b) => a + b);
  },
);

/// These tests cover code paths of [ISet] which were not reached by other tests.
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() => ImmutableCollection.resetAllConfigurations());

  //////////////////////////////////////////////////////////////////////////////

  group("ISetConst | identity equals |", () {
    //
    test("hashCode | can be calculated, and the set is still equal to itself", () {
      const ISet<int> iset = ISetConst<int>({1, 2}, ConfigSet(isDeepEquals: false));

      expect(iset.isIdentityEquals, isTrue);
      expect(iset.hashCode, isA<int>());
      expect(iset == iset, isTrue);
      expect(iset.same(iset), isTrue);

      // A const set with the same items but deep equals is not equal to it.
      const ISet<int> deep = ISetConst<int>({1, 2});
      expect(iset == deep, isFalse);
      expect(deep == iset, isFalse);

      // Identity equals compares the internals, so a non-const set with the same
      // items is not equal.
      expect(iset == ISet.withConfig({1, 2}, ConfigSet(isDeepEquals: false)), isFalse);
    });

    test(
      "hashCode | is stable and consistent with ==",
      () {
        const ISet<int> iset1 = ISetConst<int>({1, 2}, ConfigSet(isDeepEquals: false));
        const ISet<int> iset2 = ISetConst<int>({1, 2}, ConfigSet(isDeepEquals: false));

        expect(iset1.hashCode, iset1.hashCode);
        expect(iset1 == iset2, isTrue);
        expect(iset1.hashCode, iset2.hashCode);
        expect({iset1}.contains(iset2), isTrue);
      },
    );
  });

  //////////////////////////////////////////////////////////////////////////////

  group("Const and empty sets with autoFlush on |", () {
    //
    setUp(() {
      ImmutableCollection.resetAllConfigurations();
      ImmutableCollection.autoFlush = true;
    });

    test("ISetConst | contains", () {
      const ISet<int> iset = ISetConst<int>({1, 2, 3});
      expect(iset.contains(1), isTrue);
      expect(iset.contains(3), isTrue);
      expect(iset.contains(4), isFalse);
      expect(iset.counter, 0);
      expect(iset.isFlushed, isTrue);
    });

    test("ISetConst | containsAll", () {
      const ISet<int> iset = ISetConst<int>({1, 2, 3});
      expect(iset.containsAll([]), isTrue);
      expect(iset.containsAll([1, 3]), isTrue);
      expect(iset.containsAll({1, 2, 3}.lock), isTrue);
      expect(iset.containsAll([1, 4]), isFalse);
      expect(iset.counter, 0);
    });

    test("ISetConst | lookup", () {
      const ISet<int> iset = ISetConst<int>({1, 2, 3});
      expect(iset.lookup(2), 2);
      expect(iset.lookup(4), isNull);
      expect(iset.counter, 0);
    });

    test("ISetConst | empty const set", () {
      const ISet<int> iset = ISetConst<int>({});
      expect(iset.contains(1), isFalse);
      expect(iset.containsAll([]), isTrue);
      expect(iset.containsAll([1]), isFalse);
      expect(iset.lookup(1), isNull);
      expect(iset.counter, 0);
    });

    test("ISetEmpty | contains, containsAll, lookup", () {
      const ISet<int> iset = ISet<int>.empty();
      expect(iset.contains(1), isFalse);
      expect(iset.containsAll([]), isTrue);
      expect(iset.containsAll([1]), isFalse);
      expect(iset.lookup(1), isNull);
      expect(iset.counter, 0);
      expect(iset.isFlushed, isTrue);
    });
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ISetConst | cached | computes the value every time (no caching)", () {
    const ISet<int> iset = ISetConst<int>({1, 2, 3});
    _computeCount = 0;

    expect(iset.cached(_countingKey), 6);
    expect(iset.cached(_countingKey), 6);
    expect(_computeCount, 2);

    // A regular set caches it.
    final ISet<int> regular = {1, 2, 3}.lock;
    _computeCount = 0;
    expect(regular.cached(_countingKey), 6);
    expect(regular.cached(_countingKey), 6);
    expect(_computeCount, 1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("fromJson", () {
    final ISet<int> iset = ISet<int>.fromJson([1, 2, 2, 3], (Object? o) => o as int);
    expect(iset, isA<ISet<int>>());
    expect(iset, [1, 2, 3]);
    expect(iset.config, ISet.defaultConfig);

    final ISet<String> fromStrings =
        ISet<String>.fromJson(["b", "a"], (Object? o) => (o as String).toUpperCase());
    expect(fromStrings, ["B", "A"]);

    expect(ISet<int>.fromJson([], (Object? o) => o as int), isEmpty);
    expect(() => ISet<int>.fromJson({"a": 1}, (Object? o) => o as int), throwsA(isA<TypeError>()));
  });

  test("toJson", () {
    expect({1, 2, 3}.lock.toJson((int i) => "$i"), ["1", "2", "3"]);
    expect({1, 2, 3}.lock.toJson((int i) => i), isA<List>());
    expect(<int>{}.lock.toJson((int i) => i), <int>[]);
    expect(const ISet<int>.empty().toJson((int i) => i), <int>[]);
    expect(const ISetConst<int>({3, 1}).toJson((int i) => i * 10), [30, 10]);

    // Unflushed set.
    expect({1}.lock.add(2).addAll([3, 4]).toJson((int i) => i), [1, 2, 3, 4]);

    // Sorted set.
    expect({3, 1, 2}.lock.withConfig(ConfigSet(sort: true)).toJson((int i) => i), [1, 2, 3]);
  });

  test("fromJson | toJson round trip", () {
    final ISet<int> iset = {5, 1, 3}.lock;
    final Object json = iset.toJson((int i) => i);
    expect(ISet<int>.fromJson(json, (Object? o) => o as int), iset);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("lengthCompare", () {
    final ISet<int> iset = {1, 2, 3}.lock;
    expect(iset.lengthCompare([7, 8, 9]), isTrue);
    expect(iset.lengthCompare({7, 8, 9}), isTrue);
    expect(iset.lengthCompare({7, 8, 9}.lock), isTrue);
    expect(iset.lengthCompare([1, 2]), isFalse);
    expect(iset.lengthCompare([1, 2, 3, 4]), isFalse);

    // Duplicates in a list count for its length.
    expect(iset.lengthCompare([1, 1, 1]), isTrue);

    // Empty.
    expect(<int>{}.lock.lengthCompare([]), isTrue);
    expect(const ISet<int>.empty().lengthCompare(<int>{}), isTrue);
    expect(const ISet<int>.empty().lengthCompare([1]), isFalse);

    // Unflushed.
    final ISet<int> unflushed = {1}.lock.add(2).addAll({3, 4});
    expect(unflushed.isFlushed, isFalse);
    expect(unflushed.lengthCompare([1, 2, 3, 4]), isTrue);
    expect(unflushed.lengthCompare(iset), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("difference | with ISet and List arguments", () {
    final ISet<int> iset = {1, 2, 3, 4}.lock;

    // ISet argument.
    expect(iset.difference({1, 2, 5}.lock), {3, 4});
    expect(iset.difference({1, 2, 3, 4}.lock), <int>{});
    expect(iset.difference(<int>{}.lock), {1, 2, 3, 4});
    expect(iset.difference(const ISet<int>.empty()), {1, 2, 3, 4});
    expect(iset.difference(const ISetConst<int>({2})), {1, 3, 4});
    expect(iset.difference({1}.lock.add(2).addAll([3])), {4});

    // List argument (not a Set).
    expect(iset.difference([1, 2, 5]), {3, 4});
    expect(iset.difference([1, 1, 2, 2]), {3, 4});
    expect(iset.difference(<int>[]), {1, 2, 3, 4});

    // Generic Iterable argument (not a Set, not a List).
    expect(iset.difference([1, 2, 3].where((int i) => i.isOdd)), {2, 4});

    // Result keeps the config.
    final ISet<int> sorted = {4, 3, 2, 1}.lock.withConfig(ConfigSet(sort: true));
    final ISet<int> result = sorted.difference([2]);
    expect(result.config, ConfigSet(sort: true));
    expect(result.toList(), [1, 3, 4]);
  });

  test("intersection | with ISet and List arguments", () {
    final ISet<int> iset = {1, 2, 3, 4}.lock;

    // ISet argument.
    expect(iset.intersection({1, 2, 5}.lock), {1, 2});
    expect(iset.intersection({10, 20}.lock), <int>{});
    expect(iset.intersection(const ISet<int>.empty()), <int>{});
    expect(iset.intersection(const ISetConst<int>({4, 3, 9})), {3, 4});
    expect(iset.intersection({1}.lock.add(2).addAll([30])), {1, 2});

    // List argument (not a Set).
    expect(iset.intersection([2, 2, 4, 6]), {2, 4});
    expect(iset.intersection(<int>[]), <int>{});

    // Generic Iterable argument (not a Set, not a List).
    expect(iset.intersection([1, 2, 3].map((int i) => i * 2)), {2, 4});

    // Result keeps the config.
    final ISet<int> identitySet = {4, 3, 2, 1}.lock.withConfig(ConfigSet(isDeepEquals: false));
    final ISet<int> result = identitySet.intersection([1, 4]);
    expect(result.config, ConfigSet(isDeepEquals: false));
    expect(result.unorderedEqualItems([1, 4]), isTrue);
  });

  test("union | with ISet and List arguments", () {
    final ISet<int> iset = {1, 2, 3, 4}.lock;

    // ISet argument.
    expect(iset.union({1, 2, 5}.lock), {1, 2, 3, 4, 5});
    expect(iset.union(const ISet<int>.empty()), {1, 2, 3, 4});
    expect(iset.union(const ISetConst<int>({6, 1})), {1, 2, 3, 4, 6});
    expect(iset.union({7}.lock.add(8)), {1, 2, 3, 4, 7, 8});

    // List argument (not a Set).
    expect(iset.union([5, 5, 1]).toList(), [1, 2, 3, 4, 5]);
    expect(iset.union(<int>[]), {1, 2, 3, 4});
    expect(iset.union(<int>[]).same(iset), isTrue);

    // Sorted.
    final ISet<int> sorted = {4, 3}.lock.withConfig(ConfigSet(sort: true));
    expect(sorted.union([1, 2, 5]).toList(), [1, 2, 3, 4, 5]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("unorderedEqualItems", () {
    final ISet<int> iset = {1, 2, 3}.lock;

    // Null.
    expect(iset.unorderedEqualItems(null), isFalse);
    expect(const ISet<int>.empty().unorderedEqualItems(null), isFalse);

    // Identical.
    expect(iset.unorderedEqualItems(iset), isTrue);

    // Same internals (but different instances).
    final ISet<int> sameInternals = iset.withConfig(ConfigSet(isDeepEquals: false));
    final ISet<int> sameInternals2 = iset.withConfig(ConfigSet(isDeepEquals: false));
    expect(identical(sameInternals, sameInternals2), isFalse);
    expect(sameInternals.same(sameInternals2), isTrue);
    expect(sameInternals.unorderedEqualItems(sameInternals2), isTrue);

    // Other iterables, in whatever order.
    expect(iset.unorderedEqualItems([3, 2, 1]), isTrue);
    expect(iset.unorderedEqualItems({2, 1, 3}), isTrue);
    expect(iset.unorderedEqualItems({3, 1, 2}.lock), isTrue);
    expect(iset.unorderedEqualItems({3}.lock.add(1).addAll([2])), isTrue);

    // Different items or number of items.
    expect(iset.unorderedEqualItems([1, 2]), isFalse);
    expect(iset.unorderedEqualItems([1, 2, 3, 4]), isFalse);
    expect(iset.unorderedEqualItems([1, 2, 4]), isFalse);
    expect(iset.unorderedEqualItems([1, 2, 3, 3]), isFalse);

    // Empty.
    expect(<int>{}.lock.unorderedEqualItems([]), isTrue);
    expect(const ISet<int>.empty().unorderedEqualItems(<int>{}.lock), isTrue);
    expect(const ISet<int>.empty().unorderedEqualItems([1]), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("equalItems | Ignores the config, even after the hashCodes are calculated", () {
    final ISet<int> sorted = ISet.withConfig({1, 2}, ConfigSet(sort: true));
    final ISet<int> notSorted = ISet.withConfig({1, 2}, ConfigSet(sort: false));
    final ISet<int> identity = ISet.withConfig({1, 2}, ConfigSet(isDeepEquals: false));
    const ISet<int> constSet = ISetConst({1, 2}, ConfigSet(cacheHashCode: false));

    sorted.hashCode;
    notSorted.hashCode;
    identity.hashCode;

    expect(sorted.equalItems(notSorted), isTrue);
    expect(notSorted.equalItems(sorted), isTrue);
    expect(sorted.equalItems(identity), isTrue);
    expect(identity.equalItems(sorted), isTrue);
    expect(notSorted.equalItems(constSet), isTrue);
    expect(constSet.equalItems(notSorted), isTrue);

    // Different items with the same config are still detected.
    final ISet<int> other = ISet.withConfig({1, 3}, ConfigSet(sort: true));
    other.hashCode;
    expect(sorted.equalItems(other), isFalse);
  });

  test("equalItemsAndConfig | Identity equals with equal items but different internals", () {
    final ISet<int> iset1 = ISet.withConfig({1, 2}, ConfigSet(isDeepEquals: false));
    final ISet<int> iset2 = ISet.withConfig({1, 2}, ConfigSet(isDeepEquals: false));
    expect(iset1 == iset2, isFalse);
    expect(iset1.equalItemsAndConfig(iset2), isTrue);

    iset1.hashCode;
    iset2.hashCode;
    expect(iset1.equalItemsAndConfig(iset2), isTrue);

    expect(iset1.equalItemsAndConfig(null), isFalse);
    expect({1}.lock.equalItemsAndConfig(null), isFalse);
    expect(const ISet<int>.empty().equalItemsAndConfig(null), isFalse);
  });

  test("toString | prettyPrint of empty sets", () {
    ImmutableCollection.prettyPrint = false;
    expect(ISet<int>().toString(true), "{}");
    expect(<int>{}.lock.toString(true), "{}");
    expect(const ISet<int>.empty().toString(true), "{}");
    expect(const ISetConst<int>({}).toString(true), "{}");
    expect({1}.lock.remove(1).toString(true), "{}");

    ImmutableCollection.prettyPrint = true;
    expect(ISet<int>().toString(), "{}");
    expect(ISet<String>().toString(false), "{}");
  });

  test("toString | unflushed and sorted sets", () {
    ImmutableCollection.prettyPrint = false;
    expect({1}.lock.add(2).addAll([3]).toString(), "{1, 2, 3}");
    expect({1}.lock.add(2).toString(true), "{\n   1,\n   2\n}");
    expect(<int>{}.lock.add(7).toString(true), "{7}");
    expect({3, 1, 2}.lock.withConfig(ConfigSet(sort: true)).toString(), "{1, 2, 3}");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("lookup | ModifiableSetFromISet and UnmodifiableSetFromISet return the instance in the set",
      () {
    final _Item a1 = _Item(1, "a");
    final _Item b1 = _Item(1, "b");
    final ISet<_Item> iset = {a1}.lock;

    // ModifiableSetFromISet, before and after switching to a mutable set.
    final ModifiableSetFromISet<_Item> modifiable = ModifiableSetFromISet(iset);
    expect(identical(modifiable.lookup(b1), a1), isTrue);
    expect(modifiable.lookup(_Item(9, "x")), isNull);
    modifiable.add(_Item(2, "a"));
    expect(identical(modifiable.lookup(b1), a1), isTrue);
    expect(modifiable.lookup(_Item(9, "x")), isNull);
    expect(identical((ModifiableSetFromISet<_Item>(null)..add(a1)).lookup(b1), a1), isTrue);

    // UnmodifiableSetFromISet, from an ISet and from a Set.
    expect(identical(UnmodifiableSetFromISet(iset).lookup(b1), a1), isTrue);
    expect(UnmodifiableSetFromISet(iset).lookup(_Item(9, "x")), isNull);
    expect(identical(UnmodifiableSetFromISet.fromSet({a1}).lookup(b1), a1), isTrue);
    expect(UnmodifiableSetFromISet.fromSet({a1}).lookup(_Item(9, "x")), isNull);

    // The views returned by unlockView and unlockLazy.
    expect(identical(iset.unlockView.lookup(b1), a1), isTrue);
    expect(identical(iset.unlockLazy.lookup(b1), a1), isTrue);
  });

  test("lookup | returns the instance that is in the set", () {
    final _Item a1 = _Item(1, "a");
    final _Item b1 = _Item(1, "b");
    final _Item a2 = _Item(2, "a");
    final _Item a3 = _Item(3, "a");
    final _Item b3 = _Item(3, "b");

    // Flushed.
    final ISet<_Item> flushed = {a1, a2}.lock;
    expect(identical(flushed.lookup(b1), a1), isTrue);
    expect(flushed.lookup(_Item(9, "x")), isNull);

    // After add (SAdd).
    final ISet<_Item> afterAdd = {a1}.lock.add(a3);
    expect(afterAdd.isFlushed, isFalse);
    expect(identical(afterAdd.lookup(b3), a3), isTrue);
    expect(identical(afterAdd.lookup(b1), a1), isTrue);
    expect(afterAdd.lookup(_Item(9, "x")), isNull);

    // After addAll (SAddAll).
    final ISet<_Item> afterAddAll = {a1}.lock.addAll([a2, a3]);
    expect(afterAddAll.isFlushed, isFalse);
    expect(identical(afterAddAll.lookup(b3), a3), isTrue);
    expect(identical(afterAddAll.lookup(b1), a1), isTrue);
    expect(afterAddAll.lookup(_Item(9, "x")), isNull);

    // Adding an equal item doesn't replace the original one.
    final ISet<_Item> notReplaced = {a1}.lock.add(b1).addAll([b1]);
    expect(notReplaced.length, 1);
    expect(identical(notReplaced.lookup(b1), a1), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("sort config | toSet, join, toIList, firstOr, lastOr", () {
    final ISet<int> sorted = {5, 3, 1, 4}.lock.withConfig(ConfigSet(sort: true));

    final Set<int> set = sorted.toSet();
    expect(set, isA<LinkedHashSet<int>>());
    expect(set.toList(), [1, 3, 4, 5]);
    expect(sorted.toSet(compare: (int a, int b) => b.compareTo(a)).toList(), [5, 4, 3, 1]);

    expect(sorted.join(","), "1,3,4,5");
    expect(sorted.toIList(), [1, 3, 4, 5]);
    expect(sorted.toIList(compare: (int a, int b) => b.compareTo(a)), [5, 4, 3, 1]);
    expect(sorted.toList(compare: (int a, int b) => b.compareTo(a)), [5, 4, 3, 1]);

    expect(sorted.firstOr(100), 1);
    expect(sorted.lastOr(100), 5);
    expect(sorted.firstOrNull, 1);
    expect(sorted.lastOrNull, 5);

    final ISet<int> emptySorted = <int>{}.lock.withConfig(ConfigSet(sort: true));
    expect(emptySorted.firstOr(100), 100);
    expect(emptySorted.lastOr(100), 100);
    expect(emptySorted.join(","), "");
    expect(emptySorted.toSet(), isEmpty);
  });

  test("sort config | add, addAll, remove, toggle keep the set sorted", () {
    final ISet<int> sorted = {5, 3}.lock.withConfig(ConfigSet(sort: true));

    expect(sorted.add(1).toList(), [1, 3, 5]);
    expect(sorted.add(4).first, 3);
    expect(sorted.add(4).last, 5);
    expect(sorted.addAll([9, 0, 4]).toList(), [0, 3, 4, 5, 9]);
    expect(sorted.addAll([9, 0, 4]).config, ConfigSet(sort: true));
    expect(sorted.add(1).remove(3).toList(), [1, 5]);
    expect(sorted.toggle(4).toList(), [3, 4, 5]);
    expect(sorted.toggle(3).toList(), [5]);
    expect(sorted.removeAll([5]).toList(), [3]);
    expect(sorted.retainAll([5]).toList(), [5]);
    expect(sorted.removeWhere((int i) => i > 4).config, ConfigSet(sort: true));
    expect(sorted.retainWhere((int i) => i > 4).config, ConfigSet(sort: true));
  });

  test("toIList | with config", () {
    final IList<int> ilist = {3, 1}.lock.add(2).toIList(config: ConfigList(isDeepEquals: false));
    expect(ilist, [3, 1, 2]);
    expect(ilist.config, ConfigList(isDeepEquals: false));
    expect(const ISet<int>.empty().toIList(), isEmpty);
    expect(const ISetConst<int>({2, 1}).toIList(compare: (int a, int b) => a.compareTo(b)), [1, 2]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("singleOr | singleOrNull | on unflushed sets", () {
    expect(<int>{}.lock.add(1).singleOr(10), 1);
    expect(<int>{}.lock.add(1).singleOrNull, 1);
    expect(<int>{}.lock.addAll([1]).singleOr(10), 1);
    expect({1}.lock.add(2).singleOr(10), 10);
    expect({1}.lock.add(2).singleOrNull, isNull);
    expect({1}.lock.remove(1).singleOrNull, isNull);
    expect(const ISet<int>.empty().singleOr(10), 10);
    expect(const ISetConst<int>({7}).singleOr(10), 7);
  });

  test("removeAll | retainAll | keep the config", () {
    final ISet<int> iset = {1, 2, 3}.lock.withConfig(ConfigSet(isDeepEquals: false));
    expect(iset.removeAll([2]).config, ConfigSet(isDeepEquals: false));
    expect(iset.removeAll([2]), allOf(isA<ISet<int>>(), [1, 3]));
    expect(iset.retainAll([2, 9]).config, ConfigSet(isDeepEquals: false));
    expect(iset.retainAll([2, 9]), [2]);

    // Unflushed and const sets.
    expect({1}.lock.add(2).addAll([3]).removeAll([1, 3]), [2]);
    expect(const ISetConst<int>({1, 2, 3}).retainAll([3, 1]), [1, 3]);
    expect(const ISet<int>.empty().removeAll([1]), isEmpty);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ModifiableSetFromISet | created from null", () {
    final ModifiableSetFromISet<int> set = ModifiableSetFromISet(null);
    expect(set, isEmpty);
    expect(set.length, 0);
    expect(set.contains(1), isFalse);
    expect(set.toSet(), <int>{});
    expect(set.lock, isA<ISet<int?>>());
    expect(set.lock, isEmpty);

    expect(set.add(1), isTrue);
    expect(set.add(1), isFalse);
    expect(set, [1]);
    expect(set.lock, [1]);
  });

  test("ModifiableSetFromISet | lock, toSet, iterator after mutation", () {
    final ISet<int> iset = {1, 2, 3}.lock;
    final ModifiableSetFromISet<int> set = ModifiableSetFromISet(iset);

    // Before mutating, locking returns the original ISet.
    expect(identical(set.lock, iset), isTrue);

    set.add(4);
    set.remove(1);

    expect(set.length, 3);
    expect(set.toList(), [2, 3, 4]);
    expect(set.toSet(), {2, 3, 4});
    expect(set.lock, allOf(isA<ISet<int?>>(), [2, 3, 4]));

    // The original ISet was not changed.
    expect(iset, [1, 2, 3]);
  });

  test("UnmodifiableSetFromISet | lock returns the original ISet", () {
    final ISet<int> iset = {1, 2, 3}.lock;
    expect(identical(UnmodifiableSetFromISet(iset).lock, iset), isTrue);
    expect(UnmodifiableSetFromISet<int>(null).lock, isEmpty);
    expect(UnmodifiableSetFromISet.fromSet({1, 2}).lock, allOf(isA<ISet<int>>(), [1, 2]));
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
    "ISet.withConfig factory | sorts an ISet when the new config is sorted",
    () {
      final ISet<int> iset = ISet.withConfig({3, 1, 2}.lock, ConfigSet(sort: true));
      expect(iset.toList(), [1, 2, 3]);
      expect(iset.first, 1);
      expect(iset.config, ConfigSet(sort: true));

      // Unflushed source: iteration and `first` must agree.
      final ISet<int> unflushed = {3, 1}.lock.add(2);
      expect(unflushed.isFlushed, isFalse);
      final ISet<int> sorted = ISet.withConfig(unflushed, ConfigSet(sort: true));
      expect(sorted.toList(), [1, 2, 3]);
      expect(sorted.first, 1);
      expect(sorted.last, 3);

      // Const source.
      expect(ISet.withConfig(const ISetConst({3, 1, 2}), ConfigSet(sort: true)).toList(),
          [1, 2, 3]);

      // The source is not changed.
      expect(unflushed.toList(), [3, 1, 2]);
    },
  );

  test("remove | Const and empty sets return the same instance", () {
    const ISet<int> constSet = ISetConst({1, 2, 3});
    expect(identical(constSet.remove(4), constSet), isTrue);
    expect(constSet.remove(2), {1, 3});

    const ISet<int> empty = ISet.empty();
    expect(identical(empty.remove(1), empty), isTrue);
  });

  test("Identity equals | == and hashCode compare the ISet object, and don't change when flushed",
      () {
    const ConfigSet noCache = ConfigSet(isDeepEquals: false, cacheHashCode: false);
    const ConfigSet cache = ConfigSet(isDeepEquals: false);

    final ISet<int> iset = ISet.withConfig({1}, noCache).add(2);
    final int hashCode = iset.hashCode;
    final Set<ISet<int>> set = {iset};
    iset.flush;
    expect(iset.hashCode, hashCode);
    expect(set.contains(iset), isTrue);

    // Different ISet objects are not equal, even if they share the same internals.
    final ISet<int> iset2 = ISet.withConfig({1}, cache).add(2);
    final ISet<int> sameInternals = iset2.withConfig(noCache).withConfig(cache);
    expect(identical(iset2, sameInternals), isFalse);
    expect(iset2 == sameInternals, isFalse);

    expect(iset2 == iset2, isTrue);
    iset2.flush;
    expect(iset2 == iset2, isTrue);
  });
}
