import 'utils/config.dart';
import 'utils/multi_benchmark_reporter.dart';

import 'cases/list/add.dart';
import 'cases/list/add_all.dart';
import 'cases/list/contains.dart';
import 'cases/list/empty.dart';
import 'cases/list/read.dart';
import 'cases/list/remove.dart';

/// Run the benchmarks with, for example &mdash; from the top of the project
/// &mdash;: `dart benchmark/lib/src/benchmarks.dart`
void main() => FullListReporter()
  ..report()
  ..save();

class FullListReporter {
  final List<MultiBenchmarkReporter> benchmarks = [
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

  void report() => benchmarks.forEach(
      (MultiBenchmarkReporter benchmarkReporter) => benchmarkReporter.report());

  void save() => benchmarks.forEach(
      (MultiBenchmarkReporter benchmarkReporter) => benchmarkReporter.save());
}
