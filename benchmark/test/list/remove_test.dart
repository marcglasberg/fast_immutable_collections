// import "package:test/test.dart";

// import "package:fast_immutable_collections_benchmarks/"
//     "fast_immutable_collections_benchmarks.dart";

// void main() {
//   const int size = 100;
//   const Config config = Config(runs: 100, size: size);

//   final List<int> expectedList = ListBenchmarkBase.getDummyGeneratedList()..remove(1);

//   group("Separate Benchmarks |", () {
//     final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(prefixName: "list_remove");

//     test("`List` (Mutable)", () {
//       final MutableListRemoveBenchmark listRemoveBenchmark =
//           MutableListRemoveBenchmark(config: config, emitter: tableScoreEmitter);

//       listRemoveBenchmark.report();

//       expect(listRemoveBenchmark.toMutable(), expectedList);
//     });

//     test("`IList`", () {
//       final IListRemoveBenchmark iListRemoveBenchmark =
//           IListRemoveBenchmark(config: config, emitter: tableScoreEmitter);

//       iListRemoveBenchmark.report();

//       expect(iListRemoveBenchmark.toMutable(), expectedList);
//     });

//     test("`KtList`", () {
//       final KtListRemoveBenchmark ktListRemoveBenchmark =
//           KtListRemoveBenchmark(config: config, emitter: tableScoreEmitter);

//       ktListRemoveBenchmark.report();

//       expect(ktListRemoveBenchmark.toMutable(), expectedList);
//     });

//     test("`BuiltList`", () {
//       final BuiltListRemoveBenchmark builtListRemoveBenchmark =
//           BuiltListRemoveBenchmark(config: config, emitter: tableScoreEmitter);

//       builtListRemoveBenchmark.report();

//       expect(builtListRemoveBenchmark.toMutable(), expectedList);
//     });
//   });

//   group("Multiple Benchmarks |", () {
//     test("Simple run", () {
//       final ListRemoveBenchmark removeBenchmark = ListRemoveBenchmark(configs: [config, config]);

//       removeBenchmark.report();

//       removeBenchmark.benchmarks
//           .forEach((ListBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedList));
//     });
//   });
// }
