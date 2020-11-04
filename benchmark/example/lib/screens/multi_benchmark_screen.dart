import "package:flutter/material.dart";
import "package:flutter/foundation.dart";

import "../utils/benchmarks_code.dart";
import "../widgets/bench_widget.dart";

enum CollectionType { list, set, map }

class MultiBenchmarkScreen extends StatelessWidget {
  final CollectionType collectionType;

  const MultiBenchmarkScreen({
    Key key,
    @required this.collectionType,
  }) : super(key: key);

  List<Widget> get _benchmarks {
    switch (collectionType) {
      case CollectionType.list:
        return <Widget>[
          BenchWidget(description: "Add", code: add_code, run: add_run),
          BenchWidget(description: "AddAll", code: add_all_code, run: add_all_run),
          BenchWidget(description: "Remove", code: {}, run: () {}),
          BenchWidget(description: "RemoveAll", code: {}, run: () {}),
          BenchWidget(description: "Get", code: {}, run: () {}),
          BenchWidget(description: "Empty", code: {}, run: () {}),
        ];
      case CollectionType.set:
        return <Widget>[];
      case CollectionType.map:
        return <Widget>[];
      default:
        throw UnimplementedError("No benchmarks for this collection type you've somehow chosen.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFCCCCCC),
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _benchmarks,
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
        child: const Text(
          "Please run this in release mode!",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      );
}

void add_run() => print("RUN add_code!");

void add_all_run() => print("RUN add_all_code!");
