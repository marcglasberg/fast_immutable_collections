import 'cases/benchmark_add.dart' show AddBenchmark;
import 'cases/benchmark_add_all.dart' show AddAllBenchmark;
import 'cases/banckmark_empty.dart' show EmptyBenchmark;
import 'cases/benchmark_read.dart' show ReadBenchmark;
import 'cases/banckmark_remove.dart' show RemoveBenchmark;

/// Run the benchmarks with, for example: `dart benchmark/benchmarks.dart`
void main() {
  // EmptyBenchmark.report();
  AddBenchmark.report();
  // RemoveBenchmark.report();
  // ReadBenchmark.report();
  // AddAllBenchmark.report();
}
