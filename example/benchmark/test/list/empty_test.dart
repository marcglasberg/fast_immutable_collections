import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("List (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "empty_list_mutable", config: Config(size: 0));
    final MutableListEmptyBenchmark listEmptyBenchmark =
        MutableListEmptyBenchmark(emitter: tableScoreEmitter);

    listEmptyBenchmark.report();

    expect(listEmptyBenchmark.toMutable(), <int>[]);
  });

  

  test("IList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "empty_iList", config: Config(size: 0));
    final IListEmptyBenchmark iListEmptyBenchmark = IListEmptyBenchmark(emitter: tableScoreEmitter);

    iListEmptyBenchmark.report();

    expect(iListEmptyBenchmark.toMutable(), <int>[]);
  });

  

  test("KtList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "empty_ktList", config: Config(size: 0));
    final KtListEmptyBenchmark ktListEmptyBenchmark =
        KtListEmptyBenchmark(emitter: tableScoreEmitter);

    ktListEmptyBenchmark.report();

    expect(ktListEmptyBenchmark.toMutable(), <int>[]);
  });

  

  test("BuiltList", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "empty_builtList", config: Config(size: 0));
    final BuiltListEmptyBenchmark builtListEmptyBenchmark =
        BuiltListEmptyBenchmark(emitter: tableScoreEmitter);

    builtListEmptyBenchmark.report();

    expect(builtListEmptyBenchmark.toMutable(), <int>[]);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "empty", config: Config(size: 0));
    final ListEmptyBenchmark emptyBenchmark = ListEmptyBenchmark(emitter: tableScoreEmitter);

    emptyBenchmark.report();

    emptyBenchmark.benchmarks
        .forEach((ListBenchmarkBase benchmark) => expect(benchmark.toMutable(), <int>[]));
  });

  
}
