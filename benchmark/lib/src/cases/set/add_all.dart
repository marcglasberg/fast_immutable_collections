import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/config.dart';
import '../../utils/collection_benchmark_base.dart';
import '../../utils/multi_benchmark_reporter.dart';

class SetAddAllBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  static const Set<int> baseSet = {1, 2, 3}, setToAdd = {1, 2, 3, 4, 5, 6};

  @override
  final String prefixName;
  @override
  final List<Config> configs;
  @override
  final List<SetBenchmarkBase> baseBenchmarks = [
    MutableSetAddAllBenchmark(config: null, emitter: null),
    ISetAddAllBenchmark(config: null, emitter: null),
    KtSetAddAllBenchmark(config: null, emitter: null),
    BuiltSetAddAllBenchmark(config: null, emitter: null),
  ];

  SetAddAllBenchmark({this.prefixName = 'set_add_all', @required this.configs});
}

class MutableSetAddAllBenchmark extends SetBenchmarkBase {
  MutableSetAddAllBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'Set (Mutable)', config: config, emitter: emitter);

  @override
  MutableSetAddAllBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      MutableSetAddAllBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  Set<int> _set;
  Set<int> _fixedSet;

  @override
  Set<int> toMutable() => _set;

  @override
  void setup() => _fixedSet = Set<int>.of(SetAddAllBenchmark.baseSet);

  @override
  void run() {
    _set = Set<int>.of(_fixedSet);
    _set.addAll(SetAddAllBenchmark.setToAdd);
  }
}

class ISetAddAllBenchmark extends SetBenchmarkBase {
  ISetAddAllBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'ISet', config: config, emitter: emitter);

  @override
  ISetAddAllBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      ISetAddAllBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  ISet<int> _iSet;
  ISet<int> _fixedISet;

  @override
  Set<int> toMutable() => _iSet.unlock;

  @override
  void setup() => _fixedISet = ISet(SetAddAllBenchmark.baseSet);

  @override
  void run() => _iSet = _fixedISet.addAll(SetAddAllBenchmark.setToAdd);
}

class KtSetAddAllBenchmark extends SetBenchmarkBase {
  KtSetAddAllBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'KtSet', config: config, emitter: emitter);

  @override
  KtSetAddAllBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      KtSetAddAllBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  KtSet<int> _ktSet;
  KtSet<int> _fixedISet;

  @override
  Set<int> toMutable() => _ktSet.asSet();

  @override
  void setup() => _fixedISet = KtSet.from(SetAddAllBenchmark.baseSet);

  @override
  void run() => _ktSet =
      _fixedISet.plus(SetAddAllBenchmark.setToAdd.toImmutableSet()).toSet();
}

class BuiltSetAddAllBenchmark extends SetBenchmarkBase {
  BuiltSetAddAllBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'BuiltSet', config: config, emitter: emitter);

  @override
  BuiltSetAddAllBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      BuiltSetAddAllBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltSet<int> _builtSet;
  BuiltSet<int> _fixedISet;

  @override
  Set<int> toMutable() => _builtSet.asSet();

  @override
  void setup() => _fixedISet = BuiltSet.of(SetAddAllBenchmark.baseSet);

  @override
  void run() => _builtSet = _fixedISet.rebuild((SetBuilder<int> setBuilder) =>
      setBuilder.addAll(SetAddAllBenchmark.setToAdd));
}
