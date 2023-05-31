import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("List (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "read_list_mutable", config: Config(size: 1000));
    final MutableListReadBenchmark listReadBenchmark =
        MutableListReadBenchmark(emitter: tableScoreEmitter);

    listReadBenchmark.report();

    expect(listReadBenchmark.newVar, ListBenchmarkBase.getDummyGeneratedList(size: 1000)[500]);
  });

  

  test("IList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "read_iList", config: Config(size: 1000));
    final IListReadBenchmark iListReadBenchmark = IListReadBenchmark(emitter: tableScoreEmitter);

    iListReadBenchmark.report();

    expect(iListReadBenchmark.newVar, ListBenchmarkBase.getDummyGeneratedList(size: 1000)[500]);
  });

  

  test("KtList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "read_ktList", config: Config(size: 1000));
    final KtListReadBenchmark ktListReadBenchmark = KtListReadBenchmark(emitter: tableScoreEmitter);

    ktListReadBenchmark.report();

    expect(ktListReadBenchmark.newVar, ListBenchmarkBase.getDummyGeneratedList(size: 1000)[500]);
  });

  

  test("BuiltList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "read_builtList", config: Config(size: 1000));
    final BuiltListReadBenchmark builtListReadBenchmark =
        BuiltListReadBenchmark(emitter: tableScoreEmitter);

    builtListReadBenchmark.report();

    expect(builtListReadBenchmark.newVar, ListBenchmarkBase.getDummyGeneratedList(size: 1000)[500]);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "read", config: Config(size: 1000));
    final ListReadBenchmark readBenchmark = ListReadBenchmark(emitter: tableScoreEmitter);

    readBenchmark.report();

    readBenchmark.benchmarks.forEach((ListBenchmarkBase benchmark) => expect(
        benchmark.toMutable()[500], ListBenchmarkBase.getDummyGeneratedList(size: 1000)[500]));
  });

  
}
