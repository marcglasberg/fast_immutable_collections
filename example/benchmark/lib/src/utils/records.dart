import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";

class Config {
  final int size;

  Config({required this.size}) : assert(size >= 0);

  @override
  String toString() => "Config: (size: $size)";
}

class StopwatchRecord {
  final String collectionName;

  /// The amount of time it took for the benchmark to run, typically in microseconds
  /// (µs).
  final double record;

  StopwatchRecord({required this.collectionName, required this.record})
      : assert(collectionName.isNotEmpty);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopwatchRecord && other.collectionName == collectionName && other.record == record;

  @override
  int get hashCode => collectionName.hashCode ^ record.hashCode;

  @override
  String toString() => "$runtimeType: (collectionName: $collectionName, record: $record)";
}

class RecordsColumn {
  final List<StopwatchRecord> records;
  final String title;

  RecordsColumn.empty({String title = "Column"}) : this._(const <StopwatchRecord>[], title);

  const RecordsColumn._(this.records, this.title) : assert(title.length > 0);

  RecordsColumn operator +(StopwatchRecord stopwatchRecord) =>
      RecordsColumn._(List.of([...records, stopwatchRecord]), title);

  double get max {
    double max = 0;
    records.forEach((StopwatchRecord record) {
      if (record.record > max) max = record.record;
    });
    return max;
  }

  double get min {
    double min = double.infinity;
    records.forEach((StopwatchRecord record) {
      if (record.record < min) min = record.record;
    });
    return min;
  }

  /// Finding the mutable record is linked to having the word *mutable* — it doesn't really
  /// matter if it's uppercase or not — somewhere on the row's name.
  double get mutableRecord => records
      .where((StopwatchRecord record) => record.collectionName.toLowerCase().contains("mutable"))
      .first
      .record;

  List<String> get rowNames {
    final List<String> rowNames = [];
    records.forEach((StopwatchRecord record) => rowNames.add(record.collectionName));
    return rowNames;
  }

  RecordsColumn filter(String? collectionName) {
    if (collectionName != null) {
      final List<StopwatchRecord> recordsCopy = List.of(records);
      recordsCopy.removeWhere((StopwatchRecord record) => record.collectionName == collectionName);
      return RecordsColumn._(recordsCopy, title);
    } else {
      return this;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordsColumn &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(other.records, records);

  @override
  int get hashCode => records.hashCode;

  @override
  String toString() => "$runtimeType: $records";
}

@immutable
class LeftLegend {
  final RecordsColumn _results;

  const LeftLegend({required RecordsColumn results}) : _results = results;

  IList<String> get rows {
    IList<String> collections = const <String>["Collection"].lock;
    _results.records
        .forEach((StopwatchRecord record) => collections = collections.add(record.collectionName));
    return collections;
  }
}

class RecordsTable {
  final RecordsColumn resultsColumn;
  final Config config;

  RecordsTable({required this.resultsColumn, required this.config});

  LeftLegend get leftLegend => LeftLegend(results: resultsColumn);

  RecordsColumn get normalizedAgainstMax => _normalize(resultsColumn.max, "x Max Time");

  RecordsColumn _normalize(double norm, String title) {
    RecordsColumn normalizedCol = RecordsColumn.empty(title: title);
    resultsColumn.records.forEach((StopwatchRecord record) {
      normalizedCol += StopwatchRecord(
        collectionName: record.collectionName,
        record: _round(record.record / norm),
      );
    });
    return normalizedCol;
  }

  double _round(double score) => double.parse(score.toStringAsFixed(2));

  RecordsColumn get normalizedAgainstMin => _normalize(resultsColumn.min, "x Min Time");

  RecordsColumn get normalizedAgainstMutable =>
      _normalize(resultsColumn.mutableRecord, "x Mutable Time");

  /// Note that we are currently rounding off at 2 floating points.
  RecordsColumn get normalizedAgainstSize => _normalize(config.size.toDouble(), "Time (μs) / Size");

  List<String> get rowNames => resultsColumn.rowNames;

  RecordsTable filter(String collectionName) =>
      RecordsTable(resultsColumn: resultsColumn.filter(collectionName), config: config);

  @override
  String toString() {
    String tableAsString = _header();

    for (int rowIndex = 0; rowIndex < resultsColumn.records.length; rowIndex++)
      tableAsString += _newRow(rowIndex);

    return tableAsString;
  }

  String _header() {
    final IList<RecordsColumn> numericColumns = [
      resultsColumn,
      normalizedAgainstMax,
      normalizedAgainstMin,
      normalizedAgainstMutable,
      normalizedAgainstSize,
    ].lock;

    String header = leftLegend.rows.first + ",";
    numericColumns.forEach((RecordsColumn column) => header += column.title + ",");

    return header.substring(0, header.length - 1) + "\n";
  }

  // Currently inefficient. But no one should care much, the table will be very small anyway.
  String _newRow(int rowIndex) {
    final IList<RecordsColumn> numericColumns = [
      resultsColumn,
      normalizedAgainstMax,
      normalizedAgainstMin,
      normalizedAgainstMutable,
      normalizedAgainstSize,
    ].lock;

    String newLine = leftLegend.rows[rowIndex + 1] + ",";
    numericColumns.forEach(
        (RecordsColumn column) => newLine += column.records[rowIndex].record.toString() + ",");

    return newLine.substring(0, newLine.length - 1) + "\n";
  }
}
