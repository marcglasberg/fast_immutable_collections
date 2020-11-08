import "package:flutter/material.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

import "../screens/code_screen.dart";
import "../screens/graph_screen.dart";
import "collection_button.dart";

class BenchWidget extends StatefulWidget {
  final String title;
  final IMap<String, String> code;
  final MultiBenchmarkReporter benchmark;

  BenchWidget({
    this.title,
    this.code,
    @required this.benchmark,
  });

  @override
  _BenchWidgetState createState() => _BenchWidgetState();
}

class _BenchWidgetState extends State<BenchWidget> {
  bool _isRunning;
  RecordsTable _results;

  @override
  void initState() {
    super.initState();
    _isRunning = false;
  }

  void _run() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isRunning = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          widget.benchmark.report();
          _results = widget.benchmark.emitter.table;
          _isRunning = false;
        });
      });
    });
  }

  bool get _isNotRunningAndHasResults => !_isRunning && _results != null;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          _content(context),
          if (_isRunning) _pleaseWait(),
        ],
      ),
    );
  }

  Container _content(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(
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
                  onPressed: _isNotRunningAndHasResults
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => GraphScreen(
                                    title: widget.title,
                                    recordsTable: _results,
                                  )))
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CollectionButton(
                  label: "Code",
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CodeScreen(widget.title, widget.code)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _pleaseWait() {
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
      child: Text(
        "Please Wait.\nCreating benchmarks...",
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
