import "package:charts_flutter/flutter.dart" as charts;
import "package:flutter/material.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

class BarChart extends StatelessWidget {
  final RecordsTable recordsTable;

  const BarChart({@required this.recordsTable});

  List<StopwatchRecord> get _normalizedAgainstMax =>
      recordsTable.normalizedAgainstMax.records.toList();

  List<charts.Series<StopwatchRecord, String>> get _seriesList => [
        charts.Series<StopwatchRecord, String>(
          id: "Normalized Against\nthe Maximum Value",
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (StopwatchRecord record, _) => record.collectionName,
          measureFn: (StopwatchRecord record, _) => record.record,
          data: _normalizedAgainstMax,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _seriesList,
      vertical: false,
      animate: true,
      animationDuration: Duration(seconds: 1, milliseconds: 250),
      behaviors: <charts.ChartBehavior>[
        charts.SeriesLegend(position: charts.BehaviorPosition.top),
      ],
    );
  }
}
