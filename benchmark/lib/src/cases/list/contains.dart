import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';

class ContainsBenchmark extends MultiBenchmarkReporter2 {
  @override
  final String prefixName;
  @override
  final List<Config> configs;
  @override
  final List<ListBenchmarkBase2> baseBenchmarks = [
    ListContainsBenchmark(config: null, emitter: null),
    IListContainsBenchmark(config: null, emitter: null),
    KtListContainsBenchmark(config: null, emitter: null),
    BuiltListContainsBenchmark(config: null, emitter: null),
  ];

  ContainsBenchmark(
      {this.prefixName = 'list_contains', @required this.configs});
}

class ListContainsBenchmark extends ListBenchmarkBase2 {
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
  List<int> toList() => _list;

  @override
  void setup() =>
      _list = ListBenchmarkBase2.getDummyGeneratedList(size: config.size);

  @override
  void run() {
    for (int i = 0; i < _list.length + 1; i++) _list.contains(i);
  }
}

class IListContainsBenchmark extends ListBenchmarkBase2 {
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
  List<int> toList() => _iList.unlock;

  @override
  void setup() => _iList =
      IList<int>(ListBenchmarkBase2.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _iList.length + 1; i++) _iList.contains(i);
  }
}

class KtListContainsBenchmark extends ListBenchmarkBase2 {
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
  List<int> toList() => _ktList.asList();

  @override
  void setup() => _ktList =
      KtList.from(ListBenchmarkBase2.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _ktList.size + 1; i++) _ktList.contains(i);
  }
}

class BuiltListContainsBenchmark extends ListBenchmarkBase2 {
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
  List<int> toList() => _builtList.asList();

  @override
  void setup() => _builtList = BuiltList<int>.of(
      ListBenchmarkBase2.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _builtList.length + 1; i++) _builtList.contains(i);
  }
}
