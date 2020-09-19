import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;
import 'package:kt_dart/kt.dart' show KtIterableExtensions, KtList, ListInterop;
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;
import 'package:meta/meta.dart' show required;

import '../list_benchmark_base.dart' show ListBenchmarkBase;
import '../table_score_emitter.dart' show TableScoreEmitter;

////////////////////////////////////////////////////////////////////////////////

class AddBenchmark {
  static void report() {
    const List<List<int>> benchmarksConfigurations = [
      [5000, 10],
      [5000, 1000],
      [5000, 100000],
    ];

    benchmarksConfigurations.forEach((List<int> configurations) {
      final int runs = configurations[0], size = configurations[1];

      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(reportName: 'list_add_runs_${runs}_size_${size}');

      _ListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
          .report();
      _IListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
          .report();
      _KtListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
          .report();
      _BuiltListAddWithRebuildBenchmark(
              runs: runs, size: size, emitter: tableScoreEmitter)
          .report();
      _BuiltListAddWithListBuilderBenchmark(
              runs: runs, size: size, emitter: tableScoreEmitter)
          .report();

      tableScoreEmitter.saveReport();
    });
  }
}

////////////////////////////////////////////////////////////////////////////////

class _ListAddBenchmark extends ListBenchmarkBase {
  _ListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('List (Mutable)', runs: runs, size: size, emitter: emitter);

  List<int> list;

  @override
  void setup() => list = ListBenchmarkBase.getDummyGeneratedList(length: size);

  @override
  void run() => list..add(123)..add(345)..add(567);
}

////////////////////////////////////////////////////////////////////////////////

class _IListAddBenchmark extends ListBenchmarkBase {
  _IListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('IList', runs: runs, size: size, emitter: emitter);

  IList<int> iList;
  IList<int> result;

  @override
  void setup() {
    iList = IList<int>();
    for (int i = 0; i < size; i++) iList = iList.add(i);
  }

  @override
  void run() => result = iList.add(123).add(345).add(567);
}

////////////////////////////////////////////////////////////////////////////////

class _KtListAddBenchmark extends ListBenchmarkBase {
  _KtListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('KtList', runs: runs, size: size, emitter: emitter);

  KtList<int> ktList;
  KtList<int> result;

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(length: size);
    ktList = list.toImmutableList();
  }

  @override
  void run() =>
      result = ktList.plusElement(123).plusElement(345).plusElement(567);
}

////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddWithRebuildBenchmark extends ListBenchmarkBase {
  _BuiltListAddWithRebuildBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('BuiltList with Rebuild',
            runs: runs, size: size, emitter: emitter);

  BuiltList<int> builtList;
  BuiltList<int> result;

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(length: size);
    builtList = BuiltList<int>(list);
  }

  @override
  void run() => result = builtList
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.add(123))
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.add(345))
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.add(678));
}

////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddWithListBuilderBenchmark extends ListBenchmarkBase {
  static const int innerRuns = 50;

  _BuiltListAddWithListBuilderBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('BuiltList with List Builder',
            runs: runs ~/ innerRuns, size: size, emitter: emitter);

  BuiltList<int> builtList;
  BuiltList<int> result;

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(length: size);
    builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    final ListBuilder<int> listBuilder = builtList.toBuilder();
    for (int i = 0; i < innerRuns; i++) listBuilder.add(123);
    result = listBuilder.build();
  }
}
