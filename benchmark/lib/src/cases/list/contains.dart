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
  void report() {}
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
  void setup() {}

  @override
  void run() {}
}
