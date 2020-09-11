import 'cases/add.dart' show AddBenchmark;
import 'cases/empty.dart' show EmptyBenchmark;
import 'cases/read.dart' show ReadBenchmark;
import 'cases/remove.dart' show RemoveBenchmark;

/// Run the benchmarks with, for example: `dart benchmark/benchmarks.dart`
void main() {
  EmptyBenchmark.report();
  AddBenchmark.report();
  RemoveBenchmark.report();
  ReadBenchmark.report();
}
