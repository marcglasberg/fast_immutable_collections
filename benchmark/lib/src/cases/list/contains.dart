import "package:built_collection/built_collection.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/multi_benchmark_reporter.dart";
import "../../utils/collection_benchmark_base.dart";

class ListContainsBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final IList<ListBenchmarkBase> benchmarks;

  ListContainsBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListContainsBenchmark(emitter: emitter),
          IListContainsBenchmark(emitter: emitter),
          KtListContainsBenchmark(emitter: emitter),
          BuiltListContainsBenchmark(emitter: emitter),
        ].lock,
        super(emitter: emitter);
}

class MutableListContainsBenchmark extends ListBenchmarkBase {
  MutableListContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "List (Mutable)", emitter: emitter);

  List<int> _list;
  bool _contains;

  bool get contains => _contains;

  @override
  List<int> toMutable() => _list;

  @override
  void setup() => _list = ListBenchmarkBase.getDummyGeneratedList(size: config.size);

  @override
  void run() {
    for (int i = 0; i < _list.length + 1; i++) _contains = _list.contains(i);
  }
}

class IListContainsBenchmark extends ListBenchmarkBase {
  IListContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IList", emitter: emitter);

  IList<int> _iList;
  bool _contains;

  bool get contains => _contains;

  @override
  List<int> toMutable() => _iList.unlock;

  @override
  void setup() => _iList = IList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _iList.length + 1; i++) _contains = _iList.contains(i);
  }
}

class KtListContainsBenchmark extends ListBenchmarkBase {
  KtListContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtList", emitter: emitter);

  KtList<int> _ktList;
  bool _contains;

  bool get contains => _contains;

  @override
  List<int> toMutable() => _ktList.asList();

  @override
  void setup() => _ktList = KtList.from(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _ktList.size + 1; i++) _contains = _ktList.contains(i);
  }
}

class BuiltListContainsBenchmark extends ListBenchmarkBase {
  BuiltListContainsBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltList", emitter: emitter);

  BuiltList<int> _builtList;
  bool _contains;

  bool get contains => _contains;

  @override
  List<int> toMutable() => _builtList.asList();

  @override
  void setup() =>
      _builtList = BuiltList<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    for (int i = 0; i < _builtList.length + 1; i++) _contains = _builtList.contains(i);
  }
}
