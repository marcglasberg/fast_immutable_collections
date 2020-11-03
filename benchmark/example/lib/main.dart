import "package:flutter/material.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

import "widgets/button.dart";

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
        body: CollectionChoiceScreen(),
      ),
    );
  }
}

class CollectionChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFCCCCCC),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            Text(
              "Choose a collection type to benchmark:",
              style: const TextStyle(fontSize: 20),
            ),
            SizedBox(height: 40),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            button(
                              label: "List",
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            button(
                              label: "Map",
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            button(
                              label: "Set",
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )))
          ],
        ));
  }
}
