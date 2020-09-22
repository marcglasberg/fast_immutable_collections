import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int size = 10;
  const Config config = Config(runs: 100, size: size);
  final List<int> expectedList =
      ListBenchmarkBase2.getDummyGeneratedList(size: size);

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_contains');

    test('`List` (Mutable)', () {
      final ListContainsBenchmark listContainsBenchmark =
          ListContainsBenchmark(config: config, emitter: tableScoreEmitter);

      listContainsBenchmark.report();

      expect(listContainsBenchmark.toList(), expectedList);
    });

    test('`IList`', () {
      final IListContainsBenchmark iListContainsBenchmark =
          IListContainsBenchmark(config: config, emitter: tableScoreEmitter);

      iListContainsBenchmark.report();

      expect(iListContainsBenchmark.toList(), expectedList);
    });

    test('`KtList`', () {
      final KtListContainsBenchmark ktListContainsBenchmark =
          KtListContainsBenchmark(config: config, emitter: tableScoreEmitter);

      ktListContainsBenchmark.report();

      expect(ktListContainsBenchmark.toList(), expectedList);
    });

    test('`BuiltList`', () {
      final BuiltListContainsBenchmark builtListContainsBenchmark =
          BuiltListContainsBenchmark(
              config: config, emitter: tableScoreEmitter);

      builtListContainsBenchmark.report();

      expect(builtListContainsBenchmark.toList(), expectedList);
    });
  });

  group('Multiple Benchmarks |', () {
    test('Simple run', () {
      final ContainsBenchmark containsBenchmark =
          ContainsBenchmark(configs: [config]);

      containsBenchmark.report();

      containsBenchmark.benchmarks.forEach((ListBenchmarkBase2 benchmark) =>
          expect(benchmark.toList(), expectedList));
    });
  });
}
