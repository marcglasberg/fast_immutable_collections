import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:matcher/matcher.dart";
import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  group("StopwatchRecord |", () {
    const TypeMatcher<AssertionError> isAssertionError = TypeMatcher<AssertionError>();
    final Matcher throwsAssertionError = throwsA(isAssertionError);

    test("Can't pass null", () {
      expect(() => StopwatchRecord(collectionName: null, record: null), throwsAssertionError);
      expect(() => StopwatchRecord(collectionName: null, record: 10), throwsAssertionError);
      expect(() => StopwatchRecord(collectionName: "asdf", record: null), throwsAssertionError);
    });

    test("The collection name has to have length bigger than 0",
        () => expect(() => StopwatchRecord(collectionName: "", record: 10), throwsAssertionError));

    test(
        "The record has to be bigger than 0",
        () =>
            expect(() => StopwatchRecord(collectionName: "asdf", record: 0), throwsAssertionError));

    test("Simple usage", () {
      const StopwatchRecord stopwatchRecord = StopwatchRecord(collectionName: "list", record: 10);

      expect(stopwatchRecord.collectionName, "list");
      expect(stopwatchRecord.record, 10);
    });

    test("== operator", () {
      const StopwatchRecord listRecord1 = StopwatchRecord(collectionName: "list", record: 10),
          listRecord3 = StopwatchRecord(collectionName: "list", record: 11),
          iListRecord1 = StopwatchRecord(collectionName: "iList", record: 11),
          iListRecord2 = StopwatchRecord(collectionName: "iList", record: 10);
      final StopwatchRecord listRecord2 = StopwatchRecord(collectionName: "list", record: 10);

      expect(listRecord1, listRecord2);
      expect(listRecord1, isNot(listRecord3));
      expect(listRecord1, isNot(iListRecord1));
      expect(listRecord1, isNot(iListRecord2));
    });

    test("toString method", () {
      const StopwatchRecord record = StopwatchRecord(collectionName: "list", record: 10);

      expect(record.toString(), "StopwatchRecord: (collectionName: list, record: 10.0)");
    });
  });

  group("RecordsColumn |", () {
    test("Empty initialization", () {
      final RecordsColumn recordsColumn = RecordsColumn.empty();

      expect(recordsColumn.records, allOf(isA<IList<StopwatchRecord>>(), isEmpty));
    });

    test("Adding a record", () {
      final RecordsColumn recordsColumn = RecordsColumn.empty();
      const StopwatchRecord record = StopwatchRecord(collectionName: "list", record: 10);

      final RecordsColumn newColumn = recordsColumn + record;

      expect(
          newColumn.records,
          allOf(<StopwatchRecord>[StopwatchRecord(collectionName: "list", record: 10)].lock,
              isNotEmpty));
    });

    test("== operator", () {
      RecordsColumn recordsColumn1 = RecordsColumn.empty();
      RecordsColumn recordsColumn2 = RecordsColumn.empty();

      expect(recordsColumn1, RecordsColumn.empty());

      final StopwatchRecord record1 = StopwatchRecord(collectionName: "list", record: 10);

      recordsColumn1 += record1;
      expect(recordsColumn1, isNot(RecordsColumn.empty()));

      final StopwatchRecord record2 = StopwatchRecord(collectionName: "list", record: 10);

      recordsColumn2 += record2;
      expect(recordsColumn2, isNot(RecordsColumn.empty()));
      expect(recordsColumn2, recordsColumn1);
    });

    test("toString method", () {
      RecordsColumn recordsColumn = RecordsColumn.empty();
      recordsColumn += StopwatchRecord(collectionName: "list", record: 10);

      expect(recordsColumn.toString(),
          "RecordsColumn: [StopwatchRecord: (collectionName: list, record: 10.0)]");
    });

    test("Changing the variable that points to a record doesn't change the column", () {
      
    });

    test("Extracting the column's maximum value", () {
      RecordsColumn recordsColumn = RecordsColumn.empty();
      recordsColumn += StopwatchRecord(collectionName: "list", record: 10);
      recordsColumn += StopwatchRecord(collectionName: "iList", record: 11);
      recordsColumn += StopwatchRecord(collectionName: "ktList", record: 100);
      recordsColumn += StopwatchRecord(collectionName: "builtList", record: 50);

      expect(recordsColumn.max, 100);
    });
  });
}
