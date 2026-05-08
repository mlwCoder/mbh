import 'dart:io';

import 'package:mbh/app/core/logging/log_formatter.dart';
import 'package:mbh/app/core/logging/log_level.dart';
import 'package:mbh/app/core/logging/log_sink.dart';
import 'package:path_provider/path_provider.dart';

class FileLogSink implements LogSink {
  File? _logFile;

  Future<void> init() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String today = DateTime.now().toIso8601String().split('T').first;
    _logFile = File('${dir.path}/logs/mbh_$today.log');
    if (!_logFile!.parent.existsSync()) {
      _logFile!.parent.createSync(recursive: true);
    }
  }

  @override
  void write(
    LogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_logFile == null) {
      return;
    }

    final String timestamp = LogFormatter.formatTimestamp(DateTime.now());
    final StringBuffer buffer = StringBuffer()
      ..writeln('[${level.label}] [$tag] $timestamp $message');

    if (error != null) {
      buffer.writeln('  Error: $error');
    }
    if (stackTrace != null) {
      buffer.writeln('  StackTrace: $stackTrace');
    }

    _logFile!.writeAsStringSync(buffer.toString(), mode: FileMode.append);
  }
}
