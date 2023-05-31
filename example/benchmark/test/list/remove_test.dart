import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("List (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_list_mutable", config: Config(size: 100));
    final MutableListRemoveBenchmark listRemoveBenchmark =
        MutableListRemoveBenchmark(emitter: tableScoreEmitter);

    listRemoveBenchmark.report();

    expect(listRemoveBenchmark.toMutable(),
        ListBenchmarkBase.getDummyGeneratedList(size: 100)..remove(50));
  });

  

  test("IList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_list_mutable", config: Config(size: 100));
    final IListRemoveBenchmark iListRemoveBenchmark =
        IListRemoveBenchmark(emitter: tableScoreEmitter);

    iListRemoveBenchmark.report();

    expect(iListRemoveBenchmark.toMutable(),
        ListBenchmarkBase.getDummyGeneratedList(size: 100)..remove(50));
  });

  

  test("KtList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_list_mutable", config: Config(size: 100));
    final KtListRemoveBenchmark ktListRemoveBenchmark =
        KtListRemoveBenchmark(emitter: tableScoreEmitter);

    ktListRemoveBenchmark.report();

    expect(ktListRemoveBenchmark.toMutable(),
        ListBenchmarkBase.getDummyGeneratedList(size: 100)..remove(50));
  });

  

  test("BuiltList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_list_mutable", config: Config(size: 100));
    final BuiltListRemoveBenchmark builtListRemoveBenchmark =
        BuiltListRemoveBenchmark(emitter: tableScoreEmitter);

    builtListRemoveBenchmark.report();

    expect(builtListRemoveBenchmark.toMutable(),
        ListBenchmarkBase.getDummyGeneratedList(size: 100)..remove(50));
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "remove_list_mutable", config: Config(size: 100));
    final ListRemoveBenchmark removeBenchmark = ListRemoveBenchmark(emitter: tableScoreEmitter);

    removeBenchmark.report();

    removeBenchmark.benchmarks.forEach((ListBenchmarkBase benchmark) => expect(
        benchmark.toMutable(), ListBenchmarkBase.getDummyGeneratedList(size: 100)..remove(50)));
  });

  
}
