import 'dart:io' show Directory, File;

import 'package:path/path.dart' as p show current, join;

class Logger {
  final String _reportName;
  final Map<String, Object> _loggedObjects = {};

  Logger({String reportName = ''}) : _reportName = reportName;

  void emit(String testName, Object object) =>
      _loggedObjects[testName] = object;

  String get _completeLog {
    String completeLog = '';
    _loggedObjects.forEach((String testName, Object object) =>
        completeLog += '$testName\n\n' '${object.toString()}\n\n');
    return completeLog;
  }

  void saveLog() {
    _createLogsFolderIfNonExistent();

    final File logFile = File('benchmark/logs/$_reportName.log');

    logFile.writeAsStringSync(_completeLog);
  }

  void _createLogsFolderIfNonExistent() {
    final Directory logsDir = Directory(p.join(p.current, 'benchmark', 'logs'));
    if (!logsDir.existsSync()) logsDir.createSync();
  }
}
