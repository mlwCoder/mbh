import 'package:mbh/app/core/logging/log_level.dart';

abstract class LogSink {
  void write(
    LogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}
