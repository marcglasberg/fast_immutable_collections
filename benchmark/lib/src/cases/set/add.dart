import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////////////////////////////

class MutableSetAddBenchmark extends SetBenchmarkBase {
  MutableSetAddBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Set (Mutable)", emitter: emitter);

  Set<int> set;
  Set<int> fixedSet;

  @override
  Set<int> toMutable() => set;

  @override
  void setup() => fixedSet = SetBenchmarkBase.getDummyGeneratedSet(size: config.size);

  @override
  void run() {
    set = Set<int>.of(fixedSet);
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++) set.add(i);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class ISetAddBenchmark extends SetBenchmarkBase {
  ISetAddBenchmark({@required TableScoreEmitter emitter}) : super(name: "ISet", emitter: emitter);

  ISet<int> iSet;
  ISet<int> result;

  @override
  Set<int> toMutable() => result.unlock;

  @override
  void setup() => iSet = ISet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    result = iSet;
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++) result = result.add(i);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class KtSetAddBenchmark extends SetBenchmarkBase {
  KtSetAddBenchmark({@required TableScoreEmitter emitter}) : super(name: "KtSet", emitter: emitter);

  KtSet<int> ktSet;
  KtSet<int> result;

  @override
  Set<int> toMutable() => result.asSet();

  @override
  void setup() => ktSet = SetBenchmarkBase.getDummyGeneratedSet(size: config.size).toImmutableSet();

  @override
  void run() {
    result = ktSet;
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++) result = result.plusElement(i).toSet();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltSetAddWithRebuildBenchmark extends SetBenchmarkBase {
  BuiltSetAddWithRebuildBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet with Rebuild", emitter: emitter);

  BuiltSet<int> builtSet;
  BuiltSet<int> result;

  @override
  Set<int> toMutable() => result.asSet();

  @override
  void setup() => builtSet = BuiltSet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    result = builtSet;
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++)
      result = result.rebuild((SetBuilder<int> setBuilder) => setBuilder.add(i));
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltSetAddWithSetBuilderBenchmark extends SetBenchmarkBase {
  BuiltSetAddWithSetBuilderBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet with ListBuilder", emitter: emitter);

  BuiltSet<int> builtSet;
  BuiltSet<int> result;

  @override
  Set<int> toMutable() => result.asSet();

  @override
  void setup() => builtSet = BuiltSet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    final SetBuilder<int> setBuilder = builtSet.toBuilder();
    for (int i = 0; i < SetAddBenchmark.innerRuns; i++) setBuilder.add(i);
    result = setBuilder.build();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
