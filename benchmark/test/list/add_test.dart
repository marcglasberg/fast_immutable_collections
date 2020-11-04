import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  group("Separate Benchmarks |", () {
    test("List (Mutable)", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_list_mutable", config: Config(runs: 100, size: 100));
      final MutableListAddBenchmark listAddBenchmark =
          MutableListAddBenchmark(emitter: tableScoreEmitter);

      listAddBenchmark.report();

      final List<int> expectedList = List<int>.generate(100, (int index) => index) +
          List<int>.generate(100, (int index) => index);
      expect(listAddBenchmark.toMutable(), expectedList);
    });

    test("IList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "add_iList", config: Config(runs: 100, size: 100));
      final IListAddBenchmark iListAddBenchmark = IListAddBenchmark(emitter: tableScoreEmitter);

      iListAddBenchmark.report();

      final List<int> expectedList = List<int>.generate(100, (int index) => index) +
          List<int>.generate(100, (int index) => index);
      expect(iListAddBenchmark.toMutable(), expectedList);
    });

    test("KtList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "list_add", config: Config(runs: 100, size: 100));
      final KtListAddBenchmark ktListAddBenchmark = KtListAddBenchmark(emitter: tableScoreEmitter);

      ktListAddBenchmark.report();

      final List<int> expectedList = List<int>.generate(100, (int index) => index) +
          List<int>.generate(100, (int index) => index);
      expect(ktListAddBenchmark.toMutable(), expectedList);
    });

    test("BuiltList with rebuild", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "list_add", config: Config(runs: 100, size: 100));
      final BuiltListAddWithRebuildBenchmark builtListAddWithRebuildBenchmark =
          BuiltListAddWithRebuildBenchmark(emitter: tableScoreEmitter);

      builtListAddWithRebuildBenchmark.report();

      final List<int> expectedList = List<int>.generate(100, (int index) => index) +
          List<int>.generate(100, (int index) => index);
      expect(builtListAddWithRebuildBenchmark.toMutable(), expectedList);
    });

    test("BuiltList with ListBuilder", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "list_add", config: Config(runs: 100, size: 100));
      final BuiltListAddWithListBuilderBenchmark builtListAddWithListBuilderBenchmark =
          BuiltListAddWithListBuilderBenchmark(emitter: tableScoreEmitter);

      builtListAddWithListBuilderBenchmark.report();

      final List<int> expectedList = List<int>.generate(100, (int index) => index) +
          List<int>.generate(100, (int index) => index);
      expect(builtListAddWithListBuilderBenchmark.toMutable(), expectedList);
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final ListAddBenchmark addBenchmark = ListAddBenchmark(config: Config(runs: 100, size: 100));

      addBenchmark.report();

      print(addBenchmark.emitter.table);

      final List<int> expectedList = List<int>.generate(100, (int index) => index) +
          List<int>.generate(100, (int index) => index);
      addBenchmark.benchmarks
          .forEach((ListBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedList));
    });
  });
}
