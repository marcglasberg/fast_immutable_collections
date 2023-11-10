import "dart:io";

import "package:benchmark_harness/benchmark_harness.dart";
import "package:path/path.dart" as p;

import "records.dart";

class TableScoreEmitter implements ScoreEmitter {
  final String prefixName;
  final Config config;
  RecordsColumn _recordsColumn;

  TableScoreEmitter({required this.prefixName, required this.config})
      : _recordsColumn = RecordsColumn.empty(title: prefixName);

  @override
  void emit(String testName, double time) =>
      _recordsColumn += StopwatchRecord(collectionName: testName, record: time);

  RecordsTable get table => RecordsTable(resultsColumn: _recordsColumn, config: config);

  String get _tableAsString => table.toString();

  void saveReport() {
    _createReportsFolderIfNonExistent();

    final String fileName = "${prefixName}_size_${config.size}";
    final File reportFile = File("benchmark/reports/$fileName.csv");

    reportFile.writeAsStringSync(_tableAsString);
  }

  void _createReportsFolderIfNonExistent() {
    final Directory reportsDir = Directory(p.join(p.current, "benchmark", "reports"));
    if (!reportsDir.existsSync()) reportsDir.createSync();
  }

  @override
  String toString() => "Table Score Emitter: $_recordsColumn";
}
