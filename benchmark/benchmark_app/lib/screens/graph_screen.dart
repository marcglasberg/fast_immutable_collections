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

  List<InkWell> bottomItems(activeIndex) {
    final List<InkWell> bottomItems = <InkWell>[
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

    if (bottomItems.length == 1) {
      onlyOneBenchmark = true;
      bottomItems.add(
        InkWell(
          onTap: () => onTap(1),
          child: Container(
            child: const Icon(Icons.arrow_back, color: Colors.grey),
          ),
        ),
      );
    }
    return bottomItems;
  }

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
  static const hintTextStyle = TextStyle(fontSize: 20);
  static const hintTitle = Text("Filter", style: hintTextStyle);

  final IMap<String, bool> filters;
  final void Function(String newFilter) updateFilters;

  _DropdownButton(this.filters, this.updateFilters);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red,
        child: GestureDetector(
          onTap: () => _showDialog(context),
          child: Text("Filter"),
        ));
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Iterable<DropdownMenuItem<String>> items() {
    return filters.keys.map<DropdownMenuItem<String>>(
      (String filter) {
        return DropdownMenuItem<String>(
          value: filter,
          child: GestureDetector(
            onTap: null,
            // onTap: () {
            //   print('_DropdownButton.items --------------------------------');
            // },
            child: IgnorePointer(
              child: Container(
                color: Colors.red,
                child: Row(
                  children: <Widget>[
                    checkbox(filter),
                    Text(filter, style: filterTextStyle),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Checkbox checkbox(String filter) => Checkbox(
        value: filters[filter],
        onChanged: (bool value) {
          updateFilters(filter);
        },
      );
}
// class _DropdownButton extends StatelessWidget {
//   static const filterTextStyle = TextStyle(fontSize: 20);
//   static const hintTextStyle = TextStyle(fontSize: 20);
//   static const hintTitle = Text("Filter", style: hintTextStyle);
//
//   final IMap<String, bool> filters;
//   final void Function(String newFilter) updateFilters;
//
//   _DropdownButton(this.filters, this.updateFilters);
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       hint: hintTitle,
//       items: items().toList(),
//       onChanged: updateFilters,
//     );
//   }
//
//   Iterable<DropdownMenuItem<String>> items() {
//     return filters.keys.map<DropdownMenuItem<String>>(
//       (String filter) {
//         return DropdownMenuItem<String>(
//           value: filter,
//           child: GestureDetector(
//               onTap:null,
//             // onTap: () {
//             //   print('_DropdownButton.items --------------------------------');
//             // },
//             child: IgnorePointer(
//               child: Container(
//                 color: Colors.red,
//                 child: Row(
//                   children: <Widget>[
//                     checkbox(filter),
//                     Text(filter, style: filterTextStyle),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Checkbox checkbox(String filter) => Checkbox(
//         value: filters[filter],
//         onChanged: (bool value) {
//           updateFilters(filter);
//         },
//       );
// }

// ////////////////////////////////////////////////////////////////////////////
