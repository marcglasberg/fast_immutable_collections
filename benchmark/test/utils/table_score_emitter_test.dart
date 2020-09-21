import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  test('`emit` adds values to the `scores`', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'report');

    tableScoreEmitter.emit('test', 1);

    expect(tableScoreEmitter.scores['test'], 1);
  });
}
