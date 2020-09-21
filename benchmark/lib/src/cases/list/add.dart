import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';
import '../../utils/table_score_emitter.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class AddBenchmark extends MultiBenchmarkReporter {
  static const int innerRuns = 100;

  @override
  void report() {
    const List<List<int>> benchmarksConfigurations = [
      [5000, 10],
      [5000, 100],
      [5000, 1000],
    ];

    benchmarksConfigurations.forEach((List<int> configurations) {
      final int runs = configurations[0], size = configurations[1];

      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(reportName: 'list_add_runs_${runs}_size_${size}');

      final List<ListBenchmarkBase> benchmarks = [
        ListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter),
        IListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter),
        KtListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter),
        BuiltListAddWithRebuildBenchmark(
            runs: runs, size: size, emitter: tableScoreEmitter),
        BuiltListAddWithListBuilderBenchmark(
            runs: runs, size: size, emitter: tableScoreEmitter),
      ];

      benchmarks.forEach((ListBenchmarkBase benchmark) => benchmark.report());

      tableScoreEmitters.add(tableScoreEmitter);
    });
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class ListAddBenchmark extends ListBenchmarkBase {
  ListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('List (Mutable)', runs: runs, size: size, emitter: emitter);

  List<int> _list;
  List<int> _fixedList;

  @override
  List<int> toList() => _list;

  @override
  void setup() =>
      _fixedList = ListBenchmarkBase.getDummyGeneratedList(length: size);

  @override
  void run() {
    _list = List<int>.of(_fixedList);
    for (int i = 0; i < AddBenchmark.innerRuns; i++) _list.add(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class IListAddBenchmark extends ListBenchmarkBase {
  IListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('IList', runs: runs, size: size, emitter: emitter);

  IList<int> _iList;
  IList<int> _result;

  @override
  List<int> toList() => _result.unlock;

  @override
  void setup() {
    _iList = IList<int>();
    for (int i = 0; i < size; i++) _iList = _iList.add(i);
  }

  @override
  void run() {
    _result = _iList;
    for (int i = 0; i < AddBenchmark.innerRuns; i++) _result = _result.add(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class KtListAddBenchmark extends ListBenchmarkBase {
  KtListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('KtList', runs: runs, size: size, emitter: emitter);

  KtList<int> _ktList;
  KtList<int> _result;

  @override
  List<int> toList() => _result.asList();

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(length: size);
    _ktList = list.toImmutableList();
  }

  @override
  void run() {
    _result = _ktList;
    for (int i = 0; i < AddBenchmark.innerRuns; i++)
      _result = _result.plusElement(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltListAddWithRebuildBenchmark extends ListBenchmarkBase {
  BuiltListAddWithRebuildBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('BuiltList with Rebuild',
            runs: runs, size: size, emitter: emitter);

  BuiltList<int> _builtList;
  BuiltList<int> _result;

  @override
  List<int> toList() => _result.asList();

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(length: size);
    _builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    _result = _builtList;
    for (int i = 0; i < AddBenchmark.innerRuns; i++)
      _result =
          _result.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(i));
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltListAddWithListBuilderBenchmark extends ListBenchmarkBase {
  BuiltListAddWithListBuilderBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('BuiltList with List Builder',
            runs: runs, size: size, emitter: emitter);

  BuiltList<int> _builtList;
  BuiltList<int> _result;

  @override
  List<int> toList() => _result.asList();

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(length: size);
    _builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    final ListBuilder<int> listBuilder = _builtList.toBuilder();
    for (int i = 0; i < AddBenchmark.innerRuns; i++) listBuilder.add(i);
    _result = listBuilder.build();
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
