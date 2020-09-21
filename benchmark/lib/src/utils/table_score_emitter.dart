import 'dart:io';
import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:path/path.dart' as p;

class TableScoreEmitter implements ScoreEmitter {
  final String _reportName;
  final Map<String, double> _scores = {};

  Map<String, double> get scores => _scores;

  TableScoreEmitter({String reportName = ''}) : _reportName = reportName;

  @override
  void emit(String testName, double value) => _scores[testName] = value;

  String get table {
    final Map<String, double> normalizedColumn = _normalizedColumn(),
        normalizedAgainstListColumn = _normalizedAgainstListColumn();

    const String _mu = '\u{03BC}';
    String report = 'Data Object,Time (${_mu}s),Normalized Score,'
        'Normalized Against Mutable List\n';
    _scores.forEach((String testName, double score) => report += '$testName,'
        '${score.toStringAsFixed(0).toString()},'
        '${normalizedColumn[testName].toString()},'
        '${normalizedAgainstListColumn[testName].toString()}\n');

    return report;
  }

  void saveReport() {
    _createReportsFolderIfNonExistent();

    final File reportFile = File('benchmark/reports/$_reportName.csv');

    reportFile.writeAsStringSync(table);
  }

  void _createReportsFolderIfNonExistent() {
    final Directory reportsDir =
        Directory(p.join(p.current, 'benchmark', 'reports'));
    if (!reportsDir.existsSync()) reportsDir.createSync();
  }

  Map<String, double> _normalizedColumn() {
    final Map<String, double> normalizedColumn = {};
    final double maxScore = _scores.values.toList().reduce(max);

    _scores.forEach((String testName, double score) =>
        normalizedColumn[testName] =
            double.parse((score / maxScore).toStringAsFixed(2)));

    return normalizedColumn;
  }

  Map<String, double> _normalizedAgainstListColumn() {
    final Map<String, double> normalizedAgainstListColumn = {};
    final double listScore = _scores[_scores.keys
        .firstWhere((String key) => key.toLowerCase().contains('mutable'))];

    _scores.forEach((String testName, double score) =>
        normalizedAgainstListColumn[testName] =
            double.parse((score / listScore).toStringAsFixed(2)));

    return normalizedAgainstListColumn;
  }
}
