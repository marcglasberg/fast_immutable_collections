import "dart:math";
import "package:built_collection/built_collection.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:kt_dart/kt.dart";
import "package:meta/meta.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

//////////////////////////////////////////////////////////////////////////////////////////////////

class ListInsertBenchmark extends MultiBenchmarkReporter<ListBenchmarkBase> {
  @override
  final List<ListBenchmarkBase> benchmarks;

  ListInsertBenchmark({@required TableScoreEmitter emitter, int seed})
      : benchmarks = <ListBenchmarkBase>[
          MutableListInsertBenchmark(emitter: emitter, seed: seed),
          IListInsertBenchmark(emitter: emitter, seed: seed),
          KtListInsertBenchmark(emitter: emitter, seed: seed),
          BuiltListInsertBenchmark(emitter: emitter, seed: seed),
        ],
        super(emitter: emitter);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class MutableListInsertBenchmark extends ListBenchmarkBase {
  final int seed;

  MutableListInsertBenchmark({@required TableScoreEmitter emitter, this.seed})
      : super(name: "List (Mutable)", emitter: emitter);

  List<int> list;

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
    final int randomInt = Random(seed).nextInt(emitter.config.size);
    list.insert(randomInt, randomInt);
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

class IListInsertBenchmark extends ListBenchmarkBase {
  final int seed;

  IListInsertBenchmark({@required TableScoreEmitter emitter, this.seed})
      : super(name: "IList", emitter: emitter);

  IList<int> iList;
  IList<int> result;

  @override
  List<int> toMutable() => result.unlock;

  @override
  void setup() {
    iList = ListBenchmarkBase.getDummyGeneratedList(size: config.size).lock;
  }

  @override
  void run() {
    final int randomInt = Random(seed).nextInt(emitter.config.size);
    result = iList.insert(randomInt, randomInt);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class KtListInsertBenchmark extends ListBenchmarkBase {
  final int seed;

  KtListInsertBenchmark({@required TableScoreEmitter emitter, this.seed})
      : super(name: "KtList", emitter: emitter);

  KtList<int> ktList;
  KtList<int> result;

  @override
  List<int> toMutable() => result.asList();

  @override
  void setup() {
    ktList = ListBenchmarkBase.getDummyGeneratedList(size: config.size).toImmutableList();
  }

  @override
  void run() {
    final int randomInt = Random(seed).nextInt(emitter.config.size);
    final KtMutableList<int> mutable = ktList.toMutableList();
    mutable.addAt(randomInt, randomInt);
    result = KtList<int>.from(mutable.iter);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltListInsertBenchmark extends ListBenchmarkBase {
  final int seed;

  BuiltListInsertBenchmark({@required TableScoreEmitter emitter, this.seed})
      : super(name: "BuiltList", emitter: emitter);

  BuiltList<int> builtList;
  BuiltList<int> result;

  @override
  List<int> toMutable() => result.asList();

  @override
  void setup() =>
      builtList = BuiltList<int>(ListBenchmarkBase.getDummyGeneratedList(size: config.size));

  @override
  void run() {
    final int randomInt = Random(seed).nextInt(emitter.config.size);
    final ListBuilder<int> listBuilder = builtList.toBuilder();
    listBuilder.insert(randomInt, randomInt);
    result = listBuilder.build();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
