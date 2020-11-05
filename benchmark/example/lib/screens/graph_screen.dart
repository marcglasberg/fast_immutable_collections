import "package:flutter/material.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

import "../widgets/bar_chart.dart";

class GraphScreen extends StatelessWidget {
  final RecordsTable recordsTable;

  const GraphScreen({@required this.recordsTable});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Graph Results"),
      ),
      body: Container(
        child: BarChart(recordsTable: recordsTable),
      ),
    );
  }
}
