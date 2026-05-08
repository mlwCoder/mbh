import 'dart:developer' as developer;
import 'dart:io';

import 'package:mbh/app/core/logging/log_formatter.dart';
import 'package:mbh/app/core/logging/log_level.dart';
import 'package:mbh/app/core/logging/log_sink.dart';

class ConsoleLogSink implements LogSink {
  static const String _ansiReset = '\u001b[0m';

  bool get _supportsAnsi => stdout.supportsAnsiEscapes;

  @override
  void write(
    LogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final String timestamp = LogFormatter.formatTimestamp(DateTime.now());
    final String prefix = _supportsAnsi
        ? '${level.ansiColor}[${level.label}]$_ansiReset'
        : '[${level.label}]';

    developer.log(
      '$prefix [$tag] $timestamp $message',
      name: 'MBH',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
