import "package:benchmark_harness/benchmark_harness.dart";
import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/collection_benchmark_base.dart";
import "../../utils/config.dart";
import "../../utils/multi_benchmark_reporter.dart";

class SetEmptyBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final String prefixName;
  @override
  final List<Config> configs;
  @override
  final List<SetBenchmarkBase> baseBenchmarks = [
    MutableSetEmptyBenchmark(config: null, emitter: null),
    ISetEmptyBenchmark(config: null, emitter: null),
    KtSetEmptyBenchmark(config: null, emitter: null),
    BuiltSetEmptyBenchmark(config: null, emitter: null),
  ];

  SetEmptyBenchmark({this.prefixName = "set_empty", @required this.configs});
}

class MutableSetEmptyBenchmark extends SetBenchmarkBase {
  MutableSetEmptyBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: "Set (Mutable)", config: config, emitter: emitter);

  @override
  MutableSetEmptyBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      MutableSetEmptyBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  Set<int> _set;

  @override
  Set<int> toMutable() => _set;

  @override
  void run() => _set = <int>{};
}

class ISetEmptyBenchmark extends SetBenchmarkBase {
  ISetEmptyBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: "ISet", config: config, emitter: emitter);

  @override
  ISetEmptyBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      ISetEmptyBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  ISet<int> _iSet;

  @override
  Set<int> toMutable() => _iSet.unlock;

  @override
  void run() => _iSet = ISet<int>();
}

class KtSetEmptyBenchmark extends SetBenchmarkBase {
  KtSetEmptyBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: "KtSet", config: config, emitter: emitter);

  @override
  KtSetEmptyBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      KtSetEmptyBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  KtSet<int> _ktSet;

  @override
  Set<int> toMutable() => _ktSet.asSet();

  @override
  void run() => _ktSet = KtSet<int>.empty();
}

class BuiltSetEmptyBenchmark extends SetBenchmarkBase {
  BuiltSetEmptyBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: "BuiltSet", config: config, emitter: emitter);

  @override
  BuiltSetEmptyBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      BuiltSetEmptyBenchmark(config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltSet<int> _builtSet;

  @override
  Set<int> toMutable() => _builtSet.asSet();

  @override
  void run() => _builtSet = BuiltSet<int>();
}
