import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";


import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

class MapContainsValueBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapContainsValueBenchmark({required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapContainsValueBenchmark(emitter: emitter),
          IMapContainsValueBenchmark(emitter: emitter),
          KtMapContainsValueBenchmark(emitter: emitter),
          BuiltMapContainsValueBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class MutableMapContainsValueBenchmark extends MapBenchmarkBase {
  MutableMapContainsValueBenchmark({required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  late Map<String, int> map;
  late bool contains;

  @override
  Map<String, int> toMutable() => map;

  @override
  void setup() => map = MapBenchmarkBase.getDummyGeneratedMap(size: config.size);

  @override
  void run() {
    for (int i = 0; i < map.length + 1; i++) contains = map.containsValue(i);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class IMapContainsValueBenchmark extends MapBenchmarkBase {
  IMapContainsValueBenchmark({required TableScoreEmitter emitter})
      : super(name: "IMap", emitter: emitter);

  late IMap<String, int> iMap;
  late bool contains;

  @override
  Map<String, int> toMutable() => iMap.unlock;

  @override
  void setup() =>
      iMap = IMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    for (int i = 0; i < iMap.length + 1; i++) contains = iMap.containsValue(i);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class KtMapContainsValueBenchmark extends MapBenchmarkBase {
  KtMapContainsValueBenchmark({required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  late KtMap<String, int> ktMap;
  late bool contains;

  @override
  Map<String, int> toMutable() => ktMap.asMap();

  @override
  void setup() => ktMap = KtMap.from(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    for (int i = 0; i < ktMap.size + 1; i++) contains = ktMap.containsValue(i);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltMapContainsValueBenchmark extends MapBenchmarkBase {
  BuiltMapContainsValueBenchmark({required TableScoreEmitter emitter})
      : super(name: "BuiltMap", emitter: emitter);

  late BuiltMap<String, int> builtMap;
  late bool contains;

  @override
  Map<String, int> toMutable() => builtMap.asMap();

  @override
  void setup() =>
      builtMap = BuiltMap<String, int>.of(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    for (int i = 0; i < builtMap.length + 1; i++) contains = builtMap.containsValue(i);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
