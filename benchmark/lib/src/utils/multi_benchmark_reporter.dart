import "collection_benchmark_base.dart";
import "config.dart";
import "table_score_emitter.dart";

abstract class MultiBenchmarkReporter<B extends CollectionBenchmarkBase> {
  final List<B> benchmarks = [];

  /// Specify the basic forms &mdash; e.g. with `null`s &mdash; of your
  /// benchmarks and the [configure] method will reconfigure them with the
  /// [Config]s.
  List<B> get baseBenchmarks;

  String prefixName;
  List<Config> configs;

  MultiBenchmarkReporter() {
    configure();
  }

  void configure() {
    configs.forEach((Config config) {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: prefixName, config: config);

      baseBenchmarks.forEach((B baseBenchmark) => benchmarks
          .add(baseBenchmark.reconfigure(newConfig: config, newEmitter: tableScoreEmitter)));
    });
  }

  void report() => benchmarks.forEach((B benchmark) => benchmark.report());

  void save() =>
      benchmarks.forEach((B benchmark) => (benchmark.emitter as TableScoreEmitter).saveReport());
}
