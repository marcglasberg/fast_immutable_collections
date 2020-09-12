import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart' show BuiltList, ListBuilder;
import 'package:kt_dart/kt.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';

import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;
import '../utils/table_score_emitter.dart' show TableScoreEmitter;

// /////////////////////////////////////////////////////////////////////////////////////////////////

class AddBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(reportName: 'list_add');

    _ListAddBenchmark(runs: 10000, size: 1000, emitter: tableScoreEmitter).report();
    _IListAddBenchmark(runs: 10000, size: 1000, emitter: tableScoreEmitter).report();
    _KtListAddBenchmark(runs: 10000, size: 1000, emitter: tableScoreEmitter).report();
    _BuiltListAddBenchmark1(runs: 10000, size: 1000, emitter: tableScoreEmitter).report();
    _BuiltListAddBenchmark2(runs: 10000, size: 1000, emitter: tableScoreEmitter).report();

    tableScoreEmitter.saveReport();
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _ListAddBenchmark extends ListBenchmarkBase {
  _ListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('List (Mutable) $size', runs: runs, size: size, emitter: emitter);

  List<int> list;

  @override
  void setup() {
    list = <int>[];
    for (int i = 0; i < size; i++) list.add(i);
  }

  @override
  void run() {
    list.add(123);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _IListAddBenchmark extends ListBenchmarkBase {
  _IListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('IList $size', runs: runs, size: size, emitter: emitter);

  IList<int> iList;

  @override
  void setup() {
    iList = IList<int>();
    for (int i = 0; i < size; i++) iList = iList.add(i);
  }

  @override
  void run() {
    iList.add(123);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _KtListAddBenchmark extends ListBenchmarkBase {
  _KtListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('KtList $size', runs: runs, size: size, emitter: emitter);

  KtList<int> _ktList;

  @override
  void setup() {
    var list = <int>[];
    for (int i = 0; i < size; i++) list.add(i);
    _ktList = list.toImmutableList();
  }

  @override
  void run() {
    _ktList = _ktList.plusElement(1);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddBenchmark1 extends ListBenchmarkBase {
  _BuiltListAddBenchmark1({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('BuiltList1 $size', runs: runs, size: size, emitter: emitter);

  BuiltList<int> _builtList;

  @override
  void setup() {
    var list = <int>[];
    for (int i = 0; i < size; i++) list.add(i);
    _builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    _builtList.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(123));
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddBenchmark2 extends ListBenchmarkBase {
  static const innerRuns = 1000;

  _BuiltListAddBenchmark2({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('BuiltList2 $size', runs: runs ~/ innerRuns, size: size, emitter: emitter);

  BuiltList<int> _builtList;

  @override
  void setup() {
    var list = <int>[];
    for (int i = 0; i < size; i++) list.add(i);
    _builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    ListBuilder<int> listBuilder = _builtList.toBuilder();
    for (int i = 0; i < innerRuns; i++) listBuilder.add(123);
    listBuilder.build();
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
