import "package:flutter/material.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

import "screens/multi_benchmark_screen.dart";

void main() => runApp(BenchmarkApp());

class BenchmarkApp extends StatelessWidget {
  final ListEmptyBenchmark listEmptyBenchmark =
      ListEmptyBenchmark(configs: const [Config(runs: 100, size: 100)]);

  BenchmarkApp() {
    listEmptyBenchmark.report();
  }

  RecordsTable get table =>
      (listEmptyBenchmark.benchmarks.first.emitter as TableScoreEmitter).table;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight * 1.3,
          title: Text(
            "Fast Immutable Collections Benchmarks",
            maxLines: 2,
            style: TextStyle(color: Colors.white, height: 1.3),
          ),
        ),
        body: MultiBenchmarkScreen(),
      ),
    );
  }
}
