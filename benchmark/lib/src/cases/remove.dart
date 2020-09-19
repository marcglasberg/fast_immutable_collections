import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;
import 'package:kt_dart/collection.dart' show KtList, KtIterableExtensions;
import 'package:meta/meta.dart' show required;

import '../utils/benchmark_reporter.dart' show BenchmarkReporter;
import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;
import '../utils/table_score_emitter.dart' show TableScoreEmitter;

class RemoveBenchmark extends BenchmarkReporter{
  @override
  void report() {
    const List<int> benchmarksConfigurations = [100, 10000, 100000];

    benchmarksConfigurations.forEach((int runs) {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(reportName: 'list_remove_runs_$runs');

      _ListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter).report();
      _IListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter).report();
      _KtListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter).report();
      _BuiltListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter)
          .report();

      tableScoreEmitters.add(tableScoreEmitter);
    });
  }
}

class _ListRemoveBenchmark extends ListBenchmarkBase {
  _ListRemoveBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('List (Mutable)', runs: runs, size: 0, emitter: emitter);

  List<int> _list;

  @override
  void setup() => _list = ListBenchmarkBase.getDummyGeneratedList();

  @override
  void run() => _list.remove(1);
}

class _IListRemoveBenchmark extends ListBenchmarkBase {
  _IListRemoveBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('IList', runs: runs, size: 0, emitter: emitter);

  IList<int> _iList;

  @override
  void setup() =>
      _iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList());

  @override
  void run() => _iList = _iList.remove(1);
}

class _KtListRemoveBenchmark extends ListBenchmarkBase {
  _KtListRemoveBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('KtList', runs: runs, size: 0, emitter: emitter);

  KtList<int> _ktList;

  @override
  void setup() =>
      _ktList = KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList());

  /// `_ktList.asList()` gives back an unmodifiable list, so we need `List.of`
  /// to remove an item.
  @override
  void run() => _ktList = _ktList.minusElement(1);
}

class _BuiltListRemoveBenchmark extends ListBenchmarkBase {
  _BuiltListRemoveBenchmark(
      {@required int runs, @required ScoreEmitter emitter})
      : super('BuiltList', runs: runs, size: 0, emitter: emitter);

  BuiltList<int> _builtList;

  @override
  void setup() =>
      _builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList());

  @override
  void run() => _builtList = _builtList
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.remove(1));
}
