import "dart:io";
import "dart:math";

import "package:benchmark_harness/benchmark_harness.dart";
import "package:meta/meta.dart";
import "package:path/path.dart" as p;

import "config.dart";
import "record_data.dart";

class TableScoreEmitter implements ScoreEmitter {
  final String _prefixName;
  final Config _config;
  RecordsColumn _recordsColumn;

  TableScoreEmitter({@required String prefixName, @required Config config})
      : _prefixName = prefixName,
        _config = config,
        _recordsColumn = RecordsColumn.empty(title: prefixName);

  @override
  void emit(String testName, double time) =>
      _recordsColumn += StopwatchRecord(collectionName: testName, record: time);

  RecordsTable get table => RecordsTable(resultsColumn: _recordsColumn, config: _config);

  String get _tableAsString => table.toString();

  void saveReport() {
    _createReportsFolderIfNonExistent();

    final String fileName = "${_prefixName}_runs_${_config.runs}_size_${_config.size}";
    final File reportFile = File("benchmark/reports/$fileName.csv");

    reportFile.writeAsStringSync(_tableAsString);
  }

  void _createReportsFolderIfNonExistent() {
    final Directory reportsDir = Directory(p.join(p.current, "benchmark", "reports"));
    if (!reportsDir.existsSync()) reportsDir.createSync();
  }

  @override
  String toString() => "Table Score Emitter: ${_recordsColumn.toString()}";
}
