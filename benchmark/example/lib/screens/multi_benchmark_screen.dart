import "package:flutter/material.dart";
import "package:flutter/foundation.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

import "../utils/benchmarks_code.dart";
import "../widgets/bench_widget.dart";

enum CollectionType { list, set, map }

class MultiBenchmarkScreen extends StatelessWidget {
  final CollectionType collectionType;

  const MultiBenchmarkScreen({
    Key key,
    @required this.collectionType,
  }) : super(key: key);

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
            if (!kReleaseMode)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                width: double.infinity,
                color: Colors.black,
                child: const Text(
                  "Please run this in release mode!",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _benchmarks {
    switch (collectionType) {
      case CollectionType.list:
        return <Widget>[
          BenchWidget(
            title: "Add",
            code: ListCode.add,
            benchmark: ListAddBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_add",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            title: "AddAll",
            code: ListCode.add_all,
            benchmark: ListAddAllBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_add_all",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            title: "Contains",
            code: ListCode.contains,
            benchmark: ListContainsBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_contains",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            title: "Empty",
            code: ListCode.empty,
            benchmark: ListEmptyBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_empty",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            title: "Read",
            code: ListCode.read,
            benchmark: ListReadBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_read",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            title: "Remove",
            code: ListCode.remove,
            benchmark: ListRemoveBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_remove",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
        ];
      case CollectionType.set:
        return <Widget>[
          BenchWidget(
            title: "Add",
            code: SetCode.add,
            benchmark: SetAddBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "set_add",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            title: "AddAll",
            code: SetCode.add_all,
            benchmark: SetAddAllBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "set_add_all",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            title: "Contains",
            code: SetCode.contains,
            benchmark: SetContainsBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "set_contains",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            title: "Empty",
            code: SetCode.contains,
            benchmark: SetEmptyBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "set_empty",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            title: "Remove",
            code: SetCode.contains,
            benchmark: SetRemoveBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "set_remove",
                config: Config(runs: 100, size: 100),
              ),
            ),
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
