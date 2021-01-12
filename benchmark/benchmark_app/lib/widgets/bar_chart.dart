import "package:charts_flutter/flutter.dart" as charts;
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

// ////////////////////////////////////////////////////////////////////////////

class BarChart extends StatelessWidget {
  final RecordsTable recordsTable;

  const BarChart({@required this.recordsTable});

  List<charts.Series<StopwatchRecord, String>> _seriesList() => [
        charts.Series<StopwatchRecord, String>(
          id: "Normalized Against\nthe Maximum Value",
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (StopwatchRecord record, _) => record.collectionName,
          measureFn: (StopwatchRecord record, _) => record.record,
          data: _normalizedAgainstMaxPrefixedByAbs(recordsTable),
          displayName: "Xaxaxaxa",
        ),
      ];

  List<StopwatchRecord> _normalizedAgainstMaxPrefixedByAbs(RecordsTable table) {
    List<StopwatchRecord> records = [];
    RecordsColumn resultsColumn = table.resultsColumn;
    RecordsColumn normalizedAgainstMaxColumn = table.normalizedAgainstMax;

    for (int i = 0; i < resultsColumn.records.length; i++) {
      records.add(_stopwatchRecord(resultsColumn, i, normalizedAgainstMaxColumn));
    }
    return records;
  }

  StopwatchRecord _stopwatchRecord(
    RecordsColumn resultsColumn,
    int i,
    RecordsColumn normalizedAgainstMaxColumn,
  ) {
    final NumberFormat formatter = NumberFormat("#,##0", "en_US");
    final String millis = formatter.format(resultsColumn.records[i].record.round());
    final String collectionName = normalizedAgainstMaxColumn.records[i].collectionName;

    return StopwatchRecord(
      collectionName: "$millis μs | $collectionName",
      record: normalizedAgainstMaxColumn.records[i].record,
    );
  }

  @override
  Widget build(_) {
    return charts.BarChart(
      _seriesList(),
      animate: true,
      animationDuration: const Duration(milliseconds: 100),
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
    );
  }
}

// ////////////////////////////////////////////////////////////////////////////
