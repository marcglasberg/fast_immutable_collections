import "package:flutter/material.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

import "../widgets/bar_chart.dart";

class GraphScreen extends StatelessWidget {
  final String title;
  final RecordsTable recordsTable;

  const GraphScreen({@required this.title, @required this.recordsTable});

  @override
  Widget build(_) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title Benchmark Graph Results"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 5),
        child: BarChart(recordsTable: recordsTable),
      ),
    );
  }
}
