import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/config.dart';
import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/collection_benchmark_base.dart';

class ListReadBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  static const int indexToRead = 100;

  @override
  final String prefixName;
  @override
  final List<Config> configs;
  @override
  final List<ListBenchmarkBase> baseBenchmarks = [
    MutableListReadBenchmark(config: null, emitter: null),
    IListReadBenchmark(config: null, emitter: null),
    KtListReadBenchmark(config: null, emitter: null),
    BuiltListReadBenchmark(config: null, emitter: null),
  ];

  ListReadBenchmark({this.prefixName = 'list_read', @required this.configs});
}

class MutableListReadBenchmark extends ListBenchmarkBase {
  MutableListReadBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'List (Mutable)', config: config, emitter: emitter);

  @override
  MutableListReadBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      MutableListReadBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  List<int> _list;
  int newVar;

  @override
  List<int> toMutable() => _list;

  @override
  void setup() => _list = ListBenchmarkBase.getDummyGeneratedList(size: config.size);

  @override
  void run() => newVar = _list[ListReadBenchmark.indexToRead];
}

class IListReadBenchmark extends ListBenchmarkBase {
  IListReadBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'IList', config: config, emitter: emitter);

  @override
  IListReadBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      IListReadBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  IList<int> _iList;
  int newVar;

  @override
  List<int> toMutable() => _iList.unlock;

  @override
  void setup() => _iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = _iList[ListReadBenchmark.indexToRead];
}

class KtListReadBenchmark extends ListBenchmarkBase {
  KtListReadBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'KtList', config: config, emitter: emitter);

  @override
  IListReadBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      IListReadBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  KtList<int> _ktList;
  int newVar;

  @override
  List<int> toMutable() => _ktList.asList();

  @override
  void setup() =>
      _ktList = KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = _ktList[ListReadBenchmark.indexToRead];
}

class BuiltListReadBenchmark extends ListBenchmarkBase {
  BuiltListReadBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'BuiltList', config: config, emitter: emitter);

  @override
  IListReadBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      IListReadBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltList<int> _builtList;
  int newVar;

  @override
  List<int> toMutable() => _builtList.asList();

  @override
  void setup() =>
      _builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = _builtList[ListReadBenchmark.indexToRead];
}
