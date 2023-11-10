// ignore_for_file: overridden_fields
import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:kt_dart/kt.dart";

class MapAddBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapAddBenchmark({required super.emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapAddBenchmark(emitter: emitter),
          IMapAddBenchmark(emitter: emitter),
          KtMapAddBenchmark(emitter: emitter),
          BuiltMapAddWithRebuildBenchmark(emitter: emitter),
          BuiltMapAddWithListBuilderBenchmark(emitter: emitter),
        ];
}

class MutableMapAddBenchmark extends MapBenchmarkBase {
  MutableMapAddBenchmark({required super.emitter}) : super(name: "Map (Mutable)");

  late Map<String, int> map;

  late int count;

  // Saves many copies of the initial list (created during setup).
  late List<Map<String, int>> initialMaps;

  @override
  Map<String, int> toMutable() => map;

  @override
  void setup() {
    count = 0;
    initialMaps = [];
    for (int i = 0; i <= max(1, 1000000 ~/ config.size); i++)
      initialMaps.add(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));
  }

  @override
  void run() {
    map = getNextMap();
    final int initialLength = map.length;
    for (int i = initialLength; i < initialLength + innerRuns(); i++) map.addAll({i.toString(): i});
  }

  Map<String, int> getNextMap() {
    if (count >= initialMaps.length - 1)
      count = 0;
    else
      count++;
    return initialMaps[count];
  }
}

class IMapAddBenchmark extends MapBenchmarkBase {
  IMapAddBenchmark({required super.emitter}) : super(name: "IMap");

  late IMap<String, int> iMap;
  late IMap<String, int> result;

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
    final int initialLength = iMap.length;
    for (int i = initialLength; i < initialLength + innerRuns(); i++)
      result = result.add(i.toString(), i);
  }
}

class KtMapAddBenchmark extends MapBenchmarkBase {
  KtMapAddBenchmark({required super.emitter}) : super(name: "KtMap");

  late KtMap<String, int> ktMap;
  late KtMap<String, int> result;

  @override
  Map<String, int> toMutable() => result.asMap();

  @override
  void setup() => ktMap = MapBenchmarkBase.getDummyGeneratedMap(size: config.size).toImmutableMap();

  @override
  void run() {
    result = ktMap;
    final int initialLength = ktMap.size;
    for (int i = initialLength; i < initialLength + innerRuns(); i++)
      result = result.plus(<String, int>{i.toString(): i}.toImmutableMap());
  }
}

class BuiltMapAddWithRebuildBenchmark extends MapBenchmarkBase {
  BuiltMapAddWithRebuildBenchmark({required super.emitter}) : super(name: "BuiltMap (Rebuild)");

  late BuiltMap<String, int> builtMap;
  late BuiltMap<String, int> result;

  @override
  Map<String, int> toMutable() => result.asMap();

  @override
  void setup() =>
      builtMap = BuiltMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    result = builtMap;
    final int initialLength = builtMap.length;
    for (int i = initialLength; i < initialLength + innerRuns(); i++)
      result = result.rebuild((MapBuilder<String, int> mapBuilder) =>
          mapBuilder.addAll(<String, int>{i.toString(): i}));
  }
}

class BuiltMapAddWithListBuilderBenchmark extends MapBenchmarkBase {
  BuiltMapAddWithListBuilderBenchmark({required super.emitter})
      : super(name: "BuiltMap (ListBuilder)");

  late BuiltMap<String, int> builtMap;
  late BuiltMap<String, int> result;

  @override
  Map<String, int> toMutable() => result.asMap();

  @override
  void setup() =>
      builtMap = BuiltMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    final MapBuilder<String, int> mapBuilder = builtMap.toBuilder();
    final int initialLength = builtMap.length;
    for (int i = initialLength; i < initialLength + innerRuns(); i++)
      mapBuilder.addAll(<String, int>{i.toString(): i});
    result = mapBuilder.build();
  }
}
