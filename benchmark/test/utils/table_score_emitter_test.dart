import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("TableScoreEmitter.emit adds values to the TableScoreEmitter.table", () {
    const Config config = Config(size: 100);

    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "report", config: config);

    tableScoreEmitter.emit("List (Mutable)", 10);
    tableScoreEmitter.emit("Collection1", 1);

    expect(tableScoreEmitter.table.resultsColumn.records, [
      StopwatchRecord(collectionName: "List (Mutable)", record: 10),
      StopwatchRecord(collectionName: "Collection1", record: 1),
    ]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("TableScoreEmitter.toString method", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "report", config: Config(size: 10));

    tableScoreEmitter.emit("Test1", 5);

    expect(tableScoreEmitter.toString(),
        "Table Score Emitter: RecordsColumn: [StopwatchRecord: (collectionName: Test1, record: 5.0)]");
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}
