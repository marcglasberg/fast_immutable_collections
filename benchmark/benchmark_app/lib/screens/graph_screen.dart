import "../widgets/bar_chart.dart";
import "package:flutter/material.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:intl/intl.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

// ////////////////////////////////////////////////////////////////////////////

class GraphScreen extends StatefulWidget {
  final String title;
  final List<RecordsTable> tables;

  const GraphScreen({@required this.title, @required this.tables});

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

// ////////////////////////////////////////////////////////////////////////////

class _GraphScreenState extends State<GraphScreen> {
  static final NumberFormat formatter = NumberFormat("#,##0", "en_US");

  static const bottomNavigationBarDecoration = BoxDecoration(
    border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
  );

  int _currentTableIndex;

  /// We need to add an artificial button to the bottom bar if there's
  /// only one benchmark, since it requires at least 2 items.
  bool _onlyOneBenchmark;

  IMap<String, bool> filters;

  RecordsTable get _currentTable => _currentTableIndex >= widget.tables.length
      ? widget.tables.last
      : widget.tables[_currentTableIndex];

  @override
  void initState() {
    _onlyOneBenchmark = false;
    _currentTableIndex = 0;

    filters = <String, bool>{}.lock;
    _currentTable.rowNames.forEach((String rowName) => filters = filters.add(rowName, true));

    super.initState();
  }

  @override
  Widget build(_) => Scaffold(
        appBar: AppBar(title: _title()),
        body: _body(),
        bottomNavigationBar: _bottomNavigationBar(),
      );

  Text _title() => Text("${widget.title} Benchmark Graph Results");

  Container _body() {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: ListView(
        children: [
          _DropdownButton(filters, updateFilters),
          Container(
            height: 490,
            child: BarChart(recordsTable: _filterNTimes(_currentTable)),
          ),
        ],
      ),
    );
  }

  Container _bottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: bottomNavigationBarDecoration,
      height: 60,
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text("Sizes", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _bottomItems(_currentTableIndex),
          ),
        ],
      ),
    );
  }

  void updateFilters(String newFilter) {
    setState(() {
      filters = filters.update(newFilter, (bool value) => !value);
    });
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
              style: _bottomItemTextStyle(activeIndex, i),
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

  TextStyle _bottomItemTextStyle(activeIndex, int i) => TextStyle(
        fontSize: 17,
        color: activeIndex == i ? Colors.black : Colors.grey,
      );

  void _onTap(int index) => setState(() {
        if (_onlyOneBenchmark && index == 1) {
          Navigator.of(context).pop();
        } else {
          _currentTableIndex = index;
        }
      });

  RecordsTable _filterNTimes(RecordsTable table) {
    filters.forEach((String filterName, bool shouldNotFilter) {
      if (!shouldNotFilter) table = table.filter(filterName);
    });
    return table;
  }
}

// ////////////////////////////////////////////////////////////////////////////

class _DropdownButton extends StatelessWidget {
  static const filterTextStyle = TextStyle(fontSize: 20);
  static const hintTextStyle = TextStyle(fontSize: 20);
  static const hintTitle = Text("Filter", style: hintTextStyle);

  final IMap<String, bool> filters;
  final void Function(String newFilter) updateFilters;

  _DropdownButton(this.filters, this.updateFilters);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: hintTitle,
      items: _items().toList(),
      onChanged: updateFilters,
    );
  }

  Iterable<DropdownMenuItem<String>> _items() {
    return filters.keys.map<DropdownMenuItem<String>>(
      (String filter) {
        return DropdownMenuItem<String>(
          value: filter,
          child: Row(
            children: <Widget>[
              _checkbox(filter),
              Text(filter, style: filterTextStyle),
            ],
          ),
        );
      },
    );
  }

  Checkbox _checkbox(String filter) => Checkbox(
        value: filters[filter],
        onChanged: (bool value) {
          updateFilters(filter);
        },
      );
}

// ////////////////////////////////////////////////////////////////////////////
