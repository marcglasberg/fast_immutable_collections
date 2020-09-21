import 'table_score_emitter.dart';

abstract class BenchmarkReporter {
  final List<TableScoreEmitter> tableScoreEmitters = [];

  void report();

  void save() => tableScoreEmitters.forEach(
      (TableScoreEmitter tableScoreEmitter) => tableScoreEmitter.saveReport());
}
