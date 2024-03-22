// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = true;
    ImmutableCollection.prettyPrint = true;
  });

  test('mapNotNull', () {
    //
    int? f(String? e) => (e == null) ? 0 : e.length;

    Iterable<int?> list1 = ["xxx", "xx", null, "x"].map(f).toList();
    expect(list1, isA<Iterable<int?>>());
    expect(list1, isNot(isA<Iterable<int>>()));

    Iterable<int?> list2 = ["xxx", "xx", null, "x"].mapNotNull(f).toList();
    expect(list2, isA<Iterable<int>>());
    expect(list1, isA<Iterable<int?>>());
  });

  test('sumBy', () {
    expect([1, 2, 3, 4, 5].sumBy((e) => e), 15);
    expect([1.5, 2.5, 3.3, 4, 5].sumBy((e) => e), 16.3);
    expect([1.5, 2.5, 3.3, 4.2, 5.9].sumBy((e) => e), 17.4);
    expect([].sumBy((e) => (e is int) ? e : 0), 0);
    expect([''].sumBy((e) => e.length), 0);
    expect(['a'].sumBy((e) => e.length), 1);
    expect(['a', 'ab', 'abc', 'abcd', 'abcde'].sumBy((e) => e.length), 15);
    expect(['a', 'ab', 'abc', 'abcd', 'abcde'].map((e) => e.length).sum, 15);
    expect(<double>[].sumBy((e) => e), 0.0);
    expect(<int>[].sumBy((e) => e), 0);
  });

  test('averageBy', () {
    expect([1, 2, 3, 4, 5].averageBy((e) => e), 3.0);
    expect([1.5, 2.5, 3.3, 4, 5].averageBy((e) => e), 3.26);
    expect([].averageBy((e) => (e is int) ? e : 0), 0);
    expect([''].averageBy((e) => e.length), 0);
    expect(['a'].averageBy((e) => e.length), 1);
    expect(['a', 'ab', 'abc', 'abcd', 'abcd'].averageBy((e) => e.length), 2.8);
    expect(['a', 'ab', 'abc', 'abcd', 'abcde'].averageBy((e) => e.length), 3.0);
  });

  test('whereNotNull (removed this, now using it from collection package)', () {
    //
    List<String?> list1 = ["xxx", "xx", null, "x"];
    expect(list1, isA<List<String?>>());

    List<String?> list2 = list1.where((x) => x != null).toList();
    expect(list2, isA<List<String?>>());
    expect(list2, isNot(isA<List<String>>()));
    expect(list2, ["xxx", "xx", "x"]);

    List<String> list3 = list1.whereNotNull().toList();
    expect(list3, isA<List<String>>());
    expect(list3, ["xxx", "xx", "x"]);
  });

  test("deepEquals", () {
    //
    // 1) Equal
    final listA = [a(1), a(2), a(3)];
    final listB = [a(1), a(2), a(3)];

    expect(listA.deepEquals(listB), isTrue);

    // 2) If one of them is not null, then false
    expect([].deepEquals(null), isFalse);

    // 3) Different lengths
    final list1 = [a(1), a(2)], list2 = [a(1), a(2), a(3)];
    final set1 = {1, 2}, set2 = {1, 2, 3};
    final ilist1 = [a(1), a(2)].lock, ilist2 = [a(1), a(2), a(3)].lock;

    expect(list1.deepEquals(list2), isFalse);
    expect(set1.deepEquals(set2), isFalse);
    expect(ilist1.deepEquals(ilist2), isFalse);

    // 4) Checking for equality

    // 4.1) Ordered Equality
    expect([a(1), a(2)].deepEquals([a(1), a(2)]), isTrue);
    expect([a(1), a(2)].deepEquals([a(2), a(1)]), isFalse);

    expect({a(1), a(2)}.deepEquals({a(1), a(2)}), isTrue);
    expect({a(1), a(2)}.deepEquals({a(2), a(1)}), isFalse);

    expect([a(1), a(2)].lock.deepEquals([a(1), a(2)].lock), isTrue);
    expect([a(1), a(2)].lock.deepEquals([a(2), a(1)].lock), isFalse);

    // 4.2) Unordered Equality
    expect([a(1), a(2)].deepEquals([a(1), a(2)], ignoreOrder: true), isTrue);
    expect([a(1), a(2)].deepEquals([a(2), a(1)], ignoreOrder: true), isTrue);

    expect({a(1), a(2)}.deepEquals({a(1), a(2)}, ignoreOrder: true), isTrue);
    expect({a(1), a(2)}.deepEquals({a(2), a(1)}, ignoreOrder: true), isTrue);

    expect([a(1), a(2)].lock.deepEquals([a(1), a(2)].lock, ignoreOrder: true), isTrue);
    expect([a(1), a(2)].lock.deepEquals([a(2), a(1)].lock, ignoreOrder: true), isTrue);
  });

  test("deepEqualsByIdentity", () {
    // List
    expect([].deepEqualsByIdentity(null), isFalse);
    expect([].deepEqualsByIdentity([]), isTrue);
    expect([1].deepEqualsByIdentity([1]), isTrue);
    expect([1].deepEqualsByIdentity([2]), isFalse);
    expect([1, 2].deepEqualsByIdentity([1, 2]), isTrue);
    expect([1, 2].deepEqualsByIdentity([3, 4]), isFalse);
    expect([1, 2].deepEqualsByIdentity([1, 3]), isFalse);
    expect([1, 2].deepEqualsByIdentity([1, 2, 2]), isFalse);

    // Set
    expect(<int>{}.deepEqualsByIdentity(null), isFalse);
    expect(<int>{}.deepEqualsByIdentity(<int>{}), isTrue);
    expect({1}.deepEqualsByIdentity({1}), isTrue);
    expect({1}.deepEqualsByIdentity({2}), isFalse);
    expect({1, 2}.deepEqualsByIdentity({1, 2}), isTrue);
    expect({1, 2}.deepEqualsByIdentity({2, 1}), isFalse);
    expect({1, 2}.deepEqualsByIdentity({3, 4}), isFalse);
    expect({1, 2}.deepEqualsByIdentity({1, 3}), isFalse);

    // ImmutableCollection (IList)
    expect([].lock.deepEqualsByIdentity(null), isFalse);
    expect([].lock.deepEqualsByIdentity([].lock), isTrue);
    expect([1].lock.deepEqualsByIdentity([1].lock), isTrue);
    expect([1].lock.deepEqualsByIdentity([2].lock), isFalse);
    expect([1, 2].lock.deepEqualsByIdentity([1, 2].lock), isTrue);
    expect([1, 2].lock.deepEqualsByIdentity([3, 4].lock), isFalse);
    expect([1, 2].lock.deepEqualsByIdentity([1, 3].lock), isFalse);
    expect([1, 2].lock.deepEqualsByIdentity([1, 2, 2].lock), isFalse);

    // Unordered Equality
    expect([1, 2].deepEqualsByIdentity([2, 1], ignoreOrder: true), isTrue);
    expect({1, 2}.deepEqualsByIdentity({2, 1}, ignoreOrder: true), isTrue);
    expect([1, 2].lock.deepEqualsByIdentity([2, 1].lock, ignoreOrder: true), isTrue);

    // Now with objects that are equal by value:
    var obj1 = _ClassEqualsByValue();
    expect(obj1 == obj1, isTrue);
    expect([obj1].deepEqualsByIdentity([obj1]), isTrue);
    expect([obj1].deepEqualsByIdentity([_ClassEqualsByValue()]), isFalse);

    var obj2 = _ClassEqualsByValue();
    expect(obj1 == obj2, isTrue);
    expect([obj1].deepEqualsByIdentity([obj2]), isFalse);
    expect([obj1, obj2].deepEqualsByIdentity([obj1, obj2]), isTrue);

    // Comparing to non-list objects
    expect([].deepEqualsByIdentity({}), isTrue);
    expect([1].deepEqualsByIdentity({1}), isTrue);
    expect([1].deepEqualsByIdentity({2}), isFalse);
    expect([1, 2].deepEqualsByIdentity({1, 2}), isTrue);
    expect([1, 2].deepEqualsByIdentity({3, 4}), isFalse);
    expect([1, 2].deepEqualsByIdentity({1, 3}), isFalse);
    expect([1, 2].deepEqualsByIdentity([1, 2, 2].iterator.toIterable()), isFalse);
  });

  test("whereNoDuplicates", () {
    expect(([].whereNoDuplicates()), []);
    expect(([5, 5, 5].whereNoDuplicates()), [5]);
    expect(([1, 2, 3, 4].whereNoDuplicates()), [1, 2, 3, 4]);
    expect(([1, 2, 3, 4, 3, 5, 3].whereNoDuplicates()), [1, 2, 3, 4, 5]);
    expect(([1, 2, 3, 4, 3, 5, 1].whereNoDuplicates()), [1, 2, 3, 4, 5]);
    expect((["abc", "abc", "def"].whereNoDuplicates()), ["abc", "def"]);
    expect((["abc", "abc", "def"].whereNoDuplicates()).take(1), ["abc"]);

    expect((["a", "b", "abc", "ab", "def"].whereNoDuplicates(by: (item) => item.length)),
        ["a", "abc", "ab"]);

    expect(
        (["a", "b", "abc", "ab", "def"]
            .whereNoDuplicates(by: (item) => item.length, removeNulls: true)),
        ["a", "abc", "ab"]);

    expect(([null, 1, 2, 3, null, 4, 3, 5, 1, null].whereNoDuplicates(removeNulls: true)),
        [1, 2, 3, 4, 5]);

    expect(
        ([null, "a", "b", null, "abc", "ab", "def", null]
            .whereNoDuplicates(by: ((item) => item?.length), removeNulls: true)),
        ["a", "abc", "ab"]);
  });

  test("sortedLike", () {
    expect([1, 2, 3].sortedLike([1, 2, 3]), [1, 2, 3]);
    expect([1, 2, 3].sortedLike(<int>[]), [1, 2, 3]);
    expect(<int>[].sortedLike([1, 2, 3]), isEmpty);
    expect([2, 3].sortedLike([1, 2]), [2, 3]);
    expect([3, 4, 5, 6, 7].sortedLike([5, 4, 3, 2, 1]), [5, 4, 3, 6, 7]);
    expect([3, 4, 5, 7, 6].sortedLike([5, 4, 3, 2, 1]), [5, 4, 3, 7, 6]);
    expect([7, 3, 4, 6].sortedLike([5, 4, 3, 2, 1]), [4, 3, 7, 6]);
    expect([2, 3, 1].sortedLike([1, 2, 2, 1]), [1, 2, 3]);
    expect([3, 2].sortedLike([3, 1, 2, 3, 2, 1]), [3, 2]);
    expect([3, 2].sortedLike([1, 5, 2]), [2, 3]);
    expect([3, 2].sortedLike([10, 50, 20]), [3, 2]);
    expect([3, 2].sortedLike([1, 2, 3, 2, 1]), [2, 3]);
  });

  test("sortedReversed", () {
    expect([1, 2, 3].sortedReversed(), [3, 2, 1]);
    expect([3, 2, 1].sortedReversed(), [3, 2, 1]);
    expect([1, 3, 2].sortedReversed(), [3, 2, 1]);
  });

  test("updateById", () {
    //
    List<WithId> list = [];
    var newItems = [WithId(id: "x", name: "Lyn")];
    var updatedList = list.updateById(newItems, (WithId obj) => obj.id);
    expect(updatedList, [WithId(id: "x", name: "Lyn")]);

    //
    list = [WithId(id: "x", name: "Lyn")];
    newItems = [];
    updatedList = list.updateById(newItems, (WithId obj) => obj.id);
    expect(updatedList, [WithId(id: "x", name: "Lyn")]);

    //
    list = [WithId(id: "x", name: "Marc")];
    newItems = [WithId(id: "x", name: "Lyn")];
    updatedList = list.updateById(newItems, (WithId obj) => obj.id);
    expect(updatedList, [WithId(id: "x", name: "Lyn")]);

    //
    list = [WithId(id: "x", name: "Marc")];
    newItems = [WithId(id: "a", name: "Lyn")];
    updatedList = list.updateById(newItems, (WithId obj) => obj.id);
    expect(updatedList, [
      WithId(id: "x", name: "Marc"),
      WithId(id: "a", name: "Lyn"),
    ]);

    //
    // Replace the first, keep the second.
    list = [
      WithId(id: "x", name: "Marc"),
      WithId(id: "x", name: "John"),
    ];
    newItems = [WithId(id: "x", name: "Lyn")];
    updatedList = list.updateById(newItems, (WithId obj) => obj.id);
    expect(updatedList, [
      WithId(id: "x", name: "Lyn"),
      WithId(id: "x", name: "John"),
    ]);

    //
    // Nulls are kept.
    List<WithId?> listNullable = [];
    List<WithId?> updatedListNullable = [];
    listNullable = [WithId(id: "x", name: "Marc"), null, WithId(id: "x", name: "Marc")];
    newItems = [];
    updatedListNullable = listNullable.updateById(newItems, (WithId? obj) => obj?.id);
    expect(updatedListNullable, [
      WithId(id: "x", name: "Marc"),
      null,
      WithId(id: "x", name: "Marc"),
    ]);

    //
    list = [WithId(id: "x", name: "Marc")];
    newItems = [
      WithId(id: "a", name: "Lyn"),
      WithId(id: "a", name: "Beth"),
    ];
    updatedList = list.updateById(newItems, (WithId obj) => obj.id);
    expect(updatedList, [
      WithId(id: "x", name: "Marc"),
      WithId(id: "a", name: "Beth"),
    ]);

    //
    list = [WithId(id: "a", name: "Marc")];
    newItems = [
      WithId(id: "a", name: "Lyn"),
      WithId(id: "a", name: "Lyn"),
    ];
    updatedList = list.updateById(newItems, (WithId obj) => obj.id);
    expect(updatedList, [
      WithId(id: "a", name: "Lyn"),
    ]);

    //
    listNullable = [null, WithId(id: "x", name: "Marc")];
    List<WithId?> newItemsNullable = [null, WithId(id: "a", name: "Lyn"), null];
    updatedListNullable = listNullable.updateById(newItemsNullable, (WithId? obj) => obj?.id);
    expect(updatedListNullable, [
      null,
      WithId(id: "x", name: "Marc"),
      WithId(id: "a", name: "Lyn"),
    ]);

    //
    listNullable = [WithId(id: "x", name: "Marc")];
    newItemsNullable = [null, WithId(id: "a", name: "Lyn"), null];
    updatedListNullable = listNullable.updateById(newItemsNullable, (WithId? obj) => obj?.id);
    expect(updatedListNullable, [
      WithId(id: "x", name: "Marc"),
      null,
      WithId(id: "a", name: "Lyn"),
    ]);

    //
    list = [
      WithId(id: "x", name: "Marc"),
      WithId(id: "y", name: "Bill"),
      WithId(id: "z", name: "Luke"),
      WithId(id: "k", name: "July"),
      WithId(id: "l", name: "Samy"),
      WithId(id: "m", name: "Jane"),
      WithId(id: "n", name: "Zack"),
    ];

    newItems = [
      WithId(id: "x", name: "Lyn"),
      WithId(id: "a", name: "Richard"),
      WithId(id: "l", name: "Lea"),
      WithId(id: "n", name: "Amy"),
    ];

    updatedList = list.updateById(newItems, (WithId obj) => obj.id);

    expect(updatedList, [
      WithId(id: "x", name: "Lyn"),
      WithId(id: "y", name: "Bill"),
      WithId(id: "z", name: "Luke"),
      WithId(id: "k", name: "July"),
      WithId(id: "l", name: "Lea"),
      WithId(id: "m", name: "Jane"),
      WithId(id: "n", name: "Amy"),
      WithId(id: "a", name: "Richard"),
    ]);
  });

  test("isFirst", () {
    //
    var a = Object();
    var b = Object();
    var c = Object();

    List<Object> list = [a, b, c];

    expect(list.isFirst(a), isTrue);
    expect(list.isFirst(b), isFalse);
    expect(list.isFirst(c), isFalse);

    expect(list.isNotFirst(a), isFalse);
    expect(list.isNotFirst(b), isTrue);
    expect(list.isNotFirst(c), isTrue);

    expect(list.isLast(a), isFalse);
    expect(list.isLast(b), isFalse);
    expect(list.isLast(c), isTrue);

    expect(list.isNotLast(a), isTrue);
    expect(list.isNotLast(b), isTrue);
    expect(list.isNotLast(c), isFalse);
  });

  test("restrict", () {
    var primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31];
    expect(primes.restrict(14, orElse: -1), -1);
    expect(primes.restrict(7, orElse: -1), 7);
    expect(primes.restrict(2, orElse: -1), 2);
    expect(primes.restrict(31, orElse: -1), 31);
    expect(primes.restrict(null, orElse: -1), -1);

    var primesWithNull = [2, 3, null, 5, 7, 11, 13, 17, 19, 23, 29, 31];
    expect(primesWithNull.restrict(null, orElse: -1), null);
    expect(primesWithNull.restrict(2, orElse: -1), 2);
    expect(primesWithNull.restrict(100, orElse: -1), -1);
  });

  test("findDuplicates", () {
    expect(["A", "B", "C", "D", "C", "A", "E"].findDuplicates(), {"C", "A"});
    expect(["A", "B", "C", "D", "C", "A", "E"].findDuplicates(), ["C", "A"]);
    expect(["A", "B", "C", "E"].findDuplicates(), <String>{});
    expect(["A", "B", "C", "E"].findDuplicates(), <String>[]);
    expect(["A", "B", "B", "B"].findDuplicates(), {"B"});
    expect(["A", "B", "B", "B"].findDuplicates(), ["B"]);
  });

  test("everyIs", () {
    List<int> list1 = [1, 1, 1];
    List<int> list2 = [1, 1, 2];

    expect(list1.everyIs(1), isTrue);
    expect(list1.everyIs(2), isFalse);
    expect(list2.everyIs(1), isFalse);
    expect(list2.everyIs(2), isFalse);
  });

  test("anyIs", () {
    List<int> list1 = [1, 1, 1];
    List<int> list2 = [1, 1, 2];

    expect(list1.anyIs(1), isTrue);
    expect(list1.anyIs(2), isFalse);
    expect(list2.anyIs(1), isTrue);
    expect(list2.anyIs(2), isTrue);
    expect(list2.anyIs(3), isFalse);
  });

  test("mapIndexedAndLast", () {
    List<String> list = ["a", "b", "c"];

    expect(
        list
            .mapIndexedAndLast(
              (int index, String item, bool isLast) => "$index $isLast $item",
            )
            .toList(),
        [
          '0 false a',
          '1 false b',
          '2 true c',
        ]);
  });

  test("intersectsWith", () {
    //

    // 1) None of them are Sets/iSets.
    Iterable<String> iter1 = ["a", "b", "c", "d"];
    Iterable<String> iter2 = ["x", "c", "y"];
    Iterable<String> iter3 = ["x", "y", "z"];

    expect(iter1.intersectsWith(iter2), isTrue);
    expect(iter2.intersectsWith(iter1), isTrue);

    expect(iter1.intersectsWith(iter3), isFalse);
    expect(iter3.intersectsWith(iter1), isFalse);

    // ---

    // 2) All of them are Sets.
    iter1 = {"a", "b", "c", "d"};
    iter2 = {"x", "c", "y"};
    iter3 = {"x", "y", "z"};

    expect(iter1.intersectsWith(iter2), isTrue);
    expect(iter2.intersectsWith(iter1), isTrue);

    expect(iter1.intersectsWith(iter3), isFalse);
    expect(iter3.intersectsWith(iter1), isFalse);

    // ---

    // 3) All of them are ISets.
    iter1 = {"a", "b", "c", "d"}.lock;
    iter2 = {"x", "c", "y"}.lock;
    iter3 = {"x", "y", "z"}.lock;

    expect(iter1.intersectsWith(iter2), isTrue);
    expect(iter2.intersectsWith(iter1), isTrue);

    expect(iter1.intersectsWith(iter3), isFalse);
    expect(iter3.intersectsWith(iter1), isFalse);

    // ---

    // 4) One of them is a Set.
    iter1 = {"a", "b", "c", "d"};
    iter2 = ["x", "c", "y"];
    iter3 = ["x", "y", "z"];

    expect(iter1.intersectsWith(iter2), isTrue);
    expect(iter2.intersectsWith(iter1), isTrue);

    expect(iter1.intersectsWith(iter3), isFalse);
    expect(iter3.intersectsWith(iter1), isFalse);

    // ---

    // 5) One of them is an ISet.
    iter1 = {"a", "b", "c", "d"}.lock;
    iter2 = ["x", "c", "y"];
    iter3 = ["x", "y", "z"];

    expect(iter1.intersectsWith(iter2), isTrue);
    expect(iter2.intersectsWith(iter1), isTrue);

    expect(iter1.intersectsWith(iter3), isFalse);
    expect(iter3.intersectsWith(iter1), isFalse);
  });
}

class _ClassEqualsByValue {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _ClassEqualsByValue && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class WithId {
  String id;
  String name;

  WithId({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithId && runtimeType == other.runtimeType && id == other.id && name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => "WithId{$id, $name}";
}

/// Shortcut
Wrapper a(Comparable a) => Wrapper(a);

/// The simple wrapper.
///
/// Allows wrap built-in types which can be equal with different references
class Wrapper implements Comparable<Wrapper> {
  final Comparable value;

  const Wrapper(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is Wrapper && value == other.value;

  @override
  int compareTo(Wrapper other) => value.compareTo(other.value);
}
