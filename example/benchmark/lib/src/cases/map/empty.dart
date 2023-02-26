// ignore_for_file: overridden_fields
import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/table_score_emitter.dart";
import "package:kt_dart/collection.dart";

// /////////////////////////////////////////////////////////////////////////////

class MapEmptyBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapEmptyBenchmark({required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapEmptyBenchmark(emitter: emitter),
          IMapEmptyBenchmark(emitter: emitter),
          KtMapEmptyBenchmark(emitter: emitter),
          BuiltMapEmptyBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

// /////////////////////////////////////////////////////////////////////////////

class MutableMapEmptyBenchmark extends MapBenchmarkBase {
  MutableMapEmptyBenchmark({required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  late Map<String, int> map;

  @override
  Map<String, int> toMutable() => map;

  @override
  void run() => map = <String, int>{};
}

// /////////////////////////////////////////////////////////////////////////////

class IMapEmptyBenchmark extends MapBenchmarkBase {
  IMapEmptyBenchmark({required TableScoreEmitter emitter}) : super(name: "IMap", emitter: emitter);

  late IMap<String, int> iMap;

  @override
  Map<String, int> toMutable() => iMap.unlock;

  @override
  void run() => iMap = IMap<String, int>();
}

// /////////////////////////////////////////////////////////////////////////////

class KtMapEmptyBenchmark extends MapBenchmarkBase {
  KtMapEmptyBenchmark({required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  late KtMap<String, int> ktMap;

  @override
  Map<String, int> toMutable() => ktMap.asMap();

  @override
  void run() => ktMap = const KtMap<String, int>.empty();
}

// /////////////////////////////////////////////////////////////////////////////

class BuiltMapEmptyBenchmark extends MapBenchmarkBase {
  BuiltMapEmptyBenchmark({required TableScoreEmitter emitter})
      : super(name: "BuiltMap", emitter: emitter);

  late BuiltMap<String, int> builtMap;

  @override
  Map<String, int> toMutable() => builtMap.asMap();

  @override
  void run() => builtMap = BuiltMap<String, int>();
}

// /////////////////////////////////////////////////////////////////////////////
