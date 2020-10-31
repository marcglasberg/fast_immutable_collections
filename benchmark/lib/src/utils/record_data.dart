import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";

import "config.dart";

@immutable
class StopwatchRecord {
  final String collectionName;

  /// The amount of time it took for the benchmark to run, typically in microseconds.
  final double record;

  const StopwatchRecord({@required this.collectionName, @required this.record})
      : assert(collectionName != null && collectionName.length > 0),
        assert(record != null && record > 0);

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
  /// Not that the records are of type [IList] already.
  final IList<StopwatchRecord> records;
  final String title;

  RecordsColumn.empty({String title = "Column"}) : this._(const <StopwatchRecord>[].lock, title);

  const RecordsColumn._(this.records, this.title) : assert(title != null && title.length > 0);

  RecordsColumn operator +(StopwatchRecord stopwatchRecord) =>
      RecordsColumn._(records.add(stopwatchRecord), title);

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

  /// Finding the mutable record is linked to having the word *mutable* somewhere on the row's name.
  double get mutableRecord => records
      .where((StopwatchRecord record) => record.collectionName.toLowerCase().contains("mutable"))
      .first
      .record;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RecordsColumn && other.records == records;

  @override
  int get hashCode => records.hashCode;

  @override
  String toString() => "$runtimeType: ${records.toString()}";
}

@immutable
class LeftLegend {
  final RecordsColumn _results;

  LeftLegend({@required RecordsColumn results}) : _results = results;

  IList<String> get rows {
    IList<String> collections = const <String>[].lock;
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

  RecordsColumn get normalizedAgainstMax => _normalize(resultsColumn.max);

  RecordsColumn _normalize(double norm) {
    RecordsColumn normalizedCol = RecordsColumn.empty();
    resultsColumn.records.forEach((StopwatchRecord record) {
      normalizedCol += StopwatchRecord(
        collectionName: record.collectionName,
        record: _round(record.record / norm),
      );
    });
    return normalizedCol;
  }

  double _round(double score) => double.parse(score.toStringAsFixed(2));

  RecordsColumn get normalizedAgainstMin => _normalize(resultsColumn.min);

  RecordsColumn get normalizedAgainstMutable => _normalize(resultsColumn.mutableRecord);

  /// Note that we are currently rounding off at 2 floating points.
  RecordsColumn get normalizedAgainstRuns => _normalize(config.runs.toDouble());

  /// Note that we are currently rounding off at 2 floating points.
  RecordsColumn get normalizedAgainstSize => _normalize(config.size.toDouble());
}
