import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const Config config = Config(runs: 100, size: 0);
  const List<int> emptyList = [];

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_empty');

    test('`List` (Mutable)', () {
      final ListEmptyBenchmark listResult =
          ListEmptyBenchmark(config: config, emitter: tableScoreEmitter);

      listResult.report();

      expect(listResult.toList(), emptyList);
    });

    test('`IList`', () {
      final IListEmptyBenchmark iListEmptyBenchmark =
          IListEmptyBenchmark(config: config, emitter: tableScoreEmitter);

      iListEmptyBenchmark.report();

      expect(iListEmptyBenchmark.toList(), emptyList);
    });

    test('`KtList`', () {
      final KtListEmptyBenchmark ktListEmptyBenchmark =
          KtListEmptyBenchmark(config: config, emitter: tableScoreEmitter);

      ktListEmptyBenchmark.report();

      expect(ktListEmptyBenchmark.toList(), emptyList);
    });

    test('`BuiltList`', () {
      final BuiltListEmptyBenchmark builtListEmptyBenchmark =
          BuiltListEmptyBenchmark(config: config, emitter: tableScoreEmitter);

      builtListEmptyBenchmark.report();

      expect(builtListEmptyBenchmark.toList(), emptyList);
    });
  });

  group('Multiple Benchmarks |', () {
    test('Simple run', () {
      final EmptyBenchmark emptyBenchmark =
          EmptyBenchmark(configs: [config, config]);

      emptyBenchmark.report();

      emptyBenchmark.benchmarks.forEach((ListBenchmarkBase benchmark) =>
          expect(benchmark.toList(), emptyList));
    });
  });
}
