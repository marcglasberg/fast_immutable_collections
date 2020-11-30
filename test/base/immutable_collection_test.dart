import "package:meta/meta.dart";
import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  // TODO: Marcelo, apesar de que a documentação esclarece isso, eu tenho certeza que quem ler
  // esse nome (`sameCollection`) vai certamente pensar que ela checa se ambos os objetos são
  // `IList`, `ISet`, etc. Ainda acho que algo como `sameCollectionInternals` seria mais claro.
  test("sameCollection() | If both are null, then true",
      () => expect(sameCollection(null, null), isTrue));

  test("sameCollection() | If one of them is not null, then false", () {
    expect(sameCollection(IList(), null), isFalse);
    expect(sameCollection(null, IList()), isFalse);
  });

  test("sameCollection() | If none of them is null, then use .same()", () {
    final IList<int> iList1 = IList([1, 2]), iList2 = IList([1, 2]);
    final IList<int> iList3 = iList1.remove(3);

    expect(sameCollection(iList1, iList2), isFalse);
    expect(sameCollection(iList1, iList3), isTrue);
  });

  test("disallowUnsafeConstructors | Is initially false",
      () => expect(ImmutableCollection.disallowUnsafeConstructors, isFalse));

  test("disallowUnsafeConstructors | Changing the default to true", () {
    expect(ImmutableCollection.disallowUnsafeConstructors, isFalse);
    ImmutableCollection.disallowUnsafeConstructors = true;
    expect(ImmutableCollection.disallowUnsafeConstructors, isTrue);
  });

  test("IteratorExtension | IteratorExtension.toIterable method/generator", () {
    const List<int> list = [1, 2, 3];
    final Iterable<int> iterable = list.iterator.toIterable();
    expect(iterable, [1, 2, 3]);
  });

  test("IteratorExtension | IteratorExtension.toList()", () {
    const List<int> list = [1, 2, 3];
    final List<int> mutableList = list.iterator.toList();
    final List<int> unmodifiableList = list.iterator.toList(growable: false);

    mutableList.add(4);
    expect(mutableList, [1, 2, 3, 4]);

    expect(unmodifiableList, [1, 2, 3]);
    expect(() => unmodifiableList.add(4), throwsUnsupportedError);
  });

  test("IteratorExtension | IteratorExtension.toSet method", () {
    const List<int> list = [1, 2, 3];
    final Set<int> mutableSet = list.iterator.toSet();

    expect(mutableSet, {1, 2, 3});
  });

  test("MapIteratorExtension | MapIteratorExtension.toIterable()", () {
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

  test("MapIteratorExtension | MapIteratorExtension.toMap()", () {
    const List<MapEntry<String, int>> entryList = [
      MapEntry("a", 1),
      MapEntry("b", 2),
      MapEntry("c", 3),
    ];
    final Iterator<MapEntry<String, int>> iterator = entryList.iterator;
    final Map<String, int> map = iterator.toMap();
    expect(map, {"a": 1, "b": 2, "c": 3});
  });

  test("Output | Output.value is initially null", () => expect(Output().value, isNull));

  test("Output | Output.value won't change after it's set", () {
    Output<int> output = Output();

    expect(output.value, isNull);

    output.set(10);

    expect(output.value, 10);
    expect(() => output.set(1), throwsStateError);
  });

  test("Output | Output.toString()", () {
    Output<int> output = Output();
    expect(output.toString(), "null");
    output.set(10);
    expect(output.toString(), "10");
  });

  test("Output | Output.== operator", () {
    final Output<int> output1 = Output();
    final Output<int> output2 = Output();
    final Output<int> output3 = Output();
    output1.set(10);
    output2.set(10);
    output3.set(1);
    expect(output1 == output1, isTrue);
    expect(output1 == output2, isTrue);
    expect(output2 == output1, isTrue);
    expect(output1 == output3, isFalse);
  });

  test("Output | Output.hashCode getter", () {
    final Output<int> output1 = Output();
    final Output<int> output2 = Output();
    final Output<int> output3 = Output();
    output1.set(10);
    output2.set(10);
    output3.set(1);
    expect(output1.hashCode, allOf(output1.hashCode, output2.hashCode, isNot(output3.hashCode)));
  });

  test("IterableToImmutableExtension.lockAsList", () {
    const List<int> list = [1, 2, 3, 3];
    final IList<int> iList = list.lockAsList;
    final ISet<int> iSet = list.lockAsSet;

    expect(iList, [1, 2, 3, 3]);
    expect(iSet, {1, 2, 3});
  });

  test("IterableToImmutableExtension.lockAsSet", () {
    const Set<int> set = {1, 2, 3};
    final IList<int> iList = set.lockAsList;
    final ISet<int> iSet = set.lockAsSet;

    expect(iList, [1, 2, 3]);
    expect(iSet, [1, 2, 3]);
  });

  test("BooleanExtension | Zero", () {
    expect(true.compareTo(true), 0);
    expect(false.compareTo(false), 0);
  });

  test("BooleanExtension | Greater than zero", () {
    expect(true.compareTo(false), greaterThan(0));
    expect(true.compareTo(false), 1);
  });

  test("BooleanExtension | Less than zero", () {
    expect(false.compareTo(true), lessThan(0));
    expect(false.compareTo(true), -1);
  });

  test("CanBeEmptyExtension | isNullOrEmpty", () {
    const CanBeEmptyExample exampleNull = null;
    const CanBeEmptyExample exampleIsEmpty = CanBeEmptyExample(true, null);
    const CanBeEmptyExample exampleIsNotEmpty = CanBeEmptyExample(false, null);

    expect(exampleNull.isNullOrEmpty, isTrue);
    expect(exampleIsEmpty.isNullOrEmpty, isTrue);
    expect(exampleIsNotEmpty.isNullOrEmpty, isFalse);
  });

  test("CanBeEmptyExtension | isNotNullOrEmpty", () {
    const CanBeEmptyExample exampleNull = null;
    const CanBeEmptyExample exampleIsNotEmpty = CanBeEmptyExample(null, true);
    const CanBeEmptyExample exampleIsEmpty = CanBeEmptyExample(null, false);

    expect(exampleNull.isNotNullOrEmpty, isFalse);
    expect(exampleIsNotEmpty.isNotNullOrEmpty, isTrue);
    expect(exampleIsEmpty.isNotNullOrEmpty, isFalse);
  });

  test("CanBeEmptyExtension | isEmptyButNotNull", () {
    const CanBeEmptyExample exampleNull = null;
    const CanBeEmptyExample exampleIsEmpty = CanBeEmptyExample(true, null);
    const CanBeEmptyExample exampleIsNotEmpty = CanBeEmptyExample(false, null);

    expect(exampleNull.isEmptyButNotNull, isFalse);
    expect(exampleIsEmpty.isEmptyButNotNull, isTrue);
    expect(exampleIsNotEmpty.isEmptyButNotNull, isFalse);
  });

  test("ImmutableCollection.autoFlush", () => expect(ImmutableCollection.autoFlush, isTrue));

  test("ImmutableCollection.autoFlush setter", () {
    ImmutableCollection.autoFlush = false;

    expect(ImmutableCollection.autoFlush, isFalse);

    ImmutableCollection.autoFlush = true;

    expect(ImmutableCollection.autoFlush, isTrue);
  });

  test("lockConfig", () {
    ImmutableCollection.lockConfig();
    expect(() => IList.resetAllConfigurations(), throwsStateError);
    expect(() => ISet.resetAllConfigurations(), throwsStateError);
    expect(() => IMap.resetAllConfigurations(), throwsStateError);
    expect(() => ImmutableCollection.disallowUnsafeConstructors = true, throwsStateError);
    expect(() => ImmutableCollection.autoFlush = false, throwsStateError);
    expect(() => ImmutableCollection.resetAllConfigurations(), throwsStateError);
  });
}

@immutable
class CanBeEmptyExample implements CanBeEmpty {
  @override
  final bool isEmpty, isNotEmpty;

  const CanBeEmptyExample(this.isEmpty, this.isNotEmpty);
}
