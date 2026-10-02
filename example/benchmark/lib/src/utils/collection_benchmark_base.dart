// ignore_for_file: overridden_fields

import "dart:math";

import "package:benchmark_harness/benchmark_harness.dart";
import "package:meta/meta.dart";

import "records.dart";
import "table_score_emitter.dart";

abstract class MultiBenchmarkReporter<B extends CollectionBenchmarkBase> {
  final TableScoreEmitter emitter;

  @visibleForOverriding
  late List<B> benchmarks;

  MultiBenchmarkReporter({required this.emitter});

  void report() => benchmarks.forEach((B benchmark) => benchmark.report());

  void saveReports() => benchmarks.forEach((B benchmark) => benchmark.emitter.saveReport());
}

abstract class CollectionBenchmarkBase<T> extends BenchmarkBase {
  @override
  final TableScoreEmitter emitter;

  const CollectionBenchmarkBase({
    required String name,
    required this.emitter,
  }) : super(name);

  Config get config => emitter.config;

  /// This will be important for later checking if the resulting mutable
  /// collection processed by the benchmark is indeed the one we expected (TDD).
  @visibleForTesting
  @visibleForOverriding
  T toMutable();

  /// Benchmarks that mutate their collection must override this, so that each
  /// run gets a fresh copy of the initial collection. The copies are replenished
  /// by [measure] while the stopwatch is paused, so creating them is not measured.
  @visibleForOverriding
  FreshCopies<T>? get freshCopies => null;

  // Measures the score for the benchmark and returns it.
  @override
  double measure() {
    setup();
    // Warmup for at least 100ms. Discard result.
    _measureFor(warmup, 100);
    // Run the benchmark for at least 900ms.
    final result = _measureFor(exercise, 900);
    teardown();
    return result;
  }

  /// Same as [BenchmarkBase.measureFor], but pauses the stopwatch to replenish
  /// the [freshCopies], when needed.
  double _measureFor(void Function() f, int minimumMillis) {
    final int minimumMicros = minimumMillis * 1000;
    final FreshCopies<T>? copies = freshCopies;
    final Stopwatch watch = Stopwatch();
    int iterations = 2;
    while (true) {
      watch
        ..reset()
        ..start();
      for (int i = 0; i < iterations; i++) {
        if (copies != null && copies.isRunningLow) {
          watch.stop();
          copies.replenish();
          watch.start();
        }
        f();
      }
      watch.stop();
      final int elapsed = watch.elapsedMicroseconds;
      if (elapsed >= minimumMicros) return elapsed / iterations;
      iterations = (elapsed < 1000)
          ? iterations * 1000
          : (iterations * max(minimumMicros / elapsed, 1.5)).ceil();
    }
  }
}

/// Mutable collections are modified by the benchmarked operation, so each run
/// needs its own fresh copy of the initial collection. Creating those copies
/// during the run would distort the results, so they are created in advance.
class FreshCopies<T> {
  /// [BenchmarkBase.exercise] calls [BenchmarkBase.run] 10 times.
  static const int _runsPerExercise = 10;

  final T Function() _createCopy;
  final int _capacity;
  final List<T> _copies = [];

  FreshCopies(this._createCopy, {required int capacity})
      : _capacity = max(capacity, _runsPerExercise) {
    replenish();
  }

  /// Returns a fresh copy, never returned before.
  T next() => _copies.isEmpty ? _createCopy() : _copies.removeLast();

  bool get isRunningLow => _copies.length < _runsPerExercise;

  void replenish() {
    while (_copies.length < _capacity) _copies.add(_createCopy());
  }
}

abstract class ListBenchmarkBase extends CollectionBenchmarkBase<List<int>> {
  ListBenchmarkBase({
    required super.name,
    required super.emitter,
  });

  static List<int> getDummyGeneratedList({required int size}) =>
      List<int>.generate(size, (int index) => index);

  @visibleForTesting
  @visibleForOverriding
  @override
  List<int> toMutable();

  int innerRuns() => min(1000, max(1, config.size ~/ 10));
}

abstract class SetBenchmarkBase extends CollectionBenchmarkBase<Set<int>> {
  SetBenchmarkBase({
    required super.name,
    required super.emitter,
  });

  static Set<int> getDummyGeneratedSet({required int size}) =>
      Set<int>.of(ListBenchmarkBase.getDummyGeneratedList(size: size));

  @visibleForTesting
  @visibleForOverriding
  @override
  Set<int> toMutable();

  int innerRuns() => min(1000, max(1, config.size ~/ 10));
}

abstract class MapBenchmarkBase extends CollectionBenchmarkBase<Map<String, int>> {
  MapBenchmarkBase({
    required super.name,
    required super.emitter,
  });

  static Map<String, int> getDummyGeneratedMap({required int size}) =>
      Map<String, int>.fromEntries(List<MapEntry<String, int>>.generate(
          size, (int index) => MapEntry<String, int>(index.toString(), index)));

  @visibleForTesting
  @visibleForOverriding
  @override
  Map<String, int> toMutable();

  int innerRuns() => min(1000, max(1, config.size ~/ 10));
}
