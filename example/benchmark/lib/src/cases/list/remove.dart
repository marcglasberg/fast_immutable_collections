// ignore_for_file: overridden_fields
import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:kt_dart/collection.dart";

class ListRemoveBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListRemoveBenchmark({required super.emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListRemoveBenchmark(emitter: emitter),
          IListRemoveBenchmark(emitter: emitter),
          KtListRemoveBenchmark(emitter: emitter),
          BuiltListRemoveBenchmark(emitter: emitter),
        ];
}

class MutableListRemoveBenchmark extends ListBenchmarkBase {
  MutableListRemoveBenchmark({required super.emitter}) : super(name: "List (Mutable)");

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
    list.remove(config.size ~/ 2);
  }
}

class IListRemoveBenchmark extends ListBenchmarkBase {
  IListRemoveBenchmark({required super.emitter}) : super(name: "IList");

  late IList<int> iList;

  @override
  List<int> toMutable() => iList.unlock;

  @override
  void setup() => iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => iList = iList.remove(config.size ~/ 2);
}

class KtListRemoveBenchmark extends ListBenchmarkBase {
  KtListRemoveBenchmark({required super.emitter}) : super(name: "KtList");

  late KtList<int> ktList;

  @override
  List<int> toMutable() => ktList.asList();

  @override
  void setup() =>
      ktList = KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => ktList = ktList.minusElement(config.size ~/ 2);
}

class BuiltListRemoveBenchmark extends ListBenchmarkBase {
  BuiltListRemoveBenchmark({required super.emitter}) : super(name: "BuiltList");

  late BuiltList<int> builtList;

  @override
  List<int> toMutable() => builtList.asList();

  @override
  void setup() =>
      builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => builtList =
      builtList.rebuild((ListBuilder<int> listBuilder) => listBuilder.remove(config.size ~/ 2));
}
