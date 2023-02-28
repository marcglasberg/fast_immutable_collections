// ignore_for_file: overridden_fields
import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/table_score_emitter.dart";
import "package:kt_dart/collection.dart";

// /////////////////////////////////////////////////////////////////////////////

class ListEmptyBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListEmptyBenchmark({required TableScoreEmitter emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListEmptyBenchmark(emitter: emitter),
          IListEmptyBenchmark(emitter: emitter),
          KtListEmptyBenchmark(emitter: emitter),
          BuiltListEmptyBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

// /////////////////////////////////////////////////////////////////////////////

class MutableListEmptyBenchmark extends ListBenchmarkBase {
  MutableListEmptyBenchmark({required TableScoreEmitter emitter})
      : super(name: "List (Mutable)", emitter: emitter);

  late List<int> list;

  @override
  List<int> toMutable() => list;

  @override
  void run() => list = <int>[];
}

// /////////////////////////////////////////////////////////////////////////////

class IListEmptyBenchmark extends ListBenchmarkBase {
  IListEmptyBenchmark({required TableScoreEmitter emitter})
      : super(name: "IList", emitter: emitter);

  late IList<int> iList;

  @override
  List<int> toMutable() => iList.unlock;

  @override
  void run() => iList = IList<int>();
}

// /////////////////////////////////////////////////////////////////////////////

class KtListEmptyBenchmark extends ListBenchmarkBase {
  KtListEmptyBenchmark({required TableScoreEmitter emitter})
      : super(name: "KtList", emitter: emitter);

  late KtList<int> ktList;

  @override
  List<int> toMutable() => ktList.asList();

  @override
  void run() => ktList = const KtList<int>.empty();
}

// /////////////////////////////////////////////////////////////////////////////

class BuiltListEmptyBenchmark extends ListBenchmarkBase {
  BuiltListEmptyBenchmark({required TableScoreEmitter emitter})
      : super(name: "BuiltList", emitter: emitter);

  late BuiltList<int> builtList;

  @override
  List<int> toMutable() => builtList.asList();

  @override
  void run() => builtList = BuiltList<int>();
}

// /////////////////////////////////////////////////////////////////////////////
