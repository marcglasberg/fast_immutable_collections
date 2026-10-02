// ignore_for_file: overridden_fields
import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:kt_dart/kt.dart";

class ListInsertBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListInsertBenchmark({required super.emitter, int? seed})
      : benchmarks = <ListBenchmarkBase>[
          MutableListInsertBenchmark(emitter: emitter, seed: seed),
          IListInsertBenchmark(emitter: emitter, seed: seed),
          KtListInsertBenchmark(emitter: emitter, seed: seed),
          BuiltListInsertBenchmark(emitter: emitter, seed: seed),
        ];
}

class MutableListInsertBenchmark extends ListBenchmarkBase {
  final int? seed;

  MutableListInsertBenchmark({required super.emitter, this.seed}) : super(name: "List (Mutable)");

  late List<int> list;

  @override
  late FreshCopies<List<int>> freshCopies;

  @override
  List<int> toMutable() => list;

  @override
  void setup() {
    final List<int> initial = ListBenchmarkBase.getDummyGeneratedList(size: config.size);
    freshCopies = FreshCopies(() => List<int>.of(initial), capacity: 1000000 ~/ config.size);
  }

  @override
  void run() {
    list = freshCopies.next();
    final int randomInt = Random(seed).nextInt(emitter.config.size);
    list.insert(randomInt, randomInt);
  }
}

class IListInsertBenchmark extends ListBenchmarkBase {
  final int? seed;

  IListInsertBenchmark({required super.emitter, this.seed}) : super(name: "IList");

  late IList<int> iList;
  late IList<int> result;

  @override
  List<int> toMutable() => result.unlock;

  @override
  void setup() {
    iList = ListBenchmarkBase.getDummyGeneratedList(size: config.size).lock;
  }

  @override
  void run() {
    final int randomInt = Random(seed).nextInt(emitter.config.size);
    result = iList.insert(randomInt, randomInt);
  }
}

class KtListInsertBenchmark extends ListBenchmarkBase {
  final int? seed;

  KtListInsertBenchmark({required super.emitter, this.seed}) : super(name: "KtList");

  late KtList<int> ktList;
  late KtList<int> result;

  @override
  List<int> toMutable() => result.asList();

  @override
  void setup() {
    ktList = ListBenchmarkBase.getDummyGeneratedList(size: config.size).toImmutableList();
  }

  @override
  void run() {
    final int randomInt = Random(seed).nextInt(emitter.config.size);
    final KtMutableList<int> mutable = ktList.toMutableList();
    mutable.addAt(randomInt, randomInt);
    result = KtList<int>.from(mutable.iter);
  }
}

class BuiltListInsertBenchmark extends ListBenchmarkBase {
  final int? seed;

  BuiltListInsertBenchmark({required super.emitter, this.seed}) : super(name: "BuiltList");

  late BuiltList<int> builtList;
  late BuiltList<int> result;

  @override
  List<int> toMutable() => result.asList();

  @override
  void setup() =>
      builtList = BuiltList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    final int randomInt = Random(seed).nextInt(emitter.config.size);
    final ListBuilder<int> listBuilder = builtList.toBuilder();
    listBuilder.insert(randomInt, randomInt);
    result = listBuilder.build();
  }
}
