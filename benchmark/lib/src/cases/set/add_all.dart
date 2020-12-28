import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class SetAddAllBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  static const Set<int> baseSet = {1, 2, 3}, setToAdd = {1, 2, 3, 4, 5, 6};

  @override
  final List<SetBenchmarkBase> benchmarks;

  SetAddAllBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <SetBenchmarkBase>[
          MutableSetAddAllBenchmark(emitter: emitter),
          ISetAddAllBenchmark(emitter: emitter),
          KtSetAddAllBenchmark(emitter: emitter),
          BuiltSetAddAllBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableSetAddAllBenchmark extends SetBenchmarkBase {
  MutableSetAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Set (Mutable)", emitter: emitter);

  Set<int> set;
  Set<int> fixedSet;

  @override
  Set<int> toMutable() => set;

  @override
  void setup() => fixedSet = Set<int>.of(SetAddAllBenchmark.baseSet);

  @override
  void run() {
    set = Set<int>.of(fixedSet);
    set.addAll(SetAddAllBenchmark.setToAdd);
  }
}

class ISetAddAllBenchmark extends SetBenchmarkBase {
  ISetAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "ISet", emitter: emitter);

  ISet<int> iSet;
  ISet<int> fixedISet;

  @override
  Set<int> toMutable() => iSet.unlock;

  @override
  void setup() => fixedISet = ISet(SetAddAllBenchmark.baseSet);

  @override
  void run() => iSet = fixedISet.addAll(SetAddAllBenchmark.setToAdd);
}

class KtSetAddAllBenchmark extends SetBenchmarkBase {
  KtSetAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtSet", emitter: emitter);

  KtSet<int> ktSet;
  KtSet<int> fixedISet;

  @override
  Set<int> toMutable() => ktSet.asSet();

  @override
  void setup() => fixedISet = KtSet.from(SetAddAllBenchmark.baseSet);

  @override
  void run() => ktSet = fixedISet.plus(SetAddAllBenchmark.setToAdd.toImmutableSet()).toSet();
}

class BuiltSetAddAllBenchmark extends SetBenchmarkBase {
  BuiltSetAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet", emitter: emitter);

  BuiltSet<int> builtSet;
  BuiltSet<int> fixedISet;

  @override
  Set<int> toMutable() => builtSet.asSet();

  @override
  void setup() => fixedISet = BuiltSet.of(SetAddAllBenchmark.baseSet);

  @override
  void run() => builtSet = fixedISet
      .rebuild((SetBuilder<int> setBuilder) => setBuilder.addAll(SetAddAllBenchmark.setToAdd));
}
