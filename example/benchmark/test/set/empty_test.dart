import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("Set (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "empty_set_mutable", config: Config(size: 100));
    final MutableSetEmptyBenchmark setEmptyBenchmark =
        MutableSetEmptyBenchmark(emitter: tableScoreEmitter);

    setEmptyBenchmark.report();

    expect(setEmptyBenchmark.toMutable(), <int>{});
  });

  

  test("ISet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "empty_iSet", config: Config(size: 100));
    final ISetEmptyBenchmark iSetEmptyBenchmark = ISetEmptyBenchmark(emitter: tableScoreEmitter);

    iSetEmptyBenchmark.report();

    expect(iSetEmptyBenchmark.toMutable(), <int>{});
  });

  

  test("KtSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "empty_ktSet", config: Config(size: 100));
    final KtSetEmptyBenchmark ktSetEmptyBenchmark = KtSetEmptyBenchmark(emitter: tableScoreEmitter);

    ktSetEmptyBenchmark.report();

    expect(ktSetEmptyBenchmark.toMutable(), <int>{});
  });

  

  test("BuiltSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "empty_builtSet", config: Config(size: 100));
    final BuiltSetEmptyBenchmark builtSetEmptyBenchmark =
        BuiltSetEmptyBenchmark(emitter: tableScoreEmitter);

    builtSetEmptyBenchmark.report();

    expect(builtSetEmptyBenchmark.toMutable(), <int>{});
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "empty", config: Config(size: 100));
    final SetEmptyBenchmark emptyBenchmark = SetEmptyBenchmark(emitter: tableScoreEmitter);

    emptyBenchmark.report();

    emptyBenchmark.benchmarks
        .forEach((SetBenchmarkBase benchmark) => expect(benchmark.toMutable(), <int>{}));
  });

  
}
