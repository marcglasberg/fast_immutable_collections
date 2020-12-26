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
  ISetAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "ISet", emitter: emitter);

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
  KtSetAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtSet", emitter: emitter);

  KtSet<int> _ktSet;
  KtSet<int> _fixedISet;

  @override
  Set<int> toMutable() => _ktSet.asSet();

  @override
  void setup() => _fixedISet = KtSet.from(SetAddAllBenchmark.baseSet);

  @override
  void run() => _ktSet = _fixedISet.plus(SetAddAllBenchmark.setToAdd.toImmutableSet()).toSet();
}

class BuiltSetAddAllBenchmark extends SetBenchmarkBase {
  BuiltSetAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet", emitter: emitter);

  BuiltSet<int> _builtSet;
  BuiltSet<int> _fixedISet;

  @override
  Set<int> toMutable() => _builtSet.asSet();

  @override
  void setup() => _fixedISet = BuiltSet.of(SetAddAllBenchmark.baseSet);

  @override
  void run() => _builtSet = _fixedISet
      .rebuild((SetBuilder<int> setBuilder) => setBuilder.addAll(SetAddAllBenchmark.setToAdd));
}
