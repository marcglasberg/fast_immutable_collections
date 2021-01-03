import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

class SetAddBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
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
  List<Set<int>> initialSet;

  int count;

  @override
  Set<int> toMutable() => set;

  @override
  void setup() {
    count = 0;
    initialSet = [];
    for (int i = 0; i <= max(1, 10000000 ~/ config.size); i++)
      initialSet.add(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));
  }

  @override
  void run() {
    set = getNextSet();
    final int initialLength = set.length;
    for (int i = initialLength; i < initialLength + innerRuns(); i++) set.add(i);
  }

  Set<int> getNextSet() {
    if (count >= initialSet.length - 1)
      count = 0;
    else
      count++;
    return initialSet[count];
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
    final int initialLength = iSet.length;
    for (int i = 0; i < initialLength + innerRuns(); i++) result = result.add(i);
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
    final int initialLength = ktSet.size;
    for (int i = 0; i < initialLength + innerRuns(); i++) result = result.plusElement(i).toSet();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltSetAddWithRebuildBenchmark extends SetBenchmarkBase {
  BuiltSetAddWithRebuildBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet (Rebuild)", emitter: emitter);

  BuiltSet<int> builtSet;
  BuiltSet<int> result;

  @override
  Set<int> toMutable() => result.asSet();

  @override
  void setup() => builtSet = BuiltSet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    result = builtSet;
    final int initialLength = builtSet.length;
    for (int i = 0; i < initialLength + innerRuns(); i++)
      result = result.rebuild((SetBuilder<int> setBuilder) => setBuilder.add(i));
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltSetAddWithSetBuilderBenchmark extends SetBenchmarkBase {
  BuiltSetAddWithSetBuilderBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet (ListBuilder)", emitter: emitter);

  BuiltSet<int> builtSet;
  BuiltSet<int> result;

  @override
  Set<int> toMutable() => result.asSet();

  @override
  void setup() => builtSet = BuiltSet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    final SetBuilder<int> setBuilder = builtSet.toBuilder();
    final int initialLength = builtSet.length;
    for (int i = 0; i < initialLength + innerRuns(); i++) setBuilder.add(i);
    result = setBuilder.build();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
