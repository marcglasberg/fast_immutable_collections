import 'package:test/test.dart';

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  group("Separate Benchmarks |", () {
    test("Map (Mutable)", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_map_mutable", config: Config(runs: 100, size: 100));
      final MutableMapAddBenchmark mapAddBenchmark =
          MutableMapAddBenchmark(emitter: tableScoreEmitter);

      mapAddBenchmark.report();

      final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 100);
      expectedMap.addAll(MapBenchmarkBase.getDummyGeneratedMap(size: 100));
      expect(mapAddBenchmark.toMutable(), expectedMap);
    });

    test("IMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_iMap", config: Config(runs: 100, size: 100));
      final IMapAddBenchmark iMapAddBenchmark = IMapAddBenchmark(emitter: tableScoreEmitter);

      iMapAddBenchmark.report();

      final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 100);
      expectedMap.addAll(MapBenchmarkBase.getDummyGeneratedMap(size: 100));
      expect(iMapAddBenchmark.toMutable(), expectedMap);
    });

    test("KtMap", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_ktMap", config: Config(runs: 100, size: 100));
      final KtMapAddBenchmark ktMapAddBenchmark = KtMapAddBenchmark(emitter: tableScoreEmitter);

      ktMapAddBenchmark.report();

      final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 100);
      expectedMap.addAll(MapBenchmarkBase.getDummyGeneratedMap(size: 100));
      expect(ktMapAddBenchmark.toMutable(), expectedMap);
    });

    test("BuiltMap with Rebuild", () {
      final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(
          prefixName: "add_builtMap_with_rebuild", config: Config(runs: 100, size: 100));
      final BuiltMapAddWithRebuildBenchmark builtMapAddWithRebuildBenchmark =
          BuiltMapAddWithRebuildBenchmark(emitter: tableScoreEmitter);

      builtMapAddWithRebuildBenchmark.report();

      final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 100);
      expectedMap.addAll(MapBenchmarkBase.getDummyGeneratedMap(size: 100));
      expect(builtMapAddWithRebuildBenchmark.toMutable(), expectedMap);
    });

    test("BuiltMap with ListBuilder", () {
      final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(
          prefixName: "add_builtMap_with_listBuilder", config: Config(runs: 100, size: 100));
      final BuiltMapAddWithListBuilderBenchmark builtMapAddWithListBuilderBenchmark =
          BuiltMapAddWithListBuilderBenchmark(emitter: tableScoreEmitter);

      builtMapAddWithListBuilderBenchmark.report();

      final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 100);
      expectedMap.addAll(MapBenchmarkBase.getDummyGeneratedMap(size: 100));
      expect(builtMapAddWithListBuilderBenchmark.toMutable(), expectedMap);
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add", config: Config(runs: 100, size: 100));
      final MapAddBenchmark addBenchmark = MapAddBenchmark(emitter: tableScoreEmitter);

      addBenchmark.report();

      final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 100);
      expectedMap.addAll(MapBenchmarkBase.getDummyGeneratedMap(size: 100));
      addBenchmark.benchmarks
          .forEach((MapBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedMap));
    });
  });
}
