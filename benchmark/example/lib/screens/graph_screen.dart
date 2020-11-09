import "package:flutter/material.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

import "../widgets/bar_chart.dart";

class GraphScreen extends StatefulWidget {
  final String title;
  final IList<RecordsTable> tables;

  const GraphScreen({@required this.title, @required this.tables});

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  /// Currently, only 5 configurations are possible, but you can easily change it by adding more
  /// icons, though the bottom bar will get crowded.
  static final IList<Icon> _sizeIcons = const [
    Icon(Icons.filter_1),
    Icon(Icons.filter_2),
    Icon(Icons.filter_3),
    Icon(Icons.filter_4),
    Icon(Icons.filter_5),
  ].lock;

  int _currentTableIndex = 0;
  List<BottomNavigationBarItem> _bottomItems;

  /// We will need to add an artifial button to the bottom bar if there's only one benchmark, since
  /// it requires at least 2 items.
  bool _onlyOneBenchmark = false;

  RecordsTable get _currentTable => widget.tables[_currentTableIndex];

  @override
  void initState() {
    super.initState();
    _bottomItems = <BottomNavigationBarItem>[
      for (int i = 0; i < widget.tables.length; i++)
        BottomNavigationBarItem(
          icon: _sizeIcons[i],
          label: "Size: ${widget.tables[i].config.size}",
        ),
    ];
    if (_bottomItems.length == 1) {
      _onlyOneBenchmark = true;
      _bottomItems.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_back),
          label: "Go back",
        ),
      );
    }
  }

  void _onTap(int index) => setState(() {
        if (_onlyOneBenchmark && index == 1)
          Navigator.of(context).pop();
        else
          _currentTableIndex = index;
      });

  @override
  Widget build(_) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title} Benchmark Graph Results"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 5),
        child: BarChart(recordsTable: _currentTable),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomItems,
        onTap: _onTap,
      ),
    );
  }
}
