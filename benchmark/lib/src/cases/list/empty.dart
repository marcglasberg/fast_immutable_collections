import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';

class EmptyBenchmark extends MultiBenchmarkReporter2 {
  @override
  final String prefixName;
  @override
  final List<Config> configs;
  @override
  final List<ListBenchmarkBase2> baseBenchmarks = [
    ListEmptyBenchmark(config: null, emitter: null),
    IListEmptyBenchmark(config: null, emitter: null),
    KtListEmptyBenchmark(config: null, emitter: null),
    BuiltListEmptyBenchmark(config: null, emitter: null),
  ];

  EmptyBenchmark({this.prefixName = 'list_empty', @required this.configs});
}

class ListEmptyBenchmark extends ListBenchmarkBase2 {
  ListEmptyBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'List (Mutable)', config: config, emitter: emitter);

  @override
  ListEmptyBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      ListEmptyBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  List<int> _list;

  @override
  List<int> toList() => _list;

  @override
  void run() => _list = <int>[];
}

class IListEmptyBenchmark extends ListBenchmarkBase2 {
  IListEmptyBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'IList', config: config, emitter: emitter);

  @override
  IListEmptyBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      IListEmptyBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  IList<int> _iList;

  @override
  List<int> toList() => _iList.unlock;

  @override
  void run() => _iList = IList<int>();
}

class KtListEmptyBenchmark extends ListBenchmarkBase2 {
  KtListEmptyBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'KtList', config: config, emitter: emitter);

  @override
  KtListEmptyBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      KtListEmptyBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  KtList<int> _ktList;

  @override
  List<int> toList() => _ktList.asList();

  @override
  void run() => _ktList = KtList<int>.empty();
}

class BuiltListEmptyBenchmark extends ListBenchmarkBase2 {
  BuiltListEmptyBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'BuiltList', config: config, emitter: emitter);

  @override
  BuiltListEmptyBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      BuiltListEmptyBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltList<int> _builtList;

  @override
  List<int> toList() => _builtList.asList();

  @override
  void run() => _builtList = BuiltList<int>();
}
