import "package:benchmark_app/utils/benchmarks.dart";
import "package:benchmark_app/widgets/release_mode_warning.dart";
import "package:flutter/material.dart";

class MultiBenchmarkScreen extends StatelessWidget {
  final Type collectionType;

  const MultiBenchmarkScreen({required this.collectionType});

  @override
  Widget build(_) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose a benchmark to test"),
      ),
      body: ColoredBox(
        color: const Color(0xFFCCCCCC),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _benchmarks,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ReleaseModeWarning(),
    );
  }

  List<Widget> get _benchmarks => switch (collectionType) {
        List => listBenchmarks,
        Set => setBenchmarks,
        Map => mapBenchmarks,
        _ => throw UnimplementedError("No benchmarks for this collection type: $collectionType"),
      };
}
