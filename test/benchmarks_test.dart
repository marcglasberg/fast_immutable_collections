import 'package:benchmark_harness/benchmark_harness.dart' show BenchmarkBase;
import 'package:meta/meta.dart' show immutable;
import 'package:test/test.dart' show group, test;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

void main() {
  group('Empty Lists Initialization', () {
    test('IList', () => IListEmptyBenchmark().report());
    test('List', () => ListEmptyBenchmark().report());
  });

  group('Adding items to a list', () {
    test('Ilist', () => IListAddBenchmark().report());    
    test('List', () => ListAddBenchmark().report());    
  });
}

@immutable
class IListBenchmarkBase extends BenchmarkBase {
  static const int totalRuns = 10000;

  const IListBenchmarkBase() : super('IList');

  @override
  void exercise() {
    for (int i = 0; i < totalRuns; i++) run();
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

@immutable
class IListAddBenchmark extends IListBenchmarkBase {
  @override
  void run() => IList<int>().add(1);
}

@immutable
class ListAddBenchmark extends IListBenchmarkBase {
  @override
  void run() => <int>[].add(1);
}