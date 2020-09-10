import 'package:benchmark_harness/benchmark_harness.dart'
    show ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList;
import 'package:kt_dart/collection.dart' show KtList;
import 'package:meta/meta.dart' show immutable;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

import '../list_benchmark_base.dart' show ListBenchmarkBase;

@immutable
class IListEmptyBenchmark extends ListBenchmarkBase {
  const IListEmptyBenchmark(ScoreEmitter scoreEmitter)
      : super('IList', scoreEmitter);

  @override
  void run() => IList<int>();
}

@immutable
class ListEmptyBenchmark extends ListBenchmarkBase {
  const ListEmptyBenchmark(ScoreEmitter scoreEmitter)
      : super('List (Mutable)', scoreEmitter);

  @override
  void run() => <int>[];
}

@immutable
class KtListEmptyBenchmark extends ListBenchmarkBase {
  const KtListEmptyBenchmark(ScoreEmitter scoreEmitter)
      : super('KtList', scoreEmitter);

  @override
  void run() => KtList<int>.empty();
}

@immutable
class BuiltListEmptyBenchmark extends ListBenchmarkBase {
  const BuiltListEmptyBenchmark(ScoreEmitter scoreEmitter)
      : super('BuiltList', scoreEmitter);

  @override
  void run() => BuiltList<int>();
}
