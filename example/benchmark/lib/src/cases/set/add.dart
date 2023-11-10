// ignore_for_file: overridden_fields
import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:kt_dart/kt.dart";

class SetAddBenchmark extends MultiBenchmarkReporter<SetBenchmarkBase> {
  @override
  final List<SetBenchmarkBase> benchmarks;

  SetAddBenchmark({required super.emitter})
      : benchmarks = <SetBenchmarkBase>[
          MutableSetAddBenchmark(emitter: emitter),
          ISetAddBenchmark(emitter: emitter),
          KtSetAddBenchmark(emitter: emitter),
          BuiltSetAddWithRebuildBenchmark(emitter: emitter),
          BuiltSetAddWithSetBuilderBenchmark(emitter: emitter),
        ];
}

class MutableSetAddBenchmark extends SetBenchmarkBase {
  MutableSetAddBenchmark({required super.emitter}) : super(name: "Set (Mutable)");

  late Set<int> set;

  // Saves many copies of the initial set (created during setup).
  late List<Set<int>> initialSet;

  late int count;

  @override
  Set<int> toMutable() => set;

  @override
  void setup() {
    count = 0;
    initialSet = [];
    for (int i = 0; i <= max(1, 1000000 ~/ config.size); i++)
      initialSet.add(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));
  }

  @override
  void run() {
    set = getNextSet();

    final int initialLength = set.length;
    final int finalLength = initialLength + innerRuns();
    for (int i = initialLength; i < finalLength; i++) set.add(i);
  }

  Set<int> getNextSet() {
    if (count >= initialSet.length - 1)
      count = 0;
    else
      count++;
    return initialSet[count];
  }
}

class ISetAddBenchmark extends SetBenchmarkBase {
  ISetAddBenchmark({required super.emitter}) : super(name: "ISet");

  late ISet<int> iSet;
  late ISet<int> result;

  @override
  Set<int> toMutable() => result.unlock;

  @override
  void setup() => iSet = ISet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    result = iSet;

    final int initialLength = iSet.length;
    final int finalLength = initialLength + innerRuns();

    for (int i = 0; i < finalLength; i++) result = result.add(i);
  }
}

class KtSetAddBenchmark extends SetBenchmarkBase {
  KtSetAddBenchmark({required super.emitter}) : super(name: "KtSet");

  late KtSet<int> ktSet;
  late KtSet<int> result;

  @override
  Set<int> toMutable() => result.asSet();

  @override
  void setup() => ktSet = SetBenchmarkBase.getDummyGeneratedSet(size: config.size).toImmutableSet();

  @override
  void run() {
    result = ktSet;

    final int initialLength = ktSet.size;
    final int finalLength = initialLength + innerRuns();

    for (int i = 0; i < finalLength; i++) result = result.plusElement(i).toSet();
  }
}

class BuiltSetAddWithRebuildBenchmark extends SetBenchmarkBase {
  BuiltSetAddWithRebuildBenchmark({required super.emitter}) : super(name: "BuiltSet (Rebuild)");

  late BuiltSet<int> builtSet;
  late BuiltSet<int> result;

  @override
  Set<int> toMutable() => result.asSet();

  @override
  void setup() => builtSet = BuiltSet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    result = builtSet;

    final int initialLength = builtSet.length;
    final int finalLength = initialLength + innerRuns();

    for (int i = 0; i < finalLength; i++)
      result = result.rebuild((SetBuilder<int> setBuilder) => setBuilder.add(i));
  }
}

class BuiltSetAddWithSetBuilderBenchmark extends SetBenchmarkBase {
  BuiltSetAddWithSetBuilderBenchmark({required super.emitter})
      : super(name: "BuiltSet (ListBuilder)");

  late BuiltSet<int> builtSet;
  late BuiltSet<int> result;

  @override
  Set<int> toMutable() => result.asSet();

  @override
  void setup() => builtSet = BuiltSet(SetBenchmarkBase.getDummyGeneratedSet(size: config.size));

  @override
  void run() {
    final SetBuilder<int> setBuilder = builtSet.toBuilder();
    final int initialLength = builtSet.length;
    final int finalLength = initialLength + innerRuns();

    for (int i = 0; i < finalLength; i++) setBuilder.add(i);

    result = setBuilder.build();
  }
}
