import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("Map (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_map_mutable", config: Config(size: 100));
    final MutableMapAddBenchmark mapAddBenchmark =
        MutableMapAddBenchmark(emitter: tableScoreEmitter);

    mapAddBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    expect(mapAddBenchmark.toMutable(), expectedMap);
  });

  

  test("IMap", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_iMap", config: Config(size: 100));
    final IMapAddBenchmark iMapAddBenchmark = IMapAddBenchmark(emitter: tableScoreEmitter);

    iMapAddBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    expect(iMapAddBenchmark.toMutable(), expectedMap);
  });

  

  test("KtMap", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_ktMap", config: Config(size: 100));
    final KtMapAddBenchmark ktMapAddBenchmark = KtMapAddBenchmark(emitter: tableScoreEmitter);

    ktMapAddBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    expect(ktMapAddBenchmark.toMutable(), expectedMap);
  });

  

  test("BuiltMap with Rebuild", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_builtMap_with_rebuild", config: Config(size: 100));
    final BuiltMapAddWithRebuildBenchmark builtMapAddWithRebuildBenchmark =
        BuiltMapAddWithRebuildBenchmark(emitter: tableScoreEmitter);

    builtMapAddWithRebuildBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    expect(builtMapAddWithRebuildBenchmark.toMutable(), expectedMap);
  });

  

  test("BuiltMap with ListBuilder", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_builtMap_with_listBuilder", config: Config(size: 100));
    final BuiltMapAddWithListBuilderBenchmark builtMapAddWithListBuilderBenchmark =
        BuiltMapAddWithListBuilderBenchmark(emitter: tableScoreEmitter);

    builtMapAddWithListBuilderBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    expect(builtMapAddWithListBuilderBenchmark.toMutable(), expectedMap);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add", config: Config(size: 100));
    final MapAddBenchmark addBenchmark = MapAddBenchmark(emitter: tableScoreEmitter);

    addBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 110);
    addBenchmark.benchmarks
        .forEach((MapBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedMap));
  });

  
}
