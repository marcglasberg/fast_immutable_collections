// ignore_for_file: overridden_fields
import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:kt_dart/collection.dart";

class ListAddAllBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListAddAllBenchmark({required super.emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListAddAllBenchmark(emitter: emitter),
          IListAddAllBenchmark(emitter: emitter),
          KtListAddAllBenchmark(emitter: emitter),
          BuiltListAddAllBenchmark(emitter: emitter),
        ];
}

class MutableListAddAllBenchmark extends ListBenchmarkBase {
  MutableListAddAllBenchmark({required super.emitter}) : super(name: "List (Mutable)");

  late List<int> list;

  // Saves many copies of the initial list (created during setup).
  late List<List<int>> initialLists;

  late int count;

  @override
  List<int> toMutable() => list;

  /// Since List is mutable, we have to create many copied of the original list during setup.
  /// Note the setup does not count for the measurements.
  @override
  void setup() {
    count = 0;
    initialLists = [];
    for (int i = 0; i <= max(1, 1000000 ~/ config.size); i++)
      initialLists.add(ListBenchmarkBase.getDummyGeneratedList(size: config.size));
  }

  @override
  void run() {
    list = getNextList();
    list.addAll(ListBenchmarkBase.getDummyGeneratedList(size: config.size ~/ 10));
  }

  List<int> getNextList() {
    if (count >= initialLists.length - 1)
      count = 0;
    else
      count++;
    return initialLists[count];
  }
}

class IListAddAllBenchmark extends ListBenchmarkBase {
  IListAddAllBenchmark({required super.emitter}) : super(name: "IList");

  late IList<int> iList;
  late IList<int> result;

  @override
  List<int> toMutable() => result.unlock;

  @override
  void setup() => iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() =>
      result = iList.addAll(ListBenchmarkBase.getDummyGeneratedList(size: config.size ~/ 10));
}

class KtListAddAllBenchmark extends ListBenchmarkBase {
  KtListAddAllBenchmark({required super.emitter}) : super(name: "KtList");

  late KtList<int> ktList;
  late KtList<int> result;

  @override
  List<int> toMutable() => result.asList();

  @override
  void setup() =>
      ktList = KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  /// If the added list were already of type `KtList`, then it would be much faster.
  @override
  void run() => result = ktList
      .plus(KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size ~/ 10)));
}

class BuiltListAddAllBenchmark extends ListBenchmarkBase {
  BuiltListAddAllBenchmark({required super.emitter}) : super(name: "BuiltList");

  late BuiltList<int> builtList;
  late BuiltList<int> result;

  @override
  List<int> toMutable() => result.asList();

  @override
  void setup() =>
      builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => result = builtList.rebuild((ListBuilder<int> listBuilder) =>
      listBuilder.addAll(ListBenchmarkBase.getDummyGeneratedList(size: config.size ~/ 10)));
}
