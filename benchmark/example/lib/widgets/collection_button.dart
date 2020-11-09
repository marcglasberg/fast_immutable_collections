import "package:flutter/material.dart";

class CollectionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CollectionButton({
    @required this.label,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blue,
      disabledColor: Colors.blue.withOpacity(0.4),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 17),
      ),
    );
  }
}
