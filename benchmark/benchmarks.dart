import 'cases/add.dart' show AddBenchmark;
import 'cases/empty.dart' show EmptyBenchmark;

/// Run the benchmarks with, for example: `dart benchmark/benchmarks.dart`
void main() {
  EmptyBenchmark.report();
  AddBenchmark.report();
}
