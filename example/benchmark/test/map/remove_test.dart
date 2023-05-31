import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("Map (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_map_mutable", config: Config(size: 100));
    final MutableMapRemoveBenchmark mutableMapRemoveBenchmark =
        MutableMapRemoveBenchmark(emitter: tableScoreEmitter);

    mutableMapRemoveBenchmark.report();

    expect(mutableMapRemoveBenchmark.toMutable(),
        MapBenchmarkBase.getDummyGeneratedMap(size: 100)..remove("50"));
  });

  

  test("IMap", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_iMap", config: Config(size: 100));
    final IMapRemoveBenchmark iMapRemoveBenchmark = IMapRemoveBenchmark(emitter: tableScoreEmitter);

    iMapRemoveBenchmark.report();

    expect(iMapRemoveBenchmark.toMutable(),
        MapBenchmarkBase.getDummyGeneratedMap(size: 100)..remove("50"));
  });

  

  test("KtMap", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_ktMap", config: Config(size: 100));
    final KtMapRemoveBenchmark ktMapRemoveBenchmark =
        KtMapRemoveBenchmark(emitter: tableScoreEmitter);

    ktMapRemoveBenchmark.report();

    expect(ktMapRemoveBenchmark.toMutable(),
        MapBenchmarkBase.getDummyGeneratedMap(size: 100)..remove("50"));
  });

  

  test("BuiltMap", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_builtMap", config: Config(size: 100));
    final BuiltMapMapRemoveBenchmark builtMapRemoveBenchmark =
        BuiltMapMapRemoveBenchmark(emitter: tableScoreEmitter);

    builtMapRemoveBenchmark.report();

    expect(builtMapRemoveBenchmark.toMutable(),
        MapBenchmarkBase.getDummyGeneratedMap(size: 100)..remove("50"));
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove", config: Config(size: 100));
    final MapRemoveBenchmark removeBenchmark = MapRemoveBenchmark(emitter: tableScoreEmitter);

    removeBenchmark.report();

    removeBenchmark.benchmarks.forEach((MapBenchmarkBase benchmark) => expect(
        benchmark.toMutable(), MapBenchmarkBase.getDummyGeneratedMap(size: 100)..remove("50")));
  });

  
}
