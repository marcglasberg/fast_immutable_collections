import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  group("Separate Benchmarks |", () {
    test("Map (Mutable)", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_map_mutable", config: Config(runs: 100, size: 10));
      final MutableMapAddAllBenchmark mapAddAllBenchmark =
          MutableMapAddAllBenchmark(emitter: tableScoreEmitter);

      mapAddAllBenchmark.report();

      final Map<String, int> expectedMap = Map.of(MapAddAllBenchmark.baseMap)
        ..addAll(MapAddAllBenchmark.mapToAdd);
      expect(mapAddAllBenchmark.toMutable(), expectedMap);
    });

    test("IMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_map_iMap", config: Config(runs: 100, size: 10));
      final IMapAddAllBenchmark iMapAddAllBenchmark =
          IMapAddAllBenchmark(emitter: tableScoreEmitter);

      iMapAddAllBenchmark.report();

      final Map<String, int> expectedMap = Map.of(MapAddAllBenchmark.baseMap)
        ..addAll(MapAddAllBenchmark.mapToAdd);
      expect(iMapAddAllBenchmark.toMutable(), expectedMap);
    });

    test("KtMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_map_ktMap", config: Config(runs: 100, size: 10));
      final KtMapAddAllBenchmark ktMapAddAllBenchmark =
          KtMapAddAllBenchmark(emitter: tableScoreEmitter);

      ktMapAddAllBenchmark.report();

      final Map<String, int> expectedMap = Map.of(MapAddAllBenchmark.baseMap)
        ..addAll(MapAddAllBenchmark.mapToAdd);
      expect(ktMapAddAllBenchmark.toMutable(), expectedMap);
    });

    test("BuiltMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_map_builtMap", config: Config(runs: 100, size: 10));
      final BuiltMapAddAllBenchmark builtMapAddAllBenchmark =
          BuiltMapAddAllBenchmark(emitter: tableScoreEmitter);

      builtMapAddAllBenchmark.report();

      final Map<String, int> expectedMap = Map.of(MapAddAllBenchmark.baseMap)
        ..addAll(MapAddAllBenchmark.mapToAdd);
      expect(builtMapAddAllBenchmark.toMutable(), expectedMap);
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_map", config: Config(runs: 100, size: 10));
      final MapAddAllBenchmark addAllBenchmark = MapAddAllBenchmark(emitter: tableScoreEmitter);

      addAllBenchmark.report();

      final Map<String, int> expectedMap = Map.of(MapAddAllBenchmark.baseMap)
        ..addAll(MapAddAllBenchmark.mapToAdd);
      addAllBenchmark.benchmarks
          .forEach((MapBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedMap));
    });
  });
}
