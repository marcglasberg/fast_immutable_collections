import "package:flutter/material.dart";

Expanded expandedCollectionButton({String label, VoidCallback onPressed}) {
  return Expanded(
    child: CollectionButton(label: label, onPressed: onPressed),
  );
}

class CollectionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CollectionButton({
    Key key,
    @required this.label,
    @required this.onPressed,
  }) : super(key: key);

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
