import "package:flutter/material.dart";
import "package:flutter/foundation.dart";

import "../utils/benchmarks_code.dart";
import "../widgets/bench_widget.dart";

class MultiBenchmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFCCCCCC),
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BenchWidget(description: "Add", code: add_code, run: add_run),
                  BenchWidget(description: "AddAll", code: add_all_code, run: add_all_run),
                  BenchWidget(description: "Remove", code: {}, run: () {}),
                  BenchWidget(description: "RemoveAll", code: {}, run: () {}),
                  BenchWidget(description: "Get", code: {}, run: () {}),
                  BenchWidget(description: "Empty", code: {}, run: () {}),
                ],
              ),
            ),
          ),
          if (!kReleaseMode) _releaseModeWarning(),
        ],
      ),
    );
  }

  Container _releaseModeWarning() => Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        width: double.infinity,
        color: Colors.black,
        child: Text(
          "Please run this in release mode!",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      );
}

void add_run() => print("RUN add_code!");

void add_all_run() => print("RUN add_all_code!");
