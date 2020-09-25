import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/config.dart';
import '../../utils/collection_benchmark_base.dart';
import '../../utils/multi_benchmark_reporter.dart';

class SetAddBenchmark {
  static const int innerRuns = 100;
}

class MutableSetAddBenchmark extends SetBenchmarkBase {
  MutableSetAddBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'Set (Mutable)', config: config, emitter: emitter);

  @override
  MutableSetAddBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      MutableSetAddBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  Set<int> _set;
  Set<int> _fixedSet;

  @override
  Set<int> toMutable() => _set;

  @override
  void setup() =>
      _fixedSet = SetBenchmarkBase.getDummyGeneratedSet(size: config.size);

  @override
  void run() {
    _set = Set<int>.of(_fixedSet);
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++) _set.add(i);
  }
}

class ISetAddBenchmark extends SetBenchmarkBase {
  ISetAddBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'ISet', config: config, emitter: emitter);

  @override
  ISetAddBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      ISetAddBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  ISet<int> _iSet;
  ISet<int> _result;

  @override
  Set<int> toMutable() => _result.unlock;

  @override
  void setup() =>
      _iSet = ISet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    _result = _iSet;
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++)
      _result = _result.add(i);
  }
}

class KtSetAddBenchmark extends SetBenchmarkBase {
  KtSetAddBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'KtSet', config: config, emitter: emitter);

  @override
  KtSetAddBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      KtSetAddBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  KtSet<int> _ktSet;
  KtSet<int> _result;

  @override
  Set<int> toMutable() => _result.asSet();

  Set<int> get ktSet => _ktSet.asSet();

  @override
  void setup() => _ktSet =
      SetBenchmarkBase.getDummyGeneratedSet(size: config.size).toImmutableSet();

  @override
  void run() {
    _result = _ktSet;
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++)
      _result = _result.plusElement(i).toSet();
  }
}

class BuiltSetAddWithRebuildBenchmark extends SetBenchmarkBase {
  BuiltSetAddWithRebuildBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'BuiltSet with Rebuild', config: config, emitter: emitter);

  @override
  BuiltSetAddWithRebuildBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      BuiltSetAddWithRebuildBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltSet<int> _builtSet;
  BuiltSet<int> _result;

  @override
  Set<int> toMutable() => _result.asSet();

  @override
  void setup() => _builtSet =
      BuiltSet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    _result = _builtSet;
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++)
      _result =
          _result.rebuild((SetBuilder<int> setBuilder) => setBuilder.add(i));
  }
}
