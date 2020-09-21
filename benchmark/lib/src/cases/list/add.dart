import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import '../../utils/benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';
import '../../utils/table_score_emitter.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

const int innerRuns = 300;

class AddBenchmark extends BenchmarkReporter {
  @override
  void report() {
    const List<List<int>> benchmarksConfigurations = [
      [5000, 10],
      [5000, 1000],
      [5000, 100000],
    ];

    benchmarksConfigurations.forEach((List<int> configurations) {
      final int runs = configurations[0], size = configurations[1];

      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(reportName: 'list_add_runs_${runs}_size_${size}');

      final List<int> listResult =
          _ListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
              .report();
      final List<int> iListResult =
          _IListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
              .report();
      final List<int> ktListResult = _KtListAddBenchmark(
              runs: runs, size: size, emitter: tableScoreEmitter)
          .report();
      final List<int> builtListWithRebuildResult =
          _BuiltListAddWithRebuildBenchmark(
                  runs: runs, size: size, emitter: tableScoreEmitter)
              .report();
      final List<int> builtListWithListBuilderResult =
          _BuiltListAddWithListBuilderBenchmark(
                  runs: runs, size: size, emitter: tableScoreEmitter)
              .report();

      expect(listResult, iListResult);
      expect(listResult, ktListResult);
      expect(listResult, builtListWithRebuildResult);
      expect(listResult, builtListWithListBuilderResult);

      tableScoreEmitters.add(tableScoreEmitter);
    });
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _ListAddBenchmark extends ListBenchmarkBase {
  _ListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('List (Mutable)', runs: runs, size: size, emitter: emitter);

  List<int> list;

  @override
  List<int> toList() => list;

  @override
  void setup() => list = ListBenchmarkBase.getDummyGeneratedList(length: size);

  @override
  void run() {
    list.clear();
    for (int i = 0; i < innerRuns; i++) list.add(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _IListAddBenchmark extends ListBenchmarkBase {
  _IListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('IList', runs: runs, size: size, emitter: emitter);

  IList<int> iList;
  IList<int> result;

  @override
  List<int> toList() => result.unlock;

  @override
  void setup() {
    iList = IList<int>();
    for (int i = 0; i < size; i++) iList = iList.add(i);
  }

  @override
  void run() {
    result = iList;
    for (int i = 0; i < innerRuns; i++) result = result.add(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _KtListAddBenchmark extends ListBenchmarkBase {
  _KtListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('KtList', runs: runs, size: size, emitter: emitter);

  KtList<int> ktList;
  KtList<int> result;

  @override
  List<int> toList() => result.asList();

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(length: size);
    ktList = list.toImmutableList();
  }

  @override
  void run() {
    result = ktList;
    for (int i = 0; i < innerRuns; i++) result = result.plusElement(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

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
  List<int> toList() => result.asList();

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(length: size);
    builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    result = builtList;
    for (int i = 0; i < innerRuns; i++)
      result =
          result.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(i));
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddWithListBuilderBenchmark extends ListBenchmarkBase {
  _BuiltListAddWithListBuilderBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('BuiltList with List Builder',
            runs: runs, size: size, emitter: emitter);

  BuiltList<int> builtList;
  BuiltList<int> result;

  @override
  List<int> toList() => result.asList();

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(length: size);
    builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    final ListBuilder<int> listBuilder = builtList.toBuilder();
    for (int i = 0; i < innerRuns; i++) listBuilder.add(i);
    result = listBuilder.build();
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
