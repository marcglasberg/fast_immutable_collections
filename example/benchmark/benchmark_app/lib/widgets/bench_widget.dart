import "package:benchmark_app/screens/code_screen.dart";
import "package:benchmark_app/screens/graph_screen.dart";
import "package:benchmark_app/widgets/collection_button.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";
import "package:flutter/material.dart";

class BenchWidget extends StatefulWidget {
  final String title;
  final Map<String, String> code;

  // The benchmarks are given as a function just so they are recreated when we rerun them, instead
  // of data being appended to previous runs.
  final List<MultiBenchmarkReporter> Function() benchmarks;

  const BenchWidget({
    required this.title,
    required this.code,
    required this.benchmarks,
  });

  @override
  _BenchWidgetState createState() => _BenchWidgetState();
}

class _BenchWidgetState extends State<BenchWidget> {
  bool _isRunning = false;
  List<RecordsTable>? _results;

  Future<void> _goToResults() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GraphScreen(
            title: widget.title,
            tables: _results,
          ),
        ),
      );

  void _run() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isRunning = true);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(() {
          _results = <RecordsTable>[];
          widget.benchmarks().forEach((MultiBenchmarkReporter benchmark) {
            benchmark.report();
            // print(benchmark.emitter.table);
            _results!.add(benchmark.emitter.table);
          });
          _isRunning = false;
          _goToResults();
        }),
      );
    });
  }

  bool get _isNotRunningAndHasResults => !_isRunning && _results != null;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: <Widget>[
          _content,
          if (_isRunning) const _PleaseWait(),
        ],
      ),
    );
  }

  Container get _content {
    return Container(
      width: double.infinity,
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: CollectionButton(
                  label: "Run",
                  onPressed: _isRunning ? null : _run,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CollectionButton(
                  label: "Results",
                  onPressed: _isNotRunningAndHasResults ? _goToResults : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CollectionButton(
                  label: "Code",
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CodeScreen(
                        widget.title,
                        widget.code,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PleaseWait extends StatelessWidget {
  const _PleaseWait();

  @override
  Widget build(_) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: const Text(
        "Please Wait.\nRunning the benchmarks...",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 20,
          height: 1.4,
        ),
      ),
    );
  }
}
