import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

class ListAddAllBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  static const List<int> baseList = [1, 2, 3], listToAdd = [4, 5, 6];

  @override
  final List<ListBenchmarkBase> benchmarks;

  ListAddAllBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListAddAllBenchmark(emitter: emitter),
          IListAddAllBenchmark(emitter: emitter),
          KtListAddAllBenchmark(emitter: emitter),
          BuiltListAddAllBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableListAddAllBenchmark extends ListBenchmarkBase {
  MutableListAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "List (Mutable)", emitter: emitter);

  List<int> _list;
  List<int> _fixedList;

  @override
  List<int> toMutable() => _list;

  @override
  void setup() => _fixedList = List<int>.of(ListAddAllBenchmark.baseList);

  @override
  void run() {
    _list = List<int>.of(_fixedList);
    _list.addAll(ListAddAllBenchmark.listToAdd);
  }
}

class IListAddAllBenchmark extends ListBenchmarkBase {
  IListAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IList", emitter: emitter);

  IList<int> _iList;
  IList<int> _result;

  @override
  List<int> toMutable() => _result.unlock;

  @override
  void setup() => _iList = IList<int>(ListAddAllBenchmark.baseList);

  @override
  void run() => _result = _iList.addAll(ListAddAllBenchmark.listToAdd);
}

class KtListAddAllBenchmark extends ListBenchmarkBase {
  KtListAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtList", emitter: emitter);

  KtList<int> _ktList;
  KtList<int> _result;

  @override
  List<int> toMutable() => _result.asList();

  @override
  void setup() => _ktList = KtList<int>.from(ListAddAllBenchmark.baseList);

  /// If the added list were already of type `KtList`, then it would be much faster.
  @override
  void run() => _result = _ktList.plus(KtList<int>.from(ListAddAllBenchmark.listToAdd));
}

class BuiltListAddAllBenchmark extends ListBenchmarkBase {
  BuiltListAddAllBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltList", emitter: emitter);

  BuiltList<int> _builtList;
  BuiltList<int> _result;

  @override
  List<int> toMutable() => _result.asList();

  @override
  void setup() => _builtList = BuiltList<int>.of(ListAddAllBenchmark.baseList);

  @override
  void run() => _result = _builtList
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.addAll(ListAddAllBenchmark.listToAdd));
}
