// ignore_for_file: overridden_fields
import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:kt_dart/collection.dart";

class SetRemoveBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final List<SetBenchmarkBase> benchmarks;

  SetRemoveBenchmark({required super.emitter})
      : benchmarks = <SetBenchmarkBase>[
          MutableSetRemoveBenchmark(emitter: emitter),
          ISetRemoveBenchmark(emitter: emitter),
          KtSetRemoveBenchmark(emitter: emitter),
          BuiltSetRemoveBenchmark(emitter: emitter),
        ];
}

class MutableSetRemoveBenchmark extends SetBenchmarkBase {
  MutableSetRemoveBenchmark({required super.emitter}) : super(name: "Set (Mutable)");

  late Set<int> set;
  late int count;
  late List<Set<int>> initialSets;

  @override
  Set<int> toMutable() => set;

  @override
  void setup() {
    count = 0;
    initialSets = [];
    for (int i = 0; i <= max(1, 1000000 ~/ config.size); i++)
      initialSets.add(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));
  }

  @override
  void run() {
    set = getNextSet();
    set.remove(config.size ~/ 2);
  }

  Set<int> getNextSet() {
    if (count >= initialSets.length - 1)
      count = 0;
    else
      count++;
    return initialSets[count];
  }
}

class ISetRemoveBenchmark extends SetBenchmarkBase {
  ISetRemoveBenchmark({required super.emitter}) : super(name: "ISet");

  late ISet<int> fixedSet;
  late ISet<int> iSet;

  @override
  Set<int> toMutable() => iSet.unlock;

  @override
  void setup() => fixedSet = ISet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    iSet = fixedSet;
    iSet = iSet.remove(config.size ~/ 2);
  }
}

class KtSetRemoveBenchmark extends SetBenchmarkBase {
  KtSetRemoveBenchmark({required super.emitter}) : super(name: "KtSet");

  late KtSet<int> fixedSet;
  late KtSet<int> ktSet;

  @override
  Set<int> toMutable() => ktSet.asSet();

  @override
  void setup() => fixedSet = KtSet.from(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    ktSet = fixedSet;
    ktSet = ktSet.minusElement(config.size ~/ 2).toSet();
  }
}

class BuiltSetRemoveBenchmark extends SetBenchmarkBase {
  BuiltSetRemoveBenchmark({required super.emitter}) : super(name: "BuiltSet") {
    // TODO: implement BuiltSetRemoveBenchmark
    throw UnimplementedError();
  }

  late BuiltSet<int> fixedSet;
  late BuiltSet<int> builtSet;

  @override
  Set<int> toMutable() => builtSet.asSet();

  @override
  void setup() => fixedSet = BuiltSet.of(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    builtSet = fixedSet;
    builtSet =
        fixedSet.rebuild((SetBuilder<int> setBuilder) => setBuilder.remove(config.size ~/ 2));
  }
}
