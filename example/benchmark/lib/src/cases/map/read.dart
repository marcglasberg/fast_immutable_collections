// ignore_for_file: overridden_fields
import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:kt_dart/kt.dart";

class MapReadBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapReadBenchmark({required super.emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapReadBenchmark(emitter: emitter),
          IMapReadBenchmark(emitter: emitter),
          KtMapReadBenchmark(emitter: emitter),
          BuiltMapReadBenchmark(emitter: emitter),
        ];
}

class MutableMapReadBenchmark extends MapBenchmarkBase {
  MutableMapReadBenchmark({required super.emitter}) : super(name: "Map (Mutable)");

  late Map<String, int> _map;
  late int newVar;

  @override
  Map<String, int> toMutable() => _map;

  @override
  void setup() => _map = MapBenchmarkBase.getDummyGeneratedMap(size: config.size);

  @override
  void run() => newVar = _map[(config.size ~/ 2).toString()]!;
}

class IMapReadBenchmark extends MapBenchmarkBase {
  IMapReadBenchmark({required super.emitter}) : super(name: "IMap");

  late IMap<String, int> iMap;
  late int newVar;

  @override
  Map<String, int> toMutable() => iMap.unlock;

  @override
  void setup() => iMap = IMap(MapBenchmarkBase.getDummyGeneratedMap(size: config.size));

  @override
  void run() => newVar = iMap[(config.size ~/ 2).toString()]!;
}

class KtMapReadBenchmark extends MapBenchmarkBase {
  KtMapReadBenchmark({required super.emitter}) : super(name: "KtMap");

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

class BuiltMapReadBenchmark extends MapBenchmarkBase {
  BuiltMapReadBenchmark({required super.emitter}) : super(name: "BuiltMap");

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
