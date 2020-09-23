import 'utils/multi_benchmark_reporter.dart';
import 'utils/list_benchmark_base.dart';

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
  final List<MultiBenchmarkReporter2> benchmarks = [
    // 'empty': EmptyBenchmark(),
    // 'read': ReadBenchmark(),
    AddBenchmark(configs: const <Config>[
      Config(runs: 5000, size: 100),
      Config(runs: 5000, size: 1000),
      Config(runs: 5000, size: 10000),
      Config(runs: 5000, size: 100000),
    ]),
    // 'remove': RemoveBenchmark(),
    AddAllBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 0),
    ]),
    ContainsBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 1000),
    ]),
  ];

  void report() =>
      benchmarks.forEach((MultiBenchmarkReporter2 benchmarkReporter) =>
          benchmarkReporter.report());

  void save() => benchmarks.forEach(
      (MultiBenchmarkReporter2 benchmarkReporter) => benchmarkReporter.save());
}
