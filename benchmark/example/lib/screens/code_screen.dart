import "dart:io";

import "package:flutter/material.dart";

import "../widgets/button.dart";

class CodeScreen extends StatelessWidget {
  final String description;
  final Map<String, String> code;

  CodeScreen(this.description, this.code);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
        title: Text(
          "Code: $description",
          style: TextStyle(color: Colors.white, height: 1.3),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (MapEntry<String, String> entry in code.entries) _code(entry.key, entry.value)
                ],
              ),
            ),
          ),
          Container(width: double.infinity, height: 1.0, color: Colors.black),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                button(label: "OK", onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _code(String title, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 8.0, bottom: 20),
          child: Text(
            code,
            style: TextStyle(
              fontFamily: Platform.isIOS ? "Courier" : "monospace",
              fontSize: 15,
              height: 1.2,
            ),
          ),
        ),
        Container(width: double.infinity, height: 1.0, color: Colors.grey),
      ],
    );
  }
}

