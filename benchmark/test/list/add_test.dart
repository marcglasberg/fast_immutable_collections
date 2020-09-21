import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int runs = 100, size = 100;

  final TableScoreEmitter tableScoreEmitter =
      TableScoreEmitter(reportName: 'list_add');
  final List<int> expectedList =
      ListBenchmarkBase.getDummyGeneratedList(length: 100) +
          List<int>.generate(AddBenchmark.innerRuns, (int index) => index);

  test('`List` (Mutable)', () {
    final ListAddBenchmark listAddBenchmark =
        ListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter);

    listAddBenchmark.report();

    expect(listAddBenchmark.toList(), expectedList);
  });

  test('`IList`', () {
    final IListAddBenchmark iListAddBenchmark =
        IListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter);

    iListAddBenchmark.report();

    expect(iListAddBenchmark.toList(), expectedList);
  });

  test('`KtList`', () {
    final KtListAddBenchmark ktListAddBenchmark =
        KtListAddBenchmark(runs: runs, size: size, emitter: tableScoreEmitter);

    ktListAddBenchmark.report();

    expect(ktListAddBenchmark.toList(), expectedList);
  });

  test('`BuiltList` with `rebuild`', () {
    final BuiltListAddWithRebuildBenchmark builtListAddWithRebuildBenchmark =
        BuiltListAddWithRebuildBenchmark(
            runs: runs, size: size, emitter: tableScoreEmitter);

    builtListAddWithRebuildBenchmark.report();

    expect(builtListAddWithRebuildBenchmark.toList(), expectedList);
  });

  test('`BuiltList` with `ListBuilder`', () {
    final BuiltListAddWithListBuilderBenchmark
        builtListAddWithListBuilderBenchmark =
        BuiltListAddWithListBuilderBenchmark(
            runs: runs, size: size, emitter: tableScoreEmitter);

    builtListAddWithListBuilderBenchmark.report();

    expect(builtListAddWithListBuilderBenchmark.toList(), expectedList);
  });
}
