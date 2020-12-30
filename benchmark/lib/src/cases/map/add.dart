import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

class MapAddBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  static const int innerRuns = 100;

  @override
  final List<MapBenchmarkBase> benchmarks;

  MapAddBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapAddBenchmark(emitter: emitter),
          IMapAddBenchmark(emitter: emitter),
          KtMapAddBenchmark(emitter: emitter),
          BuiltMapAddWithRebuildBenchmark(emitter: emitter),
          BuiltMapAddWithListBuilderBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class MutableMapAddBenchmark extends MapBenchmarkBase {
  MutableMapAddBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  Map<String, int> map;
  Map<String, int> fixedMap;

  @override
  Map<String, int> toMutable() => map;

  @override
  void setup() => fixedMap = MapBenchmarkBase.getDummyGeneratedMap(size: config.size);

  @override
  void run() {
    map = Map<String, int>.of(fixedMap);
    for (int i = 0; i < MapAddBenchmark.innerRuns; i++) map.addAll({i.toString(): i});
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class IMapAddBenchmark extends MapBenchmarkBase {
  IMapAddBenchmark({@required TableScoreEmitter emitter}) : super(name: "IMap", emitter: emitter);

  IMap<String, int> iMap;
  IMap<String, int> result;

  @override
  Map<String, int> toMutable() => result.unlock;

  @override
  void setup() {
    iMap = IMap<String, int>();
    for (int i = 0; i < config.size; i++) iMap = iMap.add(i.toString(), i);
  }

  @override
  void run() {
    result = iMap;
    for (int i = 0; i < MapAddBenchmark.innerRuns; i++) result = result.add(i.toString(), i);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class KtMapAddBenchmark extends MapBenchmarkBase {
  KtMapAddBenchmark({@required TableScoreEmitter emitter}) : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> ktMap;
  KtMap<String, int> result;

  @override
  Map<String, int> toMutable() => result.asMap();

  @override
  void setup() => ktMap = MapBenchmarkBase.getDummyGeneratedMap(size: config.size).toImmutableMap();

  @override
  void run() {
    result = ktMap;
    for (int i = 0; i < MapAddBenchmark.innerRuns; i++)
      result = result.plus(<String, int>{i.toString(): i}.toImmutableMap());
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltMapAddWithRebuildBenchmark extends MapBenchmarkBase {
  BuiltMapAddWithRebuildBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltMap with Rebuild", emitter: emitter);

  BuiltMap<String, int> builtMap;
  BuiltMap<String, int> result;

  @override
  Map<String, int> toMutable() => result.asMap();

  @override
  void setup() =>
      builtMap = BuiltMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    result = builtMap;
    for (int i = 0; i < MapAddBenchmark.innerRuns; i++)
      result = result.rebuild((MapBuilder<String, int> mapBuilder) =>
          mapBuilder.addAll(<String, int>{i.toString(): i}));
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltMapAddWithListBuilderBenchmark extends MapBenchmarkBase {
  BuiltMapAddWithListBuilderBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltMap with ListBuilder", emitter: emitter);

  BuiltMap<String, int> builtMap;
  BuiltMap<String, int> result;

  @override
  Map<String, int> toMutable() => result.asMap();

  @override
  void setup() =>
      builtMap = BuiltMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    final MapBuilder<String, int> mapBuilder = builtMap.toBuilder();
    for (int i = 0; i < MapAddBenchmark.innerRuns; i++)
      mapBuilder.addAll(<String, int>{i.toString(): i});
    result = mapBuilder.build();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
