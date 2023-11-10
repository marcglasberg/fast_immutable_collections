// ignore_for_file: overridden_fields
import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/src/utils/collection_benchmark_base.dart";
import "package:kt_dart/kt.dart";

class ListContainsBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListContainsBenchmark({required super.emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListContainsBenchmark(emitter: emitter),
          IListContainsBenchmark(emitter: emitter),
          KtListContainsBenchmark(emitter: emitter),
          BuiltListContainsBenchmark(emitter: emitter),
        ];
}

class MutableListContainsBenchmark extends ListBenchmarkBase {
  MutableListContainsBenchmark({required super.emitter}) : super(name: "List (Mutable)");

  late List<int> list;
  late bool contains;

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
    for (int i = 0; i < list.length + 1; i++) contains = list.contains(i);
  }

  List<int> getNextList() {
    if (count >= initialLists.length - 1)
      count = 0;
    else
      count++;
    return initialLists[count];
  }
}

class IListContainsBenchmark extends ListBenchmarkBase {
  IListContainsBenchmark({required super.emitter}) : super(name: "IList");

  late IList<int> _iList;
  late bool contains;

  @override
  List<int> toMutable() => _iList.unlock;

  @override
  void setup() => _iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _iList.length + 1; i++) contains = _iList.contains(i);
  }
}

class KtListContainsBenchmark extends ListBenchmarkBase {
  KtListContainsBenchmark({required super.emitter}) : super(name: "KtList");

  late KtList<int> _ktList;
  late bool contains;

  @override
  List<int> toMutable() => _ktList.asList();

  @override
  void setup() => _ktList = KtList.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _ktList.size + 1; i++) contains = _ktList.contains(i);
  }
}

class BuiltListContainsBenchmark extends ListBenchmarkBase {
  BuiltListContainsBenchmark({required super.emitter}) : super(name: "BuiltList");

  late BuiltList<int> _builtList;
  late bool contains;

  @override
  List<int> toMutable() => _builtList.asList();

  @override
  void setup() =>
      _builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _builtList.length + 1; i++) contains = _builtList.contains(i);
  }
}
