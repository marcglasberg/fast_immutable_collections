import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("Set (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "read_set_mutable", config: Config(size: 100));
    final MutableSetContainsBenchmark mutableSetContainsBenchmark =
        MutableSetContainsBenchmark(emitter: tableScoreEmitter);

    mutableSetContainsBenchmark.report();

    expect(
        mutableSetContainsBenchmark.toMutable(), SetBenchmarkBase.getDummyGeneratedSet(size: 100));
    expect(mutableSetContainsBenchmark.contains, isFalse);
  });

  

  test("ISet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "read_iSet", config: Config(size: 100));
    final ISetContainsBenchmark iSetContainsBenchmark =
        ISetContainsBenchmark(emitter: tableScoreEmitter);

    iSetContainsBenchmark.report();

    expect(iSetContainsBenchmark.toMutable(), SetBenchmarkBase.getDummyGeneratedSet(size: 100));
    expect(iSetContainsBenchmark.contains, isFalse);
  });

  

  test("KtSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "read_ktSet", config: Config(size: 100));
    final KtSetContainsBenchmark ktSetContainsBenchmark =
        KtSetContainsBenchmark(emitter: tableScoreEmitter);

    ktSetContainsBenchmark.report();

    expect(ktSetContainsBenchmark.toMutable(), SetBenchmarkBase.getDummyGeneratedSet(size: 100));
    expect(ktSetContainsBenchmark.contains, isFalse);
  });

  

  test("BuiltSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "read_builtSet", config: Config(size: 100));
    final BuiltSetContainsBenchmark builtSetContainsBenchmark =
        BuiltSetContainsBenchmark(emitter: tableScoreEmitter);

    builtSetContainsBenchmark.report();

    expect(builtSetContainsBenchmark.toMutable(), SetBenchmarkBase.getDummyGeneratedSet(size: 100));
    expect(builtSetContainsBenchmark.contains, isFalse);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "read", config: Config(size: 100));
    final SetContainsBenchmark setContainsBenchmark =
        SetContainsBenchmark(emitter: tableScoreEmitter);

    setContainsBenchmark.report();

    setContainsBenchmark.benchmarks.forEach((SetBenchmarkBase benchmark) =>
        expect(benchmark.toMutable(), SetBenchmarkBase.getDummyGeneratedSet(size: 100)));
  });

  
}
