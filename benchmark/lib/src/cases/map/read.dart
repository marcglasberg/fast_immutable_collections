import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class MapReadBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  static const String keyToRead = "10";

  @override
  final List<MapBenchmarkBase> benchmarks;

  MapReadBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapReadBenchmark(emitter: emitter),
          IMapReadBenchmark(emitter: emitter),
          KtMapReadBenchmark(emitter: emitter),
          BuiltMapReadBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableMapReadBenchmark extends MapBenchmarkBase {
  MutableMapReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  Map<String, int> _map;
  int newVar;

  @override
  Map<String, int> toMutable() => _map;

  @override
  void setup() => _map = MapBenchmarkBase.getDummyGeneratedMap(size: config.size);

  @override
  void run() => newVar = _map[MapReadBenchmark.keyToRead];
}

class IMapReadBenchmark extends MapBenchmarkBase {
  IMapReadBenchmark({@required TableScoreEmitter emitter}) : super(name: "IMap", emitter: emitter);

  IMap<String, int> iMap;
  int newVar;

  @override
  Map<String, int> toMutable() => iMap.unlock;

  @override
  void setup() => iMap = IMap(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => newVar = iMap[MapReadBenchmark.keyToRead];
}

class KtMapReadBenchmark extends MapBenchmarkBase {
  KtMapReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> ktMap;
  int newVar;

  @override
  Map<String, int> toMutable() => ktMap.asMap();

  @override
  void setup() =>
      ktMap = KtMap<String, int>.from(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => newVar = ktMap[MapReadBenchmark.keyToRead];
}

class BuiltMapReadBenchmark extends MapBenchmarkBase {
  BuiltMapReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltMap", emitter: emitter);

  BuiltMap<String, int> builtMap;
  int newVar;

  @override
  Map<String, int> toMutable() => builtMap.asMap();

  @override
  void setup() =>
      builtMap = BuiltMap<String, int>.of(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => newVar = builtMap[MapReadBenchmark.keyToRead];
}
