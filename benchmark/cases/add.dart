import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;
import 'package:kt_dart/collection.dart' show KtMutableList;
import 'package:meta/meta.dart' show immutable;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

import '../list_benchmark_base.dart' show ListBenchmarkBase;
import '../table_score_emitter.dart' show TableScoreEmitter;

class AddBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_add');

    _IListAddBenchmark(emitter: tableScoreEmitter);
    _ListAddBenchmark(emitter: tableScoreEmitter);
    _KtListAddBenchmark(emitter: tableScoreEmitter);
    _BuiltListAddBenchmark(emitter: tableScoreEmitter);

    tableScoreEmitter.saveReport();
  }
}

@immutable
class _IListAddBenchmark extends ListBenchmarkBase {
  const _IListAddBenchmark({ScoreEmitter emitter})
      : super('IList', emitter: emitter);

  @override
  void run() => IList<int>().add(1);
}

@immutable
class _ListAddBenchmark extends ListBenchmarkBase {
  const _ListAddBenchmark({ScoreEmitter emitter})
      : super('List', emitter: emitter);

  @override
  void run() => <int>[].add(1);
}

@immutable
class _KtListAddBenchmark extends ListBenchmarkBase {
  const _KtListAddBenchmark({ScoreEmitter emitter})
      : super('KtList', emitter: emitter);

  @override
  void run() => KtMutableList<int>.empty().add(1);
}

@immutable
class _BuiltListAddBenchmark extends ListBenchmarkBase {
  const _BuiltListAddBenchmark({ScoreEmitter emitter})
      : super('BuiltList', emitter: emitter);

  @override
  void run() => BuiltList<int>()
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.add(1));
}
