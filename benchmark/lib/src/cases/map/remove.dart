import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

class MapRemoveBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapRemoveBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapRemoveBenchmark(emitter: emitter),
          IMapRemoveBenchmark(emitter: emitter),
          KtMapRemoveBenchmark(emitter: emitter),
          BuiltMapMapRemoveBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class MutableMapRemoveBenchmark extends MapBenchmarkBase {
  MutableMapRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  Map<String, int> map;

  @override
  Map<String, int> toMutable() => map;

  @override
  void setup() => map = MapBenchmarkBase.getDummyGeneratedMap(size: config.size);

  @override
  void run() => map.remove("1");
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class IMapRemoveBenchmark extends MapBenchmarkBase {
  IMapRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IMap", emitter: emitter);

  IMap<String, int> iMap;

  @override
  Map<String, int> toMutable() => iMap.unlock;

  @override
  void setup() =>
      iMap = IMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => iMap = iMap.remove("1");
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class KtMapRemoveBenchmark extends MapBenchmarkBase {
  KtMapRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> ktMap;

  @override
  Map<String, int> toMutable() => ktMap.asMap();

  @override
  void setup() =>
      ktMap = KtMap<String, int>.from(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => ktMap = ktMap.minus("1");
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltMapMapRemoveBenchmark extends MapBenchmarkBase {
  BuiltMapMapRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  BuiltMap<String, int> builtMap;

  @override
  Map<String, int> toMutable() => builtMap.asMap();

  @override
  void setup() =>
      builtMap = BuiltMap<String, int>.of(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() =>
      builtMap = builtMap.rebuild((MapBuilder<String, int> mapBuilder) => mapBuilder.remove("1"));
}

//////////////////////////////////////////////////////////////////////////////////////////////////
