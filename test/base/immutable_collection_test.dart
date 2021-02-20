import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = true;
    ImmutableCollection.prettyPrint = true;
  });

  /////////////////////////////////////////////////////////////////////////////

  test("areSameImmutableCollection()", () {
    // 1) If both are null, then true
    expect(areSameImmutableCollection(null, null), isTrue);

    // 2) If one of them is not null, then false
    expect(areSameImmutableCollection(IList(), null), isFalse);
    expect(areSameImmutableCollection(null, IList()), isFalse);

    // 3) If none of them is null, then use .same()
    IList<int> iList1 = IList([1, 2]), iList2 = IList([1, 2]);
    IList<int> iList3 = iList1.remove(3);

    expect(areSameImmutableCollection(iList1, iList2), isFalse);
    expect(areSameImmutableCollection(iList1, iList3), isTrue);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("areImmutableCollectionsWithEqualItems()", () {
    // 1) If both are null, then true
    expect(areImmutableCollectionsWithEqualItems(null, null), isTrue);

    // 2) If one of them is not null, then false
    expect(areImmutableCollectionsWithEqualItems(IList(), null), isFalse);
    expect(areImmutableCollectionsWithEqualItems(null, IList()), isFalse);

    // 3) If none of them is null, then use .same()
    IList<int> iList1 = IList([1, 2]);
    IList<int> iList2 = IList([1]).add(2);
    IList<int> iList3 = iList1.remove(3);
    IList<int> iList4 = IList([1, 3]);
    ISet<int> iSet1 = ISet([1, 2]);

    expect(areImmutableCollectionsWithEqualItems(iList1, iList2), isTrue);
    expect(areImmutableCollectionsWithEqualItems(iList1, iList3), isTrue);
    expect(areImmutableCollectionsWithEqualItems(iList1, iList4), isFalse);

    expect(
        areImmutableCollectionsWithEqualItems(
            // ignore: unnecessary_cast
            iList1 as ImmutableCollection,
            // ignore: unnecessary_cast
            iSet1 as ImmutableCollection),
        isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("IteratorExtension.toIterable", () {
    const List<int> list = [1, 2, 3];
    final Iterable<int> iterable = list.iterator.toIterable();
    expect(iterable, [1, 2, 3]);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("IteratorExtension.toList", () {
    const List<int> list = [1, 2, 3];
    final List<int> mutableList = list.iterator.toList();
    final List<int> unmodifiableList = list.iterator.toList(growable: false);

    mutableList.add(4);
    expect(mutableList, [1, 2, 3, 4]);

    expect(unmodifiableList, [1, 2, 3]);
    expect(() => unmodifiableList.add(4), throwsUnsupportedError);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("IteratorExtension.toSet", () {
    const List<int> list = [1, 2, 3];
    final Set<int> mutableSet = list.iterator.toSet();

    expect(mutableSet, {1, 2, 3});
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("MapIteratorExtension.toIterable", () {
    const List<MapEntry<String, int>> entryList = [
      MapEntry("a", 1),
      MapEntry("b", 2),
      MapEntry("c", 3),
    ];
    final Iterator<MapEntry<String, int>> iterator = entryList.iterator;
    final Iterable<MapEntry<String, int>> iterable = iterator.toIterable();

    expect(iterable.contains(const MapEntry("a", 1)), isTrue);
    expect(iterable.contains(const MapEntry("b", 2)), isTrue);
    expect(iterable.contains(const MapEntry("c", 3)), isTrue);
    expect(iterable.contains(const MapEntry("d", 4)), isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("MapIteratorExtension.toMap", () {
    const List<MapEntry<String, int>> entryList = [
      MapEntry("a", 1),
      MapEntry("b", 2),
      MapEntry("c", 3),
    ];
    final Iterator<MapEntry<String, int>> iterator = entryList.iterator;
    final Map<String, int> map = iterator.toMap();
    expect(map, {"a": 1, "b": 2, "c": 3});
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("Output.value", () {
    // 1) is initially null
    expect(Output().value, isNull);

    // 2) won't change after it's set
    Output<int> output = Output();

    expect(output.value, isNull);

    output.save(10);

    expect(output.value, 10);
    expect(() => output.save(1), throwsStateError);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("Output.toString", () {
    Output<int> output = Output();
    expect(output.toString(), "null");
    output.save(10);
    expect(output.toString(), "10");
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("Output.==", () {
    final Output<int> output1 = Output();
    final Output<int> output2 = Output();
    final Output<int> output3 = Output();
    output1.save(10);
    output2.save(10);
    output3.save(1);
    expect(output1 == output1, isTrue);
    expect(output1 == output2, isTrue);
    expect(output2 == output1, isTrue);
    expect(output1 == output3, isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("Output.hashCode", () {
    final Output<int> output1 = Output();
    final Output<int> output2 = Output();
    final Output<int> output3 = Output();
    output1.save(10);
    output2.save(10);
    output3.save(1);
    expect(output1.hashCode, allOf(output1.hashCode, output2.hashCode, isNot(output3.hashCode)));
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("List.toIList() / List.toISet()", () {
    const List<int> list = [1, 2, 3, 3];
    final IList<int> ilist = list.toIList();
    final ISet<int> iset = list.toISet();

    expect(ilist, [1, 2, 3, 3]);
    expect(iset, {1, 2, 3});
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("Set.toIList() / Set.toISet()", () {
    const Set<int> set = {1, 2, 3};
    final IList<int> ilist = set.toIList();
    final ISet<int> iset = set.toISet();

    expect(ilist, [1, 2, 3]);
    expect(iset, [1, 2, 3]);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("BooleanExtension.compareTo", () {
    // 1) Zero
    expect(true.compareTo(true), 0);
    expect(false.compareTo(false), 0);

    // 2) Greater than zero
    expect(true.compareTo(false), greaterThan(0));
    expect(true.compareTo(false), 1);

    // 3) Less than zero
    expect(false.compareTo(true), lessThan(0));
    expect(false.compareTo(true), -1);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("isNullOrEmpty", () {
    // List:
    expect([].isNullOrEmpty, isTrue);
    expect([1].isNullOrEmpty, isFalse);
    List<int>? list;
    expect(list.isNullOrEmpty, isTrue);

    // Set:
    expect(<Set>{}.isNullOrEmpty, isTrue);
    expect({1}.isNullOrEmpty, isFalse);
    Set<int>? set;
    expect(set.isNullOrEmpty, isTrue);

    // IMap:
    expect(<Map>{}.isNullOrEmpty, isTrue);
    expect({1: 2}.isNullOrEmpty, isFalse);
    Map<int, int>? map;
    expect(map.isNullOrEmpty, isTrue);

    // IList:
    expect(IList().isNullOrEmpty, isTrue);
    expect(IList([1]).isNullOrEmpty, isFalse);
    IList<int>? ilist;
    expect(ilist.isNullOrEmpty, isTrue);

    // ISet:
    expect(ISet().isNullOrEmpty, isTrue);
    expect(ISet([1]).isNullOrEmpty, isFalse);
    ISet<int>? iset;
    expect(iset.isNullOrEmpty, isTrue);

    // IMap:
    expect(IMap().isNullOrEmpty, isTrue);
    expect(IMap({1: 2}).isNullOrEmpty, isFalse);
    IMap<int, int>? imap;
    expect(imap.isNullOrEmpty, isTrue);

    // IMapOfSets:
    expect(IMapOfSets().isNullOrEmpty, isTrue);
    expect(
        IMapOfSets({
          1: {2}
        }).isNullOrEmpty,
        isFalse);
    IMapOfSets<int, int>? imapOfSets;
    expect(imapOfSets.isNullOrEmpty, isTrue);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("isNotNullOrEmpty", () {
    // List:
    expect([].isNotNullOrEmpty, isFalse);
    expect([1].isNotNullOrEmpty, isTrue);
    List<int>? list;
    expect(list.isNotNullOrEmpty, isFalse);

    // Set:
    expect(<Set>{}.isNotNullOrEmpty, isFalse);
    expect({1}.isNotNullOrEmpty, isTrue);
    Set<int>? set;
    expect(set.isNotNullOrEmpty, isFalse);

    // IMap:
    expect(<Map>{}.isNotNullOrEmpty, isFalse);
    expect({1: 2}.isNotNullOrEmpty, isTrue);
    Map<int, int>? map;
    expect(map.isNotNullOrEmpty, isFalse);

    // IList:
    expect(IList().isNotNullOrEmpty, isFalse);
    expect(IList([1]).isNotNullOrEmpty, isTrue);
    IList<int>? ilist;
    expect(ilist.isNotNullOrEmpty, isFalse);

    // ISet:
    expect(ISet().isNotNullOrEmpty, isFalse);
    expect(ISet([1]).isNotNullOrEmpty, isTrue);
    ISet<int>? iset;
    expect(iset.isNotNullOrEmpty, isFalse);

    // IMap:
    expect(IMap().isNotNullOrEmpty, isFalse);
    expect(IMap({1: 2}).isNotNullOrEmpty, isTrue);
    IMap<int, int>? imap;
    expect(imap.isNotNullOrEmpty, isFalse);

    // IMapOfSets:
    expect(IMapOfSets().isNotNullOrEmpty, isFalse);
    expect(
        IMapOfSets({
          1: {2}
        }).isNotNullOrEmpty,
        isTrue);
    IMapOfSets<int, int>? imapOfSets;
    expect(imapOfSets.isNotNullOrEmpty, isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("isEmptyButNotNull", () {
    // List:
    expect([].isEmptyButNotNull, isTrue);
    expect([1].isEmptyButNotNull, isFalse);
    List<int>? list;
    expect(list.isEmptyButNotNull, isFalse);

    // Set:
    expect(<Set>{}.isEmptyButNotNull, isTrue);
    expect({1}.isEmptyButNotNull, isFalse);
    Set<int>? set;
    expect(set.isEmptyButNotNull, isFalse);

    // IMap:
    expect(<Map>{}.isEmptyButNotNull, isTrue);
    expect({1: 2}.isEmptyButNotNull, isFalse);
    Map<int, int>? map;
    expect(map.isEmptyButNotNull, isFalse);

    // IList:
    expect(IList().isEmptyButNotNull, isTrue);
    expect(IList([1]).isEmptyButNotNull, isFalse);
    IList<int>? ilist;
    expect(ilist.isEmptyButNotNull, isFalse);

    // ISet:
    expect(ISet().isEmptyButNotNull, isTrue);
    expect(ISet([1]).isEmptyButNotNull, isFalse);
    ISet<int>? iset;
    expect(iset.isEmptyButNotNull, isFalse);

    // IMap:
    expect(IMap().isEmptyButNotNull, isTrue);
    expect(IMap({1: 2}).isEmptyButNotNull, isFalse);
    IMap<int, int>? imap;
    expect(imap.isEmptyButNotNull, isFalse);

    // IMapOfSets:
    expect(IMapOfSets().isEmptyButNotNull, isTrue);
    expect(
        IMapOfSets({
          1: {2}
        }).isEmptyButNotNull,
        isFalse);
    IMapOfSets<int, int>? imapOfSets;
    expect(imapOfSets.isEmptyButNotNull, isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("ImmutableCollection.disallowUnsafeConstructors", () {
    // 1) Is initially false
    expect(ImmutableCollection.disallowUnsafeConstructors, isFalse);

    // 2) Changing the default to true
    expect(ImmutableCollection.disallowUnsafeConstructors, isFalse);
    ImmutableCollection.disallowUnsafeConstructors = true;
    expect(ImmutableCollection.disallowUnsafeConstructors, isTrue);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("ImmutableCollection.autoFlush", () {
    // 1) default
    expect(ImmutableCollection.autoFlush, isTrue);

    // 2) setter
    expect(ImmutableCollection.autoFlush, isTrue);

    ImmutableCollection.autoFlush = false;

    expect(ImmutableCollection.autoFlush, isFalse);

    ImmutableCollection.autoFlush = true;

    expect(ImmutableCollection.autoFlush, isTrue);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("ImmutableCollection.prettyPrint", () {
    // 1) default
    expect(ImmutableCollection.prettyPrint, isTrue);

    // 2) setter
    expect(ImmutableCollection.prettyPrint, isTrue);

    ImmutableCollection.prettyPrint = false;

    expect(ImmutableCollection.prettyPrint, isFalse);

    ImmutableCollection.prettyPrint = true;

    expect(ImmutableCollection.prettyPrint, isTrue);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("deepEqualsByIdentity", () {
    expect([].deepEqualsByIdentity(null), false);
    expect([].deepEqualsByIdentity([]), true);
    expect([1].deepEqualsByIdentity([1]), true);
    expect([1].deepEqualsByIdentity([2]), false);
    expect([1, 2].deepEqualsByIdentity([1, 2]), true);
    expect([1, 2].deepEqualsByIdentity([3, 4]), false);
    expect([1, 2].deepEqualsByIdentity([1, 3]), false);
    expect([1, 2].deepEqualsByIdentity([1, 2, 2]), false);

    // Now with objects that are equal by value:
    var obj1 = _ClassEqualsByValue();
    expect(obj1 == obj1, true);
    expect([obj1].deepEqualsByIdentity([obj1]), true);
    expect([obj1].deepEqualsByIdentity([_ClassEqualsByValue()]), false);

    var obj2 = _ClassEqualsByValue();
    expect(obj1 == obj2, true);
    expect([obj1].deepEqualsByIdentity([obj2]), false);
    expect([obj1, obj2].deepEqualsByIdentity([obj1, obj2]), true);

    // Comparing to non-list objects
    expect([].deepEqualsByIdentity({}), true);
    expect([1].deepEqualsByIdentity({1}), true);
    expect([1].deepEqualsByIdentity({2}), false);
    expect([1, 2].deepEqualsByIdentity({1, 2}), true);
    expect([1, 2].deepEqualsByIdentity({3, 4}), false);
    expect([1, 2].deepEqualsByIdentity({1, 3}), false);
    expect([1, 2].deepEqualsByIdentity([1, 2, 2].iterator.toIterable()), false);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("FicIterableExtension | isNullOrEmpty | isNotNullOrEmpty", () {
    final Iterable<int> iter1 = [1, 2, 3].iterator.toIterable();
    expect(iter1.isNullOrEmpty, isFalse);
    expect(iter1.isNotNullOrEmpty, isTrue);

    final Iterable<int> iter2 = <int>[].iterator.toIterable();
    expect(iter2.isNullOrEmpty, isTrue);
    expect(iter2.isNotNullOrEmpty, isFalse);

    Iterable<int>? iter3;
    expect(iter3.isNullOrEmpty, isTrue);
    expect(iter3.isNotNullOrEmpty, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("removeDuplicates", () {
    expect(([].removeDuplicates()), []);
    expect(([5, 5, 5].removeDuplicates()), [5]);
    expect(([1, 2, 3, 4].removeDuplicates()), [1, 2, 3, 4]);
    expect(([1, 2, 3, 4, 3, 5, 3].removeDuplicates()), [1, 2, 3, 4, 5]);
    expect(([1, 2, 3, 4, 3, 5, 1].removeDuplicates()), [1, 2, 3, 4, 5]);
    expect((["abc", "abc", "def"].removeDuplicates()), ["abc", "def"]);
    expect((["abc", "abc", "def"].removeDuplicates()).take(1), ["abc"]);

    expect((["a", "b", "abc", "ab", "def"].removeDuplicates(by: (item) => item.length)),
        ["a", "abc", "ab"]);

    expect(
        (["a", "b", "abc", "ab", "def"]
            .removeDuplicates(by: (item) => item.length, removeNulls: true)),
        ["a", "abc", "ab"]);

    expect(([null, 1, 2, 3, null, 4, 3, 5, 1, null].removeDuplicates(removeNulls: true)),
        [1, 2, 3, 4, 5]);

    expect(
        ([null, "a", "b", null, "abc", "ab", "def", null]
            .removeDuplicates(by: ((item) => item?.length), removeNulls: true)),
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
}

class _ClassEqualsByValue {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _ClassEqualsByValue && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

// /////////////////////////////////////////////////////////////////////////////
