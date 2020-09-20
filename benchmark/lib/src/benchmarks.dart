import 'utils/benchmark_reporter.dart' show BenchmarkReporter;
import 'cases/benchmark_add.dart' show AddBenchmark;
import 'cases/benchmark_add_all.dart' show AddAllBenchmark;
import 'cases/benchmark_empty.dart' show EmptyBenchmark;
import 'cases/benchmark_read.dart' show ReadBenchmark;
import 'cases/benchmark_remove.dart' show RemoveBenchmark;

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
