import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:matcher/matcher.dart";
import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  const TypeMatcher<AssertionError> isAssertionError = TypeMatcher<AssertionError>();
  final Matcher throwsAssertionError = throwsA(isAssertionError);

  group("StopwatchRecord |", () {
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

    test("Title cannot be null nor have length equal to zero", () {
      expect(() => RecordsColumn.empty(title: null), throwsAssertionError);
      expect(() => RecordsColumn.empty(title: ""), throwsAssertionError);
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

    group("Min & Max |", () {
      RecordsColumn recordsColumn = RecordsColumn.empty();
      recordsColumn += StopwatchRecord(collectionName: "list", record: 10);
      recordsColumn += StopwatchRecord(collectionName: "iList", record: 11);
      recordsColumn += StopwatchRecord(collectionName: "ktList", record: 100);
      recordsColumn += StopwatchRecord(collectionName: "builtList", record: 50);

      test("Extracting the column's maximum value", () => expect(recordsColumn.max, 100));

      test("Extracting the column's minimum value", () => expect(recordsColumn.min, 10));
    });

    test("Extracting the column's List's value", () {
      RecordsColumn recordsColumn = RecordsColumn.empty();
      recordsColumn += StopwatchRecord(collectionName: "list (mutable)", record: 10);
      recordsColumn += StopwatchRecord(collectionName: "iList", record: 11);

      expect(recordsColumn.mutableRecord, 10);
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
  });

  group("LeftLegend |", () {
    test("The rows contain all of the collection names", () {
      RecordsColumn recordsColumn = RecordsColumn.empty();
      recordsColumn += StopwatchRecord(collectionName: "List (Mutable)", record: 10);
      recordsColumn += StopwatchRecord(collectionName: "IList", record: 11);

      final LeftLegend leftLegend = LeftLegend(results: recordsColumn);

      expect(leftLegend.rows, ["Collection", "List (Mutable)", "IList"]);
    });
  });

  group("RecordsTable |", () {
    RecordsColumn recordsColumn = RecordsColumn.empty(title: "Time (μs)");
    recordsColumn += StopwatchRecord(collectionName: "List (Mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "IList", record: 15);
    recordsColumn += StopwatchRecord(collectionName: "KtList", record: 20);
    recordsColumn += StopwatchRecord(collectionName: "BuiltList", record: 30);

    final RecordsTable recordsTable =
        RecordsTable(resultsColumn: recordsColumn, config: const Config(runs: 100, size: 1000));

    test("Left, legend column", () {
      expect(recordsTable.leftLegend, isA<LeftLegend>());
      expect(recordsTable.leftLegend.rows,
          ["Collection", "List (Mutable)", "IList", "KtList", "BuiltList"]);
    });

    test("Normalized against max Column", () {
      RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
      recordsColumnAnswer += StopwatchRecord(collectionName: "List (Mutable)", record: .33);
      recordsColumnAnswer += StopwatchRecord(collectionName: "IList", record: .5);
      recordsColumnAnswer += StopwatchRecord(collectionName: "KtList", record: .67);
      recordsColumnAnswer += StopwatchRecord(collectionName: "BuiltList", record: 1);

      expect(recordsTable.normalizedAgainstMax, recordsColumnAnswer);
      expect(recordsTable.normalizedAgainstMax.title, "x Max Time");
    });

    test("Normalized against min column", () {
      RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
      recordsColumnAnswer += StopwatchRecord(collectionName: "List (Mutable)", record: 1);
      recordsColumnAnswer += StopwatchRecord(collectionName: "IList", record: 1.5);
      recordsColumnAnswer += StopwatchRecord(collectionName: "KtList", record: 2);
      recordsColumnAnswer += StopwatchRecord(collectionName: "BuiltList", record: 3);

      expect(recordsTable.normalizedAgainstMin, recordsColumnAnswer);
      expect(recordsTable.normalizedAgainstMin.title, "x Min Time");
    });

    test("Normalized against the mutable result", () {
      RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
      recordsColumnAnswer += StopwatchRecord(collectionName: "List (Mutable)", record: 1);
      recordsColumnAnswer += StopwatchRecord(collectionName: "IList", record: 1.5);
      recordsColumnAnswer += StopwatchRecord(collectionName: "KtList", record: 2);
      recordsColumnAnswer += StopwatchRecord(collectionName: "BuiltList", record: 3);

      expect(recordsTable.normalizedAgainstMutable, recordsColumnAnswer);
      expect(recordsTable.normalizedAgainstMutable.title, "x Mutable Time");
    });

    test("Normalized against runs", () {
      RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
      recordsColumnAnswer += StopwatchRecord(collectionName: "List (Mutable)", record: .1);
      recordsColumnAnswer += StopwatchRecord(collectionName: "IList", record: .15);
      recordsColumnAnswer += StopwatchRecord(collectionName: "KtList", record: .2);
      recordsColumnAnswer += StopwatchRecord(collectionName: "BuiltList", record: .3);

      expect(recordsTable.normalizedAgainstRuns, recordsColumnAnswer);
      expect(recordsTable.normalizedAgainstRuns.title, "Time (μs) / Runs");
    });

    test("Normalized against size", () {
      RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
      recordsColumnAnswer += StopwatchRecord(collectionName: "List (Mutable)", record: .01);
      recordsColumnAnswer += StopwatchRecord(collectionName: "IList", record: .01);
      recordsColumnAnswer += StopwatchRecord(collectionName: "KtList", record: .02);
      recordsColumnAnswer += StopwatchRecord(collectionName: "BuiltList", record: .03);

      expect(recordsTable.normalizedAgainstSize, recordsColumnAnswer);
      expect(recordsTable.normalizedAgainstSize.title, "Time (μs) / Size");
    });

    test("toString method (for saving it as CSV)", () {
      const String correctTableAsString = "Collection,Time (μs),"
          "x Max Time,x Min Time,x Mutable Time,Time (μs) / Runs,Time (μs) / Size\n"
          "List (Mutable),15.0,0.5,0.5,1.5,0.15,0.01\n"
          "IList,20.0,0.67,0.67,2.0,0.2,0.02\n"
          "KtList,30.0,1.0,1.0,3.0,0.3,0.03\n"
          "";

      expect(recordsTable.toString(), correctTableAsString);
    });
  });
}
