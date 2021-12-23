import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

// /////////////////////////////////////////////////////////////////////////////

class SetContainsBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final List<SetBenchmarkBase> benchmarks;

  SetContainsBenchmark({required TableScoreEmitter emitter})
      : benchmarks = <SetBenchmarkBase>[
          MutableSetContainsBenchmark(emitter: emitter),
          ISetContainsBenchmark(emitter: emitter),
          KtSetContainsBenchmark(emitter: emitter),
          BuiltSetContainsBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

// /////////////////////////////////////////////////////////////////////////////

class MutableSetContainsBenchmark extends SetBenchmarkBase {
  MutableSetContainsBenchmark({required TableScoreEmitter emitter})
      : super(name: "Set (Mutable)", emitter: emitter);

  late Set<int> set;
  late bool contains;

  @override
  Set<int> toMutable() => set;

  @override
  void setup() => set = SetBenchmarkBase.getDummyGeneratedSet(size: config.size);

  @override
  void run() {
    for (int i = 0; i < set.length + 1; i++) contains = set.contains(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////

class ISetContainsBenchmark extends SetBenchmarkBase {
  ISetContainsBenchmark({required TableScoreEmitter emitter})
      : super(name: "ISet", emitter: emitter);

  late ISet<int> iSet;
  late bool contains;

  @override
  Set<int> toMutable() => iSet.unlock;

  @override
  void setup() => iSet = ISet<int>(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    for (int i = 0; i < iSet.length + 1; i++) contains = iSet.contains(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////

class KtSetContainsBenchmark extends SetBenchmarkBase {
  KtSetContainsBenchmark({required TableScoreEmitter emitter})
      : super(name: "KtSet", emitter: emitter);

  late KtSet<int> ktSet;
  late bool contains;

  @override
  Set<int> toMutable() => ktSet.asSet();

  @override
  void setup() => ktSet = KtSet<int>.from(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    for (int i = 0; i < ktSet.size + 1; i++) contains = ktSet.contains(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////

class BuiltSetContainsBenchmark extends SetBenchmarkBase {
  BuiltSetContainsBenchmark({required TableScoreEmitter emitter})
      : super(name: "BuiltSet", emitter: emitter);

  late BuiltSet<int> builtSet;
  late bool contains;

  @override
  Set<int> toMutable() => builtSet.asSet();

  @override
  void setup() =>
      builtSet = BuiltSet<int>.of(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    for (int i = 0; i < builtSet.length + 1; i++) contains = builtSet.contains(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////
