import "package:flutter/material.dart";

Expanded button({String label, VoidCallback onPressed}) {
  return Expanded(
    child: RaisedButton(
      color: Colors.blue,
      disabledColor: Colors.blue.withOpacity(0.4),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 17),
      ),
    ),
  );
}