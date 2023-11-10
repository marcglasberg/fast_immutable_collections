// ignore_for_file: overridden_fields
import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:kt_dart/collection.dart";

class SetEmptyBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final List<SetBenchmarkBase> benchmarks;

  SetEmptyBenchmark({required super.emitter})
      : benchmarks = <SetBenchmarkBase>[
          MutableSetEmptyBenchmark(emitter: emitter),
          ISetEmptyBenchmark(emitter: emitter),
          KtSetEmptyBenchmark(emitter: emitter),
          BuiltSetEmptyBenchmark(emitter: emitter),
        ];
}

class MutableSetEmptyBenchmark extends SetBenchmarkBase {
  MutableSetEmptyBenchmark({required super.emitter}) : super(name: "Set (Mutable)");

  late Set<int> set;

  @override
  Set<int> toMutable() => set;

  @override
  void run() => set = <int>{};
}

class ISetEmptyBenchmark extends SetBenchmarkBase {
  ISetEmptyBenchmark({required super.emitter}) : super(name: "ISet");

  late ISet<int> iSet;

  @override
  Set<int> toMutable() => iSet.unlock;

  @override
  void run() => iSet = ISet<int>();
}

class KtSetEmptyBenchmark extends SetBenchmarkBase {
  KtSetEmptyBenchmark({required super.emitter}) : super(name: "KtSet");

  late KtSet<int> ktSet;

  @override
  Set<int> toMutable() => ktSet.asSet();

  @override
  void run() => ktSet = const KtSet<int>.empty();
}

class BuiltSetEmptyBenchmark extends SetBenchmarkBase {
  BuiltSetEmptyBenchmark({required super.emitter}) : super(name: "BuiltSet");

  late BuiltSet<int> builtSet;

  @override
  Set<int> toMutable() => builtSet.asSet();

  @override
  void run() => builtSet = BuiltSet<int>();
}
