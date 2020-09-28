import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/config.dart';
import '../../utils/collection_benchmark_base.dart';
import '../../utils/multi_benchmark_reporter.dart';

class SetRemoveBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final String prefixName;
  @override
  final List<Config> configs;
  @override
  final List<SetBenchmarkBase> baseBenchmarks = [
    MutableSetRemoveBenchmark(config: null, emitter: null),
    ISetRemoveBenchmark(config: null, emitter: null),
    KtSetRemoveBenchmark(config: null, emitter: null),
    BuiltSetRemoveBenchmark(config: null, emitter: null),
  ];

  SetRemoveBenchmark({this.prefixName = 'set_remove', @required this.configs});
}

class MutableSetRemoveBenchmark extends SetBenchmarkBase {
  MutableSetRemoveBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'List (Mutable)', config: config, emitter: emitter);

  @override
  MutableSetRemoveBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      MutableSetRemoveBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  Set<int> _set;

  @override
  Set<int> toMutable() => _set;

  @override
  void setup() => _set = SetBenchmarkBase.getDummyGeneratedSet(size: config.size);

  @override
  void run() => _set.remove(1);
}

class ISetRemoveBenchmark extends SetBenchmarkBase {
  ISetRemoveBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'ISet', config: config, emitter: emitter);

  @override
  ISetRemoveBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      ISetRemoveBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  ISet<int> _fixedSet;
  ISet<int> _iSet;

  @override
  Set<int> toMutable() => _iSet.unlock;

  @override
  void setup() => _fixedSet = ISet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() => _iSet = _fixedSet.remove(1);
}

class KtSetRemoveBenchmark extends SetBenchmarkBase {
  KtSetRemoveBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'KtSet', config: config, emitter: emitter);

  @override
  KtSetRemoveBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      KtSetRemoveBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  KtSet<int> _fixedSet;
  KtSet<int> _ktSet;

  @override
  Set<int> toMutable() => _ktSet.asSet();

  @override
  void setup() => _fixedSet = KtSet.from(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() => _ktSet = _fixedSet.minusElement(1).toSet();
}

class BuiltSetRemoveBenchmark extends SetBenchmarkBase {
  BuiltSetRemoveBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'BuiltSet', config: config, emitter: emitter);

  @override
  BuiltSetRemoveBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      BuiltSetRemoveBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltSet<int> _fixedSet;
  BuiltSet<int> _builtSet;

  @override
  Set<int> toMutable() => _builtSet.asSet();

  @override
  void setup() => _fixedSet = BuiltSet.of(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() => _builtSet = _fixedSet.rebuild((SetBuilder<int> setBuilder) => setBuilder.remove(1));
}
