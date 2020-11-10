import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  group("Separate Benchmarks |", () {
    test("Map (Mutable)", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "remove_map_mutable", config: Config(runs: 100, size: 100));
      final MutableMapRemoveBenchmark mutableMapRemoveBenchmark =
          MutableMapRemoveBenchmark(emitter: tableScoreEmitter);

      mutableMapRemoveBenchmark.report();

      expect(mutableMapRemoveBenchmark.toMutable(),
          MapBenchmarkBase.getDummyGeneratedMap()..remove("1"));
    });

    test("IMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "remove_iMap", config: Config(runs: 100, size: 100));
      final IMapRemoveBenchmark iMapRemoveBenchmark =
          IMapRemoveBenchmark(emitter: tableScoreEmitter);

      iMapRemoveBenchmark.report();

      expect(iMapRemoveBenchmark.toMutable(), MapBenchmarkBase.getDummyGeneratedMap()..remove("1"));
    });

    test("KtMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "remove_ktMap", config: Config(runs: 100, size: 100));
      final KtMapRemoveBenchmark ktMapRemoveBenchmark =
          KtMapRemoveBenchmark(emitter: tableScoreEmitter);

      ktMapRemoveBenchmark.report();

      expect(
          ktMapRemoveBenchmark.toMutable(), MapBenchmarkBase.getDummyGeneratedMap()..remove("1"));
    });

    test("BuiltMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "remove_builtMap", config: Config(runs: 100, size: 100));
      final BuiltMapMapRemoveBenchmark builtMapRemoveBenchmark =
          BuiltMapMapRemoveBenchmark(emitter: tableScoreEmitter);

      builtMapRemoveBenchmark.report();

      expect(
          builtMapRemoveBenchmark.toMutable(), MapBenchmarkBase.getDummyGeneratedMap()..remove("1"));
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "remove", config: Config(runs: 100, size: 100));
      final MapRemoveBenchmark removeBenchmark = MapRemoveBenchmark(emitter: tableScoreEmitter);

      removeBenchmark.report();

      removeBenchmark.benchmarks.forEach((MapBenchmarkBase benchmark) =>
          expect(benchmark.toMutable(), MapBenchmarkBase.getDummyGeneratedMap()..remove("1")));
    });
  });
}
