import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("Map (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_map_mutable", config: Config(size: 100));
    final MutableMapAddAllBenchmark mapAddAllBenchmark =
        MutableMapAddAllBenchmark(emitter: tableScoreEmitter);

    mapAddAllBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    expect(mapAddAllBenchmark.toMutable(), expectedMap);
  });

  

  test("IMap", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_map_iMap", config: Config(size: 100));
    final IMapAddAllBenchmark iMapAddAllBenchmark = IMapAddAllBenchmark(emitter: tableScoreEmitter);

    iMapAddAllBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    expect(iMapAddAllBenchmark.toMutable(), expectedMap);
  });

  

  test("KtMap", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_map_ktMap", config: Config(size: 100));
    final KtMapAddAllBenchmark ktMapAddAllBenchmark =
        KtMapAddAllBenchmark(emitter: tableScoreEmitter);

    ktMapAddAllBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    expect(ktMapAddAllBenchmark.toMutable(), expectedMap);
  });

  

  test("BuiltMap", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_map_builtMap", config: Config(size: 100));
    final BuiltMapAddAllBenchmark builtMapAddAllBenchmark =
        BuiltMapAddAllBenchmark(emitter: tableScoreEmitter);

    builtMapAddAllBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    expect(builtMapAddAllBenchmark.toMutable(), expectedMap);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_map", config: Config(size: 100));
    final MapAddAllBenchmark addAllBenchmark = MapAddAllBenchmark(emitter: tableScoreEmitter);

    addAllBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    for (final benchmark in addAllBenchmark.benchmarks) {
      expect(benchmark.toMutable(), expectedMap);
    }
  });

  
}
