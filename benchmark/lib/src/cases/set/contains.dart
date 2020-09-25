import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/config.dart';
import '../../utils/collection_benchmark_base.dart';
import '../../utils/multi_benchmark_reporter.dart';

class SetContainsBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final String prefixName;
  @override
  final List<Config> configs;
  @override
  final List<SetBenchmarkBase> baseBenchmarks = [
    MutableSetContainsBenchmark(config: null, emitter: null),
    ISetContainsBenchmark(config: null, emitter: null),
    KtSetContainsBenchmark(config: null, emitter: null),
    BuiltSetContainsBenchmark(config: null, emitter: null),
  ];

  SetContainsBenchmark(
      {this.prefixName = 'set_contains', @required this.configs});
}

class MutableSetContainsBenchmark extends SetBenchmarkBase {
  MutableSetContainsBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'Set (Mutable)', config: config, emitter: emitter);

  @override
  MutableSetContainsBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      MutableSetContainsBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  Set<int> _set;
  bool _contains;

  bool get contains => _contains;

  @override
  Set<int> toMutable() => _set;

  @override
  void setup() =>
      _set = SetBenchmarkBase.getDummyGeneratedSet(size: config.size);

  @override
  void run() {
    for (int i = 0; i < _set.length + 1; i++) _contains = _set.contains(i);
  }
}

class ISetContainsBenchmark extends SetBenchmarkBase {
  ISetContainsBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'ISet', config: config, emitter: emitter);

  @override
  ISetContainsBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      ISetContainsBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  ISet<int> _iSet;
  bool _contains;

  bool get contains => _contains;

  @override
  Set<int> toMutable() => _iSet.unlock;

  @override
  void setup() => _iSet =
      ISet<int>(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _iSet.length + 1; i++) _contains = _iSet.contains(i);
  }
}

class KtSetContainsBenchmark extends SetBenchmarkBase {
  KtSetContainsBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'KtSet', config: config, emitter: emitter);

  @override
  KtSetContainsBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      KtSetContainsBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  KtSet<int> _ktSet;
  bool _contains;

  bool get contains => _contains;

  @override
  Set<int> toMutable() => _ktSet.asSet();

  @override
  void setup() => _ktSet =
      KtSet<int>.from(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _ktSet.size + 1; i++) _contains = _ktSet.contains(i);
  }
}

class BuiltSetContainsBenchmark extends SetBenchmarkBase {
  BuiltSetContainsBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'BuiltSet', config: config, emitter: emitter);

  @override
  BuiltSetContainsBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      BuiltSetContainsBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltSet<int> _builtSet;
  bool _contains;

  bool get contains => _contains;

  @override
  Set<int> toMutable() => _builtSet.asSet();

  @override
  void setup() => _builtSet = BuiltSet<int>.of(
      SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _builtSet.length + 1; i++)
      _contains = _builtSet.contains(i);
  }
}
