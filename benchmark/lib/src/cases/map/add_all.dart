import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

class MapAddAllBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapAddAllBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapAddAllBenchmark(emitter: emitter),
          IMapAddAllBenchmark(emitter: emitter),
          KtMapAddAllBenchmark(emitter: emitter),
          BuiltMapAddAllBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class MutableMapAddAllBenchmark extends MapBenchmarkBase {
  MutableMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  Map<String, int> map;
  Map<String, int> toBeAdded;

  int count;

  // Saves many copies of the initial list (created during setup).
  List<Map<String, int>> initialMaps;

  @override
  Map<String, int> toMutable() => map;

  @override
  void setup() {
    count = 0;
    initialMaps = [];
    toBeAdded = MapBenchmarkBase.getDummyGeneratedMap(size: config.size + config.size ~/ 10);
    for (int i = 0; i <= max(1, 1000000 ~/ config.size); i++)
      initialMaps.add(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));
  }

  @override
  void run() {
    map = getNextMap();
    map.addAll(toBeAdded);
  }

  Map<String, int> getNextMap() {
    if (count >= initialMaps.length - 1)
      count = 0;
    else
      count++;
    return initialMaps[count];
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class IMapAddAllBenchmark extends MapBenchmarkBase {
  IMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IMap", emitter: emitter);

  IMap<String, int> iMap;
  IMap<String, int> result;
  IMap<String, int> toBeAdded;

  @override
  Map<String, int> toMutable() => result.unlock;

  @override
  void setup() {
    toBeAdded = MapBenchmarkBase.getDummyGeneratedMap(size: config.size + config.size ~/ 10).lock;
    iMap = IMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));
  }

  @override
  void run() => result = iMap.addAll(toBeAdded);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class KtMapAddAllBenchmark extends MapBenchmarkBase {
  KtMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> ktMap;
  KtMap<String, int> result;
  KtMap<String, int> toBeAdded;

  @override
  Map<String, int> toMutable() => result.asMap();

  @override
  void setup() {
    toBeAdded = KtMap<String, int>.from(
        MapBenchmarkBase.getDummyGeneratedMap(size: config.size + config.size ~/ 10));
    ktMap = KtMap<String, int>.from(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));
  }

  @override
  void run() => result = ktMap.plus(toBeAdded);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltMapAddAllBenchmark extends MapBenchmarkBase {
  BuiltMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltMap", emitter: emitter);

  BuiltMap<String, int> builtMap;
  BuiltMap<String, int> result;
  BuiltMap<String, int> toBeAdded;

  @override
  Map<String, int> toMutable() => result.asMap();

  @override
  void setup() {
    toBeAdded = BuiltMap<String, int>.of(
        MapBenchmarkBase.getDummyGeneratedMap(size: config.size + config.size ~/ 10));
    builtMap = BuiltMap<String, int>.of(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));
  }

  @override
  void run() => result = builtMap
      .rebuild((MapBuilder<String, int> mapBuilder) => mapBuilder.addAll(toBeAdded.asMap()));
}

//////////////////////////////////////////////////////////////////////////////////////////////////
