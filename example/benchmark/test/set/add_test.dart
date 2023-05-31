import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:test/test.dart";

void main() {
  

  test("Set (Mutable)", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_set_mutable", config: Config(size: 100));
    final MutableSetAddBenchmark mutableSetAddBenchmark =
        MutableSetAddBenchmark(emitter: tableScoreEmitter);

    mutableSetAddBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    expect(mutableSetAddBenchmark.toMutable(), expectedSet);
  });

  

  test("ISet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_iSet", config: Config(size: 100));
    final ISetAddBenchmark iSetAddBenchmark = ISetAddBenchmark(emitter: tableScoreEmitter);

    iSetAddBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    expect(iSetAddBenchmark.toMutable(), expectedSet);
  });

  

  test("KtSet", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_ktSet", config: Config(size: 100));
    final KtSetAddBenchmark ktSetAddBenchmark = KtSetAddBenchmark(emitter: tableScoreEmitter);

    ktSetAddBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    expect(ktSetAddBenchmark.toMutable(), expectedSet);
  });

  

  test("BuiltSet with .rebuild()", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add_builtSet_with_rebuild", config: Config(size: 100));
    final BuiltSetAddWithRebuildBenchmark builtSetAddWithRebuildBenchmark =
        BuiltSetAddWithRebuildBenchmark(emitter: tableScoreEmitter);

    builtSetAddWithRebuildBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    expect(builtSetAddWithRebuildBenchmark.toMutable(), expectedSet);
  });

  

  test("BuiltSet with ListBuilder", () {
    final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(
        prefixName: "add_builtSet_with_listBuilder", config: Config(size: 100));
    final BuiltSetAddWithSetBuilderBenchmark builtSetAddWithListBuilderBenchmark =
        BuiltSetAddWithSetBuilderBenchmark(emitter: tableScoreEmitter);

    builtSetAddWithListBuilderBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    expect(builtSetAddWithListBuilderBenchmark.toMutable(), expectedSet);
  });

  

  test("Multiple Benchmarks", () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(prefixName: "add", config: Config(size: 100));
    final SetAddBenchmark setAddBenchmark = SetAddBenchmark(emitter: tableScoreEmitter);

    setAddBenchmark.report();

    final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: 110);
    setAddBenchmark.benchmarks
        .forEach((SetBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedSet));
  });

  
}
