import "package:benchmark_app/utils/benchmarks_code.dart";
import "package:benchmark_app/widgets/bench_widget.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:flutter/material.dart";

/// Be careful with the parameters. If they are too big, you might encounter a difficult-to-debug
/// error, probably due to insufficient memory.

final List<Widget> listBenchmarks = [
  BenchWidget(
    title: "List.add",
    code: ListCode.add,
    benchmarks: () => [
      ListAddBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "list_add_1",
          config: Config(size: 10),
        ),
      ),
      ListAddBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "list_add_2",
          config: Config(size: 1000),
        ),
      ),
      ListAddBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "list_add_3",
          config: Config(size: 10000),
        ),
      ),
      ListAddBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "list_add_4",
          config: Config(size: 100000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "List.addAll",
    code: ListCode.addAll,
    benchmarks: () => [
      ListAddAllBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "list_add_all",
          config: Config(size: 10000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "List.contains",
    code: ListCode.contains,
    benchmarks: () => [
      ListContainsBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "list_contains",
          config: Config(size: 10000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "List.empty",
    code: ListCode.empty,
    benchmarks: () => [
      ListEmptyBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "list_empty",
          config: Config(size: 0),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "List.insert",
    code: ListCode.insert,
    benchmarks: () => [
      ListInsertBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "list_insert",
          config: Config(size: 1000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "List.read",
    code: ListCode.read,
    benchmarks: () => [
      ListReadBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "list_read",
          config: Config(size: 100000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "List.remove",
    code: ListCode.remove,
    benchmarks: () => [
      ListRemoveBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "list_remove",
          config: Config(size: 10000),
        ),
      ),
    ],
  ),
];

final List<Widget> setBenchmarks = [
  BenchWidget(
    title: "Set.add",
    code: SetCode.add,
    benchmarks: () => [
      SetAddBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_add_1",
          config: Config(size: 10),
        ),
      ),
      SetAddBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_add_2",
          config: Config(size: 1000),
        ),
      ),
      SetAddBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_add_3",
          config: Config(size: 10000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "Set.addAll",
    code: SetCode.addAll,
    benchmarks: () => [
      SetAddAllBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_add_all_1",
          config: Config(size: 10000),
        ),
      ),
      SetAddAllBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_add_all_2",
          config: Config(size: 100000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "Set.contains",
    code: SetCode.contains,
    benchmarks: () => [
      SetContainsBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_contains",
          config: Config(size: 1000),
        ),
      ),
      SetContainsBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_contains",
          config: Config(size: 10000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "Set.empty",
    code: SetCode.contains,
    benchmarks: () => [
      SetEmptyBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_empty",
          config: Config(size: 0),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "Set.remove",
    code: SetCode.contains,
    benchmarks: () => [
      SetRemoveBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_remove_1",
          config: Config(size: 100),
        ),
      ),
      SetRemoveBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_remove_2",
          config: Config(size: 1000),
        ),
      ),
      SetRemoveBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_remove_3",
          config: Config(size: 10000),
        ),
      ),
      SetRemoveBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "set_remove_4",
          config: Config(size: 100000),
        ),
      ),
    ],
  ),
];

final List<Widget> mapBenchmarks = [
  BenchWidget(
    title: "Map.add",
    code: MapCode.add,
    benchmarks: () => [
      MapAddBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "map_add_1",
          config: Config(size: 10),
        ),
      ),
      MapAddBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "map_add_2",
          config: Config(size: 1000),
        ),
      ),
      MapAddBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "map_add_3",
          config: Config(size: 10000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "Map.addAll",
    code: MapCode.addAll,
    benchmarks: () => [
      MapAddAllBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "map_add_all",
          config: Config(size: 100000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "Map.containsValue",
    code: MapCode.containsValue,
    benchmarks: () => [
      MapContainsValueBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "map_contains_value",
          config: Config(size: 10000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "Map.empty",
    code: MapCode.empty,
    benchmarks: () => [
      MapEmptyBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "map_empty",
          config: Config(size: 0),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "Map.read",
    code: MapCode.read,
    benchmarks: () => [
      MapReadBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "map_read",
          config: Config(size: 100000),
        ),
      ),
    ],
  ),
  BenchWidget(
    title: "Map.remove",
    code: MapCode.remove,
    benchmarks: () => [
      MapRemoveBenchmark(
        emitter: TableScoreEmitter(
          prefixName: "map_remove",
          config: Config(size: 100000),
        ),
      ),
    ],
  ),
];
