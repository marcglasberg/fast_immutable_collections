import "dart:io";

import "package:benchmark_app/widgets/collection_button.dart";
import "package:flutter/material.dart";

class CodeScreen extends StatelessWidget {
  final String description;
  final Map<String, String> code;

  const CodeScreen(this.description, this.code);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
        title: Text(
          "Code: $description",
          style: const TextStyle(color: Colors.white, height: 1.3),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (final MapEntry<String, String> codeEntry in code.entries)
                    _CodeBlock(title: codeEntry.key, code: codeEntry.value)
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CollectionButton(
                    label: "OK",
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String title;
  final String code;

  const _CodeBlock({
    required this.title,
    required this.code,
  });

  @override
  Widget build(_) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 8.0,
            bottom: 20,
          ),
          child: Text(
            code,
            style: TextStyle(
              fontFamily: Platform.isIOS ? "Courier" : "monospace",
              fontSize: 15,
              height: 1.2,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey,
        ),
      ],
    );
  }
}
