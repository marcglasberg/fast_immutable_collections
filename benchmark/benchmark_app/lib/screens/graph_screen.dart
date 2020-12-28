import "dart:async";
import "../widgets/bar_chart.dart";
import "package:flutter/material.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:intl/intl.dart";

class GraphScreen extends StatefulWidget {
  final String title;
  final List<RecordsTable> tables;

  const GraphScreen({@required this.title, @required this.tables});

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  static final NumberFormat formatter = NumberFormat("#,##0", "en_US");

  int _currentTableIndex;

  /// We will need to add an artificial button to the bottom bar if there's only one benchmark,
  /// since it requires at least 2 items.
  bool _onlyOneBenchmark;

  final StreamController<Map<String, bool>> _filtersStream = StreamController();
  Map<String, bool> _currentFilters = {};

  RecordsTable get _currentTable => _currentTableIndex >= widget.tables.length
      ? widget.tables.last
      : widget.tables[_currentTableIndex];

  @override
  void initState() {
    _onlyOneBenchmark = false;
    _currentTableIndex = 0;

    Map<String, bool> _currentFilters = {};
    _currentTable.rowNames.forEach((String rowName) => _currentFilters.addAll({rowName: true}));
    _filtersStream.add(_currentFilters);

    super.initState();
  }

  List<InkWell> _bottomItems(activeIndex) {
    final List<InkWell> bottomItems = <InkWell>[
      for (int i = 0; i < widget.tables.length; i++)
        InkWell(
          onTap: () => _onTap(i),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              "${formatter.format(widget.tables[i].config.size)}",
              style: TextStyle(
                fontSize: 17,
                color: activeIndex == i ? Colors.black : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ];
    if (bottomItems.length == 1) {
      _onlyOneBenchmark = true;
      bottomItems.add(
        InkWell(
          onTap: () => _onTap(1),
          child: Container(
            child: const Icon(Icons.arrow_back, color: Colors.grey),
          ),
        ),
      );
    }
    return bottomItems;
  }

  void _onTap(int index) => setState(() {
        if (_onlyOneBenchmark && index == 1) {
          Navigator.of(context).pop();
        } else {
          _currentTableIndex = index;
        }
      });

  @override
  Widget build(_) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title} Benchmark Graph Results"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: StreamBuilder<Map<String, bool>>(
            stream: _filtersStream.stream,
            builder: (_, AsyncSnapshot<Map<String, bool>> snapshot) {
              if (snapshot.hasData) _currentFilters = snapshot.data;

              return ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        hint: const Text(
                          "Filter",
                          style: TextStyle(fontSize: 20),
                        ),
                        items: _currentFilters.keys
                            .map<DropdownMenuItem<String>>(
                              (String filter) => DropdownMenuItem<String>(
                                value: filter,
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: _currentFilters[filter],
                                      onChanged: (bool value) {
                                        updateFilters(filter);
                                      },
                                    ),
                                    Text(
                                      filter,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: updateFilters,
                      ),
                    ],
                  ),
                  Container(
                    height: 490,
                    child: BarChart(recordsTable: _filterNTimes(_currentTable)),
                  ),
                ],
              );
            }),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]),
        ),
        height: 60,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8),
            const Text(
              "Sizes",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _bottomItems(_currentTableIndex),
            ),
          ],
        ),
      ),
    );
  }

  void updateFilters(String newFilter) {
    _currentFilters.update(newFilter, (bool value) => !value);
    _filtersStream.add(_currentFilters);
  }

  RecordsTable _filterNTimes(RecordsTable table) {
    _currentFilters.forEach((String filterName, bool shouldNotFilter) {
      if (!shouldNotFilter) table = table.filter(filterName);
    });
    return table;
  }
}
