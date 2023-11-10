// ignore_for_file: overridden_fields
import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:kt_dart/collection.dart";

import "../../utils/collection_benchmark_base.dart";

class MapRemoveBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapRemoveBenchmark({required super.emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapRemoveBenchmark(emitter: emitter),
          IMapRemoveBenchmark(emitter: emitter),
          KtMapRemoveBenchmark(emitter: emitter),
          BuiltMapMapRemoveBenchmark(emitter: emitter),
        ];
}

class MutableMapRemoveBenchmark extends MapBenchmarkBase {
  MutableMapRemoveBenchmark({required super.emitter}) : super(name: "Map (Mutable)");

  late Map<String, int> map;

  late int count;

  // Saves many copies of the initial list (created during setup).
  late List<Map<String, int>> initialMaps;

  @override
  Map<String, int> toMutable() => map;

  @override
  void setup() {
    count = 0;
    initialMaps = [];
    for (int i = 0; i <= max(1, 1000000 ~/ config.size); i++)
      initialMaps.add(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));
  }

  @override
  void run() {
    map = getNextMap();
    map.remove((config.size ~/ 2).toString());
  }

  Map<String, int> getNextMap() {
    if (count >= initialMaps.length - 1)
      count = 0;
    else
      count++;
    return initialMaps[count];
  }
}

class IMapRemoveBenchmark extends MapBenchmarkBase {
  IMapRemoveBenchmark({required super.emitter}) : super(name: "IMap");

  late IMap<String, int> iMap;

  @override
  Map<String, int> toMutable() => iMap.unlock;

  @override
  void setup() =>
      iMap = IMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => iMap = iMap.remove((config.size ~/ 2).toString());
}

class KtMapRemoveBenchmark extends MapBenchmarkBase {
  KtMapRemoveBenchmark({required super.emitter}) : super(name: "KtMap");

  late KtMap<String, int> ktMap;

  @override
  Map<String, int> toMutable() => ktMap.asMap();

  @override
  void setup() =>
      ktMap = KtMap<String, int>.from(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => ktMap = ktMap.minus((config.size ~/ 2).toString());
}

class BuiltMapMapRemoveBenchmark extends MapBenchmarkBase {
  BuiltMapMapRemoveBenchmark({required super.emitter}) : super(name: "BuiltMap");

  late BuiltMap<String, int> builtMap;

  @override
  Map<String, int> toMutable() => builtMap.asMap();

  @override
  void setup() =>
      builtMap = BuiltMap<String, int>.of(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => builtMap = builtMap.rebuild(
      (MapBuilder<String, int> mapBuilder) => mapBuilder.remove((config.size ~/ 2).toString()));
}
