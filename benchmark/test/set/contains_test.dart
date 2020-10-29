import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/"
    "fast_immutable_collections_benchmarks.dart";

void main() {
  const int size = 100;
  const Config config = Config(runs: 100, size: size);
  const bool expectedContains = false;
  final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: config.size);

  group("Separate Benchmarks |", () {
    final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(prefixName: "set_read");

    test("`Set` (Mutable)", () {
      final MutableSetContainsBenchmark mutableSetContainsBenchmark =
          MutableSetContainsBenchmark(config: config, emitter: tableScoreEmitter);

      mutableSetContainsBenchmark.report();

      expect(mutableSetContainsBenchmark.toMutable(), expectedSet);
      expect(mutableSetContainsBenchmark.contains, expectedContains);
    });

    test("`ISet`", () {
      final ISetContainsBenchmark iSetContainsBenchmark =
          ISetContainsBenchmark(config: config, emitter: tableScoreEmitter);

      iSetContainsBenchmark.report();

      expect(iSetContainsBenchmark.toMutable(), expectedSet);
      expect(iSetContainsBenchmark.contains, expectedContains);
    });

    test("`KtSet`", () {
      final KtSetContainsBenchmark ktSetContainsBenchmark =
          KtSetContainsBenchmark(config: config, emitter: tableScoreEmitter);

      ktSetContainsBenchmark.report();

      expect(ktSetContainsBenchmark.toMutable(), expectedSet);
      expect(ktSetContainsBenchmark.contains, expectedContains);
    });

    test("`BuiltSet`", () {
      final BuiltSetContainsBenchmark builtSetContainsBenchmark =
          BuiltSetContainsBenchmark(config: config, emitter: tableScoreEmitter);

      builtSetContainsBenchmark.report();

      expect(builtSetContainsBenchmark.toMutable(), expectedSet);
      expect(builtSetContainsBenchmark.contains, expectedContains);
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final SetContainsBenchmark setContainsBenchmark =
          SetContainsBenchmark(configs: [config, config]);

      setContainsBenchmark.report();

      setContainsBenchmark.benchmarks
          .forEach((SetBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedSet));
    });
  });
}
