import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;
import 'package:kt_dart/collection.dart' show KtList;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

import '../list_benchmark_base.dart' show ListBenchmarkBase;
import '../table_score_emitter.dart' show TableScoreEmitter;

class AddBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_add');

    _IListAddBenchmark(emitter: tableScoreEmitter).report();
    _ListAddBenchmark(emitter: tableScoreEmitter).report();
    _KtListAddBenchmark(emitter: tableScoreEmitter).report();
    _BuiltListAddBenchmark(emitter: tableScoreEmitter).report();

    tableScoreEmitter.saveReport();
  }
}

class _IListAddBenchmark extends ListBenchmarkBase {
  _IListAddBenchmark({ScoreEmitter emitter}) : super('IList', emitter: emitter);

  IList iList = IList<int>();

  @override
  void run() => iList = IList<int>().add(1);
}

class _ListAddBenchmark extends ListBenchmarkBase {
  _ListAddBenchmark({ScoreEmitter emitter})
      : super('List (Mutable)', emitter: emitter);

  List<int> list = [];

  @override
  void run() => list.add(1);
}

class _KtListAddBenchmark extends ListBenchmarkBase {
  _KtListAddBenchmark({ScoreEmitter emitter})
      : super('KtList', emitter: emitter);

  KtList<int> ktList = KtList.empty();

  @override
  void run() => ktList = KtList.from([...ktList.asList(), 1]);
}

class _BuiltListAddBenchmark extends ListBenchmarkBase {
  _BuiltListAddBenchmark({ScoreEmitter emitter})
      : super('BuiltList', emitter: emitter);

  BuiltList<int> builtList = BuiltList();

  @override
  void run() =>
      builtList.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(1));
}
