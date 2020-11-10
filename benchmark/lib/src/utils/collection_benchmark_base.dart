import "package:benchmark_harness/benchmark_harness.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "records.dart";
import "table_score_emitter.dart";

abstract class MultiBenchmarkReporter<B extends CollectionBenchmarkBase> {
  final TableScoreEmitter emitter;

  @visibleForOverriding
  IList<B> benchmarks;

  MultiBenchmarkReporter({@required this.emitter});

  void report() => benchmarks.forEach((B benchmark) => benchmark.report());

  void saveReports() => benchmarks.forEach((B benchmark) => benchmark.emitter.saveReport());
}

abstract class CollectionBenchmarkBase<T> extends BenchmarkBase {
  @override
  final TableScoreEmitter emitter;

  const CollectionBenchmarkBase({
    @required String name,
    @required this.emitter,
  }) : super(name);

  Config get config => emitter.config;

  @override
  void exercise() {
    for (int i = 0; i < config.runs; i++) run();
  }

  /// This will be important for later checking if the resulting mutable
  /// collection processed by the benchmark is indeed the one we expected (TDD).
  @visibleForTesting
  @visibleForOverriding
  T toMutable();
}

abstract class ListBenchmarkBase extends CollectionBenchmarkBase<List<int>> {
  const ListBenchmarkBase({
    @required String name,
    @required TableScoreEmitter emitter,
  }) : super(name: name, emitter: emitter);

  static List<int> getDummyGeneratedList({int size = 10000}) =>
      List<int>.generate(size, (int index) => index);

  @visibleForTesting
  @visibleForOverriding
  @override
  List<int> toMutable();
}

abstract class SetBenchmarkBase extends CollectionBenchmarkBase<Set<int>> {
  const SetBenchmarkBase({
    @required String name,
    @required TableScoreEmitter emitter,
  }) : super(name: name, emitter: emitter);

  static Set<int> getDummyGeneratedSet({int size = 10000}) =>
      Set<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: size));

  @visibleForTesting
  @visibleForOverriding
  @override
  Set<int> toMutable();
}

abstract class MapBenchmarkBase extends CollectionBenchmarkBase<Map<String, int>> {
  const MapBenchmarkBase({
    @required String name,
    @required TableScoreEmitter emitter,
  }) : super(name: name, emitter: emitter);

  static Map<String, int> getDummyGeneratedMap({int size = 10000}) =>
      Map<String, int>.fromEntries(List<MapEntry<String, int>>.generate(
          size, (int index) => MapEntry<String, int>(index.toString(), index)));

  @visibleForTesting
  @visibleForOverriding
  @override
  Map<String, int> toMutable();
}
