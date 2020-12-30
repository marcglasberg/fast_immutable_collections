import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

class MapAddAllBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  static const Map<String, int> baseMap = {"1": 1, "2": 3}, mapToAdd = {"4": 4, "5": 5, "6": 6};

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
  Map<String, int> fixedMap;

  @override
  Map<String, int> toMutable() => map;

  @override
  void setup() => fixedMap = Map<String, int>.of(MapAddAllBenchmark.baseMap);

  @override
  void run() {
    map = Map<String, int>.of(fixedMap);
    map.addAll(MapAddAllBenchmark.mapToAdd);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class IMapAddAllBenchmark extends MapBenchmarkBase {
  IMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IMap", emitter: emitter);

  IMap<String, int> iMap;
  IMap<String, int> result;

  @override
  Map<String, int> toMutable() => result.unlock;

  @override
  void setup() => iMap = IMap<String, int>(MapAddAllBenchmark.baseMap);

  @override
  void run() => result = iMap.addAll(MapAddAllBenchmark.mapToAdd.lock);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class KtMapAddAllBenchmark extends MapBenchmarkBase {
  KtMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> ktMap;
  KtMap<String, int> result;

  @override
  Map<String, int> toMutable() => result.asMap();

  @override
  void setup() => ktMap = KtMap<String, int>.from(MapAddAllBenchmark.baseMap);

  @override
  void run() => result = ktMap.plus(KtMap<String, int>.from(MapAddAllBenchmark.mapToAdd));
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltMapAddAllBenchmark extends MapBenchmarkBase {
  BuiltMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltMap", emitter: emitter);

  BuiltMap<String, int> builtMap;
  BuiltMap<String, int> result;

  @override
  Map<String, int> toMutable() => result.asMap();

  @override
  void setup() => builtMap = BuiltMap<String, int>.of(MapAddAllBenchmark.baseMap);

  @override
  void run() => result = builtMap.rebuild(
      (MapBuilder<String, int> mapBuilder) => mapBuilder.addAll(MapAddAllBenchmark.mapToAdd));
}

//////////////////////////////////////////////////////////////////////////////////////////////////
