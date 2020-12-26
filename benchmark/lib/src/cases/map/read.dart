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
  int _newVar;

  int get newVar => _newVar;

  @override
  Map<String, int> toMutable() => _map;

  @override
  void setup() => _map = MapBenchmarkBase.getDummyGeneratedMap(size: config.size);

  @override
  void run() => _newVar = _map[MapReadBenchmark.keyToRead];
}

class IMapReadBenchmark extends MapBenchmarkBase {
  IMapReadBenchmark({@required TableScoreEmitter emitter}) : super(name: "IMap", emitter: emitter);

  IMap<String, int> _iMap;
  int _newVar;

  int get newVar => _newVar;

  @override
  Map<String, int> toMutable() => _iMap.unlock;

  @override
  void setup() => _iMap = IMap(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => _newVar = _iMap[MapReadBenchmark.keyToRead];
}

class KtMapReadBenchmark extends MapBenchmarkBase {
  KtMapReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> _ktMap;
  int _newVar;

  int get newVar => _newVar;

  @override
  Map<String, int> toMutable() => _ktMap.asMap();

  @override
  void setup() =>
      _ktMap = KtMap<String, int>.from(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => _newVar = _ktMap[MapReadBenchmark.keyToRead];
}

class BuiltMapReadBenchmark extends MapBenchmarkBase {
  BuiltMapReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltMap", emitter: emitter);

  BuiltMap<String, int> _builtMap;
  int _newVar;

  int get newVar => _newVar;

  @override
  Map<String, int> toMutable() => _builtMap.asMap();

  @override
  void setup() => _builtMap =
      BuiltMap<String, int>.of(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => _newVar = _builtMap[MapReadBenchmark.keyToRead];
}
