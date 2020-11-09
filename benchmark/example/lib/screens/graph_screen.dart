import "package:flutter/material.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

import "../widgets/bar_chart.dart";

class GraphScreen extends StatelessWidget {
  final String title;
  final RecordsTable recordsTable;

  const GraphScreen({@required this.title, @required this.recordsTable});

  static final IList<Icon> _sizeIcons = const [
    Icon(Icons.filter_1),
    Icon(Icons.filter_2),
    Icon(Icons.filter_3),
    Icon(Icons.filter_4),
    Icon(Icons.filter_5),
  ].lock;

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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _sizeIcons[0],
            label: "Size: 1",
          ),
          BottomNavigationBarItem(
            icon: _sizeIcons[1],
            label: "Size: 2",
          ),
          BottomNavigationBarItem(
            icon: _sizeIcons[2],
            label: "Size: 3",
          ),
        ],
      ),
    );
  }
}
