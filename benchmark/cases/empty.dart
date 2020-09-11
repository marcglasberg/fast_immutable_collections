import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:kt_dart/collection.dart' show KtList;
import 'package:meta/meta.dart' show immutable;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;
import '../utils/table_score_emitter.dart' show TableScoreEmitter;

class EmptyBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_empty');

    _ListEmptyBenchmark(emitter: tableScoreEmitter).report();
    _IListEmptyBenchmark(emitter: tableScoreEmitter).report();
    _KtListEmptyBenchmark(emitter: tableScoreEmitter).report();
    _BuiltListEmptyBenchmark(emitter: tableScoreEmitter).report();

    tableScoreEmitter.saveReport();
  }
}

@immutable
class _ListEmptyBenchmark extends ListBenchmarkBase {
  const _ListEmptyBenchmark({ScoreEmitter emitter})
      : super('List (Mutable)', emitter: emitter);

  @override
  void run() => <int>[];
}

@immutable
class _IListEmptyBenchmark extends ListBenchmarkBase {
  const _IListEmptyBenchmark({ScoreEmitter emitter})
      : super('IList', emitter: emitter);

  @override
  void run() => IList<int>();
}

@immutable
class _KtListEmptyBenchmark extends ListBenchmarkBase {
  const _KtListEmptyBenchmark({ScoreEmitter emitter})
      : super('KtList', emitter: emitter);

  @override
  void run() => KtList<int>.empty();
}

@immutable
class _BuiltListEmptyBenchmark extends ListBenchmarkBase {
  const _BuiltListEmptyBenchmark({ScoreEmitter emitter})
      : super('BuiltList', emitter: emitter);

  @override
  void run() => BuiltList<int>();
}
