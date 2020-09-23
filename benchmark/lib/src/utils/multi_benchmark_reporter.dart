import 'config.dart';
import 'collection_benchmark_base.dart';
import 'table_score_emitter.dart';

abstract class MultiBenchmarkReporter {
  final List<CollectionBenchmarkBase> benchmarks = [];

  /// Specify the basic forms &mdash; e.g. with `null`s &mdash; of your
  /// benchmarks and the [configure] method will reconfigure them with the
  /// [configs].
  List<CollectionBenchmarkBase> get baseBenchmarks;

  String prefixName;
  List<Config> configs;

  MultiBenchmarkReporter() {
    configure();
  }

  void configure() {
    configs.forEach((Config config) {
      final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(
          reportName: '${prefixName}_runs_${config.runs}_size_${config.size}');

      baseBenchmarks.forEach((CollectionBenchmarkBase baseBenchmark) =>
          benchmarks.add(baseBenchmark.reconfigure(
              newConfig: config, newEmitter: tableScoreEmitter)));
    });
  }

  void report() => benchmarks
      .forEach((CollectionBenchmarkBase benchmark) => benchmark.report());

  void save() => benchmarks.forEach((CollectionBenchmarkBase benchmark) =>
      (benchmark.emitter as TableScoreEmitter).saveReport());
}
