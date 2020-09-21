import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';
import '../../utils/table_score_emitter.dart';

class ReadBenchmark extends MultiBenchmarkReporter {
  static const int indexToRead = 100;

  @override
  void report() {
    const int runs = 10000;

    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_read');

    final List<ListBenchmarkBase> benchmarks = [
      ListReadBenchmark(runs: runs, emitter: tableScoreEmitter),
      IListReadBenchmark(runs: runs, emitter: tableScoreEmitter),
      KtListReadBenchmark(runs: runs, emitter: tableScoreEmitter),
      BuiltListReadBenchmark(runs: runs, emitter: tableScoreEmitter),
    ];

    benchmarks.forEach((ListBenchmarkBase benchmark) => benchmark.report());

    tableScoreEmitters.add(tableScoreEmitter);
  }
}

class ListReadBenchmark extends ListBenchmarkBase {
  ListReadBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('List (Mutable)', runs: runs, size: 0, emitter: emitter);

  List<int> _list;

  @override
  List<int> toList() => _list;

  @override
  void setup() => _list = ListBenchmarkBase.dummyStaticList;

  @override
  void run() => _list[ReadBenchmark.indexToRead];
}

class IListReadBenchmark extends ListBenchmarkBase {
  IListReadBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('IList', runs: runs, size: 0, emitter: emitter);

  IList<int> _iList;

  @override
  List<int> toList() => _iList.unlock;

  @override
  void setup() => _iList = IList<int>(ListBenchmarkBase.dummyStaticList);

  @override
  void run() => _iList[ReadBenchmark.indexToRead];
}

class KtListReadBenchmark extends ListBenchmarkBase {
  KtListReadBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('KtList', runs: runs, size: 0, emitter: emitter);

  KtList<int> _ktList;

  @override
  List<int> toList() => _ktList.asList();

  @override
  void setup() => _ktList = KtList<int>.from(ListBenchmarkBase.dummyStaticList);

  @override
  void run() => _ktList[ReadBenchmark.indexToRead];
}

class BuiltListReadBenchmark extends ListBenchmarkBase {
  BuiltListReadBenchmark({@required int runs, @required ScoreEmitter emitter})
      : super('BuiltList', runs: runs, size: 0, emitter: emitter);

  BuiltList<int> _builtList;

  @override
  List<int> toList() => _builtList.asList();

  @override
  void setup() =>
      _builtList = BuiltList<int>.of(ListBenchmarkBase.dummyStaticList);

  @override
  void run() => _builtList[ReadBenchmark.indexToRead];
}
