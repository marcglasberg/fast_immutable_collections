/// A library for the benchmarks for the `fast_immutable_collections` package.
/// {@category Collections, Benchmark, Immutable, Flutter}
library fast_immutable_collections_benchmarks;

export "src/benchmarks.dart";

export "src/cases/list/add.dart";
export "src/cases/list/add_all.dart";
export "src/cases/list/contains.dart";
export "src/cases/list/empty.dart";
export "src/cases/list/read.dart";
export "src/cases/list/remove.dart";

export "src/cases/set/add.dart";
export "src/cases/set/contains.dart";
export "src/cases/set/empty.dart";

export "src/utils/config.dart";
export "src/utils/collection_benchmark_base.dart";
export "src/utils/collection_full_reporter.dart";
export "src/utils/multi_benchmark_reporter.dart";
export "src/utils/table_score_emitter.dart";
