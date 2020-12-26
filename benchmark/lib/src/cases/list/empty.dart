import "package:built_collection/built_collection.dart";
import "package:kt_dart/collection.dart";
import "package:meta/meta.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "../../utils/table_score_emitter.dart";
import "../../utils/collection_benchmark_base.dart";

class ListEmptyBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListEmptyBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListEmptyBenchmark(emitter: emitter),
          IListEmptyBenchmark(emitter: emitter),
          KtListEmptyBenchmark(emitter: emitter),
          BuiltListEmptyBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableListEmptyBenchmark extends ListBenchmarkBase {
  MutableListEmptyBenchmark({@required TableScoreEmitter emitter})
      : super(name: "List (Mutable)", emitter: emitter);

  List<int> _list;

  @override
  List<int> toMutable() => _list;

  @override
  void run() => _list = <int>[];
}

class IListEmptyBenchmark extends ListBenchmarkBase {
  IListEmptyBenchmark({@required TableScoreEmitter emitter})
      : super(name: "IList", emitter: emitter);

  IList<int> _iList;

  @override
  List<int> toMutable() => _iList.unlock;

  @override
  void run() => _iList = IList<int>();
}

class KtListEmptyBenchmark extends ListBenchmarkBase {
  KtListEmptyBenchmark({@required TableScoreEmitter emitter})
      : super(name: "KtList", emitter: emitter);

  KtList<int> _ktList;

  @override
  List<int> toMutable() => _ktList.asList();

  @override
  void run() => _ktList = KtList<int>.empty();
}

class BuiltListEmptyBenchmark extends ListBenchmarkBase {
  BuiltListEmptyBenchmark({@required TableScoreEmitter emitter})
      : super(name: "BuiltList", emitter: emitter);

  BuiltList<int> _builtList;

  @override
  List<int> toMutable() => _builtList.asList();

  @override
  void run() => _builtList = BuiltList<int>();
}
