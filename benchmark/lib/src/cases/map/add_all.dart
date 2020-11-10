import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class MapAddAllBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  static const Map<String, int> baseMap = {"1": 1, "2": 3}, mapToAdd = {"4": 4, "5": 5, "6": 6};

  @override
  final IList<MapBenchmarkBase> benchmarks;

  MapAddAllBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapAddAllBenchmark(emitter: emitter),
          IMapAddAllBenchmark(emitter: emitter),
          KtMapAddAllBenchmark(emitter: emitter),
          BuiltMapAddAllBenchmark(emitter: emitter),
        ].lock,
        super(emitter: emitter);
}

class MutableMapAddAllBenchmark extends MapBenchmarkBase {
  MutableMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  Map<String, int> _map;
  Map<String, int> _fixedMap;

  @override
  Map<String, int> toMutable() => _map;

  @override
  void setup() => _fixedMap = Map<String, int>.of(MapAddAllBenchmark.baseMap);

  @override
  void run() {
    _map = Map<String, int>.of(_fixedMap);
    _map.addAll(MapAddAllBenchmark.mapToAdd);
  }
}

class IMapAddAllBenchmark extends MapBenchmarkBase {
  IMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IMap", emitter: emitter);

  IMap<String, int> _iMap;
  IMap<String, int> _result;

  @override
  Map<String, int> toMutable() => _result.unlock;

  @override
  void setup() => _iMap = IMap<String, int>(MapAddAllBenchmark.baseMap);

  @override
  void run() => _result = _iMap.addAll(MapAddAllBenchmark.mapToAdd.lock);
}

class KtMapAddAllBenchmark extends MapBenchmarkBase {
  KtMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> _ktMap;
  KtMap<String, int> _result;

  @override
  Map<String, int> toMutable() => _result.asMap();

  @override
  void setup() => _ktMap = KtMap<String, int>.from(MapAddAllBenchmark.baseMap);

  @override
  void run() => _result = _ktMap.plus(KtMap<String, int>.from(MapAddAllBenchmark.mapToAdd));
}

class BuiltMapAddAllBenchmark extends MapBenchmarkBase {
  BuiltMapAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  BuiltMap<String, int> _builtMap;
  BuiltMap<String, int> _result;

  @override
  Map<String, int> toMutable() => _result.asMap();

  @override
  void setup() => _builtMap = BuiltMap<String, int>.of(MapAddAllBenchmark.baseMap);

  @override
  void run() => _result = _builtMap.rebuild(
      (MapBuilder<String, int> mapBuilder) => mapBuilder.addAll(MapAddAllBenchmark.mapToAdd));
}
