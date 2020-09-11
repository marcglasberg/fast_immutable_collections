import 'dart:io' show File;
import 'dart:math' show max;

import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;

class TableScoreEmitter implements ScoreEmitter {
  final String _reportName;
  final Map<String, double> scores = {};

  TableScoreEmitter({String reportName = ''}) : _reportName = reportName;

  @override
  void emit(String testName, double value) => scores[testName] = value;

  void saveReport() {
    final File reportFile = File('benchmark/reports/$_reportName.csv');
    final Map<String, double> normalizedColumn = _normalizedColumn();
    final Map<String, double> normalizedAgainstListColumn =
        _normalizedAgainstListColumn();
    String report = 'Data Object,Time (${_mu}s),Normalized Score,'
        'Normalized Against Mutable List\n';
    scores.forEach((String testName, double score) => report += '$testName,'
        '${score.toString()},'
        '${normalizedColumn[testName].toString()},'
        '${normalizedAgainstListColumn[testName].toString()}\n');
    reportFile.writeAsStringSync(report);
  }

  Map<String, double> _normalizedColumn() {
    final Map<String, double> normalizedColumn = {};
    final double maxScore = scores.values.toList().reduce(max);
    scores.forEach((String testName, double score) =>
        normalizedColumn[testName] =
            double.parse((score / maxScore).toStringAsFixed(2)));
    return normalizedColumn;
  }

  Map<String, double> _normalizedAgainstListColumn() {
    final Map<String, double> normalizedAgainstListColumn = {};
    final double listScore = scores[scores.keys
        .firstWhere((String key) => key.toLowerCase().contains('mutable'))];
    scores.forEach((String testName, double score) =>
        normalizedAgainstListColumn[testName] =
            double.parse((score / listScore).toStringAsFixed(2)));
    return normalizedAgainstListColumn;
  }

  static const String _mu = '\u{03BC}';
}
