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
  Widget build(_) {
    return charts.BarChart(
      _seriesList,
      animate: true,
      animationDuration: const Duration(milliseconds: 100),
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      behaviors: <charts.ChartBehavior>[
        charts.SeriesLegend(position: charts.BehaviorPosition.top),
      ],
    );
  }
}
