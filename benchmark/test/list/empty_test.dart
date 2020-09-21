import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  test('', () {
    const int runs = 100;

    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_empty');
    final ListEmptyBenchmark listResult =
        ListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter);

    listResult.report();

    expect(listResult.toList(), []);
  });
}
