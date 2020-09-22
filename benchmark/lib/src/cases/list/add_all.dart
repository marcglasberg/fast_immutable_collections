import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';
import '../../utils/table_score_emitter.dart';

class AddAllBenchmark extends MultiBenchmarkReporter {
  static const List<int> baseList = [1, 2, 3], listToAdd = [4, 5, 6];

  @override
  void report() {
    const int runs = 5000;

    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_add_all');

    final List<ListBenchmarkBase> benchmarks = [
      ListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter),
      IListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter),
      KtListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter),
      BuiltListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter),
    ];

    benchmarks.forEach((ListBenchmarkBase benchmarks) => benchmarks.report());

    tableScoreEmitters.add(tableScoreEmitter);
  }
}

class ListAddAllBenchmark extends ListBenchmarkBase {
  ListAddAllBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('List (Mutable)', runs: runs, size: 0, emitter: emitter);

  List<int> _list;
  List<int> _fixedList;

  @override
  List<int> toList() => _list;

  @override
  void setup() => _fixedList = List<int>.of(AddAllBenchmark.baseList);

  @override
  void run() {
    _list = List<int>.of(_fixedList);
    _list.addAll(AddAllBenchmark.listToAdd);
  }
}

class IListAddAllBenchmark extends ListBenchmarkBase {
  IListAddAllBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('IList', runs: runs, size: 0, emitter: emitter);

  IList<int> _iList;
  IList<int> _result;

  @override
  List<int> toList() => _result.unlock;

  @override
  void setup() => _iList = IList<int>(AddAllBenchmark.baseList);

  @override
  void run() => _result = _iList.addAll(AddAllBenchmark.listToAdd);
}

class KtListAddAllBenchmark extends ListBenchmarkBase {
  KtListAddAllBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('KtList', runs: runs, size: 0, emitter: emitter);

  KtList<int> _ktList;
  KtList<int> _result;

  @override
  List<int> toList() => _result.asList();

  @override
  void setup() => _ktList = KtList<int>.from(AddAllBenchmark.baseList);

  /// If the added list were already of type `KtList`, then it would be much
  /// faster.
  @override
  void run() =>
      _result = _ktList.plus(KtList<int>.from(AddAllBenchmark.listToAdd));
}

class BuiltListAddAllBenchmark extends ListBenchmarkBase {
  BuiltListAddAllBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('BuiltList', runs: runs, size: 0, emitter: emitter);

  BuiltList<int> _builtList;
  BuiltList<int> _result;

  @override
  List<int> toList() => _result.asList();

  @override
  void setup() => _builtList = BuiltList<int>.of(AddAllBenchmark.baseList);

  @override
  void run() => _result = _builtList.rebuild((ListBuilder<int> listBuilder) =>
      listBuilder.addAll(AddAllBenchmark.listToAdd));
}
