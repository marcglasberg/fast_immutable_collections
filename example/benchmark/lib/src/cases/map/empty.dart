// ignore_for_file: overridden_fields
import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:kt_dart/collection.dart";

class MapEmptyBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapEmptyBenchmark({required super.emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapEmptyBenchmark(emitter: emitter),
          IMapEmptyBenchmark(emitter: emitter),
          KtMapEmptyBenchmark(emitter: emitter),
          BuiltMapEmptyBenchmark(emitter: emitter),
        ];
}

class MutableMapEmptyBenchmark extends MapBenchmarkBase {
  MutableMapEmptyBenchmark({required super.emitter}) : super(name: "Map (Mutable)");

  late Map<String, int> map;

  @override
  Map<String, int> toMutable() => map;

  @override
  void run() => map = <String, int>{};
}

class IMapEmptyBenchmark extends MapBenchmarkBase {
  IMapEmptyBenchmark({required super.emitter}) : super(name: "IMap");

  late IMap<String, int> iMap;

  @override
  Map<String, int> toMutable() => iMap.unlock;

  @override
  void run() => iMap = IMap<String, int>();
}

class KtMapEmptyBenchmark extends MapBenchmarkBase {
  KtMapEmptyBenchmark({required super.emitter}) : super(name: "KtMap");

  late KtMap<String, int> ktMap;

  @override
  Map<String, int> toMutable() => ktMap.asMap();

  @override
  void run() => ktMap = const KtMap<String, int>.empty();
}

class BuiltMapEmptyBenchmark extends MapBenchmarkBase {
  BuiltMapEmptyBenchmark({required super.emitter}) : super(name: "BuiltMap");

  late BuiltMap<String, int> builtMap;

  @override
  Map<String, int> toMutable() => builtMap.asMap();

  @override
  void run() => builtMap = BuiltMap<String, int>();
}
