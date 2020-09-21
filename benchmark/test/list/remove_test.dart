import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int runs = 100;

  final TableScoreEmitter tableScoreEmitter =
      TableScoreEmitter(reportName: 'list_remove');
  final List<int> expectedList = ListBenchmarkBase.getDummyGeneratedList()
    ..remove(1);

  test('`List` (Mutable)', () {
    final ListRemoveBenchmark listRemoveBenchmark =
        ListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter);

    listRemoveBenchmark.report();

    expect(listRemoveBenchmark.toList(), expectedList);
  });

  test('`IList`', () {
    final IListRemoveBenchmark iListRemoveBenchmark =
        IListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter);

    iListRemoveBenchmark.report();

    expect(iListRemoveBenchmark.toList(), expectedList);
  });

  test('`KtList`', () {
    final KtListRemoveBenchmark ktListRemoveBenchmark =
        KtListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter);

    ktListRemoveBenchmark.report();

    expect(ktListRemoveBenchmark.toList(), expectedList);
  });

  test('`BuiltList`', () {
    final BuiltListRemoveBenchmark builtListRemoveBenchmark =
        BuiltListRemoveBenchmark(runs: runs, emitter: tableScoreEmitter);

    builtListRemoveBenchmark.report();

    expect(builtListRemoveBenchmark.toList(), expectedList);
  });
}
