import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:flutter/material.dart";

/// Horizontal bars, one per collection, with lengths normalized against the
/// maximum value. Each bar is labeled with its absolute time in microseconds.
class BarChart extends StatelessWidget {
  final RecordsTable recordsTable;

  const BarChart({required this.recordsTable});

  List<StopwatchRecord> _normalizedAgainstMaxPrefixedByAbs(RecordsTable table) {
    final List<StopwatchRecord> records = [];
    final RecordsColumn resultsColumn = table.resultsColumn;
    final RecordsColumn normalizedAgainstMaxColumn = table.normalizedAgainstMax;

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
    final String millis = resultsColumn.records[i].record.round().toString();
    final String collectionName = normalizedAgainstMaxColumn.records[i].collectionName;

    return StopwatchRecord(
      collectionName: "$millis μs | $collectionName",
      record: normalizedAgainstMaxColumn.records[i].record,
    );
  }

  @override
  Widget build(_) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final StopwatchRecord record in _normalizedAgainstMaxPrefixedByAbs(recordsTable))
          _Bar(record),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final StopwatchRecord record;

  const _Bar(this.record);

  @override
  Widget build(_) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(record.collectionName, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 100),
            widthFactor: record.record.isFinite ? record.record.clamp(0.005, 1.0) : 0.005,
            alignment: Alignment.centerLeft,
            child: const SizedBox(height: 24, child: ColoredBox(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
