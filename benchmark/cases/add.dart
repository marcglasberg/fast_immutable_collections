import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart' show BuiltList, ListBuilder;
import 'package:kt_dart/kt.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;
import '../utils/table_score_emitter.dart' show TableScoreEmitter;

// /////////////////////////////////////////////////////////////////////////////////////////////////

class AddBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(reportName: 'list_add');

    _ListAddBenchmark(emitter: tableScoreEmitter).report();
    _IListAddBenchmark(emitter: tableScoreEmitter).report();
    _KtListAddBenchmark(emitter: tableScoreEmitter).report();
    _BuiltListAddBenchmark1(emitter: tableScoreEmitter).report();
    _BuiltListAddBenchmark2(emitter: tableScoreEmitter).report();

    tableScoreEmitter.saveReport();
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _ListAddBenchmark extends ListBenchmarkBase {
  _ListAddBenchmark({ScoreEmitter emitter}) : super('List (Mutable)', emitter: emitter);

  List<int> _list;

  @override
  void setup() => _list = <int>[];

  @override
  void run() {
    for (int i = 0; i < 100; i++) _list.add(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _IListAddBenchmark extends ListBenchmarkBase {
  _IListAddBenchmark({ScoreEmitter emitter}) : super('IList', emitter: emitter);

  IList<int> _iList;

  @override
  void setup() => _iList = IList<int>();

  @override
  void run() {
    for (int i = 0; i < 100; i++) _iList = _iList.add(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _KtListAddBenchmark extends ListBenchmarkBase {
  _KtListAddBenchmark({ScoreEmitter emitter}) : super('KtList', emitter: emitter);

  KtList<int> _ktList;

  @override
  void setup() => _ktList = [].toImmutableList();

  @override
  void run() {
    for (int i = 0; i < 100; i++) _ktList = _ktList.plusElement(1);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddBenchmark1 extends ListBenchmarkBase {
  _BuiltListAddBenchmark1({ScoreEmitter emitter}) : super('BuiltList', emitter: emitter);

  BuiltList<int> _builtList;

  @override
  void setup() => _builtList = BuiltList<int>();

  @override
  void run() {
    for (int i = 0; i < 100; i++)
      _builtList = _builtList.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(i));
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddBenchmark2 extends ListBenchmarkBase {
  _BuiltListAddBenchmark2({ScoreEmitter emitter}) : super('BuiltList', emitter: emitter);

  BuiltList<int> _builtList;

  @override
  void setup() => _builtList = BuiltList<int>();

  @override
  void run() {
    var listBuilder = _builtList.toBuilder();
    for (int i = 0; i < 100; i++) {
      listBuilder.add(i);
    }
    _builtList = listBuilder.build();
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
