import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("Set (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_all_set_mutable", config: Config(size: 100));
    final MutableSetAddAllBenchmark mutableSetAddAllBenchmark =
        MutableSetAddAllBenchmark(emitter: tableScoreEmitter);

    mutableSetAddAllBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    expect(mutableSetAddAllBenchmark.toMutable(), expectedSet);
  });

  

  test("ISet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_all_iSet", config: Config(size: 100));
    final ISetAddAllBenchmark iSetAddAllBenchmark = ISetAddAllBenchmark(emitter: tableScoreEmitter);

    iSetAddAllBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    expect(iSetAddAllBenchmark.toMutable(), expectedSet);
  });

  

  test("KtSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_all_ktSet", config: Config(size: 100));
    final KtSetAddAllBenchmark ktSetAddAllBenchmark =
        KtSetAddAllBenchmark(emitter: tableScoreEmitter);

    ktSetAddAllBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    expect(ktSetAddAllBenchmark.toMutable(), expectedSet);
  });

  

  test("BuiltSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_all_builtSet", config: Config(size: 100));
    final BuiltSetAddAllBenchmark builtSetAddAllBenchmark =
        BuiltSetAddAllBenchmark(emitter: tableScoreEmitter);

    builtSetAddAllBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    expect(builtSetAddAllBenchmark.toMutable(), expectedSet);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_all", config: Config(size: 100));
    final SetAddAllBenchmark setAddAllBenchmark = SetAddAllBenchmark(emitter: tableScoreEmitter);

    setAddAllBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    setAddAllBenchmark.benchmarks
        .forEach((SetBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedSet));
  });

  
}
