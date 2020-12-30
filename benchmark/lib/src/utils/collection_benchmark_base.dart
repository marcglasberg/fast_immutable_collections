import "dart:math";
import "package:benchmark_harness/benchmark_harness.dart";
import "package:meta/meta.dart";
import "records.dart";
import "table_score_emitter.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

abstract class MultiBenchmarkReporter<B extends CollectionBenchmarkBase> {
  final TableScoreEmitter emitter;

  @visibleForOverriding
  List<B> benchmarks;

  MultiBenchmarkReporter({@required this.emitter});

  void report() => benchmarks.forEach((B benchmark) => benchmark.report());

  void saveReports() => benchmarks.forEach((B benchmark) => benchmark.emitter.saveReport());
}

//////////////////////////////////////////////////////////////////////////////////////////////////

abstract class CollectionBenchmarkBase<T> extends BenchmarkBase {
  @override
  final TableScoreEmitter emitter;

  const CollectionBenchmarkBase({
    @required String name,
    @required this.emitter,
  }) : super(name);

  Config get config => emitter.config;

  /// This will be important for later checking if the resulting mutable
  /// collection processed by the benchmark is indeed the one we expected (TDD).
  @visibleForTesting
  @visibleForOverriding
  T toMutable();

  // Measures the score for the benchmark and returns it.
  @override
  double measure() {
    setup();
    // Warmup for at least 100ms. Discard result.
    BenchmarkBase.measureFor(() {
      warmup();
    }, 100);
    // Run the benchmark for at least 900ms.
    double result = BenchmarkBase.measureFor(() {
      exercise();
    }, 900);
    teardown();
    return result;
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

abstract class ListBenchmarkBase extends CollectionBenchmarkBase<List<int>> {
  ListBenchmarkBase({
    @required String name,
    @required TableScoreEmitter emitter,
  }) : super(name: name, emitter: emitter);

  static List<int> getDummyGeneratedList({@required int size}) =>
      List<int>.generate(size, (int index) => index);

  @visibleForTesting
  @visibleForOverriding
  @override
  List<int> toMutable();

  int _innerRuns;

  /// Inner runs is half of the config.size.
  /// For example, we can measure adding 5 items to a list of 10 items,
  /// or adding 50 items to a list of 100 items.
  int innerRuns() => _innerRuns ??= min(1000, max(1, config.size ~/ 10));
}

//////////////////////////////////////////////////////////////////////////////////////////////////

abstract class SetBenchmarkBase extends CollectionBenchmarkBase<Set<int>> {
  const SetBenchmarkBase({
    @required String name,
    @required TableScoreEmitter emitter,
  }) : super(name: name, emitter: emitter);

  static Set<int> getDummyGeneratedSet({@required int size}) =>
      Set<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: size));

  @visibleForTesting
  @visibleForOverriding
  @override
  Set<int> toMutable();
}

//////////////////////////////////////////////////////////////////////////////////////////////////

abstract class MapBenchmarkBase extends CollectionBenchmarkBase<Map<String, int>> {
  const MapBenchmarkBase({
    @required String name,
    @required TableScoreEmitter emitter,
  }) : super(name: name, emitter: emitter);

  static Map<String, int> getDummyGeneratedMap({@required int size}) =>
      Map<String, int>.fromEntries(List<MapEntry<String, int>>.generate(
          size, (int index) => MapEntry<String, int>(index.toString(), index)));

  @visibleForTesting
  @visibleForOverriding
  @override
  Map<String, int> toMutable();
}

//////////////////////////////////////////////////////////////////////////////////////////////////
