import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";

@immutable
class Config {
  final int runs, size;

  const Config({@required this.runs, @required this.size})
      : assert(runs != null && runs > 0),
        assert(size != null && size >= 0);

  @override
  String toString() => "Config: (runs: $runs, size: $size)";
}

@immutable
class StopwatchRecord {
  final String collectionName;

  /// The amount of time it took for the benchmark to run, typically in microseconds
  /// (µs).
  final double record;

  const StopwatchRecord({@required this.collectionName, @required this.record})
      : assert(collectionName != null && collectionName.length > 0),
        assert(record != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopwatchRecord && other.collectionName == collectionName && other.record == record;

  @override
  int get hashCode => collectionName.hashCode ^ record.hashCode;

  @override
  String toString() => "$runtimeType: (collectionName: $collectionName, record: $record)";
}

@immutable
class RecordsColumn {
  final List<StopwatchRecord> records;
  final String title;

  RecordsColumn.empty({String title = "Column"}) : this._(const <StopwatchRecord>[], title);

  const RecordsColumn._(this.records, this.title) : assert(title != null && title.length > 0);

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordsColumn &&
          runtimeType == other.runtimeType &&
          ListEquality().equals(other.records, records);

  @override
  int get hashCode => records.hashCode;

  @override
  String toString() => "$runtimeType: ${records.toString()}";
}

@immutable
class LeftLegend {
  final RecordsColumn _results;

  const LeftLegend({@required RecordsColumn results}) : _results = results;

  IList<String> get rows {
    IList<String> collections = const <String>["Collection"].lock;
    _results.records
        .forEach((StopwatchRecord record) => collections = collections.add(record.collectionName));
    return collections;
  }
}

@immutable
class RecordsTable {
  final RecordsColumn resultsColumn;
  final Config config;

  RecordsTable({@required this.resultsColumn, @required this.config});

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
  RecordsColumn get normalizedAgainstRuns =>
      _normalize(config.runs.toDouble(), "Time (${_mu}s) / Runs");

  /// Note that we are currently rounding off at 2 floating points.
  RecordsColumn get normalizedAgainstSize =>
      _normalize(config.size.toDouble(), "Time (${_mu}s) / Size");

  static const String _mu = "\u{03BC}";

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
      normalizedAgainstRuns,
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
      normalizedAgainstRuns,
      normalizedAgainstSize,
    ].lock;

    String newLine = leftLegend.rows[rowIndex + 1] + ",";
    numericColumns.forEach(
        (RecordsColumn column) => newLine += column.records[rowIndex].record.toString() + ",");

    return newLine.substring(0, newLine.length - 1) + "\n";
  }
}
