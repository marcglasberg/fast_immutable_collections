import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("List (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "contains_list_mutable", config: Config(size: 10));
    final MutableListContainsBenchmark listContainsBenchmark =
        MutableListContainsBenchmark(emitter: tableScoreEmitter);

    listContainsBenchmark.report();

    final List<int> expectedList = ListBenchmarkBase.getDummyGeneratedList(size: 10);
    expect(listContainsBenchmark.contains, isFalse);
    expect(listContainsBenchmark.toMutable(), expectedList);
  });

  

  test("IList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "contains_iList", config: Config(size: 10));
    final IListContainsBenchmark iListContainsBenchmark =
        IListContainsBenchmark(emitter: tableScoreEmitter);

    iListContainsBenchmark.report();

    final List<int> expectedList = ListBenchmarkBase.getDummyGeneratedList(size: 10);
    expect(iListContainsBenchmark.contains, isFalse);
    expect(iListContainsBenchmark.toMutable(), expectedList);
  });

  

  test("KtList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "contains_ktList", config: Config(size: 10));
    final KtListContainsBenchmark ktListContainsBenchmark =
        KtListContainsBenchmark(emitter: tableScoreEmitter);

    ktListContainsBenchmark.report();

    final List<int> expectedList = ListBenchmarkBase.getDummyGeneratedList(size: 10);
    expect(ktListContainsBenchmark.contains, isFalse);
    expect(ktListContainsBenchmark.toMutable(), expectedList);
  });

  

  test("BuiltList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "contains_builtList", config: Config(size: 10));
    final BuiltListContainsBenchmark builtListContainsBenchmark =
        BuiltListContainsBenchmark(emitter: tableScoreEmitter);

    builtListContainsBenchmark.report();

    final List<int> expectedList = ListBenchmarkBase.getDummyGeneratedList(size: 10);
    expect(builtListContainsBenchmark.contains, isFalse);
    expect(builtListContainsBenchmark.toMutable(), expectedList);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "contains", config: Config(size: 10));
    final ListContainsBenchmark containsBenchmark =
        ListContainsBenchmark(emitter: tableScoreEmitter);

    containsBenchmark.report();

    final List<int> expectedList = ListBenchmarkBase.getDummyGeneratedList(size: 10);
    containsBenchmark.benchmarks
        .forEach((ListBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedList));
  });

  
}
