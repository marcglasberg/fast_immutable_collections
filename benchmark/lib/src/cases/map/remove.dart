import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

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

class MutableMapRemoveBenchmark extends MapBenchmarkBase {
  MutableMapRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  Map<String, int> _map;

  @override
  Map<String, int> toMutable() => _map;

  @override
  void setup() => _map = MapBenchmarkBase.getDummyGeneratedMap();

  @override
  void run() => _map.remove("1");
}

class IMapRemoveBenchmark extends MapBenchmarkBase {
  IMapRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IMap", emitter: emitter);

  IMap<String, int> _iMap;

  @override
  Map<String, int> toMutable() => _iMap.unlock;

  @override
  void setup() => _iMap = IMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap());

  @override
  void run() => _iMap = _iMap.remove("1");
}

class KtMapRemoveBenchmark extends MapBenchmarkBase {
  KtMapRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> _ktMap;

  @override
  Map<String, int> toMutable() => _ktMap.asMap();

  @override
  void setup() => _ktMap = KtMap<String, int>.from(MapBenchmarkBase.getDummyGeneratedMap());

  @override
  void run() => _ktMap = _ktMap.minus("1");
}

class BuiltMapMapRemoveBenchmark extends MapBenchmarkBase {
  BuiltMapMapRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  BuiltMap<String, int> _builtMap;

  @override
  Map<String, int> toMutable() => _builtMap.asMap();

  @override
  void setup() => _builtMap = BuiltMap<String, int>.of(MapBenchmarkBase.getDummyGeneratedMap());

  @override
  void run() =>
      _builtMap = _builtMap.rebuild((MapBuilder<String, int> mapBuilder) => mapBuilder.remove("1"));
}
