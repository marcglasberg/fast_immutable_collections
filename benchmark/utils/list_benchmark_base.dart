import 'package:benchmark_harness/benchmark_harness.dart'
    show BenchmarkBase, ScoreEmitter;

class ListBenchmarkBase extends BenchmarkBase {
  static const int smallSize = 10,
      mediumSize = 1000,
      bigSize = 100000,
      normalRuns = 5000;

  final int runs, size;

  const ListBenchmarkBase(
    String name, {
    this.runs = normalRuns,
    this.size = mediumSize,
    ScoreEmitter emitter,
  })  : assert(runs != null && runs > 0),
        assert(size != null && size > 0),
        super(name, emitter: emitter);

  static List<int> getDummyList({int length = bigSize}) =>
      List<int>.generate(length, (_) => 1);

  @override
  void exercise() {
    for (int i = 0; i < runs; i++) run();
  }
}
