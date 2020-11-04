import "package:flutter/material.dart";

import "package:fast_immutable_collections_benchmarks/fast_immutable_collections_benchmarks.dart";

import "../screens/code_screen.dart";
import "collection_button.dart";

class BenchWidget extends StatefulWidget {
  final String description;
  final Map<String, String> code;
  final RecordsTable Function() run;

  BenchWidget({
    this.description,
    this.code,
    this.run,
  });

  @override
  _BenchWidgetState createState() => _BenchWidgetState();
}

class _BenchWidgetState extends State<BenchWidget> {
  bool isRunning;
  RecordsTable results;

  @override
  void initState() {
    super.initState();
    isRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.description,
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
                    onPressed: () {
                      setState(() => isRunning = true);
                      results = widget.run();
                      print(results);
                      setState(() => isRunning = false);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CollectionButton(
                    label: "Results",
                    onPressed: !isRunning ? () => print("View results!") : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CollectionButton(
                      label: "Code",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) {
                            return CodeScreen(widget.description, widget.code);
                          }),
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
