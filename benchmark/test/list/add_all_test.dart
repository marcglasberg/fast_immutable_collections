import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int runs = 100;

  final TableScoreEmitter tableScoreEmitter =
      TableScoreEmitter(reportName: 'list_add_all');
  final List<int> expectedList =
      AddAllBenchmark.baseList + AddAllBenchmark.listToAdd;

  test('`List` (Mutable)', () {
    final ListAddAllBenchmark listAddAllBenchmark =
        ListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter);

    listAddAllBenchmark.report();

    expect(listAddAllBenchmark.toList(), expectedList);
  });

  test('`IList`', () {
    final IListAddAllBenchmark iListAddAllBenchmark =
        IListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter);

    iListAddAllBenchmark.report();

    expect(iListAddAllBenchmark.toList(), expectedList);
  });

  test('`KtList`', () {
    final KtListAddAllBenchmark ktListAddAllBenchmark =
        KtListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter);

    ktListAddAllBenchmark.report();

    expect(ktListAddAllBenchmark.toList(), expectedList);
  });

  test('`BuiltList`', () {
    final BuiltListAddAllBenchmark builtListAddAllBenchmark =
        BuiltListAddAllBenchmark(runs: runs, emitter: tableScoreEmitter);

    builtListAddAllBenchmark.report();

    expect(builtListAddAllBenchmark.toList(), expectedList);
  });
}
