import "package:fast_immutable_collections_example/widgets/bar_chart.dart";
import "package:flutter/material.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

class GraphScreen extends StatefulWidget {
  final String title;
  final List<RecordsTable> tables;

  const GraphScreen({@required this.title, @required this.tables});

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  /// Currently, only 5 configurations are possible, but you can easily change it by adding more
  /// icons, though the bottom bar will get crowded.
  static const List<Icon> _sizeIcons = [
    Icon(Icons.filter_1),
    Icon(Icons.filter_2),
    Icon(Icons.filter_3),
    Icon(Icons.filter_4),
    Icon(Icons.filter_5),
  ];

  int _currentTableIndex = 0;
  List<BottomNavigationBarItem> _bottomItems;

  /// We will need to add an artifial button to the bottom bar if there's only one benchmark, since
  /// it requires at least 2 items.
  bool _onlyOneBenchmark = false;
  bool _stacked = false;

  RecordsTable get _currentTable {
    if (_currentTableIndex >= widget.tables.length) {
      return widget.tables.last;
    } else {
      return widget.tables[_currentTableIndex];
    }
  }

  List<String> _possibleFilters;

  @override
  void initState() {
    _possibleFilters = _currentTable.rowNames;

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
    } else if (_bottomItems.length > 1) {
      _bottomItems.add(
        BottomNavigationBarItem(
          icon: const Icon(Icons.table_rows),
          label: "All",
        ),
      );
    }
  }

  void _onTap(int index) => setState(() {
        if (_onlyOneBenchmark && index == 1) {
          Navigator.of(context).pop();
        } else if (index == widget.tables.length) {
          _stacked = true;
          _currentTableIndex = index;
        } else {
          _stacked = false;
          _currentTableIndex = index;
        }
      });

  final List<String> _currentFilters = [];

  @override
  Widget build(_) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title} Benchmark Graph Results"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  hint: Text(
                    "Filter by: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  items: _possibleFilters
                      .map<DropdownMenuItem<String>>(
                        (String filter) => DropdownMenuItem<String>(
                          value: filter,
                          child: Text(
                            filter,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (String newFilter) {
                    setState(() {
                      _possibleFilters.remove(newFilter);
                      _currentFilters.add(newFilter);
                    });
                  },
                ),
              ],
            ),
            Container(
              height: 500,
              child: _stacked
                  ? StackedBarChart(recordsTables: _filterAllNTimes())
                  : BarChart(recordsTable: _filterNTimes(_currentTable)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: _bottomItems,
        onTap: _onTap,
        currentIndex: _currentTableIndex,
      ),
    );
  }

  List<RecordsTable> _filterAllNTimes() {
    final List<RecordsTable> tables = [];
    widget.tables.forEach((RecordsTable table) => tables.add(_filterNTimes(table)));
    return tables;
  }

  RecordsTable _filterNTimes(RecordsTable table) {
    _currentFilters.forEach((String filter) => table = table.filter(filter));
    return table;
  }
}
