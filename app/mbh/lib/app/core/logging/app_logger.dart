import 'package:get/get.dart';
import 'package:mbh/app/core/logging/console_log_sink.dart';
import 'package:mbh/app/core/logging/file_log_sink.dart';
import 'package:mbh/app/core/logging/log_level.dart';
import 'package:mbh/app/core/logging/log_sink.dart';

class AppLogger extends GetxService {
  final List<LogSink> _sinks = <LogSink>[];
  LogLevel _minLevel = LogLevel.debug;

  Future<AppLogger> init({
    bool enableConsole = true,
    bool enableFile = false,
    LogLevel minLevel = LogLevel.debug,
  }) async {
    _minLevel = minLevel;

    if (enableConsole) {
      _sinks.add(ConsoleLogSink());
    }

    if (enableFile) {
      final FileLogSink fileSink = FileLogSink();
      await fileSink.init();
      _sinks.add(fileSink);
    }

    return this;
  }

  void debug(String message, {String tag = 'APP'}) => _log(LogLevel.debug, tag, message);

  void info(String message, {String tag = 'APP'}) => _log(LogLevel.info, tag, message);

  void warn(String message, {String tag = 'APP'}) => _log(LogLevel.warn, tag, message);

  void error(
    String message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, tag, message, error: error, stackTrace: stackTrace);
  }

  void fatal(
    String message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.fatal, tag, message, error: error, stackTrace: stackTrace);
  }

  void _log(
    LogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minLevel.index) {
      return;
    }

    for (final LogSink sink in _sinks) {
      sink.write(level, tag, message, error: error, stackTrace: stackTrace);
    }
  }
}
