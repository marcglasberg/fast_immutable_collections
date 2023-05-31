import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("Map (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "contains_value_map_mutable", config: Config(size: 10));
    final MutableMapContainsValueBenchmark mapContainsValueBenchmark =
        MutableMapContainsValueBenchmark(emitter: tableScoreEmitter);

    mapContainsValueBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 10);
    expect(mapContainsValueBenchmark.contains, isFalse);
    expect(mapContainsValueBenchmark.toMutable(), expectedMap);
  });

  

  test("IMap", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "contains_value_iMap", config: Config(size: 10));
    final IMapContainsValueBenchmark iMapContainsValueBenchmark =
        IMapContainsValueBenchmark(emitter: tableScoreEmitter);

    iMapContainsValueBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 10);
    expect(iMapContainsValueBenchmark.contains, isFalse);
    expect(iMapContainsValueBenchmark.toMutable(), expectedMap);
  });

  

  test("KtMap", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "contains_value_ktMap", config: Config(size: 10));
    final KtMapContainsValueBenchmark ktMapContainsValueBenchmark =
        KtMapContainsValueBenchmark(emitter: tableScoreEmitter);

    ktMapContainsValueBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 10);
    expect(ktMapContainsValueBenchmark.contains, isFalse);
    expect(ktMapContainsValueBenchmark.toMutable(), expectedMap);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "contains_value_builtMap", config: Config(size: 10));
    final BuiltMapContainsValueBenchmark builtMapContainsValueBenchmark =
        BuiltMapContainsValueBenchmark(emitter: tableScoreEmitter);

    builtMapContainsValueBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 10);
    expect(builtMapContainsValueBenchmark.contains, isFalse);
    expect(builtMapContainsValueBenchmark.toMutable(), expectedMap);
  });

  

  test("Simple run", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "contains_value", config: Config(size: 10));
    final MapContainsValueBenchmark mapContainsValueBenchmark =
        MapContainsValueBenchmark(emitter: tableScoreEmitter);

    mapContainsValueBenchmark.report();

    final Map<String, int> expectedMap = MapBenchmarkBase.getDummyGeneratedMap(size: 10);
    mapContainsValueBenchmark.benchmarks
        .forEach((MapBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedMap));
  });

  
}
