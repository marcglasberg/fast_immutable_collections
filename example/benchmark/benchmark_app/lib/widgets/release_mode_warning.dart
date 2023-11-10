import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class ReleaseModeWarning extends StatelessWidget {
  const ReleaseModeWarning();

  static const String _checkMark = "\u{2713}";
  static const String _crossMark = "\u{2715}";

  @override
  Widget build(_) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      width: double.infinity,
      color: Colors.black,
      child: const Text(
        kReleaseMode
            ? "$_checkMark You're running under release mode."
            : "$_crossMark Please run this in release mode!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: kReleaseMode ? Colors.green : Colors.red,
          fontSize: 17,
        ),
      ),
    );
  }
}
