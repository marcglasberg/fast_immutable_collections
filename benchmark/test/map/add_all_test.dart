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
