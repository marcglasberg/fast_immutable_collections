// ignore_for_file: overridden_fields
import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:kt_dart/kt.dart";

class MapContainsValueBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapContainsValueBenchmark({required super.emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapContainsValueBenchmark(emitter: emitter),
          IMapContainsValueBenchmark(emitter: emitter),
          KtMapContainsValueBenchmark(emitter: emitter),
          BuiltMapContainsValueBenchmark(emitter: emitter),
        ];
}

class MutableMapContainsValueBenchmark extends MapBenchmarkBase {
  MutableMapContainsValueBenchmark({required super.emitter}) : super(name: "Map (Mutable)");

  late Map<String, int> map;
  late bool contains;

  @override
  Map<String, int> toMutable() => map;

  @override
  void setup() => map = MapBenchmarkBase.getDummyGeneratedMap(size: config.size);

  @override
  void run() {
    for (int i = 0; i < map.length + 1; i++) contains = map.containsValue(i);
  }
}

class IMapContainsValueBenchmark extends MapBenchmarkBase {
  IMapContainsValueBenchmark({required super.emitter}) : super(name: "IMap");

  late IMap<String, int> iMap;
  late bool contains;

  @override
  Map<String, int> toMutable() => iMap.unlock;

  @override
  void setup() =>
      iMap = IMap<String, int>(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    for (int i = 0; i < iMap.length + 1; i++) contains = iMap.containsValue(i);
  }
}

class KtMapContainsValueBenchmark extends MapBenchmarkBase {
  KtMapContainsValueBenchmark({required super.emitter}) : super(name: "KtMap");

  late KtMap<String, int> ktMap;
  late bool contains;

  @override
  Map<String, int> toMutable() => ktMap.asMap();

  @override
  void setup() => ktMap = KtMap.from(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    for (int i = 0; i < ktMap.size + 1; i++) contains = ktMap.containsValue(i);
  }
}

class BuiltMapContainsValueBenchmark extends MapBenchmarkBase {
  BuiltMapContainsValueBenchmark({required super.emitter}) : super(name: "BuiltMap");

  late BuiltMap<String, int> builtMap;
  late bool contains;

  @override
  Map<String, int> toMutable() => builtMap.asMap();

  @override
  void setup() =>
      builtMap = BuiltMap<String, int>.of(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() {
    for (int i = 0; i < builtMap.length + 1; i++) contains = builtMap.containsValue(i);
  }
}
