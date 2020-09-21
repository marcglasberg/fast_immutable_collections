import 'table_score_emitter.dart';

abstract class MultiBenchmarkReporter {
  final List<TableScoreEmitter> tableScoreEmitters = [];

  void report();

  void save() => tableScoreEmitters.forEach(
      (TableScoreEmitter tableScoreEmitter) => tableScoreEmitter.saveReport());
}
