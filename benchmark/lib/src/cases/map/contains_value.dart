import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class MapContainsValueBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapContainsValueBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapContainsValueBenchmark(emitter: emitter),
          IMapContainsValueBenchmark(emitter: emitter),
          KtMapContainsValueBenchmark(emitter: emitter),
          BuiltMapContainsValueBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableMapContainsValueBenchmark extends MapBenchmarkBase {
  MutableMapContainsValueBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  Map<String, int> _map;
  bool _contains;

  bool get contains => _contains;

  @override
  Map<String, int> toMutable() => _map;

  @override
  void setup() => _map = MapBenchmarkBase.getDummyGeneratedMap(size: config.size);

  @override
  void run() {
    for (int i = 0; i < _map.length + 1; i++) _contains = _map.containsValue(i);
  }
}

class IMapContainsValueBenchmark extends MapBenchmarkBase {
  IMapContainsValueBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IMap", emitter: emitter);

  IMap<String, int> _iMap;
  bool _contains;

  bool get contains => _contains;

  @override
  Map<String, int> toMutable() => _iMap.unlock;

  @override
  void setup() =>
      _iMap = IMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _iMap.length + 1; i++) _contains = _iMap.containsValue(i);
  }
}

class KtMapContainsValueBenchmark extends MapBenchmarkBase {
  KtMapContainsValueBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> _ktMap;
  bool _contains;

  bool get contains => _contains;

  @override
  Map<String, int> toMutable() => _ktMap.asMap();

  @override
  void setup() => _ktMap = KtMap.from(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _ktMap.size + 1; i++) _contains = _ktMap.containsValue(i);
  }
}

class BuiltMapContainsValueBenchmark extends MapBenchmarkBase {
  BuiltMapContainsValueBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltMap", emitter: emitter);

  BuiltMap<String, int> _builtMap;
  bool _contains;

  bool get contains => _contains;

  @override
  Map<String, int> toMutable() => _builtMap.asMap();

  @override
  void setup() => _builtMap =
      BuiltMap<String, int>.of(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _builtMap.length + 1; i++) _contains = _builtMap.containsValue(i);
  }
}
