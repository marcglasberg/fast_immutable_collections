// import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
// import 'package:built_collection/built_collection.dart' show BuiltList;
// import 'package:kt_dart/collection.dart' show KtList;
// import 'package:meta/meta.dart' show immutable, required;

// import 'package:fast_immutable_collections/fast_immutable_collections.dart'
//     show IList;

// import '../utils/benchmark_reporter.dart' show BenchmarkReporter;
// import '../utils/list_benchmark_base.dart' show ListBenchmarkBase;
// import '../utils/table_score_emitter.dart' show TableScoreEmitter;

// class EmptyBenchmark extends BenchmarkReporter {
//   @override
//   void report() {
//     const int runs = 100000;

//     final TableScoreEmitter tableScoreEmitter =
//         TableScoreEmitter(reportName: 'list_empty');

//     _ListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter).report();
//     _IListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter).report();
//     _KtListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter).report();
//     _BuiltListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter).report();

//     tableScoreEmitters.add(tableScoreEmitter);
//   }
// }

// @immutable
// class _ListEmptyBenchmark extends ListBenchmarkBase {
//   const _ListEmptyBenchmark({
//     @required int runs,
//     @required ScoreEmitter emitter,
//   }) : super('List (Mutable)', runs: runs, size: 0, emitter: emitter);

//   @override
//   void run() => <int>[];
// }

// @immutable
// class _IListEmptyBenchmark extends ListBenchmarkBase {
//   const _IListEmptyBenchmark({
//     @required int runs,
//     @required ScoreEmitter emitter,
//   }) : super('IList', runs: runs, size: 0, emitter: emitter);

//   @override
//   void run() => IList<int>();
// }

// @immutable
// class _KtListEmptyBenchmark extends ListBenchmarkBase {
//   const _KtListEmptyBenchmark({
//     @required int runs,
//     @required ScoreEmitter emitter,
//   }) : super('KtList', runs: runs, size: 0, emitter: emitter);

//   @override
//   void run() => KtList<int>.empty();
// }

// @immutable
// class _BuiltListEmptyBenchmark extends ListBenchmarkBase {
//   const _BuiltListEmptyBenchmark({
//     @required int runs,
//     @required ScoreEmitter emitter,
//   }) : super('BuiltList', runs: runs, size: 0, emitter: emitter);

//   @override
//   void run() => BuiltList<int>();
// }
