import 'package:fast_immutable_collections_benchmarks/'
        'fast_immutable_collections_benchmarks.dart'
    show AddBenchmark, EmptyBenchmark;

void main() {
  final EmptyBenchmark emptyBenchmark = EmptyBenchmark()..report();
  final AddBenchmark addBenchmark = AddBenchmark()..report();

  emptyBenchmark.tableScoreEmitters.forEach((element) => print(element.table));
  addBenchmark.tableScoreEmitters.forEach((element) => print(element.table));
}
