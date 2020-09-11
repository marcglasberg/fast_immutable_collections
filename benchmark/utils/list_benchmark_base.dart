import 'package:benchmark_harness/benchmark_harness.dart'
    show BenchmarkBase, ScoreEmitter;

class ListBenchmarkBase extends BenchmarkBase {
  static const int totalRuns = 10000;

  const ListBenchmarkBase(String name, {ScoreEmitter emitter})
      : super(name, emitter: emitter);

  @override
  void exercise() {
    for (int i = 0; i < totalRuns; i++) run();
  }
}
