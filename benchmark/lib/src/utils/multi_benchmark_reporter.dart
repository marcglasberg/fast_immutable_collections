import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "collection_benchmark_base.dart";
import "config.dart";
import "table_score_emitter.dart";

abstract class MultiBenchmarkReporter<B extends CollectionBenchmarkBase> {
  String prefixName;
  Config config;
  IList<B> benchmarks;
  final TableScoreEmitter emitter;

  MultiBenchmarkReporter({
    this.prefixName,
    this.config,
  }) : emitter = TableScoreEmitter(prefixName: prefixName, config: config);

  void report() => benchmarks.forEach((B benchmark) => benchmark.report());

  void saveReports() => benchmarks.forEach((B benchmark) => benchmark.emitter.saveReport());
}
