import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;
import 'package:kt_dart/collection.dart' show KtList;

import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;
import '../utils/table_score_emitter.dart' show TableScoreEmitter;

const int _indexToRead = 100;

class ReadBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_read');

    _ListReadBenchmark(emitter: tableScoreEmitter).report();
    _IListReadBenchmark(emitter: tableScoreEmitter).report();
    _KtListReadBenchmark(emitter: tableScoreEmitter).report();
    _BuiltListReadBenchmark(emitter: tableScoreEmitter).report();

    tableScoreEmitter.saveReport();
  }
}

class _ListReadBenchmark extends ListBenchmarkBase {
  _ListReadBenchmark({ScoreEmitter emitter})
      : super('List (Mutable)', emitter: emitter);

  List<int> _list;

  @override
  void setup() => _list = ListBenchmarkBase.getDummyList();

  @override
  void run() => _list[_indexToRead];
}

class _IListReadBenchmark extends ListBenchmarkBase {
  _IListReadBenchmark({ScoreEmitter emitter})
      : super('IList', emitter: emitter);

  IList<int> _iList;

  @override
  void setup() => _iList = IList<int>(ListBenchmarkBase.getDummyList());

  @override
  void run() => _iList[_indexToRead];
}

class _KtListReadBenchmark extends ListBenchmarkBase {
  _KtListReadBenchmark({ScoreEmitter emitter})
      : super('KtList', emitter: emitter);

  KtList<int> _ktList;

  @override
  void setup() => _ktList = KtList<int>.from(ListBenchmarkBase.getDummyList());

  @override
  void run() => _ktList[_indexToRead];
}

class _BuiltListReadBenchmark extends ListBenchmarkBase {
  _BuiltListReadBenchmark({ScoreEmitter emitter})
      : super('BuiltList', emitter: emitter);

  BuiltList<int> _builtList;

  @override
  void setup() => _builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyList());

  @override
  void run() => _builtList[_indexToRead];
}
