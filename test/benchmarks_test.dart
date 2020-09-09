import 'package:benchmark_harness/benchmark_harness.dart' show BenchmarkBase;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;
import 'package:kt_dart/collection.dart' show KtList, KtMutableList;
import 'package:meta/meta.dart' show immutable;
import 'package:test/test.dart' show group, test;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

/// Run the benchmarks with: `pub run test test/benchmarks_test.dart`
void main() {
  group('Empty Lists Initialization |', () {
    test('IList', () => IListEmptyBenchmark().report());
    test('List', () => ListEmptyBenchmark().report());
    test('KtList', () => KtListEmptyBenchmark().report());
    test('BuiltList', () => BuiltListEmptyBenchmark().report());
  });

  group('Adding items to a list |', () {
    test('Ilist', () => IListAddBenchmark().report());
    test('List', () => ListAddBenchmark().report());
    test('KtList', () => KtListAddBenchmark().report());
    test('BuiltList', () => BuiltListAddBenchmark().report());
  });
}

@immutable
class ListBenchmarkBase extends BenchmarkBase {
  static const int totalRuns = 10000;

  const ListBenchmarkBase(String name) : super(name);

  @override
  void exercise() {
    for (int i = 0; i < totalRuns; i++) run();
  }
}

@immutable
class IListEmptyBenchmark extends ListBenchmarkBase {
  const IListEmptyBenchmark() : super('IList Empty');

  @override
  void run() => IList<int>();
}

@immutable
class ListEmptyBenchmark extends ListBenchmarkBase {
  const ListEmptyBenchmark() : super('List Empty (Mutable)');

  @override
  void run() => <int>[];
}

@immutable
class KtListEmptyBenchmark extends ListBenchmarkBase {
  const KtListEmptyBenchmark() : super('KtList Empty');

  @override
  void run() => KtList<int>.empty();
}

@immutable
class BuiltListEmptyBenchmark extends ListBenchmarkBase {
  const BuiltListEmptyBenchmark() : super('BuiltList Empty');

  @override
  void run() => BuiltList<int>();
}

@immutable
class IListAddBenchmark extends ListBenchmarkBase {
  const IListAddBenchmark() : super('IList Add');

  @override
  void run() => IList<int>().add(1);
}

@immutable
class ListAddBenchmark extends ListBenchmarkBase {
  const ListAddBenchmark() : super('List Add');

  @override
  void run() => <int>[].add(1);
}

@immutable
class KtListAddBenchmark extends ListBenchmarkBase {
  const KtListAddBenchmark() : super('KtList Add');

  @override
  void run() => KtMutableList<int>.empty().add(1);
}

@immutable
class BuiltListAddBenchmark extends ListBenchmarkBase {
  const BuiltListAddBenchmark() : super('BuiltList Add');

  @override
  void run() => BuiltList<int>()
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.add(1));
}
