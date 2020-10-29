import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/"
    "fast_immutable_collections_benchmarks.dart";

void main() {
  const int size = 10;
  const Config config = Config(runs: 100, size: size);
  final List<int> expectedList = ListAddAllBenchmark.baseList + ListAddAllBenchmark.listToAdd;

  group("Separate Benchmarks |", () {
    final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(prefixName: "list_add_all");

    test("`List` (Mutable)", () {
      final MutableListAddAllBenchmark listAddAllBenchmark =
          MutableListAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      listAddAllBenchmark.report();

      expect(listAddAllBenchmark.toMutable(), expectedList);
    });

    test("`IList`", () {
      final IListAddAllBenchmark iListAddAllBenchmark =
          IListAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      iListAddAllBenchmark.report();

      expect(iListAddAllBenchmark.toMutable(), expectedList);
    });

    test("`KtList`", () {
      final KtListAddAllBenchmark ktListAddAllBenchmark =
          KtListAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      ktListAddAllBenchmark.report();

      expect(ktListAddAllBenchmark.toMutable(), expectedList);
    });

    test("`BuiltList`", () {
      final BuiltListAddAllBenchmark builtListAddAllBenchmark =
          BuiltListAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      builtListAddAllBenchmark.report();

      expect(builtListAddAllBenchmark.toMutable(), expectedList);
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final ListAddAllBenchmark addAllBenchmark = ListAddAllBenchmark(configs: [config, config]);

      addAllBenchmark.report();

      addAllBenchmark.benchmarks
          .forEach((ListBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedList));
    });
  });
}
