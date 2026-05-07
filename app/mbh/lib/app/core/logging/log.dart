import 'package:get/get.dart';
import 'package:mbh/app/core/logging/app_logger.dart';

class Log {
  const Log._();

  static AppLogger get _logger => Get.find<AppLogger>();

  static void d(String tag, String message) {
    _logger.debug(message, tag: tag);
  }

  static void i(String tag, String message) {
    _logger.info(message, tag: tag);
  }

  static void w(String tag, String message) {
    _logger.warn(message, tag: tag);
  }

  static void e(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.error(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void f(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.fatal(message, tag: tag, error: error, stackTrace: stackTrace);
  }
}
