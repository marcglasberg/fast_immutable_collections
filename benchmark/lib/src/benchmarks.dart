import "utils/collection_full_reporter.dart";

/// Run the benchmarks with, for example &mdash; from the top of the project
/// &mdash;: `dart benchmark/lib/src/benchmarks.dart`
/// The complete benchmark run should take around 7-10 min on a good computer.
void main() {
  ListFullReporter()
    ..report()
    ..save();
  SetFullReporter()
    ..report()
    ..save();
}
