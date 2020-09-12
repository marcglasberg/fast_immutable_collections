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
    _BuiltListAddBenchmark(emitter: tableScoreEmitter).report();

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
  void run() => _list.add(1);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _IListAddBenchmark extends ListBenchmarkBase {
  _IListAddBenchmark({ScoreEmitter emitter}) : super('IList', emitter: emitter);

  IList<int> _iList;

  @override
  void setup() => _iList = IList<int>();

  @override
  void run() => _iList = _iList.add(1);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _KtListAddBenchmark extends ListBenchmarkBase {
  _KtListAddBenchmark({ScoreEmitter emitter}) : super('KtList', emitter: emitter);

  KtList<int> _ktList;

  @override
  void setup() => _ktList = [].toImmutableList();

  // void setup() => _ktList = KtList<int>.empty();

  /// `_ktList.asList()` gives back an unmodifiable list, so we need `List.of`
  /// to add an item.
  @override
  void run() => _ktList = _ktList.plusElement(1);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class _BuiltListAddBenchmark extends ListBenchmarkBase {
  _BuiltListAddBenchmark({ScoreEmitter emitter}) : super('BuiltList', emitter: emitter);

  BuiltList<int> _builtList;

  @override
  void setup() => _builtList = BuiltList<int>();

  @override
  void run() => _builtList.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(1));
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
