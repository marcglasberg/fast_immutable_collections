import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  group("Separate Benchmarks |", () {
    test("List (Mutable)", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_all_list_mutable", config: Config(size: 10));
      final MutableListAddAllBenchmark listAddAllBenchmark =
          MutableListAddAllBenchmark(emitter: tableScoreEmitter);

      listAddAllBenchmark.report();

      final List<int> expectedList = ListAddAllBenchmark.baseList + ListAddAllBenchmark.listToAdd;
      expect(listAddAllBenchmark.toMutable(), expectedList);
    });

    test("IList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_all_iList", config: Config(size: 10));
      final IListAddAllBenchmark iListAddAllBenchmark =
          IListAddAllBenchmark(emitter: tableScoreEmitter);

      iListAddAllBenchmark.report();

      final List<int> expectedList = ListAddAllBenchmark.baseList + ListAddAllBenchmark.listToAdd;
      expect(iListAddAllBenchmark.toMutable(), expectedList);
    });

    test("KtList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_all_ktList", config: Config(size: 10));
      final KtListAddAllBenchmark ktListAddAllBenchmark =
          KtListAddAllBenchmark(emitter: tableScoreEmitter);

      ktListAddAllBenchmark.report();

      final List<int> expectedList = ListAddAllBenchmark.baseList + ListAddAllBenchmark.listToAdd;
      expect(ktListAddAllBenchmark.toMutable(), expectedList);
    });

    test("BuiltList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_all_builtList", config: Config(size: 10));
      final BuiltListAddAllBenchmark builtListAddAllBenchmark =
          BuiltListAddAllBenchmark(emitter: tableScoreEmitter);

      builtListAddAllBenchmark.report();

      final List<int> expectedList = ListAddAllBenchmark.baseList + ListAddAllBenchmark.listToAdd;
      expect(builtListAddAllBenchmark.toMutable(), expectedList);
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_all", config: Config(size: 10));
      final ListAddAllBenchmark addAllBenchmark = ListAddAllBenchmark(emitter: tableScoreEmitter);

      addAllBenchmark.report();

      final List<int> expectedList = ListAddAllBenchmark.baseList + ListAddAllBenchmark.listToAdd;
      addAllBenchmark.benchmarks
          .forEach((ListBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedList));
    });
  });
}
