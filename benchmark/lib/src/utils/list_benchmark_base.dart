import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:meta/meta.dart';

import 'table_score_emitter.dart';

abstract class ListBenchmarkBase extends BenchmarkBase {
  final int runs, size;

  const ListBenchmarkBase(
    String name, {
    @required this.runs,
    @required this.size,
    @required ScoreEmitter emitter,
  })  : assert(runs != null && runs > 0),
        assert(size != null && size >= 0),
        super(name, emitter: emitter);

  static final List<int> dummyStaticList =
      List<int>.generate(10000, (int index) => index);

  static List<int> getDummyGeneratedList({int length = 10000}) =>
      List<int>.generate(length, (int index) => index);

  @override
  void exercise() {
    for (int i = 0; i < runs; i++) run();
  }

  /// This will be important for later checking if the resulting list processed
  /// by the benchmark is indeed the one we expected (TDD).
  @visibleForTesting
  @visibleForOverriding
  List<int> toList();
}

abstract class ListBenchmarkBase2 extends BenchmarkBase {
  final Config config;

  const ListBenchmarkBase2({
    @required String name,
    @required this.config,
    @required ScoreEmitter emitter,
  }) : super(name, emitter: emitter);

  static final List<int> dummyStaticList =
      List<int>.generate(10000, (int index) => index);

  static List<int> getDummyGeneratedList({int size = 10000}) =>
      List<int>.generate(size, (int index) => index);

  @override
  void exercise() {
    for (int i = 0; i < config.runs; i++) run();
  }

  /// This will be important for later checking if the resulting list processed
  /// by the benchmark is indeed the one we expected (TDD).
  @visibleForTesting
  @visibleForOverriding
  List<int> toList();

  /// If one of the parameters is not passed, then the current one is used.
  /// This method will be important later on for reconfiguring the benchmark in
  /// the [MultiBenchmarkReporter]'s [.configure] method.
  ListBenchmarkBase2 reconfigure({Config newConfig, ScoreEmitter newEmitter});
}

class Config {
  final int runs, size;

  const Config({@required this.runs, @required this.size})
      : assert(runs != null && runs > 0),
        assert(size != null && size >= 0);
}
