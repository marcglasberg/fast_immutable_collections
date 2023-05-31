import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("List (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_all_list_mutable", config: Config(size: 100));
    final MutableListAddAllBenchmark listAddAllBenchmark =
        MutableListAddAllBenchmark(emitter: tableScoreEmitter);

    listAddAllBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    expect(listAddAllBenchmark.toMutable(), expectedList);
  });

  

  test("IList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_all_iList", config: Config(size: 100));
    final IListAddAllBenchmark iListAddAllBenchmark =
        IListAddAllBenchmark(emitter: tableScoreEmitter);

    iListAddAllBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    expect(iListAddAllBenchmark.toMutable(), expectedList);
  });

  

  test("KtList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_all_ktList", config: Config(size: 100));
    final KtListAddAllBenchmark ktListAddAllBenchmark =
        KtListAddAllBenchmark(emitter: tableScoreEmitter);

    ktListAddAllBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    expect(ktListAddAllBenchmark.toMutable(), expectedList);
  });

  

  test("BuiltList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_all_builtList", config: Config(size: 100));
    final BuiltListAddAllBenchmark builtListAddAllBenchmark =
        BuiltListAddAllBenchmark(emitter: tableScoreEmitter);

    builtListAddAllBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    expect(builtListAddAllBenchmark.toMutable(), expectedList);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_all", config: Config(size: 100));
    final ListAddAllBenchmark addAllBenchmark = ListAddAllBenchmark(emitter: tableScoreEmitter);

    addAllBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    addAllBenchmark.benchmarks
        .forEach((ListBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedList));
  });

  
}
