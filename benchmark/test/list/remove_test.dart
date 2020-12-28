import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  group("Separate Benchmarks |", () {
    test("List (Mutable)", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "remove_list_mutable", config: Config(size: 100));
      final MutableListRemoveBenchmark listRemoveBenchmark =
          MutableListRemoveBenchmark(emitter: tableScoreEmitter);

      listRemoveBenchmark.report();

      expect(listRemoveBenchmark.toMutable(), ListBenchmarkBase.getDummyGeneratedList()..remove(1));
    });

    test("IList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "remove_list_mutable", config: Config(size: 100));
      final IListRemoveBenchmark iListRemoveBenchmark =
          IListRemoveBenchmark(emitter: tableScoreEmitter);

      iListRemoveBenchmark.report();

      expect(
          iListRemoveBenchmark.toMutable(), ListBenchmarkBase.getDummyGeneratedList()..remove(1));
    });

    test("KtList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "remove_list_mutable", config: Config(size: 100));
      final KtListRemoveBenchmark ktListRemoveBenchmark =
          KtListRemoveBenchmark(emitter: tableScoreEmitter);

      ktListRemoveBenchmark.report();

      expect(
          ktListRemoveBenchmark.toMutable(), ListBenchmarkBase.getDummyGeneratedList()..remove(1));
    });

    test("BuiltList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "remove_list_mutable", config: Config(size: 100));
      final BuiltListRemoveBenchmark builtListRemoveBenchmark =
          BuiltListRemoveBenchmark(emitter: tableScoreEmitter);

      builtListRemoveBenchmark.report();

      expect(builtListRemoveBenchmark.toMutable(),
          ListBenchmarkBase.getDummyGeneratedList()..remove(1));
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "remove_list_mutable", config: Config(size: 100));
      final ListRemoveBenchmark removeBenchmark = ListRemoveBenchmark(emitter: tableScoreEmitter);

      removeBenchmark.report();

      removeBenchmark.benchmarks.forEach((ListBenchmarkBase benchmark) =>
          expect(benchmark.toMutable(), ListBenchmarkBase.getDummyGeneratedList()..remove(1)));
    });
  });
}
