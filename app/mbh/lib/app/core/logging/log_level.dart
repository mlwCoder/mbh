enum LogLevel {
  debug,
  info,
  warn,
  error,
  fatal,
}

extension LogLevelX on LogLevel {
  String get label => name.toUpperCase().padRight(5);

  String get ansiColor => switch (this) {
        LogLevel.debug => '\u001b[36m',
        LogLevel.info => '\u001b[32m',
        LogLevel.warn => '\u001b[33m',
        LogLevel.error => '\u001b[31m',
        LogLevel.fatal => '\u001b[35m',
      };
}
