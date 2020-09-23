import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int size = 10;
  const Config config = Config(runs: 100, size: size);
  final List<int> expectedList =
      ListBenchmarkBase.getDummyGeneratedList(size: size) +
          List<int>.generate(AddBenchmark.innerRuns, (int index) => index);

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_add');

    test('`List` (Mutable)', () {
      final ListAddBenchmark listAddBenchmark =
          ListAddBenchmark(config: config, emitter: tableScoreEmitter);

      listAddBenchmark.report();

      expect(listAddBenchmark.toList(), expectedList);
    });

    test('`IList`', () {
      final IListAddBenchmark iListAddBenchmark =
          IListAddBenchmark(config: config, emitter: tableScoreEmitter);

      iListAddBenchmark.report();

      expect(iListAddBenchmark.toList(), expectedList);
    });

    test('`KtList`', () {
      final KtListAddBenchmark ktListAddBenchmark =
          KtListAddBenchmark(config: config, emitter: tableScoreEmitter);

      ktListAddBenchmark.report();

      expect(ktListAddBenchmark.toList(), expectedList);
    });

    test('`BuiltList` with `rebuild`', () {
      final BuiltListAddWithRebuildBenchmark builtListAddWithRebuildBenchmark =
          BuiltListAddWithRebuildBenchmark(
              config: config, emitter: tableScoreEmitter);

      builtListAddWithRebuildBenchmark.report();

      expect(builtListAddWithRebuildBenchmark.toList(), expectedList);
    });

    test('`BuiltList` with `ListBuilder`', () {
      final BuiltListAddWithListBuilderBenchmark
          builtListAddWithListBuilderBenchmark =
          BuiltListAddWithListBuilderBenchmark(
              config: config, emitter: tableScoreEmitter);

      builtListAddWithListBuilderBenchmark.report();

      expect(builtListAddWithListBuilderBenchmark.toList(), expectedList);
    });
  });

  group('Multiple Benchmarks |', () {
    test('Simple run', () {
      final AddBenchmark addBenchmark = AddBenchmark(configs: [config, config]);

      addBenchmark.report();

      addBenchmark.benchmarks.forEach((ListBenchmarkBase benchmark) =>
          expect(benchmark.toList(), expectedList));
    });
  });
}
