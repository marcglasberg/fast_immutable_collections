import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

class SetRemoveBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final List<SetBenchmarkBase> benchmarks;

  SetRemoveBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <SetBenchmarkBase>[
          MutableSetRemoveBenchmark(emitter: emitter),
          ISetRemoveBenchmark(emitter: emitter),
          KtSetRemoveBenchmark(emitter: emitter),
          BuiltSetRemoveBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableSetRemoveBenchmark extends SetBenchmarkBase {
  MutableSetRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "List (Mutable)", emitter: emitter);

  Set<int> _set;

  @override
  Set<int> toMutable() => _set;

  @override
  void setup() => _set = SetBenchmarkBase.getDummyGeneratedSet(size: config.size);

  @override
  void run() => _set.remove(1);
}

class ISetRemoveBenchmark extends SetBenchmarkBase {
  ISetRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "ISet", emitter: emitter);

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
  KtSetRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtSet", emitter: emitter);

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
  BuiltSetRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet", emitter: emitter);

  BuiltSet<int> _fixedSet;
  BuiltSet<int> _builtSet;

  @override
  Set<int> toMutable() => _builtSet.asSet();

  @override
  void setup() => _fixedSet = BuiltSet.of(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() => _builtSet = _fixedSet.rebuild((SetBuilder<int> setBuilder) => setBuilder.remove(1));
}
