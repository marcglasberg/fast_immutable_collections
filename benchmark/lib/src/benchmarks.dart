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
void main() => FullReporter()
  ..report()
  ..save();

class FullReporter {
  final Map<String, MultiBenchmarkReporter2> benchmarks = {
    // 'empty': EmptyBenchmark(),
    // 'read': ReadBenchmark(),
    // 'add': AddBenchmark(),
    // 'remove': RemoveBenchmark(),
    // 'addAll': AddAllBenchmark(),
    'contains': ContainsBenchmark(configs: const <Config>[
      Config(runs: 1000, size: 1000),
    ]),
  };

  void report() =>
      benchmarks.forEach((_, MultiBenchmarkReporter2 benchmarkReporter) =>
          benchmarkReporter.report());

  void save() =>
      benchmarks.forEach((_, MultiBenchmarkReporter2 benchmarkReporter) =>
          benchmarkReporter.save());
}
