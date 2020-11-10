import "package:flutter/material.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

import "../utils/benchmarks_code.dart";
import "../widgets/bench_widget.dart";
import "../widgets/release_mode_warning.dart";

enum CollectionType { list, set, map }

class MultiBenchmarkScreen extends StatelessWidget {
  final CollectionType collectionType;

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
  /// error.
  List<Widget> get _benchmarks {
    switch (collectionType) {
      case CollectionType.list:
        return <Widget>[
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
                  config: Config(runs: 10, size: 500),
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
      case CollectionType.set:
        return <Widget>[
          BenchWidget(
            title: "Add",
            code: SetCode.add,
            benchmarks: [
              SetAddBenchmark(
                emitter: TableScoreEmitter(
                  prefixName: "set_add",
                  config: Config(runs: 100, size: 100),
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
      case CollectionType.map:
        return <Widget>[];
      default:
        throw UnimplementedError(
            "No benchmarks for this collection type you've somehow managed to choose.");
    }
  }
}
