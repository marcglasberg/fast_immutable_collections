import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("Normal constructor", () {
    const Entry<String, int> entry = Entry("a", 1);

    expect(entry.key, "a");
    expect(entry.value, 1);
  });

  test("Entry.from static method", () {
    final Entry<String, int> entry = Entry.from<String, int>(MapEntry<String, int>("a", 1));

    expect(entry.key, "a");
    expect(entry.value, 1);
  });

  test("From the MapEntryExtension.entry getter", () {
    final Entry<String, int> entry = MapEntry("a", 1).asEntry;

    expect(entry.key, "a");
    expect(entry.value, 1);
  });

  test("Entry == operator", () {
    final Entry<String, int> entry1 = Entry("a", 1);
    expect(entry1, entry1);
    expect(entry1, Entry("a", 1));
    expect(entry1 == Entry("b", 1), isFalse);
    expect(entry1 == Entry("a", 2), isFalse);
  });

  test("Entry.hashCode method", () {
    final Entry<String, int> entry1 = Entry("a", 1);
    expect(entry1 == Entry("a", 1), isTrue);
    expect(entry1 == Entry("b", 1), isFalse);
    expect(entry1.hashCode, Entry("a", 1).hashCode);
    expect(entry1.hashCode, isNot(Entry("b", 1).hashCode));
  });

  test("Entry.toString method", () {
    const Entry<String, int> entry = Entry("a", 1);

    expect(entry.toString(), "Entry(a: 1)");
  });
}
