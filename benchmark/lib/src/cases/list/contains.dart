import "dart:math";
import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

class ListContainsBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListContainsBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListContainsBenchmark(emitter: emitter),
          IListContainsBenchmark(emitter: emitter),
          KtListContainsBenchmark(emitter: emitter),
          BuiltListContainsBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class MutableListContainsBenchmark extends ListBenchmarkBase {
  MutableListContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "List (Mutable)", emitter: emitter);

  List<int> list;
  bool contains;

  // Saves many copies of the initial list (created during setup).
  List<List<int>> initialLists;

  int count;

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

//////////////////////////////////////////////////////////////////////////////////////////////////

class IListContainsBenchmark extends ListBenchmarkBase {
  IListContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IList", emitter: emitter);

  IList<int> _iList;
  bool contains;

  @override
  List<int> toMutable() => _iList.unlock;

  @override
  void setup() => _iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _iList.length + 1; i++) contains = _iList.contains(i);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class KtListContainsBenchmark extends ListBenchmarkBase {
  KtListContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtList", emitter: emitter);

  KtList<int> _ktList;
  bool contains;

  @override
  List<int> toMutable() => _ktList.asList();

  @override
  void setup() => _ktList = KtList.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _ktList.size + 1; i++) contains = _ktList.contains(i);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltListContainsBenchmark extends ListBenchmarkBase {
  BuiltListContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltList", emitter: emitter);

  BuiltList<int> _builtList;
  bool contains;

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

//////////////////////////////////////////////////////////////////////////////////////////////////
