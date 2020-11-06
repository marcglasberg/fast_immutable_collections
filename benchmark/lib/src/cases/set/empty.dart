import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class SetEmptyBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final IList<SetBenchmarkBase> benchmarks;

  SetEmptyBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <SetBenchmarkBase>[
          MutableSetEmptyBenchmark(emitter: emitter),
          ISetEmptyBenchmark(emitter: emitter),
          KtSetEmptyBenchmark(emitter: emitter),
          BuiltSetEmptyBenchmark(emitter: emitter),
        ].lock,
        super(emitter: emitter);
}

class MutableSetEmptyBenchmark extends SetBenchmarkBase {
  MutableSetEmptyBenchmark({@required TableScoreEmitter emitter})
      : super(name: "Set (Mutable)", emitter: emitter);

  Set<int> _set;

  @override
  Set<int> toMutable() => _set;

  @override
  void run() => _set = <int>{};
}

class ISetEmptyBenchmark extends SetBenchmarkBase {
  ISetEmptyBenchmark({@required TableScoreEmitter emitter}) : super(name: "ISet", emitter: emitter);

  ISet<int> _iSet;

  @override
  Set<int> toMutable() => _iSet.unlock;

  @override
  void run() => _iSet = ISet<int>();
}

class KtSetEmptyBenchmark extends SetBenchmarkBase {
  KtSetEmptyBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtSet", emitter: emitter);

  KtSet<int> _ktSet;

  @override
  Set<int> toMutable() => _ktSet.asSet();

  @override
  void run() => _ktSet = KtSet<int>.empty();
}

class BuiltSetEmptyBenchmark extends SetBenchmarkBase {
  BuiltSetEmptyBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltSet", emitter: emitter);

  BuiltSet<int> _builtSet;

  @override
  Set<int> toMutable() => _builtSet.asSet();

  @override
  void run() => _builtSet = BuiltSet<int>();
}
