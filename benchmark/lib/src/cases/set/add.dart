import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class SetAddBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  static const int innerRuns = 100;

  @override
  final List<SetBenchmarkBase> benchmarks;

  SetAddBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <SetBenchmarkBase>[
          MutableSetAddBenchmark(emitter: emitter),
          ISetAddBenchmark(emitter: emitter),
          KtSetAddBenchmark(emitter: emitter),
          BuiltSetAddWithRebuildBenchmark(emitter: emitter),
          BuiltSetAddWithSetBuilderBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableSetAddBenchmark extends SetBenchmarkBase {
  MutableSetAddBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Set (Mutable)", emitter: emitter);

  Set<int> _set;
  Set<int> _fixedSet;

  @override
  Set<int> toMutable() => _set;

  @override
  void setup() => _fixedSet = SetBenchmarkBase.getDummyGeneratedSet(size: config.size);

  @override
  void run() {
    _set = Set<int>.of(_fixedSet);
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++) _set.add(i);
  }
}

class ISetAddBenchmark extends SetBenchmarkBase {
  ISetAddBenchmark({@required TableScoreEmitter emitter}) : super(name: "ISet", emitter: emitter);

  ISet<int> _iSet;
  ISet<int> _result;

  @override
  Set<int> toMutable() => _result.unlock;

  @override
  void setup() => _iSet = ISet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    _result = _iSet;
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++) _result = _result.add(i);
  }
}

class KtSetAddBenchmark extends SetBenchmarkBase {
  KtSetAddBenchmark({@required TableScoreEmitter emitter}) : super(name: "KtSet", emitter: emitter);

  KtSet<int> _ktSet;
  KtSet<int> _result;

  @override
  Set<int> toMutable() => _result.asSet();

  Set<int> get ktSet => _ktSet.asSet();

  @override
  void setup() =>
      _ktSet = SetBenchmarkBase.getDummyGeneratedSet(size: config.size).toImmutableSet();

  @override
  void run() {
    _result = _ktSet;
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++) _result = _result.plusElement(i).toSet();
  }
}

class BuiltSetAddWithRebuildBenchmark extends SetBenchmarkBase {
  BuiltSetAddWithRebuildBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet with Rebuild", emitter: emitter);

  BuiltSet<int> _builtSet;
  BuiltSet<int> _result;

  @override
  Set<int> toMutable() => _result.asSet();

  @override
  void setup() => _builtSet = BuiltSet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    _result = _builtSet;
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++)
      _result = _result.rebuild((SetBuilder<int> setBuilder) => setBuilder.add(i));
  }
}

class BuiltSetAddWithSetBuilderBenchmark extends SetBenchmarkBase {
  BuiltSetAddWithSetBuilderBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet with ListBuilder", emitter: emitter);

  BuiltSet<int> _builtSet;
  BuiltSet<int> _result;

  @override
  Set<int> toMutable() => _result.asSet();

  @override
  void setup() => _builtSet = BuiltSet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    final SetBuilder<int> setBuilder = _builtSet.toBuilder();
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++) setBuilder.add(i);
    _result = setBuilder.build();
  }
}
