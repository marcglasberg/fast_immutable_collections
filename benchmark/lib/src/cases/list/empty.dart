import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';
import '../../utils/table_score_emitter.dart';

class EmptyBenchmark extends MultiBenchmarkReporter {
  @override
  void report() {
    const int runs = 10000;

    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_empty');

    final List<ListBenchmarkBase> benchmarks = [
      ListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter),
      IListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter),
      KtListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter),
      BuiltListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter),
    ];

    benchmarks.forEach((ListBenchmarkBase benchmark) => benchmark.report());

    tableScoreEmitters.add(tableScoreEmitter);
  }
}

class ListEmptyBenchmark extends ListBenchmarkBase {
  ListEmptyBenchmark({
    @required int runs,
    @required ScoreEmitter emitter,
  }) : super('List (Mutable)', runs: runs, size: 0, emitter: emitter);

  List<int> _list;

  @override
  List<int> toList() => _list;

  @override
  void run() => _list = <int>[];
}

class IListEmptyBenchmark extends ListBenchmarkBase {
  IListEmptyBenchmark({
    @required int runs,
    @required ScoreEmitter emitter,
  }) : super('IList', runs: runs, size: 0, emitter: emitter);

  IList<int> _iList;

  @override
  List<int> toList() => _iList.unlock;

  @override
  void run() => _iList = IList<int>();
}

class KtListEmptyBenchmark extends ListBenchmarkBase {
  KtListEmptyBenchmark({
    @required int runs,
    @required ScoreEmitter emitter,
  }) : super('KtList', runs: runs, size: 0, emitter: emitter);

  KtList<int> _ktList;

  @override
  List<int> toList() => _ktList.asList();

  @override
  void run() => _ktList = KtList<int>.empty();
}

class BuiltListEmptyBenchmark extends ListBenchmarkBase {
  BuiltListEmptyBenchmark({
    @required int runs,
    @required ScoreEmitter emitter,
  }) : super('BuiltList', runs: runs, size: 0, emitter: emitter);

  BuiltList<int> _builtList;

  @override
  List<int> toList() => _builtList.asList();

  @override
  void run() => _builtList = BuiltList<int>();
}
