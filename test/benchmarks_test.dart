import 'dart:io' show File;

import 'package:benchmark_harness/benchmark_harness.dart'
    show BenchmarkBase, ScoreEmitter;
import 'package:built_collection/built_collection.dart'
    show BuiltList, ListBuilder;
import 'package:kt_dart/collection.dart' show KtList, KtMutableList;
import 'package:meta/meta.dart' show immutable;
import 'package:test/test.dart' show group, tearDownAll, test;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList;

/// Run the benchmarks with: `pub run test test/benchmarks_test.dart`
void main() {
  group('Empty Lists Initialization |', () {
    final ListScores listScores = ListScores(reportName: 'lsit_empty');

    test('IList', () => IListEmptyBenchmark(listScores).report());
    test('List', () => ListEmptyBenchmark(listScores).report());
    test('KtList', () => KtListEmptyBenchmark(listScores).report());
    test('BuiltList', () => BuiltListEmptyBenchmark(listScores).report());

    tearDownAll(() => listScores.scoreReport());
  });

  group('Adding items to a list |', () {
    final ListScores listScores = ListScores(reportName: 'list_add');

    test('Ilist', () => IListAddBenchmark(listScores).report());
    test('List', () => ListAddBenchmark(listScores).report());
    test('KtList', () => KtListAddBenchmark(listScores).report());
    test('BuiltList', () => BuiltListAddBenchmark(listScores).report());

    tearDownAll(() => listScores.scoreReport());
  });
}

class ListScores implements ScoreEmitter {
  final String _reportName;

  final Map<String, double> scores = {};

  ListScores({String reportName}): _reportName = reportName;

  @override
  void emit(String testName, double value) => scores[testName] = value;

  void scoreReport() {
    final File reportFile = File('test/reports/$_reportName.csv');
    String report = 'Test, Time (${_mu}s)\n';
    scores.forEach((String testName, double score) =>
        report += '$testName, ${score.toString()}\n');
    reportFile.writeAsStringSync(report);
  }

  static const String _mu = '\u{03BC}';
}

@immutable
class ListBenchmarkBase extends BenchmarkBase {
  static const int totalRuns = 10000;

  const ListBenchmarkBase(String name, ScoreEmitter emitter)
      : super(name, emitter: emitter);

  @override
  void exercise() {
    for (int i = 0; i < totalRuns; i++) run();
  }
}

/////////////////////////////////////////////////////////////////////

@immutable
class IListEmptyBenchmark extends ListBenchmarkBase {
  const IListEmptyBenchmark(ScoreEmitter scoreEmitter)
      : super('IList Empty', scoreEmitter);

  @override
  void run() => IList<int>();
}

@immutable
class ListEmptyBenchmark extends ListBenchmarkBase {
  const ListEmptyBenchmark(ScoreEmitter scoreEmitter)
      : super('List Empty (Mutable)', scoreEmitter);

  @override
  void run() => <int>[];
}

@immutable
class KtListEmptyBenchmark extends ListBenchmarkBase {
  const KtListEmptyBenchmark(ScoreEmitter scoreEmitter)
      : super('KtList Empty', scoreEmitter);

  @override
  void run() => KtList<int>.empty();
}

@immutable
class BuiltListEmptyBenchmark extends ListBenchmarkBase {
  const BuiltListEmptyBenchmark(ScoreEmitter scoreEmitter)
      : super('BuiltList Empty', scoreEmitter);

  @override
  void run() => BuiltList<int>();
}

/////////////////////////////////////////////////////////////////////

@immutable
class IListAddBenchmark extends ListBenchmarkBase {
  const IListAddBenchmark(ScoreEmitter scoreEmitter)
      : super('IList Add', scoreEmitter);

  @override
  void run() => IList<int>().add(1);
}

@immutable
class ListAddBenchmark extends ListBenchmarkBase {
  const ListAddBenchmark(ScoreEmitter scoreEmitter)
      : super('List Add', scoreEmitter);

  @override
  void run() => <int>[].add(1);
}

@immutable
class KtListAddBenchmark extends ListBenchmarkBase {
  const KtListAddBenchmark(ScoreEmitter scoreEmitter)
      : super('KtList Add', scoreEmitter);

  @override
  void run() => KtMutableList<int>.empty().add(1);
}

@immutable
class BuiltListAddBenchmark extends ListBenchmarkBase {
  const BuiltListAddBenchmark(ScoreEmitter scoreEmitter)
      : super('BuiltList Add', scoreEmitter);

  @override
  void run() => BuiltList<int>()
      .rebuild((ListBuilder<int> listBuilder) => listBuilder.add(1));
}
