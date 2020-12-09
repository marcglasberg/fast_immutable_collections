import "package:meta/meta.dart";
import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = true;
    ImmutableCollection.prettyPrint = true;
  });

  /////////////////////////////////////////////////////////////////////////////

  test("sameCollection()", () {
    // 1) If both are null, then true
    expect(sameCollection(null, null), isTrue);

    // 2) If one of them is not null, then false
    expect(sameCollection(IList(), null), isFalse);
    expect(sameCollection(null, IList()), isFalse);

    // 3) If none of them is null, then use .same()
    final IList<int> iList1 = IList([1, 2]), iList2 = IList([1, 2]);
    final IList<int> iList3 = iList1.remove(3);

    expect(sameCollection(iList1, iList2), isFalse);
    expect(sameCollection(iList1, iList3), isTrue);
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

  test("IterableToImmutableExtension.lockAsList", () {
    const List<int> list = [1, 2, 3, 3];
    final IList<int> ilist = list.lockAsList;
    final ISet<int> iset = list.lockAsSet;

    expect(ilist, [1, 2, 3, 3]);
    expect(iset, {1, 2, 3});
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("IterableToImmutableExtension.lockAsSet", () {
    const Set<int> set = {1, 2, 3};
    final IList<int> ilist = set.lockAsList;
    final ISet<int> iset = set.lockAsSet;

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

  test("CanBeEmptyExtension.isNullOrEmpty", () {
    const CanBeEmptyExample exampleNull = null;
    const CanBeEmptyExample exampleIsEmpty = CanBeEmptyExample(true, null);
    const CanBeEmptyExample exampleIsNotEmpty = CanBeEmptyExample(false, null);

    expect(exampleNull.isNullOrEmpty, isTrue);
    expect(exampleIsEmpty.isNullOrEmpty, isTrue);
    expect(exampleIsNotEmpty.isNullOrEmpty, isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("CanBeEmptyExtension.isNotNullOrEmpty", () {
    const CanBeEmptyExample exampleNull = null;
    const CanBeEmptyExample exampleIsNotEmpty = CanBeEmptyExample(null, true);
    const CanBeEmptyExample exampleIsEmpty = CanBeEmptyExample(null, false);

    expect(exampleNull.isNotNullOrEmpty, isFalse);
    expect(exampleIsNotEmpty.isNotNullOrEmpty, isTrue);
    expect(exampleIsEmpty.isNotNullOrEmpty, isFalse);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("CanBeEmptyExtension.isEmptyButNotNull", () {
    const CanBeEmptyExample exampleNull = null;
    const CanBeEmptyExample exampleIsEmpty = CanBeEmptyExample(true, null);
    const CanBeEmptyExample exampleIsNotEmpty = CanBeEmptyExample(false, null);

    expect(exampleNull.isEmptyButNotNull, isFalse);
    expect(exampleIsEmpty.isEmptyButNotNull, isTrue);
    expect(exampleIsNotEmpty.isEmptyButNotNull, isFalse);
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
}

@immutable
class CanBeEmptyExample implements CanBeEmpty {
  @override
  final bool isEmpty, isNotEmpty;

  const CanBeEmptyExample(this.isEmpty, this.isNotEmpty);
}
