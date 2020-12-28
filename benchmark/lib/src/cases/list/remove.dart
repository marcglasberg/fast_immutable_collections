import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class ListRemoveBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListRemoveBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListRemoveBenchmark(emitter: emitter),
          IListRemoveBenchmark(emitter: emitter),
          KtListRemoveBenchmark(emitter: emitter),
          BuiltListRemoveBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableListRemoveBenchmark extends ListBenchmarkBase {
  MutableListRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "List (Mutable)", emitter: emitter);

  List<int> list;

  @override
  List<int> toMutable() => list;

  @override
  void setup() => list = ListBenchmarkBase.getDummyGeneratedList();

  @override
  void run() => list.remove(1);
}

class IListRemoveBenchmark extends ListBenchmarkBase {
  IListRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IList", emitter: emitter);

  IList<int> iList;

  @override
  List<int> toMutable() => iList.unlock;

  @override
  void setup() => iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList());

  @override
  void run() => iList = iList.remove(1);
}

class KtListRemoveBenchmark extends ListBenchmarkBase {
  KtListRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtList", emitter: emitter);

  KtList<int> ktList;

  @override
  List<int> toMutable() => ktList.asList();

  @override
  void setup() => ktList = KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList());

  @override
  void run() => ktList = ktList.minusElement(1);
}

class BuiltListRemoveBenchmark extends ListBenchmarkBase {
  BuiltListRemoveBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltList", emitter: emitter);

  BuiltList<int> builtList;

  @override
  List<int> toMutable() => builtList.asList();

  @override
  void setup() => builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList());

  @override
  void run() =>
      builtList = builtList.rebuild((ListBuilder<int> listBuilder) => listBuilder.remove(1));
}
