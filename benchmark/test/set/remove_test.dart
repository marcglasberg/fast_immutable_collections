import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Set (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_set_mutable", config: Config(size: 100));
    final MutableSetRemoveBenchmark mutableSetRemoveBenchmark =
        MutableSetRemoveBenchmark(emitter: tableScoreEmitter);

    mutableSetRemoveBenchmark.report();

    expect(mutableSetRemoveBenchmark.toMutable(),
        SetBenchmarkBase.getDummyGeneratedSet(size: 100)..remove(1));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("ISet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_iSet", config: Config(size: 100));
    final ISetRemoveBenchmark iSetRemoveBenchmark = ISetRemoveBenchmark(emitter: tableScoreEmitter);

    iSetRemoveBenchmark.report();

    expect(iSetRemoveBenchmark.toMutable(),
        SetBenchmarkBase.getDummyGeneratedSet(size: 100)..remove(1));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("KtSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_ktSet", config: Config(size: 100));
    final KtSetRemoveBenchmark ktSetRemoveBenchmark =
        KtSetRemoveBenchmark(emitter: tableScoreEmitter);

    ktSetRemoveBenchmark.report();

    expect(ktSetRemoveBenchmark.toMutable(),
        SetBenchmarkBase.getDummyGeneratedSet(size: 100)..remove(1));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("BuiltSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_builtSet", config: Config(size: 100));
    final BuiltSetRemoveBenchmark builtSetRemoveBenchmark =
        BuiltSetRemoveBenchmark(emitter: tableScoreEmitter);

    builtSetRemoveBenchmark.report();

    expect(builtSetRemoveBenchmark.toMutable(),
        SetBenchmarkBase.getDummyGeneratedSet(size: 100)..remove(1));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove", config: Config(size: 100));
    final SetRemoveBenchmark setRemoveBenchmark = SetRemoveBenchmark(emitter: tableScoreEmitter);

    setRemoveBenchmark.report();

    setRemoveBenchmark.benchmarks.forEach((SetBenchmarkBase benchmark) =>
        expect(benchmark.toMutable(), SetBenchmarkBase.getDummyGeneratedSet(size: 100)..remove(1)));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}
