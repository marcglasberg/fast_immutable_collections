// import 'package:benchmark_harness/benchmark_harness.dart';
// import 'package:built_collection/built_collection.dart';
// import 'package:kt_dart/kt.dart';
// import 'package:meta/meta.dart';
// import 'package:test/test.dart';

// import 'package:fast_immutable_collections/fast_immutable_collections.dart';

// import '../../utils/benchmark_reporter.dart';
// import '../../utils/list_benchmark_base.dart';
// import '../../utils/table_score_emitter.dart';

// class ReadBenchmark extends BenchmarkReporter {
//   @override
//   void report() {
//     const int runs = 10000;

//     final TableScoreEmitter tableScoreEmitter =
//         TableScoreEmitter(reportName: 'list_read');

//     final List<int> listResult =
//             _ListReadBenchmark(runs: runs, emitter: tableScoreEmitter).report(),
//         iListResult =
//             _IListReadBenchmark(runs: runs, emitter: tableScoreEmitter)
//                 .report(),
//         ktListResult =
//             _KtListReadBenchmark(runs: runs, emitter: tableScoreEmitter)
//                 .report(),
//         builtListResult =
//             _BuiltListReadBenchmark(runs: runs, emitter: tableScoreEmitter)
//                 .report();

//     group('Read | Testing if all lists conform to the basic, mutable one |',
//         () {
//       test('IList', () => expect(listResult, iListResult));
//       test('KtList', () => expect(listResult, ktListResult));
//       test('BuiltList', () => expect(listResult, builtListResult));
//     });

//     tableScoreEmitters.add(tableScoreEmitter);
//   }
// }

// const int _indexToRead = 100;

// class _ListReadBenchmark extends ListBenchmarkBase {
//   _ListReadBenchmark({@required int runs, @required ScoreEmitter emitter})
//       : super('List (Mutable)', runs: runs, size: 0, emitter: emitter);

//   List<int> _list;

//   @override
//   List<int> toList() => _list;

//   @override
//   void setup() => _list = ListBenchmarkBase.dummyStaticList;

//   @override
//   void run() => _list[_indexToRead];
// }

// class _IListReadBenchmark extends ListBenchmarkBase {
//   _IListReadBenchmark({@required int runs, @required ScoreEmitter emitter})
//       : super('IList', runs: runs, size: 0, emitter: emitter);

//   IList<int> _iList;

//   @override
//   List<int> toList() => _iList.unlock;

//   @override
//   void setup() => _iList = IList<int>(ListBenchmarkBase.dummyStaticList);

//   @override
//   void run() => _iList[_indexToRead];
// }

// class _KtListReadBenchmark extends ListBenchmarkBase {
//   _KtListReadBenchmark({@required int runs, @required ScoreEmitter emitter})
//       : super('KtList', runs: runs, size: 0, emitter: emitter);

//   KtList<int> _ktList;

//   @override
//   List<int> toList() => _ktList.asList();

//   @override
//   void setup() => _ktList = KtList<int>.from(ListBenchmarkBase.dummyStaticList);

//   @override
//   void run() => _ktList[_indexToRead];
// }

// class _BuiltListReadBenchmark extends ListBenchmarkBase {
//   _BuiltListReadBenchmark({@required int runs, @required ScoreEmitter emitter})
//       : super('BuiltList', runs: runs, size: 0, emitter: emitter);

//   BuiltList<int> _builtList;

//   @override
//   List<int> toList() => _builtList.asList();

//   @override
//   void setup() =>
//       _builtList = BuiltList<int>.of(ListBenchmarkBase.dummyStaticList);

//   @override
//   void run() => _builtList[_indexToRead];
// }
