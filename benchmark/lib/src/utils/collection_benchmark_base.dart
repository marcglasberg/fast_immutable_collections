import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:meta/meta.dart';

import 'config.dart';

abstract class CollectionBenchmarkBase<T> extends BenchmarkBase {
  final Config config;

  const CollectionBenchmarkBase({
    @required String name,
    @required this.config,
    @required ScoreEmitter emitter,
  }) : super(name, emitter: emitter);

  @override
  void exercise() {
    for (int i = 0; i < config.runs; i++) run();
  }

  /// This will be important for later checking if the resulting mutable
  /// collection processed by the benchmark is indeed the one we expected (TDD).
  @visibleForTesting
  @visibleForOverriding
  T toMutable();

  /// If one of the parameters is not passed, then the current one is used.
  /// This method will be important later on for reconfiguring the benchmark in
  /// the [MultiBenchmarkReporter]'s [configure] method.
  CollectionBenchmarkBase reconfigure(
      {Config newConfig, ScoreEmitter newEmitter});
}

abstract class ListBenchmarkBase extends CollectionBenchmarkBase {
  const ListBenchmarkBase({
    @required String name,
    @required Config config,
    @required ScoreEmitter emitter,
  }) : super(name: name, config: config, emitter: emitter);

  static final List<int> dummyStaticList =
      List<int>.generate(10000, (int index) => index);

  static List<int> getDummyGeneratedList({int size = 10000}) =>
      List<int>.generate(size, (int index) => index);

  @visibleForTesting
  @visibleForOverriding
  @override
  List<int> toMutable();
}

abstract class SetBenchmarkBase extends CollectionBenchmarkBase {
  const SetBenchmarkBase({
    @required String name,
    @required Config config,
    @required ScoreEmitter emitter,
  }) : super(name: name, config: config, emitter: emitter);

  @visibleForTesting
  @visibleForOverriding
  @override
  Set<int> toMutable();
}
