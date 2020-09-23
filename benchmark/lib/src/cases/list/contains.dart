import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/config.dart';
import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/collection_benchmark_base.dart';

class ContainsBenchmark extends MultiBenchmarkReporter {
  @override
  final String prefixName;
  @override
  final List<Config> configs;
  @override
  final List<ListBenchmarkBase> baseBenchmarks = [
    ListContainsBenchmark(config: null, emitter: null),
    IListContainsBenchmark(config: null, emitter: null),
    KtListContainsBenchmark(config: null, emitter: null),
    BuiltListContainsBenchmark(config: null, emitter: null),
  ];

  ContainsBenchmark(
      {this.prefixName = 'list_contains', @required this.configs});
}

class ListContainsBenchmark extends ListBenchmarkBase {
  ListContainsBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'List (Mutable)', config: config, emitter: emitter);

  @override
  ListContainsBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      ListContainsBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  List<int> _list;

  @override
  List<int> toMutable() => _list;

  @override
  void setup() =>
      _list = ListBenchmarkBase.getDummyGeneratedList(size: config.size);

  @override
  void run() {
    for (int i = 0; i < _list.length + 1; i++) _list.contains(i);
  }
}

class IListContainsBenchmark extends ListBenchmarkBase {
  IListContainsBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'IList', config: config, emitter: emitter);

  @override
  IListContainsBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      IListContainsBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  IList<int> _iList;

  @override
  List<int> toMutable() => _iList.unlock;

  @override
  void setup() => _iList =
      IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _iList.length + 1; i++) _iList.contains(i);
  }
}

class KtListContainsBenchmark extends ListBenchmarkBase {
  KtListContainsBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'KtList', config: config, emitter: emitter);

  @override
  KtListContainsBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      KtListContainsBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  KtList<int> _ktList;

  @override
  List<int> toMutable() => _ktList.asList();

  @override
  void setup() => _ktList =
      KtList.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _ktList.size + 1; i++) _ktList.contains(i);
  }
}

class BuiltListContainsBenchmark extends ListBenchmarkBase {
  BuiltListContainsBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'BuiltList', config: config, emitter: emitter);

  @override
  BuiltListContainsBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      BuiltListContainsBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltList<int> _builtList;

  @override
  List<int> toMutable() => _builtList.asList();

  @override
  void setup() => _builtList = BuiltList<int>.of(
      ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _builtList.length + 1; i++) _builtList.contains(i);
  }
}
