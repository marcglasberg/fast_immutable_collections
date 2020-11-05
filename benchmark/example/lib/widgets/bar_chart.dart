import "package:charts_flutter/flutter.dart" as charts;
import "package:flutter/material.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

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
