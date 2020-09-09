import 'package:benchmark_harness/benchmark_harness.dart' show BenchmarkBase;
import 'package:meta/meta.dart' show immutable;
import 'package:test/test.dart' show test;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

void main() {
  test('Empty IList Initialization', () {
    final IListEmptyBenchmark iListEmptyBenchmark = IListEmptyBenchmark();
    iListEmptyBenchmark.report();
    // iListEmptyBenchmark.measure();
  });

  test('Empty List Initialization', () => ListEmptyBenchmark().report());
}

@immutable
class IListBenchmarkBase extends BenchmarkBase {
  static const int totalRuns = 10000;

  const IListBenchmarkBase() : super('IList');

  @override
  void exercise() {
    for (int i = 0; i < totalRuns; i++)
      run();
  }
}

@immutable
class IListEmptyBenchmark extends IListBenchmarkBase {
  @override
  void run() => IList<int>();
}

@immutable
class ListEmptyBenchmark extends IListBenchmarkBase {
  @override
  void run() => <int>[];
}