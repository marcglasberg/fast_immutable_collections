import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart' show BuiltList, ListBuilder;
import 'package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart';
import 'package:kt_dart/kt.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';
import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;

// /////////////////////////////////////////////////////////////////////////////////////////////////

int innerRuns = 300;

class AddBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(reportName: 'list_add');

    int runs = 5000;
    int size = 10;
    var r1 = _ListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter).report();
    var r2 = _IListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter).report();
    var r3 = _KtListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter).report();
    var r4 = _BuiltListAddBenchmark1(runs: runs, size: size, emitter: tableScoreEmitter).report();
    var r5 = _BuiltListAddBenchmark2(runs: runs, size: size, emitter: tableScoreEmitter).report();
    expect(r1, r2);
    expect(r1, r3);
    expect(r1, r4);
    expect(r1, r5);

    runs = 5000;
    size = 1000;
    _ListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter).report();
    _IListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter).report();
    _KtListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter).report();
    _BuiltListAddBenchmark1(runs: runs, size: size, emitter: tableScoreEmitter).report();
    _BuiltListAddBenchmark2(runs: runs, size: size, emitter: tableScoreEmitter).report();

    runs = 5000;
    size = 100000;
    _ListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter).report();
    _IListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter).report();
    _KtListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter).report();
    _BuiltListAddBenchmark1(runs: runs, size: size, emitter: tableScoreEmitter).report();
    _BuiltListAddBenchmark2(runs: runs, size: size, emitter: tableScoreEmitter).report();

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
  List toList() => list;

  @override
  void setup() {
    list = <int>[];
    for (int i = 0; i < size; i++) list.add(i);
  }

  @override
  void run() {
    list.clear();
    for (int i = 0; i < innerRuns; i++) list.add(i);
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
  List toList() => result.unlock;

  @override
  void setup() {
    iList = IList<int>();
    for (int i = 0; i < size; i++) iList = iList.add(i);
  }

  @override
  void run() {
    result = iList;
    for (int i = 0; i < innerRuns; i++) result = result.add(i);
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
  List toList() => result.asList();

  @override
  void setup() {
    var list = <int>[];
    for (int i = 0; i < size; i++) list.add(i);
    ktList = list.toImmutableList();
  }

  @override
  void run() {
    result = ktList;
    for (int i = 0; i < innerRuns; i++) result = result.plusElement(i);
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
    result = builtList;
    for (int i = 0; i < innerRuns; i++)
      result = result.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(i));
  }

  @override
  List toList() => result.asList();
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddBenchmark2 extends ListBenchmarkBase {
  _BuiltListAddBenchmark2({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('BuiltList2 $size', runs: runs ~/ innerRuns, size: size, emitter: emitter);

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
    for (int i = 0; i < innerRuns; i++) listBuilder.add(i);
    result = listBuilder.build();
  }

  @override
  List toList() => result.asList();
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
