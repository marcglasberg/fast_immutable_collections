import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;
import 'package:kt_dart/collection.dart' show KtList;

import '../list_benchmark_base.dart' show ListBenchmarkBase;
import '../table_score_emitter.dart' show TableScoreEmitter;

class RemoveBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_remove');

    _ListRemoveBenchmark(emitter: tableScoreEmitter).report();
    _IListRemoveBenchmark(emitter: tableScoreEmitter).report();
    _KtListRemoveBenchmark(emitter: tableScoreEmitter).report();
    _BuiltListRemoveBenchmark(emitter: tableScoreEmitter).report();

    tableScoreEmitter.saveReport();
  }
}

List<int> getDummyList() =>
    List.generate(ListBenchmarkBase.totalRuns, (_) => 1);

class _ListRemoveBenchmark extends ListBenchmarkBase {
  _ListRemoveBenchmark({ScoreEmitter emitter})
      : super('List (mutable)', emitter: emitter);

  List<int> _list;

  @override
  void setup() => _list = getDummyList();

  @override
  void run() => _list.remove(1);
}

class _IListRemoveBenchmark extends ListBenchmarkBase {
  _IListRemoveBenchmark({ScoreEmitter emitter})
      : super('IList', emitter: emitter);

  IList<int> _iList;

  @override
  void setup() => _iList = IList(getDummyList());

  @override
  void run() => _iList = _iList.remove(1);
}

class _KtListRemoveBenchmark extends ListBenchmarkBase {
  _KtListRemoveBenchmark({ScoreEmitter emitter})
      : super('KtList', emitter: emitter);

  KtList<int> _ktList;

  @override
  void setup() => _ktList = KtList.from(getDummyList());

  /// `_ktList.asList()` gives back an unmodifiable list, so we need `List.of`
  /// to remove an item.
  @override
  void run() => _ktList = KtList.from(List.of(_ktList.asList())..remove(1));
}

class _BuiltListRemoveBenchmark extends ListBenchmarkBase {
  _BuiltListRemoveBenchmark({ScoreEmitter emitter})
      : super('BuiltList', emitter: emitter);

  BuiltList<int> _builtList;

  @override
  void setup() => _builtList = BuiltList.of(getDummyList());

  @override
  void run() => _builtList
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.remove(1));
}
