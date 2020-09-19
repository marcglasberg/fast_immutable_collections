import 'table_score_emitter.dart' show TableScoreEmitter;

abstract class BenchmarkReporter {
  final List<TableScoreEmitter> tableScoreEmitters = [];

  void report();

  void save() => tableScoreEmitters.forEach(
      (TableScoreEmitter tableScoreEmitter) => tableScoreEmitter.saveReport());
}
