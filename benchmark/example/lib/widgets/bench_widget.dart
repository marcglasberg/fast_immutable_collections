import "package:flutter/material.dart";

import "../screens/code_screen.dart";
import "button.dart";

class BenchWidget extends StatefulWidget {
  final String description;
  final Map<String, String> code;
  final VoidCallback run;

  BenchWidget({
    this.description,
    this.code,
    this.run,
  });

  @override
  _BenchWidgetState createState() => _BenchWidgetState();
}

class _BenchWidgetState extends State<BenchWidget> {
  bool hasResults;

  @override
  void initState() {
    super.initState();
    hasResults = false;
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
            SizedBox(height: 12),
            Row(
              children: <Widget>[
                expandedCollectionButton(
                  label: "Run",
                  onPressed: widget.run,
                ),
                SizedBox(width: 12),
                expandedCollectionButton(
                  label: "Results",
                  onPressed: hasResults ? () => print("View results!") : null,
                ),
                SizedBox(width: 12),
                expandedCollectionButton(
                    label: "Code",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return CodeScreen(widget.description, widget.code);
                        }),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}