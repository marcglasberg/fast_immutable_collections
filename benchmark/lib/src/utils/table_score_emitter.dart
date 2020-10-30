import "dart:io";
import "dart:math";

import "package:benchmark_harness/benchmark_harness.dart";
import "package:meta/meta.dart";
import "package:path/path.dart" as p;

import "config.dart";

class TableScoreEmitter implements ScoreEmitter {
  final String _prefixName;
  final Config _config;
  final Map<String, double> _stopwatchRecords = {};

  Map<String, double> get scores => _stopwatchRecords;

  TableScoreEmitter({@required String prefixName, Config config})
      : _prefixName = prefixName,
        _config = config;

  @override
  void emit(String testName, double time) => _stopwatchRecords[testName] = time;

  /// You can't get the [table] before the benchmarks have finished because all
  /// data is needed to build it.
  Map<String, Map<String, double>> get table {
    final Map<String, Map<String, double>> completeTable = {};

    completeTable["scores"] = _stopwatchRecords;
    completeTable["normalized"] = _normalizedAgainstMax;
    completeTable["normalizedAgainstList"] = _normalizedAgainstList;
    completeTable["normalizedAgainstRuns"] = _normalizedAgainstRuns;

    return completeTable;
  }

  String get tableAsString {
    final Map<String, Map<String, double>> completeTable = table;

    const String mu = "\u{03BC}";
    String report = "Data Object,"
        "Time (${mu}s),"
        "x Max Time,"
        "x Mutable List Time,"
        "Time (${mu}s) / Run"
        "\n";
    _stopwatchRecords.forEach((String testName, double score) => report += "$testName,"
        "${score.toStringAsFixed(0).toString()},"
        "${completeTable["normalized"][testName].toString()},"
        "${completeTable["normalizedAgainstList"][testName].toString()},"
        "${completeTable["normalizedAgainstRuns"][testName].toString()}"
        "\n");

    return report;
  }

  Map<String, double> get _normalizedAgainstRuns {
    final Map<String, double> normalizedColumn = {};
    final double maxScore = _maxScore();

    _stopwatchRecords.forEach((String testName, double score) =>
        normalizedColumn[testName] = double.parse((score / maxScore).toStringAsFixed(2)));

    return normalizedColumn;
  }

  double _maxScore() => _stopwatchRecords.values.toList().reduce(max);

  Map<String, double> get _normalizedAgainstMax {
    final Map<String, double> normalizedColumn = {};
    final double maxScore = _maxScore();

    _stopwatchRecords.forEach((String testName, double score) =>
        normalizedColumn[testName] = double.parse((score / maxScore).toStringAsFixed(2)));

    return normalizedColumn;
  }

  Map<String, double> get _normalizedAgainstList {
    final Map<String, double> normalizedAgainstListColumn = {};
    final double listScore =
        _stopwatchRecords[_stopwatchRecords.keys.firstWhere((String key) => key.toLowerCase().contains("mutable"))];

    _stopwatchRecords.forEach((String testName, double score) => normalizedAgainstListColumn[testName] =
        double.parse((score / listScore).toStringAsFixed(2)));

    return normalizedAgainstListColumn;
  }

  void saveReport() {
    _createReportsFolderIfNonExistent();

    final String fileName = "${_prefixName}_runs_${_config.runs}_size_${_config.size}";
    final File reportFile = File("benchmark/reports/$fileName.csv");

    reportFile.writeAsStringSync(tableAsString);
  }

  void _createReportsFolderIfNonExistent() {
    final Directory reportsDir = Directory(p.join(p.current, "benchmark", "reports"));
    if (!reportsDir.existsSync()) reportsDir.createSync();
  }

  @override
  String toString() => "Table Score Emitter: ${_stopwatchRecords.toString()}";
}
