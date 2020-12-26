import "package:charts_flutter/flutter.dart" as charts;
import "package:flutter/material.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

class BarChart extends StatelessWidget {
  final RecordsTable recordsTable;

  const BarChart({@required this.recordsTable});

  List<charts.Series<StopwatchRecord, String>> get _seriesList => [
        charts.Series<StopwatchRecord, String>(
          id: "Normalized Against\nthe Maximum Value",
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (StopwatchRecord record, _) => record.collectionName,
          measureFn: (StopwatchRecord record, _) => record.record,
          data: _normalizedAgainstMaxPrefixedByAbs(recordsTable),
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

List<StopwatchRecord> _normalizedAgainstMaxPrefixedByAbs(RecordsTable table) {
  final List<StopwatchRecord> records = [];
  final RecordsColumn resultsColumn = table.resultsColumn;
  final RecordsColumn normalizedAgainstMaxColumn = table.normalizedAgainstMax;
  for (int i = 0; i < resultsColumn.records.length; i++) {
    final StopwatchRecord stopwatchRecord = StopwatchRecord(
      collectionName: resultsColumn.records[i].record.round().toString() +
          " μs | " +
          normalizedAgainstMaxColumn.records[i].collectionName,
      record: normalizedAgainstMaxColumn.records[i].record,
    );
    records.add(stopwatchRecord);
  }
  return records;
}

class StackedBarChart extends StatelessWidget {
  final List<RecordsTable> recordsTables;

  const StackedBarChart({@required this.recordsTables});

  List<charts.Series<StopwatchRecord, String>> get _seriesList => [
        for (final RecordsTable recordsTable in recordsTables)
          charts.Series<StopwatchRecord, String>(
            id: "${recordsTable.config.size}",
            domainFn: (StopwatchRecord record, _) => record.collectionName,
            measureFn: (StopwatchRecord record, _) => record.record,
            data: _normalizedAgainstMaxPrefixedByAbs(recordsTable),
          )
      ];

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _seriesList,
      animate: true,
      vertical: false,
      animationDuration: const Duration(milliseconds: 100),
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      behaviors: <charts.ChartBehavior>[
        charts.SeriesLegend(position: charts.BehaviorPosition.top),
      ],
    );
  }
}
