import "package:fast_immutable_collections_example/utils/benchmarks_code.dart";
import "package:fast_immutable_collections_example/widgets/bench_widget.dart";
import "package:fast_immutable_collections_example/widgets/release_mode_warning.dart";
import "package:flutter/material.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

class MultiBenchmarkScreen extends StatelessWidget {
  final Type collectionType;

  const MultiBenchmarkScreen({@required this.collectionType});

  @override
  Widget build(_) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose a benchmark to test"),
      ),
      body: Container(
        color: const Color(0xFFCCCCCC),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _benchmarks,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ReleaseModeWarning(),
    );
  }

  /// Be careful with the parameters. If they are too big, you might encounter a difficult-to-debug
  /// error, probably due to insufficient memory.
  List<Widget> get _benchmarks {
    switch (collectionType) {
      case List:
        return _listBenchmarks;
      case Set:
        return _setBenchmarks;
      case Map:
        return _mapBenchmarks;
      default:
        throw UnimplementedError("No benchmarks for this collection type.");
    }
  }

  static final List<Widget> _listBenchmarks = [
    BenchWidget(
      title: "Add",
      code: ListCode.add,
      benchmarks: [
        ListAddBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "list_add_1",
            config: Config(runs: 10, size: 10),
          ),
        ),
        ListAddBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "list_add_2",
            config: Config(runs: 10, size: 100),
          ),
        ),
        ListAddBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "list_add_3",
            config: Config(runs: 5, size: 10000),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "AddAll",
      code: ListCode.addAll,
      benchmarks: [
        ListAddAllBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "list_add_all",
            config: Config(runs: 100, size: 100),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "Contains",
      code: ListCode.contains,
      benchmarks: [
        ListContainsBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "list_contains",
            config: Config(runs: 100, size: 100),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "Empty",
      code: ListCode.empty,
      benchmarks: [
        ListEmptyBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "list_empty",
            config: Config(runs: 100, size: 100),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "Read",
      code: ListCode.read,
      benchmarks: [
        ListReadBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "list_read",
            config: Config(runs: 100, size: 100),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "Remove",
      code: ListCode.remove,
      benchmarks: [
        ListRemoveBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "list_remove",
            config: Config(runs: 100, size: 100),
          ),
        ),
      ].lock,
    ),
  ];

  static final List<Widget> _setBenchmarks = [
    BenchWidget(
      title: "Add",
      code: SetCode.add,
      benchmarks: [
        SetAddBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "set_add_1",
            config: Config(runs: 10, size: 10),
          ),
        ),
        SetAddBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "set_add_2",
            config: Config(runs: 10, size: 50),
          ),
        ),
        SetAddBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "set_add_3",
            config: Config(runs: 10, size: 100),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "AddAll",
      code: SetCode.addAll,
      benchmarks: [
        SetAddAllBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "set_add_all",
            config: Config(runs: 100, size: 100),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "Contains",
      code: SetCode.contains,
      benchmarks: [
        SetContainsBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "set_contains",
            config: Config(runs: 100, size: 100),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "Empty",
      code: SetCode.contains,
      benchmarks: [
        SetEmptyBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "set_empty",
            config: Config(runs: 100, size: 100),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "Remove",
      code: SetCode.contains,
      benchmarks: [
        SetRemoveBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "set_remove",
            config: Config(runs: 100, size: 100),
          ),
        ),
      ].lock,
    ),
  ];

  static final List<Widget> _mapBenchmarks = [
    BenchWidget(
      title: "Add",
      code: MapCode.add,
      benchmarks: [
        MapAddBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "map_add_1",
            config: Config(runs: 10, size: 10),
          ),
        ),
        MapAddBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "map_add_2",
            config: Config(runs: 10, size: 100),
          ),
        ),
        MapAddBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "map_add_3",
            config: Config(runs: 10, size: 500),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "AddAll",
      code: MapCode.addAll,
      benchmarks: [
        MapAddAllBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "map_add_all",
            config: Config(runs: 100, size: 10),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "ContainsValue",
      code: MapCode.containsValue,
      benchmarks: [
        MapContainsValueBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "map_contains_value",
            config: Config(runs: 100, size: 10),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "Empty",
      code: MapCode.empty,
      benchmarks: [
        MapEmptyBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "map_empty",
            config: Config(runs: 100, size: 0),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "Read",
      code: MapCode.read,
      benchmarks: [
        MapReadBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "map_read",
            config: Config(runs: 100, size: 1000),
          ),
        ),
      ].lock,
    ),
    BenchWidget(
      title: "Remove",
      code: MapCode.remove,
      benchmarks: [
        MapRemoveBenchmark(
          emitter: TableScoreEmitter(
            prefixName: "map_remove",
            config: Config(runs: 100, size: 1000),
          ),
        ),
      ].lock,
    ),
  ];
}
