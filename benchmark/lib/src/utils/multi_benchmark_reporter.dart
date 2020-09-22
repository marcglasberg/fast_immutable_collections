import 'list_benchmark_base.dart';
import 'table_score_emitter.dart';

abstract class MultiBenchmarkReporter {
  final List<TableScoreEmitter> tableScoreEmitters = [];

  void report();

  void save() => tableScoreEmitters.forEach(
      (TableScoreEmitter tableScoreEmitter) => tableScoreEmitter.saveReport());
}

abstract class MultiBenchmarkReporter2 {
  final List<ListBenchmarkBase2> benchmarks = [];

  List<Config> configs;

  void configure();

  void report() =>
      benchmarks.forEach((ListBenchmarkBase2 benchmark) => benchmark.report());

  void save() => benchmarks.forEach((ListBenchmarkBase2 benchmark) =>
      (benchmark.emitter as TableScoreEmitter).saveReport());
}
