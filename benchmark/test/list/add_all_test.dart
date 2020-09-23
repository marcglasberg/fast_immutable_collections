import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int size = 10;
  const Config config = Config(runs: 100, size: size);
  final List<int> expectedList =
      AddAllBenchmark.baseList + AddAllBenchmark.listToAdd;

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_add_all');

    test('`List` (Mutable)', () {
      final ListAddAllBenchmark listAddAllBenchmark =
          ListAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      listAddAllBenchmark.report();

      expect(listAddAllBenchmark.toList(), expectedList);
    });

    test('`IList`', () {
      final IListAddAllBenchmark iListAddAllBenchmark =
          IListAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      iListAddAllBenchmark.report();

      expect(iListAddAllBenchmark.toList(), expectedList);
    });

    test('`KtList`', () {
      final KtListAddAllBenchmark ktListAddAllBenchmark =
          KtListAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      ktListAddAllBenchmark.report();

      expect(ktListAddAllBenchmark.toList(), expectedList);
    });

    test('`BuiltList`', () {
      final BuiltListAddAllBenchmark builtListAddAllBenchmark =
          BuiltListAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      builtListAddAllBenchmark.report();

      expect(builtListAddAllBenchmark.toList(), expectedList);
    });
  });

  group('Multiple Benchmarks |', () {
    test('Simple run', () {
      final AddAllBenchmark addAllBenchmark =
          AddAllBenchmark(configs: [config, config]);

      addAllBenchmark.report();

      addAllBenchmark.benchmarks.forEach((ListBenchmarkBase benchmark) =>
          expect(benchmark.toList(), expectedList));
    });
  });
}
