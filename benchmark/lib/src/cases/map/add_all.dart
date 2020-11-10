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
