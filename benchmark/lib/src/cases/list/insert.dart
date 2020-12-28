import "dart:math";
import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

class ListInsertBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListInsertBenchmark({@required TableScoreEmitter emitter})
      : benchmarks = <ListBenchmarkBase>[
          MutableListInsertBenchmark(emitter: emitter),
          IListInsertBenchmark(emitter: emitter),
          KtListInsertBenchmark(emitter: emitter),
          BuiltListInsertBenchmark(emitter: emitter),
        ],
        super(emitter: emitter);
}

class MutableListInsertBenchmark extends ListBenchmarkBase {
  final int randomInt;

  MutableListInsertBenchmark({@required TableScoreEmitter emitter})
      : randomInt = Random(0).nextInt(emitter.config.size),
        super(name: "List (Mutable)", emitter: emitter);

  List<int> list;

  @override
  List<int> toMutable() => list;

  @override
  void run() {
    list = ListBenchmarkBase.getDummyGeneratedList(size: config.size);
    list.insert(randomInt, randomInt);
  }
}

class IListInsertBenchmark extends ListBenchmarkBase {
  final int randomInt;

  IListInsertBenchmark({@required TableScoreEmitter emitter})
      : randomInt = Random(0).nextInt(emitter.config.size),
        super(name: "IList", emitter: emitter);

  IList<int> iList;
  IList<int> result;

  @override
  List<int> toMutable() => result.unlock;

  @override
  void run() {
    result = ListBenchmarkBase.getDummyGeneratedList(size: config.size).lock;
    result = result.insert(randomInt, randomInt);
  }
}

class KtListInsertBenchmark extends ListBenchmarkBase {
  final int randomInt;

  KtListInsertBenchmark({@required TableScoreEmitter emitter})
      : randomInt = Random(0).nextInt(emitter.config.size),
        super(name: "KtList", emitter: emitter);

  KtList<int> ktList;
  KtList<int> result;

  @override
  List<int> toMutable() => result.asList();

  @override
  void run() {
    result = ListBenchmarkBase.getDummyGeneratedList(size: config.size).toImmutableList();
    final KtMutableList<int> mutable = result.toMutableList();
    mutable.addAt(randomInt, randomInt);
    result = KtList<int>.from(mutable.iter);
  }
}

class BuiltListInsertBenchmark extends ListBenchmarkBase {
  final int randomInt;

  BuiltListInsertBenchmark({@required TableScoreEmitter emitter})
      : randomInt = Random(0).nextInt(emitter.config.size),
        super(name: "BuiltList", emitter: emitter);

  BuiltList<int> builtList;
  BuiltList<int> result;

  @override
  List<int> toMutable() => result.asList();

  @override
  void setup() =>
      builtList = BuiltList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    final ListBuilder<int> listBuilder = builtList.toBuilder();
    listBuilder.insert(randomInt, randomInt);
    result = listBuilder.build();
  }
}
