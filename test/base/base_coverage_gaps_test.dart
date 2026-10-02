// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/base/hash.dart";
import "package:test/test.dart";

enum _Color { red, green, blue }

enum _Size { small, large }

class _NotComparable {
  final int value;

  _NotComparable(this.value);
}

/// Returns its argument without letting flow-analysis promote it to non-nullable,
/// so that the `FicNumberExtensionNullable` extension is the one applied.
T? _nullable<T>(T? value) => value;

void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
  });

  tearDown(() {
    ImmutableCollection.resetAllConfigurations();
  });

  //////////////////////////////////////////////////////////////////////////////

  test("combineIterables | same sizes", () {
    expect(combineIterables<int, String, String>([1, 2, 3], ["a", "b", "c"], (a, b) => "$a$b"),
        ["1a", "2b", "3c"]);

    expect(combineIterables<int, String, String>([], [], (a, b) => "$a$b"), isEmpty);
  });

  test("combineIterables | a is longer than b", () {
    // Throws when not allowing different sizes (only after yielding the common part).
    final Iterable<String> combined =
        combineIterables<int, String, String>([1, 2, 3], ["a", "b"], (a, b) => "$a$b");
    final Iterator<String> iterator = combined.iterator;
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, "1a");
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, "2b");
    expect(() => iterator.moveNext(), throwsStateError);

    // Stops at the shorter one when allowing different sizes.
    expect(
        combineIterables<int, String, String>([1, 2, 3], ["a", "b"], (a, b) => "$a$b",
            allowDifferentSizes: true),
        ["1a", "2b"]);

    expect(
        combineIterables<int, String, String>([1, 2, 3], [], (a, b) => "$a$b",
            allowDifferentSizes: true),
        isEmpty);
  });

  test("combineIterables | a is shorter than b", () {
    expect(
        () => combineIterables<int, String, String>([1], ["a", "b"], (a, b) => "$a$b").toList(),
        throwsStateError);

    expect(
        combineIterables<int, String, String>([1], ["a", "b"], (a, b) => "$a$b",
            allowDifferentSizes: true),
        ["1a"]);

    expect(
        combineIterables<int, String, String>([], ["a"], (a, b) => "$a$b",
            allowDifferentSizes: true),
        isEmpty);
  });

  test("combineIterables | is lazy", () {
    int count = 0;
    final Iterable<int> combined = combineIterables<int, int, int>([1, 2, 3], [10, 20, 30], (a, b) {
      count++;
      return a + b;
    });
    expect(count, 0);
    expect(combined.first, 11);
    expect(count, 1);
    expect(combined.toList(), [11, 22, 33]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("asList | Returns the same instance if already a List", () {
    final List<int> list = [1, 2, 3];
    final List<int> result = list.asList();
    expect(identical(result, list), isTrue);

    final List<int> emptyList = [];
    expect(identical(emptyList.asList(), emptyList), isTrue);
  });

  test("asList | Creates a new List if not a List", () {
    final Set<int> set = {1, 2, 3};
    final List<int> result1 = set.asList();
    expect(result1, isA<List<int>>());
    expect(result1, [1, 2, 3]);

    final Iterable<int> iterable = [1, 2, 3].where((e) => e != 2);
    final List<int> result2 = iterable.asList();
    expect(result2, [1, 3]);

    final List<int> result3 = <int>{}.asList();
    expect(result3, isEmpty);

    // The new list is growable (it's created with toList()).
    result1.add(4);
    expect(result1, [1, 2, 3, 4]);
    expect(set, {1, 2, 3});

    // An IList is not a List, so a new list is created.
    final IList<int> ilist = [1, 2].lock;
    expect(ilist.asList(), [1, 2]);
  });

  test("asSet | Returns the same instance if already a Set", () {
    final Set<int> set = {1, 2, 3};
    expect(identical(set.asSet(), set), isTrue);

    final Set<String> emptySet = <String>{};
    expect(identical(emptySet.asSet(), emptySet), isTrue);

    final LinkedHashSet<int> linked = LinkedHashSet.of([3, 1, 2]);
    expect(identical(linked.asSet(), linked), isTrue);
  });

  test("asSet | Creates a new Set if not a Set", () {
    final List<int> list = [1, 2, 2, 3, 1];
    final Set<int> result1 = list.asSet();
    expect(result1, isA<Set<int>>());
    expect(result1, {1, 2, 3});
    expect(result1.toList(), [1, 2, 3]); // Keeps the order of first occurrence.

    expect(<int>[].asSet(), isEmpty);

    // An ISet is not a Set, so a new set is created.
    final ISet<int> iset = {1, 2}.lock;
    final Set<int> result2 = iset.asSet();
    expect(result2, {1, 2});
    result2.add(3);
    expect(iset, {1, 2});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("deepEquals | Same instance is always equal", () {
    final List<int> list = [1, 2, 3];
    expect(list.deepEquals(list), isTrue);
    expect(list.deepEquals(list, ignoreOrder: true), isTrue);

    final Iterable<int> lazy = [1, 2, 3].map((e) => e);
    expect(lazy.deepEquals(lazy), isTrue);

    // Even when the items are not equal to themselves (NaN), the instance is identical.
    final List<double> nanList = [double.nan];
    expect(nanList.deepEquals(nanList), isTrue);
    expect(nanList.deepEquals([double.nan]), isFalse);
  });

  test("deepEquals | null and different lengths", () {
    expect([1, 2].deepEquals(null), isFalse);
    expect([1, 2].deepEquals([1, 2, 3]), isFalse);
    expect({1, 2}.deepEquals({1, 2, 3}), isFalse);
    expect(Queue.of([1, 2]).deepEquals([1, 2]), isTrue);
    expect(Queue.of([1, 2]).deepEquals([1]), isFalse);
    expect([1, 2].lock.deepEquals([1, 2, 3]), isFalse);
    expect([1, 2].lock.deepEquals([1, 2]), isTrue);
    expect([1, 2].map((e) => e).deepEquals([1, 2, 3]), isFalse);
    expect(<int>[].deepEquals(<int>[]), isTrue);
  });

  test("deepEqualsByIdentity | Same instance is always equal", () {
    final List<Object> list = [Object(), Object()];
    expect(list.deepEqualsByIdentity(list), isTrue);
    expect(list.deepEqualsByIdentity(list, ignoreOrder: true), isTrue);

    final Iterable<Object> lazy = list.where((e) => true);
    expect(lazy.deepEqualsByIdentity(lazy), isTrue);
  });

  test("deepEqualsByIdentity | null and different lengths", () {
    final Object a = Object(), b = Object();
    expect([a, b].deepEqualsByIdentity(null), isFalse);
    expect([a, b].deepEqualsByIdentity([a]), isFalse);
    expect({a, b}.deepEqualsByIdentity({a}), isFalse);
    expect(Queue.of([a, b]).deepEqualsByIdentity([a, b]), isTrue);
    expect([a, b].lock.deepEqualsByIdentity([a, b, a]), isFalse);
    expect([a, b].deepEqualsByIdentity([b, a]), isFalse);
    expect([a, b].deepEqualsByIdentity([b, a], ignoreOrder: true), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("sumBy | Empty iterables of int and double return the right zero type", () {
    final int intSum = <String>[].sumBy((e) => e.length);
    expect(intSum, 0);
    expect(intSum, isA<int>());

    final double doubleSum = <String>[].sumBy((e) => e.length.toDouble());
    expect(doubleSum, 0.0);
    expect(doubleSum, isA<double>());
  });

  test("sumBy | Empty iterables of num return 0", () {
    expect(<num>[].sumBy((e) => e), 0);
    expect(<int>[].sumBy<num>((e) => e), 0);
    expect(<String>[].sumBy<num>((e) => e.length), 0);
  });

  test("sumBy | Non-empty iterables", () {
    expect([1].sumBy((e) => e), 1);
    expect([-1, 1].sumBy((e) => e), 0);
    expect([0.5, 0.25].sumBy((e) => e), 0.75);
    expect(<num>[1, 0.5].sumBy((e) => e), 1.5);
    expect(["a", "bb"].sumBy<double>((e) => e.length / 2), 1.5);
  });

  test("averageBy | Edge cases", () {
    expect(<int>[].averageBy((e) => e), 0.0);
    expect([7].averageBy((e) => e), 7.0);
    expect([-1, 1].averageBy((e) => e), 0.0);
    expect([1, 2].averageBy((e) => e), 1.5);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("restrict | Edge cases", () {
    expect(<int>[].restrict(1, orElse: -1), -1);
    expect([1, 2].restrict(null, orElse: -1), -1);
    expect(<int?>[1, null].restrict(null, orElse: 5), isNull);
    expect([1, 2].restrict(2, orElse: -1), 2);
  });

  test("findDuplicates | Edge cases", () {
    expect(<int>[].findDuplicates(), isEmpty);
    expect([1].findDuplicates(), isEmpty);
    expect([1, 1, 1].findDuplicates(), {1});
    expect(<int?>[null, 1, null].findDuplicates(), {null});
  });

  test("everyIs / anyIs | Empty iterable", () {
    expect(<int>[].everyIs(1), isTrue);
    expect(<int>[].anyIs(1), isFalse);
    expect(<int?>[null, null].everyIs(null), isTrue);
    expect(<int?>[1, null].anyIs(null), isTrue);
  });

  test("whereNoDuplicates | removeNulls with and without `by`", () {
    expect(<int?>[null, 1, null, 2, 1].whereNoDuplicates(), [null, 1, 2]);
    expect(<int?>[null, 1, null, 2, 1].whereNoDuplicates(removeNulls: true), [1, 2]);
    expect(
        <String?>[null, "a", "AA", "b", null, "A"]
            .whereNoDuplicates(by: (e) => e?.toLowerCase(), removeNulls: true),
        ["a", "AA", "b"]);
    expect(
        <String?>[null, "a", null, "A"].whereNoDuplicates(by: (e) => e?.toLowerCase()),
        [null, "a"]);
    expect(<int>[].whereNoDuplicates(), isEmpty);
  });

  test("whereNoDuplicates | is lazy", () {
    int count = 0;
    final Iterable<int> source = [1, 1, 2, 3, 4, 5].map((e) {
      count++;
      return e;
    });
    expect(source.whereNoDuplicates().take(2).toList(), [1, 2]);
    expect(count, 3);
  });

  test("sortedReversed | Edge cases", () {
    final List<int> original = [2, 3, 1];
    expect(original.sortedReversed(), [3, 2, 1]);
    expect(original, [2, 3, 1]); // Original is not changed.
    expect(<int>[].sortedReversed(), isEmpty);
    expect(["a", "bbb", "cc"].sortedReversed((a, b) => a.length.compareTo(b.length)),
        ["bbb", "cc", "a"]);
  });

  test("sortedLike | Edge cases", () {
    expect(<int>[].sortedLike([1, 2]), isEmpty);
    expect([3, 1, 2].sortedLike([]), [3, 1, 2]);
    expect([3, 1, 2].sortedLike([2, 3, 1]), [2, 3, 1]);
    expect([5, 3, 1, 2].sortedLike([2, 7, 3]), [2, 3, 5, 1]);
  });

  test("updateById | Edge cases", () {
    expect(<int>[].updateById([1, 2], (e) => e), [1, 2]);
    expect([1, 2].updateById([], (e) => e), [1, 2]);

    // Duplicates in newItems: the last one wins.
    expect(["a1", "b1"].updateById(["a2", "a3"], (e) => e[0]), ["a3", "b1"]);

    // Duplicates in the original: only the first is replaced.
    expect(["a1", "a2", "b1"].updateById(["a9"], (e) => e[0]), ["a9", "a2", "b1"]);
  });

  test("isFirst / isNotFirst / isLast / isNotLast | Empty iterable returns false/true", () {
    final Object item = Object();
    expect(<Object>[].isFirst(item), isFalse);
    expect(<Object>[].isNotFirst(item), isTrue);
    expect(<Object>[].isLast(item), isFalse);
    expect(<Object>[].isNotLast(item), isTrue);

    // Compares by identity, not by equality.
    final List<int> a = [1];
    final List<int> b = [1];
    final List<List<int>> list = [a];
    expect(list.isFirst(a), isTrue);
    expect(list.isLast(a), isTrue);
    expect(list.isFirst(b), isFalse);
    expect(list.isLast(b), isFalse);
    expect(list.isNotFirst(b), isTrue);
    expect(list.isNotLast(b), isTrue);
  });

  test("mapIndexedAndLast | Edge cases", () {
    expect(<int>[].mapIndexedAndLast((i, e, isLast) => "$i$e$isLast"), isEmpty);
    expect([7].mapIndexedAndLast((i, e, isLast) => "$i:$e:$isLast"), ["0:7:true"]);
    expect(
        {"a", "b"}.where((e) => true).mapIndexedAndLast((i, e, isLast) => "$i:$e:$isLast"),
        ["0:a:false", "1:b:true"]);
  });

  test("intersectsWith | Mixed Set, ISet and Iterable", () {
    // Both sets, this is bigger.
    expect({1, 2, 3, 4}.intersectsWith({9, 4}), isTrue);
    expect({1, 2, 3, 4}.intersectsWith({9, 8}), isFalse);
    // Both sets, this is smaller.
    expect({4}.intersectsWith({1, 2, 3, 4}.lock), isTrue);
    expect({5}.intersectsWith({1, 2, 3, 4}.lock), isFalse);
    // Only this is a set.
    expect({1, 2}.lock.intersectsWith([3, 2]), isTrue);
    expect({1, 2}.intersectsWith([3, 4]), isFalse);
    // Only other is a set.
    expect([1, 2].intersectsWith({3, 2}.lock), isTrue);
    expect([1, 2].intersectsWith({3, 4}), isFalse);
    // Neither is a set.
    expect([1, 2].intersectsWith([2]), isTrue);
    expect([1, 2].intersectsWith([]), isFalse);
    expect(<int>[].intersectsWith([1]), isFalse);
  });

  test("mapNotNull | Returns a non-nullable iterable", () {
    final Iterable<int> result = <String?>["a", null, "bbb"].mapNotNull((e) => e?.length ?? 0);
    expect(result, isA<Iterable<int>>());
    expect(result, [1, 0, 3]);
  });

  test("toIList / toISet | With config", () {
    final IList<int> ilist = [1, 2].toIList(ConfigList(isDeepEquals: false));
    expect(ilist, [1, 2]);
    expect(ilist.config.isDeepEquals, isFalse);

    final ISet<int> iset = [2, 1, 2].toISet(ConfigSet(sort: true));
    expect(iset, {1, 2});
    expect(iset.config.sort, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("inRange (nullable extension) | Non-null values are clamped", () {
    // Below min.
    expect(_nullable(-10)!.inRange(5, 10), 5); // Non-nullable extension.
    expect(_nullable<int>(-10).inRange(5, 10, orElse: 0), 5);
    expect(_nullable<int>(4).inRange(5, 10, orElse: 0), 5);

    // Equal to min.
    expect(_nullable<int>(5).inRange(5, 10, orElse: 0), 5);

    // Inside the range.
    expect(_nullable<int>(7).inRange(5, 10, orElse: 0), 7);

    // Equal to max.
    expect(_nullable<int>(10).inRange(5, 10, orElse: 0), 10);

    // Above max.
    expect(_nullable<int>(11).inRange(5, 10, orElse: 0), 10);
    expect(_nullable<int>(1000).inRange(5, 10, orElse: 0), 10);

    // Doubles.
    expect(_nullable<double>(4.9).inRange(5.0, 10.0, orElse: 0.0), 5.0);
    expect(_nullable<double>(7.5).inRange(5.0, 10.0, orElse: 0.0), 7.5);
    expect(_nullable<double>(10.1).inRange(5.0, 10.0, orElse: 0.0), 10.0);
  });

  test("inRange (nullable extension) | Null returns orElse", () {
    expect(_nullable<int>(null).inRange(5, 10, orElse: 7), 7);

    // orElse is returned as is, even if outside the range.
    expect(_nullable<int>(null).inRange(5, 10, orElse: 100), 100);
    expect(_nullable<double>(null).inRange(5.0, 10.0, orElse: -1.0), -1.0);
  });

  test("inRange | Doubles and negatives (non-nullable extension)", () {
    expect((-3.5).inRange(-2.0, 2.0), -2.0);
    expect(3.5.inRange(-2.0, 2.0), 2.0);
    expect(0.5.inRange(-2.0, 2.0), 0.5);
    expect(5.inRange(5, 5), 5);
  });

  test("isInRange / isNotInRange | Bounds", () {
    expect(5.isInRange(5, 10), isTrue);
    expect(10.isInRange(5, 10), isTrue);
    expect(4.999.isInRange(5, 10), isFalse);
    expect(5.isNotInRange(5, 10), isFalse);
    expect(10.001.isNotInRange(5, 10), isTrue);
    // Inverted range: nothing is in range.
    expect(7.isInRange(10, 5), isFalse);
    expect(7.isNotInRange(10, 5), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("areImmutableCollectionsWithEqualItems | Identical", () {
    final IList<int> ilist = [1, 2].lock;
    expect(areImmutableCollectionsWithEqualItems(ilist, ilist), isTrue);
  });

  test("areImmutableCollectionsWithEqualItems | ISet", () {
    final ISet<int> iset1 = {1, 2, 3}.lock;
    final ISet<int> iset2 = {3, 2, 1}.lock;
    final ISet<int> iset3 = ISet([1, 2]).add(3);
    final ISet<int> iset4 = {1, 2, 4}.lock;
    final ISet<int> iset5 = {1, 2}.lock;

    expect(areImmutableCollectionsWithEqualItems(iset1, iset2), isTrue);
    expect(areImmutableCollectionsWithEqualItems(iset1, iset3), isTrue);
    expect(areImmutableCollectionsWithEqualItems(iset1, iset4), isFalse);
    expect(areImmutableCollectionsWithEqualItems(iset1, iset5), isFalse);
    expect(areImmutableCollectionsWithEqualItems(ISet<int>(), ISet<int>()), isTrue);

    // Config is not compared.
    final ISet<int> isetIdentity = ISet.withConfig([1, 2, 3], ConfigSet(isDeepEquals: false));
    expect(areImmutableCollectionsWithEqualItems(iset1, isetIdentity), isTrue);
  });

  test("areImmutableCollectionsWithEqualItems | IMap", () {
    final IMap<String, int> imap1 = {"a": 1, "b": 2}.lock;
    final IMap<String, int> imap2 = {"b": 2, "a": 1}.lock;
    final IMap<String, int> imap3 = IMap({"a": 1}).add("b", 2);
    final IMap<String, int> imap4 = {"a": 1, "b": 3}.lock;
    final IMap<String, int> imap5 = {"a": 1, "c": 2}.lock;
    final IMap<String, int> imap6 = {"a": 1}.lock;

    expect(areImmutableCollectionsWithEqualItems(imap1, imap2), isTrue);
    expect(areImmutableCollectionsWithEqualItems(imap1, imap3), isTrue);
    expect(areImmutableCollectionsWithEqualItems(imap1, imap4), isFalse);
    expect(areImmutableCollectionsWithEqualItems(imap1, imap5), isFalse);
    expect(areImmutableCollectionsWithEqualItems(imap1, imap6), isFalse);
    expect(areImmutableCollectionsWithEqualItems(IMap<String, int>(), IMap<String, int>()), isTrue);
  });

  test("areImmutableCollectionsWithEqualItems | IMapOfSets", () {
    final IMapOfSets<String, int> mos1 = IMapOfSets({
      "a": {1, 2},
      "b": {3},
    });
    final IMapOfSets<String, int> mos2 = IMapOfSets({
      "b": {3},
      "a": {2, 1},
    });
    final IMapOfSets<String, int> mos3 = IMapOfSets({
      "a": {1, 2},
    }).add("b", 3);
    final IMapOfSets<String, int> mos4 = IMapOfSets({
      "a": {1, 2},
      "b": {4},
    });
    final IMapOfSets<String, int> mos5 = IMapOfSets({
      "a": {1, 2},
    });

    expect(areImmutableCollectionsWithEqualItems(mos1, mos2), isTrue);
    expect(areImmutableCollectionsWithEqualItems(mos1, mos3), isTrue);
    expect(areImmutableCollectionsWithEqualItems(mos1, mos4), isFalse);
    expect(areImmutableCollectionsWithEqualItems(mos1, mos5), isFalse);
  });

  test("areImmutableCollectionsWithEqualItems | Different collection types", () {
    final IList<int> ilist = [1, 2].lock;
    final ISet<int> iset = {1, 2}.lock;
    final IMap<int, int> imap = {1: 1}.lock;
    final IMapOfSets<int, int> mos = IMapOfSets({
      1: {1}
    });

    expect(areImmutableCollectionsWithEqualItems(iset, ilist), isFalse);
    expect(areImmutableCollectionsWithEqualItems(iset, imap), isFalse);
    expect(areImmutableCollectionsWithEqualItems(imap, iset), isFalse);
    expect(areImmutableCollectionsWithEqualItems(imap, mos), isFalse);
    expect(areImmutableCollectionsWithEqualItems(mos, imap), isFalse);
    expect(areImmutableCollectionsWithEqualItems(mos, null), isFalse);
    expect(areImmutableCollectionsWithEqualItems(null, iset), isFalse);
  });

  test("areSameImmutableCollection | Identical and same-runtime-type with different internals",
      () {
    final ISet<int> iset = {1}.lock;
    expect(areSameImmutableCollection(iset, iset), isTrue);
    expect(areSameImmutableCollection(iset, {1}.lock), isFalse);
    final IMap<String, int> imap = {"a": 1}.lock;
    expect(areSameImmutableCollection(imap, imap), isTrue);
    expect(areSameImmutableCollection(imap, iset), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ImmutableCollection.disallowUnsafeConstructors | Setting the same value is a no-op", () {
    expect(ImmutableCollection.disallowUnsafeConstructors, isFalse);
    ImmutableCollection.disallowUnsafeConstructors = false;
    expect(ImmutableCollection.disallowUnsafeConstructors, isFalse);

    ImmutableCollection.disallowUnsafeConstructors = true;
    ImmutableCollection.disallowUnsafeConstructors = true;
    expect(ImmutableCollection.disallowUnsafeConstructors, isTrue);

    // Unsafe constructors now throw.
    expect(() => IList.unsafe([1], config: ConfigList()), throwsUnsupportedError);

    ImmutableCollection.disallowUnsafeConstructors = false;
    expect(IList.unsafe([1], config: ConfigList()), [1]);
  });

  test("ImmutableCollection.autoFlush / prettyPrint | Setting the same value is a no-op", () {
    ImmutableCollection.autoFlush = true;
    expect(ImmutableCollection.autoFlush, isTrue);
    ImmutableCollection.prettyPrint = true;
    expect(ImmutableCollection.prettyPrint, isTrue);
  });

  test("ImmutableCollection.resetAllConfigurations | Resets everything", () {
    ImmutableCollection.autoFlush = false;
    ImmutableCollection.prettyPrint = false;
    ImmutableCollection.disallowUnsafeConstructors = true;
    IList.flushFactor = 7;
    ISet.flushFactor = 8;
    IMap.flushFactor = 9;

    ImmutableCollection.resetAllConfigurations();

    expect(ImmutableCollection.autoFlush, isTrue);
    expect(ImmutableCollection.prettyPrint, isTrue);
    expect(ImmutableCollection.disallowUnsafeConstructors, isFalse);
    expect(IList.flushFactor, 500);
    expect(ISet.flushFactor, 50);
    expect(IMap.flushFactor, 50);
    expect(ImmutableCollection.isConfigLocked, isFalse);

    // Note: `defaultConfig`s are NOT tested here, since `resetAllConfigurations`
    // currently doesn't reset them (see IList/ISet/IMap.resetAllConfigurations).
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ConfigList.copyWith | Only cacheHashCode, and no arguments", () {
    final ConfigList config = ConfigList(isDeepEquals: false, cacheHashCode: true);

    final ConfigList copy1 = config.copyWith(cacheHashCode: false);
    expect(copy1.isDeepEquals, isFalse);
    expect(copy1.cacheHashCode, isFalse);
    expect(copy1, isNot(config));

    // No change returns the same instance.
    expect(identical(config.copyWith(), config), isTrue);
    expect(identical(config.copyWith(isDeepEquals: false, cacheHashCode: true), config), isTrue);
  });

  test("ConfigList | hashCode and toString", () {
    expect(ConfigList().hashCode, ConfigList().hashCode);
    expect(ConfigList(isDeepEquals: false).hashCode, isNot(ConfigList().hashCode));
    expect(ConfigList(isDeepEquals: false, cacheHashCode: true).toString(),
        "ConfigList{isDeepEquals: false, cacheHashCode: true}");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("MapEntryEquality.hash | MapEntry is hashed by key and value", () {
    const MapEntryEquality<dynamic> eq = MapEntryEquality();
    final MapEntry<String, int> entry1 = MapEntry("a", 1);
    final MapEntry<String, int> entry2 = MapEntry("a", 1);
    final MapEntry<String, int> entry3 = MapEntry("a", 2);

    // Different MapEntry instances (with different native hashCodes) hash the same.
    expect(eq.hash(entry1), eq.hash(entry2));
    expect(eq.hash(entry1), hashObj2("a", 1));
    expect(eq.hash(entry1), isNot(eq.hash(entry3)));
    expect(eq.equals(entry1, entry2), isTrue);
    expect(eq.equals(entry1, entry3), isFalse);

    // Null key/value.
    expect(eq.hash(MapEntry<String?, int?>(null, null)), hashObj2(null, null));

    // Non-MapEntry objects use their regular hashCode.
    expect(eq.hash(null), null.hashCode);
    expect(eq.equals(null, null), isTrue);
    expect(eq.equals(entry1, "a"), isFalse);
  });

  test("MapEntryEquality.isValidKey | Always true", () {
    const MapEntryEquality<dynamic> eq = MapEntryEquality();
    expect(eq.isValidKey(null), isTrue);
    expect(eq.isValidKey(1), isTrue);
    expect(eq.isValidKey(MapEntry(1, 2)), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("unzip | Regular usage", () {
    final List<(int, String)> records = [(1, "a"), (2, "b"), (3, "c")];
    final (Iterable<int>, Iterable<String>) unzipped = records.unzip();
    expect(unzipped.$1, [1, 2, 3]);
    expect(unzipped.$2, ["a", "b", "c"]);
  });

  test("unzip | Empty and single", () {
    final (Iterable<int>, Iterable<String>) empty = <(int, String)>[].unzip();
    expect(empty.$1, isEmpty);
    expect(empty.$2, isEmpty);

    final (Iterable<int?>, Iterable<String?>) single = <(int?, String?)>[(null, null)].unzip();
    expect(single.$1, [null]);
    expect(single.$2, [null]);
  });

  test("unzip | Zipping and unzipping are inverses", () {
    final IList<String> keys = ["a", "b"].lock;
    final IList<int> values = [1, 2].lock;
    final (Iterable<String>, Iterable<int>) unzipped = keys.zip(values).unzip();
    expect(unzipped.$1.toIList(), keys);
    expect(unzipped.$2.toIList(), values);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("CacheKey.computeFrom | Calls the compute function every time", () {
    int count = 0;
    final CacheKey<List<int>, int> key = CacheKey((list) {
      count++;
      return list.fold(0, (a, b) => a + b);
    });

    expect(key.computeFrom([1, 2, 3]), 6);
    expect(key.computeFrom([]), 0);
    expect(count, 2);
  });

  test("CacheKey | const keys are canonicalized", () {
    const CacheKey<IList<int>, int> key1 = CacheKey<IList<int>, int>(_length);
    const CacheKey<IList<int>, int> key2 = CacheKey<IList<int>, int>(_length);
    expect(identical(key1, key2), isTrue);
    expect(key1.computeFrom([1, 2].lock), 2);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("compareObject | Enums are compared by name, not by index", () {
    // By index: red(0) < green(1) < blue(2). By name: blue < green < red.
    expect(compareObject(_Color.red, _Color.green), greaterThan(0));
    expect(compareObject(_Color.blue, _Color.green), lessThan(0));
    expect(compareObject(_Color.red, _Color.red), 0);
    expect([_Color.red, _Color.green, _Color.blue]..sort(compareObject),
        [_Color.blue, _Color.green, _Color.red]);
  });

  test("compareObject | Unordered cases return 0", () {
    // Different enum types.
    expect(compareObject(_Color.red, _Size.small), 0);
    expect(compareObject(_Size.large, _Color.blue), 0);

    // Non-comparable objects.
    expect(compareObject(_NotComparable(1), _NotComparable(2)), 0);

    // Different, non-comparable types.
    expect(compareObject(true, 1), 0);
    expect(compareObject(MapEntry(1, 1), 1), 0);

    // Both null.
    expect(compareObject(null, null), 0);
    expect(compareObject(null, null, nullsBefore: true), 0);
  });

  test("compareObject | MapEntry with non-comparable values", () {
    expect(compareObject(MapEntry("a", _NotComparable(1)), MapEntry("a", _NotComparable(2))), 0);
    expect(compareObject(MapEntry("a", _NotComparable(1)), MapEntry("b", _NotComparable(2))),
        lessThan(0));
    expect(compareObject(MapEntry("a", true), MapEntry("a", false)), greaterThan(0));
  });

  test("compareObjectTo | Booleans and map entries", () {
    expect(true.compareObjectTo(false), 1);
    expect(false.compareObjectTo(true), -1);
    expect(true.compareObjectTo(true), 0);
    expect(MapEntry("a", 5).compareObjectTo(MapEntry("b", 3)), lessThan(0));
    expect(_NotComparable(1).compareObjectTo(_NotComparable(2)), 0);
  });

  test("sortBy | Without `then`, items satisfying the test come first, ties keep order", () {
    final int Function(int, int) comparator = sortBy((int x) => x.isEven);
    expect(comparator(2, 3), -1);
    expect(comparator(3, 2), 1);
    expect(comparator(2, 4), 0);
    expect(comparator(3, 5), 0);

    // List.sort is not stable, so only check which items end up in each half.
    final List<int> sorted = [1, 2, 3, 4]..sort(comparator);
    expect(sorted.take(2).toSet(), {2, 4});
    expect(sorted.skip(2).toSet(), {1, 3});
  });

  test("sortLike | Ties, non-List order, and items not in order", () {
    // Equal items return 0.
    expect(sortLike<int, int>([1, 2])(1, 1), 0);

    // Order given as a Set (neither List nor IList) is converted to a list.
    final int Function(int, int) bySet = sortLike<int, int>({3, 1, 2});
    expect([1, 2, 3]..sort(bySet), [3, 1, 2]);

    // Order given as an IList.
    final int Function(int, int) byIList = sortLike<int, int>([3, 1, 2].lock);
    expect([1, 2, 3]..sort(byIList), [3, 1, 2]);

    // Items not in order, without `then`, are unordered (0).
    expect(sortLike<int, int>([1, 2])(1, 5), 0);
    expect(sortLike<int, int>([1, 2])(5, 6), 0);

    // Items not in order, with `then`.
    final int Function(int, int) withThen =
        sortLike<int, int>([9], then: (int a, int b) => a.compareTo(b));
    expect(withThen(5, 6), lessThan(0));
    expect(withThen(9, 6), greaterThan(0)); // Only one is present: uses `then`.
  });

  test("if0 | Chained", () {
    expect(0.if0(0).if0(5), 5);
    expect(0.if0(-3).if0(5), -3);
    expect(2.if0(-3), 2);
  });

  test("compareObject | nullsBefore is used for MapEntry keys and values", () {
    // Keys.
    expect(compareObject(MapEntry(null, 1), MapEntry("a", 1)), 1);
    expect(compareObject(MapEntry(null, 1), MapEntry("a", 1), nullsBefore: true), -1);
    expect(compareObject(MapEntry("a", 1), MapEntry(null, 1), nullsBefore: true), 1);

    // Values (same keys).
    expect(compareObject(MapEntry("a", null), MapEntry("a", 1)), 1);
    expect(compareObject(MapEntry("a", null), MapEntry("a", 1), nullsBefore: true), -1);

    // Sorting.
    final List<MapEntry<String?, int>> entries = [MapEntry("b", 1), MapEntry(null, 2), MapEntry("a", 3)];
    expect((entries.toList()..sort(compareObject)).map((e) => e.key), ["a", "b", null]);
    expect(
        (entries.toList()..sort((a, b) => compareObject(a, b, nullsBefore: true)))
            .map((e) => e.key),
        [null, "a", "b"]);
  });

  test("resetAllConfigurations | Restores the default configs", () {
    IList.defaultConfig = ConfigList(isDeepEquals: false, cacheHashCode: false);
    ISet.defaultConfig = ConfigSet(isDeepEquals: false, sort: true);
    IMap.defaultConfig = ConfigMap(isDeepEquals: false, sort: true);
    IMapOfSets.defaultConfig = ConfigMapOfSets(removeEmptySets: false);

    ImmutableCollection.resetAllConfigurations();

    expect(IList.defaultConfig, const ConfigList());
    expect(ISet.defaultConfig, const ConfigSet());
    expect(IMap.defaultConfig, const ConfigMap());
    expect(IMapOfSets.defaultConfig, const ConfigMapOfSets());

    expect([1].lock.config, const ConfigList());
    expect({1}.lock.config, const ConfigSet());
    expect({"a": 1}.lock.config, const ConfigMap());
  });
}

int _length(IList<int> list) => list.length;
