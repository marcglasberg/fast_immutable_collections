import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  group("Table and Scores |", () {
    const Config config = Config(runs: 100, size: 100);

    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "report", config: config);

    tableScoreEmitter.emit("List (Mutable)", 10);
    tableScoreEmitter.emit("Collection1", 1);

    test("TableScoreEmitter.emit adds values to the TableScoreEmitter.scores",
        () => expect(tableScoreEmitter.scores["Collection1"], 1));

    test("Normalized column", () {
      expect(tableScoreEmitter.table["normalized"]["Collection1"], 0.1);
      expect(tableScoreEmitter.table["normalized"]["List (Mutable)"], 1);
    });

    test("Normalized column against the mutable list", () {
      tableScoreEmitter.emit("Collection2", 100);

      expect(tableScoreEmitter.table["normalizedAgainstList"]["Collection2"], 10);
    });

    test("Normalized column against runs (time / runs)", () {
      expect(tableScoreEmitter.table["normalizedAgainstRuns"]["List (Mutable)"], .1);
      expect(tableScoreEmitter.table["normalizedAgainstRuns"]["Collection1"], .01);
      expect(tableScoreEmitter.table["normalizedAgainstRuns"]["Collection2"], 1);
    });
  });

  group("Other stuff |", () {
    final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(prefixName: "report");

    tableScoreEmitter.emit("Test1", 1);

    test("TableScoreEmitter.toString method",
        () => expect(tableScoreEmitter.toString(), "Table Score Emitter: {Test1: 1.0}"));
  });
}
