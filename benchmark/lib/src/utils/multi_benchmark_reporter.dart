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

  /// Specify the basic forms &mdash; e.g. with `null`s &mdash; of your
  /// benchmarks and the [configure] method will reconfigure them with the
  /// [configs].
  List<ListBenchmarkBase2> get baseBenchmarks;

  String prefixName;
  List<Config> configs;

  MultiBenchmarkReporter2() {
    configure();
  }

  void configure() {
    configs.forEach((Config config) {
      final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(
          reportName: '${prefixName}_runs_${config.runs}_size_${config.size}');

      baseBenchmarks.forEach((ListBenchmarkBase2 baseBenchmark) =>
          benchmarks.add(
            baseBenchmark.reconfigure(
              newConfig: config, newEmitter: tableScoreEmitter)));
    });
  }

  void report() =>
      benchmarks.forEach((ListBenchmarkBase2 benchmark) => benchmark.report());

  void save() => benchmarks.forEach((ListBenchmarkBase2 benchmark) =>
      (benchmark.emitter as TableScoreEmitter).saveReport());
}
