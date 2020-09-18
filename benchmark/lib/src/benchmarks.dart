import 'cases/add.dart' show AddBenchmark;
import 'cases/add_all.dart' show AddAllBenchmark;
import 'cases/empty.dart' show EmptyBenchmark;
import 'cases/read.dart' show ReadBenchmark;
import 'cases/remove.dart' show RemoveBenchmark;

/// Run the benchmarks with, for example &mdash; from the top of the project
/// &mdash;: `dart benchmark/lib/src/benchmarks.dart`
void main() => fullReport();

void fullReport() {
  EmptyBenchmark.report();
  ReadBenchmark.report();
  AddBenchmark.report();
  RemoveBenchmark.report();
  AddAllBenchmark.report();
}
