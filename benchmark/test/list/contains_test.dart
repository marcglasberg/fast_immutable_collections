import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int runs = 100, size = 100;

  final TableScoreEmitter tableScoreEmitter =
      TableScoreEmitter(reportName: 'list_contains');
  final List<int> expectedList =
      ListBenchmarkBase.getDummyGeneratedList(length: 100);

  test('`List` (Mutable)', () {
    final ListContainsBenchmark listContainsBenchmark = ListContainsBenchmark(
        runs: runs, size: size, emitter: tableScoreEmitter);

    listContainsBenchmark.report();

    expect(listContainsBenchmark.toList(), expectedList);
  });

  test('`IList`', () {
    
  });
}
