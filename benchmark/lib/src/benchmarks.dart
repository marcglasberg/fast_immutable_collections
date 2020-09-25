import 'utils/collection_full_reporter.dart';

/// Run the benchmarks with, for example &mdash; from the top of the project
/// &mdash;: `dart benchmark/lib/src/benchmarks.dart`
void main() {
  ListFullReporter()..report()..save();
  SetFullReporter()..report()..save();
}