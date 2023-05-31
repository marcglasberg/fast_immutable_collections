import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("Set (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_set_mutable", config: Config(size: 100));
    final MutableSetRemoveBenchmark mutableSetRemoveBenchmark =
        MutableSetRemoveBenchmark(emitter: tableScoreEmitter);

    mutableSetRemoveBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 100);
    expectedSet.remove(50);
    expect(mutableSetRemoveBenchmark.toMutable(), expectedSet);
  });

  

  test("ISet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_iSet", config: Config(size: 100));
    final ISetRemoveBenchmark iSetRemoveBenchmark = ISetRemoveBenchmark(emitter: tableScoreEmitter);

    iSetRemoveBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 100);
    expectedSet.remove(50);
    expect(iSetRemoveBenchmark.toMutable(), expectedSet);
  });

  

  test("KtSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_ktSet", config: Config(size: 100));
    final KtSetRemoveBenchmark ktSetRemoveBenchmark =
        KtSetRemoveBenchmark(emitter: tableScoreEmitter);

    ktSetRemoveBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 100);
    expectedSet.remove(50);
    expect(ktSetRemoveBenchmark.toMutable(), expectedSet);
  });

  

  test("BuiltSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_builtSet", config: Config(size: 100));
    final BuiltSetRemoveBenchmark builtSetRemoveBenchmark =
        BuiltSetRemoveBenchmark(emitter: tableScoreEmitter);

    builtSetRemoveBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 100);
    expectedSet.remove(50);
    expect(builtSetRemoveBenchmark.toMutable(), expectedSet);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove", config: Config(size: 100));
    final SetRemoveBenchmark setRemoveBenchmark = SetRemoveBenchmark(emitter: tableScoreEmitter);

    setRemoveBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 100);
    expectedSet.remove(50);
    setRemoveBenchmark.benchmarks
        .forEach((SetBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedSet));
  });

  
}
