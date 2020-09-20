import 'utils/benchmark_reporter.dart' show BenchmarkReporter;
import 'cases/add.dart' show AddBenchmark;
import 'cases/add_all.dart' show AddAllBenchmark;
import 'cases/empty.dart' show EmptyBenchmark;
import 'cases/read.dart' show ReadBenchmark;
import 'cases/remove.dart' show RemoveBenchmark;

/// Run the benchmarks with, for example &mdash; from the top of the project
/// &mdash;: `dart benchmark/lib/src/benchmarks.dart`
void main() => FullReporter()
  ..report()
  ..save();

class FullReporter {
  final Map<String, BenchmarkReporter> benchmarks = {
    'empty': EmptyBenchmark(),
    'read': ReadBenchmark(),
    'add': AddBenchmark(),
    'remove': RemoveBenchmark(),
    'addAll': AddAllBenchmark(),
  };

  void report() => benchmarks.forEach(
      (_, BenchmarkReporter benchmarkReporter) => benchmarkReporter.report());

  void save() => benchmarks.forEach(
      (_, BenchmarkReporter benchmarkReporter) => benchmarkReporter.save());
}
