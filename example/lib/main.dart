import "package:flutter/material.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: "FIC Example",
      home: MyHomePage(),
      theme: ThemeData(
        textTheme: TextTheme(bodyText2: TextStyle(fontSize: 21)),
      ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  IList<Widget> items;

  @override
  void initState() {
    super.initState();
    items = [text()].lock;
  }

  Widget text() => Text("You have pushed the button $counter times.");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FIC Example")),
      body: ListView(
        children: items.unlockView,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            counter++;
            items = items.add(text());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
