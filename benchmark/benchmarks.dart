/// A library for the benchmarks for the `fast_immutable_collections` package.
/// {@category Collections, Immutable, Flutter}
library fast_immutable_collections_benchmarks;

import 'cases/add.dart' show AddBenchmark;
import 'cases/add_all.dart' show AddAllBenchmark;
import 'cases/empty.dart' show EmptyBenchmark;
import 'cases/read.dart' show ReadBenchmark;
import 'cases/remove.dart' show RemoveBenchmark;

/// Run the benchmarks with, for example: `dart benchmark/benchmarks.dart`
void main() {
  EmptyBenchmark.report();
  ReadBenchmark.report();
  AddBenchmark.report();
  RemoveBenchmark.report();
  AddAllBenchmark.report();
}
