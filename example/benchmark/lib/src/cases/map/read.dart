import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

class MapReadBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapReadBenchmark({required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapReadBenchmark(emitter: emitter),
          IMapReadBenchmark(emitter: emitter),
          KtMapReadBenchmark(emitter: emitter),
          BuiltMapReadBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class MutableMapReadBenchmark extends MapBenchmarkBase {
  MutableMapReadBenchmark({required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  late Map<String, int> _map;
  late int newVar;

  @override
  Map<String, int> toMutable() => _map;

  @override
  void setup() => _map = MapBenchmarkBase.getDummyGeneratedMap(size: config.size);

  @override
  void run() => newVar = _map[(config.size ~/ 2).toString()]!;
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class IMapReadBenchmark extends MapBenchmarkBase {
  IMapReadBenchmark({required TableScoreEmitter emitter}) : super(name: "IMap", emitter: emitter);

  late IMap<String, int> iMap;
  late int newVar;

  @override
  Map<String, int> toMutable() => iMap.unlock;

  @override
  void setup() => iMap = IMap(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => newVar = iMap[(config.size ~/ 2).toString()]!;
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class KtMapReadBenchmark extends MapBenchmarkBase {
  KtMapReadBenchmark({required TableScoreEmitter emitter}) : super(name: "KtMap", emitter: emitter);

  late KtMap<String, int> ktMap;
  late int newVar;

  @override
  Map<String, int> toMutable() => ktMap.asMap();

  @override
  void setup() =>
      ktMap = KtMap<String, int>.from(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => newVar = ktMap[(config.size ~/ 2).toString()]!;
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltMapReadBenchmark extends MapBenchmarkBase {
  BuiltMapReadBenchmark({required TableScoreEmitter emitter})
      : super(name: "BuiltMap", emitter: emitter);

  late BuiltMap<String, int> builtMap;
  late int newVar;

  @override
  Map<String, int> toMutable() => builtMap.asMap();

  @override
  void setup() =>
      builtMap = BuiltMap<String, int>.of(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => newVar = builtMap[(config.size ~/ 2).toString()]!;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
