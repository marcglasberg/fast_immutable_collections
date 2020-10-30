import "package:flutter/material.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() => runApp(BenchmarkApp());

class BenchmarkApp extends StatelessWidget {
  final ListEmptyBenchmark listEmptyBenchmark =
      ListEmptyBenchmark(configs: const [Config(runs: 100, size: 100)]);

  BenchmarkApp() {
    listEmptyBenchmark.report();
  }

  Map<String, double> get scores =>
      (listEmptyBenchmark.benchmarks.first.emitter as TableScoreEmitter).table["scores"];

  @override
  Widget build(BuildContext context) {
    print(scores);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Benchmark Report"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Text("Empty Benchmark"),
              Expanded(
                child: ListView.builder(
                  itemCount: scores.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (_, int index) {
                    return Row(
                      children: [
                        Text(scores.keys.toList()[index]),
                        Text(scores.values.toList()[index].toString()),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
