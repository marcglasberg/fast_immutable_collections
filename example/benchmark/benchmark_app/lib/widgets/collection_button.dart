import "package:flutter/material.dart";

class CollectionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CollectionButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(_) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 17),
      ),
    );
  }
}
