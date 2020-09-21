// import 'package:benchmark_harness/benchmark_harness.dart';
// import 'package:built_collection/built_collection.dart';
// import 'package:kt_dart/kt.dart';
// import 'package:meta/meta.dart';
// import 'package:test/test.dart';

// import 'package:fast_immutable_collections/fast_immutable_collections.dart';

// import '../../utils/benchmark_reporter.dart';
// import '../../utils/list_benchmark_base.dart';
// import '../../utils/table_score_emitter.dart';

// // /////////////////////////////////////////////////////////////////////////////////////////////////

// class AddBenchmark extends BenchmarkReporter {
//   @override
//   void report() {
//     const List<List<int>> benchmarksConfigurations = [
//       [5000, 100],
//       [5000, 1000],
//       [5000, 10000],
//     ];

//     benchmarksConfigurations.forEach((List<int> configurations) {
//       final int runs = configurations[0], size = configurations[1];

//       final TableScoreEmitter tableScoreEmitter =
//           TableScoreEmitter(reportName: 'list_add_runs_${runs}_size_${size}');

//       final List<int> listResult = _ListAddBenchmark(
//                   runs: runs, size: size, emitter: tableScoreEmitter)
//               .report(),
//           iListResult = _IListAddBenchmark(
//                   runs: runs, size: size, emitter: tableScoreEmitter)
//               .report(),
//           ktListResult = _KtListAddBenchmark(
//                   runs: runs, size: size, emitter: tableScoreEmitter)
//               .report(),
//           builtListWithRebuildResult = _BuiltListAddWithRebuildBenchmark(
//                   runs: runs, size: size, emitter: tableScoreEmitter)
//               .report(),
//           builtListWithListBuilderResult =
//               _BuiltListAddWithListBuilderBenchmark(
//                       runs: runs, size: size, emitter: tableScoreEmitter)
//                   .report();

//       group('Add | Testing if all lists conform to the basic, mutable one |',
//           () {
//         test('IList', () => expect(listResult, iListResult));
//         test('KtList', () => expect(listResult, ktListResult));
//         test('BuiltList with Rebuild',
//             () => expect(listResult, builtListWithRebuildResult));
//         test('BuiltList with ListBuilder',
//             () => expect(listResult, builtListWithListBuilderResult));
//       });

//       tableScoreEmitters.add(tableScoreEmitter);
//     });
//   }
// }

// // /////////////////////////////////////////////////////////////////////////////////////////////////

// const int _innerRuns = 100;

// class _ListAddBenchmark extends ListBenchmarkBase {
//   _ListAddBenchmark({
//     @required int runs,
//     @required int size,
//     @required ScoreEmitter emitter,
//   }) : super('List (Mutable)', runs: runs, size: size, emitter: emitter);

//   List<int> _list;
//   List<int> _fixedList;

//   @override
//   List<int> toList() => _list;

//   @override
//   void setup() =>
//       _fixedList = ListBenchmarkBase.getDummyGeneratedList(length: size);

//   @override
//   void run() {
//     _list = List<int>.of(_fixedList);
//     for (int i = 0; i < _innerRuns; i++) _list.add(i);
//   }
// }

// // /////////////////////////////////////////////////////////////////////////////////////////////////

// class _IListAddBenchmark extends ListBenchmarkBase {
//   _IListAddBenchmark({
//     @required int runs,
//     @required int size,
//     @required ScoreEmitter emitter,
//   }) : super('IList', runs: runs, size: size, emitter: emitter);

//   IList<int> _iList;
//   IList<int> _result;

//   @override
//   List<int> toList() => _result.unlock;

//   @override
//   void setup() {
//     _iList = IList<int>();
//     for (int i = 0; i < size; i++) _iList = _iList.add(i);
//   }

//   @override
//   void run() {
//     _result = _iList;
//     for (int i = 0; i < _innerRuns; i++) _result = _result.add(i);
//   }
// }

// // /////////////////////////////////////////////////////////////////////////////////////////////////

// class _KtListAddBenchmark extends ListBenchmarkBase {
//   _KtListAddBenchmark({
//     @required int runs,
//     @required int size,
//     @required ScoreEmitter emitter,
//   }) : super('KtList', runs: runs, size: size, emitter: emitter);

//   KtList<int> _ktList;
//   KtList<int> _result;

//   @override
//   List<int> toList() => _result.asList();

//   @override
//   void setup() {
//     final List<int> list =
//         ListBenchmarkBase.getDummyGeneratedList(length: size);
//     _ktList = list.toImmutableList();
//   }

//   @override
//   void run() {
//     _result = _ktList;
//     for (int i = 0; i < _innerRuns; i++) _result = _result.plusElement(i);
//   }
// }

// // /////////////////////////////////////////////////////////////////////////////////////////////////

// class _BuiltListAddWithRebuildBenchmark extends ListBenchmarkBase {
//   _BuiltListAddWithRebuildBenchmark({
//     @required int runs,
//     @required int size,
//     @required ScoreEmitter emitter,
//   }) : super('BuiltList with Rebuild',
//             runs: runs, size: size, emitter: emitter);

//   BuiltList<int> _builtList;
//   BuiltList<int> _result;

//   @override
//   List<int> toList() => _result.asList();

//   @override
//   void setup() {
//     final List<int> list =
//         ListBenchmarkBase.getDummyGeneratedList(length: size);
//     _builtList = BuiltList<int>(list);
//   }

//   @override
//   void run() {
//     _result = _builtList;
//     for (int i = 0; i < _innerRuns; i++)
//       _result =
//           _result.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(i));
//   }
// }

// // /////////////////////////////////////////////////////////////////////////////////////////////////

// class _BuiltListAddWithListBuilderBenchmark extends ListBenchmarkBase {
//   _BuiltListAddWithListBuilderBenchmark({
//     @required int runs,
//     @required int size,
//     @required ScoreEmitter emitter,
//   }) : super('BuiltList with List Builder',
//             runs: runs, size: size, emitter: emitter);

//   BuiltList<int> _builtList;
//   BuiltList<int> _result;

//   @override
//   List<int> toList() => _result.asList();

//   @override
//   void setup() {
//     final List<int> list =
//         ListBenchmarkBase.getDummyGeneratedList(length: size);
//     _builtList = BuiltList<int>(list);
//   }

//   @override
//   void run() {
//     final ListBuilder<int> listBuilder = _builtList.toBuilder();
//     for (int i = 0; i < _innerRuns; i++) listBuilder.add(i);
//     _result = listBuilder.build();
//   }
// }

// // /////////////////////////////////////////////////////////////////////////////////////////////////
