import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;
import 'package:kt_dart/kt.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';

import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;
import '../utils/table_score_emitter.dart' show TableScoreEmitter;

// /////////////////////////////////////////////////////////////////////////////////////////////////

class AddBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_add');

    int runs = 5000;
    int size = 10;
    _ListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _IListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _KtListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _BuiltListAddBenchmark1(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _BuiltListAddBenchmark2(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();

    runs = 5000;
    size = 1000;
    _ListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _IListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _KtListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _BuiltListAddBenchmark1(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _BuiltListAddBenchmark2(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();

    runs = 5000;
    size = 100000;
    _ListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _IListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _KtListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _BuiltListAddBenchmark1(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();
    _BuiltListAddBenchmark2(runs: runs, size: size, emitter: tableScoreEmitter)
        .report();

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
    list.add(345);
    list.add(567);
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
  IList<int> result;

  @override
  void setup() {
    iList = IList<int>();
    for (int i = 0; i < size; i++) iList = iList.add(i);
  }

  @override
  void run() {
    result = iList.add(123).add(345).add(567);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _KtListAddBenchmark extends ListBenchmarkBase {
  _KtListAddBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('KtList $size', runs: runs, size: size, emitter: emitter);

  KtList<int> ktList;
  KtList<int> result;

  @override
  void setup() {
    var list = <int>[];
    for (int i = 0; i < size; i++) list.add(i);
    ktList = list.toImmutableList();
  }

  @override
  void run() {
    result = ktList.plusElement(123).plusElement(345).plusElement(567);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddBenchmark1 extends ListBenchmarkBase {
  _BuiltListAddBenchmark1({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('BuiltList1 $size', runs: runs, size: size, emitter: emitter);

  BuiltList<int> builtList;
  BuiltList<int> result;

  @override
  void setup() {
    var list = <int>[];
    for (int i = 0; i < size; i++) list.add(i);
    builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    result = builtList
        .rebuild((ListBuilder<int> listBuilder) => listBuilder.add(123))
        .rebuild((ListBuilder<int> listBuilder) => listBuilder.add(345))
        .rebuild((ListBuilder<int> listBuilder) => listBuilder.add(678));
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddBenchmark2 extends ListBenchmarkBase {
  static const innerRuns = 50;

  _BuiltListAddBenchmark2({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('BuiltList2 $size',
            runs: runs ~/ innerRuns, size: size, emitter: emitter);

  BuiltList<int> builtList;
  BuiltList<int> result;

  @override
  void setup() {
    var list = <int>[];
    for (int i = 0; i < size; i++) list.add(i);
    builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    ListBuilder<int> listBuilder = builtList.toBuilder();
    for (int i = 0; i < innerRuns; i++) listBuilder.add(123);
    result = listBuilder.build();
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
