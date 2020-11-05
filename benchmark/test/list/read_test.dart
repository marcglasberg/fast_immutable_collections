import "package:test/test.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() {
  group("Separate Benchmarks |", () {
    test("List (Mutable)", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "read_list_mutable", config: Config(runs: 100, size: 1000));
      final MutableListReadBenchmark listReadBenchmark =
          MutableListReadBenchmark(emitter: tableScoreEmitter);

      listReadBenchmark.report();

      expect(listReadBenchmark.newVar,
          ListBenchmarkBase.getDummyGeneratedList(size: 1000)[ListReadBenchmark.indexToRead]);
    });

    test("IList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "read_iList", config: Config(runs: 100, size: 1000));
      final IListReadBenchmark iListReadBenchmark = IListReadBenchmark(emitter: tableScoreEmitter);

      iListReadBenchmark.report();

      expect(iListReadBenchmark.newVar,
          ListBenchmarkBase.getDummyGeneratedList(size: 1000)[ListReadBenchmark.indexToRead]);
    });

    test("KtList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "read_ktList", config: Config(runs: 100, size: 1000));
      final KtListReadBenchmark ktListReadBenchmark =
          KtListReadBenchmark(emitter: tableScoreEmitter);

      ktListReadBenchmark.report();

      expect(ktListReadBenchmark.newVar,
          ListBenchmarkBase.getDummyGeneratedList(size: 1000)[ListReadBenchmark.indexToRead]);
    });

    test("BuiltList", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "read_builtList", config: Config(runs: 100, size: 1000));
      final BuiltListReadBenchmark builtListReadBenchmark =
          BuiltListReadBenchmark(emitter: tableScoreEmitter);

      builtListReadBenchmark.report();

      expect(builtListReadBenchmark.newVar,
          ListBenchmarkBase.getDummyGeneratedList(size: 1000)[ListReadBenchmark.indexToRead]);
    });
  });

  group("Multiple Benchmarks |", () {
    test("Simple run", () {
      final TableScoreEmitter tableScoreEmitter =
          TableScoreEmitter(prefixName: "read", config: Config(runs: 100, size: 1000));
      final ListReadBenchmark readBenchmark = ListReadBenchmark(emitter: tableScoreEmitter);

      readBenchmark.report();

      readBenchmark.benchmarks.forEach((ListBenchmarkBase benchmark) => expect(
          benchmark.toMutable()[ListReadBenchmark.indexToRead],
          ListBenchmarkBase.getDummyGeneratedList(size: 1000)[ListReadBenchmark.indexToRead]));
    });
  });
}
