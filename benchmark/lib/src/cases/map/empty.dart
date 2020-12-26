import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class MapEmptyBenchmark extends MultiBenchmarkReporter<MapBenchmarkBase> {
  @override
  final List<MapBenchmarkBase> benchmarks;

  MapEmptyBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <MapBenchmarkBase>[
          MutableMapEmptyBenchmark(emitter: emitter),
          IMapEmptyBenchmark(emitter: emitter),
          KtMapEmptyBenchmark(emitter: emitter),
          BuiltMapEmptyBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableMapEmptyBenchmark extends MapBenchmarkBase {
  MutableMapEmptyBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Map (Mutable)", emitter: emitter);

  Map<String, int> _map;

  @override
  Map<String, int> toMutable() => _map;

  @override
  void run() => _map = <String, int>{};
}

class IMapEmptyBenchmark extends MapBenchmarkBase {
  IMapEmptyBenchmark({@required TableScoreEmitter emitter}) : super(name: "IMap", emitter: emitter);

  IMap<String, int> _iMap;

  @override
  Map<String, int> toMutable() => _iMap.unlock;

  @override
  void run() => _iMap = IMap<String, int>();
}

class KtMapEmptyBenchmark extends MapBenchmarkBase {
  KtMapEmptyBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtMap", emitter: emitter);

  KtMap<String, int> _ktMap;

  @override
  Map<String, int> toMutable() => _ktMap.asMap();

  @override
  void run() => _ktMap = KtMap<String, int>.empty();
}

class BuiltMapEmptyBenchmark extends MapBenchmarkBase {
  BuiltMapEmptyBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltMap", emitter: emitter);

  BuiltMap<String, int> _builtMap;

  @override
  Map<String, int> toMutable() => _builtMap.asMap();

  @override
  void run() => _builtMap = BuiltMap<String, int>();
}
