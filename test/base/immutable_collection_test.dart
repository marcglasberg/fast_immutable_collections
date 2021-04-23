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

    // 3.1) IList
    IList<int> iList1 = IList([1, 2]), iList2 = IList([1, 2]);
    IList<int> iList3 = iList1.remove(3);

    expect(areSameImmutableCollection(iList1, iList2), isFalse);
    expect(areSameImmutableCollection(iList1, iList3), isTrue);

    // 3.2) ISet
    ISet<int> iset1 = ISet([1, 2]), iSet2 = ISet([1, 2]);
    ISet<int> iset3 = iset1.remove(3);

    expect(areSameImmutableCollection(iset1, iSet2), isFalse);
    expect(areSameImmutableCollection(iset1, iset3), isTrue);

    // 3.3) IMap
    IMap<String, int> imap1 = IMap({"a": 1, "b": 2}), imap2 = IMap({"a": 1, "b": 2});
    IMap<String, int> imap3 = imap1.remove("c");

    expect(areSameImmutableCollection(imap1, imap2), isFalse);
    expect(areSameImmutableCollection(imap1, imap3), isTrue);

    // 3.4) IMapOfSets
    IMapOfSets<String, int> imapOfSets1 = IMapOfSets({
          "a": {1},
          "b": {1, 2}
        }),
        imapOfSets2 = IMapOfSets({
          "a": {1},
          "b": {1, 2}
        });
    IMapOfSets<String, int> imapOfSets3 = imapOfSets1.removeSet("c");

    expect(areSameImmutableCollection(imapOfSets1, imapOfSets2), isFalse);
    expect(areSameImmutableCollection(imapOfSets1, imapOfSets3), isTrue);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("areSameImmutableCollection | Different Collections", () {
    IList<int> ilistA = IList([1, 2]);
    ISet<int> isetA = ISet([1, 2]);
    expect(areSameImmutableCollection(ilistA, isetA), isFalse);
  });

  /////////////////////////////////////////////////////////////////////////////

  test(
      "areSameImmutableCollection | "
      "Trying to verify if Dart implicitly checks for the type of the items inside the "
      "[ImmutableCollection]. If it does, then the print inside the 3rd `if` shouldn't be executed.",
      () {
    IList<int> iListA = IList([1, 2]);
    IList<String> iListB = IList(["a", "b"]);

    expect(areSameImmutableCollection(iListA, iListB), isFalse); // throws an error
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

  test("FicIteratorExtension.toIterable", () {
    const List<int> list = [1, 2, 3];
    final Iterable<int> iterable = list.iterator.toIterable();
    expect(iterable, [1, 2, 3]);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("FicIteratorExtension.toList", () {
    const List<int> list = [1, 2, 3];
    final List<int> mutableList = list.iterator.toList();
    final List<int> unmodifiableList = list.iterator.toList(growable: false);

    mutableList.add(4);
    expect(mutableList, [1, 2, 3, 4]);

    expect(unmodifiableList, [1, 2, 3]);
    expect(() => unmodifiableList.add(4), throwsUnsupportedError);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("FicIteratorExtension.toSet", () {
    const List<int> list = [1, 2, 3];
    final Set<int> mutableSet = list.iterator.toSet();

    expect(mutableSet, {1, 2, 3});
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("FicMapIteratorExtension.toIterable", () {
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
    expect(iterable.contains(null), isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("FicMapIteratorExtension.toMap", () {
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

  test("isNotNullNotEmpty", () {
    // List:
    expect([].isNotNullNotEmpty, isFalse);
    expect([1].isNotNullNotEmpty, isTrue);
    List<int>? list;
    expect(list.isNotNullNotEmpty, isFalse);

    // Set:
    expect(<Set>{}.isNotNullNotEmpty, isFalse);
    expect({1}.isNotNullNotEmpty, isTrue);
    Set<int>? set;
    expect(set.isNotNullNotEmpty, isFalse);

    // IMap:
    expect(<Map>{}.isNotNullNotEmpty, isFalse);
    expect({1: 2}.isNotNullNotEmpty, isTrue);
    Map<int, int>? map;
    expect(map.isNotNullNotEmpty, isFalse);

    // IList:
    expect(IList().isNotNullNotEmpty, isFalse);
    expect(IList([1]).isNotNullNotEmpty, isTrue);
    IList<int>? ilist;
    expect(ilist.isNotNullNotEmpty, isFalse);

    // ISet:
    expect(ISet().isNotNullNotEmpty, isFalse);
    expect(ISet([1]).isNotNullNotEmpty, isTrue);
    ISet<int>? iset;
    expect(iset.isNotNullNotEmpty, isFalse);

    // IMap:
    expect(IMap().isNotNullNotEmpty, isFalse);
    expect(IMap({1: 2}).isNotNullNotEmpty, isTrue);
    IMap<int, int>? imap;
    expect(imap.isNotNullNotEmpty, isFalse);

    // IMapOfSets:
    expect(IMapOfSets().isNotNullNotEmpty, isFalse);
    expect(
        IMapOfSets({
          1: {2}
        }).isNotNullNotEmpty,
        isTrue);
    IMapOfSets<int, int>? imapOfSets;
    expect(imapOfSets.isNotNullNotEmpty, isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("isEmptyNotNull", () {
    // List:
    expect([].isEmptyNotNull, isTrue);
    expect([1].isEmptyNotNull, isFalse);
    List<int>? list;
    expect(list.isEmptyNotNull, isFalse);

    // Set:
    expect(<Set>{}.isEmptyNotNull, isTrue);
    expect({1}.isEmptyNotNull, isFalse);
    Set<int>? set;
    expect(set.isEmptyNotNull, isFalse);

    // IMap:
    expect(<Map>{}.isEmptyNotNull, isTrue);
    expect({1: 2}.isEmptyNotNull, isFalse);
    Map<int, int>? map;
    expect(map.isEmptyNotNull, isFalse);

    // IList:
    expect(IList().isEmptyNotNull, isTrue);
    expect(IList([1]).isEmptyNotNull, isFalse);
    IList<int>? ilist;
    expect(ilist.isEmptyNotNull, isFalse);

    // ISet:
    expect(ISet().isEmptyNotNull, isTrue);
    expect(ISet([1]).isEmptyNotNull, isFalse);
    ISet<int>? iset;
    expect(iset.isEmptyNotNull, isFalse);

    // IMap:
    expect(IMap().isEmptyNotNull, isTrue);
    expect(IMap({1: 2}).isEmptyNotNull, isFalse);
    IMap<int, int>? imap;
    expect(imap.isEmptyNotNull, isFalse);

    // IMapOfSets:
    expect(IMapOfSets().isEmptyNotNull, isTrue);
    expect(
        IMapOfSets({
          1: {2}
        }).isEmptyNotNull,
        isFalse);
    IMapOfSets<int, int>? imapOfSets;
    expect(imapOfSets.isEmptyNotNull, isFalse);
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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("FicIteratorExtension.toIterable()", () {
    final Iterable<int> iter1 = [1, 2, 3].iterator.toIterable();
    expect(iter1.isNullOrEmpty, isFalse);
    expect(iter1.isNotNullNotEmpty, isTrue);

    final Iterable<int> iter2 = <int>[].iterator.toIterable();
    expect(iter2.isNullOrEmpty, isTrue);
    expect(iter2.isNotNullNotEmpty, isFalse);

    Iterable<int>? iter3;
    expect(iter3.isNullOrEmpty, isTrue);
    expect(iter3.isNotNullNotEmpty, isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////
}
