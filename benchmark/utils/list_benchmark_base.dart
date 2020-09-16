import 'package:benchmark_harness/benchmark_harness.dart'
    show BenchmarkBase, ScoreEmitter;
import 'package:meta/meta.dart';

// List<int> getDummyList({int length = ListBenchmarkBase.totalRuns}) =>
//     List<int>.generate(length, (_) => 1);

class ListBenchmarkBase extends BenchmarkBase {
  //
  final int runs;
  final int size;

  const ListBenchmarkBase(
    String name, {
    @required this.runs,
    @required this.size,
    ScoreEmitter emitter,
  })  : assert(runs != null && runs > 0),
        assert(size != null && size > 0),
        super(name, emitter: emitter);

  @override
  void exercise() {
    for (int i = 0; i < runs; i++) run();
  }
}
