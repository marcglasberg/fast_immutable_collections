import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

/// Run the benchmarks with, for example — from the top of the project —:
///
/// ```sh
/// dart benchmark/lib/src/benchmarks.dart
/// ```
///
/// The complete benchmark run should take around 7-10 min on a good computer at most, depending on
/// the parameters.
void main() {
  ListAddBenchmark(emitter: TableScoreEmitter(prefixName: "list_add", config: Config(size: 100)))
    ..report()
    ..saveReports();
  ListAddAllBenchmark(
      emitter: TableScoreEmitter(prefixName: "list_add_all", config: Config(size: 100)))
    ..report()
    ..saveReports();
  ListContainsBenchmark(
      emitter: TableScoreEmitter(prefixName: "list_contains", config: Config(size: 100)))
    ..report()
    ..saveReports();
  ListEmptyBenchmark(
      emitter: TableScoreEmitter(prefixName: "list_empty", config: Config(size: 100)))
    ..report()
    ..saveReports();
  ListReadBenchmark(emitter: TableScoreEmitter(prefixName: "list_read", config: Config(size: 100)))
    ..report()
    ..saveReports();
  ListRemoveBenchmark(
      emitter: TableScoreEmitter(prefixName: "list_remove", config: Config(size: 100)))
    ..report()
    ..saveReports();

  SetAddBenchmark(emitter: TableScoreEmitter(prefixName: "set_add", config: Config(size: 100)))
    ..report()
    ..saveReports();
  SetAddAllBenchmark(
      emitter: TableScoreEmitter(prefixName: "set_add_all", config: Config(size: 100)))
    ..report()
    ..saveReports();
  SetContainsBenchmark(
      emitter: TableScoreEmitter(prefixName: "set_contains", config: Config(size: 100)))
    ..report()
    ..saveReports();
  SetEmptyBenchmark(emitter: TableScoreEmitter(prefixName: "set_empty", config: Config(size: 100)))
    ..report()
    ..saveReports();
  SetRemoveBenchmark(
      emitter: TableScoreEmitter(prefixName: "set_remove", config: Config(size: 100)))
    ..report()
    ..saveReports();

  MapAddBenchmark(emitter: TableScoreEmitter(prefixName: "map_add", config: Config(size: 500)))
    ..report()
    ..saveReports();
  MapAddAllBenchmark(
      emitter: TableScoreEmitter(prefixName: "map_add_all", config: Config(size: 10)))
    ..report()
    ..saveReports();
  MapContainsValueBenchmark(
      emitter: TableScoreEmitter(prefixName: "map_contains_value", config: Config(size: 10)))
    ..report()
    ..saveReports();
  MapEmptyBenchmark(emitter: TableScoreEmitter(prefixName: "map_empty", config: Config(size: 0)))
    ..report()
    ..saveReports();
  MapReadBenchmark(emitter: TableScoreEmitter(prefixName: "map_read", config: Config(size: 1000)))
    ..report()
    ..saveReports();
  MapRemoveBenchmark(
      emitter: TableScoreEmitter(prefixName: "map_remove", config: Config(size: 1000)))
    ..report()
    ..saveReports();
}
