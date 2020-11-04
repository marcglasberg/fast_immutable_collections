import "package:flutter/material.dart";

import "../widgets/collection_button.dart";
import "multi_benchmark_screen.dart";

class CollectionChoiceScreen extends StatelessWidget {
  const CollectionChoiceScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFCCCCCC),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(height: .25 * MediaQuery.of(context).size.height),
          Text(
            "Choose a collection type to benchmark:",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CollectionButton(
                  label: "List",
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MultiBenchmarkScreen(collectionType: CollectionType.list)),
                  ),
                ),
                CollectionButton(
                  label: "Set",
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MultiBenchmarkScreen(collectionType: CollectionType.list)),
                  ),
                ),
                CollectionButton(
                  label: "Map",
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MultiBenchmarkScreen(collectionType: CollectionType.list)),
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
