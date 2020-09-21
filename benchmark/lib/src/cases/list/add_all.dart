import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;
import 'package:kt_dart/collection.dart' show KtList, KtIterableExtensions;
import 'package:meta/meta.dart' show required;

import '../utils/benchmark_reporter.dart' show BenchmarkReporter;
import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;
import '../utils/table_score_emitter.dart' show TableScoreEmitter;

const List<int> _baseList = [1, 2, 3];
const List<int> _listToAdd = [4, 5, 6];

class AddAllBenchmark extends BenchmarkReporter {
  @override
  void report() {
    const int runs = 10000;

    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_add_all');

    _ListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter).report();
    _IListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter).report();
    _KtListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter).report();
    _BuiltListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter).report();

    tableScoreEmitters.add(tableScoreEmitter);
  }
}

class _ListAddAllBenchmark extends ListBenchmarkBase {
  _ListAddAllBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('List (Mutable)', runs: runs, size: 0, emitter: emitter);

  List<int> _list;

  @override
  void setup() => _list = List<int>.of(_baseList);

  @override
  void run() => _list.addAll(_listToAdd);
}

class _IListAddAllBenchmark extends ListBenchmarkBase {
  _IListAddAllBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('IList', runs: runs, size: 0, emitter: emitter);

  IList<int> _iList;

  @override
  void setup() => _iList = IList<int>(_baseList);

  @override
  void run() => _iList = _iList.addAll(_listToAdd);
}

class _KtListAddAllBenchmark extends ListBenchmarkBase {
  _KtListAddAllBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('KtList', runs: runs, size: 0, emitter: emitter);

  KtList<int> _ktList;

  @override
  void setup() => _ktList = KtList<int>.from(_baseList);

  /// If the added list were already of type `KtList`, then it would be much
  /// faster.
  @override
  void run() => _ktList = _ktList.plus(KtList<int>.from(_listToAdd));
}

class _BuiltListAddAllBenchmark extends ListBenchmarkBase {
  _BuiltListAddAllBenchmark(
      {@required int runs, @required ScoreEmitter emitter})
      : super('BuiltList', runs: runs, size: 0, emitter: emitter);

  BuiltList<int> _builtList;

  @override
  void setup() => _builtList = BuiltList<int>.of(_baseList);

  @override
  void run() => _builtList = _builtList.rebuild(
      (ListBuilder<int> listBuilder) => listBuilder.addAll(_listToAdd));
}
