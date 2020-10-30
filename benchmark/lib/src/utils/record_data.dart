import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";

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

  RecordsColumn.empty() : this._(const <StopwatchRecord>[].lock);

  const RecordsColumn._(this.records);

  RecordsColumn operator +(StopwatchRecord stopwatchRecord) =>
      RecordsColumn._(records.add(stopwatchRecord));

  double get max {
    double max = 0;
    records.forEach((StopwatchRecord record) {
      if (record.record > max) max = record.record;
    });
    return max;
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
class RecordsTable {}
