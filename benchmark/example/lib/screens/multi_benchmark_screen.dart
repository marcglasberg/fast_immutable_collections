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
  Widget build(BuildContext context) {
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
            if (!kReleaseMode) _releaseModeWarning(),
          ],
        ),
      ),
    );
  }

  Container _releaseModeWarning() => Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        width: double.infinity,
        color: Colors.black,
        child: const Text(
          "Please run this in release mode!",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      );

  List<Widget> get _benchmarks {
    switch (collectionType) {
      case CollectionType.list:
        return <Widget>[
          BenchWidget(
            description: "Add",
            code: add_code,
            benchmark: ListAddBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_add",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            description: "AddAll",
            code: add_all_code,
            benchmark: ListAddBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_add_all",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            description: "Contains",
            code: {},
            benchmark: ListAddBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_contains",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            description: "Empty",
            code: {},
            benchmark: ListAddBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_empty",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            description: "Read",
            code: {},
            benchmark: ListAddBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_read",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
          BenchWidget(
            description: "Remove",
            code: {},
            benchmark: ListAddBenchmark(
              emitter: TableScoreEmitter(
                prefixName: "list_remove",
                config: Config(runs: 100, size: 100),
              ),
            ),
          ),
        ];
      case CollectionType.set:
        return <Widget>[];
      case CollectionType.map:
        return <Widget>[];
      default:
        throw UnimplementedError("No benchmarks for this collection type you've somehow chosen.");
    }
  }
}
