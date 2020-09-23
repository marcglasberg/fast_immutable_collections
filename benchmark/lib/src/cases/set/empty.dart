import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';

import '../../utils/collection_benchmark_base.dart';
import '../../utils/config.dart';

class SetEmptyBenchmark extends SetBenchmarkBase {
  SetEmptyBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'Set (Mutable)', config: config, emitter: emitter);

  @override
  SetEmptyBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      SetEmptyBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  Set<int> _set;

  @override
  Set<int> toMutable() => _set;

  @override
  void run() => _set = <int>{};
}

class ISetEmptyBenchmark extends SetBenchmarkBase {
  ISetEmptyBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'Set (Mutable)', config: config, emitter: emitter);

  @override
  ISetEmptyBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      ISetEmptyBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  ISet<int> _set;

  @override
  Set<int> toMutable() => _set.unlock;

  @override
  void run() => _set = ISet<int>();
}
