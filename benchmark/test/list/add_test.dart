import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  const int size = 10;
  const Config config = Config(runs: 100, size: size);
  final List<int> expectedList = ListBenchmarkBase.getDummyGeneratedList(size: size) +
      List<int>.generate(ListAddBenchmark.innerRuns, (int index) => index);

  group("Separate Benchmarks |", () {
    final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(prefixName: "list_add");

    test("`List` (Mutable)", () {
      final MutableListAddBenchmark listAddBenchmark =
          MutableListAddBenchmark(config: config, emitter: tableScoreEmitter);

      listAddBenchmark.report();

      expect(listAddBenchmark.toMutable(), expectedList);
    });

    test("`IList`", () {
      final IListAddBenchmark iListAddBenchmark =
          IListAddBenchmark(config: config, emitter: tableScoreEmitter);

      iListAddBenchmark.report();

      expect(iListAddBenchmark.toMutable(), expectedList);
    });

    test("`KtList`", () {
      final KtListAddBenchmark ktListAddBenchmark =
          KtListAddBenchmark(config: config, emitter: tableScoreEmitter);

      ktListAddBenchmark.report();

      expect(ktListAddBenchmark.toMutable(), expectedList);
    });

    test("`BuiltList` with `rebuild`", () {
      final BuiltListAddWithRebuildBenchmark builtListAddWithRebuildBenchmark =
          BuiltListAddWithRebuildBenchmark(config: config, emitter: tableScoreEmitter);

      builtListAddWithRebuildBenchmark.report();

      expect(builtListAddWithRebuildBenchmark.toMutable(), expectedList);
    });

    test("`BuiltList` with `ListBuilder`", () {
      final BuiltListAddWithListBuilderBenchmark builtListAddWithListBuilderBenchmark =
          BuiltListAddWithListBuilderBenchmark(config: config, emitter: tableScoreEmitter);

      builtListAddWithListBuilderBenchmark.report();

      expect(builtListAddWithListBuilderBenchmark.toMutable(), expectedList);
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final ListAddBenchmark addBenchmark = ListAddBenchmark(configs: [config, config]);

      addBenchmark.report();

      addBenchmark.benchmarks
          .forEach((ListBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedList));
    });
  });
}
