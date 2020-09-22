import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';
import '../../utils/table_score_emitter.dart';

class RemoveBenchmark extends MultiBenchmarkReporter {
  @override
  void report() {
    const List<int> benchmarksConfigurations = [100, 10000, 100000];

    benchmarksConfigurations.forEach((int runs) {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(reportName: 'list_remove_runs_$runs');

      final List<ListBenchmarkBase> benchmarks = [
        ListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter),
        IListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter),
        KtListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter),
        BuiltListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter),
      ];

      benchmarks.forEach((ListBenchmarkBase benchmark) => benchmark.report());

      tableScoreEmitters.add(tableScoreEmitter);
    });
  }
}

class ListRemoveBenchmark extends ListBenchmarkBase {
  ListRemoveBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('List (Mutable)', runs: runs, size: 0, emitter: emitter);

  List<int> _list;

  @override
  List<int> toList() => _list;

  @override
  void setup() => _list = ListBenchmarkBase.getDummyGeneratedList();

  @override
  void run() => _list.remove(1);
}

class IListRemoveBenchmark extends ListBenchmarkBase {
  IListRemoveBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('IList', runs: runs, size: 0, emitter: emitter);

  IList<int> _iList;

  @override
  List<int> toList() => _iList.unlock;

  @override
  void setup() =>
      _iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList());

  @override
  void run() => _iList = _iList.remove(1);
}

class KtListRemoveBenchmark extends ListBenchmarkBase {
  KtListRemoveBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('KtList', runs: runs, size: 0, emitter: emitter);

  KtList<int> _ktList;

  @override
  List<int> toList() => _ktList.asList();

  @override
  void setup() =>
      _ktList = KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList());

  @override
  void run() => _ktList = _ktList.minusElement(1);
}

class BuiltListRemoveBenchmark extends ListBenchmarkBase {
  BuiltListRemoveBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('BuiltList', runs: runs, size: 0, emitter: emitter);

  BuiltList<int> _builtList;

  @override
  List<int> toList() => _builtList.asList();

  @override
  void setup() =>
      _builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList());

  @override
  void run() => _builtList = _builtList
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.remove(1));
}
