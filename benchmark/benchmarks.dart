import 'package:test/test.dart' show group, tearDownAll, test;

import 'cases/add.dart';
import 'cases/empty.dart';
import 'score_emitter.dart' show ListScoreEmitter;

/// Run the benchmarks with, for example: `dart benchmark/benchmarks.dart`
void main() {
  group('Empty Lists Initialization |', () {
    final ListScoreEmitter listScores = ListScoreEmitter(reportName: 'list_empty');

    test('IList', () => IListEmptyBenchmark(listScores).report());
    test('List', () => ListEmptyBenchmark(listScores).report());
    test('KtList', () => KtListEmptyBenchmark(listScores).report());
    test('BuiltList', () => BuiltListEmptyBenchmark(listScores).report());

    tearDownAll(() => listScores.scoreReport());
  });

  group('Adding items to a list |', () {
    final ListScoreEmitter listScores = ListScoreEmitter(reportName: 'list_add');

    test('Ilist', () => IListAddBenchmark(listScores).report());
    test('List', () => ListAddBenchmark(listScores).report());
    test('KtList', () => KtListAddBenchmark(listScores).report());
    test('BuiltList', () => BuiltListAddBenchmark(listScores).report());

    tearDownAll(() => listScores.scoreReport());
  });
}
