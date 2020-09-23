import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';

class ReadBenchmark extends MultiBenchmarkReporter2 {
  static const int indexToRead = 100;

  @override
  final String prefixName;
  @override
  final List<Config> configs;
  @override
  final List<ListBenchmarkBase2> baseBenchmarks = [
    ListReadBenchmark(config: null, emitter: null),
    IListReadBenchmark(config: null, emitter: null),
    KtListReadBenchmark(config: null, emitter: null),
    BuiltListReadBenchmark(config: null, emitter: null),
  ];

  ReadBenchmark({this.prefixName = 'list_read', @required this.configs});
}

class ListReadBenchmark extends ListBenchmarkBase2 {
  ListReadBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'List (Mutable)', config: config, emitter: emitter);

  @override
  ListReadBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      ListReadBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  List<int> _list;

  @override
  List<int> toList() => _list;

  @override
  void setup() => _list = ListBenchmarkBase.dummyStaticList;

  @override
  void run() => _list[ReadBenchmark.indexToRead];
}

class IListReadBenchmark extends ListBenchmarkBase2 {
  IListReadBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'IList', config: config, emitter: emitter);

  @override
  IListReadBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      IListReadBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  IList<int> _iList;

  @override
  List<int> toList() => _iList.unlock;

  @override
  void setup() => _iList = IList<int>(ListBenchmarkBase.dummyStaticList);

  @override
  void run() => _iList[ReadBenchmark.indexToRead];
}

class KtListReadBenchmark extends ListBenchmarkBase2 {
  KtListReadBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'KtList', config: config, emitter: emitter);

  @override
  IListReadBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      IListReadBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  KtList<int> _ktList;

  @override
  List<int> toList() => _ktList.asList();

  @override
  void setup() => _ktList = KtList<int>.from(ListBenchmarkBase.dummyStaticList);

  @override
  void run() => _ktList[ReadBenchmark.indexToRead];
}

class BuiltListReadBenchmark extends ListBenchmarkBase2 {
  BuiltListReadBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'BuiltList', config: config, emitter: emitter);

  @override
  IListReadBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      IListReadBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltList<int> _builtList;

  @override
  List<int> toList() => _builtList.asList();

  @override
  void setup() =>
      _builtList = BuiltList<int>.of(ListBenchmarkBase.dummyStaticList);

  @override
  void run() => _builtList[ReadBenchmark.indexToRead];
}
