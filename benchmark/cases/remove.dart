import 'package:benchmark_harness/benchmark_harness.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

import '../list_benchmark_base.dart' show ListBenchmarkBase;
import '../table_score_emitter.dart' show TableScoreEmitter;

class RemoveBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_remove');

    _ListAddBenchmark(emitter: tableScoreEmitter).report();

    tableScoreEmitter.saveReport();
  }
}

class _ListAddBenchmark extends ListBenchmarkBase {
  _ListAddBenchmark({ScoreEmitter emitter}) : super('IList', emitter: emitter);

  List<int> _list;

  @override
  void setup() => _list = List.generate(ListBenchmarkBase.totalRuns, (_) => 1);

  @override
  void run() => _list.remove(1);
}
