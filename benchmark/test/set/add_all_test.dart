import 'package:fast_immutable_collections_benchmarks/src/cases/set/add_all.dart';
import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const Config config = Config(runs: 1, size: 10);
  final Set<int> expectedSet = Set<int>.of(SetAddAllBenchmark.baseSet)
    ..addAll(SetAddAllBenchmark.setToAdd);

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter = TableScoreEmitter(prefixName: 'set_add_all');

    test('`Set` (Mutable)', () {
      final MutableSetAddAllBenchmark mutableSetAddAllBenchmark =
          MutableSetAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      mutableSetAddAllBenchmark.report();

      expect(mutableSetAddAllBenchmark.toMutable(), expectedSet);
    });

    test('`ISet`', () {
      final ISetAddAllBenchmark iSetAddAllBenchmark =
          ISetAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      iSetAddAllBenchmark.report();

      expect(iSetAddAllBenchmark.toMutable(), expectedSet);
    });

    test('`KtSet`', () {
      final KtSetAddAllBenchmark ktSetAddAllBenchmark =
          KtSetAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      ktSetAddAllBenchmark.report();

      expect(ktSetAddAllBenchmark.toMutable(), expectedSet);
    });

    test('`BuiltSet`', () {
      final BuiltSetAddAllBenchmark builtSetAddAllBenchmark =
          BuiltSetAddAllBenchmark(config: config, emitter: tableScoreEmitter);

      builtSetAddAllBenchmark.report();

      expect(builtSetAddAllBenchmark.toMutable(), expectedSet);
    });
  });

  group('Multiple Benchmarks |', () {
    test('Simple run', () {
      final SetAddAllBenchmark setAddAllBenchmark = SetAddAllBenchmark(configs: [config, config]);

      setAddAllBenchmark.report();

      setAddAllBenchmark.benchmarks
          .forEach((SetBenchmarkBase benchmark) => expect(benchmark.toMutable(), expectedSet));
    });
  });
}
