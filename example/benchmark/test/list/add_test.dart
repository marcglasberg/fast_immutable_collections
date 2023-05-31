import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("List (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_list_mutable", config: Config(size: 100));
    final MutableListAddBenchmark listAddBenchmark =
        MutableListAddBenchmark(emitter: tableScoreEmitter);

    listAddBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    expect(listAddBenchmark.toMutable(), expectedList);
  });

  

  test("IList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_iList", config: Config(size: 100));
    final IListAddBenchmark iListAddBenchmark = IListAddBenchmark(emitter: tableScoreEmitter);

    iListAddBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    expect(iListAddBenchmark.toMutable(), expectedList);
  });

  

  test("KtList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_ktList", config: Config(size: 100));
    final KtListAddBenchmark ktListAddBenchmark = KtListAddBenchmark(emitter: tableScoreEmitter);

    ktListAddBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    expect(ktListAddBenchmark.toMutable(), expectedList);
  });

  

  test("BuiltList with rebuild", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_builtList_with_rebuild", config: Config(size: 100));
    final BuiltListAddWithRebuildBenchmark builtListAddWithRebuildBenchmark =
        BuiltListAddWithRebuildBenchmark(emitter: tableScoreEmitter);

    builtListAddWithRebuildBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    expect(builtListAddWithRebuildBenchmark.toMutable(), expectedList);
  });

  

  test("BuiltList with ListBuilder", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_builtList_with_listBuilder", config: Config(size: 100));
    final BuiltListAddWithListBuilderBenchmark builtListAddWithListBuilderBenchmark =
        BuiltListAddWithListBuilderBenchmark(emitter: tableScoreEmitter);

    builtListAddWithListBuilderBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    expect(builtListAddWithListBuilderBenchmark.toMutable(), expectedList);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add", config: Config(size: 100));
    final ListAddBenchmark addBenchmark = ListAddBenchmark(emitter: tableScoreEmitter);

    addBenchmark.report();

    final List<int> expectedList = List<int>.generate(100, (int index) => index) +
        List<int>.generate(10, (int index) => index);
    addBenchmark.benchmarks
        .forEach((ListBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedList));
  });

  
}
