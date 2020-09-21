import 'package:fast_immutable_collections_benchmarks/src/cases/list/empty.dart';
import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int runs = 100;
  const List<int> emptyList = [];

  final TableScoreEmitter tableScoreEmitter =
      TableScoreEmitter(reportName: 'list_empty');

  test('`List` (Mutable)', () {
    final ListEmptyBenchmark listResult =
        ListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter);

    listResult.report();

    expect(listResult.toList(), emptyList);
  });

  test('`IList`', () {
    final IListEmptyBenchmark iListEmptyBenchmark =
        IListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter);

    iListEmptyBenchmark.report();

    expect(iListEmptyBenchmark.toList(), emptyList);
  });

  test('`KtList`', () {
    final KtListEmptyBenchmark ktListEmptyBenchmark =
        KtListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter);

    ktListEmptyBenchmark.report();

    expect(ktListEmptyBenchmark.toList(), emptyList);
  });

  test('`BuiltList`', () {
    final BuiltListEmptyBenchmark builtListEmptyBenchmark =
        BuiltListEmptyBenchmark(runs: runs, emitter: tableScoreEmitter);

    builtListEmptyBenchmark.report();

    expect(builtListEmptyBenchmark.toList(), emptyList);
  });
}
