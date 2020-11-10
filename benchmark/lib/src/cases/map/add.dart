import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class MapAddBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  static const int innerRuns = 100;

  @override
  final IList<MapBenchmarkBase> benchmarks;

  MapAddBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapAddBenchmark(emitter: emitter),
          IMapAddBenchmark(emitter: emitter),
          KtMapAddBenchmark(emitter: emitter),
          BuiltMapAddWithRebuildBenchmark(emitter: emitter),
          BuiltMapAddWithListBuilderBenchmark(emitter: emitter),
        ].lock,
        super(emitter: emitter);
}

class MutableMapAddBenchmark extends MapBenchmarkBase {
  MutableMapAddBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  Map<String, int> _map;
  Map<String, int> _fixedMap;

  @override
  Map<String, int> toMutable() => _map;

  @override
  void setup() => _fixedMap = MapBenchmarkBase.getDummyGeneratedMap(size: config.size);

  @override
  void run() {
    _map = Map<String, int>.of(_fixedMap);
    for (int i = 0; i < MapAddBenchmark.innerRuns; i++) _map.addAll({i.toString(): i});
  }
}

class IMapAddBenchmark extends MapBenchmarkBase {
  IMapAddBenchmark({@required TableScoreEmitter emitter}) : super(name: "IMap", emitter: emitter);

  IMap<String, int> _iMap;
  IMap<String, int> _result;

  @override
  Map<String, int> toMutable() => _result.unlock;

  @override
  void setup() {
    _iMap = IMap<String, int>();
    for (int i = 0; i < config.size; i++) _iMap = _iMap.add(i.toString(), i);
  }

  @override
  void run() {
    _result = _iMap;
    for (int i = 0; i < MapAddBenchmark.innerRuns; i++) _result = _result.add(i.toString(), i);
  }
}

class KtMapAddBenchmark extends MapBenchmarkBase {
  KtMapAddBenchmark({@required TableScoreEmitter emitter}) : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> _ktMap;
  KtMap<String, int> _result;

  @override
  Map<String, int> toMutable() => _result.asMap();

  @override
  void setup() =>
      _ktMap = MapBenchmarkBase.getDummyGeneratedMap(size: config.size).toImmutableMap();

  @override
  void run() {
    _result = _ktMap;
    for (int i = 0; i < MapAddBenchmark.innerRuns; i++)
      _result = _result.plus(<String, int>{i.toString(): i}.toImmutableMap());
  }
}

class BuiltMapAddWithRebuildBenchmark extends MapBenchmarkBase {
  BuiltMapAddWithRebuildBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltMap with Rebuild", emitter: emitter);

  BuiltMap<String, int> _builtMap;
  BuiltMap<String, int> _result;

  @override
  Map<String, int> toMutable() => _result.asMap();

  @override
  void setup() =>
      _builtMap = BuiltMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    _result = _builtMap;
    for (int i = 0; i < MapAddBenchmark.innerRuns; i++)
      _result = _result.rebuild((MapBuilder<String, int> mapBuilder) =>
          mapBuilder.addAll(<String, int>{i.toString(): i}));
  }
}

class BuiltMapAddWithListBuilderBenchmark extends MapBenchmarkBase {
  BuiltMapAddWithListBuilderBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltMap with ListBuilder", emitter: emitter);

  BuiltMap<String, int> _builtMap;
  BuiltMap<String, int> _result;

  @override
  Map<String, int> toMutable() => _result.asMap();

  @override
  void setup() =>
      _builtMap = BuiltMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    final MapBuilder<String, int> mapBuilder = _builtMap.toBuilder();
    for (int i = 0; i < MapAddBenchmark.innerRuns; i++)
      mapBuilder.addAll(<String, int>{i.toString(): i});
    _result = mapBuilder.build();
  }
}
