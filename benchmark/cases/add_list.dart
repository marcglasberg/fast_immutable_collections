import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;

import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;
import '../utils/table_score_emitter.dart' show TableScoreEmitter;

final List<int> _baseList = [1, 2, 3];
final List<int> _listToAdd = [4, 5, 6];

class AddListBenchmark {
  static void report() {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_add_list');

    _ListAddListBenchmark(emitter: tableScoreEmitter).report();

    tableScoreEmitter.saveReport();
  }
}

class _ListAddListBenchmark extends ListBenchmarkBase {
  _ListAddListBenchmark({ScoreEmitter emitter})
      : super('List (Mutable)', emitter: emitter);

  List<int> _list;

  @override
  void setup() => _list = List<int>.of(_baseList);

  @override
  void run() => _list.addAll(_listToAdd);
}
