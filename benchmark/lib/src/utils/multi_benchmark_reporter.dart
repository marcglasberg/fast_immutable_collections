import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";

import "collection_benchmark_base.dart";
import "table_score_emitter.dart";

abstract class MultiBenchmarkReporter<B extends CollectionBenchmarkBase> {
  final TableScoreEmitter emitter;

  @visibleForOverriding
  IList<B> benchmarks;

  MultiBenchmarkReporter({@required this.emitter});

  void report() => benchmarks.forEach((B benchmark) => benchmark.report());

  void saveReports() => benchmarks.forEach((B benchmark) => benchmark.emitter.saveReport());
}
