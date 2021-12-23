import "dart:math";

import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

// /////////////////////////////////////////////////////////////////////////////

class ListRemoveBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListRemoveBenchmark({required TableScoreEmitter emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListRemoveBenchmark(emitter: emitter),
          IListRemoveBenchmark(emitter: emitter),
          KtListRemoveBenchmark(emitter: emitter),
          BuiltListRemoveBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

// /////////////////////////////////////////////////////////////////////////////

class MutableListRemoveBenchmark extends ListBenchmarkBase {
  MutableListRemoveBenchmark({required TableScoreEmitter emitter})
      : super(name: "List (Mutable)", emitter: emitter);

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
    list.remove(config.size ~/ 2);
  }

  List<int> getNextList() {
    if (count >= initialLists.length - 1)
      count = 0;
    else
      count++;
    return initialLists[count];
  }
}

// /////////////////////////////////////////////////////////////////////////////

class IListRemoveBenchmark extends ListBenchmarkBase {
  IListRemoveBenchmark({required TableScoreEmitter emitter})
      : super(name: "IList", emitter: emitter);

  late IList<int> iList;

  @override
  List<int> toMutable() => iList.unlock;

  @override
  void setup() => iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => iList = iList.remove(config.size ~/ 2);
}

// /////////////////////////////////////////////////////////////////////////////

class KtListRemoveBenchmark extends ListBenchmarkBase {
  KtListRemoveBenchmark({required TableScoreEmitter emitter})
      : super(name: "KtList", emitter: emitter);

  late KtList<int> ktList;

  @override
  List<int> toMutable() => ktList.asList();

  @override
  void setup() =>
      ktList = KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => ktList = ktList.minusElement(config.size ~/ 2);
}

// /////////////////////////////////////////////////////////////////////////////

class BuiltListRemoveBenchmark extends ListBenchmarkBase {
  BuiltListRemoveBenchmark({required TableScoreEmitter emitter})
      : super(name: "BuiltList", emitter: emitter);

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

// /////////////////////////////////////////////////////////////////////////////
