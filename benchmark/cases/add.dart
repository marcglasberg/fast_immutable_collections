import 'package:benchmark_harness/benchmark_harness.dart'
    show ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;
import 'package:kt_dart/collection.dart' show KtMutableList;
import 'package:meta/meta.dart' show immutable;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

import '../list_benchmark_base.dart' show ListBenchmarkBase;

@immutable
class IListAddBenchmark extends ListBenchmarkBase {
  const IListAddBenchmark(ScoreEmitter scoreEmitter)
      : super('IList', scoreEmitter);

  @override
  void run() => IList<int>().add(1);
}

@immutable
class ListAddBenchmark extends ListBenchmarkBase {
  const ListAddBenchmark(ScoreEmitter scoreEmitter)
      : super('List', scoreEmitter);

  @override
  void run() => <int>[].add(1);
}

@immutable
class KtListAddBenchmark extends ListBenchmarkBase {
  const KtListAddBenchmark(ScoreEmitter scoreEmitter)
      : super('KtList', scoreEmitter);

  @override
  void run() => KtMutableList<int>.empty().add(1);
}

@immutable
class BuiltListAddBenchmark extends ListBenchmarkBase {
  const BuiltListAddBenchmark(ScoreEmitter scoreEmitter)
      : super('BuiltList', scoreEmitter);

  @override
  void run() => BuiltList<int>()
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.add(1));
}
