import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class ListReadBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  static const int indexToRead = 10;

  @override
  final List<ListBenchmarkBase> benchmarks;

  ListReadBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListReadBenchmark(emitter: emitter),
          IListReadBenchmark(emitter: emitter),
          KtListReadBenchmark(emitter: emitter),
          BuiltListReadBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableListReadBenchmark extends ListBenchmarkBase {
  MutableListReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "List (Mutable)", emitter: emitter);

  List<int> list;
  int newVar;

  @override
  List<int> toMutable() => list;

  @override
  void setup() => list = ListBenchmarkBase.getDummyGeneratedList(size: config.size);

  @override
  void run() => newVar = list[ListReadBenchmark.indexToRead];
}

class IListReadBenchmark extends ListBenchmarkBase {
  IListReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IList", emitter: emitter);

  IList<int> iList;
  int newVar;

  @override
  List<int> toMutable() => iList.unlock;

  @override
  void setup() => iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = iList[ListReadBenchmark.indexToRead];
}

class KtListReadBenchmark extends ListBenchmarkBase {
  KtListReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtList", emitter: emitter);

  KtList<int> ktList;
  int newVar;

  @override
  List<int> toMutable() => ktList.asList();

  @override
  void setup() =>
      ktList = KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = ktList[ListReadBenchmark.indexToRead];
}

class BuiltListReadBenchmark extends ListBenchmarkBase {
  BuiltListReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltList", emitter: emitter);

  BuiltList<int> builtList;
  int newVar;

  @override
  List<int> toMutable() => builtList.asList();

  @override
  void setup() =>
      builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = builtList[ListReadBenchmark.indexToRead];
}
