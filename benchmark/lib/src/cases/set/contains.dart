import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class SetContainsBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final List<SetBenchmarkBase> benchmarks;

  SetContainsBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <SetBenchmarkBase>[
          MutableSetContainsBenchmark(emitter: emitter),
          ISetContainsBenchmark(emitter: emitter),
          KtSetContainsBenchmark(emitter: emitter),
          BuiltSetContainsBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableSetContainsBenchmark extends SetBenchmarkBase {
  MutableSetContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Set (Mutable)", emitter: emitter);

  Set<int> _set;
  bool _contains;

  bool get contains => _contains;

  @override
  Set<int> toMutable() => _set;

  @override
  void setup() => _set = SetBenchmarkBase.getDummyGeneratedSet(size: config.size);

  @override
  void run() {
    for (int i = 0; i < _set.length + 1; i++) _contains = _set.contains(i);
  }
}

class ISetContainsBenchmark extends SetBenchmarkBase {
  ISetContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "ISet", emitter: emitter);

  ISet<int> _iSet;
  bool _contains;

  bool get contains => _contains;

  @override
  Set<int> toMutable() => _iSet.unlock;

  @override
  void setup() => _iSet = ISet<int>(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _iSet.length + 1; i++) _contains = _iSet.contains(i);
  }
}

class KtSetContainsBenchmark extends SetBenchmarkBase {
  KtSetContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtSet", emitter: emitter);

  KtSet<int> _ktSet;
  bool _contains;

  bool get contains => _contains;

  @override
  Set<int> toMutable() => _ktSet.asSet();

  @override
  void setup() =>
      _ktSet = KtSet<int>.from(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _ktSet.size + 1; i++) _contains = _ktSet.contains(i);
  }
}

class BuiltSetContainsBenchmark extends SetBenchmarkBase {
  BuiltSetContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet", emitter: emitter);

  BuiltSet<int> _builtSet;
  bool _contains;

  bool get contains => _contains;

  @override
  Set<int> toMutable() => _builtSet.asSet();

  @override
  void setup() =>
      _builtSet = BuiltSet<int>.of(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _builtSet.length + 1; i++) _contains = _builtSet.contains(i);
  }
}
