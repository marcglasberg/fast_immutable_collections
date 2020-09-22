import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';
import '../../utils/table_score_emitter.dart';

class ContainsBenchmark extends MultiBenchmarkReporter {
  @override
  void report() {
    const int runs = 100;
    const List<int> sizes = [100, 1000, 10000, 100000];

    sizes.forEach((int size) {
      final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(
          reportName: 'list_contains_runs_${runs}_size_${size}');

      final List<ListBenchmarkBase> benchmarks = [
        ListContainsBenchmark(
            runs: runs, size: size, emitter: tableScoreEmitter),
        IListContainsBenchmark(
            runs: runs, size: size, emitter: tableScoreEmitter),
        KtListContainsBenchmark(
            runs: runs, size: size, emitter: tableScoreEmitter),
        BuiltListContainsBenchmark(
            runs: runs, size: size, emitter: tableScoreEmitter),
      ];

      benchmarks.forEach((ListBenchmarkBase benchmark) => benchmark.report());

      tableScoreEmitters.add(tableScoreEmitter);
    });
  }
}

class ListContainsBenchmark extends ListBenchmarkBase {
  ListContainsBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('List (Mutable)', runs: runs, size: size, emitter: emitter);

  List<int> _list;

  @override
  List<int> toList() => _list;

  @override
  void setup() => _list = ListBenchmarkBase.getDummyGeneratedList(length: size);

  @override
  void run() {
    for (int i = 0; i < _list.length + 1; i++) _list.contains(i);
  }
}

class IListContainsBenchmark extends ListBenchmarkBase {
  IListContainsBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('IList', runs: runs, size: size, emitter: emitter);

  IList<int> _iList;

  @override
  List<int> toList() => _iList.unlock;

  @override
  void setup() => _iList =
      IList<int>(ListBenchmarkBase.getDummyGeneratedList(length: size));

  @override
  void run() {
    for (int i = 0; i < _iList.length + 1; i++) _iList.contains(i);
  }
}

class KtListContainsBenchmark extends ListBenchmarkBase {
  KtListContainsBenchmark({
    @required int runs,
    @required int size,
    @required ScoreEmitter emitter,
  }) : super('KtList', runs: runs, size: size, emitter: emitter);

  KtList<int> _ktList;

  @override
  List<int> toList() => _ktList.asList();

  @override
  void setup() => _ktList =
      KtList.from(ListBenchmarkBase.getDummyGeneratedList(length: size));

  @override
  void run() {
    for (int i = 0; i < _ktList.size + 1; i++) _ktList.contains(i);
  }
}

class BuiltListContainsBenchmark extends ListBenchmarkBase {
  BuiltListContainsBenchmark(
      {@required int runs, @required int size, @required ScoreEmitter emitter})
      : super('BuiltList', runs: runs, size: size, emitter: emitter);

  BuiltList<int> _builtList;

  @override
  List<int> toList() => _builtList.asList();

  @override
  void setup() => _builtList =
      BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList(length: size));

  @override
  void run() {
    for (int i = 0; i < _builtList.length + 1; i++) _builtList.contains(i);
  }
}
