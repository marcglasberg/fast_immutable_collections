import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  final TableScoreEmitter tableScoreEmitter =
      TableScoreEmitter(reportName: 'report');

  tableScoreEmitter.emit('Test1', 1);
  tableScoreEmitter.emit('List (Mutable)', 10);

  test('`emit` adds values to the `scores`',
      () => expect(tableScoreEmitter.scores['Test1'], 1));

  test('Normalized column', () {
    expect(tableScoreEmitter.completeTable['normalized']['Test1'], 0.1);
    expect(tableScoreEmitter.completeTable['normalized']['List (Mutable)'], 1);
  });

  test('Normalized column against the mutable list', () {
    tableScoreEmitter.emit('Test2', 100);

    expect(
        tableScoreEmitter.completeTable['normalizedAgainstList']['Test2'], 10);
  });

  group('Other stuff |', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'report');

    tableScoreEmitter.emit('Test1', 1);

    test(
        'Printing',
        () => expect(
            tableScoreEmitter.toString(), 'Table Score Emitter: {Test1: 1.0}'));
  });
}
