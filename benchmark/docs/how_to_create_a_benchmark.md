# How to Create a Benchmark

Please do check out the [`benchmark_harness`][benchmark_harness] package before following this tutorial.


[benchmark_harness]: https://pub.dev/packages/benchmark_harness

## 1. Creating a Benchmark

1. Create a use case file under the `benchmark/case` folder.
1. Create your benchmarks extending from base cases &mdash; for example `ListBenchmarkBase`, which is in `benchmark/utils/list_benchmark_base.dart`. 
   - A simple example would be something like:
       ```dart
       class _SampleBenchmark extends ListBenchmarkBase {
         _SampleBenchmark({ScoreEmitter emitter}): super('Sample', emitter: emitter);

         @override
         void run() => null; // is going to run `n` times.
       }
       ```
1. Add a class with a static void method called `report`.
   1. Create a score emitter (`ScoreEmitter`).
       - You can access `benchmark/utils/table_score_emitter.dart` to get an idea of how to create a score emitter.
   1. Create the benchmark objects and `report` on them.
   1. Save the report with `saveReport`.
1. Add your benchmark use case class to the `benchmarks.dart` file's `main()` function.

## 2. Benchmark Dart Snippet(s)

> The snippet(s) below are only guaranteed to work on VS Code.

Since creating benchmarks can be very repetitive, having snippets can help save some time.

Add this to your `dart.json`, which holds your editor's user's snippets:

```json
"benchmark template": {
    "prefix": "benchx",
    "body": [
        "class _$1Benchmark extends $2BenchmarkBase {",
        "  _$1Benchmark({ScoreEmitter emitter}): super('${3:name on report}', emitter: emitter);",
        "",
        "  @override",
        "  void run() => $4;",
        "}"
    ]
}
```

The `name on report` parameter will be the name of the benchmark's row on the generated CSV table.
