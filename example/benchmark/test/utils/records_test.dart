// ignore_for_file: prefer_final_locals

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

const TypeMatcher<AssertionError> isAssertionError = TypeMatcher<AssertionError>();
final Matcher throwsAssertionError = throwsA(isAssertionError);

void main() {
  test("Config | Only accepts sizes bigger or equal than 0", () {
    expect(() => Config(size: -1), throwsAssertionError);
  });

  test("Config | toString()", () {
    var config = Config(size: 10);

    expect(config.toString(), "Config: (size: 10)");
  });

  test("StopwatchRecord | The collection name has to have length bigger than 0", () {
    expect(() => StopwatchRecord(collectionName: "", record: 10), throwsAssertionError);
  });

  test("StopwatchRecord | Simple usage", () {
    StopwatchRecord stopwatchRecord = StopwatchRecord(collectionName: "list", record: 10);

    expect(stopwatchRecord.collectionName, "list");
    expect(stopwatchRecord.record, 10);
  });

  test("StopwatchRecord | == operator", () {
    StopwatchRecord listRecord1 = StopwatchRecord(collectionName: "list", record: 10),
        listRecord3 = StopwatchRecord(collectionName: "list", record: 11),
        iListRecord1 = StopwatchRecord(collectionName: "ilist", record: 11),
        iListRecord2 = StopwatchRecord(collectionName: "ilist", record: 10);
    final StopwatchRecord listRecord2 = StopwatchRecord(collectionName: "list", record: 10);

    expect(listRecord1, listRecord2);
    expect(listRecord1, isNot(listRecord3));
    expect(listRecord1, isNot(iListRecord1));
    expect(listRecord1, isNot(iListRecord2));
  });

  test("StopwatchRecord | toString()", () {
    StopwatchRecord record = StopwatchRecord(collectionName: "list", record: 10);

    expect(record.toString(), "StopwatchRecord: (collectionName: list, record: 10.0)");
  });

  test("RecordsColumn | Empty initialization", () {
    final RecordsColumn recordsColumn = RecordsColumn.empty();

    expect(recordsColumn.records, allOf(isA<List<StopwatchRecord>>(), isEmpty));
  });

  test("RecordsColumn | Title cannot be null nor have length equal to zero", () {
    expect(() => RecordsColumn.empty(title: ""), throwsAssertionError);
  });

  test("RecordsColumn | Adding a record", () {
    final RecordsColumn recordsColumn = RecordsColumn.empty();
    StopwatchRecord record = StopwatchRecord(collectionName: "list", record: 10);

    final RecordsColumn newColumn = recordsColumn + record;

    expect(
        newColumn.records,
        allOf(<StopwatchRecord>[StopwatchRecord(collectionName: "list", record: 10)].lock,
            isNotEmpty));
  });

  test("RecordsColumn | Extracting the column's maximum value", () {
    RecordsColumn recordsColumn = RecordsColumn.empty();
    recordsColumn += StopwatchRecord(collectionName: "list", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "ilist", record: 11);
    recordsColumn += StopwatchRecord(collectionName: "ktList", record: 100);
    recordsColumn += StopwatchRecord(collectionName: "builtList", record: 50);

    expect(recordsColumn.max, 100);
  });

  test("RecordsColumn | Extracting the column's minimum value", () {
    RecordsColumn recordsColumn = RecordsColumn.empty();
    recordsColumn += StopwatchRecord(collectionName: "list", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "ilist", record: 11);
    recordsColumn += StopwatchRecord(collectionName: "ktList", record: 100);
    recordsColumn += StopwatchRecord(collectionName: "builtList", record: 50);

    expect(recordsColumn.min, 10);
  });

  test("RecordsColumn | Extracting the column's List's value", () {
    RecordsColumn recordsColumn = RecordsColumn.empty();
    recordsColumn += StopwatchRecord(collectionName: "list (mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "ilist", record: 11);

    expect(recordsColumn.mutableRecord, 10);
  });

  test("RecordsColumn | == operator", () {
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

  test("RecordsColumn | toString()", () {
    RecordsColumn recordsColumn = RecordsColumn.empty();
    recordsColumn += StopwatchRecord(collectionName: "list", record: 10);

    expect(recordsColumn.toString(),
        "RecordsColumn: [StopwatchRecord: (collectionName: list, record: 10.0)]");
  });

  test("RecordsColumn | Names of each row", () {
    RecordsColumn recordsColumn = RecordsColumn.empty();
    recordsColumn += StopwatchRecord(collectionName: "list (mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "ilist", record: 11);
    recordsColumn += StopwatchRecord(collectionName: "builtList", record: 11);

    expect(recordsColumn.rowNames, ["list (mutable)", "ilist", "builtList"]);
  });

  test("RecordsColumn | Filter", () {
    RecordsColumn recordsColumn = RecordsColumn.empty();
    recordsColumn += StopwatchRecord(collectionName: "list (mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "ilist", record: 11);
    recordsColumn += StopwatchRecord(collectionName: "builtList", record: 11);

    RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
    recordsColumnAnswer += StopwatchRecord(collectionName: "list (mutable)", record: 10);
    recordsColumnAnswer += StopwatchRecord(collectionName: "ilist", record: 11);

    expect(recordsColumn.filter("builtList"), recordsColumnAnswer);
  });

  test("LeftLegend | The rows contain all of the collection names", () {
    RecordsColumn recordsColumn = RecordsColumn.empty();
    recordsColumn += StopwatchRecord(collectionName: "List (Mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "IList", record: 11);

    final LeftLegend leftLegend = LeftLegend(results: recordsColumn);

    expect(leftLegend.rows, ["Collection", "List (Mutable)", "IList"]);
  });

  test("RecordsTable | Left, legend column", () {
    RecordsColumn recordsColumn = RecordsColumn.empty(title: "Time (μs)");
    recordsColumn += StopwatchRecord(collectionName: "List (Mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "IList", record: 15);
    recordsColumn += StopwatchRecord(collectionName: "KtList", record: 20);
    recordsColumn += StopwatchRecord(collectionName: "BuiltList", record: 30);

    final RecordsTable recordsTable =
        RecordsTable(resultsColumn: recordsColumn, config: Config(size: 1000));

    expect(recordsTable.leftLegend, isA<LeftLegend>());
    expect(recordsTable.leftLegend.rows,
        ["Collection", "List (Mutable)", "IList", "KtList", "BuiltList"]);
  });

  test("RecordsTable | Normalized against max Column", () {
    RecordsColumn recordsColumn = RecordsColumn.empty(title: "Time (μs)");
    recordsColumn += StopwatchRecord(collectionName: "List (Mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "IList", record: 15);
    recordsColumn += StopwatchRecord(collectionName: "KtList", record: 20);
    recordsColumn += StopwatchRecord(collectionName: "BuiltList", record: 30);

    final RecordsTable recordsTable =
        RecordsTable(resultsColumn: recordsColumn, config: Config(size: 1000));

    RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
    recordsColumnAnswer += StopwatchRecord(collectionName: "List (Mutable)", record: .33);
    recordsColumnAnswer += StopwatchRecord(collectionName: "IList", record: .5);
    recordsColumnAnswer += StopwatchRecord(collectionName: "KtList", record: .67);
    recordsColumnAnswer += StopwatchRecord(collectionName: "BuiltList", record: 1);

    expect(recordsTable.normalizedAgainstMax, recordsColumnAnswer);
    expect(recordsTable.normalizedAgainstMax.title, "x Max Time");
  });

  test("RecordsTable | Normalized against min column", () {
    RecordsColumn recordsColumn = RecordsColumn.empty(title: "Time (μs)");
    recordsColumn += StopwatchRecord(collectionName: "List (Mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "IList", record: 15);
    recordsColumn += StopwatchRecord(collectionName: "KtList", record: 20);
    recordsColumn += StopwatchRecord(collectionName: "BuiltList", record: 30);

    final RecordsTable recordsTable =
        RecordsTable(resultsColumn: recordsColumn, config: Config(size: 1000));

    RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
    recordsColumnAnswer += StopwatchRecord(collectionName: "List (Mutable)", record: 1);
    recordsColumnAnswer += StopwatchRecord(collectionName: "IList", record: 1.5);
    recordsColumnAnswer += StopwatchRecord(collectionName: "KtList", record: 2);
    recordsColumnAnswer += StopwatchRecord(collectionName: "BuiltList", record: 3);

    expect(recordsTable.normalizedAgainstMin, recordsColumnAnswer);
    expect(recordsTable.normalizedAgainstMin.title, "x Min Time");
  });

  test("RecordsTable | Normalized against the mutable result", () {
    RecordsColumn recordsColumn = RecordsColumn.empty(title: "Time (μs)");
    recordsColumn += StopwatchRecord(collectionName: "List (Mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "IList", record: 15);
    recordsColumn += StopwatchRecord(collectionName: "KtList", record: 20);
    recordsColumn += StopwatchRecord(collectionName: "BuiltList", record: 30);

    final RecordsTable recordsTable =
        RecordsTable(resultsColumn: recordsColumn, config: Config(size: 1000));

    RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
    recordsColumnAnswer += StopwatchRecord(collectionName: "List (Mutable)", record: 1);
    recordsColumnAnswer += StopwatchRecord(collectionName: "IList", record: 1.5);
    recordsColumnAnswer += StopwatchRecord(collectionName: "KtList", record: 2);
    recordsColumnAnswer += StopwatchRecord(collectionName: "BuiltList", record: 3);

    expect(recordsTable.normalizedAgainstMutable, recordsColumnAnswer);
    expect(recordsTable.normalizedAgainstMutable.title, "x Mutable Time");
  });

  test("RecordsTable | Normalized against size", () {
    RecordsColumn recordsColumn = RecordsColumn.empty(title: "Time (μs)");
    recordsColumn += StopwatchRecord(collectionName: "List (Mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "IList", record: 15);
    recordsColumn += StopwatchRecord(collectionName: "KtList", record: 20);
    recordsColumn += StopwatchRecord(collectionName: "BuiltList", record: 30);

    final RecordsTable recordsTable =
        RecordsTable(resultsColumn: recordsColumn, config: Config(size: 1000));

    RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
    recordsColumnAnswer += StopwatchRecord(collectionName: "List (Mutable)", record: .01);
    recordsColumnAnswer += StopwatchRecord(collectionName: "IList", record: .01);
    recordsColumnAnswer += StopwatchRecord(collectionName: "KtList", record: .02);
    recordsColumnAnswer += StopwatchRecord(collectionName: "BuiltList", record: .03);

    expect(recordsTable.normalizedAgainstSize, recordsColumnAnswer);
    expect(recordsTable.normalizedAgainstSize.title, "Time (μs) / Size");
  });

  test("RecordsTable | toString() (for saving it as CSV)", () {
    RecordsColumn recordsColumn = RecordsColumn.empty(title: "Time (μs)");
    recordsColumn += StopwatchRecord(collectionName: "List (Mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "IList", record: 15);
    recordsColumn += StopwatchRecord(collectionName: "KtList", record: 20);
    recordsColumn += StopwatchRecord(collectionName: "BuiltList", record: 30);

    final RecordsTable recordsTable =
        RecordsTable(resultsColumn: recordsColumn, config: Config(size: 1000));

    const String correctTableAsString =
        "Collection,Time (μs),x Max Time,x Min Time,x Mutable Time,Time (μs) / Size\n"
        "List (Mutable),10.0,0.33,1.0,1.0,0.01\n"
        "IList,15.0,0.5,1.5,1.5,0.01\n"
        "KtList,20.0,0.67,2.0,2.0,0.02\n"
        "BuiltList,30.0,1.0,3.0,3.0,0.03\n";

    expect(recordsTable.toString(), correctTableAsString);
  });

  test("RecordsTable | Filter", () {
    RecordsColumn recordsColumn = RecordsColumn.empty(title: "Time (μs)");
    recordsColumn += StopwatchRecord(collectionName: "List (Mutable)", record: 10);
    recordsColumn += StopwatchRecord(collectionName: "IList", record: 15);
    recordsColumn += StopwatchRecord(collectionName: "KtList", record: 20);
    recordsColumn += StopwatchRecord(collectionName: "BuiltList", record: 30);

    final RecordsTable recordsTable =
        RecordsTable(resultsColumn: recordsColumn, config: Config(size: 1000));

    RecordsColumn recordsColumnAnswer = RecordsColumn.empty();
    recordsColumnAnswer += StopwatchRecord(collectionName: "List (Mutable)", record: .5);
    recordsColumnAnswer += StopwatchRecord(collectionName: "IList", record: .75);
    recordsColumnAnswer += StopwatchRecord(collectionName: "KtList", record: 1);

    final RecordsTable recordsTableFiltered = recordsTable.filter("BuiltList");

    expect(recordsTableFiltered.normalizedAgainstMax, recordsColumnAnswer);
  });
}
