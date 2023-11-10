import "package:benchmark_app/widgets/bar_chart.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:flutter/material.dart";

class GraphScreen extends StatefulWidget {
  final String title;
  final List<RecordsTable>? tables;

  const GraphScreen({
    required this.title,
    required this.tables,
  });

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  static final BoxDecoration bottomDecoration = BoxDecoration(
    color: Colors.blue,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
  );

  late int currentTableIndex;

  late Map<String, bool> filters;

  RecordsTable get currentTable => currentTableIndex >= widget.tables!.length
      ? widget.tables!.last
      : widget.tables![currentTableIndex];

  @override
  void initState() {
    currentTableIndex = 0;
    filters = {};
    currentTable.rowNames.forEach((String rowName) => filters[rowName] = true);

    super.initState();
  }

  @override
  Widget build(_) {
    return Scaffold(
      appBar: AppBar(title: title()),
      body: body(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Text title() => Text(widget.title);

  Container body() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView(
        children: [
          _DropdownButton(showFilterDialog),
          SizedBox(
            height: 460,
            child: BarChart(recordsTable: filterNTimes(currentTable)),
          ),
        ],
      ),
    );
  }

  Container bottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      decoration: bottomDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bottomItems(currentTableIndex),
          ),
        ],
      ),
    );
  }

  void updateFilters(String newFilter) {
    setState(() {
      filters[newFilter] = !filters[newFilter]!;
    });
  }

  List<InkWell> bottomItems(int activeIndex) {
    return <InkWell>[
      for (int i = 0; i < widget.tables!.length; i++)
        InkWell(
          onTap: () => onTap(i),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              "Size\n${widget.tables![i].config.size}",
              style: bottomItemTextStyle(activeIndex, i),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ];
  }

  TextStyle bottomItemTextStyle(int activeIndex, int i) => TextStyle(
        fontSize: 17,
        color: activeIndex == i ? Colors.white : Colors.black,
      );

  void onTap(int index) {
    setState(() {
      currentTableIndex = index;
    });
  }

  RecordsTable filterNTimes(RecordsTable table) {
    filters.forEach((String filterName, bool shouldNotFilter) {
      if (!shouldNotFilter) table = table.filter(filterName);
    });
    return table;
  }

  Future<void> showFilterDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return _FilterDialog(filters, updateFilters);
      },
    );
  }
}

class _DropdownButton extends StatelessWidget {
  //
  final VoidCallback onTap;

  const _DropdownButton(this.onTap);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 16, left: 8, right: 8),
          child: const ColoredBox(
            color: Color(0x22000000),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Filters", style: TextStyle(fontSize: 20)),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterDialog extends StatefulWidget {
  //
  final Map<String, bool> filters;
  final void Function(String newFilter) updateFilters;

  const _FilterDialog(this.filters, this.updateFilters);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  //
  Map<String, bool> get filters => widget.filters;

  static const filterTextStyle = TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Show:"),
      content: SingleChildScrollView(
        child: ListBody(
          children: items(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK", style: TextStyle(fontSize: 21)),
        ),
      ],
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
              setState(() {
                widget.updateFilters(filter);
              });
            },
            child: Row(
              children: <Widget>[
                _checkbox(filter),
                Text(filter, style: filterTextStyle),
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  Checkbox _checkbox(String filter) {
    return Checkbox(
      value: filters[filter],
      onChanged: (bool? value) {
        setState(() {
          widget.updateFilters(filter);
        });
      },
    );
  }
}
