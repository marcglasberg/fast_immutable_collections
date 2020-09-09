import 'package:benchmark_harness/benchmark_harness.dart' show BenchmarkBase;
import 'package:kt_dart/collection.dart' show KtList, KtMutableList;
import 'package:meta/meta.dart' show immutable;
import 'package:test/test.dart' show group, test;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

void main() {
  group('Empty Lists Initialization |', () {
    test('IList', () => IListEmptyBenchmark().report());
    test('List', () => ListEmptyBenchmark().report());
    test('KtList', () => KtListEmptyBenchmark().report());
  });

  group('Adding items to a list |', () {
    test('Ilist', () => IListAddBenchmark().report());    
    test('List', () => ListAddBenchmark().report());    
    test('KtList', () => KtListAddBenchmark().report());    
  });
}

@immutable
class ListBenchmarkBase extends BenchmarkBase {
  static const int totalRuns = 10000;

  const ListBenchmarkBase() : super('IList');

  @override
  void exercise() {
    for (int i = 0; i < totalRuns; i++) run();
  }
}

@immutable
class IListEmptyBenchmark extends ListBenchmarkBase {
  @override
  void run() => IList<int>();
}

@immutable
class ListEmptyBenchmark extends ListBenchmarkBase {
  @override
  void run() => <int>[];
}

@immutable
class KtListEmptyBenchmark extends ListBenchmarkBase {
  @override
  void run() => KtList<int>.empty();
}

@immutable
class IListAddBenchmark extends ListBenchmarkBase {
  @override
  void run() => IList<int>().add(1);
}

@immutable
class ListAddBenchmark extends ListBenchmarkBase {
  @override
  void run() => <int>[].add(1);
}

@immutable
class KtListAddBenchmark extends ListAddBenchmark {
  @override
  void run() => KtMutableList<int>.empty().add(1);
}