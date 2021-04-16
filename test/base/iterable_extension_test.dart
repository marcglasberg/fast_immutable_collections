import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:collection/collection.dart";
import "package:test/test.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = true;
    ImmutableCollection.prettyPrint = true;
  });

  //////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////

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

  /////////////////////////////////////////////////////////////////////////////

  test("deepEquals", () {
    // *) If both are null, then true
    Iterable? iterable1;
    Iterable? iterable2;
    expect(iterable1?.deepEquals(iterable2), isNull);

    // 1) Identical
    List<int> listA = [1, 2, 3];
    List<int> listB = listA;

    expect(listA.deepEquals(listB), isTrue);

    // 2) If one of them is not null, then false
    expect([].deepEquals(null), isFalse);

    // 3) Different lengths
    List<int> list1 = [1, 2], list2 = [1, 2, 3];
    Set<int> set1 = {1, 2}, set2 = {1, 2, 3};
    IList<int> ilist1 = [1, 2].lock, ilist2 = [1, 2, 3].lock;

    expect(list1.deepEquals(list2), isFalse);
    expect(set1.deepEquals(set2), isFalse);
    expect(ilist1.deepEquals(ilist2), isFalse);

    // 4) Checking for equality

    // 4.1) Ordered Equality
    expect([1, 2].deepEquals([1, 2]), isTrue);
    expect([1, 2].deepEquals([2, 1]), isFalse);

    expect({1, 2}.deepEquals({1, 2}), isTrue);
    expect({1, 2}.deepEquals({2, 1}), isFalse);

    expect([1, 2].lock.deepEquals([1, 2].lock), isTrue);
    expect([1, 2].lock.deepEquals([2, 1].lock), isFalse);

    // 4.2) Unordered Equality
    expect([1, 2].deepEquals([1, 2], ignoreOrder: true), isTrue);
    expect([1, 2].deepEquals([2, 1], ignoreOrder: true), isTrue);

    expect({1, 2}.deepEquals({1, 2}, ignoreOrder: true), isTrue);
    expect({1, 2}.deepEquals({2, 1}, ignoreOrder: true), isTrue);

    expect([1, 2].lock.deepEquals([1, 2].lock, ignoreOrder: true), isTrue);
    expect([1, 2].lock.deepEquals([2, 1].lock, ignoreOrder: true), isTrue);
  });

  // /////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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
  // /////////////////////////////////////////////////////////////////////////////

  test("findDuplicates", () {
    expect(["A", "B", "C", "D", "C", "A", "E"].findDuplicates(), {"C", "A"});
    expect(["A", "B", "C", "D", "C", "A", "E"].findDuplicates(), ["C", "A"]);
    expect(["A", "B", "C", "E"].findDuplicates(), <String>{});
    expect(["A", "B", "C", "E"].findDuplicates(), <String>[]);
    expect(["A", "B", "B", "B"].findDuplicates(), {"B"});
    expect(["A", "B", "B", "B"].findDuplicates(), ["B"]);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("everyIs", () {
    List<int> list1 = [1, 1, 1];
    List<int> list2 = [1, 1, 2];

    expect(list1.everyIs(1), isTrue);
    expect(list1.everyIs(2), isFalse);
    expect(list2.everyIs(1), isFalse);
    expect(list2.everyIs(2), isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("anyIs", () {
    List<int> list1 = [1, 1, 1];
    List<int> list2 = [1, 1, 2];

    expect(list1.anyIs(1), isTrue);
    expect(list1.anyIs(2), isFalse);
    expect(list2.anyIs(1), isTrue);
    expect(list2.anyIs(2), isTrue);
    expect(list2.anyIs(3), isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////
}

// /////////////////////////////////////////////////////////////////////////////

class _ClassEqualsByValue {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _ClassEqualsByValue && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

//////////////////////////////////////////////////////////////////////////////

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

// /////////////////////////////////////////////////////////////////////////////
