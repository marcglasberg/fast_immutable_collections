import 'package:fast_immutable_collections_benchmarks/src/cases/set/add_all.dart';
import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int size = 10;
  const Config config = Config(runs: 1, size: 10);
  final Set<int> expectedSet = Set<int>.of(SetAddAllBenchmark.baseSet)
    ..addAll(SetAddAllBenchmark.setToAdd);

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'set_add_all');

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
      
    });
  });
}
