import 'package:test/test.dart';

import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  const int size = 100;
  const Config config = Config(runs: 100, size: size);
  final int numberToRead =
      ListBenchmarkBase.dummyStaticList[ReadBenchmark.indexToRead];

  group('Separate Benchmarks |', () {
    final TableScoreEmitter tableScoreEmitter =
        TableScoreEmitter(reportName: 'list_read');

    test('`List` (Mutable)', () {
      final ListReadBenchmark listReadBenchmark =
          ListReadBenchmark(config: config, emitter: tableScoreEmitter);

      listReadBenchmark.report();

      expect(listReadBenchmark.newVar, numberToRead);
    });

    test('`IList`', () {
      final IListReadBenchmark iListReadBenchmark =
          IListReadBenchmark(config: config, emitter: tableScoreEmitter);

      iListReadBenchmark.report();

      expect(iListReadBenchmark.newVar, numberToRead);
    });

    test('`KtList`', () {
      final KtListReadBenchmark ktListReadBenchmark =
          KtListReadBenchmark(config: config, emitter: tableScoreEmitter);

      ktListReadBenchmark.report();

      expect(ktListReadBenchmark.newVar, numberToRead);
    });

    test('`BuiltList`', () {
      final BuiltListReadBenchmark builtListReadBenchmark =
          BuiltListReadBenchmark(config: config, emitter: tableScoreEmitter);

      builtListReadBenchmark.report();

      expect(builtListReadBenchmark.newVar, numberToRead);
    });
  });

  group('Multiple Benchmarks |', () {
    test('Simple run', () {
      final ReadBenchmark readBenchmark =
          ReadBenchmark(configs: [config, config]);

      readBenchmark.report();

      readBenchmark.benchmarks.forEach((CollectionBenchmarkBase benchmark) => expect(
          benchmark.toMutable()[ReadBenchmark.indexToRead], numberToRead));
    });
  });
}
