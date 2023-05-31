import "package:benchmark_app/screens/multi_benchmark_screen.dart";
import "package:benchmark_app/widgets/collection_button.dart";
import "package:flutter/material.dart";

class CollectionChoiceScreen extends StatelessWidget {
  const CollectionChoiceScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      color: const Color(0xFFCCCCCC),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(height: .175 * MediaQuery.of(context).size.height),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Choose a\ncollection type\nto benchmark:",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CollectionButton(
                    label: "List",
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MultiBenchmarkScreen(
                          collectionType: List,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CollectionButton(
                    label: "Set",
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MultiBenchmarkScreen(
                          collectionType: Set,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CollectionButton(
                    label: "Map",
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MultiBenchmarkScreen(
                          collectionType: Map,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
