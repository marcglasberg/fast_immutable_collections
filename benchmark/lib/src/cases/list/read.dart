import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class ListReadBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  static const int indexToRead = 100;

  @override
  final IList<ListBenchmarkBase> benchmarks;

  ListReadBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListReadBenchmark(emitter: emitter),
          IListReadBenchmark(emitter: emitter),
          KtListReadBenchmark(emitter: emitter),
          BuiltListReadBenchmark(emitter: emitter),
        ].lock,
        super(emitter: emitter);
}

class MutableListReadBenchmark extends ListBenchmarkBase {
  MutableListReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "List (Mutable)", emitter: emitter);

  List<int> _list;
  int newVar;

  @override
  List<int> toMutable() => _list;

  @override
  void setup() => _list = ListBenchmarkBase.getDummyGeneratedList(size: config.size);

  @override
  void run() => newVar = _list[ListReadBenchmark.indexToRead];
}

class IListReadBenchmark extends ListBenchmarkBase {
  IListReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IList", emitter: emitter);

  IList<int> _iList;
  int newVar;

  @override
  List<int> toMutable() => _iList.unlock;

  @override
  void setup() => _iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = _iList[ListReadBenchmark.indexToRead];
}

class KtListReadBenchmark extends ListBenchmarkBase {
  KtListReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtList", emitter: emitter);

  KtList<int> _ktList;
  int newVar;

  @override
  List<int> toMutable() => _ktList.asList();

  @override
  void setup() =>
      _ktList = KtList<int>.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = _ktList[ListReadBenchmark.indexToRead];
}

class BuiltListReadBenchmark extends ListBenchmarkBase {
  BuiltListReadBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltList", emitter: emitter);

  BuiltList<int> _builtList;
  int newVar;

  @override
  List<int> toMutable() => _builtList.asList();

  @override
  void setup() =>
      _builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() => newVar = _builtList[ListReadBenchmark.indexToRead];
}
