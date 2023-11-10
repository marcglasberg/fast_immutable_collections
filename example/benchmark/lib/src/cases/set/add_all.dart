// ignore_for_file: overridden_fields
import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:kt_dart/collection.dart";

class SetAddAllBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final List<SetBenchmarkBase> benchmarks;

  SetAddAllBenchmark({required super.emitter})
      : benchmarks = <SetBenchmarkBase>[
          MutableSetAddAllBenchmark(emitter: emitter),
          ISetAddAllBenchmark(emitter: emitter),
          KtSetAddAllBenchmark(emitter: emitter),
          BuiltSetAddAllBenchmark(emitter: emitter),
        ];
}

class MutableSetAddAllBenchmark extends SetBenchmarkBase {
  MutableSetAddAllBenchmark({required super.emitter}) : super(name: "Set (Mutable)");

  late Set<int> set;
  late Set<int> toBeAdded;
  late List<Set<int>> initialSet;
  late int count;

  @override
  Set<int> toMutable() => set;

  @override
  void setup() {
    count = 0;
    initialSet = [];
    toBeAdded = SetBenchmarkBase.getDummyGeneratedSet(size: config.size + config.size ~/ 10);
    for (int i = 0; i <= max(1, 10000000 ~/ config.size); i++)
      initialSet.add(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));
  }

  @override
  void run() {
    set = getNextSet();
    set.addAll(toBeAdded);
  }

  Set<int> getNextSet() {
    if (count >= initialSet.length - 1)
      count = 0;
    else
      count++;
    return initialSet[count];
  }
}

class ISetAddAllBenchmark extends SetBenchmarkBase {
  ISetAddAllBenchmark({required super.emitter}) : super(name: "ISet");

  late ISet<int> iSet;
  late ISet<int> toBeAdded;
  late ISet<int> fixedISet;

  @override
  Set<int> toMutable() => iSet.unlock;

  @override
  void setup() {
    toBeAdded = SetBenchmarkBase.getDummyGeneratedSet(size: config.size + config.size ~/ 10).lock;
    fixedISet = ISet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));
  }

  @override
  void run() {
    iSet = fixedISet;
    iSet = iSet.addAll(toBeAdded);
  }
}

class KtSetAddAllBenchmark extends SetBenchmarkBase {
  KtSetAddAllBenchmark({required super.emitter}) : super(name: "KtSet");

  late KtSet<int> ktSet;
  late KtSet<int> toBeAdded;
  late KtSet<int> fixedISet;

  @override
  Set<int> toMutable() => ktSet.asSet();

  @override
  void setup() {
    toBeAdded =
        KtSet.from(SetBenchmarkBase.getDummyGeneratedSet(size: config.size + config.size ~/ 10));
    fixedISet = KtSet.from(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));
  }

  @override
  void run() {
    ktSet = fixedISet;
    ktSet = ktSet.plus(toBeAdded).toSet();
  }
}

class BuiltSetAddAllBenchmark extends SetBenchmarkBase {
  BuiltSetAddAllBenchmark({required super.emitter}) : super(name: "BuiltSet");

  late BuiltSet<int> builtSet;
  late BuiltSet<int> toBeAdded;
  late BuiltSet<int> fixedISet;

  @override
  Set<int> toMutable() => builtSet.asSet();

  @override
  void setup() {
    toBeAdded =
        BuiltSet.of(SetBenchmarkBase.getDummyGeneratedSet(size: config.size + config.size ~/ 10));
    fixedISet = BuiltSet.of(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));
  }

  @override
  void run() {
    builtSet = fixedISet.rebuild((SetBuilder<int> setBuilder) => setBuilder.addAll(toBeAdded));
  }
}
