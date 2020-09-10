import 'dart:io' show File;

import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;

class ListScoreEmitter implements ScoreEmitter {
  final String _reportName;

  final Map<String, double> scores = {};

  ListScoreEmitter({String reportName}) : _reportName = reportName;

  @override
  void emit(String testName, double value) => scores[testName] = value;

  void scoreReport() {
    final File reportFile = File('benchmark/reports/$_reportName.csv');
    String report = 'Data Object,Time (${_mu}s)\n';
    scores.forEach((String testName, double score) =>
        report += '$testName,${score.toString()}\n');
    reportFile.writeAsStringSync(report);
  }

  static const String _mu = '\u{03BC}';
}