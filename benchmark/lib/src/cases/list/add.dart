import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/config.dart';
import '../../utils/multi_benchmark_reporter.dart';
import '../../utils/list_benchmark_base.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

class AddBenchmark extends MultiBenchmarkReporter {
  static const int innerRuns = 100;

  @override
  final String prefixName;
  @override
  final List<Config> configs;
  @override
  final List<ListBenchmarkBase> baseBenchmarks = [
    ListAddBenchmark(config: null, emitter: null),
    IListAddBenchmark(config: null, emitter: null),
    KtListAddBenchmark(config: null, emitter: null),
    BuiltListAddWithRebuildBenchmark(config: null, emitter: null),
    BuiltListAddWithListBuilderBenchmark(config: null, emitter: null),
  ];

  AddBenchmark({this.prefixName = 'list_add', @required this.configs});
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class ListAddBenchmark extends ListBenchmarkBase {
  ListAddBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'List (Mutable)', config: config, emitter: emitter);

  @override
  ListAddBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      ListAddBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  List<int> _list;
  List<int> _fixedList;

  @override
  List<int> toList() => _list;

  @override
  void setup() =>
      _fixedList = ListBenchmarkBase.getDummyGeneratedList(size: config.size);

  @override
  void run() {
    _list = List<int>.of(_fixedList);
    for (int i = 0; i < AddBenchmark.innerRuns; i++) _list.add(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class IListAddBenchmark extends ListBenchmarkBase {
  IListAddBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'IList', config: config, emitter: emitter);

  @override
  IListAddBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      IListAddBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  IList<int> _iList;
  IList<int> _result;

  @override
  List<int> toList() => _result.unlock;

  @override
  void setup() {
    _iList = IList<int>();
    for (int i = 0; i < config.size; i++) _iList = _iList.add(i);
  }

  @override
  void run() {
    _result = _iList;
    for (int i = 0; i < AddBenchmark.innerRuns; i++) _result = _result.add(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class KtListAddBenchmark extends ListBenchmarkBase {
  KtListAddBenchmark({@required Config config, @required ScoreEmitter emitter})
      : super(name: 'KtList', config: config, emitter: emitter);

  @override
  KtListAddBenchmark reconfigure({Config newConfig, ScoreEmitter newEmitter}) =>
      KtListAddBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  KtList<int> _ktList;
  KtList<int> _result;

  @override
  List<int> toList() => _result.asList();

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(size: config.size);
    _ktList = list.toImmutableList();
  }

  @override
  void run() {
    _result = _ktList;
    for (int i = 0; i < AddBenchmark.innerRuns; i++)
      _result = _result.plusElement(i);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltListAddWithRebuildBenchmark extends ListBenchmarkBase {
  BuiltListAddWithRebuildBenchmark(
      {@required Config config, @required ScoreEmitter emitter})
      : super(name: 'BuiltList with Rebuild', config: config, emitter: emitter);

  @override
  BuiltListAddWithRebuildBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      BuiltListAddWithRebuildBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltList<int> _builtList;
  BuiltList<int> _result;

  @override
  List<int> toList() => _result.asList();

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(size: config.size);
    _builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    _result = _builtList;
    for (int i = 0; i < AddBenchmark.innerRuns; i++)
      _result =
          _result.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(i));
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class BuiltListAddWithListBuilderBenchmark extends ListBenchmarkBase {
  BuiltListAddWithListBuilderBenchmark({
    @required Config config,
    @required ScoreEmitter emitter,
  }) : super(
            name: 'BuiltList with List Builder',
            config: config,
            emitter: emitter);

  @override
  BuiltListAddWithListBuilderBenchmark reconfigure(
          {Config newConfig, ScoreEmitter newEmitter}) =>
      BuiltListAddWithListBuilderBenchmark(
          config: newConfig ?? config, emitter: newEmitter ?? emitter);

  BuiltList<int> _builtList;
  BuiltList<int> _result;

  @override
  List<int> toList() => _result.asList();

  @override
  void setup() {
    final List<int> list =
        ListBenchmarkBase.getDummyGeneratedList(size: config.size);
    _builtList = BuiltList<int>(list);
  }

  @override
  void run() {
    final ListBuilder<int> listBuilder = _builtList.toBuilder();
    for (int i = 0; i < AddBenchmark.innerRuns; i++) listBuilder.add(i);
    _result = listBuilder.build();
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
