import 'package:fast_immutable_collections_benchmarks/src/cases/set/remove.dart';
import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int size = 100;
  const Config config = Config(runs: 1, size: size);
  final Set<int> expectedSet = SetBenchmarkBase.getDummyGeneratedSet(size: size)..remove(1);

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(reportName: 'set_remove');

    test('`List` (Mutable)', () {
      final MutableSetRemoveBenchmark mutableSetRemoveBenchmark =
          MutableSetRemoveBenchmark(config: config, emitter: tableScoreEmitter);

      mutableSetRemoveBenchmark.report();

      expect(mutableSetRemoveBenchmark.toMutable(), expectedSet);
    });

    test('`ISet`', () {
      final ISetRemoveBenchmark iSetRemoveBenchmark =
          ISetRemoveBenchmark(config: config, emitter: tableScoreEmitter);

      iSetRemoveBenchmark.report();

      expect(iSetRemoveBenchmark.toMutable(), expectedSet);
    });

    test('`KtSet`', () {
      final KtSetRemoveBenchmark ktSetRemoveBenchmark =
          KtSetRemoveBenchmark(config: config, emitter: tableScoreEmitter);

      ktSetRemoveBenchmark.report();

      expect(ktSetRemoveBenchmark.toMutable(), expectedSet);
    });

    test('`BuiltSet`', () {
      final BuiltSetRemoveBenchmark builtSetRemoveBenchmark =
          BuiltSetRemoveBenchmark(config: config, emitter: tableScoreEmitter);

      builtSetRemoveBenchmark.report();

      expect(builtSetRemoveBenchmark.toMutable(), expectedSet);
    });
  });

  group('Multiple Benchmarks |', () {
    test('Simple run', () {
      final SetRemoveBenchmark setRemoveBenchmark = SetRemoveBenchmark(configs: [config, config]);

      setRemoveBenchmark.report();

      setRemoveBenchmark.benchmarks
          .forEach((SetBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedSet));
    });
  });
}
