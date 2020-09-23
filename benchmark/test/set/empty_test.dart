import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int size = 100;
  const Config config = Config(runs: 100, size: size);
  final Set<int> expectedSet = {};

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'set_empty');

    test('`Set` (Mutable)', () {
      final SetEmptyBenchmark setEmptyBenchmark =
          SetEmptyBenchmark(config: config, emitter: tableScoreEmitter);

      setEmptyBenchmark.report();

      expect(setEmptyBenchmark.toMutable(), expectedSet);
    });

    test('`ISet`', () {
      final ISetEmptyBenchmark iSetEmptyBenchmark =
          ISetEmptyBenchmark(config: config, emitter: tableScoreEmitter);

      iSetEmptyBenchmark.report();

      expect(iSetEmptyBenchmark.toMutable(), expectedSet);
    });
  });
}
