import 'package:fast_immutable_collections_benchmarks/'
    'fast_immutable_collections_benchmarks.dart';

void main() {
  final FullReporter fullReporter = FullReporter()..report();

  fullReporter.benchmarks
      .forEach((String name, MultiBenchmarkReporter benchmarkReporter) {
    benchmarkReporter.tableScoreEmitters
        .forEach((TableScoreEmitter tableScoreEmitter) {
      print(name);
      print(tableScoreEmitter.tableAsString);
    });
  });
}
