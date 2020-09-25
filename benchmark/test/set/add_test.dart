import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int size = 10;
  const Config config = Config(runs: 1, size: size);
  final Set<int> expectedSet = Set<int>.of(
      SetBenchmarkBase.getDummyGeneratedSet(size: size).toList() +
          List<int>.generate(SetAddBenchmark.innerRuns, (int index) => index));

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'set_add');

    test('`Set` (Mutable)', () {
      final MutableSetAddBenchmark mutableSetAddBenchmark =
          MutableSetAddBenchmark(config: config, emitter: tableScoreEmitter);

      mutableSetAddBenchmark.report();

      expect(mutableSetAddBenchmark.toMutable(), expectedSet);
    });

    test('`ISet`', () {
      final ISetAddBenchmark iSetAddBenchmark =
          ISetAddBenchmark(config: config, emitter: tableScoreEmitter);

      iSetAddBenchmark.report();

      expect(iSetAddBenchmark.toMutable(), expectedSet);
    });

    test('`KtSet`', () {
      final KtSetAddBenchmark ktSetAddBenchmark =
          KtSetAddBenchmark(config: config, emitter: tableScoreEmitter);

      ktSetAddBenchmark.report();

      expect(ktSetAddBenchmark.toMutable(), expectedSet);
    });

    test('`BuiltSet`', () {
      final BuiltSetAddWithRebuildBenchmark builtSetAddWithRebuildBenchmark =
          BuiltSetAddWithRebuildBenchmark(
              config: config, emitter: tableScoreEmitter);

      builtSetAddWithRebuildBenchmark.report();

      expect(builtSetAddWithRebuildBenchmark.toMutable(), expectedSet);
    });
  });
}
