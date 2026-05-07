import 'dart:developer' as developer;

import 'package:mbh/app/core/logging/log_level.dart';
import 'package:mbh/app/core/logging/log_sink.dart';

class ConsoleLogSink implements LogSink {
  static const String _ansiReset = '\u001b[0m';

  @override
  void write(
    LogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final String timestamp = DateTime.now().toIso8601String();
    final String prefix = '${level.ansiColor}[${level.label}]$_ansiReset';
    developer.log(
      '$prefix [$tag] $timestamp $message',
      name: 'MBH',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
