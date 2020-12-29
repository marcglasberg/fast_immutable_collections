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

  int currentTableIndex;

  /// We need to add an artificial button to the bottom bar if there's
  /// only one benchmark, since it requires at least 2 items.
  bool onlyOneBenchmark;

  IMap<String, bool> filters;

  RecordsTable get currentTable => currentTableIndex >= widget.tables.length
      ? widget.tables.last
      : widget.tables[currentTableIndex];

  @override
  void initState() {
    onlyOneBenchmark = false;
    currentTableIndex = 0;

    filters = <String, bool>{}.lock;
    currentTable.rowNames.forEach((String rowName) => filters = filters.add(rowName, true));

    super.initState();
  }

  @override
  Widget build(_) => Scaffold(
        appBar: AppBar(title: title()),
        body: body(),
        bottomNavigationBar: bottomNavigationBar(),
      );

  Text title() => Text("${widget.title} Benchmark Graph Results");

  Container body() {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: ListView(
        children: [
          Center(child: _DropdownButton(filters, updateFilters)),
          Container(
            height: 480,
            child: BarChart(recordsTable: filterNTimes(currentTable)),
          ),
        ],
      ),
    );
  }

  Container bottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.blue,
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: bottomItems(currentTableIndex),
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

  List<InkWell> bottomItems(activeIndex) => <InkWell>[
        for (int i = 0; i < widget.tables.length; i++)
          InkWell(
            onTap: () => onTap(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                "Size\n${formatter.format(widget.tables[i].config.size)}",
                style: bottomItemTextStyle(activeIndex, i),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ];

  TextStyle bottomItemTextStyle(activeIndex, int i) => TextStyle(
        fontSize: 17,
        color: activeIndex == i ? Colors.white : Colors.black,
      );

  void onTap(int index) => setState(() {
        if (onlyOneBenchmark && index == 1) {
          Navigator.of(context).pop();
        } else {
          currentTableIndex = index;
        }
      });

  RecordsTable filterNTimes(RecordsTable table) {
    filters.forEach((String filterName, bool shouldNotFilter) {
      if (!shouldNotFilter) table = table.filter(filterName);
    });
    return table;
  }
}

// ////////////////////////////////////////////////////////////////////////////

class _DropdownButton extends StatelessWidget {
  static const filterTextStyle = TextStyle(fontSize: 20);

  final IMap<String, bool> filters;
  final void Function(String newFilter) updateFilters;

  _DropdownButton(this.filters, this.updateFilters);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDialog(context),
      child: Container(
        margin: EdgeInsets.only(top: 8, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Filters", style: TextStyle(fontSize: 20)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Show:"),
          content: SingleChildScrollView(
            child: ListBody(
              children: items(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK", style: TextStyle(fontSize: 21)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> items() {
    return filters.keys.map<Widget>(
      (String filter) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              updateFilters(filter);
            },
            child: Container(
              child: Row(
                children: [
                  checkbox(filter),
                  Text(filter, style: filterTextStyle),
                ],
              ),
            ),
          ),
        );
      },
    ).toList();
  }

  GestureDetector checkbox(String filter) => GestureDetector(
        onTap: () {
          updateFilters(filter);
          print("${filters[filter]}");
        },
        child: Checkbox(
          value: filters.get(filter),
          onChanged: (bool value) {
            updateFilters(filter);
          },
        ),
      );
}

// ////////////////////////////////////////////////////////////////////////////
