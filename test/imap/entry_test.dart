// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("MapEntryExtension.entry", () {
    final Entry<String, int> entry = MapEntry("a", 1).asComparableEntry;

    expect(entry.key, "a");
    expect(entry.value, 1);
  });

  test("MapEntryExtension.compareKeyAndValue", () {
    expect(
        MapEntry<String?, int?>(null, null).compareKeyAndValue(MapEntry<String?, int?>(null, null)),
        0);
    expect(MapEntry<String?, int?>(null, null).compareKeyAndValue(null), -1);
    expect(MapEntry<String, int>("a", 1).compareKeyAndValue(MapEntry<String, int>("a", 1)), 0);
    expect(MapEntry<String, int>("a", 1).compareKeyAndValue(MapEntry<String, int>("b", 1)), -1);
    expect(MapEntry<String, int>("a", 1).compareKeyAndValue(MapEntry<String, int>("a", 2)), -1);
    expect(MapEntry<String, int>("a", 2).compareKeyAndValue(MapEntry<String, int>("b", 1)), -1);
  });

  test("MapEntryExtension.print", () {
    // 1) Simple usage
    final MapEntry<String, int> simpleEntry = MapEntry("a", 1);

    expect(simpleEntry.print(true), "a: 1");
    expect(simpleEntry.print(false), "a: 1");

    // 2) The key is one of the immutable collections
    final MapEntry<IList<String>, int> entryWithCollectionKeys = MapEntry(["a", "b"].lock, 1);

    expect(entryWithCollectionKeys.print(false), "[a, b]: 1");
    expect(
        entryWithCollectionKeys.print(true),
        "[\n"
        "   a,\n"
        "   b\n"
        "]: 1");
    // 3) The value is one of the immutable collections
    final MapEntry<int, ISet<int>> entryWithCollectionValues = MapEntry(1, {1, 2, 3}.lock);

    expect(entryWithCollectionValues.print(false), "1: {1, 2, 3}");
    expect(
        entryWithCollectionValues.print(true),
        "1: {\n"
        "   1,\n"
        "   2,\n"
        "   3\n"
        "}");
  });

  test("Default constructor", () {
    const Entry<String, int> entry = Entry("a", 1);

    expect(entry.key, "a");
    expect(entry.value, 1);
  });

  test("from", () {
    final Entry<String, int> entry = Entry.from<String, int>(MapEntry<String, int>("a", 1));

    expect(entry.key, "a");
    expect(entry.value, 1);
  });

  test("==", () {
    final Entry<String, int> entry1 = Entry("a", 1);
    expect(entry1, entry1);
    expect(entry1, Entry("a", 1));
    expect(entry1 == Entry("b", 1), isFalse);
    expect(entry1 == Entry("a", 2), isFalse);
  });

  test("hashCode", () {
    final Entry<String, int> entry1 = Entry("a", 1);
    expect(entry1 == Entry("a", 1), isTrue);
    expect(entry1 == Entry("b", 1), isFalse);
    expect(entry1.hashCode, Entry("a", 1).hashCode);
    expect(entry1.hashCode, isNot(Entry("b", 1).hashCode));
  });

  test("toString", () {
    const Entry<String, int> entry = Entry("a", 1);

    expect(entry.toString(), "Entry(a: 1)");
  });

  test("compareTo", () {
    expect(Entry<String?, int?>(null, null).compareTo(Entry<String?, int?>(null, null)), 0);
    expect(Entry<String, int>("a", 1).compareTo(Entry<String, int>("a", 1)), 0);
    expect(Entry<String, int>("a", 1).compareTo(Entry<String, int>("b", 1)), -1);
    expect(Entry<String, int>("a", 1).compareTo(Entry<String, int>("a", 2)), -1);
    expect(Entry<String, int>("a", 1).compareTo(Entry<String, int>("b", 2)), -1);
    expect(Entry<String, int>("a", 2).compareTo(Entry<String, int>("b", 1)), -1);
  });
}
