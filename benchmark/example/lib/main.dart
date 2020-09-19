import 'package:fast_immutable_collections_benchmarks/'
        'fast_immutable_collections_benchmarks.dart'
    show BenchmarkReporter, FullReporter, TableScoreEmitter;

void main() {
  final FullReporter fullReporter = FullReporter()..report();

  fullReporter.benchmarks
      .forEach((String name, BenchmarkReporter benchmarkReporter) {
    benchmarkReporter.tableScoreEmitters
        .forEach((TableScoreEmitter tableScoreEmitter) {
      print(name);
      print(tableScoreEmitter.table);
    });
  });
}
