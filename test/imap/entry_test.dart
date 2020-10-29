import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  group("Initialization |", () {
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
      final Entry<String, int> entry = MapEntry("a", 1).entry;

      expect(entry.key, "a");
      expect(entry.value, 1);
    });

    group("Equals and Hash Code |", () {
      final Entry<String, int> entry1 = Entry("a", 1),
          entry2 = Entry("a", 1),
          entry3 = Entry("b", 1),
          entry4 = Entry("a", 2);

      test("Entry == operator", () {
        expect(entry1, entry1);
        expect(entry1, entry2);
        expect(entry1 == entry3, isFalse);
        expect(entry1 == entry4, isFalse);
      });

      test("Entry.hashCode method", () {
        expect(entry1 == entry2, isTrue);
        expect(entry1 == entry3, isFalse);
        expect(entry1.hashCode, entry2.hashCode);
        expect(entry1.hashCode, isNot(entry3.hashCode));
      });
    });

    group("Others |", () {
      test("Entry.toString method", () {
        const Entry<String, int> entry = Entry("a", 1);

        expect(entry.toString(), "Entry(a: 1)");
      });
    });
  });
}
