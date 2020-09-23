import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int size = 100;
  const Config config = Config(runs: 100, size: size);

  final List<int> expectedList = ListBenchmarkBase.getDummyGeneratedList()
    ..remove(1);

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_remove');

    test('`List` (Mutable)', () {
      final ListRemoveBenchmark listRemoveBenchmark =
          ListRemoveBenchmark(config: config, emitter: tableScoreEmitter);

      listRemoveBenchmark.report();

      expect(listRemoveBenchmark.toList(), expectedList);
    });

    test('`IList`', () {
      final IListRemoveBenchmark iListRemoveBenchmark =
          IListRemoveBenchmark(config: config, emitter: tableScoreEmitter);

      iListRemoveBenchmark.report();

      expect(iListRemoveBenchmark.toList(), expectedList);
    });

    test('`KtList`', () {
      final KtListRemoveBenchmark ktListRemoveBenchmark =
          KtListRemoveBenchmark(config: config, emitter: tableScoreEmitter);

      ktListRemoveBenchmark.report();

      expect(ktListRemoveBenchmark.toList(), expectedList);
    });

    test('`BuiltList`', () {
      final BuiltListRemoveBenchmark builtListRemoveBenchmark =
          BuiltListRemoveBenchmark(config: config, emitter: tableScoreEmitter);

      builtListRemoveBenchmark.report();

      expect(builtListRemoveBenchmark.toList(), expectedList);
    });
  });

  group('Multiple Benchmarks |', () {
    test('Simple run', () {
      final RemoveBenchmark removeBenchmark =
          RemoveBenchmark(configs: [config, config]);

      removeBenchmark.report();

      removeBenchmark.benchmarks.forEach((ListBenchmarkBase2 benchmark) =>
          expect(benchmark.toList(), expectedList));
    });
  });
}
