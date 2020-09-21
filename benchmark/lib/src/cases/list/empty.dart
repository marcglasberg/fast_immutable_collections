import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';
import '../../utils/table_score_emitter.dart';

class EmptyBenchmark extends BenchmarkReporter {
  @override
  void report() {
    const int runs = 10000;

    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_empty');

    final List<int> listResult =
            _ListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter)
                .report(),
        iListResult =
            _IListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter)
                .report(),
        ktListResult =
            _KtListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter)
                .report(),
        builtListResult =
            _BuiltListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter)
                .report();

    group('Empty | Testing if all lists conform to the basic, mutable one |',
        () {
      test('IList', () => expect(listResult, iListResult));
      test('KtList', () => expect(listResult, ktListResult));
      test('BuiltList', () => expect(listResult, builtListResult));
    });

    tableScoreEmitters.add(tableScoreEmitter);
  }
}

class _ListEmptyBenchmark extends ListBenchmarkBase {
  _ListEmptyBenchmark({
    @required int runs,
    @required ScoreEmitter emitter,
  }) : super('List (Mutable)', runs: runs, size: 0, emitter: emitter);

  List<int> _list;

  @override
  List<int> toList() => _list;

  @override
  void run() => _list = <int>[];
}

class _IListEmptyBenchmark extends ListBenchmarkBase {
  _IListEmptyBenchmark({
    @required int runs,
    @required ScoreEmitter emitter,
  }) : super('IList', runs: runs, size: 0, emitter: emitter);

  IList<int> _iList;

  @override
  List<int> toList() => _iList.unlock;

  @override
  void run() => _iList = IList<int>();
}

class _KtListEmptyBenchmark extends ListBenchmarkBase {
  _KtListEmptyBenchmark({
    @required int runs,
    @required ScoreEmitter emitter,
  }) : super('KtList', runs: runs, size: 0, emitter: emitter);

  KtList<int> _ktList;

  @override
  List<int> toList() => _ktList.asList();

  @override
  void run() => _ktList = KtList<int>.empty();
}

class _BuiltListEmptyBenchmark extends ListBenchmarkBase {
  _BuiltListEmptyBenchmark({
    @required int runs,
    @required ScoreEmitter emitter,
  }) : super('BuiltList', runs: runs, size: 0, emitter: emitter);

  BuiltList<int> _builtList;

  @override
  List<int> toList() => _builtList.asList();

  @override
  void run() => _builtList = BuiltList<int>();
}
