import 'dart:io';

import "package:charts_flutter/flutter.dart" as charts;
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

void main() => runApp(BenchmarkApp());

class BenchmarkApp extends StatelessWidget {
  final ListEmptyBenchmark listEmptyBenchmark =
      ListEmptyBenchmark(configs: const [Config(runs: 100, size: 100)]);

  BenchmarkApp() {
    listEmptyBenchmark.report();
  }

  RecordsTable get table =>
      (listEmptyBenchmark.benchmarks.first.emitter as TableScoreEmitter).table;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight * 1.3,
          title: Text(
            "Fast Immutable Collections Benchmarks",
            maxLines: 2,
            style: TextStyle(color: Colors.white, height: 1.3),
          ),
        ),
        body: Container(
          child: BarChart(recordsTable: table),
        ),
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  final RecordsTable recordsTable;

  const BarChart({@required this.recordsTable});

  List<StopwatchRecord> get _data => recordsTable.normalizedAgainstMax.records.toList();

  List<charts.Series<StopwatchRecord, String>> get _seriesList => [
        charts.Series<StopwatchRecord, String>(
          id: "Benchmark",
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (StopwatchRecord record, _) => record.collectionName,
          measureFn: (StopwatchRecord record, _) => record.record,
          data: _data,
        )
      ];

  // @override
  // Widget build(BuildContext context) {
  //   return charts.BarChart(_seriesList, animate: false);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFCCCCCC),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  BenchWidget(description: "Add", code: add_code, run: add_run),
                  BenchWidget(description: "AddAll", code: add_all_code, run: add_all_run),
                  BenchWidget(description: "Remove", code: {}, run: () {}),
                  BenchWidget(description: "RemoveAll", code: {}, run: () {}),
                  BenchWidget(description: "Get", code: {}, run: () {}),
                  BenchWidget(description: "Empty", code: {}, run: () {}),
                  //
                ],
              ),
            ),
          ),
          //
          if (!kReleaseMode) _releaseModeWarning(),
        ],
      ),
    );
  }

  Container _releaseModeWarning() => Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        width: double.infinity,
        color: Colors.black,
        child: Text(
          "Please run this in release mode!",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      );
}

class BenchWidget extends StatefulWidget {
  final String description;
  final Map<String, String> code;
  final VoidCallback run;

  BenchWidget({
    this.description,
    this.code,
    this.run,
  });

  @override
  _BenchWidgetState createState() => _BenchWidgetState();
}

class _BenchWidgetState extends State<BenchWidget> {
  //
  bool hasResults;

  @override
  void initState() {
    super.initState();
    hasResults = false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.description,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _button(
                  label: "Run",
                  onPressed: widget.run,
                ),
                SizedBox(width: 12),
                _button(
                  label: "Results",
                  onPressed: hasResults ? () => print("View results!") : null,
                ),
                SizedBox(width: 12),
                _button(
                    label: "Code",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return CodeScreen(widget.description, widget.code);
                        }),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CodeScreen extends StatelessWidget {
  final String description;
  final Map<String, String> code;

  CodeScreen(this.description, this.code);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
        title: Text(
          "Code: $description",
          style: TextStyle(color: Colors.white, height: 1.3),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (MapEntry<String, String> entry in code.entries) _code(entry.key, entry.value)
                ],
              ),
            ),
          ),
          Container(width: double.infinity, height: 1.0, color: Colors.black),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _button(label: "OK", onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _code(String title, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 8.0, bottom: 20),
          child: Text(code,
              style: TextStyle(
                fontFamily: Platform.isIOS ? "Courier" : "monospace",
                fontSize: 15,
                height: 1.2,
              )),
        ),
        Container(width: double.infinity, height: 1.0, color: Colors.grey),
      ],
    );
  }
}

Expanded _button({String label, VoidCallback onPressed}) {
  return Expanded(
    child: RaisedButton(
      color: Colors.blue,
      disabledColor: Colors.blue.withOpacity(0.4),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 17),
      ),
    ),
  );
}

void add_run() => print("RUN add_code!");

Map<String, String> add_code = {
  "List (mutable)": "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++) _list.add(i);",
  "IList": "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++) _result = _result.add(i);",
  "KtList":
      "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++) _result = _result.plusElement(i);",
  "BuiltList (with rebuild)":
      "for (int i = 0; i < ${ListAddBenchmark.innerRuns}; i++) _result = _result.rebuild((ListBuilder<int> listBuilder) => listBuilder.add(i));",
  "BuiltList (with ListBuilder)":
      "for (int i = 0; i < ListAddBenchmark.innerRuns; i++) listBuilder.add(i); _result = listBuilder.build();",
};

void add_all_run() => print("RUN add_all_code!");

Map<String, String> add_all_code = {};
