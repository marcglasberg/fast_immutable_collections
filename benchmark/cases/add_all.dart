import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;
import 'package:kt_dart/collection.dart';

import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;
import '../utils/table_score_emitter.dart' show TableScoreEmitter;

const List<int> _baseList = [1, 2, 3];
const List<int> _listToAdd = [4, 5, 6];

class AddAllBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_add_all');

    _ListAddAllBenchmark(emitter: tableScoreEmitter).report();
    _IListAddAllBenchmark(emitter: tableScoreEmitter).report();
    _KtListAddAllBenchmark(emitter: tableScoreEmitter).report();
    _BuiltListAddAllBenchmark(emitter: tableScoreEmitter).report();

    tableScoreEmitter.saveReport();
  }
}

class _ListAddAllBenchmark extends ListBenchmarkBase {
  _ListAddAllBenchmark({ScoreEmitter emitter})
      : super('List (Mutable)', emitter: emitter);

  List<int> _list;

  @override
  void setup() => _list = List<int>.of(_baseList);

  @override
  void run() => _list.addAll(_listToAdd);
}

class _IListAddAllBenchmark extends ListBenchmarkBase {
  _IListAddAllBenchmark({ScoreEmitter emitter})
      : super('IList', emitter: emitter);

  IList<int> _iList;

  @override
  void setup() => _iList = IList<int>(_baseList);

  @override
  void run() => _iList.addAll(_listToAdd);
}

class _KtListAddAllBenchmark extends ListBenchmarkBase {
  _KtListAddAllBenchmark({ScoreEmitter emitter})
      : super('KtList', emitter: emitter);

  KtList<int> _ktList;

  @override
  void setup() => _ktList = KtList<int>.from(_baseList);

  @override
  void run() =>
      _ktList = KtList.from(List.of(_ktList.asList())..addAll(_listToAdd));
}

class _BuiltListAddAllBenchmark extends ListBenchmarkBase {
  _BuiltListAddAllBenchmark({ScoreEmitter emitter})
      : super('BuiltList', emitter: emitter);

  BuiltList<int> _builtList;

  @override
  void setup() => _builtList = BuiltList<int>.of(_baseList);

  @override
  void run() => _builtList.rebuild(
      (ListBuilder<int> listBuilder) => listBuilder.addAll(_listToAdd));
}
