import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  group("Separate Benchmarks |", () {
    test("Map (Mutable)", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "empty_map_mutable", config: Config(size: 0));
      final MutableMapEmptyBenchmark mapEmptyBenchmark =
          MutableMapEmptyBenchmark(emitter: tableScoreEmitter);

      mapEmptyBenchmark.report();

      expect(mapEmptyBenchmark.toMutable(), <String, int>{});
    });

    test("IMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "empty_iMap", config: Config(size: 0));
      final IMapEmptyBenchmark iMapEmptyBenchmark = IMapEmptyBenchmark(emitter: tableScoreEmitter);

      iMapEmptyBenchmark.report();

      expect(iMapEmptyBenchmark.toMutable(), <String, int>{});
    });

    test("KtMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "empty_ktMap", config: Config(size: 0));
      final KtMapEmptyBenchmark ktMapEmptyBenchmark =
          KtMapEmptyBenchmark(emitter: tableScoreEmitter);

      ktMapEmptyBenchmark.report();

      expect(ktMapEmptyBenchmark.toMutable(), <String, int>{});
    });

    test("BuiltMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "empty_builtMap", config: Config(size: 0));
      final BuiltMapEmptyBenchmark builtMapEmptyBenchmark =
          BuiltMapEmptyBenchmark(emitter: tableScoreEmitter);

      builtMapEmptyBenchmark.report();

      expect(builtMapEmptyBenchmark.toMutable(), <String, int>{});
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "empty", config: Config(size: 0));
      final MapEmptyBenchmark emptyBenchmark = MapEmptyBenchmark(emitter: tableScoreEmitter);

      emptyBenchmark.report();

      emptyBenchmark.benchmarks
          .forEach((MapBenchmarkBase benchmark) => expect(benchmark.toMutable(), <String, int>{}));
    });
  });
}
