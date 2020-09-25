import 'collection_benchmark_base.dart';
import 'config.dart';
import 'multi_benchmark_reporter.dart';

import '../cases/list/add.dart';
import '../cases/list/add_all.dart';
import '../cases/list/contains.dart';
import '../cases/list/empty.dart';
import '../cases/list/read.dart';
import '../cases/list/remove.dart';

import '../cases/set/add.dart';
import '../cases/set/add_all.dart';
import '../cases/set/contains.dart';
import '../cases/set/empty.dart';
import '../cases/set/remove.dart';

abstract class CollectionFullReporter<M extends MultiBenchmarkReporter,
    B extends CollectionBenchmarkBase> {
  List<MultiBenchmarkReporter<B>> benchmarks;

  void report() =>
      benchmarks.forEach((MultiBenchmarkReporter<B> benchmarkReporter) =>
          benchmarkReporter.report());

  void save() =>
      benchmarks.forEach((MultiBenchmarkReporter<B> benchmarkReporter) =>
          benchmarkReporter.save());
}

class ListFullReporter extends CollectionFullReporter<
    MultiBenchmarkReporter<ListBenchmarkBase>, ListBenchmarkBase> {
  @override
  final List<MultiBenchmarkReporter<ListBenchmarkBase>> benchmarks = [
    ListAddAllBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 0),
    ]),
    ListAddBenchmark(configs: const <Config>[
      Config(runs: 5000, size: 100),
      Config(runs: 5000, size: 1000),
      Config(runs: 5000, size: 10000),
    ]),
    ListContainsBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 1000),
    ]),
    ListEmptyBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 0),
    ]),
    ListReadBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 1000),
    ]),
    ListRemoveBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 1000),
    ]),
  ];
}

class SetFullReporter extends CollectionFullReporter<
    MultiBenchmarkReporter<SetBenchmarkBase>, SetBenchmarkBase> {
  @override
  final List<MultiBenchmarkReporter<SetBenchmarkBase>> benchmarks = [
    SetAddAllBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 0),
    ]),
    SetAddBenchmark(configs: const <Config>[
      Config(runs: 5000, size: 100),
      Config(runs: 5000, size: 1000),
      Config(runs: 5000, size: 10000),
    ]),
    SetContainsBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 1000),
    ]),
    SetEmptyBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 0),
    ]),
    SetRemoveBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 1000),
    ]),
  ];
}
