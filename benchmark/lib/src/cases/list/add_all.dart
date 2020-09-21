// import 'package:benchmark_harness/benchmark_harness.dart';
// import 'package:built_collection/built_collection.dart';
// import 'package:kt_dart/collection.dart';
// import 'package:meta/meta.dart';
// import 'package:test/test.dart';

// import 'package:fast_immutable_collections/fast_immutable_collections.dart';

// import '../../utils/benchmark_reporter.dart';
// import '../../utils/list_benchmark_base.dart';
// import '../../utils/table_score_emitter.dart';

// class AddAllBenchmark extends BenchmarkReporter {
//   @override
//   void report() {
//     const int runs = 5000;

//     final TableScoreEmitter tableScoreEmitter =
//         TableScoreEmitter(reportName: 'list_add_all');

//     final List<int> listResult =
//             _ListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter)
//                 .report(),
//         iListResult =
//             _IListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter)
//                 .report(),
//         ktListResult =
//             _KtListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter)
//                 .report(),
//         builtListResult =
//             _BuiltListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter)
//                 .report();

//     group('AddAll | Testing if all lists conform to the basic, mutable one |',
//         () {
//       test('IList', () => expect(listResult, iListResult));
//       test('KtList', () => expect(listResult, ktListResult));
//       test('BuiltList', () => expect(listResult, builtListResult));
//     });

//     tableScoreEmitters.add(tableScoreEmitter);
//   }
// }

// const List<int> _baseList = [1, 2, 3];
// const List<int> _listToAdd = [4, 5, 6];

// class _ListAddAllBenchmark extends ListBenchmarkBase {
//   _ListAddAllBenchmark({@required int runs, @required ScoreEmitter emitter})
//       : super('List (Mutable)', runs: runs, size: 0, emitter: emitter);

//   List<int> _list;
//   List<int> _fixedList;

//   @override
//   List<int> toList() => _list;

//   @override
//   void setup() => _fixedList = List<int>.of(_baseList);

//   @override
//   void run() {
//     _list = List<int>.of(_fixedList);
//     _list.addAll(_listToAdd);
//   }
// }

// class _IListAddAllBenchmark extends ListBenchmarkBase {
//   _IListAddAllBenchmark({@required int runs, @required ScoreEmitter emitter})
//       : super('IList', runs: runs, size: 0, emitter: emitter);

//   IList<int> _iList;
//   IList<int> _result;

//   @override
//   List<int> toList() => _result.unlock;

//   @override
//   void setup() => _iList = IList<int>(_baseList);

//   @override
//   void run() => _result = _iList.addAll(_listToAdd);
// }

// class _KtListAddAllBenchmark extends ListBenchmarkBase {
//   _KtListAddAllBenchmark({@required int runs, @required ScoreEmitter emitter})
//       : super('KtList', runs: runs, size: 0, emitter: emitter);

//   KtList<int> _ktList;
//   KtList<int> _result;

//   @override
//   List<int> toList() => _result.asList();

//   @override
//   void setup() => _ktList = KtList<int>.from(_baseList);

//   /// If the added list were already of type `KtList`, then it would be much
//   /// faster.
//   @override
//   void run() => _result = _ktList.plus(KtList<int>.from(_listToAdd));
// }

// class _BuiltListAddAllBenchmark extends ListBenchmarkBase {
//   _BuiltListAddAllBenchmark(
//       {@required int runs, @required ScoreEmitter emitter})
//       : super('BuiltList', runs: runs, size: 0, emitter: emitter);

//   BuiltList<int> _builtList;
//   BuiltList<int> _result;

//   @override
//   List<int> toList() => _result.asList();

//   @override
//   void setup() => _builtList = BuiltList<int>.of(_baseList);

//   @override
//   void run() => _result = _builtList.rebuild(
//       (ListBuilder<int> listBuilder) => listBuilder.addAll(_listToAdd));
// }
