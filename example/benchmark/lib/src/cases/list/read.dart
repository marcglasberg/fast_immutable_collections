// ignore_for_file: overridden_fields
import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:kt_dart/kt.dart";

class ListReadBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListReadBenchmark({required super.emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListReadBenchmark(emitter: emitter),
          IListReadBenchmark(emitter: emitter),
          KtListReadBenchmark(emitter: emitter),
          BuiltListReadBenchmark(emitter: emitter),
        ];
}

class MutableListReadBenchmark extends ListBenchmarkBase {
  MutableListReadBenchmark({required super.emitter}) : super(name: "List (Mutable)");

  late List<int> list;
  late int newVar;

  @override
  List<int> toMutable() => list;

  @override
  void setup() => list = ListBenchmarkBase.getDummyGeneratedList(size: config.size);

  @override
  void run() => newVar = list[config.size ~/ 2];
}

class IListReadBenchmark extends ListBenchmarkBase {
  IListReadBenchmark({required super.emitter}) : super(name: "IList");

  late IList<int> iList;
  late int newVar;

  @override
  List<int> toMutable() => iList.unlock;

  @override
  void setup() => iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = iList[config.size ~/ 2];
}

class KtListReadBenchmark extends ListBenchmarkBase {
  KtListReadBenchmark({required super.emitter}) : super(name: "KtList");

  late KtList<int> ktList;
  late int newVar;

  @override
  List<int> toMutable() => ktList.asList();

  @override
  void setup() =>
      ktList = KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = ktList[config.size ~/ 2];
}

class BuiltListReadBenchmark extends ListBenchmarkBase {
  BuiltListReadBenchmark({required super.emitter}) : super(name: "BuiltList");

  late BuiltList<int> builtList;
  late int newVar;

  @override
  List<int> toMutable() => builtList.asList();

  @override
  void setup() =>
      builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = builtList[config.size ~/ 2];
}
