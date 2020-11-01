import "package:charts_flutter/flutter.dart" as charts;
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
          title: Text("Benchmark Report"),
        ),
        body: Container(child: BarChart(recordsTable: table)),
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

  @override
  Widget build(BuildContext context) => charts.BarChart(_seriesList, animate: false);
}
