import "package:benchmark_app/screens/collection_choice_screen.dart";
import "package:benchmark_app/widgets/release_mode_warning.dart";
import "package:flutter/material.dart";

void main() => runApp(const BenchmarkApp());

class BenchmarkApp extends StatelessWidget {
  const BenchmarkApp();

  @override
  Widget build(_) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight * 1.3,
          title: const Text(
            "Fast Immutable Collections (FIC) Benchmarks",
            maxLines: 2,
            style: TextStyle(color: Colors.white, height: 1.3),
          ),
        ),
        body: const CollectionChoiceScreen(),
        bottomNavigationBar: const ReleaseModeWarning(),
      ),
    );
  }
}
