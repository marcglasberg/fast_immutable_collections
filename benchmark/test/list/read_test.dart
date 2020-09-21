import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int runs = 100;

  final TableScoreEmitter tableScoreEmitter =
      TableScoreEmitter(reportName: 'list_read');
  final int numberToRead =
      ListBenchmarkBase.dummyStaticList[ReadBenchmark.indexToRead];

  test('`List` (Mutable)', () {
    final ListReadBenchmark listReadBenchmark =
        ListReadBenchmark(runs: runs, emitter: tableScoreEmitter);

    listReadBenchmark.report();

    expect(listReadBenchmark.toList()[ReadBenchmark.indexToRead], numberToRead);
  });

  test('`IList`', () {
    final IListReadBenchmark iListReadBenchmark =
        IListReadBenchmark(runs: runs, emitter: tableScoreEmitter);

    iListReadBenchmark.report();

    expect(
        iListReadBenchmark.toList()[ReadBenchmark.indexToRead], numberToRead);
  });

  test('`KtList`', () {
    final KtListReadBenchmark ktListReadBenchmark =
        KtListReadBenchmark(runs: runs, emitter: tableScoreEmitter);

    ktListReadBenchmark.report();

    expect(
        ktListReadBenchmark.toList()[ReadBenchmark.indexToRead], numberToRead);
  });

  test('`BuiltList`', () {
    final BuiltListReadBenchmark builtListReadBenchmark =
        BuiltListReadBenchmark(runs: runs, emitter: tableScoreEmitter);

    builtListReadBenchmark.report();

    expect(builtListReadBenchmark.toList()[ReadBenchmark.indexToRead],
        numberToRead);
  });
}
